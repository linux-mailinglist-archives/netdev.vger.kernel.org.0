Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348D035FEE6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhDOA3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:27428 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhDOA24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:56 -0400
IronPort-SDR: ma06Uc3/Ts6fNVcTtR0OxSqE3zToik+niK5FOdbiERKhP20EST2xZ1aaKn737UmSZ/nKP4zv5B
 JQQQwxYMIMsw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262252"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262252"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: mrBfxOWU31vOiNV2bXiRe4Tn8uzVZLv42JSaD2ePCJq1QKem94G5b6CuX7Nq0VCJgPqs618oU0
 Bpf71RLRjB1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379531"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 11/15] ice: remove unused struct member
Date:   Wed, 14 Apr 2021 17:30:09 -0700
Message-Id: <20210415003013.19717-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The only time you can ever have a rq_last_status is if
a firmware event was somehow reporting a status on the receive
queue, which are generally firmware initiated events or
mailbox messages from a VF.  Mostly this struct member was unused.

Fix this problem by still printing the value of the field in a debug
print, but don't store the value forever in a struct, potentially
creating opportunities for callers to use the wrong struct member.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 6 +++---
 drivers/net/ethernet/intel/ice/ice_controlq.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 0f207a42ea77..87b33bdd4960 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -1097,6 +1097,7 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		  struct ice_rq_event_info *e, u16 *pending)
 {
 	u16 ntc = cq->rq.next_to_clean;
+	enum ice_aq_err rq_last_status;
 	enum ice_status ret_code = 0;
 	struct ice_aq_desc *desc;
 	struct ice_dma_mem *bi;
@@ -1130,13 +1131,12 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	desc = ICE_CTL_Q_DESC(cq->rq, ntc);
 	desc_idx = ntc;
 
-	cq->rq_last_status = (enum ice_aq_err)le16_to_cpu(desc->retval);
+	rq_last_status = (enum ice_aq_err)le16_to_cpu(desc->retval);
 	flags = le16_to_cpu(desc->flags);
 	if (flags & ICE_AQ_FLAG_ERR) {
 		ret_code = ICE_ERR_AQ_ERROR;
 		ice_debug(hw, ICE_DBG_AQ_MSG, "Control Receive Queue Event 0x%04X received with error 0x%X\n",
-			  le16_to_cpu(desc->opcode),
-			  cq->rq_last_status);
+			  le16_to_cpu(desc->opcode), rq_last_status);
 	}
 	memcpy(&e->desc, desc, sizeof(e->desc));
 	datalen = le16_to_cpu(desc->datalen);
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index 77c2307d4fb8..fe75871e48ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -83,7 +83,6 @@ struct ice_rq_event_info {
 /* Control Queue information */
 struct ice_ctl_q_info {
 	enum ice_ctl_q qtype;
-	enum ice_aq_err rq_last_status;	/* last status on receive queue */
 	struct ice_ctl_q_ring rq;	/* receive queue */
 	struct ice_ctl_q_ring sq;	/* send queue */
 	u32 sq_cmd_timeout;		/* send queue cmd write back timeout */
-- 
2.26.2

