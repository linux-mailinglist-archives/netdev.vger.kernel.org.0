Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF5A619EFD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKDRmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiKDRmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:42:05 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF85B842;
        Fri,  4 Nov 2022 10:42:02 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B1393FF808;
        Fri,  4 Nov 2022 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667583721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKUenYNB3v7NDOtqjkiaNGBi/7ccXmhnKVdj/8lZw/A=;
        b=EtFTVGN0gCc9BYzcJmaRaSXKF/RO852zSEdUuAVNFXipmvqJPxcGC8/ca2vyyUQKW+MUTf
        eh7x6ntifGFJbF+tn1ue9W4JvsHo1pjbJtl+WSs+9egDja6WxHrSYGd/SID3mwu3EBidvB
        KSSPnEPsMbzODTk0wG5cuaSLSr1bGnM6SjeWPlE24mst8tZRHpfU6cwXxdf7rz9ezLZzFh
        +tnxsjjOUJkhSmZQnsDufam2plXnrgAxD9uxt0pDFTBXojugxUdijzSQ1MKgsdFs1Xx0Is
        prBlPDqJl5fBdTlM/RsvtB3TrWbACHmDS+MC4eolstUpaqH7k0UGJ7GBt09YPw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging protocol
Date:   Fri,  4 Nov 2022 18:41:49 +0100
Message-Id: <20221104174151.439008-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

V7->V8:
 - Added a missing blank line after declaration
V6->V7:
 - Fixed a sparse warning by making the dsa ops static
V5->V6:
 - Added some documentation
 - Removed the pop/push helpers
 - Removed unused fields
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


 Documentation/networking/dsa/dsa.rst | 13 +++++++-
 MAINTAINERS                          |  1 +
 include/linux/dsa/oob.h              | 16 +++++++++
 include/linux/skbuff.h               |  3 ++
 include/net/dsa.h                    |  2 ++
 net/core/skbuff.c                    | 10 ++++++
 net/dsa/Kconfig                      |  9 +++++
 net/dsa/Makefile                     |  1 +
 net/dsa/tag_oob.c                    | 49 ++++++++++++++++++++++++++++
 9 files changed, 103 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index a94ddf83348a..2909ed5f00f6 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -66,7 +66,8 @@ Switch tagging protocols
 ------------------------
 
 DSA supports many vendor-specific tagging protocols, one software-defined
-tagging protocol, and a tag-less mode as well (``DSA_TAG_PROTO_NONE``).
+tagging protocol, a tag-less mode as well (``DSA_TAG_PROTO_NONE``) and an
+out-of-band tagging protocol (``DSA_TAG_PROTO_OOB``).
 
 The exact format of the tag protocol is vendor specific, but in general, they
 all contain something which:
@@ -217,6 +218,16 @@ receive all frames regardless of the value of the MAC DA. This can be done by
 setting the ``promisc_on_master`` property of the ``struct dsa_device_ops``.
 Note that this assumes a DSA-unaware master driver, which is the norm.
 
+Some SoCs have a tight integration between the conduit network interface and the
+embedded switch, such that the DSA tag isn't transmitted in the packet data,
+but through another media, using so-called out-of-band tagging. In that case,
+the host MAC driver is in charge of transmitting the tag to the switch.
+An example is the IPQ4019 SoC, that transmits the tag between the ipqess
+ethernet controller and the qca8k switch using the DMA descriptor. In that
+configuration, tag-chaining is permitted, but the OOB tag will always be the
+top-most switch in the tree. The tagger (``DSA_TAG_PROTO_OOB``) uses skb
+extensions to transmit the tag to and from the MAC driver.
+
 Master network devices
 ----------------------
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 47588d4b1657..bdf716128058 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17055,6 +17055,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
 F:	drivers/net/ethernet/qualcomm/ipqess/
+F:	net/dsa/tag_oob.c
 
 QUALCOMM ETHQOS ETHERNET DRIVER
 M:	Vinod Koul <vkoul@kernel.org>
diff --git a/include/linux/dsa/oob.h b/include/linux/dsa/oob.h
new file mode 100644
index 000000000000..b5683a9a647d
--- /dev/null
+++ b/include/linux/dsa/oob.h
@@ -0,0 +1,16 @@
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
+	u16 port;
+};
+
+int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
+int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
+#endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d..ace765ae56b3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4573,6 +4573,9 @@ enum skb_ext_id {
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
index 42a35b59fb1e..571ef7fd95b4 100644
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
@@ -4487,6 +4491,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
+	[SKB_EXT_DSA_OOB] = SKB_EXT_CHUNKSIZEOF(struct dsa_oob_tag_info),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4506,6 +4513,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
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
index 3eef72ce99a4..2ba4bbe07df1 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -113,6 +113,15 @@ config NET_DSA_TAG_OCELOT_8021Q
 	  this mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for
 	  use with tc-flower.
 
+config NET_DSA_TAG_OOB
+	select SKB_EXTENSIONS
+	tristate "Tag driver for Out-of-band tagging drivers"
+	help
+	  Say Y or M if you want to enable support for pairs of embedded
+	  switches and host MAC drivers which perform demultiplexing and
+	  packet steering to ports using out of band metadata processed
+	  by the DSA master, rather than tags present in the packets.
+
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index bf57ef3bce2a..b11c24c969ee 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
+obj-$(CONFIG_NET_DSA_TAG_OOB) += tag_oob.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
diff --git a/net/dsa/tag_oob.c b/net/dsa/tag_oob.c
new file mode 100644
index 000000000000..e328a1f4e38d
--- /dev/null
+++ b/net/dsa/tag_oob.c
@@ -0,0 +1,49 @@
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
+static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct dsa_oob_tag_info *tag_info = skb_ext_add(skb, SKB_EXT_DSA_OOB);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	tag_info->port = dp->index;
+
+	return skb;
+}
+
+static struct sk_buff *oob_tag_rcv(struct sk_buff *skb,
+				   struct net_device *dev)
+{
+	struct dsa_oob_tag_info *tag_info = skb_ext_find(skb, SKB_EXT_DSA_OOB);
+
+	if (!tag_info)
+		return NULL;
+
+	skb->dev = dsa_master_find_slave(dev, 0, tag_info->port);
+	if (!skb->dev)
+		return NULL;
+
+	return skb;
+}
+
+static const struct dsa_device_ops oob_tag_dsa_ops = {
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

