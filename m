Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B80F2A183A
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 15:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgJaOgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 10:36:24 -0400
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:55466 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgJaOgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 10:36:23 -0400
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 0FE798195C;
        Sat, 31 Oct 2020 17:36:22 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
To:     kuba@kernel.org
Cc:     sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] fix for potential NULL pointer dereference with bare lan743x
Date:   Sat, 31 Oct 2020 17:36:18 +0300
Message-Id: <20201031143619.7086-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201030165515.614637a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201030165515.614637a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
---
 drivers/net/ethernet/microchip/lan743x_ethtool.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb..ad38fc9e1468 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -780,7 +780,9 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
 
 	wol->supported = 0;
 	wol->wolopts = 0;
-	phy_ethtool_get_wol(netdev->phydev, wol);
+
+	if (netdev->phydev)
+		phy_ethtool_get_wol(netdev->phydev, wol);
 
 	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
 		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
@@ -792,6 +794,7 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 				   struct ethtool_wolinfo *wol)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	int ret;
 
 	adapter->wolopts = 0;
 	if (wol->wolopts & WAKE_UCAST)
@@ -809,9 +812,12 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
-	phy_ethtool_set_wol(netdev->phydev, wol);
+	if (netdev->phydev)
+		ret = phy_ethtool_set_wol(netdev->phydev, wol);
+	else
+		ret = -EIO;
 
-	return 0;
+	return ret;
 }
 #endif /* CONFIG_PM */
 
-- 
2.20.1

