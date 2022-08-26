Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19655A2B8C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344437AbiHZPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344418AbiHZPrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:47:02 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C3F7A532;
        Fri, 26 Aug 2022 08:47:00 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5CA211BF20B;
        Fri, 26 Aug 2022 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661528819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV++rPYz6bwemsK6rkn8DxeqvDnJ5gYSRMQtC1A+Hxs=;
        b=QfyxYt+kd5gTvLZ5oQjQh/SLIlRD6/syJLX4eDRdPsUoGRY0Zl+KL234n9AnovaMHywRDl
        Ywhmqz56WwZ13Kd79vAj0JnRbwC4FLtB+wTcyKHLA/X2ZW5MeKe7RSAQdhhLRjL5QV239U
        sK1dzHZViw5jikelLGuYVAD70xNDE5+chGVOSyTIISxJvxGUmYWlI61fUhAzXQRHcwPita
        NT8zU4kBzynupEUDGsRsaYo4S1CPXnrScbSBSepjTWsfhK0L/aKOpwpdjQHgz2qbGqSQJO
        6JL6/niXKcEaYO6bmucFm+Jq5U0O5bX4wrW79WEac20TlViOfZEUo24fWFA0pA==
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
Subject: [PATCH net-next v3 2/5] net: dsa: add out-of-band tagging protocol
Date:   Fri, 26 Aug 2022 17:46:47 +0200
Message-Id: <20220826154650.615582-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

This out-of-band tagging protocol is using the very beggining of the skb
headroom to store the tag. The drawback of this approch is that the
headroom isn't initialized upon allocating it, therefore we have a
chance that the garbage data that lies there at allocation time actually
ressembles a valid oob tag. This is only problematic if we are
sending/receiving traffic on the master port, which isn't a valid DSA
use-case from the beggining. When dealing from traffic to/from a slave
port, then the oob tag will be initialized properly by the tagger or the
mac driver through the use of the dsa_oob_tag_push() call.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V2:
 - No changes, as the discussion is ongoing
V1->V2:
 - Reworked the tagging method, putting the tag at skb->head instead
   of putting it into skb->shinfo, as per Andrew, Florian and Vlad's
   reviews

 include/linux/dsa/oob.h | 17 +++++++++
 include/net/dsa.h       |  2 +
 net/dsa/Kconfig         |  7 ++++
 net/dsa/Makefile        |  1 +
 net/dsa/tag_oob.c       | 84 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 111 insertions(+)
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
diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..8a63bb65b81b 100644
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
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 3eef72ce99a4..3e095041dcca 100644
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
index af28c24ead18..729acd0a5511 100644
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
index 000000000000..45ee3df5a7f9
--- /dev/null
+++ b/net/dsa/tag_oob.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* Copyright (c) 2022, Maxime Chevallier <maxime.chevallier@bootlin.com> */
+
+#include <linux/bitfield.h>
+#include <linux/dsa/oob.h>
+
+#include "dsa_priv.h"
+
+#define DSA_OOB_TAG_LEN 4
+
+int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
+{
+	struct dsa_oob_tag_info *tag_info;
+
+	tag_info = (struct dsa_oob_tag_info *)skb->head;
+
+	tag_info->proto = ti->proto;
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
+	tag_info = (struct dsa_oob_tag_info *)skb->head;
+
+	if (tag_info->proto != DSA_TAG_PROTO_OOB)
+		return -EINVAL;
+
+	ti->proto = tag_info->proto;
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
+	tag_info.proto = DSA_TAG_PROTO_OOB;
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
+	.needed_headroom = DSA_OOB_TAG_LEN,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DSA tag driver for out-of-band tagging");
+MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OOB);
+
+module_dsa_tag_driver(oob_tag_dsa_ops);
-- 
2.37.2

