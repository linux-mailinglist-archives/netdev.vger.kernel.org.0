Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FCF35E7BF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348312AbhDMUs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:48:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:41260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348277AbhDMUsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:48:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA34BAE86;
        Tue, 13 Apr 2021 20:48:31 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: korina: Fix MDIO functions
Date:   Tue, 13 Apr 2021 22:48:12 +0200
Message-Id: <20210413204818.23350-2-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210413204818.23350-1-tsbogend@alpha.franken.de>
References: <20210413204818.23350-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed MDIO functions to work reliable and not just by accident.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 57 +++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 925161959b9b..2266b18c1377 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -137,7 +137,6 @@ struct korina_private {
 	struct mii_if_info mii_if;
 	struct work_struct restart_task;
 	struct net_device *dev;
-	int phy_addr;
 };
 
 extern unsigned int idt_cpu_freq;
@@ -292,32 +291,50 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static int mdio_read(struct net_device *dev, int mii_id, int reg)
+static int korina_mdio_wait(struct korina_private *lp)
+{
+	int timeout = 1000;
+
+	while ((readl(&lp->eth_regs->miimind) & 1) && timeout-- > 0)
+		udelay(1);
+
+	if (timeout <= 0)
+		return -1;
+
+	return 0;
+}
+
+static int korina_mdio_read(struct net_device *dev, int phy, int reg)
 {
 	struct korina_private *lp = netdev_priv(dev);
 	int ret;
 
-	mii_id = ((lp->rx_irq == 0x2c ? 1 : 0) << 8);
+	if (korina_mdio_wait(lp))
+		return -1;
 
-	writel(0, &lp->eth_regs->miimcfg);
-	writel(0, &lp->eth_regs->miimcmd);
-	writel(mii_id | reg, &lp->eth_regs->miimaddr);
-	writel(ETH_MII_CMD_SCN, &lp->eth_regs->miimcmd);
+	writel(phy << 8 | reg, &lp->eth_regs->miimaddr);
+	writel(1, &lp->eth_regs->miimcmd);
 
-	ret = (int)(readl(&lp->eth_regs->miimrdd));
+	if (korina_mdio_wait(lp))
+		return -1;
+
+	if (readl(&lp->eth_regs->miimind) & 4)
+		return -1;
+
+	ret = readl(&lp->eth_regs->miimrdd);
+	writel(0, &lp->eth_regs->miimcmd);
 	return ret;
 }
 
-static void mdio_write(struct net_device *dev, int mii_id, int reg, int val)
+static void korina_mdio_write(struct net_device *dev, int phy, int reg, int val)
 {
 	struct korina_private *lp = netdev_priv(dev);
 
-	mii_id = ((lp->rx_irq == 0x2c ? 1 : 0) << 8);
+	if (korina_mdio_wait(lp))
+		return;
 
-	writel(0, &lp->eth_regs->miimcfg);
-	writel(1, &lp->eth_regs->miimcmd);
-	writel(mii_id | reg, &lp->eth_regs->miimaddr);
-	writel(ETH_MII_CMD_SCN, &lp->eth_regs->miimcmd);
+	writel(0, &lp->eth_regs->miimcmd);
+	writel(phy << 8 | reg, &lp->eth_regs->miimaddr);
 	writel(val, &lp->eth_regs->miimwtd);
 }
 
@@ -643,7 +660,7 @@ static void korina_check_media(struct net_device *dev, unsigned int init_media)
 {
 	struct korina_private *lp = netdev_priv(dev);
 
-	mii_check_media(&lp->mii_if, 0, init_media);
+	mii_check_media(&lp->mii_if, 1, init_media);
 
 	if (lp->mii_if.full_duplex)
 		writel(readl(&lp->eth_regs->ethmac2) | ETH_MAC2_FD,
@@ -869,12 +886,15 @@ static int korina_init(struct net_device *dev)
 	 * Clock independent setting */
 	writel(((idt_cpu_freq) / MII_CLOCK + 1) & ~1,
 			&lp->eth_regs->ethmcp);
+	writel(0, &lp->eth_regs->miimcfg);
 
 	/* don't transmit until fifo contains 48b */
 	writel(48, &lp->eth_regs->ethfifott);
 
 	writel(ETH_MAC1_RE, &lp->eth_regs->ethmac1);
 
+	korina_check_media(dev, 1);
+
 	napi_enable(&lp->napi);
 	netif_start_queue(dev);
 
@@ -1089,11 +1109,10 @@ static int korina_probe(struct platform_device *pdev)
 	dev->watchdog_timeo = TX_TIMEOUT;
 	netif_napi_add(dev, &lp->napi, korina_poll, NAPI_POLL_WEIGHT);
 
-	lp->phy_addr = (((lp->rx_irq == 0x2c? 1:0) << 8) | 0x05);
 	lp->mii_if.dev = dev;
-	lp->mii_if.mdio_read = mdio_read;
-	lp->mii_if.mdio_write = mdio_write;
-	lp->mii_if.phy_id = lp->phy_addr;
+	lp->mii_if.mdio_read = korina_mdio_read;
+	lp->mii_if.mdio_write = korina_mdio_write;
+	lp->mii_if.phy_id = 1;
 	lp->mii_if.phy_id_mask = 0x1f;
 	lp->mii_if.reg_num_mask = 0x1f;
 
-- 
2.29.2

