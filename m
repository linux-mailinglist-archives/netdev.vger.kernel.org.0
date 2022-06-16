Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62654E911
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359138AbiFPSGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358129AbiFPSGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:06:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6C64EDD7;
        Thu, 16 Jun 2022 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655402793; x=1686938793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ErhvI6oD4q6tNA4Mvtx4UA3aP40DUiY5A2A/F9sPEi0=;
  b=QZqeRUTkZE6STvbs963kTLNqqFrop3jnj4l78/wC3v7qEnF7iuih5qve
   Pc8mG0KqU9eeTiUiLnLbIXEB0F33bU0+T88WTmNd0qbO27X1Muij3lojv
   rrFnqeo8MiNxX7TYwo9U0zOF3r5YfOI9Hkv+LI5tqi9Xm3oXTLx6JtVpK
   IwGhbf+5fI2Y1CmbQezcOBeINXnNIx6ivsuiO3AWX2elZv2KE+3yKw6Vk
   z2Mk84oKtM0gnFfGrNiYfbwwAodBeqLyuAmA6ScxIEAub9wCt/In21yiT
   Ftgyd9oAuQgEfYNb6bqtW8jmNke6YPRrtepDILUWzlYt8wvnKCAD/MYMF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343275908"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343275908"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641664285"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2022 11:06:19 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH v4 bpf-next 01/10] ice: compress branches in ice_set_features()
Date:   Thu, 16 Jun 2022 20:06:00 +0200
Message-Id: <20220616180609.905015-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of rather verbose comparison of current netdev->features bits vs
the incoming ones from user, let us compress them by a helper features
set that will be the result of netdev->features XOR features. This way,
current, extensive branches:

	if (features & NETIF_F_BIT && !(netdev->features & NETIF_F_BIT))
		set_feature(true);
	else if (!(features & NETIF_F_BIT) && netdev->features & NETIF_F_BIT)
		set_feature(false);

can become:

	netdev_features_t changed = netdev->features ^ features;

	if (changed & NETIF_F_BIT)
		set_feature(!!(features & NETIF_F_BIT));

This is nothing new as currently several other drivers use this
approach, which I find much more convenient.

CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 40 +++++++++++------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e1cae253412c..23d1b1fc39fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5910,44 +5910,41 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 static int
 ice_set_features(struct net_device *netdev, netdev_features_t features)
 {
+	netdev_features_t changed = netdev->features ^ features;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int ret = 0;
 
 	/* Don't set any netdev advanced features with device in Safe Mode */
-	if (ice_is_safe_mode(vsi->back)) {
-		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
+	if (ice_is_safe_mode(pf)) {
+		dev_err(ice_pf_to_dev(vsi->back),
+			"Device is in Safe Mode - not enabling advanced netdev features\n");
 		return ret;
 	}
 
 	/* Do not change setting during reset */
 	if (ice_is_reset_in_progress(pf->state)) {
-		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
+		dev_err(ice_pf_to_dev(pf),
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
@@ -5956,11 +5953,12 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
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
 
 	return 0;
 }
-- 
2.27.0

