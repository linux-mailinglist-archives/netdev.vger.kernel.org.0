Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE17F2CED
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbfKGLAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:00:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44813 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387927AbfKGLAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 06:00:52 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX1-0004bU-2H; Thu, 07 Nov 2019 12:00:51 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX0-0003en-3d; Thu, 07 Nov 2019 12:00:50 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Tristram.Ha@microchip.com, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: [PATCH v1 2/4] net: tag: ksz: Add KSZ8863 tag code
Date:   Thu,  7 Nov 2019 12:00:28 +0100
Message-Id: <20191107110030.25199-3-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
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

Add DSA tag code for the Microchip KSZ8863 switch.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9507611a41f07..911f07ec40e3a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -42,6 +42,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_8021Q_VALUE		12
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
+#define DSA_TAG_PROTO_KSZ8863_VALUE		15
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -59,6 +60,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
+	DSA_TAG_PROTO_KSZ8863		= DSA_TAG_PROTO_KSZ8863_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 73605bcbb3851..08ea996af3c34 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -243,8 +243,68 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
+	u16 *tag;
+
+	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
+	if (!nskb)
+		return NULL;
+
+	/* Tag encoding */
+	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
+
+	*tag = 1 << (dp->index); /* destination port */
+	*tag = cpu_to_be16(*tag);
+
+	return nskb;
+}
+
+static struct sk_buff *ksz8863_rcv(struct sk_buff *skb, struct net_device *dev,
+				   struct packet_type *pt)
+{
+	/* Tag decoding */
+	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+	unsigned int port = tag[0] & 1;
+	unsigned int len = KSZ_EGRESS_TAG_LEN;
+
+	return ksz_common_rcv(skb, dev, port, len);
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
2.24.0.rc1

