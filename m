Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7B54B6CC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344787AbiFNQv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354713AbiFNQvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:51:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8575E326D5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655225476; x=1686761476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w1vHXkiJm3DyKVoBtllboekJ21B82sC5VZG6ron8ZF0=;
  b=fUMnb9pEV16XsxPFiL6JjBYEw7bvRBWpqub2bLf2fmdJADsOrjrf7HRg
   R/nQHE7Qi3VgbQhKGQjIhpub791B8Qgohhh6PFkQrqZ41IrLG8NzzX1Ef
   oqrumnxiUIlOUGe6jkAQqzfj9mh6QnNYh4Bn9v7kUrkp0KFZdpKbUxH++
   7iX0CxlZQqW9dzF4r1ResLGbQ4PDKOksWjCy1uvRTQddrSu42It8Nl3lN
   esushYd7I6uO/MXmq3l7LOCv1E4ENCR2MbWH1edPgILAxvGTTHgi4FWu2
   XVFV7Tznmrnp0Zvx9z8rCtr5oD04RaS6J1NZjwlB82DNa1B60db1gRMZ5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="278715016"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="278715016"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 09:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="582775188"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 09:51:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Roman Storozhenko <roman.storozhenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/4] ice: Sync VLAN filtering features for DVM
Date:   Tue, 14 Jun 2022 09:48:04 -0700
Message-Id: <20220614164806.1184030-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
References: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Storozhenko <roman.storozhenko@intel.com>

VLAN filtering features, that is C-Tag and S-Tag, in DVM mode must be
both enabled or disabled.
In case of turning off/on only one of the features, another feature must
be turned off/on automatically with issuing an appropriate message to
the kernel log.

Fixes: 1babaf77f49d ("ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev")
Signed-off-by: Roman Storozhenko <roman.storozhenko@intel.com>
Co-developed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 49 ++++++++++++++---------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e1cae253412c..c1ac2f746714 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5763,25 +5763,38 @@ static netdev_features_t
 ice_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	netdev_features_t supported_vlan_filtering;
-	netdev_features_t requested_vlan_filtering;
-	struct ice_vsi *vsi = np->vsi;
-
-	requested_vlan_filtering = features & NETIF_VLAN_FILTERING_FEATURES;
-
-	/* make sure supported_vlan_filtering works for both SVM and DVM */
-	supported_vlan_filtering = NETIF_F_HW_VLAN_CTAG_FILTER;
-	if (ice_is_dvm_ena(&vsi->back->hw))
-		supported_vlan_filtering |= NETIF_F_HW_VLAN_STAG_FILTER;
-
-	if (requested_vlan_filtering &&
-	    requested_vlan_filtering != supported_vlan_filtering) {
-		if (requested_vlan_filtering & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, enabling all supported VLAN filtering settings\n");
-			features |= supported_vlan_filtering;
+	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
+	bool cur_ctag, cur_stag, req_ctag, req_stag;
+
+	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+	cur_ctag = cur_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	cur_stag = cur_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
+	req_ctag = req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	req_stag = req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	if (req_vlan_fltr != cur_vlan_fltr) {
+		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
+			if (req_ctag && req_stag) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+			} else if (!req_ctag && !req_stag) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
+				   (!cur_stag && req_stag && !cur_ctag)) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
+			} else if ((cur_ctag && !req_ctag && cur_stag) ||
+				   (cur_stag && !req_stag && cur_ctag)) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
+			}
 		} else {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, clearing all supported VLAN filtering settings\n");
-			features &= ~supported_vlan_filtering;
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER)
+				netdev_warn(netdev, "cannot support requested 802.1ad filtering setting in SVM mode\n");
+
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER)
+				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		}
 	}
 
-- 
2.35.1

