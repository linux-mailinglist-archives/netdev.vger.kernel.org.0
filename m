Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CDB50BFC0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiDVSMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiDVSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:06:47 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3869EE49FF;
        Fri, 22 Apr 2022 11:03:48 -0700 (PDT)
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id ED1BFC291E;
        Fri, 22 Apr 2022 18:03:32 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 606C14000B;
        Fri, 22 Apr 2022 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650650594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bOB03Ql0qmxG+6T9P82rThWtyPk6+o4QxKsRabLUrb0=;
        b=JRWgWVrbGhzpnbUAnIpAdgC9O+JRnD4xAZTPdLyo/1HdKiNLEwGTn6x7bQmlYyCunNbHmq
        AqSIE9R6UMwpyCO9UTtnzUR2d3u2Jd92AnRKMlGgxiHjsZ1133/ERpM+z+sEDvRjPeqC22
        xu7pbMFR1PdHyETRUOgnyVXyUbIItChgVWHZChpHrSl/8GmSeXkoq8gUaunlhBsKeeMIan
        JrwCsrkmULUnbRQ5iPoVu0owKat6Zrxgne/EXHCPX69nl1h5ZWpOxuM1TzOiha2mO8Wdw0
        X+5ldBYu0BuHSkgHemyMVV3qf3kg93+DMNUPIyVsM8X9TMKTLxVir514FF49yw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next 2/5] net: dsa: add out-of-band tagging protocol
Date:   Fri, 22 Apr 2022 20:03:02 +0200
Message-Id: <20220422180305.301882-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tagging protocol is designed for the situation where the link
between the MAC and the Switch is designed such that the Destination
Port, which is usually embedded in some part of the Ethernet Header, is
sent out-of-band, and isn't present at all in the Ethernet frame.

This can happen when the MAC and Switch are tightly integrated on an
SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
tag is inserted directly into the DMA descriptors. In that case,
the MAC driver is responsible for sending the tag to the switch using
the out-of-band medium. To do so, the MAC driver needs to have the
information of the destination port for that skb.

This tagging protocol relies on a new set of fields in skb->shinfo to
transmit the dsa tagging information to and from the MAC driver.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 include/linux/skbuff.h |  7 +++++++
 include/net/dsa.h      |  2 ++
 net/dsa/Kconfig        |  7 +++++++
 net/dsa/Makefile       |  1 +
 net/dsa/tag_oob.c      | 45 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)
 create mode 100644 net/dsa/tag_oob.c

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0ef11df1bc67..6f8012cf9246 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -685,6 +685,11 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg);
 
+struct dsa_tag_info {
+	unsigned int proto;
+	unsigned int dp;
+};
+
 /* This data is invariant across clones and lives at
  * the end of the header data, ie. at skb->end.
  */
@@ -701,6 +706,8 @@ struct skb_shared_info {
 	unsigned int	gso_type;
 	u32		tskey;
 
+	struct dsa_tag_info dsa_tag_info;
+
 	/*
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14e10cda7267..9951df858912 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -53,6 +53,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
 #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
+#define DSA_TAG_PROTO_OOB_VALUE			26
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -81,6 +82,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
 	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
+	DSA_TAG_PROTO_OOB		= DSA_TAG_PROTO_OOB_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8cb87b5067ee..b7aa4d8552b2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -57,6 +57,13 @@ config NET_DSA_TAG_HELLCREEK
 	  Say Y or M if you want to enable support for tagging frames
 	  for the Hirschmann Hellcreek TSN switches.
 
+config NET_DSA_TAG_OOB
+	tristate "Tag driver for Out-of-band tagging drivers"
+	help
+	  Say Y or M if you want to enable support for tagging out-of-band. In
+	  that case, the MAC driver becomes responsible for sending the tag to
+	  the switch, outside the inband data.
+
 config NET_DSA_TAG_GSWIP
 	tristate "Tag driver for Lantiq / Intel GSWIP switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 9f75820e7c98..b156e20f9c0a 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
+obj-$(CONFIG_NET_DSA_TAG_OOB) += tag_oob.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
diff --git a/net/dsa/tag_oob.c b/net/dsa/tag_oob.c
new file mode 100644
index 000000000000..045c7c06e81f
--- /dev/null
+++ b/net/dsa/tag_oob.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* Copyright (c) 2022, Maxime Chevallier <maxime.chevallier@bootlin.com> */
+
+#include <linux/bitfield.h>
+
+#include "dsa_priv.h"
+
+static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_tag_info *tag_info = &skb_shinfo(skb)->dsa_tag_info;
+
+	tag_info->dp = BIT(dp->index);
+	tag_info->proto = DSA_TAG_PROTO_OOB;
+
+	return skb;
+}
+
+static struct sk_buff *oob_tag_rcv(struct sk_buff *skb,
+				   struct net_device *dev)
+{
+	struct dsa_tag_info *tag_info = &skb_shinfo(skb)->dsa_tag_info;
+
+	skb->dev = dsa_master_find_slave(dev, 0, tag_info->dp);
+	if (!skb->dev)
+		return NULL;
+
+	return skb;
+}
+
+const struct dsa_device_ops oob_tag_dsa_ops = {
+	.name	= "oob",
+	.proto	= DSA_TAG_PROTO_OOB,
+	.xmit	= oob_tag_xmit,
+	.rcv	= oob_tag_rcv,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DSA tag driver for out-of-band tagging");
+MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OOB);
+
+module_dsa_tag_driver(oob_tag_dsa_ops);
-- 
2.35.1

