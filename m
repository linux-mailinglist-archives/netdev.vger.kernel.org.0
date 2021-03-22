Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717773450D9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhCVUcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:5504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhCVUbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:22 -0400
IronPort-SDR: HJMqs5oMm2ydK0r1p5zT1VOEUfcTJGu76AcOcydOu2aFlryO/muFhfUJZLlfmKXK5TILQj7wb6
 K4XFUyqMfNeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438218"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438218"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: /wOdUUAq59TvbK1uEiDvnxc/PkHLq4EvBXO4KlOo7GHiK8P4cD4dw87TJiKbjJwZx2FXNmdqW2
 +kESrUVdNH1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810605"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, Yahui Cao <yahui.cao@intel.com>,
        Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 09/18] ice: Add new actions support for VF FDIR
Date:   Mon, 22 Mar 2021 13:32:35 -0700
Message-Id: <20210322203244.2525310-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

Add two new actions support for VF FDIR:

A passthrough action does not specify the destination queue, but
just allow the packet go to next pipeline stage, a typical use
cases is combined with a software mark (FDID) action.

Allow specify a 2^n continuous queues as the destination of a FDIR rule.
Packet distribution is based on current RSS configure.

Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fdir.c          | 12 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |  4 ++++
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 10 ++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 8f3e61c6bfd6..5f8d7a9ca068 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -374,7 +374,14 @@ ice_fdir_get_prgm_desc(struct ice_hw *hw, struct ice_fdir_fltr *input,
 	if (input->dest_ctl == ICE_FLTR_PRGM_DESC_DEST_DROP_PKT) {
 		fdir_fltr_ctx.drop = ICE_FXD_FLTR_QW0_DROP_YES;
 		fdir_fltr_ctx.qindex = 0;
+	} else if (input->dest_ctl ==
+		   ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_OTHER) {
+		fdir_fltr_ctx.drop = ICE_FXD_FLTR_QW0_DROP_NO;
+		fdir_fltr_ctx.qindex = 0;
 	} else {
+		if (input->dest_ctl ==
+		    ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QGROUP)
+			fdir_fltr_ctx.toq = input->q_region;
 		fdir_fltr_ctx.drop = ICE_FXD_FLTR_QW0_DROP_NO;
 		fdir_fltr_ctx.qindex = input->q_index;
 	}
@@ -382,7 +389,10 @@ ice_fdir_get_prgm_desc(struct ice_hw *hw, struct ice_fdir_fltr *input,
 	fdir_fltr_ctx.cnt_index = input->cnt_index;
 	fdir_fltr_ctx.fd_vsi = ice_get_hw_vsi_num(hw, input->dest_vsi);
 	fdir_fltr_ctx.evict_ena = ICE_FXD_FLTR_QW0_EVICT_ENA_FALSE;
-	fdir_fltr_ctx.toq_prio = 3;
+	if (input->dest_ctl == ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_OTHER)
+		fdir_fltr_ctx.toq_prio = 0;
+	else
+		fdir_fltr_ctx.toq_prio = 3;
 	fdir_fltr_ctx.pcmd = add ? ICE_FXD_FLTR_QW1_PCMD_ADD :
 		ICE_FXD_FLTR_QW1_PCMD_REMOVE;
 	fdir_fltr_ctx.swap = ICE_FXD_FLTR_QW1_SWAP_NOT_SET;
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 93f3f0d9d37b..adf237925b3c 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -42,6 +42,8 @@
 enum ice_fltr_prgm_desc_dest {
 	ICE_FLTR_PRGM_DESC_DEST_DROP_PKT,
 	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX,
+	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QGROUP,
+	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_OTHER,
 };
 
 enum ice_fltr_prgm_desc_fd_status {
@@ -133,6 +135,8 @@ struct ice_fdir_fltr {
 
 	/* flex byte filter data */
 	__be16 flex_word;
+	/* queue region size (=2^q_region) */
+	u8 q_region;
 	u16 flex_offset;
 	u16 flex_fltr;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 6c7a9d89be67..a1b6d3771e2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -897,6 +897,10 @@ ice_vc_fdir_parse_action(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 		struct virtchnl_filter_action *action = &as->actions[i];
 
 		switch (action->type) {
+		case VIRTCHNL_ACTION_PASSTHRU:
+			dest_num++;
+			input->dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_OTHER;
+			break;
 		case VIRTCHNL_ACTION_DROP:
 			dest_num++;
 			input->dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DROP_PKT;
@@ -906,6 +910,12 @@ ice_vc_fdir_parse_action(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 			input->dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX;
 			input->q_index = action->act_conf.queue.index;
 			break;
+		case VIRTCHNL_ACTION_Q_REGION:
+			dest_num++;
+			input->dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QGROUP;
+			input->q_index = action->act_conf.queue.index;
+			input->q_region = action->act_conf.queue.region;
+			break;
 		case VIRTCHNL_ACTION_MARK:
 			mark_num++;
 			input->fltr_id = action->act_conf.mark_id;
-- 
2.26.2

