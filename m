Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874B641124C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhITJyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:54:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37479 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236781AbhITJxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131512; x=1663667512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwJwGbEIIjCN1Dfp1IEqlyndVqIkbVlMlcttoC0S3q0=;
  b=v+DoRXdZITzMr6SMWrm8tUQampRQEuGsOnbcqgpXCbfwSBo3b1N3vOMQ
   W4dUwnArnmqjtp7SmpR2K2TwF3YpHUvn6FWYpUtIK+KDo+fO9P1v0rG+m
   ZvIeLw2jf5xf+Ve5r7BJjZPBwzUacP/r2pdFAcBKVBW8DOlcLlsj83TUn
   gczyGzABFxLKE9yQMJHsNORKNhBvU6IwR3DuNdUFilU6cS1vv9fRGsBhb
   v8drt2DKDkhqVMs0Hrbvg0m7XfvIShRzjEgHWbaBbAOWP9tmUnvZxfUK2
   ByV9yWSRvmZmznDoXfxFFySAnuZ+uVRDr55XMUutuXw3MuoRo30NtW2B7
   Q==;
IronPort-SDR: bkiwZXYrLbkBuN1tHpOJcwCmG4G6pLj0DOwz5wSHp1hXYYuGexBXGanP0WE+iZi8shZRgZ551Z
 ggbxf1ZgFbJuhqAicb3cgVMGRHQcw5rtpXAc6EUh+HHRNc+GjqfGp1BFcDi63WfIzDDz1e0hEM
 SuM7C5+HtDZDRY7MEd05up25KDvtfAOQqonxIpsqwqGhfQxkotdLcL1uUs/GC5Gu1l6V+wDq4Z
 kXbZMtbpVhIqZgdjF6Gc0QzLkplQzL3Rvxxz0Mr0y0uxfqLMHFkfCcsZbnCShtv5boECzlv8Hd
 OzP+87rmHjYRizVOUJDq+6Re
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="129913612"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:48 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 12/12] net: lan966x: add ethtool configuration and statistics
Date:   Mon, 20 Sep 2021 11:52:18 +0200
Message-ID: <20210920095218.1108151-13-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for statistics counters for the network
interfaces. Also adds support for configuring the network interface via
ethtool like: speed, duplex etc.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../microchip/lan966x/lan966x_ethtool.c       | 578 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  11 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  20 +
 4 files changed, 611 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index e18c9b2d0bb7..445a2abc47ff 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
-lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o
+lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
+	lan966x_ethtool.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
new file mode 100644
index 000000000000..90fe2d872afa
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -0,0 +1,578 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (C) 2019 Microchip Technology Inc. */
+
+#include <linux/netdevice.h>
+
+#include "lan966x_main.h"
+
+/* Number of traffic classes */
+#define LAN966X_NUM_TC			8
+#define LAN966X_STATS_CHECK_DELAY	(2 * HZ)
+
+static const struct lan966x_stat_layout lan966x_stats_layout[] = {
+	{ .name = "rx_octets", .offset = 0x00, },
+	{ .name = "rx_unicast", .offset = 0x01, },
+	{ .name = "rx_multicast", .offset = 0x02 },
+	{ .name = "rx_broadcast", .offset = 0x03 },
+	{ .name = "rx_short", .offset = 0x04 },
+	{ .name = "rx_frag", .offset = 0x05 },
+	{ .name = "rx_jabber", .offset = 0x06 },
+	{ .name = "rx_crc", .offset = 0x07 },
+	{ .name = "rx_symbol_err", .offset = 0x08 },
+	{ .name = "rx_sz_64", .offset = 0x09 },
+	{ .name = "rx_sz_65_127", .offset = 0x0a},
+	{ .name = "rx_sz_128_255", .offset = 0x0b},
+	{ .name = "rx_sz_256_511", .offset = 0x0c },
+	{ .name = "rx_sz_512_1023", .offset = 0x0d },
+	{ .name = "rx_sz_1024_1526", .offset = 0x0e },
+	{ .name = "rx_sz_jumbo", .offset = 0x0f },
+	{ .name = "rx_pause", .offset = 0x10 },
+	{ .name = "rx_control", .offset = 0x11 },
+	{ .name = "rx_long", .offset = 0x12 },
+	{ .name = "rx_cat_drop", .offset = 0x13 },
+	{ .name = "rx_red_prio_0", .offset = 0x14 },
+	{ .name = "rx_red_prio_1", .offset = 0x15 },
+	{ .name = "rx_red_prio_2", .offset = 0x16 },
+	{ .name = "rx_red_prio_3", .offset = 0x17 },
+	{ .name = "rx_red_prio_4", .offset = 0x18 },
+	{ .name = "rx_red_prio_5", .offset = 0x19 },
+	{ .name = "rx_red_prio_6", .offset = 0x1a },
+	{ .name = "rx_red_prio_7", .offset = 0x1b },
+	{ .name = "rx_yellow_prio_0", .offset = 0x1c },
+	{ .name = "rx_yellow_prio_1", .offset = 0x1d },
+	{ .name = "rx_yellow_prio_2", .offset = 0x1e },
+	{ .name = "rx_yellow_prio_3", .offset = 0x1f },
+	{ .name = "rx_yellow_prio_4", .offset = 0x20 },
+	{ .name = "rx_yellow_prio_5", .offset = 0x21 },
+	{ .name = "rx_yellow_prio_6", .offset = 0x22 },
+	{ .name = "rx_yellow_prio_7", .offset = 0x23 },
+	{ .name = "rx_green_prio_0", .offset = 0x24 },
+	{ .name = "rx_green_prio_1", .offset = 0x25 },
+	{ .name = "rx_green_prio_2", .offset = 0x26 },
+	{ .name = "rx_green_prio_3", .offset = 0x27 },
+	{ .name = "rx_green_prio_4", .offset = 0x28 },
+	{ .name = "rx_green_prio_5", .offset = 0x29 },
+	{ .name = "rx_green_prio_6", .offset = 0x2a },
+	{ .name = "rx_green_prio_7", .offset = 0x2b },
+	{ .name = "rx_assembly_err", .offset = 0x2c },
+	{ .name = "rx_smd_err", .offset = 0x2d },
+	{ .name = "rx_assembly_ok", .offset = 0x2e },
+	{ .name = "rx_merge_frag", .offset = 0x2f },
+	{ .name = "rx_pmac_octets", .offset = 0x30, },
+	{ .name = "rx_pmac_unicast", .offset = 0x31, },
+	{ .name = "rx_pmac_multicast", .offset = 0x32 },
+	{ .name = "rx_pmac_broadcast", .offset = 0x33 },
+	{ .name = "rx_pmac_short", .offset = 0x34 },
+	{ .name = "rx_pmac_frag", .offset = 0x35 },
+	{ .name = "rx_pmac_jabber", .offset = 0x36 },
+	{ .name = "rx_pmac_crc", .offset = 0x37 },
+	{ .name = "rx_pmac_symbol_err", .offset = 0x38 },
+	{ .name = "rx_pmac_sz_64", .offset = 0x39 },
+	{ .name = "rx_pmac_sz_65_127", .offset = 0x3a },
+	{ .name = "rx_pmac_sz_128_255", .offset = 0x3b },
+	{ .name = "rx_pmac_sz_256_511", .offset = 0x3c },
+	{ .name = "rx_pmac_sz_512_1023", .offset = 0x3d },
+	{ .name = "rx_pmac_sz_1024_1526", .offset = 0x3e },
+	{ .name = "rx_pmac_sz_jumbo", .offset = 0x3f },
+	{ .name = "rx_pmac_pause", .offset = 0x40 },
+	{ .name = "rx_pmac_control", .offset = 0x41 },
+	{ .name = "rx_pmac_long", .offset = 0x42 },
+
+	{ .name = "tx_octets", .offset = 0x80, },
+	{ .name = "tx_unicast", .offset = 0x81, },
+	{ .name = "tx_multicast", .offset = 0x82 },
+	{ .name = "tx_broadcast", .offset = 0x83 },
+	{ .name = "tx_col", .offset = 0x84 },
+	{ .name = "tx_drop", .offset = 0x85 },
+	{ .name = "tx_pause", .offset = 0x86 },
+	{ .name = "tx_sz_64", .offset = 0x87 },
+	{ .name = "tx_sz_65_127", .offset = 0x88 },
+	{ .name = "tx_sz_128_255", .offset = 0x89 },
+	{ .name = "tx_sz_256_511", .offset = 0x8a },
+	{ .name = "tx_sz_512_1023", .offset = 0x8b },
+	{ .name = "tx_sz_1024_1526", .offset = 0x8c },
+	{ .name = "tx_sz_jumbo", .offset = 0x8d },
+	{ .name = "tx_yellow_prio_0", .offset = 0x8e },
+	{ .name = "tx_yellow_prio_1", .offset = 0x8f },
+	{ .name = "tx_yellow_prio_2", .offset = 0x90 },
+	{ .name = "tx_yellow_prio_3", .offset = 0x91 },
+	{ .name = "tx_yellow_prio_4", .offset = 0x92 },
+	{ .name = "tx_yellow_prio_5", .offset = 0x93 },
+	{ .name = "tx_yellow_prio_6", .offset = 0x94 },
+	{ .name = "tx_yellow_prio_7", .offset = 0x95 },
+	{ .name = "tx_green_prio_0", .offset = 0x96 },
+	{ .name = "tx_green_prio_1", .offset = 0x97 },
+	{ .name = "tx_green_prio_2", .offset = 0x98 },
+	{ .name = "tx_green_prio_3", .offset = 0x99 },
+	{ .name = "tx_green_prio_4", .offset = 0x9a },
+	{ .name = "tx_green_prio_5", .offset = 0x9b },
+	{ .name = "tx_green_prio_6", .offset = 0x9c },
+	{ .name = "tx_green_prio_7", .offset = 0x9d },
+	{ .name = "tx_aged", .offset = 0x9e },
+	{ .name = "tx_llct", .offset = 0x9f },
+	{ .name = "tx_ct", .offset = 0xa0 },
+	{ .name = "tx_mm_hold", .offset = 0xa1 },
+	{ .name = "tx_merge_frag", .offset = 0xa2 },
+	{ .name = "tx_pmac_octets", .offset = 0xa3, },
+	{ .name = "tx_pmac_unicast", .offset = 0xa4, },
+	{ .name = "tx_pmac_multicast", .offset = 0xa5 },
+	{ .name = "tx_pmac_broadcast", .offset = 0xa6 },
+	{ .name = "tx_pmac_pause", .offset = 0xa7 },
+	{ .name = "tx_pmac_sz_64", .offset = 0xa8 },
+	{ .name = "tx_pmac_sz_65_127", .offset = 0xa9 },
+	{ .name = "tx_pmac_sz_128_255", .offset = 0xaa },
+	{ .name = "tx_pmac_sz_256_511", .offset = 0xab },
+	{ .name = "tx_pmac_sz_512_1023", .offset = 0xac },
+	{ .name = "tx_pmac_sz_1024_1526", .offset = 0xad },
+	{ .name = "tx_pmac_sz_jumbo", .offset = 0xae },
+
+	{ .name = "dr_local", .offset = 0x100 },
+	{ .name = "dr_tail", .offset = 0x101 },
+	{ .name = "dr_yellow_prio_0", .offset = 0x102 },
+	{ .name = "dr_yellow_prio_1", .offset = 0x103 },
+	{ .name = "dr_yellow_prio_2", .offset = 0x104 },
+	{ .name = "dr_yellow_prio_3", .offset = 0x105 },
+	{ .name = "dr_yellow_prio_4", .offset = 0x106 },
+	{ .name = "dr_yellow_prio_5", .offset = 0x107 },
+	{ .name = "dr_yellow_prio_6", .offset = 0x108 },
+	{ .name = "dr_yellow_prio_7", .offset = 0x109 },
+	{ .name = "dr_green_prio_0", .offset = 0x10a },
+	{ .name = "dr_green_prio_1", .offset = 0x10b },
+	{ .name = "dr_green_prio_2", .offset = 0x10c },
+	{ .name = "dr_green_prio_3", .offset = 0x10d },
+	{ .name = "dr_green_prio_4", .offset = 0x10e },
+	{ .name = "dr_green_prio_5", .offset = 0x10f },
+	{ .name = "dr_green_prio_6", .offset = 0x110 },
+	{ .name = "dr_green_prio_7", .offset = 0x111 },
+};
+
+/* The following numbers are indexes into lan966x_stats_layout[] */
+#define SYS_COUNT_RX_OCT		  0
+#define SYS_COUNT_RX_UC			  1
+#define SYS_COUNT_RX_MC			  2
+#define SYS_COUNT_RX_BC			  3
+#define SYS_COUNT_RX_SHORT		  4
+#define SYS_COUNT_RX_FRAG		  5
+#define SYS_COUNT_RX_JABBER		  6
+#define SYS_COUNT_RX_CRC		  7
+#define SYS_COUNT_RX_SYMBOL_ERR		  8
+#define SYS_COUNT_RX_SZ_64		  9
+#define SYS_COUNT_RX_SZ_65_127		 10
+#define SYS_COUNT_RX_SZ_128_255		 11
+#define SYS_COUNT_RX_SZ_256_511		 12
+#define SYS_COUNT_RX_SZ_512_1023	 13
+#define SYS_COUNT_RX_SZ_1024_1526	 14
+#define SYS_COUNT_RX_SZ_JUMBO		 15
+#define SYS_COUNT_RX_PAUSE		 16
+#define SYS_COUNT_RX_CONTROL		 17
+#define SYS_COUNT_RX_LONG		 18
+#define SYS_COUNT_RX_CAT_DROP		 19
+#define SYS_COUNT_RX_RED_PRIO_0		 20
+#define SYS_COUNT_RX_RED_PRIO_1		 21
+#define SYS_COUNT_RX_RED_PRIO_2		 22
+#define SYS_COUNT_RX_RED_PRIO_3		 23
+#define SYS_COUNT_RX_RED_PRIO_4		 24
+#define SYS_COUNT_RX_RED_PRIO_5		 25
+#define SYS_COUNT_RX_RED_PRIO_6		 26
+#define SYS_COUNT_RX_RED_PRIO_7		 27
+#define SYS_COUNT_RX_YELLOW_PRIO_0	 28
+#define SYS_COUNT_RX_YELLOW_PRIO_1	 29
+#define SYS_COUNT_RX_YELLOW_PRIO_2	 30
+#define SYS_COUNT_RX_YELLOW_PRIO_3	 31
+#define SYS_COUNT_RX_YELLOW_PRIO_4	 32
+#define SYS_COUNT_RX_YELLOW_PRIO_5	 33
+#define SYS_COUNT_RX_YELLOW_PRIO_6	 34
+#define SYS_COUNT_RX_YELLOW_PRIO_7	 35
+#define SYS_COUNT_RX_GREEN_PRIO_0	 36
+#define SYS_COUNT_RX_GREEN_PRIO_1	 37
+#define SYS_COUNT_RX_GREEN_PRIO_2	 38
+#define SYS_COUNT_RX_GREEN_PRIO_3	 39
+#define SYS_COUNT_RX_GREEN_PRIO_4	 40
+#define SYS_COUNT_RX_GREEN_PRIO_5	 41
+#define SYS_COUNT_RX_GREEN_PRIO_6	 42
+#define SYS_COUNT_RX_GREEN_PRIO_7	 43
+#define SYS_COUNT_RX_ASSEMBLY_ERR	 44
+#define SYS_COUNT_RX_SMD_ERR		 45
+#define SYS_COUNT_RX_ASSEMBLY_OK	 46
+#define SYS_COUNT_RX_MERGE_FRAG		 47
+#define SYS_COUNT_RX_PMAC_OCT		 48
+#define SYS_COUNT_RX_PMAC_UC		 49
+#define SYS_COUNT_RX_PMAC_MC		 50
+#define SYS_COUNT_RX_PMAC_BC		 51
+#define SYS_COUNT_RX_PMAC_SHORT		 52
+#define SYS_COUNT_RX_PMAC_FRAG		 53
+#define SYS_COUNT_RX_PMAC_JABBER	 54
+#define SYS_COUNT_RX_PMAC_CRC		 55
+#define SYS_COUNT_RX_PMAC_SYMBOL_ERR	 56
+#define SYS_COUNT_RX_PMAC_SZ_64		 57
+#define SYS_COUNT_RX_PMAC_SZ_65_127	 58
+#define SYS_COUNT_RX_PMAC_SZ_128_255	 59
+#define SYS_COUNT_RX_PMAC_SZ_256_511	 60
+#define SYS_COUNT_RX_PMAC_SZ_512_1023	 61
+#define SYS_COUNT_RX_PMAC_SZ_1024_1526	 62
+#define SYS_COUNT_RX_PMAC_SZ_JUMBO	 63
+#define SYS_COUNT_RX_PMAC_PAUSE		 64
+#define SYS_COUNT_RX_PMAC_CONTROL	 65
+#define SYS_COUNT_RX_PMAC_LONG		 66
+
+#define SYS_COUNT_TX_OCT		 67
+#define SYS_COUNT_TX_UC			 68
+#define SYS_COUNT_TX_MC			 69
+#define SYS_COUNT_TX_BC			 70
+#define SYS_COUNT_TX_COL		 71
+#define SYS_COUNT_TX_DROP		 72
+#define SYS_COUNT_TX_PAUSE		 73
+#define SYS_COUNT_TX_SZ_64		 74
+#define SYS_COUNT_TX_SZ_65_127		 75
+#define SYS_COUNT_TX_SZ_128_255		 76
+#define SYS_COUNT_TX_SZ_256_511		 77
+#define SYS_COUNT_TX_SZ_512_1023	 78
+#define SYS_COUNT_TX_SZ_1024_1526	 79
+#define SYS_COUNT_TX_SZ_JUMBO		 80
+#define SYS_COUNT_TX_YELLOW_PRIO_0	 81
+#define SYS_COUNT_TX_YELLOW_PRIO_1	 82
+#define SYS_COUNT_TX_YELLOW_PRIO_2	 83
+#define SYS_COUNT_TX_YELLOW_PRIO_3	 84
+#define SYS_COUNT_TX_YELLOW_PRIO_4	 85
+#define SYS_COUNT_TX_YELLOW_PRIO_5	 86
+#define SYS_COUNT_TX_YELLOW_PRIO_6	 87
+#define SYS_COUNT_TX_YELLOW_PRIO_7	 88
+#define SYS_COUNT_TX_GREEN_PRIO_0	 89
+#define SYS_COUNT_TX_GREEN_PRIO_1	 90
+#define SYS_COUNT_TX_GREEN_PRIO_2	 91
+#define SYS_COUNT_TX_GREEN_PRIO_3	 92
+#define SYS_COUNT_TX_GREEN_PRIO_4	 93
+#define SYS_COUNT_TX_GREEN_PRIO_5	 94
+#define SYS_COUNT_TX_GREEN_PRIO_6	 95
+#define SYS_COUNT_TX_GREEN_PRIO_7	 96
+#define SYS_COUNT_TX_AGED		 97
+#define SYS_COUNT_TX_LLCT		 98
+#define SYS_COUNT_TX_CT			 99
+#define SYS_COUNT_TX_MM_HOLD		100
+#define SYS_COUNT_TX_MERGE_FRAG		101
+#define SYS_COUNT_TX_PMAC_OCT		102
+#define SYS_COUNT_TX_PMAC_UC		103
+#define SYS_COUNT_TX_PMAC_MC		104
+#define SYS_COUNT_TX_PMAC_BC		105
+#define SYS_COUNT_TX_PMAC_PAUSE		106
+#define SYS_COUNT_TX_PMAC_SZ_64		107
+#define SYS_COUNT_TX_PMAC_SZ_65_127	108
+#define SYS_COUNT_TX_PMAC_SZ_128_255	109
+#define SYS_COUNT_TX_PMAC_SZ_256_511	110
+#define SYS_COUNT_TX_PMAC_SZ_512_1023	111
+#define SYS_COUNT_TX_PMAC_SZ_1024_1526	112
+#define SYS_COUNT_TX_PMAC_SZ_JUMBO	113
+
+#define SYS_COUNT_DR_LOCAL		114
+#define SYS_COUNT_DR_TAIL		115
+#define SYS_COUNT_DR_YELLOW_PRIO_0	116
+#define SYS_COUNT_DR_YELLOW_PRIO_1	117
+#define SYS_COUNT_DR_YELLOW_PRIO_2	118
+#define SYS_COUNT_DR_YELLOW_PRIO_3	119
+#define SYS_COUNT_DR_YELLOW_PRIO_4	120
+#define SYS_COUNT_DR_YELLOW_PRIO_5	121
+#define SYS_COUNT_DR_YELLOW_PRIO_6	122
+#define SYS_COUNT_DR_YELLOW_PRIO_7	123
+#define SYS_COUNT_DR_GREEN_PRIO_0	124
+#define SYS_COUNT_DR_GREEN_PRIO_1	125
+#define SYS_COUNT_DR_GREEN_PRIO_2	126
+#define SYS_COUNT_DR_GREEN_PRIO_3	127
+#define SYS_COUNT_DR_GREEN_PRIO_4	128
+#define SYS_COUNT_DR_GREEN_PRIO_5	129
+#define SYS_COUNT_DR_GREEN_PRIO_6	130
+#define SYS_COUNT_DR_GREEN_PRIO_7	131
+
+/* Add a possibly wrapping 32 bit value to a 64 bit counter */
+static void lan966x_add_cnt(u64 *cnt, u32 val)
+{
+	if (val < (*cnt & U32_MAX))
+		*cnt += (u64)1 << 32; /* value has wrapped */
+
+	*cnt = (*cnt & ~(u64)U32_MAX) + val;
+}
+
+static void lan966x_stats_update(struct lan966x *lan966x)
+{
+	int i, j;
+
+	mutex_lock(&lan966x->stats_lock);
+
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		uint idx = i * lan966x->num_stats;
+
+		lan_wr(SYS_STAT_CFG_STAT_VIEW_SET(i),
+		       lan966x, SYS_STAT_CFG);
+
+		for (j = 0; j < lan966x->num_stats; j++) {
+			u32 offset = lan966x->stats_layout[j].offset;
+
+			lan966x_add_cnt(&lan966x->stats[idx++],
+					lan_rd(lan966x, SYS_CNT(offset)));
+		}
+	}
+
+	mutex_unlock(&lan966x->stats_lock);
+}
+
+static int lan966x_get_sset_count(struct net_device *dev, int sset)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+
+	return lan966x->num_stats;
+}
+
+static void lan966x_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	struct lan966x_port *port = netdev_priv(netdev);
+	struct lan966x *lan966x = port->lan966x;
+	int i;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < lan966x->num_stats; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+		       lan966x->stats_layout[i].name, ETH_GSTRING_LEN);
+}
+
+static void lan966x_get_ethtool_stats(struct net_device *dev,
+				      struct ethtool_stats *stats, u64 *data)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int i;
+
+	/* check and update now */
+	lan966x_stats_update(lan966x);
+
+	/* Copy all counters */
+	for (i = 0; i < lan966x->num_stats; i++)
+		*data++ = lan966x->stats[port->chip_port *
+					 lan966x->num_stats + i];
+}
+
+static void lan966x_get_eth_mac_stats(struct net_device *dev,
+				      struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	u32 idx;
+
+	lan966x_stats_update(lan966x);
+
+	idx = port->chip_port * lan966x->num_stats;
+
+	mutex_lock(&lan966x->stats_lock);
+
+	mac_stats->FramesTransmittedOK =
+		lan966x->stats[idx + SYS_COUNT_TX_UC] +
+		lan966x->stats[idx + SYS_COUNT_TX_MC] +
+		lan966x->stats[idx + SYS_COUNT_TX_BC] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_UC] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_MC] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_BC];
+	mac_stats->SingleCollisionFrames =
+		lan966x->stats[idx + SYS_COUNT_TX_COL];
+	mac_stats->MultipleCollisionFrames = 0;
+	mac_stats->FramesReceivedOK =
+		lan966x->stats[idx + SYS_COUNT_RX_UC] +
+		lan966x->stats[idx + SYS_COUNT_RX_MC] +
+		lan966x->stats[idx + SYS_COUNT_RX_BC];
+	mac_stats->FrameCheckSequenceErrors =
+		lan966x->stats[idx + SYS_COUNT_RX_CRC] +
+		lan966x->stats[idx + SYS_COUNT_RX_CRC];
+	mac_stats->AlignmentErrors = 0;
+	mac_stats->OctetsTransmittedOK =
+		lan966x->stats[idx + SYS_COUNT_TX_OCT] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_OCT];
+	mac_stats->FramesWithDeferredXmissions =
+		lan966x->stats[idx + SYS_COUNT_TX_MM_HOLD];
+	mac_stats->LateCollisions = 0;
+	mac_stats->FramesAbortedDueToXSColls = 0;
+	mac_stats->FramesLostDueToIntMACXmitError = 0;
+	mac_stats->CarrierSenseErrors = 0;
+	mac_stats->OctetsReceivedOK =
+		lan966x->stats[idx + SYS_COUNT_RX_OCT];
+	mac_stats->FramesLostDueToIntMACRcvError = 0;
+	mac_stats->MulticastFramesXmittedOK =
+		lan966x->stats[idx + SYS_COUNT_TX_MC] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_MC];
+	mac_stats->BroadcastFramesXmittedOK =
+		lan966x->stats[idx + SYS_COUNT_TX_BC] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_BC];
+	mac_stats->FramesWithExcessiveDeferral = 0;
+	mac_stats->MulticastFramesReceivedOK =
+		lan966x->stats[idx + SYS_COUNT_RX_MC];
+	mac_stats->BroadcastFramesReceivedOK =
+		lan966x->stats[idx + SYS_COUNT_RX_BC];
+	mac_stats->InRangeLengthErrors =
+		lan966x->stats[idx + SYS_COUNT_RX_FRAG] +
+		lan966x->stats[idx + SYS_COUNT_RX_JABBER] +
+		lan966x->stats[idx + SYS_COUNT_RX_CRC] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_FRAG] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_JABBER] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_CRC];
+	mac_stats->OutOfRangeLengthField =
+		lan966x->stats[idx + SYS_COUNT_RX_SHORT] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SHORT] +
+		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_LONG];
+	mac_stats->FrameTooLongErrors =
+		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_LONG];
+
+	mutex_unlock(&lan966x->stats_lock);
+}
+
+static int lan966x_get_link_ksettings(struct net_device *ndev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct lan966x_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(port->phylink, cmd);
+}
+
+static int lan966x_set_link_ksettings(struct net_device *ndev,
+				      const struct ethtool_link_ksettings *cmd)
+{
+	struct lan966x_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(port->phylink, cmd);
+}
+
+const struct ethtool_ops lan966x_ethtool_ops = {
+	.get_link_ksettings     = lan966x_get_link_ksettings,
+	.set_link_ksettings     = lan966x_set_link_ksettings,
+	.get_sset_count		= lan966x_get_sset_count,
+	.get_strings		= lan966x_get_strings,
+	.get_ethtool_stats	= lan966x_get_ethtool_stats,
+	.get_eth_mac_stats      = lan966x_get_eth_mac_stats,
+	.get_link		= ethtool_op_get_link,
+};
+
+static void lan966x_check_stats_work(struct work_struct *work)
+{
+	struct delayed_work *del_work = to_delayed_work(work);
+	struct lan966x *lan966x = container_of(del_work, struct lan966x,
+					       stats_work);
+
+	lan966x_stats_update(lan966x);
+
+	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
+			   LAN966X_STATS_CHECK_DELAY);
+}
+
+void lan966x_stats_get(struct net_device *dev,
+		       struct rtnl_link_stats64 *stats)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	u32 idx;
+	int i;
+
+	idx = port->chip_port * lan966x->num_stats;
+
+	mutex_lock(&lan966x->stats_lock);
+
+	stats->rx_bytes = lan966x->stats[idx + SYS_COUNT_RX_OCT] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_OCT];
+
+	stats->rx_packets = lan966x->stats[idx + SYS_COUNT_RX_SHORT] +
+		lan966x->stats[idx + SYS_COUNT_RX_FRAG] +
+		lan966x->stats[idx + SYS_COUNT_RX_JABBER] +
+		lan966x->stats[idx + SYS_COUNT_RX_CRC] +
+		lan966x->stats[idx + SYS_COUNT_RX_SYMBOL_ERR] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_64] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_65_127] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_128_255] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_256_511] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_512_1023] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_1024_1526] +
+		lan966x->stats[idx + SYS_COUNT_RX_SZ_JUMBO] +
+		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SHORT] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_FRAG] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_JABBER] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_64] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_65_127] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_128_255] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_256_511] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_512_1023] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_1024_1526] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_SZ_JUMBO];
+
+	stats->multicast = lan966x->stats[idx + SYS_COUNT_RX_MC] +
+		lan966x->stats[idx + SYS_COUNT_RX_PMAC_MC];
+
+	stats->rx_errors = lan966x->stats[idx + SYS_COUNT_RX_SHORT] +
+		lan966x->stats[idx + SYS_COUNT_RX_FRAG] +
+		lan966x->stats[idx + SYS_COUNT_RX_JABBER] +
+		lan966x->stats[idx + SYS_COUNT_RX_CRC] +
+		lan966x->stats[idx + SYS_COUNT_RX_SYMBOL_ERR] +
+		lan966x->stats[idx + SYS_COUNT_RX_LONG];
+
+	stats->rx_dropped = dev->stats.rx_dropped +
+		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
+		lan966x->stats[idx + SYS_COUNT_DR_LOCAL] +
+		lan966x->stats[idx + SYS_COUNT_DR_TAIL];
+
+	for (i = 0; i < LAN966X_NUM_TC; i++) {
+		stats->rx_dropped +=
+			(lan966x->stats[idx + SYS_COUNT_DR_YELLOW_PRIO_0 + i] +
+			 lan966x->stats[idx + SYS_COUNT_DR_GREEN_PRIO_0 + i]);
+	}
+
+	/* Get Tx stats */
+	stats->tx_bytes = lan966x->stats[idx + SYS_COUNT_TX_OCT] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_OCT];
+
+	stats->tx_packets = lan966x->stats[idx + SYS_COUNT_TX_SZ_64] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_65_127] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_128_255] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_256_511] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_512_1023] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_1024_1526] +
+		lan966x->stats[idx + SYS_COUNT_TX_SZ_JUMBO] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_64] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_65_127] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_128_255] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_256_511] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_512_1023] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_1024_1526] +
+		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_JUMBO];
+
+	stats->tx_dropped = lan966x->stats[idx + SYS_COUNT_TX_DROP] +
+		lan966x->stats[idx + SYS_COUNT_TX_AGED];
+
+	stats->collisions = lan966x->stats[idx + SYS_COUNT_TX_COL];
+
+	mutex_unlock(&lan966x->stats_lock);
+}
+
+int lan966x_stats_init(struct lan966x *lan966x)
+{
+	char queue_name[32];
+
+	lan966x->stats_layout = lan966x_stats_layout;
+	lan966x->num_stats = ARRAY_SIZE(lan966x_stats_layout);
+	lan966x->stats = devm_kcalloc(lan966x->dev, lan966x->num_phys_ports *
+				      lan966x->num_stats,
+				      sizeof(u64), GFP_KERNEL);
+	if (!lan966x->stats)
+		return -ENOMEM;
+
+	/* Init stats worker */
+	mutex_init(&lan966x->stats_lock);
+	snprintf(queue_name, sizeof(queue_name), "%s-stats",
+		 dev_name(lan966x->dev));
+	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
+	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
+			   LAN966X_STATS_CHECK_DELAY);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 53b88bb5b718..7448d414c6cc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -446,6 +446,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_change_mtu			= lan966x_change_mtu,
 	.ndo_set_rx_mode		= lan966x_set_rx_mode,
 	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
+	.ndo_get_stats64		= lan966x_stats_get,
 	.ndo_set_mac_address		= lan966x_port_set_mac_address,
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 };
@@ -653,6 +654,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u8 port,
 	dev->max_mtu = ETH_MAX_MTU;
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
+	dev->ethtool_ops = &lan966x_ethtool_ops;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	ether_addr_copy(dev->dev_addr, lan966x->base_mac);
@@ -918,6 +920,7 @@ static int lan966x_probe(struct platform_device *pdev)
 
 	/* init switch */
 	lan966x_init(lan966x);
+	lan966x_stats_init(lan966x);
 
 	/* go over the child nodes */
 	fwnode_for_each_available_child_node(ports, portnp) {
@@ -950,6 +953,10 @@ static int lan966x_probe(struct platform_device *pdev)
 cleanup_ports:
 	fwnode_handle_put(portnp);
 
+	cancel_delayed_work_sync(&lan966x->stats_work);
+	destroy_workqueue(lan966x->stats_queue);
+	mutex_destroy(&lan966x->stats_lock);
+
 	disable_irq(lan966x->xtr_irq);
 	lan966x->xtr_irq = -ENXIO;
 	lan966x_cleanup_ports(lan966x);
@@ -961,6 +968,10 @@ static int lan966x_remove(struct platform_device *pdev)
 {
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&lan966x->stats_work);
+	destroy_workqueue(lan966x->stats_queue);
+	mutex_destroy(&lan966x->stats_lock);
+
 	disable_irq(lan966x->xtr_irq);
 	lan966x->xtr_irq = -ENXIO;
 	lan966x_cleanup_ports(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index d499f654e316..fa484226656e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -76,6 +76,11 @@ struct lan966x_frame_info {
 	u8 ipv;
 };
 
+struct lan966x_stat_layout {
+	u32 offset;
+	char name[ETH_GSTRING_LEN];
+};
+
 struct lan966x {
 	struct device *dev;
 
@@ -88,6 +93,16 @@ struct lan966x {
 
 	u8 base_mac[ETH_ALEN];
 
+	/* stats */
+	const struct lan966x_stat_layout *stats_layout;
+	u32 num_stats;
+
+	/* workqueue for reading stats */
+	struct mutex stats_lock;
+	u64 *stats;
+	struct delayed_work stats_work;
+	struct workqueue_struct *stats_queue;
+
 	/* interrupts */
 	int xtr_irq;
 };
@@ -117,6 +132,11 @@ struct lan966x_port {
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
+extern const struct ethtool_ops lan966x_ethtool_ops;
+
+void lan966x_stats_get(struct net_device *dev,
+		       struct rtnl_link_stats64 *stats);
+int lan966x_stats_init(struct lan966x *lan966x);
 
 void lan966x_port_config_down(struct lan966x_port *port);
 void lan966x_port_config_up(struct lan966x_port *port);
-- 
2.31.1

