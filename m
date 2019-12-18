Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235F91252B8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLRUIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:08:40 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfLRUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:08:40 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcc-0004WS-M3; Wed, 18 Dec 2019 21:08:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcb-0004bX-7G; Wed, 18 Dec 2019 21:08:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v2 2/4] net: tag: ksz: Add KSZ8863 tag code
Date:   Wed, 18 Dec 2019 21:08:29 +0100
Message-Id: <20191218200831.13796-3-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
References: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
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

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
v1 -> v2: - fixed __be16 handling

 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 65f23b9e286b8..a3e4ec4869738 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -43,6 +43,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
 #define DSA_TAG_PROTO_OCELOT_VALUE		15
+#define DSA_TAG_PROTO_KSZ8863_VALUE		16
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -61,6 +62,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
 	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
+	DSA_TAG_PROTO_KSZ8863		= DSA_TAG_PROTO_KSZ8863_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0afd2fa424504..efdcbe2f29ae7 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -242,8 +242,65 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
+/* For ingress (Host -> KSZ8863), 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
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
+	__be16 *tag;
+
+	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
+	if (!nskb)
+		return NULL;
+
+	/* Tag encoding */
+	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
+
+	*tag = cpu_to_be16(1 << (dp->index)); /* destination port */
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
2.24.0

