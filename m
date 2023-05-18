Return-Path: <netdev+bounces-3565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636C7707E09
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50E331C21080
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30751125B9;
	Thu, 18 May 2023 10:26:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2059E125B7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:26:39 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469B71BE6
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684405597; x=1715941597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ninw869I6P0cFGI0nOQ6S8ycG12PdZIEkTEIVH21FGs=;
  b=F0CymuYwHyy0McNWyRzdIe3Wv2g0xl2SKCsXFK/pXoKBq7lRBCa3ould
   sGSoepmpIrQIgQBfWxnYDL4HwBMvAjJLKlvsw9aCzxhRNI5nruFMEa1tH
   yYw/zoDxCmajKpWUi06RpKO18iMxy8yReBRniJU3Ciyhyj8uNHzonVQ2N
   CBQpFdurYZZLDBpBjeOHF/bi6vMTIXOgNLXRN7tC7xPcfWSAwDVONPRlN
   Tsu7H4KqV8mDFxrcD14tPCTvTrH/uNxFzMS5lHO2l4UIofGaZkuGlOums
   4SbPrrCj3R3prNXapa8DpH+Wa1WhUnE9jsiNekRiaYfyUS5PNIqSQU0ls
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="438371421"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438371421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="767143732"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="767143732"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2023 03:26:20 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id AF81A27BA3;
	Thu, 18 May 2023 11:26:19 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com
Subject: [PATCH iwl-next v2 01/10] ice: Minor switchdev fixes
Date: Thu, 18 May 2023 12:25:00 +0200
Message-Id: <20230518102509.20913-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518102509.20913-1-wojciech.drewek@intel.com>
References: <20230518102509.20913-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
  enabled in ice_set_rx_mode.

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
v2: enclose bitops into separate set of braces, move
    ice_is_switchdev_running check to ice_set_rx_mode
    from ice_vsi_sync_fltr
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 14 +++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c    |  4 ++--
 2 files changed, 15 insertions(+), 3 deletions(-)

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
index b0d1e6116eb9..80b2b4d39278 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -385,7 +385,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	}
 	err = 0;
 	/* check for changes in promiscuous modes */
-	if (changed_flags & IFF_ALLMULTI) {
+	if ((changed_flags & IFF_ALLMULTI)) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
 			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
@@ -5767,7 +5767,7 @@ static void ice_set_rx_mode(struct net_device *netdev)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 
-	if (!vsi)
+	if (!vsi || ice_is_switchdev_running(vsi->back))
 		return;
 
 	/* Set the flags to synchronize filters
-- 
2.40.1


