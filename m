Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3308A29DD72
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbgJ2Ahn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:37:43 -0400
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:53798 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730552AbgJ2Afw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:35:52 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 20:35:51 EDT
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 82EAD80470;
        Thu, 29 Oct 2020 03:28:47 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
Cc:     sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix for potential NULL pointer dereference with bare lan743x
Date:   Thu, 29 Oct 2020 03:28:45 +0300
Message-Id: <20201029002845.28984-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This is just a minor fix which prevents a kernel NULL pointer
dereference when using phy-less lan743x.

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
---
 drivers/net/ethernet/microchip/lan743x_ethtool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb..354d72d550f2 100644
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
@@ -793,6 +795,9 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
+	if (!netdev->phydev)
+		return -EIO;
+
 	adapter->wolopts = 0;
 	if (wol->wolopts & WAKE_UCAST)
 		adapter->wolopts |= WAKE_UCAST;
-- 
2.20.1

