Return-Path: <netdev+bounces-9715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF1072A52A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57ED828163E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5328721090;
	Fri,  9 Jun 2023 21:14:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B4F408CE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:14:50 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54BD35A3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686345288; x=1717881288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ydiNCRNu3aFV0z45HjdsD+wQxvDLwLZFu5fep1Ssc8c=;
  b=efcQwvQRH+RmLkv/RV9jgefhiz5ppStoGjWHAiwjZz4eZAell25F3zFL
   5VAqls2giyLIvNzAgCziamhrMCfk19fJG9N8CQh40aF8V6jHARphvV9OG
   vSmZRHl7gvjToNZJF7/VArj6q3UeE7nFQtcZ2M5461mDfzWbx17+zsjDb
   RqFr6bmNU2Unl1oI6iSqzGXv+Ilqsr9k1Uicte8BLG5+eWHLNOkf0lPP7
   RoWFKQGiz/K0m8rdrueYSk0Uvhn6N6d1e8AxKy3pSRVWXOYICZvWw9QUO
   Be+LlB3W9VNQzapcACl27yACU9s1bfgb7lNa0+oOmHmJ4mFADxZgf2X+e
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356583165"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="356583165"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 14:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="823194628"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="823194628"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 14:14:47 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: daniel.machon@microchip.com,
	simon.horman@corigine.com,
	netdev@vger.kernel.org,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iwl-next v4 01/10] ice: Correctly initialize queue context values
Date: Fri,  9 Jun 2023 14:16:17 -0700
Message-Id: <20230609211626.621968-2-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609211626.621968-1-david.m.ertman@intel.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_alloc_lan_q_ctx function allocates the queue context array for a
given traffic class. This function uses devm_kcalloc which will
zero-allocate the structure. Thus, prior to any queue being setup by
ice_ena_vsi_txq, the q_ctx structure will have a q_handle of 0 and a q_teid
of 0. These are potentially valid values.

Modify the ice_alloc_lan_q_ctx function to initialize every member of the
q_ctx array to have invalid values. Modify ice_dis_vsi_txq to ensure that
it assigns q_teid to an invalid value when it assigns q_handle to the
invalid value as well.

This will allow other code to check whether the queue context is currently
valid before operating on it.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  1 +
 drivers/net/ethernet/intel/ice/ice_sched.c  | 23 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index deb55b6d516a..09e2e38d538e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4673,6 +4673,7 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 			break;
 		ice_free_sched_node(pi, node);
 		q_ctx->q_handle = ICE_INVAL_Q_HANDLE;
+		q_ctx->q_teid = ICE_INVAL_TEID;
 	}
 	mutex_unlock(&pi->sched_lock);
 	kfree(qg_list);
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index b664d60fd037..79a8972873f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -569,18 +569,24 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
 {
 	struct ice_vsi_ctx *vsi_ctx;
 	struct ice_q_ctx *q_ctx;
+	u16 idx;
 
 	vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
 	if (!vsi_ctx)
 		return -EINVAL;
 	/* allocate LAN queue contexts */
 	if (!vsi_ctx->lan_q_ctx[tc]) {
-		vsi_ctx->lan_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
-						      new_numqs,
-						      sizeof(*q_ctx),
-						      GFP_KERNEL);
-		if (!vsi_ctx->lan_q_ctx[tc])
+		q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
+				     sizeof(*q_ctx), GFP_KERNEL);
+		if (!q_ctx)
 			return -ENOMEM;
+
+		for (idx = 0; idx < new_numqs; idx++) {
+			q_ctx[idx].q_handle = ICE_INVAL_Q_HANDLE;
+			q_ctx[idx].q_teid = ICE_INVAL_TEID;
+		}
+
+		vsi_ctx->lan_q_ctx[tc] = q_ctx;
 		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
 		return 0;
 	}
@@ -592,9 +598,16 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
 				     sizeof(*q_ctx), GFP_KERNEL);
 		if (!q_ctx)
 			return -ENOMEM;
+
 		memcpy(q_ctx, vsi_ctx->lan_q_ctx[tc],
 		       prev_num * sizeof(*q_ctx));
 		devm_kfree(ice_hw_to_dev(hw), vsi_ctx->lan_q_ctx[tc]);
+
+		for (idx = prev_num; idx < new_numqs; idx++) {
+			q_ctx[idx].q_handle = ICE_INVAL_Q_HANDLE;
+			q_ctx[idx].q_teid = ICE_INVAL_TEID;
+		}
+
 		vsi_ctx->lan_q_ctx[tc] = q_ctx;
 		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
 	}
-- 
2.40.1


