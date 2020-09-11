Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2F265B89
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgIKI0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKIZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:25:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C2DC061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:25:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeNB-0002LH-Fx; Fri, 11 Sep 2020 10:25:33 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeN7-00074b-OJ; Fri, 11 Sep 2020 10:25:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] net: ag71xx: add ethtool support
Date:   Fri, 11 Sep 2020 10:25:27 +0200
Message-Id: <20200911082528.27121-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911082528.27121-1-o.rempel@pengutronix.de>
References: <20200911082528.27121-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic ethtool support. The functionality was tested on AR9331 SoC.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 147 ++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 38cce66ef212..8c80a87aee58 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -235,6 +235,59 @@
 	| NETIF_MSG_RX_ERR		\
 	| NETIF_MSG_TX_ERR)
 
+struct ag71xx_statistic {
+	unsigned short offset;
+	u32 mask;
+	const char name[ETH_GSTRING_LEN];
+};
+
+static const struct ag71xx_statistic ag71xx_statistics[] = {
+	{ 0x0080, GENMASK(17, 0), "Tx/Rx 64 Byte", },
+	{ 0x0084, GENMASK(17, 0), "Tx/Rx 65-127 Byte", },
+	{ 0x0088, GENMASK(17, 0), "Tx/Rx 128-255 Byte", },
+	{ 0x008C, GENMASK(17, 0), "Tx/Rx 256-511 Byte", },
+	{ 0x0090, GENMASK(17, 0), "Tx/Rx 512-1023 Byte", },
+	{ 0x0094, GENMASK(17, 0), "Tx/Rx 1024-1518 Byte", },
+	{ 0x0098, GENMASK(17, 0), "Tx/Rx 1519-1522 Byte VLAN", },
+	{ 0x009C, GENMASK(23, 0), "Rx Byte", },
+	{ 0x00A0, GENMASK(17, 0), "Rx Packet", },
+	{ 0x00A4, GENMASK(11, 0), "Rx FCS Error", },
+	{ 0x00A8, GENMASK(17, 0), "Rx Multicast Packet", },
+	{ 0x00AC, GENMASK(21, 0), "Rx Broadcast Packet", },
+	{ 0x00B0, GENMASK(17, 0), "Rx Control Frame Packet", },
+	{ 0x00B4, GENMASK(11, 0), "Rx Pause Frame Packet", },
+	{ 0x00B8, GENMASK(11, 0), "Rx Unknown OPCode Packet", },
+	{ 0x00BC, GENMASK(11, 0), "Rx Alignment Error", },
+	{ 0x00C0, GENMASK(15, 0), "Rx Frame Length Error", },
+	{ 0x00C4, GENMASK(11, 0), "Rx Code Error", },
+	{ 0x00C8, GENMASK(11, 0), "Rx Carrier Sense Error", },
+	{ 0x00CC, GENMASK(11, 0), "Rx Undersize Packet", },
+	{ 0x00D0, GENMASK(11, 0), "Rx Oversize Packet", },
+	{ 0x00D4, GENMASK(11, 0), "Rx Fragments", },
+	{ 0x00D8, GENMASK(11, 0), "Rx Jabber", },
+	{ 0x00DC, GENMASK(11, 0), "Rx Dropped Packet", },
+	{ 0x00E0, GENMASK(23, 0), "Tx Byte", },
+	{ 0x00E4, GENMASK(17, 0), "Tx Packet", },
+	{ 0x00E8, GENMASK(17, 0), "Tx Multicast Packet", },
+	{ 0x00EC, GENMASK(17, 0), "Tx Broadcast Packet", },
+	{ 0x00F0, GENMASK(11, 0), "Tx Pause Control Frame", },
+	{ 0x00F4, GENMASK(11, 0), "Tx Deferral Packet", },
+	{ 0x00F8, GENMASK(11, 0), "Tx Excessive Deferral Packet", },
+	{ 0x00FC, GENMASK(11, 0), "Tx Single Collision Packet", },
+	{ 0x0100, GENMASK(11, 0), "Tx Multiple Collision", },
+	{ 0x0104, GENMASK(11, 0), "Tx Late Collision Packet", },
+	{ 0x0108, GENMASK(11, 0), "Tx Excessive Collision Packet", },
+	{ 0x010C, GENMASK(12, 0), "Tx Total Collision", },
+	{ 0x0110, GENMASK(11, 0), "Tx Pause Frames Honored", },
+	{ 0x0114, GENMASK(11, 0), "Tx Drop Frame", },
+	{ 0x0118, GENMASK(11, 0), "Tx Jabber Frame", },
+	{ 0x011C, GENMASK(11, 0), "Tx FCS Error", },
+	{ 0x0120, GENMASK(11, 0), "Tx Control Frame", },
+	{ 0x0124, GENMASK(11, 0), "Tx Oversize Frame", },
+	{ 0x0128, GENMASK(11, 0), "Tx Undersize Frame", },
+	{ 0x012C, GENMASK(11, 0), "Tx Fragment", },
+};
+
 #define DESC_EMPTY		BIT(31)
 #define DESC_MORE		BIT(24)
 #define DESC_PKTLEN_M		0xfff
@@ -394,6 +447,99 @@ static void ag71xx_int_disable(struct ag71xx *ag, u32 ints)
 	ag71xx_cb(ag, AG71XX_REG_INT_ENABLE, ints);
 }
 
+static void ag71xx_get_drvinfo(struct net_device *ndev,
+			       struct ethtool_drvinfo *info)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	strlcpy(info->driver, "ag71xx", sizeof(info->driver));
+	strlcpy(info->bus_info, of_node_full_name(ag->pdev->dev.of_node),
+		sizeof(info->bus_info));
+}
+
+static int ag71xx_get_link_ksettings(struct net_device *ndev,
+				   struct ethtool_link_ksettings *kset)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(ag->phylink, kset);
+}
+
+static int ag71xx_set_link_ksettings(struct net_device *ndev,
+				   const struct ethtool_link_ksettings *kset)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(ag->phylink, kset);
+}
+
+static int ag71xx_ethtool_nway_reset(struct net_device *ndev)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	return phylink_ethtool_nway_reset(ag->phylink);
+}
+
+static void ag71xx_ethtool_get_pauseparam(struct net_device *ndev,
+					  struct ethtool_pauseparam *pause)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	phylink_ethtool_get_pauseparam(ag->phylink, pause);
+}
+
+static int ag71xx_ethtool_set_pauseparam(struct net_device *ndev,
+					 struct ethtool_pauseparam *pause)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+
+	return phylink_ethtool_set_pauseparam(ag->phylink, pause);
+}
+
+static void ag71xx_ethtool_get_strings(struct net_device *netdev, u32 sset,
+				       u8 *data)
+{
+	if (sset == ETH_SS_STATS) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(ag71xx_statistics); i++)
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       ag71xx_statistics[i].name, ETH_GSTRING_LEN);
+	}
+}
+
+static void ag71xx_ethtool_get_stats(struct net_device *ndev,
+				     struct ethtool_stats *stats, u64 *data)
+{
+	struct ag71xx *ag = netdev_priv(ndev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ag71xx_statistics); i++)
+		*data++ = ag71xx_rr(ag, ag71xx_statistics[i].offset)
+				& ag71xx_statistics[i].mask;
+}
+
+static int ag71xx_ethtool_get_sset_count(struct net_device *ndev, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ARRAY_SIZE(ag71xx_statistics);
+	return -EOPNOTSUPP;
+}
+
+static const struct ethtool_ops ag71xx_ethtool_ops = {
+	.get_drvinfo			= ag71xx_get_drvinfo,
+	.get_link			= ethtool_op_get_link,
+	.get_ts_info			= ethtool_op_get_ts_info,
+	.get_link_ksettings		= ag71xx_get_link_ksettings,
+	.set_link_ksettings		= ag71xx_set_link_ksettings,
+	.nway_reset			= ag71xx_ethtool_nway_reset,
+	.get_pauseparam			= ag71xx_ethtool_get_pauseparam,
+	.set_pauseparam			= ag71xx_ethtool_set_pauseparam,
+	.get_strings			= ag71xx_ethtool_get_strings,
+	.get_ethtool_stats		= ag71xx_ethtool_get_stats,
+	.get_sset_count			= ag71xx_ethtool_get_sset_count,
+};
+
 static int ag71xx_mdio_wait_busy(struct ag71xx *ag)
 {
 	struct net_device *ndev = ag->ndev;
@@ -1769,6 +1915,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	}
 
 	ndev->netdev_ops = &ag71xx_netdev_ops;
+	ndev->ethtool_ops = &ag71xx_ethtool_ops;
 
 	INIT_DELAYED_WORK(&ag->restart_work, ag71xx_restart_work_func);
 	timer_setup(&ag->oom_timer, ag71xx_oom_timer_handler, 0);
-- 
2.28.0

