Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25E54B80A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244080AbiFNRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbiFNRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:48:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F153055F;
        Tue, 14 Jun 2022 10:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655228884; x=1686764884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vmf7x579QBwv8YXAGjON3KIIRMEr0QApqqdBHK9Q4b0=;
  b=WjqaFfhPDLW0SfOZT/eZkJpYQTLAJNp3xoYK/CK6bQ6uRrAItHJCuxVD
   trbTlYXEFV8aYYUjxzGuoDZUmmsghfDoHQAZ7XhPFHzTC2c5Z8DH97u2n
   GoYXTDBMHjjAC3Iu8TcHB7h+1Wz8XWgvuokYQHaqqblEDIlLsTl+4/x/8
   RT24QFesAnPBNjCgbmvfKWiGSfr4atr4/RtRgTPi8l4zVuijs9IkZu3vs
   upZUZQcheUvZK+2mPaGjyaP+p+71ERh6B9XcjkN3f2eg9jY6r9z+pBfo8
   0KYORZRNY10slt7Os14UVdIIcpKIn5+VI0q0zi1nIm6tpn+98WEOB9AS7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340356774"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340356774"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 10:47:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="570110063"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Jun 2022 10:47:54 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Tue, 14 Jun 2022 19:47:40 +0200
Message-Id: <20220614174749.901044-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NETIF_F_LOOPBACK. Also, simplify checks throughout whole
ice_set_features().

CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 54 ++++++++++++++---------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e1cae253412c..ab00b0361e87 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
@@ -5902,6 +5903,18 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
+static void ice_set_loopback(struct ice_pf *pf, struct net_device *netdev, bool ena)
+{
+	bool if_running = netif_running(netdev);
+
+	if (if_running)
+		ice_stop(netdev);
+	if (ice_aq_set_mac_loopback(&pf->hw, ena, NULL))
+		dev_err(ice_pf_to_dev(pf), "Failed to toggle loopback state\n");
+	if (if_running)
+		ice_open(netdev);
+}
+
 /**
  * ice_set_features - set the netdev feature flags
  * @netdev: ptr to the netdev being adjusted
@@ -5910,6 +5923,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 static int
 ice_set_features(struct net_device *netdev, netdev_features_t features)
 {
+	netdev_features_t changed = netdev->features ^ features;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
@@ -5917,37 +5931,33 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	/* Don't set any netdev advanced features with device in Safe Mode */
 	if (ice_is_safe_mode(vsi->back)) {
-		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
+		dev_err(ice_pf_to_dev(vsi->back),
+			"Device is in Safe Mode - not enabling advanced netdev features\n");
 		return ret;
 	}
 
 	/* Do not change setting during reset */
 	if (ice_is_reset_in_progress(pf->state)) {
-		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
+		dev_err(ice_pf_to_dev(vsi->back),
+			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
 		return -EBUSY;
 	}
 
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
-	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
-		ice_vsi_manage_rss_lut(vsi, true);
-	else if (!(features & NETIF_F_RXHASH) &&
-		 netdev->features & NETIF_F_RXHASH)
-		ice_vsi_manage_rss_lut(vsi, false);
+	if (changed & NETIF_F_RXHASH)
+		ice_vsi_manage_rss_lut(vsi, !!(features & NETIF_F_RXHASH));
 
 	ret = ice_set_vlan_features(netdev, features);
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_NTUPLE) &&
-	    !(netdev->features & NETIF_F_NTUPLE)) {
-		ice_vsi_manage_fdir(vsi, true);
-		ice_init_arfs(vsi);
-	} else if (!(features & NETIF_F_NTUPLE) &&
-		 (netdev->features & NETIF_F_NTUPLE)) {
-		ice_vsi_manage_fdir(vsi, false);
-		ice_clear_arfs(vsi);
+	if (changed & NETIF_F_NTUPLE) {
+		bool ena = !!(features & NETIF_F_NTUPLE);
+
+		ice_vsi_manage_fdir(vsi, ena);
+		ena ? ice_init_arfs(vsi) : ice_clear_arfs(vsi);
 	}
 
 	/* don't turn off hw_tc_offload when ADQ is already enabled */
@@ -5956,11 +5966,15 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		return -EACCES;
 	}
 
-	if ((features & NETIF_F_HW_TC) &&
-	    !(netdev->features & NETIF_F_HW_TC))
-		set_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
-	else
-		clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
+	if (changed & NETIF_F_HW_TC) {
+		bool ena = !!(features & NETIF_F_HW_TC);
+
+		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
+		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
+	}
+
+	if (changed & NETIF_F_LOOPBACK)
+		ice_set_loopback(pf, netdev, !!(features & NETIF_F_LOOPBACK));
 
 	return 0;
 }
-- 
2.27.0

