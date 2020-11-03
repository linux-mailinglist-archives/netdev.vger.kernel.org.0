Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CBB2A3D3F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCHLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:11:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36044 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCHLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:11:36 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604387493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Cb5CPMyks0SNB+anMkVChyamq93YSY47XdhZK036tQ=;
        b=a2bw4C3egCxmI3MpTtpQ5SZGc8s5gU/uaF+nMRf6XiVvRCHUsBvvtfQ+RV2jlNiMF4zvEK
        fB3sZmXWgiuHvb414m0zNbkaUUWoO0k5vAePsCbMIOU4grFovlwa+yfWPVSxVN8NSgQveC
        degUfMxYIO944mrpKT05WH9F7sMbVv6z9HGfUuv3BxyZAMO7UCm8Ae8HbPrR5oj4kw6jPU
        7+gQqcqSQUlc5PmpSpPTwWCXI8OQ9+iRbQFUa95SGHZU/yIJ0ou0Kl4QP7FvRhUOcwcEHb
        /KvSum90dkrSnijwDnZvs7c5OVb8Daj51IUdW44nEcXGkpSuM7vPoNeLmQJi7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604387493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Cb5CPMyks0SNB+anMkVChyamq93YSY47XdhZK036tQ=;
        b=K+F4D+7ptL7ZpROW/qkkRoTYO201/Ij54pjn5Iqh1vPrqHRrIaENxh0DEWPr4xL7wHMdVS
        JfzBr53w/aqqYeAQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v8 1/8] net: dsa: Add tag handling for Hirschmann Hellcreek switches
Date:   Tue,  3 Nov 2020 08:10:54 +0100
Message-Id: <20201103071101.3222-2-kurt@linutronix.de>
In-Reply-To: <20201103071101.3222-1-kurt@linutronix.de>
References: <20201103071101.3222-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
exchanged between the CPU port and the master interface. The format is a one
byte trailer indicating the destination or origin port.

It's quite similar to the Micrel KSZ tagging. That's why the implementation is
based on that code.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/net/dsa.h       |  2 ++
 net/dsa/Kconfig         |  6 ++++
 net/dsa/Makefile        |  1 +
 net/dsa/tag_hellcreek.c | 66 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)
 create mode 100644 net/dsa/tag_hellcreek.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..04e93bafb7bd 100644
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
index 000000000000..2061de06eafb
--- /dev/null
+++ b/net/dsa/tag_hellcreek.c
@@ -0,0 +1,66 @@
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
+	u8 *tag;
+
+	/* Tag encoding */
+	tag  = skb_put(skb, HELLCREEK_TAG_LEN);
+	*tag = BIT(dp->index);
+
+	return skb;
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
+	.tail_tag = true,
+};
+
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK);
+
+module_dsa_tag_driver(hellcreek_netdev_ops);
-- 
2.20.1

