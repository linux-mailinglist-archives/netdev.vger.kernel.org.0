Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BF031C810
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBPJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:27:15 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:45093 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhBPJ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:26:30 -0500
X-Originating-IP: 90.55.97.122
Received: from pc-2.home (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 6E0501BF20E;
        Tue, 16 Feb 2021 09:25:42 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next v2 2/2] net: mvneta: Implement mqprio support
Date:   Tue, 16 Feb 2021 10:25:36 +0100
Message-Id: <20210216092536.1153864-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210216092536.1153864-1-maxime.chevallier@bootlin.com>
References: <20210216092536.1153864-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a basic MQPrio support, inserting rules in RX that translate
the TC to prio mapping into vlan prio to queues.

The TX logic stays the same as when we don't offload the qdisc.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2 : Fixed the reverse xmas tree, as per Andrew's review.
     Fixed a compile warning from the ktest bot

 drivers/net/ethernet/marvell/mvneta.c | 61 +++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 8e410fafff8d..a635cf84608a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -102,6 +102,8 @@
 #define      MVNETA_TX_NO_DATA_SWAP              BIT(5)
 #define      MVNETA_DESC_SWAP                    BIT(6)
 #define      MVNETA_TX_BRST_SZ_MASK(burst)       ((burst) << 22)
+#define	MVNETA_VLAN_PRIO_TO_RXQ			 0x2440
+#define      MVNETA_VLAN_PRIO_RXQ_MAP(prio, rxq) ((rxq) << ((prio) * 3))
 #define MVNETA_PORT_STATUS                       0x2444
 #define      MVNETA_TX_IN_PRGRS                  BIT(1)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
@@ -490,6 +492,7 @@ struct mvneta_port {
 	u8 mcast_count[256];
 	u16 tx_ring_size;
 	u16 rx_ring_size;
+	u8 prio_tc_map[8];
 
 	phy_interface_t phy_interface;
 	struct device_node *dn;
@@ -4922,6 +4925,63 @@ static int mvneta_ethtool_set_eee(struct net_device *dev,
 	return phylink_ethtool_set_eee(pp->phylink, eee);
 }
 
+static void mvneta_clear_rx_prio_map(struct mvneta_port *pp)
+{
+	mvreg_write(pp, MVNETA_VLAN_PRIO_TO_RXQ, 0);
+}
+
+static void mvneta_setup_rx_prio_map(struct mvneta_port *pp)
+{
+	u32 val = 0;
+	int i;
+
+	for (i = 0; i < rxq_number; i++)
+		val |= MVNETA_VLAN_PRIO_RXQ_MAP(i, pp->prio_tc_map[i]);
+
+	mvreg_write(pp, MVNETA_VLAN_PRIO_TO_RXQ, val);
+}
+
+static int mvneta_setup_mqprio(struct net_device *dev,
+			       struct tc_mqprio_qopt *qopt)
+{
+	struct mvneta_port *pp = netdev_priv(dev);
+	u8 num_tc;
+	int i;
+
+	qopt->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	num_tc = qopt->num_tc;
+
+	if (num_tc > rxq_number)
+		return -EINVAL;
+
+	if (!num_tc) {
+		mvneta_clear_rx_prio_map(pp);
+		netdev_reset_tc(dev);
+		return 0;
+	}
+
+	memcpy(pp->prio_tc_map, qopt->prio_tc_map, sizeof(pp->prio_tc_map));
+
+	mvneta_setup_rx_prio_map(pp);
+
+	netdev_set_num_tc(dev, qopt->num_tc);
+	for (i = 0; i < qopt->num_tc; i++)
+		netdev_set_tc_queue(dev, i, qopt->count[i], qopt->offset[i]);
+
+	return 0;
+}
+
+static int mvneta_setup_tc(struct net_device *dev, enum tc_setup_type type,
+			   void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return mvneta_setup_mqprio(dev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_open            = mvneta_open,
 	.ndo_stop            = mvneta_stop,
@@ -4934,6 +4994,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_do_ioctl        = mvneta_ioctl,
 	.ndo_bpf	     = mvneta_xdp,
 	.ndo_xdp_xmit        = mvneta_xdp_xmit,
+	.ndo_setup_tc	     = mvneta_setup_tc,
 };
 
 static const struct ethtool_ops mvneta_eth_tool_ops = {
-- 
2.25.4

