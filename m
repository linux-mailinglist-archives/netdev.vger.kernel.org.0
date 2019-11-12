Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C86F8FDF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKLMpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:45:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51324 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKLMo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so3021589wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ATp6128+CwvJ64jjxTzTelFncMJrWx07320JEYhhZqw=;
        b=jHI++TF/pZXaIeyEvh6JzCd57gjhAc0PiNQ5mxKd25ApN6WG678rlzlNhjzy15UC/e
         K0GjUxxEAy+NI59Bj1SJsxHz64LCaaPMbfkYKVxu5kficAfUBZPtFxyKNh0Ki/R1jGHy
         vc8t7zS/Ox4120/Vdr1lE17OPP88SuuKiF6BzNvFBHXlQIYJ+/D1p6SwEVNomkYetDI5
         XZ+H483m7jIV5eqqHB1wdPLZe/385evgn7oqH4u58qaEn9uB92/VhHECoILw9afU3m6S
         abY0KbasptCRWa9pERgpo5Uu7+mjBDlapo9RR89JZOfLZVaYOQ3s9/GdE6fvA40EnB1o
         UZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ATp6128+CwvJ64jjxTzTelFncMJrWx07320JEYhhZqw=;
        b=LU8hOcvEnjy4DPYb6RCfqSkYbIz1iwtRry8OD4bDcRHjyrsymJjU+vzEwKYSoGdVoE
         sto7CZb8Bh8lNzlslRIPPzXZSaGIv7NnpaLbLPwSFQe2QOu31KYkGAIk7g2iohg3t8Au
         6BH0cB5WSwtGZlMzmmFowhCU2UpFgLGwL0RvMYT+jRZVnD+xWRxZInfxU0ovvhuPlhOt
         /8EXtuCgo1+5L71rHiKYSSm+0fWqTx3kxAZux7nn5usREqC2WZxSDgfwprAHbIXcJ/gb
         s5rPSTDMeFm3rdBij2OJSOQ35LamtWe5bH9TFvEHikI/MAnwuYZ8Lrmx3ITr2CxrlICJ
         v9SA==
X-Gm-Message-State: APjAAAXSF3p/7ftoY+viuRoKGMPJyKuuL4QZZi5RR5bGPLQ9qotFgibS
        cCffX3p8SwGjzQnOOK5PNnY=
X-Google-Smtp-Source: APXvYqzhYvQkmoQtNk7LWo+CqP1XNy/jBJ+D2pul2L0b44mC8eubHQGJzI0ifv7XdQOyyc9f5YgulA==
X-Received: by 2002:a1c:9601:: with SMTP id y1mr3614536wmd.157.1573562694916;
        Tue, 12 Nov 2019 04:44:54 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 12/12] net: dsa: vitesse: add tagger for Ocelot/Felix switches
Date:   Tue, 12 Nov 2019 14:44:20 +0200
Message-Id: <20191112124420.6225-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

While it is entirely possible that this tagger format is in fact more
generic than just these 2 switch families, I don't have that knowledge.
The Seville switch in NXP T1040 has a similar frame format, but there
are enough differences (e.g. DEST field starts at bit 57 instead of 56)
that calling this file tag_vitesse.c is a bit of a stretch at the
moment. The frame format has been listed in a comment so that people who
add support for further Vitesse switches can rework this tagger while
keeping compatibility with Felix.

The "ocelot" name was chosen instead of "felix" because even the Ocelot
switch can act as a DSA device when it is used in NPI mode, and the Felix
tagger format is almost identical. Currently it is only used for the
Felix switch embedded in the NXP LS1028A chip.

The ABI for this tagger should be considered "not stable" at the moment.
The DSA tag is always placed before the Ethernet header and therefore,
we are using the long prefix for RX tags to avoid putting the DSA master
port in promiscuous mode. Once there will be an API in DSA for drivers
to request DSA masters to be in promiscuous mode unconditionally, we
will switch to the "no prefix" extraction frame header, which will save
16 padding bytes for each RX frame.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 MAINTAINERS                     |   1 +
 drivers/net/dsa/vitesse/Kconfig |   1 +
 drivers/net/dsa/vitesse/felix.c |  15 +--
 include/net/dsa.h               |   2 +
 net/dsa/Kconfig                 |   7 +
 net/dsa/Makefile                |   1 +
 net/dsa/tag_ocelot.c            | 229 ++++++++++++++++++++++++++++++++
 7 files changed, 248 insertions(+), 8 deletions(-)
 create mode 100644 net/dsa/tag_ocelot.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 486300903366..e86c4199a52f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17365,6 +17365,7 @@ M:	Claudiu Manoil <claudiu.manoil@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/vitesse/felix*
+F:	net/dsa/tag_ocelot.c
 
 VIVID VIRTUAL VIDEO DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
diff --git a/drivers/net/dsa/vitesse/Kconfig b/drivers/net/dsa/vitesse/Kconfig
index ca47c55f9733..e3b82a8db4b7 100644
--- a/drivers/net/dsa/vitesse/Kconfig
+++ b/drivers/net/dsa/vitesse/Kconfig
@@ -3,6 +3,7 @@ config NET_DSA_VITESSE_FELIX
 	tristate "Felix Ethernet switch support"
 	depends on NET_DSA && PCI
 	select MSCC_OCELOT_SWITCH
+	select NET_DSA_TAG_OCELOT
 	help
 	  This driver supports the Felix (VSC9959) network switch, which is a
 	  variant of the Vitesse Ocelot switch core that is embedded as a PCIe
diff --git a/drivers/net/dsa/vitesse/felix.c b/drivers/net/dsa/vitesse/felix.c
index 0f433971335a..e2439e9a1a12 100644
--- a/drivers/net/dsa/vitesse/felix.c
+++ b/drivers/net/dsa/vitesse/felix.c
@@ -12,7 +12,7 @@
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 						    int port)
 {
-	return DSA_TAG_PROTO_NONE;
+	return DSA_TAG_PROTO_OCELOT;
 }
 
 static int felix_set_ageing_time(struct dsa_switch *ds,
@@ -201,15 +201,14 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ocelot_init(ocelot);
 
-	for (port = 0; port < ds->num_ports; port++)
+	for (port = 0; port < ds->num_ports; port++) {
 		ocelot_init_port(ocelot, port);
 
-	/* Set the CPU port as one of the non-NPI ports, so that the switch
-	 * is dumb for now and passes untagged traffic to/from the CPU.
-	 */
-	ocelot_set_cpu_port(ocelot, ds->num_ports,
-			    OCELOT_TAG_PREFIX_NONE,
-			    OCELOT_TAG_PREFIX_NONE);
+		if (port == dsa_upstream_port(ds, port))
+			ocelot_set_cpu_port(ocelot, port,
+					    OCELOT_TAG_PREFIX_NONE,
+					    OCELOT_TAG_PREFIX_LONG);
+	}
 
 	return 0;
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9507611a41f0..6767dc3f66c0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -42,6 +42,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_8021Q_VALUE		12
 #define DSA_TAG_PROTO_SJA1105_VALUE		13
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
+#define DSA_TAG_PROTO_OCELOT_VALUE		15
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -59,6 +60,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
 	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
+	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 29e2bd5cc5af..fd9ef19a9581 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -67,6 +67,13 @@ config NET_DSA_TAG_EDSA
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Marvell switches which use EtherType DSA headers.
 
+config NET_DSA_TAG_OCELOT
+	tristate "Tag driver for Vitesse Ocelot/Felix switch"
+	select PACKING
+	help
+	  Say Y or M if you want to enable support for tagging frames with the
+	  Vitesse Ocelot (VSC7514) and Felix (VSC9959) switching cores.
+
 config NET_DSA_TAG_MTK
 	tristate "Tag driver for Mediatek switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 2c6d286f0511..9a482c38bdb1 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
new file mode 100644
index 000000000000..078d4790669d
--- /dev/null
+++ b/net/dsa/tag_ocelot.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2019 NXP Semiconductors
+ */
+#include <soc/mscc/ocelot.h>
+#include <linux/packing.h>
+#include "dsa_priv.h"
+
+/* The CPU injection header and the CPU extraction header can have 3 types of
+ * prefixes: long, short and no prefix. The format of the header itself is the
+ * same in all 3 cases.
+ *
+ * Extraction with long prefix:
+ *
+ * +-------------------+-------------------+------+------+------------+-------+
+ * | ff:ff:ff:ff:ff:ff | ff:ff:ff:ff:ff:ff | 8880 | 000a | extraction | frame |
+ * |                   |                   |      |      |   header   |       |
+ * +-------------------+-------------------+------+------+------------+-------+
+ *        48 bits             48 bits      16 bits 16 bits  128 bits
+ *
+ * Extraction with short prefix:
+ *
+ *                                         +------+------+------------+-------+
+ *                                         | 8880 | 000a | extraction | frame |
+ *                                         |      |      |   header   |       |
+ *                                         +------+------+------------+-------+
+ *                                         16 bits 16 bits  128 bits
+ *
+ * Extraction with no prefix:
+ *
+ *                                                       +------------+-------+
+ *                                                       | extraction | frame |
+ *                                                       |   header   |       |
+ *                                                       +------------+-------+
+ *                                                          128 bits
+ *
+ *
+ * Injection with long prefix:
+ *
+ * +-------------------+-------------------+------+------+------------+-------+
+ * |      any dmac     |      any smac     | 8880 | 000a | injection  | frame |
+ * |                   |                   |      |      |   header   |       |
+ * +-------------------+-------------------+------+------+------------+-------+
+ *        48 bits             48 bits      16 bits 16 bits  128 bits
+ *
+ * Injection with short prefix:
+ *
+ *                                         +------+------+------------+-------+
+ *                                         | 8880 | 000a | injection  | frame |
+ *                                         |      |      |   header   |       |
+ *                                         +------+------+------------+-------+
+ *                                         16 bits 16 bits  128 bits
+ *
+ * Injection with no prefix:
+ *
+ *                                                       +------------+-------+
+ *                                                       | injection  | frame |
+ *                                                       |   header   |       |
+ *                                                       +------------+-------+
+ *                                                          128 bits
+ *
+ * The injection header looks like this (network byte order, bit 127
+ * is part of lowest address byte in memory, bit 0 is part of highest
+ * address byte):
+ *
+ *         +------+------+------+------+------+------+------+------+
+ * 127:120 |BYPASS| MASQ |          MASQ_PORT        |REW_OP|REW_OP|
+ *         +------+------+------+------+------+------+------+------+
+ * 119:112 |                         REW_OP                        |
+ *         +------+------+------+------+------+------+------+------+
+ * 111:104 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ * 103: 96 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  95: 88 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  87: 80 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  79: 72 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  71: 64 |            RSV            |           DEST            |
+ *         +------+------+------+------+------+------+------+------+
+ *  63: 56 |                         DEST                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  55: 48 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  47: 40 |  RSV |         SRC_PORT          |     RSV     |TFRM_TIMER|
+ *         +------+------+------+------+------+------+------+------+
+ *  39: 32 |     TFRM_TIMER     |               RSV                |
+ *         +------+------+------+------+------+------+------+------+
+ *  31: 24 |  RSV |  DP  |   POP_CNT   |           CPUQ            |
+ *         +------+------+------+------+------+------+------+------+
+ *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
+ *         +------+------+------+------+------+------+------+------+
+ *  15:  8 |         PCP        |  DEI |            VID            |
+ *         +------+------+------+------+------+------+------+------+
+ *   7:  0 |                          VID                          |
+ *         +------+------+------+------+------+------+------+------+
+ *
+ * And the extraction header looks like this:
+ *
+ *         +------+------+------+------+------+------+------+------+
+ * 127:120 |  RSV |                  REW_OP                        |
+ *         +------+------+------+------+------+------+------+------+
+ * 119:112 |       REW_OP       |              REW_VAL             |
+ *         +------+------+------+------+------+------+------+------+
+ * 111:104 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ * 103: 96 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  95: 88 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  87: 80 |       REW_VAL      |               LLEN               |
+ *         +------+------+------+------+------+------+------+------+
+ *  79: 72 | LLEN |                      WLEN                      |
+ *         +------+------+------+------+------+------+------+------+
+ *  71: 64 | WLEN |                      RSV                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  63: 56 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  55: 48 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  47: 40 | RSV  |          SRC_PORT         |       ACL_ID       |
+ *         +------+------+------+------+------+------+------+------+
+ *  39: 32 |       ACL_ID       |  RSV |         SFLOW_ID          |
+ *         +------+------+------+------+------+------+------+------+
+ *  31: 24 |ACL_HIT| DP  |  LRN_FLAGS  |           CPUQ            |
+ *         +------+------+------+------+------+------+------+------+
+ *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
+ *         +------+------+------+------+------+------+------+------+
+ *  15:  8 |         PCP        |  DEI |            VID            |
+ *         +------+------+------+------+------+------+------+------+
+ *   7:  0 |                          VID                          |
+ *         +------+------+------+------+------+------+------+------+
+ */
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u64 bypass, dest, src, qos_class;
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	u8 *injection;
+
+	if (unlikely(skb_cow_head(skb, OCELOT_TAG_LEN) < 0)) {
+		netdev_err(netdev, "Cannot make room for tag.\n");
+		return NULL;
+	}
+
+	injection = skb_push(skb, OCELOT_TAG_LEN);
+
+	memset(injection, 0, OCELOT_TAG_LEN);
+
+	src = dsa_upstream_port(ds, port);
+	dest = BIT(port);
+	bypass = true;
+	qos_class = skb->priority;
+
+	packing(injection, &bypass,   127, 127, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &dest,      68,  56, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &src,       46,  43, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
+
+	return skb;
+}
+
+static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
+				  struct net_device *netdev,
+				  struct packet_type *pt)
+{
+	u64 src_port, qos_class;
+	u8 *start = skb->data;
+	u8 *extraction;
+
+	/* Revert skb->data by the amount consumed by the DSA master,
+	 * so it points to the beginning of the frame.
+	 */
+	skb_push(skb, ETH_HLEN);
+	/* We don't care about the long prefix, it is just for easy entrance
+	 * into the DSA master's RX filter. Discard it now by moving it into
+	 * the headroom.
+	 */
+	skb_pull(skb, OCELOT_LONG_PREFIX_LEN);
+	/* And skb->data now points to the extraction frame header.
+	 * Keep a pointer to it.
+	 */
+	extraction = skb->data;
+	/* Now the EFH is part of the headroom as well */
+	skb_pull(skb, OCELOT_TAG_LEN);
+	/* Reset the pointer to the real MAC header */
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+	/* And move skb->data to the correct location again */
+	skb_pull(skb, ETH_HLEN);
+
+	/* Remove from inet csum the extraction header */
+	skb_postpull_rcsum(skb, start, OCELOT_LONG_PREFIX_LEN + OCELOT_TAG_LEN);
+
+	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
+
+	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
+	if (!skb->dev)
+		/* The switch will reflect back some frames sent through
+		 * sockets opened on the bare DSA master. These will come back
+		 * with src_port equal to the index of the CPU port, for which
+		 * there is no slave registered. So don't print any error
+		 * message here (ignore and drop those frames).
+		 */
+		return NULL;
+
+	skb->offload_fwd_mark = 1;
+	skb->priority = qos_class;
+
+	return skb;
+}
+
+static struct dsa_device_ops ocelot_netdev_ops = {
+	.name			= "ocelot",
+	.proto			= DSA_TAG_PROTO_OCELOT,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.17.1

