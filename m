Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C5239F38
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgHCFpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgHCFpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F09FC061756
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005J5-FA; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THK-0005U2-U5; Mon, 03 Aug 2020 07:44:54 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 03/11] net: tag: ksz: Add KSZ8863 tag code
Date:   Mon,  3 Aug 2020 07:44:34 +0200
Message-Id: <20200803054442.20089-4-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DSA tag code for Microchip KSZ8863 switch.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - fixed __be16 handling
v2 -> v3: - no changes
v3 -> v4: - changed handling to only one padding byte

 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 75c8fac82017444..321ecbee0834f5e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -45,6 +45,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_OCELOT_VALUE		15
 #define DSA_TAG_PROTO_AR9331_VALUE		16
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
+#define DSA_TAG_PROTO_KSZ8863_VALUE		18
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -65,6 +66,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
 	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
+	DSA_TAG_PROTO_KSZ8863		= DSA_TAG_PROTO_KSZ8863_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index bd1a3158d79a85f..fb9cc0e84288782 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -242,8 +242,65 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
+	struct sk_buff *nskb;
+	u8 *tag;
+
+	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
+	if (!nskb)
+		return NULL;
+
+	/* Tag encoding */
+	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
+
+	*tag = BIT(dp->index); /* destination port */
+
+	return nskb;
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
2.28.0

