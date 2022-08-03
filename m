Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD2A589389
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbiHCUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbiHCUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:09 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AAA5C969
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T4+UpKNUsd9cCj/RM6bbhlvKsvF+DaQ87z+jQ0EufIM=; b=MG5nN0Hp9BCPef3Uwzcdl5DTil
        soz0sKQ9yZAcP99DIcbuEf2J6Y/qVtPPCic0Hjvlq/dwRg5XyvG42wRFaRJevGY0Io7o/MJU+Hn0H
        JeQtw0jm/OlYGKrsVPqh9lQDgSGpIuHGTZjBaAcyQShVNdIqyjcc9/D0T5r5oogSOPdE=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJZ-0001TF-UY; Wed, 03 Aug 2022 22:50:02 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/6] tsnep: Add loopback support
Date:   Wed,  3 Aug 2022 22:49:42 +0200
Message-Id: <20220803204947.52789-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NETIF_F_LOOPBACK feature. Loopback mode is used for
testing.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 71 ++++++++++++++++------
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index cb069a0af7b9..fcc605a347c4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -124,30 +124,51 @@ static int tsnep_mdiobus_write(struct mii_bus *bus, int addr, int regnum,
 	return 0;
 }
 
+static void tsnep_set_link_mode(struct tsnep_adapter *adapter)
+{
+	u32 mode;
+
+	switch (adapter->phydev->speed) {
+	case SPEED_100:
+		mode = ECM_LINK_MODE_100;
+		break;
+	case SPEED_1000:
+		mode = ECM_LINK_MODE_1000;
+		break;
+	default:
+		mode = ECM_LINK_MODE_OFF;
+		break;
+	}
+	iowrite32(mode, adapter->addr + ECM_STATUS);
+}
+
 static void tsnep_phy_link_status_change(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
-	u32 mode;
 
-	if (phydev->link) {
-		switch (phydev->speed) {
-		case SPEED_100:
-			mode = ECM_LINK_MODE_100;
-			break;
-		case SPEED_1000:
-			mode = ECM_LINK_MODE_1000;
-			break;
-		default:
-			mode = ECM_LINK_MODE_OFF;
-			break;
-		}
-		iowrite32(mode, adapter->addr + ECM_STATUS);
-	}
+	if (phydev->link)
+		tsnep_set_link_mode(adapter);
 
 	phy_print_status(netdev->phydev);
 }
 
+static int tsnep_phy_loopback(struct tsnep_adapter *adapter, bool enable)
+{
+	int retval;
+
+	retval = phy_loopback(adapter->phydev, enable);
+
+	/* PHY link state change is not signaled if loopback is enabled, it
+	 * would delay a working loopback anyway, let's ensure that loopback
+	 * is working immediately by setting link mode directly
+	 */
+	if (!retval && enable)
+		tsnep_set_link_mode(adapter);
+
+	return retval;
+}
+
 static int tsnep_phy_open(struct tsnep_adapter *adapter)
 {
 	struct phy_device *phydev;
@@ -1017,6 +1038,22 @@ static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
 	return 0;
 }
 
+static int tsnep_netdev_set_features(struct net_device *netdev,
+				     netdev_features_t features)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed = netdev->features ^ features;
+	bool enable;
+	int retval = 0;
+
+	if (changed & NETIF_F_LOOPBACK) {
+		enable = !!(features & NETIF_F_LOOPBACK);
+		retval = tsnep_phy_loopback(adapter, enable);
+	}
+
+	return retval;
+}
+
 static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
 				       const struct skb_shared_hwtstamps *hwtstamps,
 				       bool cycles)
@@ -1038,9 +1075,9 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_start_xmit = tsnep_netdev_xmit_frame,
 	.ndo_eth_ioctl = tsnep_netdev_ioctl,
 	.ndo_set_rx_mode = tsnep_netdev_set_multicast,
-
 	.ndo_get_stats64 = tsnep_netdev_get_stats64,
 	.ndo_set_mac_address = tsnep_netdev_set_mac_address,
+	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
 };
@@ -1225,7 +1262,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
 	netdev->features = NETIF_F_SG;
-	netdev->hw_features = netdev->features;
+	netdev->hw_features = netdev->features | NETIF_F_LOOPBACK;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
-- 
2.30.2

