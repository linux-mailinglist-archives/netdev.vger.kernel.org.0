Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A948296D26
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462588AbgJWK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462568AbgJWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B86FC0613D5
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:40 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087s-Kr; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001kw-I7; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 6/6] can: flexcan: add ethtool support
Date:   Fri, 23 Oct 2020 12:56:26 +0200
Message-Id: <20201023105626.6534-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/can/flexcan.c | 111 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c320eed31322..8f487ac37f5e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -247,6 +247,11 @@
 /* support memory detection and correction */
 #define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
 
+#define FLEXCAN_DEFAULT_MSG_ENABLE \
+	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK | NETIF_MSG_TIMER \
+	 NETIF_MSG_IFDOWN | NETIF_MSG_IFUP | NETIF_MSG_RX_ERR | \
+	 NETIF_MSG_TX_ERR)
+
 /* Structure of the message buffer */
 struct flexcan_mb {
 	u32 can_ctrl;
@@ -369,6 +374,18 @@ struct flexcan_priv {
 	phy_interface_t phy_if_mode;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
+	u32 msg_enable;
+};
+
+struct flexcan_statistic {
+	unsigned short offset;
+	u32 mask;
+	const char name[ETH_GSTRING_LEN];
+};
+
+static const struct flexcan_statistic flexcan_statistics[] = {
+	{ 0x001c, GENMASK(15, 7), "RX_ERR", },
+	{ 0x001c, GENMASK(7, 0), "TX_ERR", },
 };
 
 static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
@@ -492,6 +509,98 @@ static inline void flexcan_write_le(u32 val, void __iomem *addr)
 	iowrite32(val, addr);
 }
 
+static void flexcan_get_drvinfo(struct net_device *ndev,
+			       struct ethtool_drvinfo *info)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	strlcpy(info->driver, "flexcan", sizeof(info->driver));
+	strlcpy(info->bus_info, of_node_full_name(priv->dev->of_node),
+		sizeof(info->bus_info));
+}
+
+static int flexcan_get_link_ksettings(struct net_device *ndev,
+				   struct ethtool_link_ksettings *kset)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(priv->phylink, kset);
+}
+
+static int flexcan_set_link_ksettings(struct net_device *ndev,
+				   const struct ethtool_link_ksettings *kset)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(priv->phylink, kset);
+}
+
+static int flexcan_ethtool_nway_reset(struct net_device *ndev)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	return phylink_ethtool_nway_reset(priv->phylink);
+}
+
+static void flexcan_set_msglevel(struct net_device *ndev, u32 value)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	priv->msg_enable = value;
+}
+
+static u32 flexcan_get_msglevel(struct net_device *ndev)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	return priv->msg_enable;
+}
+
+static void flexcan_ethtool_get_strings(struct net_device *netdev, u32 sset,
+				       u8 *data)
+{
+	if (sset == ETH_SS_STATS) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(flexcan_statistics); i++)
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       flexcan_statistics[i].name, ETH_GSTRING_LEN);
+	}
+}
+
+static void flexcan_ethtool_get_stats(struct net_device *ndev,
+				     struct ethtool_stats *stats, u64 *data)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(flexcan_statistics); i++)
+		*data++ = u32_get_bits(priv->read(regs + flexcan_statistics[i].offset),
+					flexcan_statistics[i].mask);
+}
+
+static int flexcan_ethtool_get_sset_count(struct net_device *ndev, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ARRAY_SIZE(flexcan_statistics);
+	return -EOPNOTSUPP;
+}
+
+static const struct ethtool_ops flexcan_ethtool_ops = {
+	.get_drvinfo			= flexcan_get_drvinfo,
+	.get_link			= ethtool_op_get_link,
+	.get_ts_info			= ethtool_op_get_ts_info,
+	.get_link_ksettings		= flexcan_get_link_ksettings,
+	.set_link_ksettings		= flexcan_set_link_ksettings,
+	.nway_reset			= flexcan_ethtool_nway_reset,
+	.get_msglevel			= flexcan_get_msglevel,
+	.set_msglevel			= flexcan_set_msglevel,
+	.get_strings			= flexcan_ethtool_get_strings,
+	.get_ethtool_stats		= flexcan_ethtool_get_stats,
+	.get_sset_count			= flexcan_ethtool_get_sset_count,
+};
+
 static struct flexcan_mb __iomem *flexcan_get_mb(const struct flexcan_priv *priv,
 						 u8 mb_index)
 {
@@ -2122,6 +2231,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	dev->netdev_ops = &flexcan_netdev_ops;
+	dev->ethtool_ops = &flexcan_ethtool_ops;
 	dev->irq = irq;
 	dev->flags |= IFF_ECHO;
 
@@ -2150,6 +2260,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
 	priv->phy_if_mode = phy_if_mode;
+	priv->msg_enable = netif_msg_init(-1, FLEXCAN_DEFAULT_MSG_ENABLE);
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
-- 
2.28.0

