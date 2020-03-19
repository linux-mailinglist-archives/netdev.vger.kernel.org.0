Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA48718BC83
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgCSQ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:28:57 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54258 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgCSQ2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:28:54 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGSTah085362;
        Thu, 19 Mar 2020 11:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584635309;
        bh=29jJAnVjvz932+VLNDkqp9uCG/z81gOmhGpdn2EFFRc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=kHOqd4sfXQPByzNy1eLE43Bcls34Aq0WU89HdSVGZck6pIpZNgJ6MF0l5uCe0x0ak
         rPbXsSKWt60ZTIjwaxYMvLRrY271p9VFEQpV9HJsShY9NWpnMpQGMMvnzrAV6G5LlD
         2CTrSv8yM+K2s3po1wSHJHDTHFzWFyFYyWHQs+F4=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGSTgQ093569;
        Thu, 19 Mar 2020 11:28:29 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:28:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:28:28 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGSPOd110310;
        Thu, 19 Mar 2020 11:28:26 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 06/11] net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver
Date:   Thu, 19 Mar 2020 18:28:01 +0200
Message-ID: <20200319162806.25705-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319162806.25705-1-grygorii.strashko@ti.com>
References: <20200319162806.25705-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI AM65x/J721E SoCs Gigabit Ethernet Switch subsystem (CPSW2G NUSS) has
two ports - One Ethernet port (port 1) with selectable RGMII and RMII
interfaces and an internal Communications Port Programming Interface (CPPI)
port (Host port 0) and with ALE in between. It also contains
 - Management Data Input/Output (MDIO) interface for physical layer device
(PHY) management;
 - Updated Address Lookup Engine (ALE) module;
 - (TBD) New version of Common platform time sync (CPTS) module.

On the TI am65x/J721E SoCs CPSW NUSS Ethernet subsystem into device MCU
domain named MCU_CPSW0.

Host Port 0 CPPI Packet Streaming Interface interface supports 8 TX
channels and one RX channels operating by TI am654 NAVSS Unified DMA
Peripheral Root Complex (UDMA-P) controller.

Introduced driver provides standard Linux net_device to user space and supports:
 - ifconfig up/down
 - MAC address configuration
 - ethtool operation:
   --driver
   --change
   --register-dump
   --negotiate phy
   --statistics
   --set-eee phy
   --show-ring
   --show-channels
   --set-channels
 - net_device ioctl mii-control
 - promisc mode

 - rx checksum offload for non-fragmented IPv4/IPv6 TCP/UDP packets.
   The CPSW NUSS can verify IPv4/IPv6 TCP/UDP packets checksum and fills
   csum information for each packet in psdata[2] word:
   - BIT(16) CHECKSUM_ERROR - indicates csum error
   - BIT(17) FRAGMENT -  indicates fragmented packet
   - BIT(18) TCP_UDP_N -  Indicates TCP packet was detected
   - BIT(19) IPV6_VALID,  BIT(20) IPV4_VALID - indicates IPv6/IPv4 packet
   - BIT(15, 0) CHECKSUM_ADD - This is the value that was summed
   during the checksum computation. This value is FFFFh for non fragmented
   IPV4/6 UDP/TCP packets with no checksum error.

   RX csum offload can be disabled:
	 ethtool -K <dev> rx-checksum on|off

 - tx checksum offload support for IPv4/IPv6 TCP/UDP packets (J721E only).
   TX csum HW offload  can be enabled/disabled:
	 ethtool -K <dev> tx-checksum-ip-generic on|off

 - multiq and switch between round robin/prio modes for cppi tx queues by
   using Netdev private flag "p0-rx-ptype-rrobin" to switch between
   Round Robin and Fixed priority modes:
	 # ethtool --show-priv-flags eth0
	 Private flags for eth0:
	 p0-rx-ptype-rrobin: on
	 # ethtool --set-priv-flags eth0 p0-rx-ptype-rrobin off

   Number of TX DMA channels can be changed using "ethtool -L eth0 tx <N>".

 - GRO support: the napi_gro_receive() and napi_complete_done() are used.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/net/ethernet/ti/Kconfig             |   19 +-
 drivers/net/ethernet/ti/Makefile            |    3 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  747 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 1965 +++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h    |  142 ++
 drivers/net/ethernet/ti/k3-cppi-desc-pool.c |  126 ++
 drivers/net/ethernet/ti/k3-cppi-desc-pool.h |   30 +
 7 files changed, 3030 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-ethtool.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.h
 create mode 100644 drivers/net/ethernet/ti/k3-cppi-desc-pool.c
 create mode 100644 drivers/net/ethernet/ti/k3-cppi-desc-pool.h

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 8a6ca16eee3b..89cec778cf2d 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_TI
 	bool "Texas Instruments (TI) devices"
 	default y
-	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE
+	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -31,7 +31,7 @@ config TI_DAVINCI_EMAC
 
 config TI_DAVINCI_MDIO
 	tristate "TI DaVinci MDIO Support"
-	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
+	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST
 	select PHYLIB
 	---help---
 	  This driver supports TI's DaVinci MDIO module.
@@ -95,6 +95,21 @@ config TI_CPTS_MOD
 	imply PTP_1588_CLOCK
 	default m
 
+config TI_K3_AM65_CPSW_NUSS
+	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
+	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
+	select TI_DAVINCI_MDIO
+	imply PHY_TI_GMII_SEL
+	help
+	  This driver supports TI K3 AM654/J721E CPSW2G Ethernet SubSystem.
+	  The two-port Gigabit Ethernet MAC (MCU_CPSW0) subsystem provides
+	  Ethernet packet communication for the device: One Ethernet port
+	  (port 1) with selectable RGMII and RMII interfaces and an internal
+	  Communications Port Programming Interface (CPPI) port (port 0).
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ti-am65-cpsw-nuss.
+
 config TI_KEYSTONE_NETCP
 	tristate "TI Keystone NETCP Core Support"
 	select TI_DAVINCI_MDIO
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index ecf776ad8689..53792190e9c2 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -23,3 +23,6 @@ obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
 keystone_netcp-y := netcp_core.o cpsw_ale.o
 obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) += keystone_netcp_ethss.o
 keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o cpsw_ale.o
+
+obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
+ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-cppi-desc-pool.o
diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
new file mode 100644
index 000000000000..c3502aa15ea0
--- /dev/null
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -0,0 +1,747 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Texas Instruments K3 AM65 Ethernet Switch SubSystem Driver ethtool ops
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ */
+
+#include <linux/net_tstamp.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "am65-cpsw-nuss.h"
+#include "cpsw_ale.h"
+
+#define AM65_CPSW_REGDUMP_VER 0x1
+
+enum {
+	AM65_CPSW_REGDUMP_MOD_NUSS = 1,
+	AM65_CPSW_REGDUMP_MOD_RGMII_STATUS = 2,
+	AM65_CPSW_REGDUMP_MOD_MDIO = 3,
+	AM65_CPSW_REGDUMP_MOD_CPSW = 4,
+	AM65_CPSW_REGDUMP_MOD_CPSW_P0 = 5,
+	AM65_CPSW_REGDUMP_MOD_CPSW_P1 = 6,
+	AM65_CPSW_REGDUMP_MOD_CPSW_CPTS = 7,
+	AM65_CPSW_REGDUMP_MOD_CPSW_ALE = 8,
+	AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL = 9,
+	AM65_CPSW_REGDUMP_MOD_LAST,
+};
+
+/**
+ * struct am65_cpsw_regdump_hdr - regdump record header
+ *
+ * @module_id: CPSW module ID
+ * @len: CPSW module registers space length in u32
+ */
+
+struct am65_cpsw_regdump_hdr {
+	u32 module_id;
+	u32 len;
+};
+
+/**
+ * struct am65_cpsw_regdump_item - regdump module description
+ *
+ * @hdr: CPSW module header
+ * @start_ofs: CPSW module registers start addr
+ * @end_ofs: CPSW module registers end addr
+ *
+ * Registers dump provided in the format:
+ *  u32 : module ID
+ *  u32 : dump length
+ *  u32[..len]: registers values
+ */
+struct am65_cpsw_regdump_item {
+	struct am65_cpsw_regdump_hdr hdr;
+	u32 start_ofs;
+	u32 end_ofs;
+};
+
+#define AM65_CPSW_REGDUMP_REC(mod, start, end) { \
+	.hdr.module_id = (mod), \
+	.hdr.len = (((u32 *)(end)) - ((u32 *)(start)) + 1) * sizeof(u32) * 2 + \
+		   sizeof(struct am65_cpsw_regdump_hdr), \
+	.start_ofs = (start), \
+	.end_ofs = end, \
+}
+
+static const struct am65_cpsw_regdump_item am65_cpsw_regdump[] = {
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_NUSS, 0x0, 0x1c),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_RGMII_STATUS, 0x30, 0x4c),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_MDIO, 0xf00, 0xffc),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW, 0x20000, 0x2011c),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW_P0, 0x21000, 0x21320),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW_P1, 0x22000, 0x223a4),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW_CPTS,
+			      0x3d000, 0x3d048),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW_ALE, 0x3e000, 0x3e13c),
+	AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL, 0, 0),
+};
+
+struct am65_cpsw_stats_regs {
+	u32	rx_good_frames;
+	u32	rx_broadcast_frames;
+	u32	rx_multicast_frames;
+	u32	rx_pause_frames;		/* slave */
+	u32	rx_crc_errors;
+	u32	rx_align_code_errors;		/* slave */
+	u32	rx_oversized_frames;
+	u32	rx_jabber_frames;		/* slave */
+	u32	rx_undersized_frames;
+	u32	rx_fragments;			/* slave */
+	u32	ale_drop;
+	u32	ale_overrun_drop;
+	u32	rx_octets;
+	u32	tx_good_frames;
+	u32	tx_broadcast_frames;
+	u32	tx_multicast_frames;
+	u32	tx_pause_frames;		/* slave */
+	u32	tx_deferred_frames;		/* slave */
+	u32	tx_collision_frames;		/* slave */
+	u32	tx_single_coll_frames;		/* slave */
+	u32	tx_mult_coll_frames;		/* slave */
+	u32	tx_excessive_collisions;	/* slave */
+	u32	tx_late_collisions;		/* slave */
+	u32	rx_ipg_error;			/* slave 10G only */
+	u32	tx_carrier_sense_errors;	/* slave */
+	u32	tx_octets;
+	u32	tx_64B_frames;
+	u32	tx_65_to_127B_frames;
+	u32	tx_128_to_255B_frames;
+	u32	tx_256_to_511B_frames;
+	u32	tx_512_to_1023B_frames;
+	u32	tx_1024B_frames;
+	u32	net_octets;
+	u32	rx_bottom_fifo_drop;
+	u32	rx_port_mask_drop;
+	u32	rx_top_fifo_drop;
+	u32	ale_rate_limit_drop;
+	u32	ale_vid_ingress_drop;
+	u32	ale_da_eq_sa_drop;
+	u32	ale_block_drop;			/* K3 */
+	u32	ale_secure_drop;		/* K3 */
+	u32	ale_auth_drop;			/* K3 */
+	u32	ale_unknown_ucast;
+	u32	ale_unknown_ucast_bytes;
+	u32	ale_unknown_mcast;
+	u32	ale_unknown_mcast_bytes;
+	u32	ale_unknown_bcast;
+	u32	ale_unknown_bcast_bytes;
+	u32	ale_pol_match;
+	u32	ale_pol_match_red;
+	u32	ale_pol_match_yellow;
+	u32	ale_mcast_sa_drop;		/* K3 */
+	u32	ale_dual_vlan_drop;		/* K3 */
+	u32	ale_len_err_drop;		/* K3 */
+	u32	ale_ip_next_hdr_drop;		/* K3 */
+	u32	ale_ipv4_frag_drop;		/* K3 */
+	u32	__rsvd_1[24];
+	u32	iet_rx_assembly_err;		/* K3 slave */
+	u32	iet_rx_assembly_ok;		/* K3 slave */
+	u32	iet_rx_smd_err;			/* K3 slave */
+	u32	iet_rx_frag;			/* K3 slave */
+	u32	iet_tx_hold;			/* K3 slave */
+	u32	iet_tx_frag;			/* K3 slave */
+	u32	__rsvd_2[9];
+	u32	tx_mem_protect_err;
+	/* following NU only */
+	u32	tx_pri0;
+	u32	tx_pri1;
+	u32	tx_pri2;
+	u32	tx_pri3;
+	u32	tx_pri4;
+	u32	tx_pri5;
+	u32	tx_pri6;
+	u32	tx_pri7;
+	u32	tx_pri0_bcnt;
+	u32	tx_pri1_bcnt;
+	u32	tx_pri2_bcnt;
+	u32	tx_pri3_bcnt;
+	u32	tx_pri4_bcnt;
+	u32	tx_pri5_bcnt;
+	u32	tx_pri6_bcnt;
+	u32	tx_pri7_bcnt;
+	u32	tx_pri0_drop;
+	u32	tx_pri1_drop;
+	u32	tx_pri2_drop;
+	u32	tx_pri3_drop;
+	u32	tx_pri4_drop;
+	u32	tx_pri5_drop;
+	u32	tx_pri6_drop;
+	u32	tx_pri7_drop;
+	u32	tx_pri0_drop_bcnt;
+	u32	tx_pri1_drop_bcnt;
+	u32	tx_pri2_drop_bcnt;
+	u32	tx_pri3_drop_bcnt;
+	u32	tx_pri4_drop_bcnt;
+	u32	tx_pri5_drop_bcnt;
+	u32	tx_pri6_drop_bcnt;
+	u32	tx_pri7_drop_bcnt;
+};
+
+struct am65_cpsw_ethtool_stat {
+	char desc[ETH_GSTRING_LEN];
+	int offset;
+};
+
+#define AM65_CPSW_STATS(prefix, field)			\
+{							\
+	#prefix#field,					\
+	offsetof(struct am65_cpsw_stats_regs, field)	\
+}
+
+static const struct am65_cpsw_ethtool_stat am65_host_stats[] = {
+	AM65_CPSW_STATS(p0_, rx_good_frames),
+	AM65_CPSW_STATS(p0_, rx_broadcast_frames),
+	AM65_CPSW_STATS(p0_, rx_multicast_frames),
+	AM65_CPSW_STATS(p0_, rx_crc_errors),
+	AM65_CPSW_STATS(p0_, rx_oversized_frames),
+	AM65_CPSW_STATS(p0_, rx_undersized_frames),
+	AM65_CPSW_STATS(p0_, ale_drop),
+	AM65_CPSW_STATS(p0_, ale_overrun_drop),
+	AM65_CPSW_STATS(p0_, rx_octets),
+	AM65_CPSW_STATS(p0_, tx_good_frames),
+	AM65_CPSW_STATS(p0_, tx_broadcast_frames),
+	AM65_CPSW_STATS(p0_, tx_multicast_frames),
+	AM65_CPSW_STATS(p0_, tx_octets),
+	AM65_CPSW_STATS(p0_, tx_64B_frames),
+	AM65_CPSW_STATS(p0_, tx_65_to_127B_frames),
+	AM65_CPSW_STATS(p0_, tx_128_to_255B_frames),
+	AM65_CPSW_STATS(p0_, tx_256_to_511B_frames),
+	AM65_CPSW_STATS(p0_, tx_512_to_1023B_frames),
+	AM65_CPSW_STATS(p0_, tx_1024B_frames),
+	AM65_CPSW_STATS(p0_, net_octets),
+	AM65_CPSW_STATS(p0_, rx_bottom_fifo_drop),
+	AM65_CPSW_STATS(p0_, rx_port_mask_drop),
+	AM65_CPSW_STATS(p0_, rx_top_fifo_drop),
+	AM65_CPSW_STATS(p0_, ale_rate_limit_drop),
+	AM65_CPSW_STATS(p0_, ale_vid_ingress_drop),
+	AM65_CPSW_STATS(p0_, ale_da_eq_sa_drop),
+	AM65_CPSW_STATS(p0_, ale_block_drop),
+	AM65_CPSW_STATS(p0_, ale_secure_drop),
+	AM65_CPSW_STATS(p0_, ale_auth_drop),
+	AM65_CPSW_STATS(p0_, ale_unknown_ucast),
+	AM65_CPSW_STATS(p0_, ale_unknown_ucast_bytes),
+	AM65_CPSW_STATS(p0_, ale_unknown_mcast),
+	AM65_CPSW_STATS(p0_, ale_unknown_mcast_bytes),
+	AM65_CPSW_STATS(p0_, ale_unknown_bcast),
+	AM65_CPSW_STATS(p0_, ale_unknown_bcast_bytes),
+	AM65_CPSW_STATS(p0_, ale_pol_match),
+	AM65_CPSW_STATS(p0_, ale_pol_match_red),
+	AM65_CPSW_STATS(p0_, ale_pol_match_yellow),
+	AM65_CPSW_STATS(p0_, ale_mcast_sa_drop),
+	AM65_CPSW_STATS(p0_, ale_dual_vlan_drop),
+	AM65_CPSW_STATS(p0_, ale_len_err_drop),
+	AM65_CPSW_STATS(p0_, ale_ip_next_hdr_drop),
+	AM65_CPSW_STATS(p0_, ale_ipv4_frag_drop),
+	AM65_CPSW_STATS(p0_, tx_mem_protect_err),
+	AM65_CPSW_STATS(p0_, tx_pri0),
+	AM65_CPSW_STATS(p0_, tx_pri1),
+	AM65_CPSW_STATS(p0_, tx_pri2),
+	AM65_CPSW_STATS(p0_, tx_pri3),
+	AM65_CPSW_STATS(p0_, tx_pri4),
+	AM65_CPSW_STATS(p0_, tx_pri5),
+	AM65_CPSW_STATS(p0_, tx_pri6),
+	AM65_CPSW_STATS(p0_, tx_pri7),
+	AM65_CPSW_STATS(p0_, tx_pri0_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri1_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri2_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri3_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri4_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri5_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri6_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri7_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri0_drop),
+	AM65_CPSW_STATS(p0_, tx_pri1_drop),
+	AM65_CPSW_STATS(p0_, tx_pri2_drop),
+	AM65_CPSW_STATS(p0_, tx_pri3_drop),
+	AM65_CPSW_STATS(p0_, tx_pri4_drop),
+	AM65_CPSW_STATS(p0_, tx_pri5_drop),
+	AM65_CPSW_STATS(p0_, tx_pri6_drop),
+	AM65_CPSW_STATS(p0_, tx_pri7_drop),
+	AM65_CPSW_STATS(p0_, tx_pri0_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri1_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri2_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri3_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri4_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri5_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri6_drop_bcnt),
+	AM65_CPSW_STATS(p0_, tx_pri7_drop_bcnt),
+};
+
+static const struct am65_cpsw_ethtool_stat am65_slave_stats[] = {
+	AM65_CPSW_STATS(, rx_good_frames),
+	AM65_CPSW_STATS(, rx_broadcast_frames),
+	AM65_CPSW_STATS(, rx_multicast_frames),
+	AM65_CPSW_STATS(, rx_pause_frames),
+	AM65_CPSW_STATS(, rx_crc_errors),
+	AM65_CPSW_STATS(, rx_align_code_errors),
+	AM65_CPSW_STATS(, rx_oversized_frames),
+	AM65_CPSW_STATS(, rx_jabber_frames),
+	AM65_CPSW_STATS(, rx_undersized_frames),
+	AM65_CPSW_STATS(, rx_fragments),
+	AM65_CPSW_STATS(, ale_drop),
+	AM65_CPSW_STATS(, ale_overrun_drop),
+	AM65_CPSW_STATS(, rx_octets),
+	AM65_CPSW_STATS(, tx_good_frames),
+	AM65_CPSW_STATS(, tx_broadcast_frames),
+	AM65_CPSW_STATS(, tx_multicast_frames),
+	AM65_CPSW_STATS(, tx_pause_frames),
+	AM65_CPSW_STATS(, tx_deferred_frames),
+	AM65_CPSW_STATS(, tx_collision_frames),
+	AM65_CPSW_STATS(, tx_single_coll_frames),
+	AM65_CPSW_STATS(, tx_mult_coll_frames),
+	AM65_CPSW_STATS(, tx_excessive_collisions),
+	AM65_CPSW_STATS(, tx_late_collisions),
+	AM65_CPSW_STATS(, rx_ipg_error),
+	AM65_CPSW_STATS(, tx_carrier_sense_errors),
+	AM65_CPSW_STATS(, tx_octets),
+	AM65_CPSW_STATS(, tx_64B_frames),
+	AM65_CPSW_STATS(, tx_65_to_127B_frames),
+	AM65_CPSW_STATS(, tx_128_to_255B_frames),
+	AM65_CPSW_STATS(, tx_256_to_511B_frames),
+	AM65_CPSW_STATS(, tx_512_to_1023B_frames),
+	AM65_CPSW_STATS(, tx_1024B_frames),
+	AM65_CPSW_STATS(, net_octets),
+	AM65_CPSW_STATS(, rx_bottom_fifo_drop),
+	AM65_CPSW_STATS(, rx_port_mask_drop),
+	AM65_CPSW_STATS(, rx_top_fifo_drop),
+	AM65_CPSW_STATS(, ale_rate_limit_drop),
+	AM65_CPSW_STATS(, ale_vid_ingress_drop),
+	AM65_CPSW_STATS(, ale_da_eq_sa_drop),
+	AM65_CPSW_STATS(, ale_block_drop),
+	AM65_CPSW_STATS(, ale_secure_drop),
+	AM65_CPSW_STATS(, ale_auth_drop),
+	AM65_CPSW_STATS(, ale_unknown_ucast),
+	AM65_CPSW_STATS(, ale_unknown_ucast_bytes),
+	AM65_CPSW_STATS(, ale_unknown_mcast),
+	AM65_CPSW_STATS(, ale_unknown_mcast_bytes),
+	AM65_CPSW_STATS(, ale_unknown_bcast),
+	AM65_CPSW_STATS(, ale_unknown_bcast_bytes),
+	AM65_CPSW_STATS(, ale_pol_match),
+	AM65_CPSW_STATS(, ale_pol_match_red),
+	AM65_CPSW_STATS(, ale_pol_match_yellow),
+	AM65_CPSW_STATS(, ale_mcast_sa_drop),
+	AM65_CPSW_STATS(, ale_dual_vlan_drop),
+	AM65_CPSW_STATS(, ale_len_err_drop),
+	AM65_CPSW_STATS(, ale_ip_next_hdr_drop),
+	AM65_CPSW_STATS(, ale_ipv4_frag_drop),
+	AM65_CPSW_STATS(, iet_rx_assembly_err),
+	AM65_CPSW_STATS(, iet_rx_assembly_ok),
+	AM65_CPSW_STATS(, iet_rx_smd_err),
+	AM65_CPSW_STATS(, iet_rx_frag),
+	AM65_CPSW_STATS(, iet_tx_hold),
+	AM65_CPSW_STATS(, iet_tx_frag),
+	AM65_CPSW_STATS(, tx_mem_protect_err),
+	AM65_CPSW_STATS(, tx_pri0),
+	AM65_CPSW_STATS(, tx_pri1),
+	AM65_CPSW_STATS(, tx_pri2),
+	AM65_CPSW_STATS(, tx_pri3),
+	AM65_CPSW_STATS(, tx_pri4),
+	AM65_CPSW_STATS(, tx_pri5),
+	AM65_CPSW_STATS(, tx_pri6),
+	AM65_CPSW_STATS(, tx_pri7),
+	AM65_CPSW_STATS(, tx_pri0_bcnt),
+	AM65_CPSW_STATS(, tx_pri1_bcnt),
+	AM65_CPSW_STATS(, tx_pri2_bcnt),
+	AM65_CPSW_STATS(, tx_pri3_bcnt),
+	AM65_CPSW_STATS(, tx_pri4_bcnt),
+	AM65_CPSW_STATS(, tx_pri5_bcnt),
+	AM65_CPSW_STATS(, tx_pri6_bcnt),
+	AM65_CPSW_STATS(, tx_pri7_bcnt),
+	AM65_CPSW_STATS(, tx_pri0_drop),
+	AM65_CPSW_STATS(, tx_pri1_drop),
+	AM65_CPSW_STATS(, tx_pri2_drop),
+	AM65_CPSW_STATS(, tx_pri3_drop),
+	AM65_CPSW_STATS(, tx_pri4_drop),
+	AM65_CPSW_STATS(, tx_pri5_drop),
+	AM65_CPSW_STATS(, tx_pri6_drop),
+	AM65_CPSW_STATS(, tx_pri7_drop),
+	AM65_CPSW_STATS(, tx_pri0_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri1_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri2_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri3_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri4_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri5_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri6_drop_bcnt),
+	AM65_CPSW_STATS(, tx_pri7_drop_bcnt),
+};
+
+/* Ethtool priv_flags */
+static const char am65_cpsw_ethtool_priv_flags[][ETH_GSTRING_LEN] = {
+#define	AM65_CPSW_PRIV_P0_RX_PTYPE_RROBIN	BIT(0)
+	"p0-rx-ptype-rrobin",
+};
+
+static int am65_cpsw_ethtool_op_begin(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	int ret;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		dev_err(common->dev, "ethtool begin failed %d\n", ret);
+		pm_runtime_put_noidle(common->dev);
+	}
+
+	return ret;
+}
+
+static void am65_cpsw_ethtool_op_complete(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	int ret;
+
+	ret = pm_runtime_put(common->dev);
+	if (ret < 0 && ret != -EBUSY)
+		dev_err(common->dev, "ethtool complete failed %d\n", ret);
+}
+
+static void am65_cpsw_get_drvinfo(struct net_device *ndev,
+				  struct ethtool_drvinfo *info)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+	strlcpy(info->driver, dev_driver_string(common->dev),
+		sizeof(info->driver));
+	strlcpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
+}
+
+static u32 am65_cpsw_get_msglevel(struct net_device *ndev)
+{
+	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
+
+	return priv->msg_enable;
+}
+
+static void am65_cpsw_set_msglevel(struct net_device *ndev, u32 value)
+{
+	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
+
+	priv->msg_enable = value;
+}
+
+static void am65_cpsw_get_channels(struct net_device *ndev,
+				   struct ethtool_channels *ch)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+	ch->max_rx = AM65_CPSW_MAX_RX_QUEUES;
+	ch->max_tx = AM65_CPSW_MAX_TX_QUEUES;
+	ch->rx_count = AM65_CPSW_MAX_RX_QUEUES;
+	ch->tx_count = common->tx_ch_num;
+}
+
+static int am65_cpsw_set_channels(struct net_device *ndev,
+				  struct ethtool_channels *chs)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+	if (!chs->rx_count || !chs->tx_count)
+		return -EINVAL;
+
+	/* Check if interface is up. Can change the num queues when
+	 * the interface is down.
+	 */
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	am65_cpsw_nuss_remove_tx_chns(common);
+
+	return am65_cpsw_nuss_update_tx_chns(common, chs->tx_count);
+}
+
+static void am65_cpsw_get_ringparam(struct net_device *ndev,
+				    struct ethtool_ringparam *ering)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+	/* not supported */
+	ering->tx_pending = common->tx_chns[0].descs_num;
+	ering->rx_pending = common->rx_chns.descs_num;
+}
+
+static void am65_cpsw_get_pauseparam(struct net_device *ndev,
+				     struct ethtool_pauseparam *pause)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	pause->autoneg = AUTONEG_DISABLE;
+	pause->rx_pause = salve->rx_pause ? true : false;
+	pause->tx_pause = salve->tx_pause ? true : false;
+}
+
+static int am65_cpsw_set_pauseparam(struct net_device *ndev,
+				    struct ethtool_pauseparam *pause)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy)
+		return -EINVAL;
+
+	if (!phy_validate_pause(salve->phy, pause))
+		return -EINVAL;
+
+	salve->rx_pause = pause->rx_pause ? true : false;
+	salve->tx_pause = pause->tx_pause ? true : false;
+
+	phy_set_asym_pause(salve->phy, salve->rx_pause, salve->tx_pause);
+
+	return 0;
+}
+
+static void am65_cpsw_get_wol(struct net_device *ndev,
+			      struct ethtool_wolinfo *wol)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	wol->supported = 0;
+	wol->wolopts = 0;
+
+	if (salve->phy)
+		phy_ethtool_get_wol(salve->phy, wol);
+}
+
+static int am65_cpsw_set_wol(struct net_device *ndev,
+			     struct ethtool_wolinfo *wol)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy)
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_set_wol(salve->phy, wol);
+}
+
+static int am65_cpsw_get_link_ksettings(struct net_device *ndev,
+					struct ethtool_link_ksettings *ecmd)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy)
+		return -EOPNOTSUPP;
+
+	phy_ethtool_ksettings_get(salve->phy, ecmd);
+	return 0;
+}
+
+static int
+am65_cpsw_set_link_ksettings(struct net_device *ndev,
+			     const struct ethtool_link_ksettings *ecmd)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_ksettings_set(salve->phy, ecmd);
+}
+
+static int am65_cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_get_eee(salve->phy, edata);
+}
+
+static int am65_cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_set_eee(salve->phy, edata);
+}
+
+static int am65_cpsw_nway_reset(struct net_device *ndev)
+{
+	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
+
+	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
+		return -EOPNOTSUPP;
+
+	return phy_restart_aneg(salve->phy);
+}
+
+static int am65_cpsw_get_regs_len(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	u32 i, regdump_len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(am65_cpsw_regdump); i++) {
+		if (am65_cpsw_regdump[i].hdr.module_id ==
+		    AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL) {
+			regdump_len += sizeof(struct am65_cpsw_regdump_hdr);
+			regdump_len += common->ale->params.ale_entries *
+				       ALE_ENTRY_WORDS * sizeof(u32);
+			continue;
+		}
+		regdump_len += am65_cpsw_regdump[i].hdr.len;
+	}
+
+	return regdump_len;
+}
+
+static void am65_cpsw_get_regs(struct net_device *ndev,
+			       struct ethtool_regs *regs, void *p)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	u32 i, j, pos, *reg = p;
+
+	/* update CPSW IP version */
+	regs->version = AM65_CPSW_REGDUMP_VER;
+
+	pos = 0;
+	for (i = 0; i < ARRAY_SIZE(am65_cpsw_regdump); i++) {
+		reg[pos++] = am65_cpsw_regdump[i].hdr.module_id;
+
+		if (am65_cpsw_regdump[i].hdr.module_id ==
+		    AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL) {
+			u32 ale_tbl_len = common->ale->params.ale_entries *
+					  ALE_ENTRY_WORDS * sizeof(u32) +
+					  sizeof(struct am65_cpsw_regdump_hdr);
+			reg[pos++] = ale_tbl_len;
+			cpsw_ale_dump(common->ale, &reg[pos]);
+			pos += ale_tbl_len;
+			continue;
+		}
+
+		reg[pos++] = am65_cpsw_regdump[i].hdr.len;
+
+		j = am65_cpsw_regdump[i].start_ofs;
+		do {
+			reg[pos++] = j;
+			reg[pos++] = readl_relaxed(common->ss_base + j);
+			j += sizeof(u32);
+		} while (j <= am65_cpsw_regdump[i].end_ofs);
+	}
+}
+
+static int am65_cpsw_get_sset_count(struct net_device *ndev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return ARRAY_SIZE(am65_host_stats) +
+		       ARRAY_SIZE(am65_slave_stats);
+	case ETH_SS_PRIV_FLAGS:
+		return ARRAY_SIZE(am65_cpsw_ethtool_priv_flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void am65_cpsw_get_strings(struct net_device *ndev,
+				  u32 stringset, u8 *data)
+{
+	const struct am65_cpsw_ethtool_stat *hw_stats;
+	u32 i, num_stats;
+	u8 *p = data;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		num_stats = ARRAY_SIZE(am65_host_stats);
+		hw_stats = am65_host_stats;
+		for (i = 0; i < num_stats; i++) {
+			memcpy(p, hw_stats[i].desc, ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		num_stats = ARRAY_SIZE(am65_slave_stats);
+		hw_stats = am65_slave_stats;
+		for (i = 0; i < num_stats; i++) {
+			memcpy(p, hw_stats[i].desc, ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		num_stats = ARRAY_SIZE(am65_cpsw_ethtool_priv_flags);
+
+		for (i = 0; i < num_stats; i++) {
+			memcpy(p, am65_cpsw_ethtool_priv_flags[i],
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	}
+}
+
+static void am65_cpsw_get_ethtool_stats(struct net_device *ndev,
+					struct ethtool_stats *stats, u64 *data)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	const struct am65_cpsw_ethtool_stat *hw_stats;
+	struct am65_cpsw_host *host_p;
+	struct am65_cpsw_port *port;
+	u32 i, num_stats;
+
+	host_p = am65_common_get_host(common);
+	port = am65_ndev_to_port(ndev);
+	num_stats = ARRAY_SIZE(am65_host_stats);
+	hw_stats = am65_host_stats;
+	for (i = 0; i < num_stats; i++)
+		*data++ = readl_relaxed(host_p->stat_base +
+					hw_stats[i].offset);
+
+	num_stats = ARRAY_SIZE(am65_slave_stats);
+	hw_stats = am65_slave_stats;
+	for (i = 0; i < num_stats; i++)
+		*data++ = readl_relaxed(port->stat_base +
+					hw_stats[i].offset);
+}
+
+static u32 am65_cpsw_get_ethtool_priv_flags(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	u32 priv_flags = 0;
+
+	if (common->pf_p0_rx_ptype_rrobin)
+		priv_flags |= AM65_CPSW_PRIV_P0_RX_PTYPE_RROBIN;
+
+	return priv_flags;
+}
+
+static int am65_cpsw_set_ethtool_priv_flags(struct net_device *ndev, u32 flags)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+	common->pf_p0_rx_ptype_rrobin =
+			!!(flags & AM65_CPSW_PRIV_P0_RX_PTYPE_RROBIN);
+	am65_cpsw_nuss_set_p0_ptype(common);
+
+	return 0;
+}
+
+const struct ethtool_ops am65_cpsw_ethtool_ops_slave = {
+	.begin			= am65_cpsw_ethtool_op_begin,
+	.complete		= am65_cpsw_ethtool_op_complete,
+	.get_drvinfo		= am65_cpsw_get_drvinfo,
+	.get_msglevel		= am65_cpsw_get_msglevel,
+	.set_msglevel		= am65_cpsw_set_msglevel,
+	.get_channels		= am65_cpsw_get_channels,
+	.set_channels		= am65_cpsw_set_channels,
+	.get_ringparam		= am65_cpsw_get_ringparam,
+	.get_regs_len		= am65_cpsw_get_regs_len,
+	.get_regs		= am65_cpsw_get_regs,
+	.get_sset_count		= am65_cpsw_get_sset_count,
+	.get_strings		= am65_cpsw_get_strings,
+	.get_ethtool_stats	= am65_cpsw_get_ethtool_stats,
+	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_priv_flags		= am65_cpsw_get_ethtool_priv_flags,
+	.set_priv_flags		= am65_cpsw_set_ethtool_priv_flags,
+
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= am65_cpsw_get_link_ksettings,
+	.set_link_ksettings	= am65_cpsw_set_link_ksettings,
+	.get_pauseparam		= am65_cpsw_get_pauseparam,
+	.set_pauseparam		= am65_cpsw_set_pauseparam,
+	.get_wol		= am65_cpsw_get_wol,
+	.set_wol		= am65_cpsw_set_wol,
+	.get_eee		= am65_cpsw_get_eee,
+	.set_eee		= am65_cpsw_set_eee,
+	.nway_reset		= am65_cpsw_nway_reset,
+};
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
new file mode 100644
index 000000000000..97f7385c6741
--- /dev/null
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -0,0 +1,1965 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Texas Instruments K3 AM65 Ethernet Switch SubSystem Driver
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/kmemleak.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/of_device.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/dma/ti-cppi5.h>
+#include <linux/dma/k3-udma-glue.h>
+
+#include "cpsw_ale.h"
+#include "cpsw_sl.h"
+#include "am65-cpsw-nuss.h"
+#include "k3-cppi-desc-pool.h"
+
+#define AM65_CPSW_SS_BASE	0x0
+#define AM65_CPSW_SGMII_BASE	0x100
+#define AM65_CPSW_XGMII_BASE	0x2100
+#define AM65_CPSW_CPSW_NU_BASE	0x20000
+#define AM65_CPSW_NU_PORTS_BASE	0x1000
+#define AM65_CPSW_NU_STATS_BASE	0x1a000
+#define AM65_CPSW_NU_ALE_BASE	0x1e000
+#define AM65_CPSW_NU_CPTS_BASE	0x1d000
+
+#define AM65_CPSW_NU_PORTS_OFFSET	0x1000
+#define AM65_CPSW_NU_STATS_PORT_OFFSET	0x200
+
+#define AM65_CPSW_MAX_PORTS	8
+
+#define AM65_CPSW_MIN_PACKET_SIZE	VLAN_ETH_ZLEN
+#define AM65_CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
+
+#define AM65_CPSW_REG_CTL		0x004
+#define AM65_CPSW_REG_STAT_PORT_EN	0x014
+#define AM65_CPSW_REG_PTYPE		0x018
+
+#define AM65_CPSW_P0_REG_CTL			0x004
+#define AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET	0x008
+
+#define AM65_CPSW_PORT_REG_PRI_CTL		0x01c
+#define AM65_CPSW_PORT_REG_RX_PRI_MAP		0x020
+#define AM65_CPSW_PORT_REG_RX_MAXLEN		0x024
+
+#define AM65_CPSW_PORTN_REG_SA_L		0x308
+#define AM65_CPSW_PORTN_REG_SA_H		0x30c
+#define AM65_CPSW_PORTN_REG_TS_CTL              0x310
+#define AM65_CPSW_PORTN_REG_TS_SEQ_LTYPE_REG	0x314
+#define AM65_CPSW_PORTN_REG_TS_VLAN_LTYPE_REG	0x318
+#define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
+
+#define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
+#define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
+#define AM65_CPSW_CTL_P0_TX_CRC_REMOVE		BIT(13)
+#define AM65_CPSW_CTL_P0_RX_PAD			BIT(14)
+
+/* AM65_CPSW_P0_REG_CTL */
+#define AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN	BIT(0)
+
+/* AM65_CPSW_PORT_REG_PRI_CTL */
+#define AM65_CPSW_PORT_REG_PRI_CTL_RX_PTYPE_RROBIN	BIT(8)
+
+/* AM65_CPSW_PN_TS_CTL register fields */
+#define AM65_CPSW_PN_TS_CTL_TX_ANX_F_EN		BIT(4)
+#define AM65_CPSW_PN_TS_CTL_TX_VLAN_LT1_EN	BIT(5)
+#define AM65_CPSW_PN_TS_CTL_TX_VLAN_LT2_EN	BIT(6)
+#define AM65_CPSW_PN_TS_CTL_TX_ANX_D_EN		BIT(7)
+#define AM65_CPSW_PN_TS_CTL_TX_ANX_E_EN		BIT(10)
+#define AM65_CPSW_PN_TS_CTL_TX_HOST_TS_EN	BIT(11)
+#define AM65_CPSW_PN_TS_CTL_MSG_TYPE_EN_SHIFT	16
+
+/* AM65_CPSW_PORTN_REG_TS_SEQ_LTYPE_REG register fields */
+#define AM65_CPSW_PN_TS_SEQ_ID_OFFSET_SHIFT	16
+
+/* AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2 */
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_107	BIT(16)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_129	BIT(17)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_130	BIT(18)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_131	BIT(19)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_132	BIT(20)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319	BIT(21)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320	BIT(22)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO BIT(23)
+
+/* The PTP event messages - Sync, Delay_Req, Pdelay_Req, and Pdelay_Resp. */
+#define AM65_CPSW_TS_EVENT_MSG_TYPE_BITS (BIT(0) | BIT(1) | BIT(2) | BIT(3))
+
+#define AM65_CPSW_TS_SEQ_ID_OFFSET (0x1e)
+
+#define AM65_CPSW_TS_TX_ANX_ALL_EN		\
+	(AM65_CPSW_PN_TS_CTL_TX_ANX_D_EN |	\
+	 AM65_CPSW_PN_TS_CTL_TX_ANX_E_EN |	\
+	 AM65_CPSW_PN_TS_CTL_TX_ANX_F_EN)
+
+#define AM65_CPSW_ALE_AGEOUT_DEFAULT	30
+/* Number of TX/RX descriptors */
+#define AM65_CPSW_MAX_TX_DESC	500
+#define AM65_CPSW_MAX_RX_DESC	500
+
+#define AM65_CPSW_NAV_PS_DATA_SIZE 16
+#define AM65_CPSW_NAV_SW_DATA_SIZE 16
+
+#define AM65_CPSW_DEBUG	(NETIF_MSG_HW | NETIF_MSG_DRV | NETIF_MSG_LINK | \
+			 NETIF_MSG_IFUP	| NETIF_MSG_PROBE | NETIF_MSG_IFDOWN | \
+			 NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
+
+static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
+				      const u8 *dev_addr)
+{
+	u32 mac_hi = (dev_addr[0] << 0) | (dev_addr[1] << 8) |
+		     (dev_addr[2] << 16) | (dev_addr[3] << 24);
+	u32 mac_lo = (dev_addr[4] << 0) | (dev_addr[5] << 8);
+
+	writel(mac_hi, slave->port_base + AM65_CPSW_PORTN_REG_SA_H);
+	writel(mac_lo, slave->port_base + AM65_CPSW_PORTN_REG_SA_L);
+}
+
+static void am65_cpsw_sl_ctl_reset(struct am65_cpsw_port *port)
+{
+	cpsw_sl_reset(port->slave.mac_sl, 100);
+	/* Max length register has to be restored after MAC SL reset */
+	writel(AM65_CPSW_MAX_PACKET_SIZE,
+	       port->port_base + AM65_CPSW_PORT_REG_RX_MAXLEN);
+}
+
+static void am65_cpsw_nuss_get_ver(struct am65_cpsw_common *common)
+{
+	common->nuss_ver = readl(common->ss_base);
+	common->cpsw_ver = readl(common->cpsw_base);
+	dev_info(common->dev,
+		 "initializing am65 cpsw nuss version 0x%08X, cpsw version 0x%08X Ports: %u\n",
+		common->nuss_ver,
+		common->cpsw_ver,
+		common->port_num + 1);
+}
+
+void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	struct phy_device *phy = port->slave.phy;
+	u32 mac_control = 0;
+
+	if (!phy)
+		return;
+
+	if (phy->link) {
+		mac_control = CPSW_SL_CTL_GMII_EN;
+
+		if (phy->speed == 1000)
+			mac_control |= CPSW_SL_CTL_GIG;
+		if (phy->speed == 10 && phy_interface_is_rgmii(phy))
+			/* Can be used with in band mode only */
+			mac_control |= CPSW_SL_CTL_EXT_EN;
+		if (phy->duplex)
+			mac_control |= CPSW_SL_CTL_FULLDUPLEX;
+
+		/* RGMII speed is 100M if !CPSW_SL_CTL_GIG*/
+
+		/* rx_pause/tx_pause */
+		if (port->slave.rx_pause)
+			mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
+
+		if (port->slave.tx_pause)
+			mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
+
+		cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
+
+		/* enable forwarding */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
+
+		netif_tx_wake_all_queues(ndev);
+	} else {
+		int tmo;
+		/* disable forwarding */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
+
+		cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
+
+		tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
+		dev_dbg(common->dev, "donw msc_sl %08x tmo %d\n",
+			cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS),
+			tmo);
+
+		cpsw_sl_ctl_reset(port->slave.mac_sl);
+
+		netif_tx_stop_all_queues(ndev);
+	}
+
+	phy_print_status(phy);
+}
+
+static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
+					    __be16 proto, u16 vid)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	u32 port_mask, unreg_mcast = 0;
+	int ret;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(common->dev);
+		return ret;
+	}
+
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
+	if (!vid)
+		unreg_mcast = port_mask;
+	dev_info(common->dev, "Adding vlan %d to vlan filter\n", vid);
+	ret = cpsw_ale_add_vlan(common->ale, vid, port_mask,
+				unreg_mcast, port_mask, 0);
+
+	pm_runtime_put(common->dev);
+	return ret;
+}
+
+static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
+					     __be16 proto, u16 vid)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	int ret;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(common->dev);
+		return ret;
+	}
+
+	dev_info(common->dev, "Removing vlan %d from vlan filter\n", vid);
+	ret = cpsw_ale_del_vlan(common->ale, vid, 0);
+
+	pm_runtime_put(common->dev);
+	return ret;
+}
+
+static void am65_cpsw_slave_set_promisc_2g(struct am65_cpsw_port *port,
+					   bool promisc)
+{
+	struct am65_cpsw_common *common = port->common;
+
+	if (promisc) {
+		/* Enable promiscuous mode */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_MACONLY_CAF, 1);
+		dev_dbg(common->dev, "promisc enabled\n");
+	} else {
+		/* Disable promiscuous mode */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_MACONLY_CAF, 0);
+		dev_dbg(common->dev, "promisc disabled\n");
+	}
+}
+
+static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	u32 port_mask;
+	bool promisc;
+
+	promisc = !!(ndev->flags & IFF_PROMISC);
+	am65_cpsw_slave_set_promisc_2g(port, promisc);
+
+	if (promisc)
+		return;
+
+	/* Restore allmulti on vlans if necessary */
+	cpsw_ale_set_allmulti(common->ale,
+			      ndev->flags & IFF_ALLMULTI, port->port_id);
+
+	port_mask = ALE_PORT_HOST;
+	/* Clear all mcast from ALE */
+	cpsw_ale_flush_multicast(common->ale, port_mask, -1);
+
+	if (!netdev_mc_empty(ndev)) {
+		struct netdev_hw_addr *ha;
+
+		/* program multicast address list into ALE register */
+		netdev_for_each_mc_addr(ha, ndev) {
+			cpsw_ale_add_mcast(common->ale, ha->addr,
+					   port_mask, 0, 0, 0);
+		}
+	}
+}
+
+static void am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,
+					       unsigned int txqueue)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_tx_chn *tx_chn;
+	struct netdev_queue *netif_txq;
+	unsigned long trans_start;
+
+	netif_txq = netdev_get_tx_queue(ndev, txqueue);
+	tx_chn = &common->tx_chns[txqueue];
+	trans_start = netif_txq->trans_start;
+
+	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u dql_avail:%d free_desc:%zu\n",
+		   txqueue,
+		   netif_tx_queue_stopped(netif_txq),
+		   jiffies_to_msecs(jiffies - trans_start),
+		   dql_avail(&netif_txq->dql),
+		   k3_cppi_desc_pool_avail(tx_chn->desc_pool));
+
+	if (netif_tx_queue_stopped(netif_txq)) {
+		/* try recover if stopped by us */
+		txq_trans_update(netif_txq);
+		netif_tx_wake_queue(netif_txq);
+	}
+}
+
+static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
+				  struct sk_buff *skb)
+{
+	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
+	struct cppi5_host_desc_t *desc_rx;
+	struct device *dev = common->dev;
+	u32 pkt_len = skb_tailroom(skb);
+	dma_addr_t desc_dma;
+	dma_addr_t buf_dma;
+	void *swdata;
+
+	desc_rx = k3_cppi_desc_pool_alloc(rx_chn->desc_pool);
+	if (!desc_rx) {
+		dev_err(dev, "Failed to allocate RXFDQ descriptor\n");
+		return -ENOMEM;
+	}
+	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
+
+	buf_dma = dma_map_single(dev, skb->data, pkt_len, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+		dev_err(dev, "Failed to map rx skb buffer\n");
+		return -EINVAL;
+	}
+
+	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
+			 AM65_CPSW_NAV_PS_DATA_SIZE);
+	cppi5_hdesc_attach_buf(desc_rx, 0, 0, buf_dma, skb_tailroom(skb));
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	*((void **)swdata) = skb;
+
+	return k3_udma_glue_push_rx_chn(rx_chn->rx_chn, 0, desc_rx, desc_dma);
+}
+
+void am65_cpsw_nuss_set_p0_ptype(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
+	u32 val, pri_map;
+
+	/* P0 set Receive Priority Type */
+	val = readl(host_p->port_base + AM65_CPSW_PORT_REG_PRI_CTL);
+
+	if (common->pf_p0_rx_ptype_rrobin) {
+		val |= AM65_CPSW_PORT_REG_PRI_CTL_RX_PTYPE_RROBIN;
+		/* Enet Ports fifos works in fixed priority mode only, so
+		 * reset P0_Rx_Pri_Map so all packet will go in Enet fifo 0
+		 */
+		pri_map = 0x0;
+	} else {
+		val &= ~AM65_CPSW_PORT_REG_PRI_CTL_RX_PTYPE_RROBIN;
+		/* restore P0_Rx_Pri_Map */
+		pri_map = 0x76543210;
+	}
+
+	writel(pri_map, host_p->port_base + AM65_CPSW_PORT_REG_RX_PRI_MAP);
+	writel(val, host_p->port_base + AM65_CPSW_PORT_REG_PRI_CTL);
+}
+
+static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
+				      netdev_features_t features)
+{
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
+	int port_idx, i, ret;
+	struct sk_buff *skb;
+	u32 val, port_mask;
+
+	if (common->usage_count)
+		return 0;
+
+	/* Control register */
+	writel(AM65_CPSW_CTL_P0_ENABLE | AM65_CPSW_CTL_P0_TX_CRC_REMOVE |
+	       AM65_CPSW_CTL_VLAN_AWARE | AM65_CPSW_CTL_P0_RX_PAD,
+	       common->cpsw_base + AM65_CPSW_REG_CTL);
+	/* Max length register */
+	writel(AM65_CPSW_MAX_PACKET_SIZE,
+	       host_p->port_base + AM65_CPSW_PORT_REG_RX_MAXLEN);
+	/* set base flow_id */
+	writel(common->rx_flow_id_base,
+	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
+	/* en tx crc offload */
+	if (features & NETIF_F_HW_CSUM)
+		writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
+		       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+
+	am65_cpsw_nuss_set_p0_ptype(common);
+
+	/* enable statistic */
+	val = BIT(HOST_PORT_NUM);
+	for (port_idx = 0; port_idx < common->port_num; port_idx++) {
+		struct am65_cpsw_port *port = &common->ports[port_idx];
+
+		if (!port->disabled)
+			val |=  BIT(port->port_id);
+	}
+	writel(val, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
+
+	/* disable priority elevation */
+	writel(0, common->cpsw_base + AM65_CPSW_REG_PTYPE);
+
+	cpsw_ale_start(common->ale);
+
+	/* limit to one RX flow only */
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
+			     ALE_DEFAULT_THREAD_ID, 0);
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
+			     ALE_DEFAULT_THREAD_ENABLE, 1);
+	if (AM65_CPSW_IS_CPSW2G(common))
+		cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
+				     ALE_PORT_NOLEARN, 1);
+	/* switch to vlan unaware mode */
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_VLAN_AWARE, 1);
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
+			     ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
+
+	/* default vlan cfg: create mask based on enabled ports */
+	port_mask = GENMASK(common->port_num, 0) &
+		    ~common->disabled_ports_mask;
+
+	cpsw_ale_add_vlan(common->ale, 0, port_mask,
+			  port_mask, port_mask,
+			  port_mask & ~ALE_PORT_HOST);
+
+	for (i = 0; i < common->rx_chns.descs_num; i++) {
+		skb = __netdev_alloc_skb_ip_align(NULL,
+						  AM65_CPSW_MAX_PACKET_SIZE,
+						  GFP_KERNEL);
+		if (!skb) {
+			dev_err(common->dev, "cannot allocate skb\n");
+			return -ENOMEM;
+		}
+
+		ret = am65_cpsw_nuss_rx_push(common, skb);
+		if (ret < 0) {
+			dev_err(common->dev,
+				"cannot submit skb to channel rx, error %d\n",
+				ret);
+			kfree_skb(skb);
+			return ret;
+		}
+		kmemleak_not_leak(skb);
+	}
+	k3_udma_glue_enable_rx_chn(common->rx_chns.rx_chn);
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		ret = k3_udma_glue_enable_tx_chn(common->tx_chns[i].tx_chn);
+		if (ret)
+			return ret;
+		napi_enable(&common->tx_chns[i].napi_tx);
+	}
+
+	napi_enable(&common->napi_rx);
+
+	dev_dbg(common->dev, "cpsw_nuss started\n");
+	return 0;
+}
+
+static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma);
+static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma);
+
+static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
+{
+	int i;
+
+	if (common->usage_count != 1)
+		return 0;
+
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
+			     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
+
+	/* shutdown tx channels */
+	atomic_set(&common->tdown_cnt, common->tx_ch_num);
+	/* ensure new tdown_cnt value is visible */
+	smp_mb__after_atomic();
+	reinit_completion(&common->tdown_complete);
+
+	for (i = 0; i < common->tx_ch_num; i++)
+		k3_udma_glue_tdown_tx_chn(common->tx_chns[i].tx_chn, false);
+
+	i = wait_for_completion_timeout(&common->tdown_complete,
+					msecs_to_jiffies(1000));
+	if (!i)
+		dev_err(common->dev, "tx timeout\n");
+	for (i = 0; i < common->tx_ch_num; i++)
+		napi_disable(&common->tx_chns[i].napi_tx);
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		k3_udma_glue_reset_tx_chn(common->tx_chns[i].tx_chn,
+					  &common->tx_chns[i],
+					  am65_cpsw_nuss_tx_cleanup);
+		k3_udma_glue_disable_tx_chn(common->tx_chns[i].tx_chn);
+	}
+
+	k3_udma_glue_tdown_rx_chn(common->rx_chns.rx_chn, true);
+	napi_disable(&common->napi_rx);
+
+	for (i = 0; i < AM65_CPSW_MAX_RX_FLOWS; i++)
+		k3_udma_glue_reset_rx_chn(common->rx_chns.rx_chn, i,
+					  &common->rx_chns,
+					  am65_cpsw_nuss_rx_cleanup, !!i);
+
+	k3_udma_glue_disable_rx_chn(common->rx_chns.rx_chn);
+
+	cpsw_ale_stop(common->ale);
+
+	writel(0, common->cpsw_base + AM65_CPSW_REG_CTL);
+	writel(0, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
+
+	dev_dbg(common->dev, "cpsw_nuss stopped\n");
+	return 0;
+}
+
+static int am65_cpsw_nuss_ndo_slave_stop(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	int ret;
+
+	if (port->slave.phy)
+		phy_stop(port->slave.phy);
+
+	netif_tx_stop_all_queues(ndev);
+
+	if (port->slave.phy) {
+		phy_disconnect(port->slave.phy);
+		port->slave.phy = NULL;
+	}
+
+	ret = am65_cpsw_nuss_common_stop(common);
+	if (ret)
+		return ret;
+
+	common->usage_count--;
+	pm_runtime_put(common->dev);
+	return 0;
+}
+
+static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	u32 port_mask;
+	int ret, i;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(common->dev);
+		return ret;
+	}
+
+	/* Notify the stack of the actual queue counts. */
+	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
+	if (ret) {
+		dev_err(common->dev, "cannot set real number of tx queues\n");
+		return ret;
+	}
+
+	ret = netif_set_real_num_rx_queues(ndev, AM65_CPSW_MAX_RX_QUEUES);
+	if (ret) {
+		dev_err(common->dev, "cannot set real number of rx queues\n");
+		return ret;
+	}
+
+	for (i = 0; i < common->tx_ch_num; i++)
+		netdev_tx_reset_queue(netdev_get_tx_queue(ndev, i));
+
+	ret = am65_cpsw_nuss_common_open(common, ndev->features);
+	if (ret)
+		return ret;
+
+	common->usage_count++;
+
+	am65_cpsw_port_set_sl_mac(port, ndev->dev_addr);
+
+	if (port->slave.mac_only)
+		/* enable mac-only mode on port */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_MACONLY, 1);
+	if (AM65_CPSW_IS_CPSW2G(common))
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_NOLEARN, 1);
+
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
+	cpsw_ale_add_ucast(common->ale, ndev->dev_addr,
+			   HOST_PORT_NUM, ALE_SECURE, 0);
+	cpsw_ale_add_mcast(common->ale, ndev->broadcast,
+			   port_mask, 0, 0, ALE_MCAST_FWD_2);
+
+	/* mac_sl should be configured via phy-link interface */
+	am65_cpsw_sl_ctl_reset(port);
+
+	ret = phy_set_mode_ext(port->slave.ifphy, PHY_MODE_ETHERNET,
+			       port->slave.phy_if);
+	if (ret)
+		goto error_cleanup;
+
+	if (port->slave.phy_node) {
+		port->slave.phy = of_phy_connect(ndev,
+						 port->slave.phy_node,
+						 &am65_cpsw_nuss_adjust_link,
+						 0, port->slave.phy_if);
+		if (!port->slave.phy) {
+			dev_err(common->dev, "phy %pOF not found on slave %d\n",
+				port->slave.phy_node,
+				port->port_id);
+			ret = -ENODEV;
+			goto error_cleanup;
+		}
+	}
+
+	phy_attached_info(port->slave.phy);
+	phy_start(port->slave.phy);
+
+	return 0;
+
+error_cleanup:
+	am65_cpsw_nuss_ndo_slave_stop(ndev);
+	return ret;
+}
+
+static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
+{
+	struct am65_cpsw_rx_chn *rx_chn = data;
+	struct cppi5_host_desc_t *desc_rx;
+	struct sk_buff *skb;
+	dma_addr_t buf_dma;
+	u32 buf_dma_len;
+	void **swdata;
+
+	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	skb = *swdata;
+	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+
+	dma_unmap_single(rx_chn->dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+
+	dev_kfree_skb_any(skb);
+}
+
+/* RX psdata[2] word format - checksum information */
+#define AM65_CPSW_RX_PSD_CSUM_ADD	GENMASK(15, 0)
+#define AM65_CPSW_RX_PSD_CSUM_ERR	BIT(16)
+#define AM65_CPSW_RX_PSD_IS_FRAGMENT	BIT(17)
+#define AM65_CPSW_RX_PSD_IS_TCP		BIT(18)
+#define AM65_CPSW_RX_PSD_IPV6_VALID	BIT(19)
+#define AM65_CPSW_RX_PSD_IPV4_VALID	BIT(20)
+
+static void am65_cpsw_nuss_rx_csum(struct sk_buff *skb, u32 csum_info)
+{
+	/* HW can verify IPv4/IPv6 TCP/UDP packets checksum
+	 * csum information provides in psdata[2] word:
+	 * AM65_CPSW_RX_PSD_CSUM_ERR bit - indicates csum error
+	 * AM65_CPSW_RX_PSD_IPV6_VALID and AM65_CPSW_RX_PSD_IPV4_VALID
+	 * bits - indicates IPv4/IPv6 packet
+	 * AM65_CPSW_RX_PSD_IS_FRAGMENT bit - indicates fragmented packet
+	 * AM65_CPSW_RX_PSD_CSUM_ADD has value 0xFFFF for non fragmented packets
+	 * or csum value for fragmented packets if !AM65_CPSW_RX_PSD_CSUM_ERR
+	 */
+	skb_checksum_none_assert(skb);
+
+	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM)))
+		return;
+
+	if ((csum_info & (AM65_CPSW_RX_PSD_IPV6_VALID |
+			  AM65_CPSW_RX_PSD_IPV4_VALID)) &&
+			  !(csum_info & AM65_CPSW_RX_PSD_CSUM_ERR)) {
+		/* csum for fragmented packets is unsupported */
+		if (!(csum_info & AM65_CPSW_RX_PSD_IS_FRAGMENT))
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+}
+
+static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
+				     u32 flow_idx)
+{
+	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
+	u32 buf_dma_len, pkt_len, port_id = 0, csum_info;
+	struct am65_cpsw_ndev_priv *ndev_priv;
+	struct am65_cpsw_ndev_stats *stats;
+	struct cppi5_host_desc_t *desc_rx;
+	struct device *dev = common->dev;
+	struct sk_buff *skb, *new_skb;
+	dma_addr_t desc_dma, buf_dma;
+	struct am65_cpsw_port *port;
+	struct net_device *ndev;
+	void **swdata;
+	u32 *psdata;
+	int ret = 0;
+
+	ret = k3_udma_glue_pop_rx_chn(rx_chn->rx_chn, flow_idx, &desc_dma);
+	if (ret) {
+		if (ret != -ENODATA)
+			dev_err(dev, "RX: pop chn fail %d\n", ret);
+		return ret;
+	}
+
+	if (desc_dma & 0x1) {
+		dev_dbg(dev, "%s RX tdown flow: %u\n", __func__, flow_idx);
+		return 0;
+	}
+
+	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
+	dev_dbg(dev, "%s flow_idx: %u desc %pad\n",
+		__func__, flow_idx, &desc_dma);
+
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	skb = *swdata;
+	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
+	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
+	dev_dbg(dev, "%s rx port_id:%d\n", __func__, port_id);
+	port = am65_common_get_port(common, port_id);
+	ndev = port->ndev;
+	skb->dev = ndev;
+
+	psdata = cppi5_hdesc_get_psdata(desc_rx);
+	csum_info = psdata[2];
+	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
+
+	dma_unmap_single(dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
+
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+
+	new_skb = netdev_alloc_skb_ip_align(ndev, AM65_CPSW_MAX_PACKET_SIZE);
+	if (new_skb) {
+		skb_put(skb, pkt_len);
+		skb->protocol = eth_type_trans(skb, ndev);
+		am65_cpsw_nuss_rx_csum(skb, csum_info);
+		napi_gro_receive(&common->napi_rx, skb);
+
+		ndev_priv = netdev_priv(ndev);
+		stats = this_cpu_ptr(ndev_priv->stats);
+
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_packets++;
+		stats->rx_bytes += pkt_len;
+		u64_stats_update_end(&stats->syncp);
+		kmemleak_not_leak(new_skb);
+	} else {
+		ndev->stats.rx_dropped++;
+		new_skb = skb;
+	}
+
+	if (netif_dormant(ndev)) {
+		dev_kfree_skb_any(new_skb);
+		ndev->stats.rx_dropped++;
+		return 0;
+	}
+
+	ret = am65_cpsw_nuss_rx_push(common, new_skb);
+	if (WARN_ON(ret < 0)) {
+		dev_kfree_skb_any(new_skb);
+		ndev->stats.rx_errors++;
+		ndev->stats.rx_dropped++;
+	}
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_rx_poll(struct napi_struct *napi_rx, int budget)
+{
+	struct am65_cpsw_common *common = am65_cpsw_napi_to_common(napi_rx);
+	int flow = AM65_CPSW_MAX_RX_FLOWS;
+	int cur_budget, ret;
+	int num_rx = 0;
+
+	/* process every flow */
+	while (flow--) {
+		cur_budget = budget - num_rx;
+
+		while (cur_budget--) {
+			ret = am65_cpsw_nuss_rx_packets(common, flow);
+			if (ret)
+				break;
+			num_rx++;
+		}
+
+		if (num_rx >= budget)
+			break;
+	}
+
+	dev_dbg(common->dev, "%s num_rx:%d %d\n", __func__, num_rx, budget);
+
+	if (num_rx < budget && napi_complete_done(napi_rx, num_rx))
+		enable_irq(common->rx_chns.irq);
+
+	return num_rx;
+}
+
+static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
+				     struct device *dev,
+				     struct cppi5_host_desc_t *desc)
+{
+	struct cppi5_host_desc_t *first_desc, *next_desc;
+	dma_addr_t buf_dma, next_desc_dma;
+	u32 buf_dma_len;
+
+	first_desc = desc;
+	next_desc = first_desc;
+
+	cppi5_hdesc_get_obuf(first_desc, &buf_dma, &buf_dma_len);
+
+	dma_unmap_single(dev, buf_dma, buf_dma_len,
+			 DMA_TO_DEVICE);
+
+	next_desc_dma = cppi5_hdesc_get_next_hbdesc(first_desc);
+	while (next_desc_dma) {
+		next_desc = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
+						       next_desc_dma);
+		cppi5_hdesc_get_obuf(next_desc, &buf_dma, &buf_dma_len);
+
+		dma_unmap_page(dev, buf_dma, buf_dma_len,
+			       DMA_TO_DEVICE);
+
+		next_desc_dma = cppi5_hdesc_get_next_hbdesc(next_desc);
+
+		k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
+	}
+
+	k3_cppi_desc_pool_free(tx_chn->desc_pool, first_desc);
+}
+
+static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma)
+{
+	struct am65_cpsw_tx_chn *tx_chn = data;
+	struct cppi5_host_desc_t *desc_tx;
+	struct sk_buff *skb;
+	void **swdata;
+
+	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool, desc_dma);
+	swdata = cppi5_hdesc_get_swdata(desc_tx);
+	skb = *(swdata);
+	am65_cpsw_nuss_xmit_free(tx_chn, tx_chn->common->dev, desc_tx);
+
+	dev_kfree_skb_any(skb);
+}
+
+static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
+					   int chn, unsigned int budget)
+{
+	struct cppi5_host_desc_t *desc_tx;
+	struct device *dev = common->dev;
+	struct am65_cpsw_tx_chn *tx_chn;
+	struct netdev_queue *netif_txq;
+	unsigned int total_bytes = 0;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	dma_addr_t desc_dma;
+	int res, num_tx = 0;
+	void **swdata;
+
+	tx_chn = &common->tx_chns[chn];
+
+	while (true) {
+		struct am65_cpsw_ndev_priv *ndev_priv;
+		struct am65_cpsw_ndev_stats *stats;
+
+		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
+		if (res == -ENODATA)
+			break;
+
+		if (desc_dma & 0x1) {
+			if (atomic_dec_and_test(&common->tdown_cnt))
+				complete(&common->tdown_complete);
+			break;
+		}
+
+		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
+						     desc_dma);
+		swdata = cppi5_hdesc_get_swdata(desc_tx);
+		skb = *(swdata);
+		am65_cpsw_nuss_xmit_free(tx_chn, dev, desc_tx);
+
+		ndev = skb->dev;
+
+		ndev_priv = netdev_priv(ndev);
+		stats = this_cpu_ptr(ndev_priv->stats);
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_packets++;
+		stats->tx_bytes += skb->len;
+		u64_stats_update_end(&stats->syncp);
+
+		total_bytes += skb->len;
+		napi_consume_skb(skb, budget);
+		num_tx++;
+	}
+
+	if (!num_tx)
+		return 0;
+
+	netif_txq = netdev_get_tx_queue(ndev, chn);
+
+	netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
+
+	if (netif_tx_queue_stopped(netif_txq)) {
+		/* Check whether the queue is stopped due to stalled tx dma,
+		 * if the queue is stopped then wake the queue as
+		 * we have free desc for tx
+		 */
+		__netif_tx_lock(netif_txq, smp_processor_id());
+		if (netif_running(ndev) &&
+		    (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
+		     MAX_SKB_FRAGS))
+			netif_tx_wake_queue(netif_txq);
+
+		__netif_tx_unlock(netif_txq);
+	}
+	dev_dbg(dev, "%s:%u pkt:%d\n", __func__, chn, num_tx);
+
+	return num_tx;
+}
+
+static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
+{
+	struct am65_cpsw_tx_chn *tx_chn = am65_cpsw_napi_to_tx_chn(napi_tx);
+	int num_tx;
+
+	num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id,
+						 budget);
+	num_tx = min(num_tx, budget);
+	if (num_tx < budget) {
+		napi_complete(napi_tx);
+		enable_irq(tx_chn->irq);
+	}
+
+	return num_tx;
+}
+
+static irqreturn_t am65_cpsw_nuss_rx_irq(int irq, void *dev_id)
+{
+	struct am65_cpsw_common *common = dev_id;
+
+	disable_irq_nosync(irq);
+	napi_schedule(&common->napi_rx);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t am65_cpsw_nuss_tx_irq(int irq, void *dev_id)
+{
+	struct am65_cpsw_tx_chn *tx_chn = dev_id;
+
+	disable_irq_nosync(irq);
+	napi_schedule(&tx_chn->napi_tx);
+
+	return IRQ_HANDLED;
+}
+
+static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
+						 struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct cppi5_host_desc_t *first_desc, *next_desc, *cur_desc;
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	struct device *dev = common->dev;
+	struct am65_cpsw_tx_chn *tx_chn;
+	struct netdev_queue *netif_txq;
+	dma_addr_t desc_dma, buf_dma;
+	int ret, q_idx, i;
+	void **swdata;
+	u32 *psdata;
+	u32 pkt_len;
+
+	/* padding enabled in hw */
+	pkt_len = skb_headlen(skb);
+
+	q_idx = skb_get_queue_mapping(skb);
+	dev_dbg(dev, "%s skb_queue:%d\n", __func__, q_idx);
+
+	tx_chn = &common->tx_chns[q_idx];
+	netif_txq = netdev_get_tx_queue(ndev, q_idx);
+
+	/* Map the linear buffer */
+	buf_dma = dma_map_single(dev, skb->data, pkt_len,
+				 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+		dev_err(dev, "Failed to map tx skb buffer\n");
+		ndev->stats.tx_errors++;
+		goto err_free_skb;
+	}
+
+	first_desc = k3_cppi_desc_pool_alloc(tx_chn->desc_pool);
+	if (!first_desc) {
+		dev_dbg(dev, "Failed to allocate descriptor\n");
+		dma_unmap_single(dev, buf_dma, pkt_len, DMA_TO_DEVICE);
+		goto busy_stop_q;
+	}
+
+	cppi5_hdesc_init(first_desc, CPPI5_INFO0_HDESC_EPIB_PRESENT,
+			 AM65_CPSW_NAV_PS_DATA_SIZE);
+	cppi5_desc_set_pktids(&first_desc->hdr, 0, 0x3FFF);
+	cppi5_hdesc_set_pkttype(first_desc, 0x7);
+	cppi5_desc_set_tags_ids(&first_desc->hdr, 0, port->port_id);
+
+	cppi5_hdesc_attach_buf(first_desc, buf_dma, pkt_len, buf_dma, pkt_len);
+	swdata = cppi5_hdesc_get_swdata(first_desc);
+	*(swdata) = skb;
+	psdata = cppi5_hdesc_get_psdata(first_desc);
+
+	/* HW csum offload if enabled */
+	psdata[2] = 0;
+	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		unsigned int cs_start, cs_offset;
+
+		cs_start = skb_transport_offset(skb);
+		cs_offset = cs_start + skb->csum_offset;
+		/* HW numerates bytes starting from 1 */
+		psdata[2] = ((cs_offset + 1) << 24) |
+			    ((cs_start + 1) << 16) | (skb->len - cs_start);
+		dev_dbg(dev, "%s tx psdata:%#x\n", __func__, psdata[2]);
+	}
+
+	if (!skb_is_nonlinear(skb))
+		goto done_tx;
+
+	dev_dbg(dev, "fragmented SKB\n");
+
+	/* Handle the case where skb is fragmented in pages */
+	cur_desc = first_desc;
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		u32 frag_size = skb_frag_size(frag);
+
+		next_desc = k3_cppi_desc_pool_alloc(tx_chn->desc_pool);
+		if (!next_desc) {
+			dev_err(dev, "Failed to allocate descriptor\n");
+			goto busy_free_descs;
+		}
+
+		buf_dma = skb_frag_dma_map(dev, frag, 0, frag_size,
+					   DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, buf_dma))) {
+			dev_err(dev, "Failed to map tx skb page\n");
+			k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
+			ndev->stats.tx_errors++;
+			goto err_free_descs;
+		}
+
+		cppi5_hdesc_reset_hbdesc(next_desc);
+		cppi5_hdesc_attach_buf(next_desc,
+				       buf_dma, frag_size, buf_dma, frag_size);
+
+		desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool,
+						      next_desc);
+		cppi5_hdesc_link_hbdesc(cur_desc, desc_dma);
+
+		pkt_len += frag_size;
+		cur_desc = next_desc;
+	}
+	WARN_ON(pkt_len != skb->len);
+
+done_tx:
+	skb_tx_timestamp(skb);
+
+	/* report bql before sending packet */
+	netdev_tx_sent_queue(netif_txq, pkt_len);
+
+	cppi5_hdesc_set_pktlen(first_desc, pkt_len);
+	desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool, first_desc);
+	ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+	if (ret) {
+		dev_err(dev, "can't push desc %d\n", ret);
+		/* inform bql */
+		netdev_tx_completed_queue(netif_txq, 1, pkt_len);
+		ndev->stats.tx_errors++;
+		goto err_free_descs;
+	}
+
+	if (k3_cppi_desc_pool_avail(tx_chn->desc_pool) < MAX_SKB_FRAGS) {
+		netif_tx_stop_queue(netif_txq);
+		/* Barrier, so that stop_queue visible to other cpus */
+		smp_mb__after_atomic();
+		dev_dbg(dev, "netif_tx_stop_queue %d\n", q_idx);
+
+		/* re-check for smp */
+		if (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
+		    MAX_SKB_FRAGS) {
+			netif_tx_wake_queue(netif_txq);
+			dev_dbg(dev, "netif_tx_wake_queue %d\n", q_idx);
+		}
+	}
+
+	return NETDEV_TX_OK;
+
+err_free_descs:
+	am65_cpsw_nuss_xmit_free(tx_chn, dev, first_desc);
+err_free_skb:
+	ndev->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+
+busy_free_descs:
+	am65_cpsw_nuss_xmit_free(tx_chn, dev, first_desc);
+busy_stop_q:
+	netif_tx_stop_queue(netif_txq);
+	return NETDEV_TX_BUSY;
+}
+
+static int am65_cpsw_nuss_ndo_slave_set_mac_address(struct net_device *ndev,
+						    void *addr)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	struct sockaddr *sockaddr = (struct sockaddr *)addr;
+	int ret;
+
+	ret = eth_prepare_mac_addr_change(ndev, addr);
+	if (ret < 0)
+		return ret;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(common->dev);
+		return ret;
+	}
+
+	cpsw_ale_del_ucast(common->ale, ndev->dev_addr,
+			   HOST_PORT_NUM, 0, 0);
+	cpsw_ale_add_ucast(common->ale, sockaddr->sa_data,
+			   HOST_PORT_NUM, ALE_SECURE, 0);
+
+	am65_cpsw_port_set_sl_mac(port, addr);
+	eth_commit_mac_addr_change(ndev, sockaddr);
+
+	pm_runtime_put(common->dev);
+
+	return 0;
+}
+
+static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
+					  struct ifreq *req, int cmd)
+{
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+
+	if (!netif_running(ndev))
+		return -EINVAL;
+
+	if (!port->slave.phy)
+		return -EOPNOTSUPP;
+
+	return phy_mii_ioctl(port->slave.phy, req, cmd);
+}
+
+static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
+					 struct rtnl_link_stats64 *stats)
+{
+	struct am65_cpsw_ndev_priv *ndev_priv = netdev_priv(dev);
+	unsigned int start;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct am65_cpsw_ndev_stats *cpu_stats;
+		u64 rx_packets;
+		u64 rx_bytes;
+		u64 tx_packets;
+		u64 tx_bytes;
+
+		cpu_stats = per_cpu_ptr(ndev_priv->stats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			rx_packets = cpu_stats->rx_packets;
+			rx_bytes   = cpu_stats->rx_bytes;
+			tx_packets = cpu_stats->tx_packets;
+			tx_bytes   = cpu_stats->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes   += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes   += tx_bytes;
+	}
+
+	stats->rx_errors	= dev->stats.rx_errors;
+	stats->rx_dropped	= dev->stats.rx_dropped;
+	stats->tx_dropped	= dev->stats.tx_dropped;
+}
+
+static int am65_cpsw_nuss_ndo_slave_set_features(struct net_device *ndev,
+						 netdev_features_t features)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	netdev_features_t changes = features ^ ndev->features;
+	struct am65_cpsw_host *host_p;
+
+	host_p = am65_common_get_host(common);
+
+	if (changes & NETIF_F_HW_CSUM) {
+		bool enable = !!(features & NETIF_F_HW_CSUM);
+
+		dev_info(common->dev, "Turn %s tx-checksum-ip-generic\n",
+			 enable ? "ON" : "OFF");
+		if (enable)
+			writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
+			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+		else
+			writel(0,
+			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	}
+
+	return 0;
+}
+
+static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
+	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
+	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
+	.ndo_start_xmit		= am65_cpsw_nuss_ndo_slave_xmit,
+	.ndo_set_rx_mode	= am65_cpsw_nuss_ndo_slave_set_rx_mode,
+	.ndo_get_stats64        = am65_cpsw_nuss_ndo_get_stats,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_set_mac_address	= am65_cpsw_nuss_ndo_slave_set_mac_address,
+	.ndo_tx_timeout		= am65_cpsw_nuss_ndo_host_tx_timeout,
+	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
+	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
+	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
+	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
+};
+
+static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
+{
+	struct am65_cpsw_common *common = port->common;
+
+	if (!port->disabled)
+		return;
+
+	common->disabled_ports_mask |= BIT(port->port_id);
+	cpsw_ale_control_set(common->ale, port->port_id,
+			     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
+
+	cpsw_sl_reset(port->slave.mac_sl, 100);
+	cpsw_sl_ctl_reset(port->slave.mac_sl);
+}
+
+static void am65_cpsw_nuss_free_tx_chns(void *data)
+{
+	struct am65_cpsw_common *common = data;
+	int i;
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
+
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
+		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
+			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
+
+		memset(tx_chn, 0, sizeof(*tx_chn));
+	}
+}
+
+void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
+{
+	struct device *dev = common->dev;
+	int i;
+
+	devm_remove_action(dev, am65_cpsw_nuss_free_tx_chns, common);
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
+
+		if (tx_chn->irq)
+			devm_free_irq(dev, tx_chn->irq, tx_chn);
+
+		netif_napi_del(&tx_chn->napi_tx);
+
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
+		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
+			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
+
+		memset(tx_chn, 0, sizeof(*tx_chn));
+	}
+}
+
+static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
+{
+	u32  max_desc_num = ALIGN(AM65_CPSW_MAX_TX_DESC, MAX_SKB_FRAGS);
+	struct k3_udma_glue_tx_channel_cfg tx_cfg = { 0 };
+	struct device *dev = common->dev;
+	struct k3_ring_cfg ring_cfg = {
+		.elm_size = K3_RINGACC_RING_ELSIZE_8,
+		.mode = K3_RINGACC_RING_MODE_RING,
+		.flags = 0
+	};
+	u32 hdesc_size;
+	int i, ret = 0;
+
+	hdesc_size = cppi5_hdesc_calc_size(true, AM65_CPSW_NAV_PS_DATA_SIZE,
+					   AM65_CPSW_NAV_SW_DATA_SIZE);
+
+	tx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
+	tx_cfg.tx_cfg = ring_cfg;
+	tx_cfg.txcq_cfg = ring_cfg;
+	tx_cfg.tx_cfg.size = max_desc_num;
+	tx_cfg.txcq_cfg.size = max_desc_num;
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
+
+		snprintf(tx_chn->tx_chn_name,
+			 sizeof(tx_chn->tx_chn_name), "tx%d", i);
+
+		tx_chn->common = common;
+		tx_chn->id = i;
+		tx_chn->descs_num = max_desc_num;
+		tx_chn->desc_pool =
+			k3_cppi_desc_pool_create_name(dev,
+						      tx_chn->descs_num,
+						      hdesc_size,
+						      tx_chn->tx_chn_name);
+		if (IS_ERR(tx_chn->desc_pool)) {
+			ret = PTR_ERR(tx_chn->desc_pool);
+			dev_err(dev, "Failed to create poll %d\n", ret);
+			goto err;
+		}
+
+		tx_chn->tx_chn =
+			k3_udma_glue_request_tx_chn(dev,
+						    tx_chn->tx_chn_name,
+						    &tx_cfg);
+		if (IS_ERR(tx_chn->tx_chn)) {
+			ret = PTR_ERR(tx_chn->tx_chn);
+			dev_err(dev, "Failed to request tx dma channel %d\n",
+				ret);
+			goto err;
+		}
+
+		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
+		if (tx_chn->irq <= 0) {
+			dev_err(dev, "Failed to get tx dma irq %d\n",
+				tx_chn->irq);
+			goto err;
+		}
+
+		snprintf(tx_chn->tx_chn_name,
+			 sizeof(tx_chn->tx_chn_name), "%s-tx%d",
+			 dev_name(dev), tx_chn->id);
+	}
+
+err:
+	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);
+	if (i) {
+		dev_err(dev, "failed to add free_tx_chns action %d", i);
+		return i;
+	}
+
+	return ret;
+}
+
+static void am65_cpsw_nuss_free_rx_chns(void *data)
+{
+	struct am65_cpsw_common *common = data;
+	struct am65_cpsw_rx_chn *rx_chn;
+
+	rx_chn = &common->rx_chns;
+
+	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
+
+	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
+		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+}
+
+static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
+	struct k3_udma_glue_rx_channel_cfg rx_cfg = { 0 };
+	u32  max_desc_num = AM65_CPSW_MAX_RX_DESC;
+	struct device *dev = common->dev;
+	u32 hdesc_size;
+	u32 fdqring_id;
+	int i, ret = 0;
+
+	hdesc_size = cppi5_hdesc_calc_size(true, AM65_CPSW_NAV_PS_DATA_SIZE,
+					   AM65_CPSW_NAV_SW_DATA_SIZE);
+
+	rx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
+	rx_cfg.flow_id_num = AM65_CPSW_MAX_RX_FLOWS;
+	rx_cfg.flow_id_base = common->rx_flow_id_base;
+
+	/* init all flows */
+	rx_chn->dev = dev;
+	rx_chn->descs_num = max_desc_num;
+	rx_chn->desc_pool = k3_cppi_desc_pool_create_name(dev,
+							  rx_chn->descs_num,
+							  hdesc_size, "rx");
+	if (IS_ERR(rx_chn->desc_pool)) {
+		ret = PTR_ERR(rx_chn->desc_pool);
+		dev_err(dev, "Failed to create rx poll %d\n", ret);
+		goto err;
+	}
+
+	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, "rx", &rx_cfg);
+	if (IS_ERR(rx_chn->rx_chn)) {
+		ret = PTR_ERR(rx_chn->rx_chn);
+		dev_err(dev, "Failed to request rx dma channel %d\n", ret);
+		goto err;
+	}
+
+	common->rx_flow_id_base =
+			k3_udma_glue_rx_get_flow_id_base(rx_chn->rx_chn);
+	dev_info(dev, "set new flow-id-base %u\n", common->rx_flow_id_base);
+
+	fdqring_id = K3_RINGACC_RING_ID_ANY;
+	for (i = 0; i < rx_cfg.flow_id_num; i++) {
+		struct k3_ring_cfg rxring_cfg = {
+			.elm_size = K3_RINGACC_RING_ELSIZE_8,
+			.mode = K3_RINGACC_RING_MODE_RING,
+			.flags = 0,
+		};
+		struct k3_ring_cfg fdqring_cfg = {
+			.elm_size = K3_RINGACC_RING_ELSIZE_8,
+			.mode = K3_RINGACC_RING_MODE_MESSAGE,
+			.flags = K3_RINGACC_RING_SHARED,
+		};
+		struct k3_udma_glue_rx_flow_cfg rx_flow_cfg = {
+			.rx_cfg = rxring_cfg,
+			.rxfdq_cfg = fdqring_cfg,
+			.ring_rxq_id = K3_RINGACC_RING_ID_ANY,
+			.src_tag_lo_sel =
+				K3_UDMA_GLUE_SRC_TAG_LO_USE_REMOTE_SRC_TAG,
+		};
+
+		rx_flow_cfg.ring_rxfdq0_id = fdqring_id;
+		rx_flow_cfg.rx_cfg.size = max_desc_num;
+		rx_flow_cfg.rxfdq_cfg.size = max_desc_num;
+
+		ret = k3_udma_glue_rx_flow_init(rx_chn->rx_chn,
+						i, &rx_flow_cfg);
+		if (ret) {
+			dev_err(dev, "Failed to init rx flow%d %d\n", i, ret);
+			goto err;
+		}
+		if (!i)
+			fdqring_id =
+				k3_udma_glue_rx_flow_get_fdq_id(rx_chn->rx_chn,
+								i);
+
+		rx_chn->irq = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
+
+		if (rx_chn->irq <= 0) {
+			dev_err(dev, "Failed to get rx dma irq %d\n",
+				rx_chn->irq);
+			ret = -ENXIO;
+			goto err;
+		}
+	}
+
+err:
+	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
+	if (i) {
+		dev_err(dev, "failed to add free_rx_chns action %d", i);
+		return i;
+	}
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_init_host_p(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
+
+	host_p->common = common;
+	host_p->port_base = common->cpsw_base + AM65_CPSW_NU_PORTS_BASE;
+	host_p->stat_base = common->cpsw_base + AM65_CPSW_NU_STATS_BASE;
+
+	return 0;
+}
+
+static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
+					   int slave, u8 *mac_addr)
+{
+	u32 mac_lo, mac_hi, offset;
+	struct regmap *syscon;
+	int ret;
+
+	syscon = syscon_regmap_lookup_by_phandle(of_node, "ti,syscon-efuse");
+	if (IS_ERR(syscon)) {
+		if (PTR_ERR(syscon) == -ENODEV)
+			return 0;
+		return PTR_ERR(syscon);
+	}
+
+	ret = of_property_read_u32_index(of_node, "ti,syscon-efuse", 1,
+					 &offset);
+	if (ret)
+		return ret;
+
+	regmap_read(syscon, offset, &mac_lo);
+	regmap_read(syscon, offset + 4, &mac_hi);
+
+	mac_addr[0] = (mac_hi >> 8) & 0xff;
+	mac_addr[1] = mac_hi & 0xff;
+	mac_addr[2] = (mac_lo >> 24) & 0xff;
+	mac_addr[3] = (mac_lo >> 16) & 0xff;
+	mac_addr[4] = (mac_lo >> 8) & 0xff;
+	mac_addr[5] = mac_lo & 0xff;
+
+	return 0;
+}
+
+static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
+{
+	struct device_node *node, *port_np;
+	struct device *dev = common->dev;
+	int ret;
+
+	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
+	if (!node)
+		return -ENOENT;
+
+	for_each_child_of_node(node, port_np) {
+		struct am65_cpsw_port *port;
+		const void *mac_addr;
+		u32 port_id;
+
+		/* it is not a slave port node, continue */
+		if (strcmp(port_np->name, "port"))
+			continue;
+
+		ret = of_property_read_u32(port_np, "reg", &port_id);
+		if (ret < 0) {
+			dev_err(dev, "%pOF error reading port_id %d\n",
+				port_np, ret);
+			return ret;
+		}
+
+		if (!port_id || port_id > common->port_num) {
+			dev_err(dev, "%pOF has invalid port_id %u %s\n",
+				port_np, port_id, port_np->name);
+			return -EINVAL;
+		}
+
+		port = am65_common_get_port(common, port_id);
+		port->port_id = port_id;
+		port->common = common;
+		port->port_base = common->cpsw_base + AM65_CPSW_NU_PORTS_BASE +
+				  AM65_CPSW_NU_PORTS_OFFSET * (port_id);
+		port->stat_base = common->cpsw_base + AM65_CPSW_NU_STATS_BASE +
+				  (AM65_CPSW_NU_STATS_PORT_OFFSET * port_id);
+		port->name = of_get_property(port_np, "label", NULL);
+
+		port->disabled = !of_device_is_available(port_np);
+		if (port->disabled)
+			continue;
+
+		port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
+		if (IS_ERR(port->slave.ifphy)) {
+			ret = PTR_ERR(port->slave.ifphy);
+			dev_err(dev, "%pOF error retrieving port phy: %d\n",
+				port_np, ret);
+			return ret;
+		}
+
+		port->slave.mac_only =
+				of_property_read_bool(port_np, "ti,mac-only");
+
+		/* get phy/link info */
+		if (of_phy_is_fixed_link(port_np)) {
+			ret = of_phy_register_fixed_link(port_np);
+			if (ret) {
+				if (ret != -EPROBE_DEFER)
+					dev_err(dev, "%pOF failed to register fixed-link phy: %d\n",
+						port_np, ret);
+				return ret;
+			}
+			port->slave.phy_node = of_node_get(port_np);
+		} else {
+			port->slave.phy_node =
+				of_parse_phandle(port_np, "phy-handle", 0);
+		}
+
+		if (!port->slave.phy_node) {
+			dev_err(dev,
+				"slave[%d] no phy found\n", port_id);
+			return -ENODEV;
+		}
+
+		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
+		if (ret) {
+			dev_err(dev, "%pOF read phy-mode err %d\n",
+				port_np, ret);
+			return ret;
+		}
+
+		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
+		if (IS_ERR(port->slave.mac_sl))
+			return PTR_ERR(port->slave.mac_sl);
+
+		mac_addr = of_get_mac_address(port_np);
+		if (!IS_ERR(mac_addr)) {
+			ether_addr_copy(port->slave.mac_addr, mac_addr);
+		} else if (am65_cpsw_am654_get_efuse_macid(port_np,
+							   port->port_id,
+							   port->slave.mac_addr) ||
+			   !is_valid_ether_addr(port->slave.mac_addr)) {
+			random_ether_addr(port->slave.mac_addr);
+			dev_err(dev, "Use rundom MAC address\n");
+		}
+	}
+	of_node_put(node);
+
+	return 0;
+}
+
+static void am65_cpsw_pcpu_stats_free(void *data)
+{
+	struct am65_cpsw_ndev_stats __percpu *stats = data;
+
+	free_percpu(stats);
+}
+
+static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_ndev_priv *ndev_priv;
+	struct device *dev = common->dev;
+	struct am65_cpsw_port *port;
+	int ret;
+
+	port = am65_common_get_port(common, 1);
+
+	/* alloc netdev */
+	port->ndev = devm_alloc_etherdev_mqs(common->dev,
+					     sizeof(struct am65_cpsw_ndev_priv),
+					     AM65_CPSW_MAX_TX_QUEUES,
+					     AM65_CPSW_MAX_RX_QUEUES);
+	if (!port->ndev) {
+		dev_err(dev, "error allocating slave net_device %u\n",
+			port->port_id);
+		return -ENOMEM;
+	}
+
+	ndev_priv = netdev_priv(port->ndev);
+	ndev_priv->port = port;
+	ndev_priv->msg_enable = AM65_CPSW_DEBUG;
+	SET_NETDEV_DEV(port->ndev, dev);
+
+	ether_addr_copy(port->ndev->dev_addr, port->slave.mac_addr);
+
+	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
+	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
+	port->ndev->hw_features = NETIF_F_SG |
+				  NETIF_F_RXCSUM |
+				  NETIF_F_HW_CSUM;
+	port->ndev->features = port->ndev->hw_features |
+			       NETIF_F_HW_VLAN_CTAG_FILTER;
+	port->ndev->vlan_features |=  NETIF_F_SG;
+	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops_2g;
+	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
+
+	/* Disable TX checksum offload by default due to HW bug */
+	if (common->pdata->quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
+		port->ndev->features &= ~NETIF_F_HW_CSUM;
+
+	ndev_priv->stats = netdev_alloc_pcpu_stats(struct am65_cpsw_ndev_stats);
+	if (!ndev_priv->stats)
+		return -ENOMEM;
+
+	ret = devm_add_action_or_reset(dev, am65_cpsw_pcpu_stats_free,
+				       ndev_priv->stats);
+	if (ret) {
+		dev_err(dev, "failed to add percpu stat free action %d", ret);
+		return ret;
+	}
+
+	netif_napi_add(port->ndev, &common->napi_rx,
+		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
+
+	common->pf_p0_rx_ptype_rrobin = false;
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
+{
+	struct device *dev = common->dev;
+	struct am65_cpsw_port *port;
+	int i, ret = 0;
+
+	port = am65_common_get_port(common, 1);
+
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
+
+		netif_tx_napi_add(port->ndev, &tx_chn->napi_tx,
+				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
+
+		ret = devm_request_irq(dev, tx_chn->irq,
+				       am65_cpsw_nuss_tx_irq,
+				       0, tx_chn->tx_chn_name, tx_chn);
+		if (ret) {
+			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
+				tx_chn->id, tx_chn->irq, ret);
+			goto err;
+		}
+	}
+
+err:
+	return ret;
+}
+
+static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
+{
+	struct device *dev = common->dev;
+	struct am65_cpsw_port *port;
+	int ret = 0;
+
+	port = am65_common_get_port(common, 1);
+	ret = am65_cpsw_nuss_ndev_add_napi_2g(common);
+	if (ret)
+		goto err;
+
+	ret = devm_request_irq(dev, common->rx_chns.irq,
+			       am65_cpsw_nuss_rx_irq,
+			       0, dev_name(dev), common);
+	if (ret) {
+		dev_err(dev, "failure requesting rx irq %u, %d\n",
+			common->rx_chns.irq, ret);
+		goto err;
+	}
+
+	ret = register_netdev(port->ndev);
+	if (ret)
+		dev_err(dev, "error registering slave net device %d\n", ret);
+
+	/* can't auto unregister ndev using devm_add_action() due to
+	 * devres release sequence in DD core for DMA
+	 */
+err:
+	return ret;
+}
+
+int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
+{
+	int ret;
+
+	common->tx_ch_num = num_tx;
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret)
+		return ret;
+
+	return am65_cpsw_nuss_ndev_add_napi_2g(common);
+}
+
+static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		if (port->ndev)
+			unregister_netdev(port->ndev);
+	}
+}
+
+static const struct am65_cpsw_pdata am65x_sr1_0 = {
+	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
+};
+
+static const struct am65_cpsw_pdata j721e_sr1_0 = {
+	.quirks = 0,
+};
+
+static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
+	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0 },
+	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_sr1_0 },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
+
+static int am65_cpsw_nuss_probe(struct platform_device *pdev)
+{
+	struct cpsw_ale_params ale_params;
+	const struct of_device_id *of_id;
+	struct device *dev = &pdev->dev;
+	struct am65_cpsw_common *common;
+	struct device_node *node;
+	struct resource *res;
+	int ret, i;
+
+	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
+	if (!common)
+		return -ENOMEM;
+	common->dev = dev;
+
+	of_id = of_match_device(am65_cpsw_nuss_of_mtable, dev);
+	if (!of_id)
+		return -EINVAL;
+	common->pdata = of_id->data;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cpsw_nuss");
+	common->ss_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(common->ss_base))
+		return PTR_ERR(common->ss_base);
+	common->cpsw_base = common->ss_base + AM65_CPSW_CPSW_NU_BASE;
+
+	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
+	if (!node)
+		return -ENOENT;
+	common->port_num = of_get_child_count(node);
+	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
+		return -ENOENT;
+	of_node_put(node);
+
+	if (common->port_num != 1)
+		return -EOPNOTSUPP;
+
+	common->rx_flow_id_base = -1;
+	init_completion(&common->tdown_complete);
+	common->tx_ch_num = 1;
+
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "error setting dma mask: %d\n", ret);
+		return ret;
+	}
+
+	common->ports = devm_kcalloc(dev, common->port_num,
+				     sizeof(*common->ports),
+				     GFP_KERNEL);
+	if (!common->ports)
+		return -ENOMEM;
+
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	/* We do not want to force this, as in some cases may not have child */
+	if (ret)
+		dev_warn(dev, "populating child nodes err:%d\n", ret);
+
+	am65_cpsw_nuss_get_ver(common);
+
+	/* init tx channels */
+	ret = am65_cpsw_nuss_init_tx_chns(common);
+	if (ret)
+		goto err_of_clear;
+	ret = am65_cpsw_nuss_init_rx_chns(common);
+	if (ret)
+		goto err_of_clear;
+
+	ret = am65_cpsw_nuss_init_host_p(common);
+	if (ret)
+		goto err_of_clear;
+
+	ret = am65_cpsw_nuss_init_slave_ports(common);
+	if (ret)
+		goto err_of_clear;
+
+	/* init common data */
+	ale_params.dev = dev;
+	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
+	ale_params.ale_entries = 0;
+	ale_params.ale_ports = common->port_num + 1;
+	ale_params.ale_regs = common->cpsw_base + AM65_CPSW_NU_ALE_BASE;
+	ale_params.nu_switch_ale = true;
+
+	common->ale = cpsw_ale_create(&ale_params);
+	if (!common->ale) {
+		dev_err(dev, "error initializing ale engine\n");
+		goto err_of_clear;
+	}
+
+	/* init ports */
+	for (i = 0; i < common->port_num; i++)
+		am65_cpsw_nuss_slave_disable_unused(&common->ports[i]);
+
+	dev_set_drvdata(dev, common);
+
+	ret = am65_cpsw_nuss_init_ndev_2g(common);
+	if (ret)
+		goto err_of_clear;
+
+	ret = am65_cpsw_nuss_ndev_reg_2g(common);
+	if (ret)
+		goto err_of_clear;
+
+	pm_runtime_put(dev);
+	return 0;
+
+err_of_clear:
+	of_platform_depopulate(dev);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
+	return ret;
+}
+
+static int am65_cpsw_nuss_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct am65_cpsw_common *common;
+	int ret;
+
+	common = dev_get_drvdata(dev);
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
+		return ret;
+	}
+
+	/* must unregister ndevs here because DD release_driver routine calls
+	 * dma_deconfigure(dev) before devres_release_all(dev)
+	 */
+	am65_cpsw_nuss_cleanup_ndev(common);
+
+	of_platform_depopulate(dev);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver am65_cpsw_nuss_driver = {
+	.driver = {
+		.name	 = AM65_CPSW_DRV_NAME,
+		.of_match_table = am65_cpsw_nuss_of_mtable,
+	},
+	.probe = am65_cpsw_nuss_probe,
+	.remove = am65_cpsw_nuss_remove,
+};
+
+module_platform_driver(am65_cpsw_nuss_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Grygorii Strashko <grygorii.strashko@ti.com>");
+MODULE_DESCRIPTION("TI AM65 CPSW Ethernet driver");
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
new file mode 100644
index 000000000000..41ae5b4c7931
--- /dev/null
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ */
+
+#ifndef AM65_CPSW_NUSS_H_
+#define AM65_CPSW_NUSS_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+#define HOST_PORT_NUM		0
+
+#define AM65_CPSW_MAX_TX_QUEUES	8
+#define AM65_CPSW_MAX_RX_QUEUES	1
+#define AM65_CPSW_MAX_RX_FLOWS	1
+
+struct am65_cpsw_slave_data {
+	bool				mac_only;
+	struct cpsw_sl			*mac_sl;
+	struct device_node		*phy_node;
+	struct phy_device		*phy;
+	phy_interface_t			phy_if;
+	struct phy			*ifphy;
+	bool				rx_pause;
+	bool				tx_pause;
+	u8				mac_addr[ETH_ALEN];
+};
+
+struct am65_cpsw_port {
+	struct am65_cpsw_common		*common;
+	struct net_device		*ndev;
+	const char			*name;
+	u32				port_id;
+	void __iomem			*port_base;
+	void __iomem			*stat_base;
+	bool				disabled;
+	struct am65_cpsw_slave_data	slave;
+};
+
+struct am65_cpsw_host {
+	struct am65_cpsw_common		*common;
+	void __iomem			*port_base;
+	void __iomem			*stat_base;
+};
+
+struct am65_cpsw_tx_chn {
+	struct napi_struct napi_tx;
+	struct am65_cpsw_common	*common;
+	struct k3_cppi_desc_pool *desc_pool;
+	struct k3_udma_glue_tx_channel *tx_chn;
+	int irq;
+	u32 id;
+	u32 descs_num;
+	char tx_chn_name[128];
+};
+
+struct am65_cpsw_rx_chn {
+	struct device *dev;
+	struct k3_cppi_desc_pool *desc_pool;
+	struct k3_udma_glue_rx_channel *rx_chn;
+	u32 descs_num;
+	int irq;
+};
+
+#define AM65_CPSW_QUIRK_I2027_NO_TX_CSUM BIT(0)
+
+struct am65_cpsw_pdata {
+	u32	quirks;
+};
+
+struct am65_cpsw_common {
+	struct device		*dev;
+	const struct am65_cpsw_pdata *pdata;
+
+	void __iomem		*ss_base;
+	void __iomem		*cpsw_base;
+
+	u32			port_num;
+	struct am65_cpsw_host   host;
+	struct am65_cpsw_port	*ports;
+	u32			disabled_ports_mask;
+
+	int			usage_count; /* number of opened ports */
+	struct cpsw_ale		*ale;
+	int			tx_ch_num;
+	u32			rx_flow_id_base;
+
+	struct am65_cpsw_tx_chn	tx_chns[AM65_CPSW_MAX_TX_QUEUES];
+	struct completion	tdown_complete;
+	atomic_t		tdown_cnt;
+
+	struct am65_cpsw_rx_chn	rx_chns;
+	struct napi_struct	napi_rx;
+
+	u32			nuss_ver;
+	u32			cpsw_ver;
+
+	bool			pf_p0_rx_ptype_rrobin;
+};
+
+struct am65_cpsw_ndev_stats {
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 rx_packets;
+	u64 rx_bytes;
+	struct u64_stats_sync syncp;
+};
+
+struct am65_cpsw_ndev_priv {
+	u32			msg_enable;
+	struct am65_cpsw_port	*port;
+	struct am65_cpsw_ndev_stats __percpu *stats;
+};
+
+#define am65_ndev_to_priv(ndev) \
+	((struct am65_cpsw_ndev_priv *)netdev_priv(ndev))
+#define am65_ndev_to_port(ndev) (am65_ndev_to_priv(ndev)->port)
+#define am65_ndev_to_common(ndev) (am65_ndev_to_port(ndev)->common)
+#define am65_ndev_to_slave(ndev) (&am65_ndev_to_port(ndev)->slave)
+
+#define am65_common_get_host(common) (&(common)->host)
+#define am65_common_get_port(common, id) (&(common)->ports[(id) - 1])
+
+#define am65_cpsw_napi_to_common(pnapi) \
+	container_of(pnapi, struct am65_cpsw_common, napi_rx)
+#define am65_cpsw_napi_to_tx_chn(pnapi) \
+	container_of(pnapi, struct am65_cpsw_tx_chn, napi_tx)
+
+#define AM65_CPSW_DRV_NAME "am65-cpsw-nuss"
+
+#define AM65_CPSW_IS_CPSW2G(common) ((common)->port_num == 1)
+
+extern const struct ethtool_ops am65_cpsw_ethtool_ops_slave;
+
+void am65_cpsw_nuss_adjust_link(struct net_device *ndev);
+void am65_cpsw_nuss_set_p0_ptype(struct am65_cpsw_common *common);
+void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common);
+int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx);
+
+#endif /* AM65_CPSW_NUSS_H_ */
diff --git a/drivers/net/ethernet/ti/k3-cppi-desc-pool.c b/drivers/net/ethernet/ti/k3-cppi-desc-pool.c
new file mode 100644
index 000000000000..ad7cfc1316ce
--- /dev/null
+++ b/drivers/net/ethernet/ti/k3-cppi-desc-pool.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/* TI K3 CPPI5 descriptors pool API
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/genalloc.h>
+#include <linux/kernel.h>
+
+#include "k3-cppi-desc-pool.h"
+
+struct k3_cppi_desc_pool {
+	struct device		*dev;
+	dma_addr_t		dma_addr;
+	void			*cpumem;	/* dma_alloc map */
+	size_t			desc_size;
+	size_t			mem_size;
+	size_t			num_desc;
+	struct gen_pool		*gen_pool;
+};
+
+void k3_cppi_desc_pool_destroy(struct k3_cppi_desc_pool *pool)
+{
+	if (!pool)
+		return;
+
+	WARN(gen_pool_size(pool->gen_pool) != gen_pool_avail(pool->gen_pool),
+	     "k3_knav_desc_pool size %zu != avail %zu",
+	     gen_pool_size(pool->gen_pool),
+	     gen_pool_avail(pool->gen_pool));
+	if (pool->cpumem)
+		dma_free_coherent(pool->dev, pool->mem_size, pool->cpumem,
+				  pool->dma_addr);
+
+	gen_pool_destroy(pool->gen_pool);	/* frees pool->name */
+}
+
+struct k3_cppi_desc_pool *
+k3_cppi_desc_pool_create_name(struct device *dev, size_t size,
+			      size_t desc_size,
+			      const char *name)
+{
+	struct k3_cppi_desc_pool *pool;
+	const char *pool_name = NULL;
+	int ret = -ENOMEM;
+
+	pool = devm_kzalloc(dev, sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return ERR_PTR(ret);
+
+	pool->dev = dev;
+	pool->desc_size	= roundup_pow_of_two(desc_size);
+	pool->num_desc	= size;
+	pool->mem_size	= pool->num_desc * pool->desc_size;
+
+	pool_name = kstrdup_const(name ? name : dev_name(pool->dev),
+				  GFP_KERNEL);
+	if (!pool_name)
+		return ERR_PTR(-ENOMEM);
+
+	pool->gen_pool = gen_pool_create(ilog2(pool->desc_size), -1);
+	if (IS_ERR(pool->gen_pool)) {
+		ret = PTR_ERR(pool->gen_pool);
+		dev_err(pool->dev, "pool create failed %d\n", ret);
+		kfree_const(pool_name);
+		goto gen_pool_create_fail;
+	}
+
+	pool->gen_pool->name = pool_name;
+
+	pool->cpumem = dma_alloc_coherent(pool->dev, pool->mem_size,
+					  &pool->dma_addr, GFP_KERNEL);
+
+	if (!pool->cpumem)
+		goto dma_alloc_fail;
+
+	ret = gen_pool_add_virt(pool->gen_pool, (unsigned long)pool->cpumem,
+				(phys_addr_t)pool->dma_addr, pool->mem_size,
+				-1);
+	if (ret < 0) {
+		dev_err(pool->dev, "pool add failed %d\n", ret);
+		goto gen_pool_add_virt_fail;
+	}
+
+	return pool;
+
+gen_pool_add_virt_fail:
+	dma_free_coherent(pool->dev, pool->mem_size, pool->cpumem,
+			  pool->dma_addr);
+dma_alloc_fail:
+	gen_pool_destroy(pool->gen_pool);	/* frees pool->name */
+gen_pool_create_fail:
+	devm_kfree(pool->dev, pool);
+	return ERR_PTR(ret);
+}
+
+dma_addr_t k3_cppi_desc_pool_virt2dma(struct k3_cppi_desc_pool *pool,
+				      void *addr)
+{
+	return addr ? pool->dma_addr + (addr - pool->cpumem) : 0;
+}
+
+void *k3_cppi_desc_pool_dma2virt(struct k3_cppi_desc_pool *pool, dma_addr_t dma)
+{
+	return dma ? pool->cpumem + (dma - pool->dma_addr) : NULL;
+}
+
+void *k3_cppi_desc_pool_alloc(struct k3_cppi_desc_pool *pool)
+{
+	return (void *)gen_pool_alloc(pool->gen_pool, pool->desc_size);
+}
+
+void k3_cppi_desc_pool_free(struct k3_cppi_desc_pool *pool, void *addr)
+{
+	gen_pool_free(pool->gen_pool, (unsigned long)addr, pool->desc_size);
+}
+
+size_t k3_cppi_desc_pool_avail(struct k3_cppi_desc_pool *pool)
+{
+	return gen_pool_avail(pool->gen_pool) / pool->desc_size;
+}
diff --git a/drivers/net/ethernet/ti/k3-cppi-desc-pool.h b/drivers/net/ethernet/ti/k3-cppi-desc-pool.h
new file mode 100644
index 000000000000..a7e3fa5e7b62
--- /dev/null
+++ b/drivers/net/ethernet/ti/k3-cppi-desc-pool.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* TI K3 CPPI5 descriptors pool
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com
+ */
+
+#ifndef K3_CPPI_DESC_POOL_H_
+#define K3_CPPI_DESC_POOL_H_
+
+#include <linux/device.h>
+#include <linux/types.h>
+
+struct k3_cppi_desc_pool;
+
+void k3_cppi_desc_pool_destroy(struct k3_cppi_desc_pool *pool);
+struct k3_cppi_desc_pool *
+k3_cppi_desc_pool_create_name(struct device *dev, size_t size,
+			      size_t desc_size,
+			      const char *name);
+#define k3_cppi_desc_pool_create(dev, size, desc_size) \
+		k3_cppi_desc_pool_create_name(dev, size, desc_size, NULL)
+dma_addr_t
+k3_cppi_desc_pool_virt2dma(struct k3_cppi_desc_pool *pool, void *addr);
+void *
+k3_cppi_desc_pool_dma2virt(struct k3_cppi_desc_pool *pool, dma_addr_t dma);
+void *k3_cppi_desc_pool_alloc(struct k3_cppi_desc_pool *pool);
+void k3_cppi_desc_pool_free(struct k3_cppi_desc_pool *pool, void *addr);
+size_t k3_cppi_desc_pool_avail(struct k3_cppi_desc_pool *pool);
+
+#endif /* K3_CPPI_DESC_POOL_H_ */
-- 
2.17.1

