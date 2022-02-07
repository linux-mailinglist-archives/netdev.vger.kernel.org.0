Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6CF4AC75E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377027AbiBGR1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346224AbiBGRXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E17EC0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644254628; x=1675790628;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dly94UPRszsxGbaHdq9AVuCztjMlsZQ9xuCw10WHMlQ=;
  b=nNMTWtqbVLwyMKnXvkRTIjeuM07U3Xb+0Uy15CsxmRdNV4UgQgN9wTlq
   goh0CiCiW2KsIjXM/rpLPIf4uQt4VKLUM1Lz4tTaaQTqXqgHTVZ77y84e
   OF6QamVQ+ZDs7VA7FRyNbFEg95tmXBIqv1tpMC0xuWZrBxLEgRdUG3DO7
   JrDphgt54SZhhDn/wYhF/TEJlQX7+3PWhHHpaZ/w1bz4pj6SQBsWWvzYT
   D2LIF1KfRH91i/rc7lmXXg7xCwMMryWXGsSg6AT8Y9kH8PWaodst2rrYZ
   bDtP4eM/UTr/ETwXpELYHzkiG+56Zo6ZNJVgAi84Tqdd/mpPCe+tkOTCG
   A==;
IronPort-SDR: +8Kv2uL5mN3QehMXg/zb4TM48MsiQ/RKl20tOdeqYoIkYUIwROtpO70KtsLZFm4ezg8nAZ9AMN
 WKMibkGgYeCk2v4iRzR1P7zO7kWEzb2DE+zYgi03rBNG6RWd8rKGrwFWAU8FoAP3WVEX2jODEX
 Lec//HOoJZxde85GNi99solEk4xcI/VChQUVuoRz31SKKLIlTJcRLVKZsIR2qHQ4iDxKmP13cV
 MZQrPImdVH/c13X6sMM31j/vAwJWMKHSASuldkit3VsbVSLJ2xlliM3yWwz5TZaHgMX5tx/yk+
 JJvWJn9KDtAodGLMG+iXwCx3
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="145147772"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 10:22:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 10:22:44 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 10:22:38 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v8 net-next 04/10] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
Date:   Mon, 7 Feb 2022 22:51:58 +0530
Message-ID: <20220207172204.589190-5-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Microchip LAN937X switches have a tagging protocol which is
very similar to KSZ tagging. So that the implementation is added to
tag_ksz.c and reused common APIs

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/Kconfig   |  4 ++--
 net/dsa/tag_ksz.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ca8c14b547b4..30b7274d8c45 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -52,6 +52,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
+#define DSA_TAG_PROTO_LAN937X_VALUE		25
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -79,6 +80,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
+	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8cb87b5067ee..6d0414c9f7f4 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -87,10 +87,10 @@ config NET_DSA_TAG_MTK
 	  Mediatek switches.
 
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
+	tristate "Tag driver for Microchip 8795/937x/9477/9893 families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 8795/9477/9893 families of switches.
+	  Microchip 8795/937x/9477/9893 families of switches.
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 3509fc967ca9..38fa19c1e2d5 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -193,10 +193,69 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 
+/* For xmit, 2 bytes are added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : represents tag override, lookup and valid
+ * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
+ *
+ * For rcv, 1 byte is added before FCS.
+ * ---------------------------------------------------------------------------
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * ---------------------------------------------------------------------------
+ * tag0 : zero-based value represents port
+ *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
+ */
+#define LAN937X_EGRESS_TAG_LEN		2
+
+#define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
+#define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
+#define LAN937X_TAIL_TAG_VALID			BIT(13)
+#define LAN937X_TAIL_TAG_PORT_MASK		7
+
+static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const struct ethhdr *hdr = eth_hdr(skb);
+	__be16 *tag;
+	u16 val;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
+		return NULL;
+
+	tag = skb_put(skb, LAN937X_EGRESS_TAG_LEN);
+
+	val = BIT(dp->index);
+
+	if (is_link_local_ether_addr(hdr->h_dest))
+		val |= LAN937X_TAIL_TAG_BLOCKING_OVERRIDE;
+
+	/* Tail tag valid bit - This bit should always be set by the CPU */
+	val |= LAN937X_TAIL_TAG_VALID;
+
+	put_unaligned_be16(val, tag);
+
+	return skb;
+}
+
+static const struct dsa_device_ops lan937x_netdev_ops = {
+	.name	= "lan937x",
+	.proto	= DSA_TAG_PROTO_LAN937X,
+	.xmit	= lan937x_xmit,
+	.rcv	= ksz9477_rcv,
+	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(lan937x_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X);
+
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
 	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
 };
 
 module_dsa_tag_drivers(dsa_tag_driver_array);
-- 
2.30.2

