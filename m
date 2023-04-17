Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60E6E440F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDQJiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjDQJhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:37:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0DB55B7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724196; x=1713260196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YeDTlqNWIhn+3zDARr1uzRUJAFrSA/jxugFwYu6on8s=;
  b=UR0tA3gr1a6eLjUNX8+rxsMwd/gMcIQgu8rUN1BjQxyA8Elv40PipqFa
   R+kk0Inwk1DqVhbxcd3ejNtD2H7wewnUF/nbOEn/dWi7Vo0+r2pvYGnY7
   O8V+T5v9eEcK561DLnWe5wuegNdBx7lKDti5ZsGnbGWFuxTjKU4qae0ID
   Mvks5NU4EEVECv7jAWz1OZ5xd7THMZQb8l99siJBrjTe6EjJMc41CojjE
   Z5gxbhoOGO7ZsSZ5F0heMIHDKYuWO5Mo+H/V7Kz7T/IWKMvyQX4kWmm0+
   VVZkWw80+WJB6UteXEKg3iTrbd2gW+t9WoBdbjZKcZ2/014Mn9oKPIekT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644082"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644082"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899246"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899246"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:18 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id B4B4B37E30;
        Mon, 17 Apr 2023 10:35:17 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 01/12] ice: Minor switchdev fixes
Date:   Mon, 17 Apr 2023 11:34:01 +0200
Message-Id: <20230417093412.12161-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417093412.12161-1-wojciech.drewek@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a few fixes that are needed for bridge offload
to work properly.

- Skip adv rule removal in ice_eswitch_disable_switchdev.
  Advanced rules for ctrl VSI will be removed anyway when the
  VSI will cleaned up, no need to do it explicitly.

- Don't allow to change promisc mode in switchdev mode.
  When switchdev is configured, PF netdev is set to be a
  default VSI. This is needed for the slow-path to work correctly.
  All the unmatched packets will be directed to PF netdev.

  It is possible that this setting might be overwritten by
  ndo_set_rx_mode. Prevent this by checking if switchdev is
  enabled in ice_vsi_sync_fltr.

- Disable vlan pruning for uplink VSI. In switchdev mode, uplink VSI
  is configured to be default VSI which means it will receive all
  unmatched packets. In order to receive vlan packets we need to
  disable vlan pruning as well. This is done by dis_rx_filtering
  vlan op.

- There is possibility that ice_eswitch_port_start_xmit might be
  called while some resources are still not allocated which might
  cause NULL pointer dereference. Fix this by checking if switchdev
  configuration was finished.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 14 +++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c    |  2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index ad0a007b7398..bfd003135fc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -103,6 +103,10 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 		rule_added = true;
 	}
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
+	if (vlan_ops->dis_rx_filtering(uplink_vsi))
+		goto err_dis_rx;
+
 	if (ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_set_allow_override))
 		goto err_override_uplink;
 
@@ -114,6 +118,8 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 err_override_control:
 	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
 err_override_uplink:
+	vlan_ops->ena_rx_filtering(uplink_vsi);
+err_dis_rx:
 	if (rule_added)
 		ice_clear_dflt_vsi(uplink_vsi);
 err_def_rx:
@@ -331,6 +337,9 @@ ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	np = netdev_priv(netdev);
 	vsi = np->vsi;
 
+	if (!vsi || !ice_is_switchdev_running(vsi->back))
+		return NETDEV_TX_BUSY;
+
 	if (ice_is_reset_in_progress(vsi->back->state) ||
 	    test_bit(ICE_VF_DIS, vsi->back->state))
 		return NETDEV_TX_BUSY;
@@ -378,9 +387,13 @@ static void ice_eswitch_release_env(struct ice_pf *pf)
 {
 	struct ice_vsi *uplink_vsi = pf->switchdev.uplink_vsi;
 	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
+	struct ice_vsi_vlan_ops *vlan_ops;
+
+	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
 
 	ice_vsi_update_security(ctrl_vsi, ice_vsi_ctx_clear_allow_override);
 	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
+	vlan_ops->ena_rx_filtering(uplink_vsi);
 	ice_clear_dflt_vsi(uplink_vsi);
 	ice_fltr_add_mac_and_broadcast(uplink_vsi,
 				       uplink_vsi->port_info->mac.perm_addr,
@@ -503,7 +516,6 @@ static void ice_eswitch_disable_switchdev(struct ice_pf *pf)
 
 	ice_eswitch_napi_disable(pf);
 	ice_eswitch_release_env(pf);
-	ice_rem_adv_rule_for_vsi(&pf->hw, ctrl_vsi->idx);
 	ice_eswitch_release_reprs(pf, ctrl_vsi);
 	ice_vsi_release(ctrl_vsi);
 	ice_repr_rem_from_all_vfs(pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7c04057c524c..f198c845631f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -385,7 +385,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	}
 	err = 0;
 	/* check for changes in promiscuous modes */
-	if (changed_flags & IFF_ALLMULTI) {
+	if (changed_flags & IFF_ALLMULTI && !ice_is_switchdev_running(pf)) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
 			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
-- 
2.39.2

