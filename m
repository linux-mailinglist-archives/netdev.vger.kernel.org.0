Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F05E368E54
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbhDWIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241360AbhDWIDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:03:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1409C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:02:32 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZqld-0007au-Or; Fri, 23 Apr 2021 10:02:25 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZqlY-0006wM-2C; Fri, 23 Apr 2021 10:02:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v6 10/10] net: tag: ksz: Add KSZ8863 tag code
Date:   Fri, 23 Apr 2021 10:02:18 +0200
Message-Id: <20210423080218.26526-11-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423080218.26526-1-o.rempel@pengutronix.de>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Add DSA tag code for Microchip KSZ8863 switch.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

---
v1 -> v2: - fixed __be16 handling
v2 -> v3: - no changes
v3 -> v4: - changed handling to only one padding byte
v4 -> v5: - incremented DSA_TAG_PROTO_KSZ8863_VALUE
          - using tail_tag = true instead of ksz_common_xmit preallocation
---
 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 507082959aa4..9c8c2b6f0571 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -50,6 +50,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
+#define DSA_TAG_PROTO_KSZ8863_VALUE		23
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -75,6 +76,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
+	DSA_TAG_PROTO_KSZ8863		= DSA_TAG_PROTO_KSZ8863_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..2a06d4087738 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -190,8 +190,60 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
+/* For ingress (Host -> KSZ8863), 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0[1,0] : represents port
+ *             (e.g. 0b00=addr-lookup 0b01=port1, 0b10=port2, 0b11=port1+port2)
+ * tag0[3,2] : bits two and three represent prioritization
+ *             (e.g. 0b00xx=prio0, 0b01xx=prio1, 0b10xx=prio2, 0b11xx=prio3)
+ *
+ * For egress (KSZ8873 -> Host), 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0[0]   : zero-based value represents port
+ *             (eg, 0b0=port1, 0b1=port2)
+ */
+
+static struct sk_buff *ksz8863_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	/* Tag encoding */
+	u8 *tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+
+	*tag = BIT(dp->index); /* destination port */
+
+	return skb;
+}
+
+static struct sk_buff *ksz8863_rcv(struct sk_buff *skb, struct net_device *dev,
+				   struct packet_type *pt)
+{
+	/* Tag decoding */
+	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+
+	return ksz_common_rcv(skb, dev, tag[0] & 1, KSZ_EGRESS_TAG_LEN);
+}
+
+static const struct dsa_device_ops ksz8863_netdev_ops = {
+	.name	= "ksz8863",
+	.proto	= DSA_TAG_PROTO_KSZ8863,
+	.xmit	= ksz8863_xmit,
+	.rcv	= ksz8863_rcv,
+	.overhead = KSZ_INGRESS_TAG_LEN,
+	.tail_tag = true,
+};
+
+DSA_TAG_DRIVER(ksz8863_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8863);
+
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(ksz8863_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
 };
-- 
2.29.2

