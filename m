Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CBD1240EB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLRICa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:02:30 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44689 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfLRIC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:02:29 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ihUHj-0004el-JI; Wed, 18 Dec 2019 09:02:19 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ihUHg-0000aN-HB; Wed, 18 Dec 2019 09:02:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH v7 3/4] net: dsa: add support for Atheros AR9331 TAG format
Date:   Wed, 18 Dec 2019 09:02:14 +0100
Message-Id: <20191218080215.2151-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218080215.2151-1-o.rempel@pengutronix.de>
References: <20191218080215.2151-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for tag format used in Atheros AR9331 built-in switch.

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/dsa.h    |  2 +
 net/dsa/Kconfig      |  6 +++
 net/dsa/Makefile     |  1 +
 net/dsa/tag_ar9331.c | 96 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+)
 create mode 100644 net/dsa/tag_ar9331.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6767dc3f66c0..da5578db228e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -43,6 +43,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
 #define DSA_TAG_PROTO_OCELOT_VALUE		15
+#define DSA_TAG_PROTO_AR9331_VALUE		16
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -61,6 +62,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
 	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
+	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 1e6c3cac11e6..92663dcb3aa2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -29,6 +29,12 @@ config NET_DSA_TAG_8021Q
 
 	  Drivers which use these helpers should select this as dependency.
 
+config NET_DSA_TAG_AR9331
+	tristate "Tag driver for Atheros AR9331 SoC with built-in switch"
+	help
+	  Say Y or M if you want to enable support for tagging frames for
+	  the Atheros AR9331 SoC with built-in switch.
+
 config NET_DSA_TAG_BRCM_COMMON
 	tristate
 	default n
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 9a482c38bdb1..108486cfdeef 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -5,6 +5,7 @@ dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
 
 # tagging formats
 obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
+obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
 obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
new file mode 100644
index 000000000000..466ffa92a474
--- /dev/null
+++ b/net/dsa/tag_ar9331.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+ */
+
+
+#include <linux/bitfield.h>
+#include <linux/etherdevice.h>
+
+#include "dsa_priv.h"
+
+#define AR9331_HDR_LEN			2
+#define AR9331_HDR_VERSION		1
+
+#define AR9331_HDR_VERSION_MASK		GENMASK(15, 14)
+#define AR9331_HDR_PRIORITY_MASK	GENMASK(13, 12)
+#define AR9331_HDR_TYPE_MASK		GENMASK(10, 8)
+#define AR9331_HDR_BROADCAST		BIT(7)
+#define AR9331_HDR_FROM_CPU		BIT(6)
+/* AR9331_HDR_RESERVED - not used or may be version field.
+ * According to the AR8216 doc it should 0b10. On AR9331 it is 0b11 on RX path
+ * and should be set to 0b11 to make it work.
+ */
+#define AR9331_HDR_RESERVED_MASK	GENMASK(5, 4)
+#define AR9331_HDR_PORT_NUM_MASK	GENMASK(3, 0)
+
+static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__le16 *phdr;
+	u16 hdr;
+
+	if (skb_cow_head(skb, 0) < 0)
+		return NULL;
+
+	phdr = skb_push(skb, AR9331_HDR_LEN);
+
+	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
+	hdr |= AR9331_HDR_FROM_CPU | dp->index;
+	/* 0b10 for AR8216 and 0b11 for AR9331 */
+	hdr |= AR9331_HDR_RESERVED_MASK;
+
+	phdr[0] = cpu_to_le16(hdr);
+
+	return skb;
+}
+
+static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
+				      struct net_device *ndev,
+				      struct packet_type *pt)
+{
+	u8 ver, port;
+	u16 hdr;
+
+	if (unlikely(!pskb_may_pull(skb, AR9331_HDR_LEN)))
+		return NULL;
+
+	hdr = le16_to_cpu(*(__le16 *)skb_mac_header(skb));
+
+	ver = FIELD_GET(AR9331_HDR_VERSION_MASK, hdr);
+	if (unlikely(ver != AR9331_HDR_VERSION)) {
+		netdev_warn_once(ndev, "%s:%i wrong header version 0x%2x\n",
+				 __func__, __LINE__, hdr);
+		return NULL;
+	}
+
+	if (unlikely(hdr & AR9331_HDR_FROM_CPU)) {
+		netdev_warn_once(ndev, "%s:%i packet should not be from cpu 0x%2x\n",
+				 __func__, __LINE__, hdr);
+		return NULL;
+	}
+
+	skb_pull_rcsum(skb, AR9331_HDR_LEN);
+
+	/* Get source port information */
+	port = FIELD_GET(AR9331_HDR_PORT_NUM_MASK, hdr);
+
+	skb->dev = dsa_master_find_slave(ndev, 0, port);
+	if (!skb->dev)
+		return NULL;
+
+	return skb;
+}
+
+static const struct dsa_device_ops ar9331_netdev_ops = {
+	.name	= "ar9331",
+	.proto	= DSA_TAG_PROTO_AR9331,
+	.xmit	= ar9331_tag_xmit,
+	.rcv	= ar9331_tag_rcv,
+	.overhead = AR9331_HDR_LEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_AR9331);
+module_dsa_tag_driver(ar9331_netdev_ops);
-- 
2.24.0

