Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB960604487
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiJSMHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiJSMHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:07:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3C71119F6;
        Wed, 19 Oct 2022 04:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666179832; x=1697715832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0xiUYmeBKino4mAeC/ZdzzkWImPwSjRWGVdbaYaLhko=;
  b=YrLyKn4YOd4aHob7YOzHdNGpgnV2sre45E9awdG0A8vZ7hS+7P/7EXqE
   babzqYeBUzJ3jSo8AaCJG8a19XwMvm8fGF56GKxotMkxoROxaA9KeJXVT
   +xs9pdDHztbj8O5Tc1At9hjxX8ayanqcWPlNstx/4KQWW8l6RiqPsodQ7
   jvdxk+a8FhPFBA3l7HBd85yPPMNN3MGJjFnm4O1YOp6Bf2HA9hIFHdaYR
   Xn+Whbam5AnrSi6vCp8zTaQ7yQxrJDRe2hgbinL+/3qdSwjzn1YlqH9Ll
   OdHcKMquNfBSbBpbUeTqOJjlSRVv2+DpzcKzkofNndtNQM+QlLVUuIrik
   w==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="182926216"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 04:42:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 04:42:25 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 04:42:22 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 1/9] net: microchip: sparx5: Adding initial VCAP API support
Date:   Wed, 19 Oct 2022 13:42:07 +0200
Message-ID: <20221019114215.620969-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221019114215.620969-1-steen.hegelund@microchip.com>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the initial VCAP API framework and Sparx5 specific VCAP
implementation.

When the Sparx5 Switchdev driver is initialized it will also initialize its
VCAP module, and this hooks up the concrete Sparx5 VCAP model to the VCAP
API, so that the VCAP API knows what VCAP instances are available.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |   1 +
 .../net/ethernet/microchip/sparx5/Makefile    |   8 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |   9 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |   6 +
 .../microchip/sparx5/sparx5_vcap_impl.c       |  41 +++
 drivers/net/ethernet/microchip/vcap/Kconfig   |  39 +++
 .../net/ethernet/microchip/vcap/vcap_ag_api.h | 326 ++++++++++++++++++
 .../net/ethernet/microchip/vcap/vcap_api.h    | 269 +++++++++++++++
 10 files changed, 699 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e55a4d47324c..8b4c6d62d75f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2407,6 +2407,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 T:	git git://github.com/microchip-ung/linux-upstream.git
 F:	arch/arm64/boot/dts/microchip/
+F:	drivers/net/ethernet/microchip/vcap/
 F:	drivers/pinctrl/pinctrl-microchip-sgpio.c
 N:	sparx5
 
diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index ed7a35c3ceac..24c994baad13 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -57,5 +57,6 @@ config LAN743X
 
 source "drivers/net/ethernet/microchip/lan966x/Kconfig"
 source "drivers/net/ethernet/microchip/sparx5/Kconfig"
+source "drivers/net/ethernet/microchip/vcap/Kconfig"
 
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index cc5e48e1bb4c..98e27530a91f 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -9,5 +9,6 @@ config SPARX5_SWITCH
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
+	select VCAP
 	help
 	  This driver supports the Sparx5 network switch device.
diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index d1c6ad966747..aa4dadb8a25d 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -5,7 +5,11 @@
 
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
-sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
+sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
- sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o
+ sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
+ sparx5_vcap_impl.o
+
+# Provide include files
+ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 62a325e96345..0b70c00c6eaa 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -672,6 +672,14 @@ static int sparx5_start(struct sparx5 *sparx5)
 
 	sparx5_board_init(sparx5);
 	err = sparx5_register_notifier_blocks(sparx5);
+	if (err)
+		return err;
+
+	err = sparx5_vcap_init(sparx5);
+	if (err) {
+		sparx5_unregister_notifier_blocks(sparx5);
+		return err;
+	}
 
 	/* Start Frame DMA with fallback to register based INJ/XTR */
 	err = -ENXIO;
@@ -906,6 +914,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	sparx5_ptp_deinit(sparx5);
 	sparx5_fdma_stop(sparx5);
 	sparx5_cleanup_ports(sparx5);
+	sparx5_vcap_destroy(sparx5);
 	/* Unregister netdevs */
 	sparx5_unregister_notifier_blocks(sparx5);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 7a83222caa73..2ab22a7b799e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -288,6 +288,8 @@ struct sparx5 {
 	struct mutex ptp_lock; /* lock for ptp interface state */
 	u16 ptp_skbs;
 	int ptp_irq;
+	/* VCAP */
+	struct vcap_control *vcap_ctrl;
 	/* PGID allocation map */
 	u8 pgid_map[PGID_TABLE_SIZE];
 };
@@ -382,6 +384,10 @@ void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
 				 struct sk_buff *skb);
 irqreturn_t sparx5_ptp_irq_handler(int irq, void *args);
 
+/* sparx5_vcap_impl.c */
+int sparx5_vcap_init(struct sparx5 *sparx5);
+void sparx5_vcap_destroy(struct sparx5 *sparx5);
+
 /* sparx5_pgid.c */
 enum sparx5_pgid_type {
 	SPX5_PGID_FREE,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
new file mode 100644
index 000000000000..8df7cba77a28
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver VCAP implementation
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include "vcap_api.h"
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+/* Allocate a vcap control and vcap instances and configure the system */
+int sparx5_vcap_init(struct sparx5 *sparx5)
+{
+	struct vcap_control *ctrl;
+
+	/* Create a VCAP control instance that owns the platform specific VCAP
+	 * model with VCAP instances and information about keysets, keys,
+	 * actionsets and actions
+	 */
+	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	sparx5->vcap_ctrl = ctrl;
+
+	return 0;
+}
+
+void sparx5_vcap_destroy(struct sparx5 *sparx5)
+{
+	if (!sparx5->vcap_ctrl)
+		return;
+
+	kfree(sparx5->vcap_ctrl);
+}
diff --git a/drivers/net/ethernet/microchip/vcap/Kconfig b/drivers/net/ethernet/microchip/vcap/Kconfig
new file mode 100644
index 000000000000..a78cbc6ce6bb
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/Kconfig
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Microchip VCAP API configuration
+#
+
+if NET_VENDOR_MICROCHIP
+
+config VCAP
+	bool "VCAP (Versatile Content-Aware Processor) library"
+	help
+	  Provides the basic VCAP functionality for multiple Microchip switchcores
+
+	  A VCAP is essentially a TCAM with rules consisting of
+
+	    - Programmable key fields
+	    - Programmable action fields
+	    - A counter (which may be only one bit wide)
+
+	  Besides this each VCAP has:
+
+	    - A number of lookups
+	    - A keyset configuration per port per lookup
+
+	  The VCAP implementation provides switchcore independent handling of rules
+	  and supports:
+
+	    - Creating and deleting rules
+	    - Updating and getting rules
+
+	  The platform specific configuration as well as the platform specific model
+	  of the VCAP instances are attached to the VCAP API and a client can then
+	  access rules via the API in a platform independent way, with the
+	  limitations that each VCAP has in terms of its supported keys and actions.
+
+	  Different switchcores will have different VCAP instances with different
+	  characteristics. Look in the datasheet for the VCAP specifications for the
+	  specific switchcore.
+
+endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
new file mode 100644
index 000000000000..804d57b9b60a
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -0,0 +1,326 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API
+ */
+
+/* This file is autogenerated by cml-utils 2022-10-13 10:04:41 +0200.
+ * Commit ID: fd7cafd175899f0672c73afb3a30fc872500ae86
+ */
+
+#ifndef __VCAP_AG_API__
+#define __VCAP_AG_API__
+
+enum vcap_type {
+	VCAP_TYPE_IS2,
+	VCAP_TYPE_MAX
+};
+
+/* Keyfieldset names with origin information */
+enum vcap_keyfield_set {
+	VCAP_KFS_NO_VALUE,          /* initial value */
+	VCAP_KFS_ARP,               /* sparx5 is2 X6 */
+	VCAP_KFS_IP4_OTHER,         /* sparx5 is2 X6 */
+	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6 */
+	VCAP_KFS_IP6_STD,           /* sparx5 is2 X6 */
+	VCAP_KFS_IP_7TUPLE,         /* sparx5 is2 X12 */
+	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6 */
+};
+
+/* List of keyfields with description
+ *
+ * Keys ending in _IS are booleans derived from frame data
+ * Keys ending in _CLS are classified frame data
+ *
+ * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2
+ *   Classified DEI
+ * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2
+ *   Classified PCP
+ * VCAP_KF_8021Q_VID_CLS: W13, sparx5: is2
+ *   Classified VID
+ * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2
+ *   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
+ *   one or more Q-tags. Independent of port VLAN awareness
+ * VCAP_KF_ARP_ADDR_SPACE_OK_IS: W1, sparx5: is2
+ *   Set if hardware address is Ethernet
+ * VCAP_KF_ARP_LEN_OK_IS: W1, sparx5: is2
+ *   Set if hardware address length = 6 (Ethernet) and IP address length = 4 (IP).
+ * VCAP_KF_ARP_OPCODE: W2, sparx5: is2
+ *   ARP opcode
+ * VCAP_KF_ARP_OPCODE_UNKNOWN_IS: W1, sparx5: is2
+ *   Set if not one of the codes defined in VCAP_KF_ARP_OPCODE
+ * VCAP_KF_ARP_PROTO_SPACE_OK_IS: W1, sparx5: is2
+ *   Set if protocol address space is 0x0800
+ * VCAP_KF_ARP_SENDER_MATCH_IS: W1, sparx5: is2
+ *   Sender Hardware Address = SMAC (ARP)
+ * VCAP_KF_ARP_TGT_MATCH_IS: W1, sparx5: is2
+ *   Target Hardware Address = SMAC (RARP)
+ * VCAP_KF_ETYPE: W16, sparx5: is2
+ *   Ethernet type
+ * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is2
+ *   Set if frame has EtherType >= 0x600
+ * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is2 W32, sparx5 is2 W65
+ *   Ingress port mask, one bit per port/erleg
+ * VCAP_KF_IF_IGR_PORT_MASK_L3: W1, sparx5: is2
+ *   If set, IF_IGR_PORT_MASK, IF_IGR_PORT_MASK_RNG, and IF_IGR_PORT_MASK_SEL are
+ *   used to specify L3 interfaces
+ * VCAP_KF_IF_IGR_PORT_MASK_RNG: W4, sparx5: is2
+ *   Range selector for IF_IGR_PORT_MASK.  Specifies which group of 32 ports are
+ *   available in IF_IGR_PORT_MASK
+ * VCAP_KF_IF_IGR_PORT_MASK_SEL: W2, sparx5: is2
+ *   Mode selector for IF_IGR_PORT_MASK, applicable when IF_IGR_PORT_MASK_L3 == 0.
+ *   Mapping: 0: DEFAULT 1: LOOPBACK 2: MASQUERADE 3: CPU_VD
+ * VCAP_KF_IP4_IS: W1, sparx5: is2
+ *   Set if frame has EtherType = 0x800 and IP version = 4
+ * VCAP_KF_ISDX_CLS: W12, sparx5: is2
+ *   Classified ISDX
+ * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2
+ *   Set if classified ISDX > 0
+ * VCAP_KF_L2_BC_IS: W1, sparx5: is2
+ *   Set if frame’s destination MAC address is the broadcast address
+ *   (FF-FF-FF-FF-FF-FF).
+ * VCAP_KF_L2_DMAC: W48, sparx5: is2
+ *   Destination MAC address
+ * VCAP_KF_L2_FWD_IS: W1, sparx5: is2
+ *   Set if the frame is allowed to be forwarded to front ports
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is2
+ *   Set if frame’s destination MAC address is a multicast address (bit 40 = 1).
+ * VCAP_KF_L2_PAYLOAD_ETYPE: W64, sparx5: is2
+ *   Byte 0-7 of L2 payload after Type/Len field and overloading for OAM
+ * VCAP_KF_L2_SMAC: W48, sparx5: is2
+ *   Source MAC address
+ * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2
+ *   Set if Src IP matches Dst IP address
+ * VCAP_KF_L3_DST_IS: W1, sparx5: is2
+ *   Set if lookup is done for egress router leg
+ * VCAP_KF_L3_FRAGMENT_TYPE: W2, sparx5: is2
+ *   L3 Fragmentation type (none, initial, suspicious, valid follow up)
+ * VCAP_KF_L3_FRAG_INVLD_L4_LEN: W1, sparx5: is2
+ *   Set if frame's L4 length is less than ANA_CL:COMMON:CLM_FRAGMENT_CFG.L4_MIN_L
+ *   EN
+ * VCAP_KF_L3_IP4_DIP: W32, sparx5: is2
+ *   Destination IPv4 Address
+ * VCAP_KF_L3_IP4_SIP: W32, sparx5: is2
+ *   Source IPv4 Address
+ * VCAP_KF_L3_IP6_DIP: W128, sparx5: is2
+ *   Sparx5: Full IPv6 DIP, LAN966x: Either Full IPv6 DIP or a subset depending on
+ *   frame type
+ * VCAP_KF_L3_IP6_SIP: W128, sparx5: is2
+ *   Sparx5: Full IPv6 SIP, LAN966x: Either Full IPv6 SIP or a subset depending on
+ *   frame type
+ * VCAP_KF_L3_IP_PROTO: W8, sparx5: is2
+ *   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
+ * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is2
+ *   Set if IPv4 frame contains options (IP len > 5)
+ * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40
+ *   Sparx5: Payload bytes after IP header. IPv4: IPv4 options are not parsed so
+ *   payload is always taken 20 bytes after the start of the IPv4 header, LAN966x:
+ *   Bytes 0-6 after IP header
+ * VCAP_KF_L3_RT_IS: W1, sparx5: is2
+ *   Set if frame has hit a router leg
+ * VCAP_KF_L3_TOS: W8, sparx5: is2
+ *   Sparx5: Frame's IPv4/IPv6 DSCP and ECN fields, LAN966x: IP TOS field
+ * VCAP_KF_L3_TTL_GT0: W1, sparx5: is2
+ *   Set if IPv4 TTL / IPv6 hop limit is greater than 0
+ * VCAP_KF_L4_ACK: W1, sparx5: is2
+ *   Sparx5 and LAN966x: TCP flag ACK, LAN966x only: PTP over UDP: flagField bit 2
+ *   (unicastFlag)
+ * VCAP_KF_L4_DPORT: W16, sparx5: is2
+ *   Sparx5: TCP/UDP destination port. Overloading for IP_7TUPLE: Non-TCP/UDP IP
+ *   frames: L4_DPORT = L3_IP_PROTO, LAN966x: TCP/UDP destination port
+ * VCAP_KF_L4_FIN: W1, sparx5: is2
+ *   TCP flag FIN, LAN966x: TCP flag FIN, and for PTP over UDP: messageType bit 1
+ * VCAP_KF_L4_PAYLOAD: W64, sparx5: is2
+ *   Payload bytes after TCP/UDP header Overloading for IP_7TUPLE: Non TCP/UDP
+ *   frames: Payload bytes 0–7 after IP header. IPv4 options are not parsed so
+ *   payload is always taken 20 bytes after the start of the IPv4 header for non
+ *   TCP/UDP IPv4 frames
+ * VCAP_KF_L4_PSH: W1, sparx5: is2
+ *   Sparx5: TCP flag PSH, LAN966x: TCP: TCP flag PSH. PTP over UDP: flagField bit
+ *   1 (twoStepFlag)
+ * VCAP_KF_L4_RNG: W16, sparx5: is2
+ *   Range checker bitmask (one for each range checker). Input into range checkers
+ *   is taken from classified results (VID, DSCP) and frame (SPORT, DPORT, ETYPE,
+ *   outer VID, inner VID)
+ * VCAP_KF_L4_RST: W1, sparx5: is2
+ *   Sparx5: TCP flag RST , LAN966x: TCP: TCP flag RST. PTP over UDP: messageType
+ *   bit 3
+ * VCAP_KF_L4_SEQUENCE_EQ0_IS: W1, sparx5: is2
+ *   Set if TCP sequence number is 0, LAN966x: Overlayed with PTP over UDP:
+ *   messageType bit 0
+ * VCAP_KF_L4_SPORT: W16, sparx5: is2
+ *   TCP/UDP source port
+ * VCAP_KF_L4_SPORT_EQ_DPORT_IS: W1, sparx5: is2
+ *   Set if UDP or TCP source port equals UDP or TCP destination port
+ * VCAP_KF_L4_SYN: W1, sparx5: is2
+ *   Sparx5: TCP flag SYN, LAN966x: TCP: TCP flag SYN. PTP over UDP: messageType
+ *   bit 2
+ * VCAP_KF_L4_URG: W1, sparx5: is2
+ *   Sparx5: TCP flag URG, LAN966x: TCP: TCP flag URG. PTP over UDP: flagField bit
+ *   7 (reserved)
+ * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is2
+ *   Selects between entries relevant for first and second lookup. Set for first
+ *   lookup, cleared for second lookup.
+ * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2
+ *   Classified Policy Association Group: chains rules from IS1/CLM to IS2
+ * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2
+ *   Dual-ended loss measurement counters in CCM frames are all zero
+ * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is2
+ *   Set if frame’s EtherType = 0x8902
+ * VCAP_KF_TCP_IS: W1, sparx5: is2
+ *   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
+ *   header = 6)
+ * VCAP_KF_TCP_UDP_IS: W1, sparx5: is2
+ *   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
+ *   or 17)
+ * VCAP_KF_TYPE: sparx5 is2 W4, sparx5 is2 W2
+ *   Keyset type id - set by the API
+ */
+
+/* Keyfield names */
+enum vcap_key_field {
+	VCAP_KF_NO_VALUE,  /* initial value */
+	VCAP_KF_8021Q_DEI_CLS,
+	VCAP_KF_8021Q_PCP_CLS,
+	VCAP_KF_8021Q_VID_CLS,
+	VCAP_KF_8021Q_VLAN_TAGGED_IS,
+	VCAP_KF_ARP_ADDR_SPACE_OK_IS,
+	VCAP_KF_ARP_LEN_OK_IS,
+	VCAP_KF_ARP_OPCODE,
+	VCAP_KF_ARP_OPCODE_UNKNOWN_IS,
+	VCAP_KF_ARP_PROTO_SPACE_OK_IS,
+	VCAP_KF_ARP_SENDER_MATCH_IS,
+	VCAP_KF_ARP_TGT_MATCH_IS,
+	VCAP_KF_ETYPE,
+	VCAP_KF_ETYPE_LEN_IS,
+	VCAP_KF_IF_IGR_PORT_MASK,
+	VCAP_KF_IF_IGR_PORT_MASK_L3,
+	VCAP_KF_IF_IGR_PORT_MASK_RNG,
+	VCAP_KF_IF_IGR_PORT_MASK_SEL,
+	VCAP_KF_IP4_IS,
+	VCAP_KF_ISDX_CLS,
+	VCAP_KF_ISDX_GT0_IS,
+	VCAP_KF_L2_BC_IS,
+	VCAP_KF_L2_DMAC,
+	VCAP_KF_L2_FWD_IS,
+	VCAP_KF_L2_MC_IS,
+	VCAP_KF_L2_PAYLOAD_ETYPE,
+	VCAP_KF_L2_SMAC,
+	VCAP_KF_L3_DIP_EQ_SIP_IS,
+	VCAP_KF_L3_DST_IS,
+	VCAP_KF_L3_FRAGMENT_TYPE,
+	VCAP_KF_L3_FRAG_INVLD_L4_LEN,
+	VCAP_KF_L3_IP4_DIP,
+	VCAP_KF_L3_IP4_SIP,
+	VCAP_KF_L3_IP6_DIP,
+	VCAP_KF_L3_IP6_SIP,
+	VCAP_KF_L3_IP_PROTO,
+	VCAP_KF_L3_OPTIONS_IS,
+	VCAP_KF_L3_PAYLOAD,
+	VCAP_KF_L3_RT_IS,
+	VCAP_KF_L3_TOS,
+	VCAP_KF_L3_TTL_GT0,
+	VCAP_KF_L4_ACK,
+	VCAP_KF_L4_DPORT,
+	VCAP_KF_L4_FIN,
+	VCAP_KF_L4_PAYLOAD,
+	VCAP_KF_L4_PSH,
+	VCAP_KF_L4_RNG,
+	VCAP_KF_L4_RST,
+	VCAP_KF_L4_SEQUENCE_EQ0_IS,
+	VCAP_KF_L4_SPORT,
+	VCAP_KF_L4_SPORT_EQ_DPORT_IS,
+	VCAP_KF_L4_SYN,
+	VCAP_KF_L4_URG,
+	VCAP_KF_LOOKUP_FIRST_IS,
+	VCAP_KF_LOOKUP_PAG,
+	VCAP_KF_OAM_CCM_CNTS_EQ0,
+	VCAP_KF_OAM_Y1731_IS,
+	VCAP_KF_TCP_IS,
+	VCAP_KF_TCP_UDP_IS,
+	VCAP_KF_TYPE,
+};
+
+/* Actionset names with origin information */
+enum vcap_actionfield_set {
+	VCAP_AFS_NO_VALUE,          /* initial value */
+	VCAP_AFS_BASE_TYPE,         /* sparx5 is2 X3 */
+};
+
+/* List of actionfields with description
+ *
+ * VCAP_AF_CNT_ID: W12, sparx5: is2
+ *   Counter ID, used per lookup to index the 4K frame counters (ANA_ACL:CNT_TBL).
+ *   Multiple VCAP IS2 entries can use the same counter.
+ * VCAP_AF_CPU_COPY_ENA: W1, sparx5: is2
+ *   Setting this bit to 1 causes all frames that hit this action to be copied to
+ *   the CPU extraction queue specified in CPU_QUEUE_NUM.
+ * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2
+ *   CPU queue number. Used when CPU_COPY_ENA is set.
+ * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2
+ *   Setting this bit to 1 causes the first frame that hits this action where the
+ *   HIT_CNT counter is zero to be copied to the CPU extraction queue specified in
+ *   CPU_QUEUE_NUM. The HIT_CNT counter is then incremented and any frames that
+ *   hit this action later are not copied to the CPU. To re-enable the HIT_ME_ONCE
+ *   functionality, the HIT_CNT counter must be cleared.
+ * VCAP_AF_IGNORE_PIPELINE_CTRL: W1, sparx5: is2
+ *   Ignore ingress pipeline control. This enforces the use of the VCAP IS2 action
+ *   even when the pipeline control has terminated the frame before VCAP IS2.
+ * VCAP_AF_INTR_ENA: W1, sparx5: is2
+ *   If set, an interrupt is triggered when this rule is hit
+ * VCAP_AF_LRN_DIS: W1, sparx5: is2
+ *   Setting this bit to 1 disables learning of frames hitting this action.
+ * VCAP_AF_MASK_MODE: W3, sparx5: is2
+ *   Controls the PORT_MASK use. Sparx5: 0: OR_DSTMASK, 1: AND_VLANMASK, 2:
+ *   REPLACE_PGID, 3: REPLACE_ALL, 4: REDIR_PGID, 5: OR_PGID_MASK, 6: VSTAX, 7:
+ *   Not applicable. LAN966X: 0: No action, 1: Permit/deny (AND), 2: Policy
+ *   forwarding (DMAC lookup), 3: Redirect. The CPU port is untouched by
+ *   MASK_MODE.
+ * VCAP_AF_MATCH_ID: W16, sparx5: is2
+ *   Logical ID for the entry. The MATCH_ID is extracted together with the frame
+ *   if the frame is forwarded to the CPU (CPU_COPY_ENA). The result is placed in
+ *   IFH.CL_RSLT.
+ * VCAP_AF_MATCH_ID_MASK: W16, sparx5: is2
+ *   Mask used by MATCH_ID.
+ * VCAP_AF_MIRROR_PROBE: W2, sparx5: is2
+ *   Mirroring performed according to configuration of a mirror probe. 0: No
+ *   mirroring. 1: Mirror probe 0. 2: Mirror probe 1. 3: Mirror probe 2
+ * VCAP_AF_PIPELINE_FORCE_ENA: W1, sparx5: is2
+ *   If set, use PIPELINE_PT unconditionally and set PIPELINE_ACT = NONE if
+ *   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
+ * VCAP_AF_PIPELINE_PT: W5, sparx5: is2
+ *   Pipeline point used if PIPELINE_FORCE_ENA is set
+ * VCAP_AF_POLICE_ENA: W1, sparx5: is2
+ *   Setting this bit to 1 causes frames that hit this action to be policed by the
+ *   ACL policer specified in POLICE_IDX. Only applies to the first lookup.
+ * VCAP_AF_POLICE_IDX: W6, sparx5: is2
+ *   Selects VCAP policer used when policing frames (POLICE_ENA)
+ * VCAP_AF_PORT_MASK: W68, sparx5: is2
+ *   Port mask applied to the forwarding decision based on MASK_MODE.
+ * VCAP_AF_RT_DIS: W1, sparx5: is2
+ *   If set, routing is disallowed. Only applies when IS_INNER_ACL is 0. See also
+ *   IGR_ACL_ENA, EGR_ACL_ENA, and RLEG_STAT_IDX.
+ */
+
+/* Actionfield names */
+enum vcap_action_field {
+	VCAP_AF_NO_VALUE,  /* initial value */
+	VCAP_AF_CNT_ID,
+	VCAP_AF_CPU_COPY_ENA,
+	VCAP_AF_CPU_QUEUE_NUM,
+	VCAP_AF_HIT_ME_ONCE,
+	VCAP_AF_IGNORE_PIPELINE_CTRL,
+	VCAP_AF_INTR_ENA,
+	VCAP_AF_LRN_DIS,
+	VCAP_AF_MASK_MODE,
+	VCAP_AF_MATCH_ID,
+	VCAP_AF_MATCH_ID_MASK,
+	VCAP_AF_MIRROR_PROBE,
+	VCAP_AF_PIPELINE_FORCE_ENA,
+	VCAP_AF_PIPELINE_PT,
+	VCAP_AF_POLICE_ENA,
+	VCAP_AF_POLICE_IDX,
+	VCAP_AF_PORT_MASK,
+	VCAP_AF_RT_DIS,
+};
+
+#endif /* __VCAP_AG_API__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
new file mode 100644
index 000000000000..4444bf67ebec
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -0,0 +1,269 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API
+ */
+
+#ifndef __VCAP_API__
+#define __VCAP_API__
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+
+/* Use the generated API model */
+#include "vcap_ag_api.h"
+
+#define VCAP_CID_LOOKUP_SIZE          100000 /* Chains in a lookup */
+#define VCAP_CID_INGRESS_L0          1000000 /* Ingress Stage 1 Lookup 0 */
+#define VCAP_CID_INGRESS_L1          1100000 /* Ingress Stage 1 Lookup 1 */
+#define VCAP_CID_INGRESS_L2          1200000 /* Ingress Stage 1 Lookup 2 */
+#define VCAP_CID_INGRESS_L3          1300000 /* Ingress Stage 1 Lookup 3 */
+#define VCAP_CID_INGRESS_L4          1400000 /* Ingress Stage 1 Lookup 4 */
+#define VCAP_CID_INGRESS_L5          1500000 /* Ingress Stage 1 Lookup 5 */
+
+#define VCAP_CID_PREROUTING_IPV6     3000000 /* Prerouting Stage */
+#define VCAP_CID_PREROUTING          6000000 /* Prerouting Stage */
+
+#define VCAP_CID_INGRESS_STAGE2_L0   8000000 /* Ingress Stage 2 Lookup 0 */
+#define VCAP_CID_INGRESS_STAGE2_L1   8100000 /* Ingress Stage 2 Lookup 1 */
+#define VCAP_CID_INGRESS_STAGE2_L2   8200000 /* Ingress Stage 2 Lookup 2 */
+#define VCAP_CID_INGRESS_STAGE2_L3   8300000 /* Ingress Stage 2 Lookup 3 */
+
+#define VCAP_CID_EGRESS_L0           10000000 /* Egress Lookup 0 */
+#define VCAP_CID_EGRESS_L1           10100000 /* Egress Lookup 1 */
+
+#define VCAP_CID_EGRESS_STAGE2_L0    20000000 /* Egress Stage 2 Lookup 0 */
+#define VCAP_CID_EGRESS_STAGE2_L1    20100000 /* Egress Stage 2 Lookup 1 */
+
+/* Known users of the VCAP API */
+enum vcap_user {
+	VCAP_USER_PTP,
+	VCAP_USER_MRP,
+	VCAP_USER_CFM,
+	VCAP_USER_VLAN,
+	VCAP_USER_QOS,
+	VCAP_USER_VCAP_UTIL,
+	VCAP_USER_TC,
+	VCAP_USER_TC_EXTRA,
+
+	/* add new users above here */
+
+	/* used to define VCAP_USER_MAX below */
+	__VCAP_USER_AFTER_LAST,
+	VCAP_USER_MAX = __VCAP_USER_AFTER_LAST - 1,
+};
+
+/* VCAP information used for displaying data */
+struct vcap_statistics {
+	char *name;
+	int count;
+	const char * const *keyfield_set_names;
+	const char * const *actionfield_set_names;
+	const char * const *keyfield_names;
+	const char * const *actionfield_names;
+};
+
+/* VCAP key/action field type, position and width */
+struct vcap_field {
+	u16 type;
+	u16 width;
+	u16 offset;
+};
+
+/* VCAP keyset or actionset type and width */
+struct vcap_set {
+	u8 type_id;
+	u8 sw_per_item;
+	u8 sw_cnt;
+};
+
+/* VCAP typegroup position and bitvalue */
+struct vcap_typegroup {
+	u16 offset;
+	u16 width;
+	u16 value;
+};
+
+/* VCAP model data */
+struct vcap_info {
+	char *name; /* user-friendly name */
+	u16 rows; /* number of row in instance */
+	u16 sw_count; /* maximum subwords used per rule */
+	u16 sw_width; /* bits per subword in a keyset */
+	u16 sticky_width; /* sticky bits per rule */
+	u16 act_width;  /* bits per subword in an actionset */
+	u16 default_cnt; /* number of default rules */
+	u16 require_cnt_dis; /* not used */
+	u16 version; /* vcap rtl version */
+	const struct vcap_set *keyfield_set; /* keysets */
+	int keyfield_set_size; /* number of keysets */
+	const struct vcap_set *actionfield_set; /* actionsets */
+	int actionfield_set_size; /* number of actionsets */
+	/* map of keys per keyset */
+	const struct vcap_field **keyfield_set_map;
+	/* number of entries in the above map */
+	int *keyfield_set_map_size;
+	/* map of actions per actionset */
+	const struct vcap_field **actionfield_set_map;
+	/* number of entries in the above map */
+	int *actionfield_set_map_size;
+	/* map of keyset typegroups per subword size */
+	const struct vcap_typegroup **keyfield_set_typegroups;
+	/* map of actionset typegroups per subword size */
+	const struct vcap_typegroup **actionfield_set_typegroups;
+};
+
+enum vcap_field_type {
+	VCAP_FIELD_BIT,
+	VCAP_FIELD_U32,
+	VCAP_FIELD_U48,
+	VCAP_FIELD_U56,
+	VCAP_FIELD_U64,
+	VCAP_FIELD_U72,
+	VCAP_FIELD_U112,
+	VCAP_FIELD_U128,
+};
+
+/* VCAP rule data towards the VCAP cache */
+struct vcap_cache_data {
+	u32 *keystream;
+	u32 *maskstream;
+	u32 *actionstream;
+	u32 counter;
+	bool sticky;
+};
+
+/* Selects which part of the rule must be updated */
+enum vcap_selection {
+	VCAP_SEL_ENTRY = 0x01,
+	VCAP_SEL_ACTION = 0x02,
+	VCAP_SEL_COUNTER = 0x04,
+	VCAP_SEL_ALL = 0xff,
+};
+
+/* Commands towards the VCAP cache */
+enum vcap_command {
+	VCAP_CMD_WRITE = 0,
+	VCAP_CMD_READ = 1,
+	VCAP_CMD_MOVE_DOWN = 2,
+	VCAP_CMD_MOVE_UP = 3,
+	VCAP_CMD_INITIALIZE = 4,
+};
+
+enum vcap_rule_error {
+	VCAP_ERR_NONE = 0,  /* No known error */
+	VCAP_ERR_NO_ADMIN,  /* No admin instance */
+	VCAP_ERR_NO_NETDEV,  /* No netdev instance */
+	VCAP_ERR_NO_KEYSET_MATCH, /* No keyset matched the rule keys */
+	VCAP_ERR_NO_ACTIONSET_MATCH, /* No actionset matched the rule actions */
+	VCAP_ERR_NO_PORT_KEYSET_MATCH, /* No port keyset matched the rule keys */
+};
+
+/* Administration of each VCAP instance */
+struct vcap_admin {
+	struct list_head list; /* for insertion in vcap_control */
+	struct list_head rules; /* list of rules */
+	enum vcap_type vtype;  /* type of vcap */
+	int vinst; /* instance number within the same type */
+	int first_cid; /* first chain id in this vcap */
+	int last_cid; /* last chain id in this vcap */
+	int tgt_inst; /* hardware instance number */
+	int lookups; /* number of lookups in this vcap type */
+	int lookups_per_instance; /* number of lookups in this instance */
+	int last_valid_addr; /* top of address range to be used */
+	int first_valid_addr; /* bottom of address range to be used */
+	int last_used_addr;  /* address of lowest added rule */
+	bool w32be; /* vcap uses "32bit-word big-endian" encoding */
+	struct vcap_cache_data cache; /* encoded rule data */
+};
+
+/* Client supplied VCAP rule data */
+struct vcap_rule {
+	int vcap_chain_id; /* chain used for this rule */
+	enum vcap_user user; /* rule owner */
+	u16 priority;
+	u32 id;  /* vcap rule id, must be unique, 0 will auto-generate a value */
+	u64 cookie;  /* used by the client to identify the rule */
+	struct list_head keyfields;  /* list of vcap_client_keyfield */
+	struct list_head actionfields;  /* list of vcap_client_actionfield */
+	enum vcap_keyfield_set keyset; /* keyset used: may be derived from fields */
+	enum vcap_actionfield_set actionset; /* actionset used: may be derived from fields */
+	enum vcap_rule_error exterr; /* extended error - used by TC */
+	u64 client; /* space for client defined data */
+};
+
+/* List of keysets */
+struct vcap_keyset_list {
+	int max; /* size of the keyset list */
+	int cnt; /* count of keysets actually in the list */
+	enum vcap_keyfield_set *keysets; /* the list of keysets */
+};
+
+/* Client supplied VCAP callback operations */
+struct vcap_operations {
+	/* validate port keyset operation */
+	enum vcap_keyfield_set (*validate_keyset)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 struct vcap_rule *rule,
+		 struct vcap_keyset_list *kslist,
+		 u16 l3_proto);
+	/* add default rule fields for the selected keyset operations */
+	void (*add_default_fields)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 struct vcap_rule *rule);
+	/* cache operations */
+	void (*cache_erase)
+		(struct vcap_admin *admin);
+	void (*cache_write)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 enum vcap_selection sel,
+		 u32 idx, u32 count);
+	void (*cache_read)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 enum vcap_selection sel,
+		 u32 idx,
+		 u32 count);
+	/* block operations */
+	void (*init)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 u32 addr,
+		 u32 count);
+	void (*update)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 enum vcap_command cmd,
+		 enum vcap_selection sel,
+		 u32 addr);
+	void (*move)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 u32 addr,
+		 int offset,
+		 int count);
+	/* informational */
+	int (*port_info)
+		(struct net_device *ndev,
+		 enum vcap_type vtype,
+		 int (*pf)(void *out, int arg, const char *fmt, ...),
+		 void *out,
+		 int arg);
+};
+
+/* VCAP API Client control interface */
+struct vcap_control {
+	u32 rule_id; /* last used rule id (unique across VCAP instances) */
+	struct vcap_operations *ops;  /* client supplied operations */
+	const struct vcap_info *vcaps; /* client supplied vcap models */
+	const struct vcap_statistics *stats; /* client supplied vcap stats */
+	struct list_head list; /* list of vcap instances */
+};
+
+/* Set client control interface on the API */
+int vcap_api_set_client(struct vcap_control *vctrl);
+
+#endif /* __VCAP_API__ */
-- 
2.38.1

