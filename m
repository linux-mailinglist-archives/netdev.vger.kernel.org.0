Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADF91E588F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgE1H0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:26:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgE1HZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:43 -0400
IronPort-SDR: H0SDbIBveDA0bjSW4egTnSqJjwjkG/b1mj+dI2Bm8MQ244nd8ODdSIcp3fWNEyRk6PHdiOW443
 C9QdilDK6FhQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:42 -0700
IronPort-SDR: rDQuV0S8KmpbjhV4KzDOEgsrIUs2sf6Nsf3cSEG2uwqI4SnLtV8XC5a4fk6RMKLEcjuCoDPG0a
 jifCcK5RFT2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831119"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Surabhi Boob <surabhi.boob@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS
Date:   Thu, 28 May 2020 00:25:29 -0700
Message-Id: <20200528072538.1621790-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

Handle memory leaks during control queue initialization and
buffer allocation failures. The macro ICE_FREE_CQ_BUFS is modified to
re-use for this fix.

Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 9a865962296d..62c2c1e621d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -199,7 +199,9 @@ ice_alloc_rq_bufs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 		cq->rq.r.rq_bi[i].pa = 0;
 		cq->rq.r.rq_bi[i].size = 0;
 	}
+	cq->rq.r.rq_bi = NULL;
 	devm_kfree(ice_hw_to_dev(hw), cq->rq.dma_head);
+	cq->rq.dma_head = NULL;
 
 	return ICE_ERR_NO_MEMORY;
 }
@@ -245,7 +247,9 @@ ice_alloc_sq_bufs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 		cq->sq.r.sq_bi[i].pa = 0;
 		cq->sq.r.sq_bi[i].size = 0;
 	}
+	cq->sq.r.sq_bi = NULL;
 	devm_kfree(ice_hw_to_dev(hw), cq->sq.dma_head);
+	cq->sq.dma_head = NULL;
 
 	return ICE_ERR_NO_MEMORY;
 }
@@ -304,6 +308,28 @@ ice_cfg_rq_regs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	return 0;
 }
 
+#define ICE_FREE_CQ_BUFS(hw, qi, ring)					\
+do {									\
+	int i;								\
+	/* free descriptors */						\
+	if ((qi)->ring.r.ring##_bi)					\
+		for (i = 0; i < (qi)->num_##ring##_entries; i++)	\
+			if ((qi)->ring.r.ring##_bi[i].pa) {		\
+				dmam_free_coherent(ice_hw_to_dev(hw),	\
+					(qi)->ring.r.ring##_bi[i].size,	\
+					(qi)->ring.r.ring##_bi[i].va,	\
+					(qi)->ring.r.ring##_bi[i].pa);	\
+					(qi)->ring.r.ring##_bi[i].va = NULL;\
+					(qi)->ring.r.ring##_bi[i].pa = 0;\
+					(qi)->ring.r.ring##_bi[i].size = 0;\
+		}							\
+	/* free the buffer info list */					\
+	if ((qi)->ring.cmd_buf)						\
+		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
+	/* free DMA head */						\
+	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
+} while (0)
+
 /**
  * ice_init_sq - main initialization routine for Control ATQ
  * @hw: pointer to the hardware structure
@@ -357,6 +383,7 @@ static enum ice_status ice_init_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	goto init_ctrlq_exit;
 
 init_ctrlq_free_rings:
+	ICE_FREE_CQ_BUFS(hw, cq, sq);
 	ice_free_cq_ring(hw, &cq->sq);
 
 init_ctrlq_exit:
@@ -416,33 +443,13 @@ static enum ice_status ice_init_rq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	goto init_ctrlq_exit;
 
 init_ctrlq_free_rings:
+	ICE_FREE_CQ_BUFS(hw, cq, rq);
 	ice_free_cq_ring(hw, &cq->rq);
 
 init_ctrlq_exit:
 	return ret_code;
 }
 
-#define ICE_FREE_CQ_BUFS(hw, qi, ring)					\
-do {									\
-	int i;								\
-	/* free descriptors */						\
-	for (i = 0; i < (qi)->num_##ring##_entries; i++)		\
-		if ((qi)->ring.r.ring##_bi[i].pa) {			\
-			dmam_free_coherent(ice_hw_to_dev(hw),		\
-					   (qi)->ring.r.ring##_bi[i].size,\
-					   (qi)->ring.r.ring##_bi[i].va,\
-					   (qi)->ring.r.ring##_bi[i].pa);\
-			(qi)->ring.r.ring##_bi[i].va = NULL;		\
-			(qi)->ring.r.ring##_bi[i].pa = 0;		\
-			(qi)->ring.r.ring##_bi[i].size = 0;		\
-		}							\
-	/* free the buffer info list */					\
-	if ((qi)->ring.cmd_buf)						\
-		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
-	/* free DMA head */						\
-	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
-} while (0)
-
 /**
  * ice_shutdown_sq - shutdown the Control ATQ
  * @hw: pointer to the hardware structure
-- 
2.26.2

