Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE85846BF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiG1T6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiG1T6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:58:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF2C70E45
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659038320; x=1690574320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WlgFCQhGd1WUCEjaAwA0dnVsdq1uBAFdBuCelNj/Rw0=;
  b=lAsQvThWV8dA8jFAF/Cvu9HyaHBxfEL1ewBaeLwZu9rx6d0Cm2JfGkBW
   a8kdJWg60sudUDVd9EPRfd++bn8+XyZuh7S5Qe4EMBgpRe9CGokigCkFO
   bTJeaXek/19fNheSAyvnDMejuymxsv2KO5KCbprT59TEMp40m1ceiIlmH
   YcI20D6blpmrbreDkBUBaEsliijPix8mObsjwYfjisOBzRgEq8ObYjYlS
   NJ7esa1ezyoQdfYQoajTo464TsCSmXBVFXSLrtWxSJi5HjRGFVYAK0sQZ
   R/6yon2VjYx8V7nuGaYpgSHzUckzAIjy8FfmF8Pi6nrJDnJnCi63b510m
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="350310076"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="350310076"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:58:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="928453975"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2022 12:58:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        John Fastabend <john.fastabend@gmail.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 4/4] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Thu, 28 Jul 2022 12:55:38 -0700
Message-Id: <20220728195538.3391360-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
References: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Add support for NETIF_F_LOOPBACK. This feature can be set via:
$ ethtool -K eth0 loopback <on|off>

Feature can be useful for local data path tests.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 32 ++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4d2804877aa2..cbbbb6788baa 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
@@ -5910,6 +5911,32 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
+/**
+ * ice_set_loopback - turn on/off loopback mode on underlying PF
+ * @vsi: ptr to VSI
+ * @ena: flag to indicate the on/off setting
+ */
+static int ice_set_loopback(struct ice_vsi *vsi, bool ena)
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
@@ -5968,7 +5995,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
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
2.35.1

