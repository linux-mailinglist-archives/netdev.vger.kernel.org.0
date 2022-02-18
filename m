Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670BD4BC25F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbiBRV4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiBRV4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0753B64
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221354; x=1676757354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lF8lNKwr46Rxpgxjlh/EOGjEsQ1xBOPkHItCiJLh9kQ=;
  b=CE8TcyLuzvDc0czzaHG6G95YfBKSOOqwrU2vUnVsUdkON7JF9w+uo6fz
   amX8PoUAtOYOInMtaIHCauwfre5NZj0H0kByb9sCagP4HPntAuo9Foogg
   ZBLSTxfyw4p7c097RjFul5TmIJ4yfTBhEfUlQzbVHhPVjhWVYQX1SFiK1
   ari64o/aWvg/FN+HEmUhdXqpsHD+Rk9PsBDWqQA0SyKKUtPLBqX5MH1Le
   dhRppzj5qtaU3gbGbNxEd6XluFrghiThBvVUvNZHuIWDXoh8yp7OCAaZ8
   tA4xJVtWO8iABVgrOOQik5GTNV/Ek0nYU6/ZcLJTqwsFrzCZp8HC0oT2V
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179160"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179160"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757366"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 1/5] ice: Match on all profiles in slow-path
Date:   Fri, 18 Feb 2022 13:55:50 -0800
Message-Id: <20220218215554.415323-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
References: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

In switchdev mode, slow-path rules need to match all protocols, in order
to correctly redirect unfiltered or missed packets to the uplink. To set
this up for the virtual function to uplink flow, the rule that redirects
packets to the control VSI must have the tunnel type set to
ICE_SW_TUN_AND_NON_TUN. As a result of that new tunnel type being set,
ice_get_compat_fv_bitmap will select ICE_PROF_ALL. At that point all
profiles would be selected for this rule, resulting in the desired
behavior. Without this change slow-path would not work with
tunnel protocols.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c       | 1 +
 drivers/net/ethernet/intel/ice/ice_protocol_type.h | 1 +
 drivers/net/ethernet/intel/ice/ice_switch.c        | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 864692b157b6..73edc24d81d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -44,6 +44,7 @@ ice_eswitch_add_vf_mac_rule(struct ice_pf *pf, struct ice_vf *vf, const u8 *mac)
 				       ctrl_vsi->rxq_map[vf->vf_id];
 	rule_info.flags_info.act |= ICE_SINGLE_ACT_LB_ENABLE;
 	rule_info.flags_info.act_valid = true;
+	rule_info.tun_type = ICE_SW_TUN_AND_NON_TUN;
 
 	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info,
 			       vf->repr->mac_rule);
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index dc1b0e9e6df5..695b6dd61dc2 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -47,6 +47,7 @@ enum ice_protocol_type {
 
 enum ice_sw_tunnel_type {
 	ICE_NON_TUN = 0,
+	ICE_SW_TUN_AND_NON_TUN,
 	ICE_SW_TUN_VXLAN,
 	ICE_SW_TUN_GENEVE,
 	ICE_SW_TUN_NVGRE,
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 11ae0bee3590..475ec2afa210 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4537,6 +4537,7 @@ ice_get_compat_fv_bitmap(struct ice_hw *hw, struct ice_adv_rule_info *rinfo,
 	case ICE_SW_TUN_NVGRE:
 		prof_type = ICE_PROF_TUN_GRE;
 		break;
+	case ICE_SW_TUN_AND_NON_TUN:
 	default:
 		prof_type = ICE_PROF_ALL;
 		break;
@@ -5305,7 +5306,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (status)
 		goto err_ice_add_adv_rule;
 
-	if (rinfo->tun_type != ICE_NON_TUN) {
+	if (rinfo->tun_type != ICE_NON_TUN &&
+	    rinfo->tun_type != ICE_SW_TUN_AND_NON_TUN) {
 		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
 						 s_rule->pdata.lkup_tx_rx.hdr,
 						 pkt_offsets);
-- 
2.31.1

