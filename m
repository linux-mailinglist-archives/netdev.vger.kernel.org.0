Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20F045F2F1
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhKZRdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:33:17 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:59119 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhKZRbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:31:08 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2A587240004;
        Fri, 26 Nov 2021 17:27:53 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v3 3/4] net: ocelot: pre-compute injection frame header content
Date:   Fri, 26 Nov 2021 18:27:38 +0100
Message-Id: <20211126172739.329098-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211126172739.329098-1-clement.leger@bootlin.com>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFH preparation can take quite some time on slow processors (up to 5% in
a iperf3 test for instance). In order to reduce the cost of this
preparation, pre-compute IFH since most of the parameters are fixed per
port. Only rew_op and vlan tag will be set when sending if different
than 0. This allows to remove entirely the calls to packing() with basic
usage. In the same time, export this function that will be used by FDMA.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 23 ++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  5 +++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6c18b598d5c..1f7c9ff18ac5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1076,20 +1076,29 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 }
 EXPORT_SYMBOL(ocelot_can_inject);
 
+void ocelot_ifh_port_set(void *ifh, struct ocelot_port *ocelot_port, u32 rew_op,
+			 u32 vlan_tag)
+{
+	memcpy(ifh, ocelot_port->ifh, OCELOT_TAG_LEN);
+
+	if (vlan_tag)
+		ocelot_ifh_set_vlan_tci(ifh, vlan_tag);
+	if (rew_op)
+		ocelot_ifh_set_rew_op(ifh, rew_op);
+}
+EXPORT_SYMBOL(ocelot_ifh_port_set);
+
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 ifh[OCELOT_TAG_LEN / 4] = {0};
 	unsigned int i, count, last;
 
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
-	ocelot_ifh_set_bypass(ifh, 1);
-	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
-	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
-	ocelot_ifh_set_vlan_tci(ifh, skb_vlan_tag_get(skb));
-	ocelot_ifh_set_rew_op(ifh, rew_op);
+	ocelot_ifh_port_set(ifh, ocelot_port, rew_op, skb_vlan_tag_get(skb));
 
 	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
 		ocelot_write_rix(ocelot, ifh[i], QS_INJ_WR, grp);
@@ -2128,6 +2137,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 
 	skb_queue_head_init(&ocelot_port->tx_skbs);
 
+	ocelot_ifh_set_bypass(ocelot_port->ifh, 1);
+	ocelot_ifh_set_dest(ocelot_port->ifh, BIT_ULL(port));
+	ocelot_ifh_set_tag_type(ocelot_port->ifh, IFH_TAG_TYPE_C);
+
 	/* Basic L2 initialization */
 
 	/* Set MAC IFG Gaps
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fef3a36b0210..b3381c90ff3e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -6,6 +6,7 @@
 #define _SOC_MSCC_OCELOT_H
 
 #include <linux/ptp_clock_kernel.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/net_tstamp.h>
 #include <linux/if_vlan.h>
 #include <linux/regmap.h>
@@ -623,6 +624,8 @@ struct ocelot_port {
 
 	struct net_device		*bridge;
 	u8				stp_state;
+
+	u8				ifh[OCELOT_TAG_LEN];
 };
 
 struct ocelot {
@@ -754,6 +757,8 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32 rew_op,
+			 u32 vlan_tag);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-- 
2.33.1

