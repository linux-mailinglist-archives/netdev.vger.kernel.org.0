Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB33F413E
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhHVTde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhHVTdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:33:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5238C061757
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:50 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id me10so3886964ejb.11
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZoZHtRNTp7KXjk92qz01l5pq8krL3wvedBpvs7B8JA=;
        b=TU2s3vBJbD5IYwtDvBIL6YuWtIuB7ap5DrYt5uEt77TDoQJ7XG0sCgbotlhMrdxPWw
         u5m358LjovIL3q6Yk7vAiSj2cg03+65/TPRCc5MMPcshyFcxEe9PJ7JfI7VCfdsVUmUs
         9JE8akDkOtYj7ioaqbQSQ4UGclV8uF3OjDTlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZoZHtRNTp7KXjk92qz01l5pq8krL3wvedBpvs7B8JA=;
        b=YiitHUmDK7Em90IPySfFQmpodqBDmnIe68rW5xfgvDHaiBEc0ZvudsY05hbeRsbOGP
         alF6IU8d/68CTqbnGW0CuCLbx5c24rTX9HdfgG0VpqKdn2zGsXQZx7lY7iC2vSjSwkZt
         mzyFpDOSknVSXO9RFNwCVVVP8qLaAHoUM7zpdajZ/ck1IALM7gi+WPnS2IDIp8eyjquD
         md939R2hMbKnaH/nWhrZ3CYya3sRKa3FlYoMS7wWiJPiZWdBmiprWt4LiXX3JcekdY2/
         LVaGyFzvesoKSKUh+7Qrs7iemCkXWxs7ABUGSCxcpNGW+UmjkDeteBNCYTdIKx9UJ8nL
         Fz4A==
X-Gm-Message-State: AOAM531S5FK51ubqA01sx/JkHuXcozeNZQKH2P2c8k5Uf56hRGfW3Hct
        A2I9fkTiRCA6NnhGttj0Lj1lfg==
X-Google-Smtp-Source: ABdhPJwWyDbPcNqFZSeMySJ7ItU7FY79AZKjz5xMLAegiEFU97IB0eixJaQ/tDR3qEMlEhjpMnDiAg==
X-Received: by 2002:a17:906:2a8e:: with SMTP id l14mr31757444eje.321.1629660769400;
        Sun, 22 Aug 2021 12:32:49 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cn16sm7780053edb.9.2021.08.22.12.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 12:32:48 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     mir@bang-olufsen.dk, alvin@pqrs.dk,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
Date:   Sun, 22 Aug 2021 21:31:41 +0200
Message-Id: <20210822193145.1312668-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822193145.1312668-1-alvin@pqrs.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This commit implements a basic version of the 8 byte tag protocol used
in the Realtek RTL8365MB-VC switch, which carries with it a protocol
version of 0x04.

The implementation itself only handles the parsing of the EtherType
value and Realtek protocol version, together with the source or
destination port fields. The rest is left unimplemented for now.

The tag format is described in a confidential document provided to my
employer - Bang & Olufsen a/s - by Realtek Semiconductor Corp.
Permission has been granted by Realtek to publish this driver based on
that material, together with an extract from the document describing the
tag format and its fields.  It is hoped that this will help future
implementors who do not have access to the material but who wish to
extend the functionality of drivers for chips which use this protocol.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 include/net/dsa.h    |   2 +
 net/dsa/Kconfig      |   6 ++
 net/dsa/Makefile     |   1 +
 net/dsa/tag_rtl8_4.c | 178 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 net/dsa/tag_rtl8_4.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0c2cba45fa79..6d8b5a11d99a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -51,6 +51,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
+#define DSA_TAG_PROTO_RTL8_4_VALUE		24
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -77,6 +78,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
+	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 548285539752..470a2f3e8f75 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -99,6 +99,12 @@ config NET_DSA_TAG_RTL4_A
 	  Realtek switches with 4 byte protocol A tags, sich as found in
 	  the Realtek RTL8366RB.
 
+config NET_DSA_TAG_RTL8_4
+	tristate "Tag driver for Realtek 8 byte protocol 4 tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for Realtek
+	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
+
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	depends on MSCC_OCELOT_SWITCH_LIB || \
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 67ea009f242c..01282817e80e 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
+obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
new file mode 100644
index 000000000000..1082bafb6a2e
--- /dev/null
+++ b/net/dsa/tag_rtl8_4.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Handler for Realtek 8 byte switch tags
+ *
+ * Copyright (C) 2021 Alvin Šipraga <alsi@bang-olufsen.dk>
+ *
+ * NOTE: Currently only supports protocol "4" found in the RTL8365MB, hence
+ * named tag_rtl8_4.
+ *
+ * This "proprietary tag" header has the following format:
+ *
+ *  -------------------------------------------
+ *  | MAC DA | MAC SA | 8 byte tag | Type | ...
+ *  -------------------------------------------
+ *     _______________/            \______________________________________
+ *    /                                                                   \
+ *  0                                  7|8                                 15
+ *  |-----------------------------------+-----------------------------------|---
+ *  |                               (16-bit)                                | ^
+ *  |                       Realtek EtherType [0x8899]                      | |
+ *  |-----------------------------------+-----------------------------------| 8
+ *  |              (8-bit)              |              (8-bit)              |
+ *  |          Protocol [0x04]          |              REASON               | b
+ *  |-----------------------------------+-----------------------------------| y
+ *  |   (1)  | (1) | (2) |   (1)  | (3) | (1)  | (1) |    (1)    |   (5)    | t
+ *  | FID_EN |  X  | FID | PRI_EN | PRI | KEEP |  X  | LEARN_DIS |    X     | e
+ *  |-----------------------------------+-----------------------------------| s
+ *  |   (1)  |                       (15-bit)                               | |
+ *  |  ALLOW |                        TX/RX                                 | v
+ *  |-----------------------------------+-----------------------------------|---
+ *
+ * With the following field descriptions:
+ *
+ *    field      | description
+ *   ------------+-------------
+ *    Realtek    | 0x8899: indicates that this is a proprietary Realtek tag;
+ *     EtherType |         note that Realtek uses the same EtherType for
+ *               |         other incompatible tag formats (e.g. tag_rtl4_a.c)
+ *    Protocol   | 0x04: indicates that this tag conforms to this format
+ *    X          | reserved
+ *   ------------+-------------
+ *    REASON     | reason for forwarding packet to CPU
+ *    FID_EN     | 1: packet has an FID
+ *               | 0: no FID
+ *    FID        | FID of packet (if FID_EN=1)
+ *    PRI_EN     | 1: force priority of packet
+ *               | 0: don't force priority
+ *    PRI        | priority of packet (if PRI_EN=1)
+ *    KEEP       | preserve packet VLAN tag format
+ *    LEARN_DIS  | don't learn the source MAC address of the packet
+ *    ALLOW      | 1: treat TX/RX field as an allowance port mask, meaning the
+ *               |    packet may only be forwarded to ports specified in the
+ *               |    mask
+ *               | 0: no allowance port mask, TX/RX field is the forwarding
+ *               |    port mask
+ *    TX/RX      | TX (switch->CPU): port number the packet was received on
+ *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
+ *               |                   allowance port mask (if ALLOW=1)
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/bits.h>
+
+#include "dsa_priv.h"
+
+#define RTL8_4_TAG_LEN			8
+#define RTL8_4_ETHERTYPE		0x8899
+/* 0x04 = RTL8365MB DSA protocol
+ */
+#define RTL8_4_PROTOCOL_RTL8365MB	0x04
+
+static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *p;
+	u8 *tag;
+	u16 out;
+
+	/* Pad out so that the (stripped) packet is at least 64 bytes long
+	 * (including FCS), otherwise the switch will drop the packet.
+	 * Then we need an additional 8 bytes for the Realtek tag.
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN + RTL8_4_TAG_LEN, false))
+		return NULL;
+
+	skb_push(skb, RTL8_4_TAG_LEN);
+
+	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
+	tag = dsa_etype_header_pos_tx(skb);
+
+	/* Set Realtek EtherType */
+	p = (__be16 *)tag;
+	*p = htons(RTL8_4_ETHERTYPE);
+
+	/* Set Protocol; zero REASON */
+	p = (__be16 *)(tag + 2);
+	*p = htons(RTL8_4_PROTOCOL_RTL8365MB << 8);
+
+	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP, LEARN_DIS */
+	p = (__be16 *)(tag + 4);
+	*p = 0;
+
+	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
+	p = (__be16 *)(tag + 6);
+	out = BIT(dp->index);
+	*p = htons(~(1 << 15) & BIT(dp->index));
+
+	return skb;
+}
+
+static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	__be16 *p;
+	u16 etype;
+	u8 proto;
+	u8 *tag;
+	u8 port;
+	u16 tmp;
+
+	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
+		return NULL;
+
+	tag = dsa_etype_header_pos_rx(skb);
+
+	/* Parse Realtek EtherType */
+	p = (__be16 *)tag;
+	etype = ntohs(*p);
+	if (unlikely(etype != RTL8_4_ETHERTYPE)) {
+		netdev_dbg(dev, "non-realtek ethertype 0x%04x\n", etype);
+		return NULL;
+	}
+
+	/* Parse Protocol; ignore REASON */
+	p = (__be16 *)(tag + 2);
+	tmp = ntohs(*p);
+	proto = tmp >> 8;
+	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
+		netdev_dbg(dev, "unknown realtek protocol 0x%02x\n", proto);
+		return NULL;
+	}
+
+	/* Ignore FID_EN, FID, PRI_EN, PRI, KEEP, LEARN_DIS */
+	p = (__be16 *)(tag + 4);
+
+	/* Ignore ALLOW; parse TX (switch->CPU) */
+	p = (__be16 *)(tag + 6);
+	tmp = ntohs(*p);
+	port = tmp & 0xf; /* Port number is the LSB 4 bits */
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev) {
+		netdev_dbg(dev, "could not find slave for port %d\n", port);
+		return NULL;
+	}
+
+	/* Remove tag and recalculate checksum */
+	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
+
+	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
+
+	skb->offload_fwd_mark = 1;
+
+	return skb;
+}
+
+static const struct dsa_device_ops rtl8_4_netdev_ops = {
+	.name = "rtl8_4",
+	.proto = DSA_TAG_PROTO_RTL8_4,
+	.xmit = rtl8_4_tag_xmit,
+	.rcv = rtl8_4_tag_rcv,
+	.needed_headroom = RTL8_4_TAG_LEN,
+};
+module_dsa_tag_driver(rtl8_4_netdev_ops);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
-- 
2.32.0

