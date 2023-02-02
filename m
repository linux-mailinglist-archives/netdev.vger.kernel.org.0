Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B1F687E11
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjBBM6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjBBM6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:58:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391E9193;
        Thu,  2 Feb 2023 04:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342725; x=1706878725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogFJQVXNUNjBJFqygmk4PZfTb+58Qo0jzOmynUcXT5E=;
  b=b7sk/bTFs4uWkfgljUvjTTDCvgkijFrsOuWdvDuQc4vlLozMiq0sIqC4
   5lODoQ9YD3JYaV2a4SdangD706lTYBID1m4fOP1dliB1e30UEgGDUrG8j
   jUiy4m/pfIdpl+lgRYTCInY3oHrs4vLcAO2a3KoKanO2ouQ6qE2NcVc2l
   nmCCDCwRutYQyTMj/XnQF0fd61PpiBwkCuTYT1n96Hmvr29lifz0bj0PU
   V/8krhKX8nMRNN2uoiiTWzlq8l919S3rdLds8DNgTA2WCZ8LMbNF2mybL
   gbF/yN2r0c6DlpDqMu6+ESK5RXlgBZ6zQfVcRnCheZTARQWtBkweIl6hN
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="198620504"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:58:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:58:32 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:28 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 01/11] net: dsa: microchip: lan937x: add cascade tailtag
Date:   Thu, 2 Feb 2023 18:29:20 +0530
Message-ID: <20230202125930.271740-2-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cascade tailtag contains 3 bytes of information, it includes
additional bytes for accomodating port number in second switch.
Destination port bitmap on first switch is at bit position 7:0 and
of second switch is at bit position 15:8, add new tailtag xmit and
rcv functions for cascade with proper formatting. Add new tag protocol
for cascading and link with new xmit and rcv functions.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/tag_ksz.c | 80 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a15f17a38eca..55651ad29193 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -56,6 +56,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
 #define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
 #define DSA_TAG_PROTO_LAN937X_VALUE		27
+#define DSA_TAG_PROTO_LAN937X_CASCADE_VALUE     28
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -86,6 +87,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
 	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
 	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
+	DSA_TAG_PROTO_LAN937X_CASCADE   = DSA_TAG_PROTO_LAN937X_CASCADE_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0eb1c7784c3d..7ab2c7eaa4ca 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -16,6 +16,7 @@
 #define KSZ9477_NAME "ksz9477"
 #define KSZ9893_NAME "ksz9893"
 #define LAN937X_NAME "lan937x"
+#define LAN937X_CASCADE_NAME "lan937x_cascade"
 
 /* Typically only one byte is used for tail tag. */
 #define KSZ_PTP_TAG_LEN			4
@@ -24,6 +25,9 @@
 
 #define KSZ_HWTS_EN  0
 
+#define SWITCH_0       0
+#define SWITCH_1       1
+
 struct ksz_tagger_private {
 	struct ksz_tagger_data data; /* Must be first */
 	unsigned long state;
@@ -84,10 +88,10 @@ static int ksz_connect(struct dsa_switch *ds)
 }
 
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
-				      struct net_device *dev,
-				      unsigned int port, unsigned int len)
+				      struct net_device *dev, unsigned int port,
+				      unsigned int len, u8 device)
 {
-	skb->dev = dsa_master_find_slave(dev, 0, port);
+	skb->dev = dsa_master_find_slave(dev, device, port);
 	if (!skb->dev)
 		return NULL;
 
@@ -141,7 +145,7 @@ static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
 
-	return ksz_common_rcv(skb, dev, tag[0] & 7, KSZ_EGRESS_TAG_LEN);
+	return ksz_common_rcv(skb, dev, tag[0] & 7, KSZ_EGRESS_TAG_LEN, SWITCH_0);
 }
 
 static const struct dsa_device_ops ksz8795_netdev_ops = {
@@ -177,6 +181,7 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_INGRESS_TAG_LEN		2
 #define KSZ9477_PTP_TAG_LEN		4
 #define KSZ9477_PTP_TAG_INDICATION	0x80
+#define LAN937X_CASCADE_CHIP		0x40
 
 #define KSZ9477_TAIL_TAG_PRIO		GENMASK(8, 7)
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
@@ -304,6 +309,7 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
 	unsigned int port = tag[0] & 7;
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
+	u8 device = SWITCH_0;
 
 	/* Extra 4-bytes PTP timestamp */
 	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
@@ -311,7 +317,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 		len += KSZ_PTP_TAG_LEN;
 	}
 
-	return ksz_common_rcv(skb, dev, port, len);
+	if (tag[0] & LAN937X_CASCADE_CHIP)
+		device = SWITCH_1;
+
+	return ksz_common_rcv(skb, dev, port, len, device);
 }
 
 static const struct dsa_device_ops ksz9477_netdev_ops = {
@@ -390,6 +399,7 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
  *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
  */
 #define LAN937X_EGRESS_TAG_LEN		2
+#define LAN937X_CASCADE_TAG_LEN		3
 
 #define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
 #define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
@@ -442,11 +452,71 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 DSA_TAG_DRIVER(lan937x_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X, LAN937X_NAME);
 
+/* For xmit, 3/7 bytes are added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|
+ * tag2(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if PTP is enabled in the Hardware)
+ * tag0 : represents tag override, lookup and valid
+ * tag1 : each bit represents destination port map through switch 2
+ *	  (eg, 0x01=port1, 0x02=port2, 0x80=port8)
+ * tag2 : each bit represents destination port map through switch 1
+ *	  (eg, 0x01=port1, 0x02=port2, 0x80=port8)
+ *
+ * For rcv, 1/5 bytes is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * ts   : time stamp (Present only if bit 7 of tag0 is set)
+ * tag0 : zero-based value represents port
+ *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
+ */
+static struct sk_buff *lan937x_cascade_xmit(struct sk_buff *skb,
+					    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const struct ethhdr *hdr = eth_hdr(skb);
+	__be32 *tag;
+	u32 val;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
+		return NULL;
+
+	tag = skb_put(skb, LAN937X_CASCADE_TAG_LEN);
+
+	val |= BIT((dp->index + (8 * dp->ds->index)));
+
+	if (is_link_local_ether_addr(hdr->h_dest))
+		val |= (LAN937X_TAIL_TAG_BLOCKING_OVERRIDE << 8);
+
+	val |= (LAN937X_TAIL_TAG_VALID << 8);
+
+	put_unaligned_be24(val, tag);
+
+	return skb;
+}
+
+static const struct dsa_device_ops lan937x_cascade_netdev_ops = {
+	.name   = LAN937X_CASCADE_NAME,
+	.proto  = DSA_TAG_PROTO_LAN937X_CASCADE,
+	.xmit   = lan937x_cascade_xmit,
+	.rcv    = ksz9477_rcv,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = LAN937X_CASCADE_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(lan937x_cascade_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937x_CASCADE,
+			    LAN937X_CASCADE_NAME);
+
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(lan937x_cascade_netdev_ops),
 };
 
 module_dsa_tag_drivers(dsa_tag_driver_array);
-- 
2.34.1

