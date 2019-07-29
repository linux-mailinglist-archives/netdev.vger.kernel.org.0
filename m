Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8D792A3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfG2RxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:53:19 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59599 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbfG2RxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:53:18 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45y6jl0hvrz1rMXL;
        Mon, 29 Jul 2019 19:53:15 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45y6jk71kzz1qqkS;
        Mon, 29 Jul 2019 19:53:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id XiRUH8DuEmVE; Mon, 29 Jul 2019 19:53:13 +0200 (CEST)
X-Auth-Info: Yf5M2fmrvudPV2ix3pP+GlGrVwXHZyZd/cgHz9U7QFo=
Received: from kurokawa.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 29 Jul 2019 19:53:13 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Tristram Ha <Tristram.Ha@microchip.com>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH V4 2/3] net: dsa: ksz: Add KSZ8795 tag code
Date:   Mon, 29 Jul 2019 19:49:46 +0200
Message-Id: <20190729174947.10103-3-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729174947.10103-1-marex@denx.de>
References: <20190729174947.10103-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tristram Ha <Tristram.Ha@microchip.com>

Add DSA tag code for Microchip KSZ8795 switch. The switch is simpler
and the tag is only 1 byte, instead of 2 as is the case with KSZ9477.

Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
V2: No change
V3: No change
V4: Drop Kconfig entry
---
 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1e8650fa8acc..147b757ef8ea 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -41,6 +41,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_TRAILER_VALUE		11
 #define DSA_TAG_PROTO_8021Q_VALUE		12
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
+#define DSA_TAG_PROTO_KSZ8795_VALUE		14
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -57,6 +58,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_TRAILER		= DSA_TAG_PROTO_TRAILER_VALUE,
 	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
+	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index adc6c1e03a4c..7af71db91c54 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -69,6 +69,67 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+/*
+ * For Ingress (Host -> KSZ8795), 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
+ *
+ * For Egress (KSZ8795 -> Host), 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : zero-based value represents port
+ *	  (eg, 0x00=port1, 0x02=port3, 0x06=port7)
+ */
+
+#define KSZ8795_INGRESS_TAG_LEN		1
+
+#define KSZ8795_TAIL_TAG_OVERRIDE	BIT(6)
+#define KSZ8795_TAIL_TAG_LOOKUP		BIT(7)
+
+static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct sk_buff *nskb;
+	u8 *tag;
+	u8 *addr;
+
+	nskb = ksz_common_xmit(skb, dev, KSZ8795_INGRESS_TAG_LEN);
+	if (!nskb)
+		return NULL;
+
+	/* Tag encoding */
+	tag = skb_put(nskb, KSZ8795_INGRESS_TAG_LEN);
+	addr = skb_mac_header(nskb);
+
+	*tag = 1 << dp->index;
+	if (is_link_local_ether_addr(addr))
+		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
+
+	return nskb;
+}
+
+static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
+				  struct packet_type *pt)
+{
+	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+
+	return ksz_common_rcv(skb, dev, tag[0] & 7, KSZ_EGRESS_TAG_LEN);
+}
+
+static const struct dsa_device_ops ksz8795_netdev_ops = {
+	.name	= "ksz8795",
+	.proto	= DSA_TAG_PROTO_KSZ8795,
+	.xmit	= ksz8795_xmit,
+	.rcv	= ksz8795_rcv,
+	.overhead = KSZ8795_INGRESS_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(ksz8795_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
+
 /*
  * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
  * ---------------------------------------------------------------------------
@@ -183,6 +244,7 @@ DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
+	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
 };
-- 
2.20.1

