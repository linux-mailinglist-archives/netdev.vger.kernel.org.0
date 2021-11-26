Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D980545EC88
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 12:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbhKZL0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:26:19 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:60257 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239198AbhKZLYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:24:19 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 70D83100005;
        Fri, 26 Nov 2021 11:21:04 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/4] net: mvneta: Allow having more than one queue per TC
Date:   Fri, 26 Nov 2021 12:20:55 +0100
Message-Id: <20211126112056.849123-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
References: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mqprio implementation assumed that we are only using one
queue per TC. Use the offset and count parameters to allow using
multiple queues per TC. In that case, the controller will use a standard
round-robin algorithm to pick queues assigned to the same TC, with the
same priority.

This only applies to VLAN priorities in ingress traffic, each TC
corresponding to a vlan priority.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2 : No changes

 drivers/net/ethernet/marvell/mvneta.c | 35 +++++++++++++++------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index d3ce87e69d2a..aba452e8abfe 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -493,7 +493,6 @@ struct mvneta_port {
 	u8 mcast_count[256];
 	u16 tx_ring_size;
 	u16 rx_ring_size;
-	u8 prio_tc_map[8];
 
 	phy_interface_t phy_interface;
 	struct device_node *dn;
@@ -4897,13 +4896,12 @@ static void mvneta_clear_rx_prio_map(struct mvneta_port *pp)
 	mvreg_write(pp, MVNETA_VLAN_PRIO_TO_RXQ, 0);
 }
 
-static void mvneta_setup_rx_prio_map(struct mvneta_port *pp)
+static void mvneta_map_vlan_prio_to_rxq(struct mvneta_port *pp, u8 pri, u8 rxq)
 {
-	u32 val = 0;
-	int i;
+	u32 val = mvreg_read(pp, MVNETA_VLAN_PRIO_TO_RXQ);
 
-	for (i = 0; i < rxq_number; i++)
-		val |= MVNETA_VLAN_PRIO_RXQ_MAP(i, pp->prio_tc_map[i]);
+	val &= ~MVNETA_VLAN_PRIO_RXQ_MAP(pri, 0x7);
+	val |= MVNETA_VLAN_PRIO_RXQ_MAP(pri, rxq);
 
 	mvreg_write(pp, MVNETA_VLAN_PRIO_TO_RXQ, val);
 }
@@ -4912,8 +4910,8 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 			       struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
+	int rxq, tc;
 	u8 num_tc;
-	int i;
 
 	if (mqprio->qopt.hw != TC_MQPRIO_HW_OFFLOAD_TCS)
 		return 0;
@@ -4923,21 +4921,28 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 	if (num_tc > rxq_number)
 		return -EINVAL;
 
+	mvneta_clear_rx_prio_map(pp);
+
 	if (!num_tc) {
-		mvneta_clear_rx_prio_map(pp);
 		netdev_reset_tc(dev);
 		return 0;
 	}
 
-	memcpy(pp->prio_tc_map, mqprio->qopt.prio_tc_map,
-	       sizeof(pp->prio_tc_map));
+	netdev_set_num_tc(dev, mqprio->qopt.num_tc);
+
+	for (tc = 0; tc < mqprio->qopt.num_tc; tc++) {
+		netdev_set_tc_queue(dev, tc, mqprio->qopt.count[tc],
+				    mqprio->qopt.offset[tc]);
 
-	mvneta_setup_rx_prio_map(pp);
+		for (rxq = mqprio->qopt.offset[tc];
+		     rxq < mqprio->qopt.count[tc] + mqprio->qopt.offset[tc];
+		     rxq++) {
+			if (rxq >= rxq_number)
+				return -EINVAL;
 
-	netdev_set_num_tc(dev, mqprio->qopt.num_tc);
-	for (i = 0; i < mqprio->qopt.num_tc; i++)
-		netdev_set_tc_queue(dev, i, mqprio->qopt.count[i],
-				    mqprio->qopt.offset[i]);
+			mvneta_map_vlan_prio_to_rxq(pp, tc, rxq);
+		}
+	}
 
 	return 0;
 }
-- 
2.25.4

