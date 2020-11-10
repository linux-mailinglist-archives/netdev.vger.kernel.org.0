Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25D72AD228
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgKJJNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgKJJNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:13:52 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FEFC0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 01:13:52 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id l2so16502793lfk.0
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 01:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=hjWDvI+VxB1xkP/pKW7wtAhnYs3nNqQBhVyjdpAZ/qo=;
        b=H6o/GL67EENCK8H1gT+gLJE/30W2pZyRMSzUX0NryuFu4XTEC+fGxzRFWhtal+2vYV
         Txau6qIb9bdMQwQ5ebI64QFpcKj71bvtR/01GNWmLGu12dQejUjpaQhzwpaFtk46ambI
         4SixbYml+fnylP9+Vs1lA77lLZNQ9ClFcASBFFpTLY/Vhgsv2Rq7i446l9ylrjNOA2oX
         orDDse6IJj7NcmZjQtf+vl3DW/KFT1m9s6pWcxO0Pt5hMwD6BqRKFK0t9oS6LP2jXFfq
         BckUIlsq51Uy5JE9uuIOlw5IjVodZrVQuwA4pj2OxI2Wkplh9xD4yqamVZf12Yse/w1R
         b6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=hjWDvI+VxB1xkP/pKW7wtAhnYs3nNqQBhVyjdpAZ/qo=;
        b=V6GAMZT9P3Ik9XfqI1qYJxAhh/XT0Lnqt+KTkSvJMTpIAfkn1eDhZquFPj3fDYaERP
         572TfPY2Y3zpn7ryCtGoBMB+xBYbwm/Abm1BBzgAW+fS60TIw1/0Fkv5yvibrGN9c6SH
         8tuBCZLYDC1mxB29hTzpeKSVN/a5zROfoRv0QdffpBNZa9BealptXYkWCtzLbTz+D6es
         NMt75zLL2zSoqKiVQY1beT78/4JXTHfUO7PctdKsT+RstEKS5zsjW1VFzGvlBLR4mhmX
         i96sgU3rewIe+OMDDyGlhB2rTWZaQ5qXHrKSu97YR7vS7roLmXNqqm/NKjhwap+pyOc9
         Xllg==
X-Gm-Message-State: AOAM532GOSE1JB7uHdAS3MG7AvjX52fbN5C0c3XPIyxLR11R7Vc8Fj+6
        +YWrpc4YdJ0hW0AeJzOAaulo7JqdQGgXzHan
X-Google-Smtp-Source: ABdhPJz0iRRhzXSfZiZV6tosezX+C9nGReeG5olC+ChOTogu0eIc7QL/wuIpMnqXnuNgsmbhPIpzIQ==
X-Received: by 2002:ac2:58cf:: with SMTP id u15mr5098249lfo.221.1604999630284;
        Tue, 10 Nov 2020 01:13:50 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id m22sm2044283lfl.14.2020.11.10.01.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 01:13:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
Date:   Tue, 10 Nov 2020 10:13:25 +0100
Message-Id: <20201110091325.21582-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethertype DSA encodes exactly the same information in the DSA tag as
the non-ethertype variety. So refactor out the common parts and reuse
them for both protocols.

This is ensures tag parsing and generation as always consistent across
all mv88e6xxx chips.

While we are at it, explicitly deal with all possible CPU codes on
receive, making sure to set offload_fwd_mark as appropriate.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

I've tried to verify all dimensions of this: Rx of TO_CPU and FORWARD,
Tx of FROM_CPU, both tagged and untagged, from both the first and a
cascaded chip.

Tested on:
1. 6352+6097F
2. 6390X

 net/dsa/Kconfig    |   6 +
 net/dsa/Makefile   |   3 +-
 net/dsa/tag_dsa.c  | 299 ++++++++++++++++++++++++++++++++++++---------
 net/dsa/tag_edsa.c | 202 ------------------------------
 4 files changed, 245 insertions(+), 265 deletions(-)
 delete mode 100644 net/dsa/tag_edsa.c

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index d975614f7dd6..42d8ad84f92f 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -68,14 +68,20 @@ config NET_DSA_TAG_GSWIP
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Lantiq / Intel GSWIP switches.
 
+config NET_DSA_TAG_DSA_COMMON
+	tristate
+	default n
+
 config NET_DSA_TAG_DSA
 	tristate "Tag driver for Marvell switches using DSA headers"
+	select NET_DSA_TAG_DSA_COMMON
 	help
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Marvell switches which use DSA headers.
 
 config NET_DSA_TAG_EDSA
 	tristate "Tag driver for Marvell switches using EtherType DSA headers"
+	select NET_DSA_TAG_DSA_COMMON
 	help
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Marvell switches which use EtherType DSA headers.
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index e25d5457964a..0fb2b75a7ae3 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -7,8 +7,7 @@ dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
 obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
 obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
-obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
-obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
+obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 63d690a0fca6..b8ee852a46d8 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -1,7 +1,47 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * net/dsa/tag_dsa.c - (Non-ethertype) DSA tagging
+ * Regular and Ethertype DSA tagging
  * Copyright (c) 2008-2009 Marvell Semiconductor
+ *
+ * Regular DSA
+ * -----------
+ * For untagged (in 802.1Q terms) packes, the swich will splice in the
+ * tag between the SA and the ethertype of the original packet. Tagged
+ * frames will instead have their outermost .1Q tag converted to a DSA
+ * tag. It expects the same layout when receiving packets from the
+ * CPU.
+ *
+ * Example:
+ *
+ *     .----.----.----.---------
+ * Pu: | DA | SA | ET | Payload ...
+ *     '----'----'----'---------
+ *       6    6    2       N
+ *     .----.----.--------.-----.----.---------
+ * Pt: | DA | SA | 0x8100 | TCI | ET | Payload ...
+ *     '----'----'--------'-----'----'---------
+ *       6    6       2      2    2       N
+ *     .----.----.-----.----.---------
+ * Pd: | DA | SA | DSA | ET | Payload ...
+ *     '----'----'-----'----'---------
+ *       6    6     4    2       N
+ *
+ * No matter if a packet is received untagged (Pu) or tagged (Pt),
+ * they will both have the same layout (Pd) when they are sent to the
+ * CPU. This is done by ignoring 802.3, replacing the ethertype field
+ * with more metadata, among which is a bit to signal if the original
+ * packet was tagged or not.
+ *
+ * Ethertype DSA
+ * -------------
+ * Uses the exact same tag format as regular DSA, but also includes a
+ * proper ethertype field (which the mv88e6xxx driver sets to
+ * ETH_P_EDSA/0xdada) followed by two zero bytes:
+ *
+ * .----.----.--------.--------.-----.----.---------
+ * | DA | SA | 0xdada | 0x0000 | DSA | ET | Payload ...
+ * '----'----'--------'--------'-----'----'---------
+ *   6    6       2        2      4    2       N
  */
 
 #include <linux/etherdevice.h>
@@ -10,43 +50,79 @@
 
 #include "dsa_priv.h"
 
-#define DSA_HLEN	4
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA_COMMON)
 
-static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
+#define DSA_HLEN 4
+
+/**
+ * enum dsa_cmd - DSA Command
+ * @DSA_CMD_TO_CPU: Set on packets that where trapped or mirrored to
+ *     the CPU port. This is needed to implement control protocols,
+ *     e.g. STP and LLDP, that must not allow those control packets to
+ *     be switched according to the normal rules.
+ * @DSA_CMD_FROM_CPU: Used by the CPU to send a packet to a specific
+ *     port, ignoring all the barriers that the switch normally
+ *     enforces (VLANs, STP port states etc.). "sudo send packet"
+ * @DSA_CMD_TO_SNIFFER: Set on packets that where mirrored to the CPU
+ *     as a result of matching some user configured ingress or egress
+ *     monitor criteria.
+ * @DSA_CMD_FORWARD: Everything else, i.e. the bulk data traffic.
+ */
+enum dsa_cmd {
+	DSA_CMD_TO_CPU     = 0,
+	DSA_CMD_FROM_CPU   = 1,
+	DSA_CMD_TO_SNIFFER = 2,
+	DSA_CMD_FORWARD    = 3
+};
+
+/**
+ * enum dsa_code - TO_CPU Code
+ *
+ * A 3-bit code is used to relay why a particular frame was sent to
+ * the CPU. We only use this to determine if the packet was trapped or
+ * mirrored, i.e. whether the packet has been forwarded by hardware or
+ * not.
+ */
+enum dsa_code {
+	DSA_CODE_MGMT_TRAP     = 0,
+	DSA_CODE_FRAME2REG     = 1,
+	DSA_CODE_IGMP_MLD_TRAP = 2,
+	DSA_CODE_POLICY_TRAP   = 3,
+	DSA_CODE_ARP_MIRROR    = 4,
+	DSA_CODE_POLICY_MIRROR = 5,
+	DSA_CODE_RESERVED_6    = 6,
+	DSA_CODE_RESERVED_7    = 7
+};
+
+static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
+				   u8 extra)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *dsa_header;
 
-	/*
-	 * Convert the outermost 802.1q tag to a DSA tag for tagged
-	 * packets, or insert a DSA tag between the addresses and
-	 * the ethertype field for untagged packets.
-	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		/*
-		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
-		 */
-		dsa_header = skb->data + 2 * ETH_ALEN;
-		dsa_header[0] = 0x60 | dp->ds->index;
+		if (extra) {
+			skb_push(skb, extra);
+			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
+		}
+
+		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
+		dsa_header = skb->data + 2 * ETH_ALEN + extra;
+		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
 		dsa_header[1] = dp->index << 3;
 
-		/*
-		 * Move CFI field from byte 2 to byte 1.
-		 */
+		/* Move CFI field from byte 2 to byte 1. */
 		if (dsa_header[2] & 0x10) {
 			dsa_header[1] |= 0x01;
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		skb_push(skb, DSA_HLEN);
-
-		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
+		skb_push(skb, DSA_HLEN + extra);
+		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/*
-		 * Construct untagged FROM_CPU DSA tag.
-		 */
-		dsa_header = skb->data + 2 * ETH_ALEN;
-		dsa_header[0] = 0x40 | dp->ds->index;
+		/* Construct untagged FROM_CPU DSA tag. */
+		dsa_header = skb->data + 2 * ETH_ALEN + extra;
+		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
 		dsa_header[1] = dp->index << 3;
 		dsa_header[2] = 0x00;
 		dsa_header[3] = 0x00;
@@ -55,30 +131,62 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
-static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
-			       struct packet_type *pt)
+static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
+				  u8 extra)
 {
+	int source_device, source_port;
+	enum dsa_code code;
+	enum dsa_cmd cmd;
 	u8 *dsa_header;
-	int source_device;
-	int source_port;
 
-	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
-		return NULL;
-
-	/*
-	 * The ethertype field is part of the DSA header.
-	 */
+	/* The ethertype field is part of the DSA header. */
 	dsa_header = skb->data - 2;
 
-	/*
-	 * Check that frame type is either TO_CPU or FORWARD.
-	 */
-	if ((dsa_header[0] & 0xc0) != 0x00 && (dsa_header[0] & 0xc0) != 0xc0)
+	cmd = dsa_header[0] >> 6;
+	switch (cmd) {
+	case DSA_CMD_FORWARD:
+		skb->offload_fwd_mark = 1;
+		break;
+
+	case DSA_CMD_TO_CPU:
+		code = (dsa_header[1] & 0x6) | ((dsa_header[2] >> 4) & 1);
+
+		switch (code) {
+		case DSA_CODE_FRAME2REG:
+			/* Remote management frames originate from the
+			 * switch itself, there is no DSA port for us
+			 * to ingress it on (the port field is always
+			 * 0 in these tags).
+			 */
+			return NULL;
+		case DSA_CODE_ARP_MIRROR:
+		case DSA_CODE_POLICY_MIRROR:
+			/* Mark mirrored packets to notify any upper
+			 * device (like a bridge) that forwarding has
+			 * already been done by hardware.
+			 */
+			skb->offload_fwd_mark = 1;
+			break;
+		case DSA_CODE_MGMT_TRAP:
+		case DSA_CODE_IGMP_MLD_TRAP:
+		case DSA_CODE_POLICY_TRAP:
+			/* Traps have, by definition, not been
+			 * forwarded by hardware, so don't mark them.
+			 */
+			break;
+		default:
+			/* Reserved code, this could be anything. Drop
+			 * seems like the safest option.
+			 */
+			return NULL;
+		}
+
+		break;
+
+	default:
 		return NULL;
+	}
 
-	/*
-	 * Determine source device and port.
-	 */
 	source_device = dsa_header[0] & 0x1f;
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
@@ -86,16 +194,15 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
-	/*
-	 * Convert the DSA header to an 802.1q header if the 'tagged'
-	 * bit in the DSA header is set.  If the 'tagged' bit is clear,
-	 * delete the DSA header entirely.
+	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
+	 * tag, and delete the ethertype (extra) if applicable. If the
+	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
+	 * if applicable.
 	 */
 	if (dsa_header[0] & 0x20) {
 		u8 new_header[4];
 
-		/*
-		 * Insert 802.1q ethertype and copy the VLAN-related
+		/* Insert 802.1Q ethertype and copy the VLAN-related
 		 * fields, but clear the bit that will hold CFI (since
 		 * DSA uses that bit location for another purpose).
 		 */
@@ -104,16 +211,13 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 		new_header[2] = dsa_header[2] & ~0x10;
 		new_header[3] = dsa_header[3];
 
-		/*
-		 * Move CFI bit from its place in the DSA header to
-		 * its 802.1q-designated place.
+		/* Move CFI bit from its place in the DSA header to
+		 * its 802.1Q-designated place.
 		 */
 		if (dsa_header[1] & 0x01)
 			new_header[2] |= 0x10;
 
-		/*
-		 * Update packet checksum if skb is CHECKSUM_COMPLETE.
-		 */
+		/* Update packet checksum if skb is CHECKSUM_COMPLETE. */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
 			__wsum c = skb->csum;
 			c = csum_add(c, csum_partial(new_header + 2, 2, 0));
@@ -122,21 +226,39 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		memcpy(dsa_header, new_header, DSA_HLEN);
+
+		if (extra)
+			memmove(skb->data - ETH_HLEN,
+				skb->data - ETH_HLEN - extra,
+				2 * ETH_ALEN);
 	} else {
-		/*
-		 * Remove DSA tag and update checksum.
-		 */
 		skb_pull_rcsum(skb, DSA_HLEN);
 		memmove(skb->data - ETH_HLEN,
-			skb->data - ETH_HLEN - DSA_HLEN,
+			skb->data - ETH_HLEN - DSA_HLEN - extra,
 			2 * ETH_ALEN);
 	}
 
-	skb->offload_fwd_mark = 1;
-
 	return skb;
 }
 
+#endif	/* CONFIG_NET_DSA_TAG_DSA_COMMON */
+
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
+
+static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	return dsa_xmit_ll(skb, dev, 0);
+}
+
+static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
+			       struct packet_type *pt)
+{
+	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
+		return NULL;
+
+	return dsa_rcv_ll(skb, dev, 0);
+}
+
 static const struct dsa_device_ops dsa_netdev_ops = {
 	.name	= "dsa",
 	.proto	= DSA_TAG_PROTO_DSA,
@@ -145,7 +267,62 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.overhead = DSA_HLEN,
 };
 
-MODULE_LICENSE("GPL");
+DSA_TAG_DRIVER(dsa_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_DSA);
+#endif	/* CONFIG_NET_DSA_TAG_DSA */
+
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_EDSA)
 
-module_dsa_tag_driver(dsa_netdev_ops);
+#define EDSA_HLEN 8
+
+static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	u8 *edsa_header;
+
+	skb = dsa_xmit_ll(skb, dev, EDSA_HLEN - DSA_HLEN);
+	if (!skb)
+		return NULL;
+
+	edsa_header = skb->data + 2 * ETH_ALEN;
+	edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
+	edsa_header[1] = ETH_P_EDSA & 0xff;
+	edsa_header[2] = 0x00;
+	edsa_header[3] = 0x00;
+	return skb;
+}
+
+static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
+				struct packet_type *pt)
+{
+	if (unlikely(!pskb_may_pull(skb, EDSA_HLEN)))
+		return NULL;
+
+	skb_pull_rcsum(skb, EDSA_HLEN - DSA_HLEN);
+
+	return dsa_rcv_ll(skb, dev, EDSA_HLEN - DSA_HLEN);
+}
+
+static const struct dsa_device_ops edsa_netdev_ops = {
+	.name	= "edsa",
+	.proto	= DSA_TAG_PROTO_EDSA,
+	.xmit	= edsa_xmit,
+	.rcv	= edsa_rcv,
+	.overhead = EDSA_HLEN,
+};
+
+DSA_TAG_DRIVER(edsa_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_EDSA);
+#endif	/* CONFIG_NET_DSA_TAG_EDSA */
+
+static struct dsa_tag_driver *dsa_tag_drivers[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
+	&DSA_TAG_DRIVER_NAME(dsa_netdev_ops),
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_EDSA)
+	&DSA_TAG_DRIVER_NAME(edsa_netdev_ops),
+#endif
+};
+
+module_dsa_tag_drivers(dsa_tag_drivers);
+
+MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
deleted file mode 100644
index abf70a29deb4..000000000000
--- a/net/dsa/tag_edsa.c
+++ /dev/null
@@ -1,202 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * net/dsa/tag_edsa.c - Ethertype DSA tagging
- * Copyright (c) 2008-2009 Marvell Semiconductor
- */
-
-#include <linux/etherdevice.h>
-#include <linux/list.h>
-#include <linux/slab.h>
-
-#include "dsa_priv.h"
-
-#define DSA_HLEN	4
-#define EDSA_HLEN	8
-
-#define FRAME_TYPE_TO_CPU	0x00
-#define FRAME_TYPE_FORWARD	0x03
-
-#define TO_CPU_CODE_MGMT_TRAP		0x00
-#define TO_CPU_CODE_FRAME2REG		0x01
-#define TO_CPU_CODE_IGMP_MLD_TRAP	0x02
-#define TO_CPU_CODE_POLICY_TRAP		0x03
-#define TO_CPU_CODE_ARP_MIRROR		0x04
-#define TO_CPU_CODE_POLICY_MIRROR	0x05
-
-static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 *edsa_header;
-
-	/*
-	 * Convert the outermost 802.1q tag to a DSA tag and prepend
-	 * a DSA ethertype field is the packet is tagged, or insert
-	 * a DSA ethertype plus DSA tag between the addresses and the
-	 * current ethertype field if the packet is untagged.
-	 */
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, DSA_HLEN);
-
-		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
-
-		/*
-		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
-		 */
-		edsa_header = skb->data + 2 * ETH_ALEN;
-		edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
-		edsa_header[1] = ETH_P_EDSA & 0xff;
-		edsa_header[2] = 0x00;
-		edsa_header[3] = 0x00;
-		edsa_header[4] = 0x60 | dp->ds->index;
-		edsa_header[5] = dp->index << 3;
-
-		/*
-		 * Move CFI field from byte 6 to byte 5.
-		 */
-		if (edsa_header[6] & 0x10) {
-			edsa_header[5] |= 0x01;
-			edsa_header[6] &= ~0x10;
-		}
-	} else {
-		skb_push(skb, EDSA_HLEN);
-
-		memmove(skb->data, skb->data + EDSA_HLEN, 2 * ETH_ALEN);
-
-		/*
-		 * Construct untagged FROM_CPU DSA tag.
-		 */
-		edsa_header = skb->data + 2 * ETH_ALEN;
-		edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
-		edsa_header[1] = ETH_P_EDSA & 0xff;
-		edsa_header[2] = 0x00;
-		edsa_header[3] = 0x00;
-		edsa_header[4] = 0x40 | dp->ds->index;
-		edsa_header[5] = dp->index << 3;
-		edsa_header[6] = 0x00;
-		edsa_header[7] = 0x00;
-	}
-
-	return skb;
-}
-
-static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
-				struct packet_type *pt)
-{
-	u8 *edsa_header;
-	int frame_type;
-	int code;
-	int source_device;
-	int source_port;
-
-	if (unlikely(!pskb_may_pull(skb, EDSA_HLEN)))
-		return NULL;
-
-	/*
-	 * Skip the two null bytes after the ethertype.
-	 */
-	edsa_header = skb->data + 2;
-
-	/*
-	 * Check that frame type is either TO_CPU or FORWARD.
-	 */
-	frame_type = edsa_header[0] >> 6;
-
-	switch (frame_type) {
-	case FRAME_TYPE_TO_CPU:
-		code = (edsa_header[1] & 0x6) | ((edsa_header[2] >> 4) & 1);
-
-		/*
-		 * Mark the frame to never egress on any port of the same switch
-		 * unless it's a trapped IGMP/MLD packet, in which case the
-		 * bridge might want to forward it.
-		 */
-		if (code != TO_CPU_CODE_IGMP_MLD_TRAP)
-			skb->offload_fwd_mark = 1;
-
-		break;
-
-	case FRAME_TYPE_FORWARD:
-		skb->offload_fwd_mark = 1;
-		break;
-
-	default:
-		return NULL;
-	}
-
-	/*
-	 * Determine source device and port.
-	 */
-	source_device = edsa_header[0] & 0x1f;
-	source_port = (edsa_header[1] >> 3) & 0x1f;
-
-	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
-	if (!skb->dev)
-		return NULL;
-
-	/*
-	 * If the 'tagged' bit is set, convert the DSA tag to a 802.1q
-	 * tag and delete the ethertype part.  If the 'tagged' bit is
-	 * clear, delete the ethertype and the DSA tag parts.
-	 */
-	if (edsa_header[0] & 0x20) {
-		u8 new_header[4];
-
-		/*
-		 * Insert 802.1q ethertype and copy the VLAN-related
-		 * fields, but clear the bit that will hold CFI (since
-		 * DSA uses that bit location for another purpose).
-		 */
-		new_header[0] = (ETH_P_8021Q >> 8) & 0xff;
-		new_header[1] = ETH_P_8021Q & 0xff;
-		new_header[2] = edsa_header[2] & ~0x10;
-		new_header[3] = edsa_header[3];
-
-		/*
-		 * Move CFI bit from its place in the DSA header to
-		 * its 802.1q-designated place.
-		 */
-		if (edsa_header[1] & 0x01)
-			new_header[2] |= 0x10;
-
-		skb_pull_rcsum(skb, DSA_HLEN);
-
-		/*
-		 * Update packet checksum if skb is CHECKSUM_COMPLETE.
-		 */
-		if (skb->ip_summed == CHECKSUM_COMPLETE) {
-			__wsum c = skb->csum;
-			c = csum_add(c, csum_partial(new_header + 2, 2, 0));
-			c = csum_sub(c, csum_partial(edsa_header + 2, 2, 0));
-			skb->csum = c;
-		}
-
-		memcpy(edsa_header, new_header, DSA_HLEN);
-
-		memmove(skb->data - ETH_HLEN,
-			skb->data - ETH_HLEN - DSA_HLEN,
-			2 * ETH_ALEN);
-	} else {
-		/*
-		 * Remove DSA tag and update checksum.
-		 */
-		skb_pull_rcsum(skb, EDSA_HLEN);
-		memmove(skb->data - ETH_HLEN,
-			skb->data - ETH_HLEN - EDSA_HLEN,
-			2 * ETH_ALEN);
-	}
-
-	return skb;
-}
-
-static const struct dsa_device_ops edsa_netdev_ops = {
-	.name	= "edsa",
-	.proto	= DSA_TAG_PROTO_EDSA,
-	.xmit	= edsa_xmit,
-	.rcv	= edsa_rcv,
-	.overhead = EDSA_HLEN,
-};
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_EDSA);
-
-module_dsa_tag_driver(edsa_netdev_ops);
-- 
2.17.1

