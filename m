Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD7B51FDF1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiEINY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiEINYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:24:23 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557142B1647;
        Mon,  9 May 2022 06:20:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 24FDA240006;
        Mon,  9 May 2022 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652102428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4UyW7TbYwIsoruZbKR9JCyTrq6clfqLl52yRW9sduv4=;
        b=IsF/cXBjzvKabzEIkzrhLaB/sSeMxTEFaFapeMhx57xv6eSXtJGE5ZIZOIkeBYvvKzLVPA
        wOBxte94B8BAmOI0L/3t6Tm6fzlQF6NdWw577c/a+zP5NNowK1GOlqVBEOMS5azPidnKjx
        aYn13Vq6vtTkFX9GCxcySLynxMkrPJl6ddPDHuv0IIK/8qniUisB1BT8rdBUM4aiU6+cQa
        I0m0FsH6+HRlpVh7v15VSOFo0seHfH/aoMo2T1LFHbJasJq2BjySlgVgGb38+jk+r6wHMR
        lVgohlEWTqVu5jEixZkSLYTds52behRXH2qLowIPuh9uSwOIr6A98fZsrQKu7Q==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 02/12] net: dsa: add Renesas RZ/N1 switch tag driver
Date:   Mon,  9 May 2022 15:18:50 +0200
Message-Id: <20220509131900.7840-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220509131900.7840-1-clement.leger@bootlin.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch that is present on the Renesas RZ/N1 SoC uses a specific
VLAN value followed by 6 bytes which contains forwarding configuration.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 include/net/dsa.h             |   2 +
 include/uapi/linux/if_ether.h |   1 +
 net/dsa/Kconfig               |   7 +++
 net/dsa/Makefile              |   1 +
 net/dsa/tag_rzn1_a5psw.c      | 113 ++++++++++++++++++++++++++++++++++
 5 files changed, 124 insertions(+)
 create mode 100644 net/dsa/tag_rzn1_a5psw.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d9da32aacbf1..9aaaa7deb102 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -53,6 +53,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
 #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
+#define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -81,6 +82,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
 	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
+	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
 };
 
 struct dsa_switch;
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 1d0bccc3fa54..d370165bc621 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -116,6 +116,7 @@
 #define ETH_P_QINQ3	0x9300		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_DSA_8021Q	0xDADB		/* Fake VLAN Header for DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_DSA_A5PSW	0xE001		/* A5PSW Tag Value [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
 #define ETH_P_AF_IUCV   0xFBFB		/* IBM af_iucv [ NOT AN OFFICIALLY REGISTERED ID ] */
 
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8cb87b5067ee..63853fff4e2f 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -132,6 +132,13 @@ config NET_DSA_TAG_RTL8_4
 	  Say Y or M if you want to enable support for tagging frames for Realtek
 	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
 
+config NET_DSA_TAG_RZN1_A5PSW
+	tristate "Tag driver for Renesas RZ/N1 A5PSW switch"
+	help
+	  Say Y or M if you want to enable support for tagging frames for
+	  Renesas RZ/N1 embedded switch that uses an 8 byte tag located after
+	  destination MAC address.
+
 config NET_DSA_TAG_LAN9303
 	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 9f75820e7c98..af28c24ead18 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
+obj-$(CONFIG_NET_DSA_TAG_RZN1_A5PSW) += tag_rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
 obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
diff --git a/net/dsa/tag_rzn1_a5psw.c b/net/dsa/tag_rzn1_a5psw.c
new file mode 100644
index 000000000000..e2a5ee6ae688
--- /dev/null
+++ b/net/dsa/tag_rzn1_a5psw.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Schneider Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <net/dsa.h>
+
+#include "dsa_priv.h"
+
+/* To define the outgoing port and to discover the incoming port a TAG is
+ * inserted after Src MAC :
+ *
+ *       Dest MAC       Src MAC           TAG         Type
+ * ...| 1 2 3 4 5 6 | 1 2 3 4 5 6 | 1 2 3 4 5 6 7 8 | 1 2 |...
+ *                                |<--------------->|
+ *
+ * See struct a5psw_tag for layout
+ */
+
+#define ETH_P_DSA_A5PSW			0xE001
+#define A5PSW_TAG_LEN			8
+#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
+/* This is both used for xmit tag and rcv tagging */
+#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
+
+struct a5psw_tag {
+	__be16 ctrl_tag;
+	__be16 ctrl_data;
+	__be16 ctrl_data2_hi;
+	__be16 ctrl_data2_lo;
+};
+
+static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct a5psw_tag *ptag;
+	u32 data2_val;
+
+	BUILD_BUG_ON(sizeof(*ptag) != A5PSW_TAG_LEN);
+
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 60 bytes otherwise they will be discarded when they enter the
+	 * switch port logic.
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
+		return NULL;
+
+	/* provide 'A5PSW_TAG_LEN' bytes additional space */
+	skb_push(skb, A5PSW_TAG_LEN);
+
+	/* make room between MACs and Ether-Type to insert tag */
+	dsa_alloc_etype_header(skb, A5PSW_TAG_LEN);
+
+	ptag = dsa_etype_header_pos_tx(skb);
+
+	data2_val = FIELD_PREP(A5PSW_CTRL_DATA_PORT, BIT(dp->index));
+	ptag->ctrl_tag = htons(ETH_P_DSA_A5PSW);
+	ptag->ctrl_data = htons(A5PSW_CTRL_DATA_FORCE_FORWARD);
+	ptag->ctrl_data2_lo = htons(data2_val);
+	ptag->ctrl_data2_hi = 0;
+
+	return skb;
+}
+
+static struct sk_buff *a5psw_tag_rcv(struct sk_buff *skb,
+				     struct net_device *dev)
+{
+	struct a5psw_tag *tag;
+	int port;
+
+	if (unlikely(!pskb_may_pull(skb, A5PSW_TAG_LEN))) {
+		dev_warn_ratelimited(&dev->dev,
+				     "Dropping packet, cannot pull\n");
+		return NULL;
+	}
+
+	tag = dsa_etype_header_pos_rx(skb);
+
+	if (tag->ctrl_tag != htons(ETH_P_DSA_A5PSW)) {
+		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid TAG marker\n");
+		return NULL;
+	}
+
+	port = FIELD_GET(A5PSW_CTRL_DATA_PORT, ntohs(tag->ctrl_data));
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev)
+		return NULL;
+
+	skb_pull_rcsum(skb, A5PSW_TAG_LEN);
+	dsa_strip_etype_header(skb, A5PSW_TAG_LEN);
+
+	dsa_default_offload_fwd_mark(skb);
+
+	return skb;
+}
+
+static const struct dsa_device_ops a5psw_netdev_ops = {
+	.name	= "a5psw",
+	.proto	= DSA_TAG_PROTO_RZN1_A5PSW,
+	.xmit	= a5psw_tag_xmit,
+	.rcv	= a5psw_tag_rcv,
+	.needed_headroom = A5PSW_TAG_LEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_A5PSW);
+module_dsa_tag_driver(a5psw_netdev_ops);
-- 
2.36.0

