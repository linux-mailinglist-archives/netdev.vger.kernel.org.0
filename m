Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47112DC14B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442391AbfJRJjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:39:45 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33273 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442370AbfJRJjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:39:43 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iLOjQ-0006Z9-Ty; Fri, 18 Oct 2019 11:39:36 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iLOjN-0007h7-Il; Fri, 18 Oct 2019 11:39:33 +0200
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
Subject: [PATCH v2 4/5] net: dsa: add support for Atheros AR9331 TAG format
Date:   Fri, 18 Oct 2019 11:39:28 +0200
Message-Id: <20191018093929.19299-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018093929.19299-1-o.rempel@pengutronix.de>
References: <20191018093929.19299-1-o.rempel@pengutronix.de>
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

Add support for tag format used in Atheros AR9331 build-in switch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/dsa.h    |  2 +
 net/dsa/Kconfig      |  6 +++
 net/dsa/Makefile     |  1 +
 net/dsa/tag_ar9331.c | 97 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 net/dsa/tag_ar9331.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 541fb514e31d..89a334e68d42 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -42,6 +42,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_8021Q_VALUE		12
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
+#define DSA_TAG_PROTO_AR9331_VALUE		15
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -59,6 +60,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
+	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 29e2bd5cc5af..617c9607df5f 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -29,6 +29,12 @@ config NET_DSA_TAG_8021Q
 
 	  Drivers which use these helpers should select this as dependency.
 
+config NET_DSA_TAG_AR9331
+	tristate "Tag driver for Atheros AR9331 SoC with build-in switch"
+	help
+	  Say Y or M if you want to enable support for tagging frames for
+	  the Atheros AR9331 SoC with build-in switch.
+
 config NET_DSA_TAG_BRCM_COMMON
 	tristate
 	default n
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 2c6d286f0511..6f77bdb5c40c 100644
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
index 000000000000..40265dd75697
--- /dev/null
+++ b/net/dsa/tag_ar9331.c
@@ -0,0 +1,97 @@
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
+	skb_pull(skb, AR9331_HDR_LEN);
+	skb_set_mac_header(skb, -ETH_HLEN);
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
2.23.0

