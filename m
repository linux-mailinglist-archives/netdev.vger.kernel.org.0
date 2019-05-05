Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F513ECC
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfEEKT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36941 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEEKTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id y5so11705571wma.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sZvxw8qVF0j8HUBHq223l31JUFIrwWUc5PDw4LXj+ys=;
        b=qQTb8/59JPpUwEKWxNhAxIiT7zzvnCrQEFHblLf3R4smwMCebfG5NfCOZdKqbsqi1e
         oraCDOzgS2zyz5D3DO6AWgtEkE9igGA1mLxCJuRUt1V2B+ipe3CC0dMF3reF1KNKgtj2
         56PE7cPUlUahwFw5erCVP++aPyPG3XDTvm9aWrv2lgTpDUEjVNpcw7KnlHDUzzPsuDca
         PoWOeqvM3lJO5sxuslzTbgLFwUal6P82D9piswyIaP0iPZmNJ1Ss+MV1I8ubaZKMQCCn
         VUxgTmzsZT1KEGM6Ok64PLb3W9K7Kuk2xTPkpdL9nqYyAU/WZGHNuZ78Lyoy+NFaSIv6
         HxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sZvxw8qVF0j8HUBHq223l31JUFIrwWUc5PDw4LXj+ys=;
        b=VGW6gy5L8iQo01F+jSX2WYNJlTxMebXl3Jmcgi4Ftm2k06xtFj9STzN36mKvlzs+ko
         Q96KJdnadJEJscdGpkEGsvwER+GyBDtPuzU1P2encempArcsXT3eAW+OtuYKDA5UkQdO
         g/aan8XZwS9Tn3hJR6hi7VicWlfWmV/kKEi7A2VUZ4ZPlAoLhX1o6OkoWMAsFv+nEfKi
         BUkBuXimkwaFEvz2c10W7lkG9Jm6MNbP7Yjj/UNE2Wgew5RmXlX1oLiwNbJFywfBA7vy
         ObCmkk/UJlW14Js1lnCuZnBN88/TuQjhhcebQGushLukmjhv+4ekxLi6yYVMrJCx4WdX
         xXAw==
X-Gm-Message-State: APjAAAWOfac5vyVo5Mrif27dy6oGj+sSu5iEcX+/dTxV95hBIPMhfqzT
        wjJchz2UDwJMIEDvTtYZnLfQL5k5
X-Google-Smtp-Source: APXvYqw3bttYjYwxq9K22d9kg9AGw0hff2/qAiDxVPcwOW3ZTP9sFl/OxfxHGiYHzCnhlDrtxqkYgg==
X-Received: by 2002:a1c:c7c8:: with SMTP id x191mr12703380wmf.146.1557051587604;
        Sun, 05 May 2019 03:19:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 08/10] net: dsa: sja1105: Add support for traffic through standalone ports
Date:   Sun,  5 May 2019 13:19:27 +0300
Message-Id: <20190505101929.17056-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support this, we are creating a make-shift switch tag out of
a VLAN trunk configured on the CPU port. Termination of normal traffic
on switch ports only works when not under a vlan_filtering bridge.
Termination of management (PTP, BPDU) traffic works under all
circumstances because it uses a different tagging mechanism
(incl_srcpt). We are making use of the generic CONFIG_NET_DSA_TAG_8021Q
code and leveraging it from our own CONFIG_NET_DSA_TAG_SJA1105.

There are two types of traffic: regular and link-local.

The link-local traffic received on the CPU port is trapped from the
switch's regular forwarding decisions because it matched one of the two
DMAC filters for management traffic.

On transmission, the switch requires special massaging for these
link-local frames. Due to a weird implementation of the switching IP, by
default it drops link-local frames that originate on the CPU port.
It needs to be told where to forward them to, through an SPI command
("management route") that is valid for only a single frame.
So when we're sending link-local traffic, we are using the
dsa_defer_xmit mechanism.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
  - None.

Changes in v2:
  - None.

 drivers/net/dsa/sja1105/Kconfig        |   1 +
 drivers/net/dsa/sja1105/sja1105.h      |   6 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 138 +++++++++++++++++++++++--
 include/linux/dsa/sja1105.h            |  35 +++++--
 include/net/dsa.h                      |   2 +
 net/dsa/Kconfig                        |   9 ++
 net/dsa/Makefile                       |   1 +
 net/dsa/tag_sja1105.c                  | 131 +++++++++++++++++++++++
 8 files changed, 308 insertions(+), 15 deletions(-)
 create mode 100644 net/dsa/tag_sja1105.c

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 038685bb9d57..757751a89819 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -1,6 +1,7 @@
 config NET_DSA_SJA1105
 tristate "NXP SJA1105 Ethernet switch family support"
 	depends on NET_DSA && SPI
+	select NET_DSA_TAG_SJA1105
 	select PACKING
 	select CRC32
 	help
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index b0a155b57e17..b043bfc408f2 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -7,6 +7,7 @@
 
 #include <linux/dsa/sja1105.h>
 #include <net/dsa.h>
+#include <linux/mutex.h>
 #include "sja1105_static_config.h"
 
 #define SJA1105_NUM_PORTS		5
@@ -65,6 +66,11 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
+	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	/* Serializes transmission of management frames so that
+	 * the switch doesn't confuse them with one another.
+	 */
+	struct mutex mgmt_lock;
 };
 
 #include "sja1105_dynamic_config.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 74f8ff9e17e0..785bb42cb993 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_bridge.h>
 #include <linux/if_ether.h>
+#include <linux/dsa/8021q.h>
 #include "sja1105.h"
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
@@ -406,11 +407,14 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.tpid2 = ETH_P_SJA1105,
 	};
 	struct sja1105_table *table;
-	int i;
+	int i, k = 0;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++)
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		if (dsa_is_dsa_port(priv->ds, i))
 			default_general_params.casc_port = i;
+		else if (dsa_is_user_port(priv->ds, i))
+			priv->ports[i].mgmt_slot = k++;
+	}
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 
@@ -1146,10 +1150,27 @@ static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 	return 0;
 }
 
+static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
+{
+	int rc, i;
+
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		rc = dsa_port_setup_8021q_tagging(ds, i, enabled);
+		if (rc < 0) {
+			dev_err(ds->dev, "Failed to setup VLAN tagging for port %d: %d\n",
+				i, rc);
+			return rc;
+		}
+	}
+	dev_info(ds->dev, "%s switch tagging\n",
+		 enabled ? "Enabled" : "Disabled");
+	return 0;
+}
+
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port)
 {
-	return DSA_TAG_PROTO_NONE;
+	return DSA_TAG_PROTO_SJA1105;
 }
 
 /* This callback needs to be present */
@@ -1173,7 +1194,11 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
 
-	return rc;
+	/* Switch port identification based on 802.1Q is only passable
+	 * if we are not under a vlan_filtering bridge. So make sure
+	 * the two configurations are mutually exclusive.
+	 */
+	return sja1105_setup_8021q_tagging(ds, !enabled);
 }
 
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
@@ -1276,7 +1301,98 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
-	return 0;
+	/* The DSA/switchdev model brings up switch ports in standalone mode by
+	 * default, and that means vlan_filtering is 0 since they're not under
+	 * a bridge, so it's safe to set up switch tagging at this time.
+	 */
+	return sja1105_setup_8021q_tagging(ds, true);
+}
+
+static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
+			     struct sk_buff *skb)
+{
+	struct sja1105_mgmt_entry mgmt_route = {0};
+	struct sja1105_private *priv = ds->priv;
+	struct ethhdr *hdr;
+	int timeout = 10;
+	int rc;
+
+	hdr = eth_hdr(skb);
+
+	mgmt_route.macaddr = ether_addr_to_u64(hdr->h_dest);
+	mgmt_route.destports = BIT(port);
+	mgmt_route.enfport = 1;
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
+					  slot, &mgmt_route, true);
+	if (rc < 0) {
+		kfree_skb(skb);
+		return rc;
+	}
+
+	/* Transfer skb to the host port. */
+	dsa_enqueue_skb(skb, ds->ports[port].slave);
+
+	/* Wait until the switch has processed the frame */
+	do {
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_MGMT_ROUTE,
+						 slot, &mgmt_route);
+		if (rc < 0) {
+			dev_err_ratelimited(priv->ds->dev,
+					    "failed to poll for mgmt route\n");
+			continue;
+		}
+
+		/* UM10944: The ENFPORT flag of the respective entry is
+		 * cleared when a match is found. The host can use this
+		 * flag as an acknowledgment.
+		 */
+		cpu_relax();
+	} while (mgmt_route.enfport && --timeout);
+
+	if (!timeout) {
+		/* Clean up the management route so that a follow-up
+		 * frame may not match on it by mistake.
+		 */
+		sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
+					     slot, &mgmt_route, false);
+		dev_err_ratelimited(priv->ds->dev, "xmit timed out\n");
+	}
+
+	return NETDEV_TX_OK;
+}
+
+/* Deferred work is unfortunately necessary because setting up the management
+ * route cannot be done from atomit context (SPI transfer takes a sleepable
+ * lock on the bus)
+ */
+static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
+					      struct sk_buff *skb)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+	int slot = sp->mgmt_slot;
+
+	/* The tragic fact about the switch having 4x2 slots for installing
+	 * management routes is that all of them except one are actually
+	 * useless.
+	 * If 2 slots are simultaneously configured for two BPDUs sent to the
+	 * same (multicast) DMAC but on different egress ports, the switch
+	 * would confuse them and redirect first frame it receives on the CPU
+	 * port towards the port configured on the numerically first slot
+	 * (therefore wrong port), then second received frame on second slot
+	 * (also wrong port).
+	 * So for all practical purposes, there needs to be a lock that
+	 * prevents that from happening. The slot used here is utterly useless
+	 * (could have simply been 0 just as fine), but we are doing it
+	 * nonetheless, in case a smarter idea ever comes up in the future.
+	 */
+	mutex_lock(&priv->mgmt_lock);
+
+	sja1105_mgmt_xmit(ds, port, slot, skb);
+
+	mutex_unlock(&priv->mgmt_lock);
+	return NETDEV_TX_OK;
 }
 
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
@@ -1324,6 +1440,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_prepare	= sja1105_mdb_prepare,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
+	.port_deferred_xmit	= sja1105_port_deferred_xmit,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -1367,7 +1484,7 @@ static int sja1105_probe(struct spi_device *spi)
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
 	struct dsa_switch *ds;
-	int rc;
+	int rc, i;
 
 	if (!dev->of_node) {
 		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
@@ -1418,6 +1535,15 @@ static int sja1105_probe(struct spi_device *spi)
 	ds->priv = priv;
 	priv->ds = ds;
 
+	/* Connections between dsa_port and sja1105_port */
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		struct sja1105_port *sp = &priv->ports[i];
+
+		ds->ports[i].priv = sp;
+		sp->dp = &ds->ports[i];
+	}
+	mutex_init(&priv->mgmt_lock);
+
 	return dsa_register_switch(priv->ds);
 }
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index abf3977e34fd..603a02e5a8cb 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -2,22 +2,39 @@
  * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 
-/* Included by drivers/net/dsa/sja1105/sja1105.h */
+/* Included by drivers/net/dsa/sja1105/sja1105.h and net/dsa/tag_sja1105.c */
 
 #ifndef _NET_DSA_SJA1105_H
 #define _NET_DSA_SJA1105_H
 
+#include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
 
-/* The switch can only be convinced to stay in unmanaged mode and not trap any
- * link-local traffic by actually telling it to filter frames sent at the
- * 00:00:00:00:00:00 destination MAC.
- */
-#define SJA1105_LINKLOCAL_FILTER_A		0x000000000000ull
-#define SJA1105_LINKLOCAL_FILTER_A_MASK		0xFFFFFFFFFFFFull
-#define SJA1105_LINKLOCAL_FILTER_B		0x000000000000ull
-#define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFFFFFFFFull
+/* IEEE 802.3 Annex 57A: Slow Protocols PDUs (01:80:C2:xx:xx:xx) */
+#define SJA1105_LINKLOCAL_FILTER_A		0x0180C2000000ull
+#define SJA1105_LINKLOCAL_FILTER_A_MASK		0xFFFFFF000000ull
+/* IEEE 1588 Annex F: Transport of PTP over Ethernet (01:1B:19:xx:xx:xx) */
+#define SJA1105_LINKLOCAL_FILTER_B		0x011B19000000ull
+#define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFF000000ull
+
+enum sja1105_frame_type {
+	SJA1105_FRAME_TYPE_NORMAL = 0,
+	SJA1105_FRAME_TYPE_LINK_LOCAL,
+};
+
+struct sja1105_skb_cb {
+	enum sja1105_frame_type type;
+};
+
+#define SJA1105_SKB_CB(skb) \
+	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
+
+struct sja1105_port {
+	struct dsa_port *dp;
+	int mgmt_slot;
+};
 
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e20be1ceb306..6aaaadd6a413 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -43,6 +43,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_QCA_VALUE			10
 #define DSA_TAG_PROTO_TRAILER_VALUE		11
 #define DSA_TAG_PROTO_8021Q_VALUE		12
+#define DSA_TAG_PROTO_SJA1105_VALUE		13
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -58,6 +59,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_QCA		= DSA_TAG_PROTO_QCA_VALUE,
 	DSA_TAG_PROTO_TRAILER		= DSA_TAG_PROTO_TRAILER_VALUE,
 	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
+	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index fc15a7e1a6df..cf855352a440 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -102,6 +102,15 @@ config NET_DSA_TAG_LAN9303
 	  Say Y or M if you want to enable support for tagging frames for the
 	  SMSC/Microchip LAN9303 family of switches.
 
+config NET_DSA_TAG_SJA1105
+	tristate "Tag driver for NXP SJA1105 switches"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y or M if you want to enable support for tagging frames with the
+	  NXP SJA1105 switch family. Both the native tagging protocol (which
+	  is only for link-local traffic) as well as non-native tagging (based
+	  on a custom 802.1Q VLAN header) are available.
+
 config NET_DSA_TAG_TRAILER
 	tristate "Tag driver for switches using a trailer tag"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index e97c794ec57b..c342f54715ba 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -13,4 +13,5 @@ obj-$(CONFIG_NET_DSA_TAG_KSZ_COMMON) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
+obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
new file mode 100644
index 000000000000..969402c7dbf1
--- /dev/null
+++ b/net/dsa/tag_sja1105.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include <linux/if_vlan.h>
+#include <linux/dsa/sja1105.h>
+#include <linux/dsa/8021q.h>
+#include <linux/packing.h>
+#include "dsa_priv.h"
+
+/* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
+static inline bool sja1105_is_link_local(const struct sk_buff *skb)
+{
+	const struct ethhdr *hdr = eth_hdr(skb);
+	u64 dmac = ether_addr_to_u64(hdr->h_dest);
+
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_A)
+		return true;
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_B_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_B)
+		return true;
+	return false;
+}
+
+/* This is the first time the tagger sees the frame on RX.
+ * Figure out if we can decode it, and if we can, annotate skb->cb with how we
+ * plan to do that, so we don't need to check again in the rcv function.
+ */
+static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
+{
+	if (sja1105_is_link_local(skb)) {
+		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_LINK_LOCAL;
+		return true;
+	}
+	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr)) {
+		SJA1105_SKB_CB(skb)->type = SJA1105_FRAME_TYPE_NORMAL;
+		return true;
+	}
+	return false;
+}
+
+static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	struct dsa_switch *ds = dp->ds;
+	u16 tx_vid = dsa_8021q_tx_vid(ds, dp->index);
+	u8 pcp = skb->priority;
+
+	/* Transmitting management traffic does not rely upon switch tagging,
+	 * but instead SPI-installed management routes. Part 2 of this
+	 * is the .port_deferred_xmit driver callback.
+	 */
+	if (unlikely(sja1105_is_link_local(skb)))
+		return dsa_defer_xmit(skb, netdev);
+
+	/* If we are under a vlan_filtering bridge, IP termination on
+	 * switch ports based on 802.1Q tags is simply too brittle to
+	 * be passable. So just defer to the dsa_slave_notag_xmit
+	 * implementation.
+	 */
+	if (dsa_port_is_vlan_filtering(dp))
+		return skb;
+
+	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
+			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+}
+
+static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
+				   struct net_device *netdev,
+				   struct packet_type *pt)
+{
+	struct ethhdr *hdr = eth_hdr(skb);
+	u64 source_port, switch_id;
+	struct sk_buff *nskb;
+	u16 tpid, vid, tci;
+	bool is_tagged;
+
+	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
+	is_tagged = (nskb && tpid == ETH_P_SJA1105);
+
+	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	vid = tci & VLAN_VID_MASK;
+
+	skb->offload_fwd_mark = 1;
+
+	if (SJA1105_SKB_CB(skb)->type == SJA1105_FRAME_TYPE_LINK_LOCAL) {
+		/* Management traffic path. Switch embeds the switch ID and
+		 * port ID into bytes of the destination MAC, courtesy of
+		 * the incl_srcpt options.
+		 */
+		source_port = hdr->h_dest[3];
+		switch_id = hdr->h_dest[4];
+		/* Clear the DMAC bytes that were mangled by the switch */
+		hdr->h_dest[3] = 0;
+		hdr->h_dest[4] = 0;
+	} else {
+		/* Normal traffic path. */
+		source_port = dsa_8021q_rx_source_port(vid);
+		switch_id = dsa_8021q_rx_switch_id(vid);
+	}
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
+	if (!skb->dev) {
+		netdev_warn(netdev, "Couldn't decode source port\n");
+		return NULL;
+	}
+
+	/* Delete/overwrite fake VLAN header, DSA expects to not find
+	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
+	 */
+	if (is_tagged)
+		memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - VLAN_HLEN,
+			ETH_HLEN - VLAN_HLEN);
+
+	return skb;
+}
+
+static struct dsa_device_ops sja1105_netdev_ops = {
+	.name = "sja1105",
+	.proto = DSA_TAG_PROTO_SJA1105,
+	.xmit = sja1105_xmit,
+	.rcv = sja1105_rcv,
+	.filter = sja1105_filter,
+	.overhead = VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1105);
+
+module_dsa_tag_driver(sja1105_netdev_ops);
-- 
2.17.1

