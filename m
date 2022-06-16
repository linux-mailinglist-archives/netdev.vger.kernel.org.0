Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D584554E919
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376306AbiFPSGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346366AbiFPSGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:06:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936994EDE2;
        Thu, 16 Jun 2022 11:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655402793; x=1686938793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S45H44CBH1JniCbOsGg73BnKvoqIL3IdcN3OLKDb+VU=;
  b=Khiu/qbwYngktzx0FlTmH7XLZPuU4YoHj8HQ0eO0Ism2KFYdCpds53++
   vtOY0l8uzZBLfrkNif2xfLEBsZIJVpPldlw+y+V0IbplieoiOXdPjB1Gt
   rz1HrTjvaWc7eybc9bdSdjH/AwfnMHDYZVpRais1OS0zbXnrumABmU2wa
   60qdNujS8eDvvayLS1jWoTWker52jFHrYVHWB/x/n49CSI2iscGTyJ8e8
   agYkoniF7o4jnfBeBFjbzqeZlPn5deMr6qwpCDzDPwAYeU4i4mpQGeVX3
   t2DPiANHfmd2Ontp1xUXPIA1M6im39i06iRg/XmvyLCi3yIW46HNfMWf/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343275913"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343275913"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:06:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641664301"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2022 11:06:24 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH v4 bpf-next 02/10] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Thu, 16 Jun 2022 20:06:01 +0200
Message-Id: <20220616180609.905015-3-maciej.fijalkowski@intel.com>
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

Add support for NETIF_F_LOOPBACK. This feature can be set via:
$ ethtool -K eth0 loopback <on|off>

Feature can be useful for local data path tests.

CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 33 ++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 23d1b1fc39fb..5bdd515142ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
@@ -5902,6 +5903,33 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
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
@@ -5960,7 +5988,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
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

