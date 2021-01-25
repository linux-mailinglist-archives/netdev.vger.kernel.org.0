Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F27B302EAE
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbhAYWJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7E3C06178C
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id dj23so17390032edb.13
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+7oq8IDCKinL7EW4mZq9kHGP8iSWMPHxRWaK0oqyJSw=;
        b=i4NDJMPEO9Z8wyUZF3fB/phSzjKJLuW6QoH9TA9VeIQ+fWcP5GGEdqM3Szin+EHj8y
         4XLMckjOX3Vd+xehgebSlzEC8EHg1p133OlWPslg1gckkzzm6njg5FhepPOA/8mrRlDo
         2yLQKLgeFMzBinLB1kXjX/LRO53sALz2bwjVOST+MV6XtwebLAhCoqXzJ0Ez5unChM3J
         ep9cUtAe1uiUUoai3QBVcpVo+pqvUIaLdPaeKFF5XPVkTlk/izQVu56xG5f86IgMgYL6
         h7Z3tWTS45WCq6mJqE/cmMm57QTZ9i2R33tKFxG9RwzFTCokN7f746hfyqCfcrP6s4p5
         KldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+7oq8IDCKinL7EW4mZq9kHGP8iSWMPHxRWaK0oqyJSw=;
        b=hj3awBhOKReEWZ+D54hN//lEs8GkAQG6pjW5Qkoh5WPY67BWIXXZ0gZnIhUisBe8K6
         SyOVJcyw+arOfrlY09+DIYU914LZflXOKFON2ZxvaW+hnBOf2kkTh8Rh5yOZOdCS9N03
         qlJiSZKXIDbreQ2/QWGxHfDP71YS5HNbyxDpbvZWIbR039euj00zHaaHHoTSyc/CPB66
         wM5E5VQuzLm6LQKmHRPcLtbZFzMQEse1P6y/v2G+91bfVnLdDQwgFnBN1xlgSOu6cM5T
         52hegfzG38q+Y+WYkC8GOKSzYNVp+jttGsdIDorap02JUMP3S1wd2EMj9WZxDZnRm1wD
         NJtg==
X-Gm-Message-State: AOAM530pjIaON23dq9BYkJhxcQNmmx6ipnyxSQ/GwjMJEfdCq6Xo/BsT
        NaKmdASWhzrs1/u+gar1UIk=
X-Google-Smtp-Source: ABdhPJyFZ49LQ6Z0kcDTYV/UHrS2cOiCcw6nF82Ox/dfyYZU8RUsp9Em3Wl5Ry+plkRGq3dwYs7nGw==
X-Received: by 2002:a05:6402:34e:: with SMTP id r14mr2232453edw.269.1611612278224;
        Mon, 25 Jan 2021 14:04:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 10/11] net: dsa: add a second tagger for Ocelot switches based on tag_8021q
Date:   Tue, 26 Jan 2021 00:03:32 +0200
Message-Id: <20210125220333.1004365-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are use cases for which the existing tagger, based on the NPI
(Node Processor Interface) functionality, is insufficient.

Namely:
- Frames injected through the NPI port bypass the frame analyzer, so no
  source address learning is performed, no TSN stream classification,
  etc.
- Flow control is not functional over an NPI port (PAUSE frames are
  encapsulated in the same Extraction Frame Header as all other frames)
- There can be at most one NPI port configured for an Ocelot switch. But
  in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
  port is currently either disabled, or operated as a plain user port
  (albeit an internally-facing one). Having the ability to configure the
  two CPU ports symmetrically could pave the way for e.g. creating a LAG
  between them, to increase bandwidth seamlessly for the system.

So there is a desire to have an alternative to the NPI mode. This change
keeps the default tagger for the Seville and Felix switches as "ocelot",
but it can be changed via the following device attribute:

echo ocelot-8021q > /sys/class/<dsa-master>/dsa/tagging

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
Path is split from previous monolithic patch "net: dsa: felix: add new
VLAN-based tagger".

 MAINTAINERS                    |  1 +
 drivers/net/dsa/ocelot/Kconfig |  2 +
 include/net/dsa.h              |  2 +
 net/dsa/Kconfig                | 21 +++++++++--
 net/dsa/Makefile               |  1 +
 net/dsa/tag_ocelot_8021q.c     | 68 ++++++++++++++++++++++++++++++++++
 6 files changed, 92 insertions(+), 3 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 650deb973913..9f5d5bc3dd2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12850,6 +12850,7 @@ F:	drivers/net/dsa/ocelot/*
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 F:	net/dsa/tag_ocelot.c
+F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index c110e82a7973..932b6b6fe817 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -6,6 +6,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
@@ -19,6 +20,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
 	help
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0d8251de520f..865113c6da85 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -47,6 +47,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
+#define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -69,6 +70,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
+	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2d226a5c085f..a45572cfb71a 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -105,11 +105,26 @@ config NET_DSA_TAG_RTL4_A
 	  the Realtek RTL8366RB.
 
 config NET_DSA_TAG_OCELOT
-	tristate "Tag driver for Ocelot family of switches"
+	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	select PACKING
 	help
-	  Say Y or M if you want to enable support for tagging frames for the
-	  Ocelot switches (VSC7511, VSC7512, VSC7513, VSC7514, VSC9959).
+	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
+	  (VSC7511, VSC7512, VSC7513, VSC7514, VSC9953, VSC9959). In this mode,
+	  the frames over the Ethernet CPU port are prepended with a
+	  hardware-defined injection/extraction frame header.  Flow control
+	  (PAUSE frames) over the CPU port is not supported when operating in
+	  this mode.
+
+config NET_DSA_TAG_OCELOT_8021Q
+	tristate "Tag driver for Ocelot family of switches, using VLAN"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y or M if you want to enable support for tagging frames with a
+	  custom VLAN-based header. Frames that require timestamping, such as
+	  PTP, are not delivered over Ethernet but over register-based MMIO.
+	  Flow control over the CPU port is functional in this mode. When using
+	  this mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for
+	  use with tc-flower.
 
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 92cea2132241..44bc79952b8b 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
new file mode 100644
index 000000000000..09e10ade11f7
--- /dev/null
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2021 NXP Semiconductors
+ *
+ * An implementation of the software-defined tag_8021q.c tagger format, which
+ * also preserves full functionality under a vlan_filtering bridge. It does
+ * this by using the TCAM engines for:
+ * - pushing the RX VLAN as a second, outer tag, on egress towards the CPU port
+ * - redirecting towards the correct front port based on TX VLAN and popping
+ *   that on egress
+ */
+#include <linux/dsa/8021q.h>
+#include "dsa_priv.h"
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+
+	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
+			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+}
+
+static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
+				  struct net_device *netdev,
+				  struct packet_type *pt)
+{
+	int src_port, switch_id, qos_class;
+	u16 vid, tci;
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	if (skb_vlan_tag_present(skb)) {
+		tci = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		__skb_vlan_pop(skb, &tci);
+	}
+	skb_pull_rcsum(skb, ETH_HLEN);
+
+	vid = tci & VLAN_VID_MASK;
+	src_port = dsa_8021q_rx_source_port(vid);
+	switch_id = dsa_8021q_rx_switch_id(vid);
+	qos_class = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
+	if (!skb->dev)
+		return NULL;
+
+	skb->offload_fwd_mark = 1;
+	skb->priority = qos_class;
+
+	return skb;
+}
+
+static struct dsa_device_ops ocelot_netdev_ops = {
+	.name			= "ocelot-8021q",
+	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT_8021Q);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.25.1

