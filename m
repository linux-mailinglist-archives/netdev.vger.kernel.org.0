Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7937175146
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCBASv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 19:18:51 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:24544 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgCBASv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 19:18:51 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 48W12w2rHgzQlFB;
        Mon,  2 Mar 2020 01:18:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id wmcl0QbDLzLi; Mon,  2 Mar 2020 01:18:45 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ag71xx: Configure Ethernet interface
Date:   Mon,  2 Mar 2020 01:18:30 +0100
Message-Id: <20200302001830.14278-2-hauke@hauke-m.de>
In-Reply-To: <20200302001830.14278-1-hauke@hauke-m.de>
References: <20200302001830.14278-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the Ethernet interface when the register range is provided.

The GMAC0 of the AR9330 and AR9340 can be operated in different modes,
like MII, RMII, GMII and RGMII. This allows to configure this mode in
the interface register block.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 76 +++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 69125f870363..7ef16fdd6617 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -64,6 +64,14 @@
 #define AG71XX_MDIO_DELAY	5
 #define AG71XX_MDIO_MAX_CLK	5000000
 
+/* GMAC Interface Registers */
+#define AG71XX_GMAC_REG_ETH_CFG	0x00
+#define ETH_CFG_RGMII_GE0	BIT(0)
+#define ETH_CFG_MII_GE0		BIT(1)
+#define ETH_CFG_GMII_GE0	BIT(2)
+#define ETH_CFG_RMII_GE0_AR933X	BIT(9)
+#define ETH_CFG_RMII_GE0_AR934X	BIT(10)
+
 /* Register offsets */
 #define AG71XX_REG_MAC_CFG1	0x0000
 #define MAC_CFG1_TXE		BIT(0)	/* Tx Enable */
@@ -311,6 +319,8 @@ struct ag71xx {
 	/* From this point onwards we're not looking at per-packet fields. */
 	void __iomem *mac_base;
 
+	void __iomem *inf_base;
+
 	struct ag71xx_desc *stop_desc;
 	dma_addr_t stop_desc_dma;
 
@@ -364,6 +374,18 @@ static u32 ag71xx_rr(struct ag71xx *ag, unsigned int reg)
 	return ioread32(ag->mac_base + reg);
 }
 
+static void ag71xx_inf_wr(struct ag71xx *ag, unsigned int reg, u32 value)
+{
+	iowrite32(value, ag->inf_base + reg);
+	/* flush write */
+	(void)ioread32(ag->inf_base + reg);
+}
+
+static u32 ag71xx_inf_rr(struct ag71xx *ag, unsigned int reg)
+{
+	return ioread32(ag->inf_base + reg);
+}
+
 static void ag71xx_sb(struct ag71xx *ag, unsigned int reg, u32 mask)
 {
 	void __iomem *r;
@@ -848,6 +870,52 @@ static void ag71xx_hw_start(struct ag71xx *ag)
 	netif_wake_queue(ag->ndev);
 }
 
+static void ag71xx_mac_config_inf(struct ag71xx *ag,
+				  const struct phylink_link_state *state)
+{
+	u32 val;
+
+	if (!ag71xx_is(ag, AR9330) && !ag71xx_is(ag, AR9340))
+		return;
+
+	val = ag71xx_inf_rr(ag, AG71XX_GMAC_REG_ETH_CFG);
+
+	val &= ~ETH_CFG_MII_GE0;
+	val &= ~ETH_CFG_GMII_GE0;
+	val &= ~ETH_CFG_RGMII_GE0;
+	if (ag71xx_is(ag, AR9330))
+		val &= ~ETH_CFG_RMII_GE0_AR933X;
+	else
+		val &= ~ETH_CFG_RMII_GE0_AR934X;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		val |= ETH_CFG_MII_GE0;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (ag71xx_is(ag, AR9330))
+			val |= ETH_CFG_RMII_GE0_AR933X;
+		else
+			val |= ETH_CFG_RMII_GE0_AR934X;
+		break;
+	case PHY_INTERFACE_MODE_GMII:
+		val |= ETH_CFG_GMII_GE0;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val |= ETH_CFG_RGMII_GE0;
+		break;
+	default:
+		netif_err(ag, link, ag->ndev,
+			  "Unsupported interface: %d\n",
+			  state->interface);
+		return;
+	}
+	ag71xx_inf_wr(ag, AG71XX_GMAC_REG_ETH_CFG, val);
+}
+
 static void ag71xx_mac_config(struct phylink_config *config, unsigned int mode,
 			      const struct phylink_link_state *state)
 {
@@ -859,6 +927,9 @@ static void ag71xx_mac_config(struct phylink_config *config, unsigned int mode,
 	if (!ag71xx_is(ag, AR7100) && !ag71xx_is(ag, AR9130))
 		ag71xx_fast_reset(ag);
 
+	if (ag->inf_base)
+		ag71xx_mac_config_inf(ag, state);
+
 	if (ag->tx_ring.desc_split) {
 		ag->fifodata[2] &= 0xffff;
 		ag->fifodata[2] |= ((2048 - ag->tx_ring.desc_split) / 4) << 16;
@@ -1703,6 +1774,11 @@ static int ag71xx_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* The interface resource is optional */
+	ag->inf_base = devm_platform_ioremap_resource_byname(pdev, "interface");
+	if (IS_ERR(ag->inf_base) && PTR_ERR(ag->inf_base) != -ENOENT)
+		return PTR_ERR(ag->inf_base);
+
 	ag->clk_eth = devm_clk_get(&pdev->dev, "eth");
 	if (IS_ERR(ag->clk_eth)) {
 		netif_err(ag, probe, ndev, "Failed to get eth clk.\n");
-- 
2.20.1

