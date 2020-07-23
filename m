Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F422AA77
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGWIRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 04:17:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56102 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGWIRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 04:17:30 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595492248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wkzoTRiyOsycl/LZaqYLFgW1cltrQXALA2WJY8fpFCg=;
        b=OzsIGNMwQnxrYfXpP6WOf1zfMI9zgOtpcn5C0ndvMyxlOvP2nzZjKDcWXxUvvI4Luw1JL7
        naI+Jzw4VF57RYiy00i4L+8eliWtmsIySZocJ4+ru3SngxmvU/hfoX1pxuIxMaIqWAUHNF
        Z4JJZJuUYGwuwTIZvlrANlD5rm5d45rNUryWVyIfDfsTtgwANY+AnLITdtKqdL735T4cih
        A67G5ak1SXV7IMh3Z2Q3O5GIP7HN7QfPtsGisAK1Jr6hJEXZg+InCbOaev1a1FWGXTtuPf
        LvpUHDQcSsMqZCRn+V2opXxbZPZnN8bt8kQ5uoSG7XWAcX4jBia3B1UTq7blSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595492248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wkzoTRiyOsycl/LZaqYLFgW1cltrQXALA2WJY8fpFCg=;
        b=KDEaAXuqnX5BaHIziY5Vwj/tJOe2rgrIsGtAPqsAmg6cdD2bewfXok/vi53jK5wvDWHSCL
        n9eCdjorZpmbIABQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 1/8] net: dsa: Add tag handling for Hirschmann Hellcreek switches
Date:   Thu, 23 Jul 2020 10:17:07 +0200
Message-Id: <20200723081714.16005-2-kurt@linutronix.de>
In-Reply-To: <20200723081714.16005-1-kurt@linutronix.de>
References: <20200723081714.16005-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
exchanged between the CPU port and the master interface. The format is a one
byte trailer indicating the destination or origin port.

It's quite similar to the Micrel KSZ tagging. That's why the implementation is
based on that code.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/net/dsa.h       |   2 +
 net/dsa/Kconfig         |   6 +++
 net/dsa/Makefile        |   1 +
 net/dsa/tag_hellcreek.c | 101 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)
 create mode 100644 net/dsa/tag_hellcreek.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f1b63d06d132..38af8f44cff4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -45,6 +45,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_OCELOT_VALUE		15
 #define DSA_TAG_PROTO_AR9331_VALUE		16
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
+#define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -65,6 +66,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
 	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
+	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 1f9b9b11008c..d975614f7dd6 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -56,6 +56,12 @@ config NET_DSA_TAG_BRCM_PREPEND
 	  Broadcom switches which places the tag before the Ethernet header
 	  (prepended).
 
+config NET_DSA_TAG_HELLCREEK
+	tristate "Tag driver for Hirschmann Hellcreek TSN switches"
+	help
+	  Say Y or M if you want to enable support for tagging frames
+	  for the Hirschmann Hellcreek TSN switches.
+
 config NET_DSA_TAG_GSWIP
 	tristate "Tag driver for Lantiq / Intel GSWIP switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 4f47b2025ff5..e25d5457964a 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
+obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
new file mode 100644
index 000000000000..0895eda94bb5
--- /dev/null
+++ b/net/dsa/tag_hellcreek.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * net/dsa/tag_hellcreek.c - Hirschmann Hellcreek switch tag format handling
+ *
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ *
+ * Based on tag_ksz.c.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <net/dsa.h>
+
+#include "dsa_priv.h"
+
+#define HELLCREEK_TAG_LEN	1
+
+static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct sk_buff *nskb;
+	int padlen;
+	u8 *tag;
+
+	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
+
+	if (skb_tailroom(skb) >= padlen + HELLCREEK_TAG_LEN) {
+		/* Let dsa_slave_xmit() free skb */
+		if (__skb_put_padto(skb, skb->len + padlen, false))
+			return NULL;
+
+		nskb = skb;
+	} else {
+		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
+				 padlen + HELLCREEK_TAG_LEN, GFP_ATOMIC);
+		if (!nskb)
+			return NULL;
+		skb_reserve(nskb, NET_IP_ALIGN);
+
+		skb_reset_mac_header(nskb);
+		skb_set_network_header(nskb,
+				       skb_network_header(skb) - skb->head);
+		skb_set_transport_header(nskb,
+					 skb_transport_header(skb) - skb->head);
+		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
+
+		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
+		 * skb
+		 */
+		if (skb_put_padto(nskb, nskb->len + padlen))
+			return NULL;
+
+		consume_skb(skb);
+	}
+
+	if (!nskb)
+		return NULL;
+
+	/* Tag encoding */
+	tag  = skb_put(nskb, HELLCREEK_TAG_LEN);
+	*tag = BIT(dp->index);
+
+	return nskb;
+}
+
+static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
+				     struct net_device *dev,
+				     struct packet_type *pt)
+{
+	/* Tag decoding */
+	u8 *tag = skb_tail_pointer(skb) - HELLCREEK_TAG_LEN;
+	unsigned int port = tag[0] & 0x03;
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev) {
+		netdev_warn(dev, "Failed to get source port: %d\n", port);
+		return NULL;
+	}
+
+	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+
+	skb->offload_fwd_mark = true;
+
+	return skb;
+}
+
+static const struct dsa_device_ops hellcreek_netdev_ops = {
+	.name	  = "hellcreek",
+	.proto	  = DSA_TAG_PROTO_HELLCREEK,
+	.xmit	  = hellcreek_xmit,
+	.rcv	  = hellcreek_rcv,
+	.overhead = HELLCREEK_TAG_LEN,
+};
+
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK);
+
+module_dsa_tag_driver(hellcreek_netdev_ops);
-- 
2.20.1

