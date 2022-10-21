Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAAF607738
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiJUMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUMqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:46:09 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412522623D1;
        Fri, 21 Oct 2022 05:46:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5CF1C60010;
        Fri, 21 Oct 2022 12:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666356365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwLBHf9NXDbZ0kvseHUb4r8ucaSCQn1PCWArHfgsHGU=;
        b=kM09+BxsvESe2r+SIC4FO3v9cQxHrUp9nMDK0cXN6M6VNMW8lrdOYwga83Ugb6C1nsrIik
        kWzzCQKBlWFfw77YTvQ8t5doy5A7RDYatA2MVpN6iTH7hmqgEFL30fZaJbmOy48hbelHsS
        pLEKVbnm+jvA7bbg9B/QM14kTipab38VnxbD/GGEwt82Ybo8+DhpaBdwxus0XmLMR0nZ70
        qL08h67t8VDYGjHLlvFgMSKWDfWzcNTg+Tbpbsv0sFY8fM7TNPJn6tatJhhThHPM8y3oRm
        1svCX2DEfWwnAHFTPxbzj5DMJTYPVkquKICXJ3HeXq8UEmMYlFg8EKCEGaoxAg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
Subject: [PATCH net-next v5 3/5] net: dsa: add out-of-band tagging protocol
Date:   Fri, 21 Oct 2022 14:45:54 +0200
Message-Id: <20221021124556.100445-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Add a new tagging protocol based on SKB extensions to convey the
information about the destination port to the MAC driver

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V4->V5
 - Use SKB extensions to convey the tag
V3->V4 
 - No changes
V3->V2:
 - No changes, as the discussion is ongoing
V1->V2:
 - Reworked the tagging method, putting the tag at skb->head instead
   of putting it into skb->shinfo, as per Andrew, Florian and Vlad's
   reviews

 include/linux/dsa/oob.h | 17 +++++++++
 include/linux/skbuff.h  |  3 ++
 include/net/dsa.h       |  2 ++
 net/core/skbuff.c       | 10 ++++++
 net/dsa/Kconfig         |  8 +++++
 net/dsa/Makefile        |  1 +
 net/dsa/tag_oob.c       | 80 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 121 insertions(+)
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

diff --git a/include/linux/dsa/oob.h b/include/linux/dsa/oob.h
new file mode 100644
index 000000000000..dbb4a6fb1ce4
--- /dev/null
+++ b/include/linux/dsa/oob.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2022 Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+
+#ifndef _NET_DSA_OOB_H
+#define _NET_DSA_OOB_H
+
+#include <linux/skbuff.h>
+
+struct dsa_oob_tag_info {
+	u16 proto;
+	u16 dp;
+};
+
+int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
+int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
+#endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fcf534f2d92..e387d6795919 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4571,6 +4571,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	SKB_EXT_MCTP,
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
+	SKB_EXT_DSA_OOB,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..114176efacc9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -55,6 +55,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
 #define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
 #define DSA_TAG_PROTO_LAN937X_VALUE		27
+#define DSA_TAG_PROTO_OOB_VALUE			28
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -85,6 +86,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
 	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
 	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
+	DSA_TAG_PROTO_OOB		= DSA_TAG_PROTO_OOB_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..627b0b9c0b23 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -61,8 +61,12 @@
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
 #include <linux/kcov.h>
+#ifdef CONFIG_NET_DSA_TAG_OOB
+#include <linux/dsa/oob.h>
+#endif
 
 #include <net/protocol.h>
+#include <net/dsa.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/checksum.h>
@@ -4474,6 +4478,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
+	[SKB_EXT_DSA_OOB] = SKB_EXT_CHUNKSIZEOF(struct dsa_oob_tag_info),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4493,6 +4500,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 		skb_ext_type_len[SKB_EXT_MCTP] +
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
+		skb_ext_type_len[SKB_EXT_DSA_OOB] +
 #endif
 		0;
 }
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 3eef72ce99a4..c50508e9f636 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -57,6 +57,14 @@ config NET_DSA_TAG_HELLCREEK
 	  Say Y or M if you want to enable support for tagging frames
 	  for the Hirschmann Hellcreek TSN switches.
 
+config NET_DSA_TAG_OOB
+	select SKB_EXTENSIONS
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
index bf57ef3bce2a..fff657064be4 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
+obj-$(CONFIG_NET_DSA_TAG_OOB) += tag_oob.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
diff --git a/net/dsa/tag_oob.c b/net/dsa/tag_oob.c
new file mode 100644
index 000000000000..f8fba8406307
--- /dev/null
+++ b/net/dsa/tag_oob.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* Copyright (c) 2022, Maxime Chevallier <maxime.chevallier@bootlin.com> */
+
+#include <linux/bitfield.h>
+#include <linux/dsa/oob.h>
+#include <linux/skbuff.h>
+
+#include "dsa_priv.h"
+
+#define DSA_OOB_TAG_LEN 4
+
+int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
+{
+	struct dsa_oob_tag_info *tag_info;
+
+	tag_info = skb_ext_add(skb, SKB_EXT_DSA_OOB);
+
+	tag_info->dp = ti->dp;
+
+	return 0;
+}
+EXPORT_SYMBOL(dsa_oob_tag_push);
+
+int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
+{
+	struct dsa_oob_tag_info *tag_info;
+
+	tag_info = skb_ext_find(skb, SKB_EXT_DSA_OOB);
+	if (!tag_info)
+		return -EINVAL;
+
+	ti->dp = tag_info->dp;
+
+	return 0;
+}
+EXPORT_SYMBOL(dsa_oob_tag_pop);
+
+static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_oob_tag_info tag_info;
+
+	tag_info.dp = dp->index;
+
+	if (dsa_oob_tag_push(skb, &tag_info))
+		return NULL;
+
+	return skb;
+}
+
+static struct sk_buff *oob_tag_rcv(struct sk_buff *skb,
+				   struct net_device *dev)
+{
+	struct dsa_oob_tag_info tag_info;
+
+	if (dsa_oob_tag_pop(skb, &tag_info))
+		return NULL;
+
+	skb->dev = dsa_master_find_slave(dev, 0, tag_info.dp);
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
2.37.3

