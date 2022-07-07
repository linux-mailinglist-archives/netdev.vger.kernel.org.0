Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24B5569F63
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiGGKRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiGGKRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:17:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDDE50714
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657189021; x=1688725021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOF50CpjhYrgsn46x88QV1wMYEZY7xjQHzvnqDG58ig=;
  b=SmvB+L80MqWhuJl6EzrRi47g65/tA6lypl7iyp6hw2wPmbBgjQE4s+kR
   V+QErekWlQ4lwfyqPTmg5ipkIhKRbgpyFLROKg1Z/nhc9IyLnfWXRSROl
   Yb5FW739GGCU2brJCGMAI7s7vH+b54Sql6ertRfbNAPG7FYJA19sWMJYP
   ZOmE6AQcY4zR6ET8WhaFqNIsAtqe5Z9Fj9lbRqCLZNMxaBDjCAaYtc9LI
   ldhZCjkYofcB4rdo2wzf798sxNKcFMaSsfzqOthpYbZuE7wWLwkoZywbT
   mw1MIejtpm7cr5ySOL0Vto7HUvEdEebhjMTa6Mz2U1/oQKX/PdhRpDuaN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="285113724"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="285113724"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 03:17:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="651077067"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jul 2022 03:16:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        anatolii.gerasymenko@intel.com, alexandr.lobakin@intel.com,
        john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 2/2] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Thu,  7 Jul 2022 12:16:51 +0200
Message-Id: <20220707101651.48738-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220707101651.48738-1-maciej.fijalkowski@intel.com>
References: <20220707101651.48738-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NETIF_F_LOOPBACK. This feature can be set via:
$ ethtool -K eth0 loopback <on|off>

Feature can be useful for local data path tests.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 33 ++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 084f0e17187c..4b08990590ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
@@ -5915,6 +5916,33 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
+/**
+ * ice_set_loopback - turn on/off loopback mode on underlying PF
+ * @vsi: ptr to VSI
+ * @ena: flag to indicate the on/off setting
+ */
+static int
+ice_set_loopback(struct ice_vsi *vsi, bool ena)
+{
+	bool if_running = netif_running(vsi->netdev);
+	int ret;
+
+	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
+		ret = ice_down(vsi);
+		if (ret) {
+			netdev_err(vsi->netdev, "Preparing device to toggle loopback failed\n");
+			return ret;
+		}
+	}
+	ret = ice_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
+	if (ret)
+		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
+	if (if_running)
+		ret = ice_up(vsi);
+
+	return ret;
+}
+
 /**
  * ice_set_features - set the netdev feature flags
  * @netdev: ptr to the netdev being adjusted
@@ -5973,7 +6001,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
 	}
 
-	return 0;
+	if (changed & NETIF_F_LOOPBACK)
+		ret = ice_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
+
+	return ret;
 }
 
 /**
-- 
2.27.0

