Return-Path: <netdev+bounces-10334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3B172DEEC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC8C5280E58
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D7A31EF9;
	Tue, 13 Jun 2023 10:14:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901D2A9D2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:14:44 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E288188
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686651282; x=1718187282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YSGJlQLGqbBQd3+m/IxIyYWQiZWagfT1Rkll5mc3ugo=;
  b=kBQ8t35zYrF5mN2PEXLcKaAgpuUoEHTiL9Z+xqho1f3Y0IaKqTNeDdpj
   TqaH1RpC6JUQcDYul+dRbtcWbAP1kGJsJJMMacXlEv+tb6L5oVjowXz8h
   DMMZEnwK3Na15EIpBpXn/OAJ3tbTEZd6kqgUO5UBgQtGJ/9IkY9PV0WTf
   n/zsatAfQ6yuLh+9k6Yjm+sRSDPO5MD71HU0lLuXxxtti8HgfPTndW8kk
   2Mk6aCb3IJOKa4OuEeRSaP8E3IMrYP7WTwF+PrdmDUohIvGvSgJAaQhC5
   JOHDV86OZdoQcgTcI5JKJE8iGmIAsLomebq+2WcPIsrbZWagT7edBpai/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424168047"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="424168047"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:14:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885787117"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="885787117"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2023 03:14:39 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id D8E7135429;
	Tue, 13 Jun 2023 11:14:37 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de,
	simon.horman@corigine.com,
	dan.carpenter@linaro.org
Subject: [PATCH iwl-next v5 01/12] ice: Skip adv rules removal upon switchdev release
Date: Tue, 13 Jun 2023 12:13:19 +0200
Message-Id: <20230613101330.87734-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613101330.87734-1-wojciech.drewek@intel.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
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

Advanced rules for ctrl VSI will be removed anyway when the
VSI will cleaned up, no need to do it explicitly.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v5: remove ice_rem_adv_rule_for_vsi since it is unused
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
 drivers/net/ethernet/intel/ice/ice_switch.c  | 53 --------------------
 drivers/net/ethernet/intel/ice/ice_switch.h  |  1 -
 3 files changed, 55 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index ad0a007b7398..be5b22691f7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -503,7 +503,6 @@ static void ice_eswitch_disable_switchdev(struct ice_pf *pf)
 
 	ice_eswitch_napi_disable(pf);
 	ice_eswitch_release_env(pf);
-	ice_rem_adv_rule_for_vsi(&pf->hw, ctrl_vsi->idx);
 	ice_eswitch_release_reprs(pf, ctrl_vsi);
 	ice_vsi_release(ctrl_vsi);
 	ice_repr_rem_from_all_vfs(pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 2ea9e1ae5517..92e16e9720ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -6539,59 +6539,6 @@ ice_rem_adv_rule_by_id(struct ice_hw *hw,
 	return -ENOENT;
 }
 
-/**
- * ice_rem_adv_rule_for_vsi - removes existing advanced switch rules for a
- *                            given VSI handle
- * @hw: pointer to the hardware structure
- * @vsi_handle: VSI handle for which we are supposed to remove all the rules.
- *
- * This function is used to remove all the rules for a given VSI and as soon
- * as removing a rule fails, it will return immediately with the error code,
- * else it will return success.
- */
-int ice_rem_adv_rule_for_vsi(struct ice_hw *hw, u16 vsi_handle)
-{
-	struct ice_adv_fltr_mgmt_list_entry *list_itr, *tmp_entry;
-	struct ice_vsi_list_map_info *map_info;
-	struct ice_adv_rule_info rinfo;
-	struct list_head *list_head;
-	struct ice_switch_info *sw;
-	int status;
-	u8 rid;
-
-	sw = hw->switch_info;
-	for (rid = 0; rid < ICE_MAX_NUM_RECIPES; rid++) {
-		if (!sw->recp_list[rid].recp_created)
-			continue;
-		if (!sw->recp_list[rid].adv_rule)
-			continue;
-
-		list_head = &sw->recp_list[rid].filt_rules;
-		list_for_each_entry_safe(list_itr, tmp_entry, list_head,
-					 list_entry) {
-			rinfo = list_itr->rule_info;
-
-			if (rinfo.sw_act.fltr_act == ICE_FWD_TO_VSI_LIST) {
-				map_info = list_itr->vsi_list_info;
-				if (!map_info)
-					continue;
-
-				if (!test_bit(vsi_handle, map_info->vsi_map))
-					continue;
-			} else if (rinfo.sw_act.vsi_handle != vsi_handle) {
-				continue;
-			}
-
-			rinfo.sw_act.vsi_handle = vsi_handle;
-			status = ice_rem_adv_rule(hw, list_itr->lkups,
-						  list_itr->lkups_cnt, &rinfo);
-			if (status)
-				return status;
-		}
-	}
-	return 0;
-}
-
 /**
  * ice_replay_vsi_adv_rule - Replay advanced rule for requested VSI
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index c84b56fe84a5..db08509805ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -379,7 +379,6 @@ int
 ice_set_vlan_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			 bool rm_vlan_promisc);
 
-int ice_rem_adv_rule_for_vsi(struct ice_hw *hw, u16 vsi_handle);
 int
 ice_rem_adv_rule_by_id(struct ice_hw *hw,
 		       struct ice_rule_query_data *remove_entry);
-- 
2.40.1


