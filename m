Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778C1500D4B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbiDNM10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243188AbiDNM1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:14 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23DF2D1F1;
        Thu, 14 Apr 2022 05:24:45 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 59F2940003;
        Thu, 14 Apr 2022 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwDxNSRrfQ0fwbGL5JfChMYmoOedvb2POPLu1+VI9fs=;
        b=mxv/3mdrs1ZRE2G4jRlJUKnhx4QvHcUxICZ/dnBY1HfoYqvWx8UcKdWjJrPsVBPjO8lE5j
        7N4AS6z5rgZOiJr9/qeBKRgAcJ9yD6EEgW2fHVrcxwgJSj5w572rVg2L81HSG50QfXX/RR
        fFv1z0h3Fin5WOgxYU6i/3goa+cweBWnJqnSTBjhZpisiV32NJOEz0rvoCaTwN6zCorD6C
        Jb7J5IKDtTI3zzpRnTIx6guWqjZrUqZxGXLrmzUSewlVP5YTmfS1nEIu/iIoTenFgSfPdn
        PQu/aEZQU1YKKPZEPzSNb97djG662523O4v/926xJXaAF1VNW1tq/yB6VLar7g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag driver
Date:   Thu, 14 Apr 2022 14:22:40 +0200
Message-Id: <20220414122250.158113-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
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
 net/dsa/Kconfig          |   8 +++
 net/dsa/Makefile         |   1 +
 net/dsa/tag_rzn1_a5psw.c | 112 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+)
 create mode 100644 net/dsa/tag_rzn1_a5psw.c

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8cb87b5067ee..e5b17108fa22 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -132,6 +132,13 @@ config NET_DSA_TAG_RTL8_4
 	  Say Y or M if you want to enable support for tagging frames for Realtek
 	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
 
+config NET_DSA_TAG_RZN1_A5PSW
+	tristate "Tag driver for Renesas RZ/N1 A5PSW switch"
+	help
+	  Say Y or M if you want to enable support for tagging frames for
+	  Renesas RZ/N1 embedded switch that uses a 8 byte tag located after
+	  destination MAC address.
+
 config NET_DSA_TAG_LAN9303
 	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
 	help
@@ -159,4 +166,5 @@ config NET_DSA_TAG_XRS700X
 	  Say Y or M if you want to enable support for tagging frames for
 	  Arrow SpeedChips XRS700x switches that use a single byte tag trailer.
 
+
 endif
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
index 000000000000..7818c1c0fca2
--- /dev/null
+++ b/net/dsa/tag_rzn1_a5psw.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Schneider Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/etherdevice.h>
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
+#define A5PSW_TAG_VALUE			0xE001
+#define A5PSW_TAG_LEN			8
+#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
+/* This is both used for xmit tag and rcv tagging */
+#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
+
+struct a5psw_tag {
+	u16 ctrl_tag;
+	u16 ctrl_data;
+	u32 ctrl_data2;
+};
+
+static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct a5psw_tag *ptag, tag = {0};
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u32 data2_val;
+
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 64 bytes (including FCS) otherwise they will be discarded when
+	 * they enter the switch port logic. When tagging is enabled, we need
+	 * to make sure that packets are at least 68 bytes (including FCS and
+	 * tag).
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN + sizeof(tag), false))
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
+	tag.ctrl_tag = htons(A5PSW_TAG_VALUE);
+	tag.ctrl_data = htons(A5PSW_CTRL_DATA_FORCE_FORWARD);
+	tag.ctrl_data2 = htonl(data2_val);
+
+	memcpy(ptag, &tag, sizeof(struct a5psw_tag));
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
+	if (tag->ctrl_tag != htons(A5PSW_TAG_VALUE)) {
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
2.34.1

