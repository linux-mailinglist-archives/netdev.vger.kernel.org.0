Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24811F2A26
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgFHXT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbgFHXT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12C120823;
        Mon,  8 Jun 2020 23:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658396;
        bh=QdiF7mgvWlf2SQq24qBVEy93LHtjIwVli09p1uRnJk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIWFBvFrdrYIWOPlZX3QZnTdIEunaUDJB4S4fmnQiK8beljRbUsjbZ/6agpBlYsDI
         lqFSOhEx8age8VoUIrDO0DTStyqNFN2MAAz9bcfqyDf4HdX7FQqrq+ldFQKmtF1IzB
         w8KfJRWK3vtvfRcxZ4iBrb+xZZ2B4K9RDdSk9T9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Surabhi Boob <surabhi.boob@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 053/175] ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS
Date:   Mon,  8 Jun 2020 19:16:46 -0400
Message-Id: <20200608231848.3366970-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

[ Upstream commit 68d270783742783f96e89ef92ac24ab3c7fb1d31 ]

Handle memory leaks during control queue initialization and
buffer allocation failures. The macro ICE_FREE_CQ_BUFS is modified to
re-use for this fix.

Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index c68709c7ef81..2e9c97bad3c3 100644
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
2.25.1

