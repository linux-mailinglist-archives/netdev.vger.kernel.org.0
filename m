Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11796424B84
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbhJGBJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240179AbhJGBJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0D16113E;
        Thu,  7 Oct 2021 01:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568838;
        bh=7tGrolaPtm0yK4RHBoVz2P9qG9S2ZGS78cUr+64jN24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOdE+0qhmFfeBJSGzUwO44rdhCx1hGnrOuX50cq4mYmLAZbQvdv9/Zv8Zy0MskKFc
         7gBGBR0SRWyWERlNAbPZ0pTNaoVq5lrhwm8tZXYW5yRWzsHbY+5ljKh4s3aiaUiWyO
         RUEylk1TvCfrIrUpjV2O8nuE6QXoBj8GHlL9mQ0DQMgaLySZwZRSLBRapsmOFRk2aS
         z0teO4vUYqaCCSCu4xOxsgeW0+DUYKUB4TNaIMeabEfKCjgzMnQ2P0l/9IxsckVN6x
         qIkosXvVP1l8/zIrhdeNpO3PociGgSfGqnjiU6ZNTXN9bdMf8Vb4DKiWhgdvPmSpNn
         a/2SlWCgzpH6g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 9/9] ethernet: make more use of device_get_ethdev_address()
Date:   Wed,  6 Oct 2021 18:07:02 -0700
Message-Id: <20211007010702.3438216-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
References: <20211007010702.3438216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert a few drivers to device_get_ethdev_address(),
saving a few LoC.

The check if addr is valid in netsec is superfluous,
device_get_ethdev_addr() already checks that (in
fwnode_get_mac_addr()).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: new patch
---
 drivers/net/ethernet/faraday/ftgmac100.c  | 5 ++---
 drivers/net/ethernet/microchip/enc28j60.c | 5 +----
 drivers/net/ethernet/qualcomm/emac/emac.c | 5 +----
 drivers/net/ethernet/socionext/netsec.c   | 9 ++-------
 4 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 86c2986395de..97c5d70de76e 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -183,10 +183,9 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	unsigned int m;
 	unsigned int l;
 
-	if (!device_get_mac_address(priv->dev, mac)) {
-		eth_hw_addr_set(priv->netdev, mac);
+	if (!device_get_ethdev_address(priv->dev, priv->netdev)) {
 		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
-			 mac);
+			 priv->netdev->dev_addr);
 		return;
 	}
 
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index cca8aa70cfc9..634ac7649c43 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1539,7 +1539,6 @@ static const struct net_device_ops enc28j60_netdev_ops = {
 
 static int enc28j60_probe(struct spi_device *spi)
 {
-	unsigned char macaddr[ETH_ALEN];
 	struct net_device *dev;
 	struct enc28j60_net *priv;
 	int ret = 0;
@@ -1572,9 +1571,7 @@ static int enc28j60_probe(struct spi_device *spi)
 		goto error_irq;
 	}
 
-	if (!device_get_mac_address(&spi->dev, macaddr))
-		eth_hw_addr_set(dev, macaddr);
-	else
+	if (device_get_ethdev_address(&spi->dev, dev))
 		eth_hw_addr_random(dev);
 	enc28j60_set_hw_macaddr(dev);
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index b1b324f45fe7..a55c52696d49 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -545,13 +545,10 @@ static int emac_probe_resources(struct platform_device *pdev,
 				struct emac_adapter *adpt)
 {
 	struct net_device *netdev = adpt->netdev;
-	char maddr[ETH_ALEN];
 	int ret = 0;
 
 	/* get mac address */
-	if (!device_get_mac_address(&pdev->dev, maddr))
-		eth_hw_addr_set(netdev, maddr);
-	else
+	if (device_get_ethdev_address(&pdev->dev, netdev))
 		eth_hw_addr_random(netdev);
 
 	/* Core 0 interrupt */
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 7e3dd07ac94e..baa9f5d1c549 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1981,7 +1981,6 @@ static int netsec_probe(struct platform_device *pdev)
 	struct netsec_priv *priv;
 	u32 hw_ver, phy_addr = 0;
 	struct net_device *ndev;
-	u8 macbuf[ETH_ALEN];
 	int ret;
 
 	mmio_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -2034,12 +2033,8 @@ static int netsec_probe(struct platform_device *pdev)
 		goto free_ndev;
 	}
 
-	ret = device_get_mac_address(&pdev->dev, macbuf);
-	if (!ret)
-		eth_hw_addr_set(ndev, macbuf);
-
-	if (priv->eeprom_base &&
-	    (ret || !is_valid_ether_addr(ndev->dev_addr))) {
+	ret = device_get_ethdev_address(&pdev->dev, ndev);
+	if (ret && priv->eeprom_base) {
 		void __iomem *macp = priv->eeprom_base +
 					NETSEC_EEPROM_MAC_ADDRESS;
 
-- 
2.31.1

