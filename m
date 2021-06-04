Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5523E39B55B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFDI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:58:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22732 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhFDI6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622797008; x=1654333008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WVSPYJMVOKWOw0GwDrzfMalvmIN2hiypZh/F4Dkj1yg=;
  b=tMoq9puNWb460CL5a/YxLDbFb33ztgHIRMiHkIFvQ7/6eNRzOyH1N17j
   d/EEpXsOL7uK8397Z50BzKycvFZ7vKPQqOdyk619dYB+jnLMNvK7rDoVy
   G4bRjwhja1BTcp1gyLjEWPfJwPxX2EwhQ6XpuY+fzULvEfq8LOIet9Kz0
   X9FKp0Hb3d28+s8DZqOF/baKOfYtXS8KpWOJvhpULFOKuedWwgtsfZm89
   vLJUC1KE3JU8jkEEy1hpQLNMto8yfW9NUgJBr5w3ZoBNHnRo0JPIoWF99
   wEYoPuMzeGCi56WtlBzBXIj/pCESOBcKlgfBVao8cNEvZJW7YKjIInUuZ
   w==;
IronPort-SDR: y4Z6wUoP0uvX32tcxRoy3FMriYdofSzAJS4W9Nw/N+xkeiCR3rNbbld5IoM1C8SRfMnM++t+9K
 80/jrrvovGH2+KTgtZefblMKSBWHIvMuSGV+dGoeU5O8edG7LvtCUjuJyIUYQuWyUPR82nQQTf
 bsVyeBsSiU170Sw/vBTRKT/J3C8WXLHjdWyNuRQLOTlL90+gOEquVJDAmCM+X6bLMDNqoBOE4r
 GOr6rlqua1QuMGtJvuHF+TMIB8Q28KbZY+RgRK6ifPskPo7cjUG+iyL5Mz02Rd4i3AQgkLJxl6
 JOM=
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="124069823"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2021 01:56:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 01:56:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 4 Jun 2021 01:56:43 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v3 09/10] net: sparx5: add ethtool configuration and statistics support
Date:   Fri, 4 Jun 2021 10:55:59 +0200
Message-ID: <20210604085600.3014532-10-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604085600.3014532-1-steen.hegelund@microchip.com>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds statistic counters for the network interfaces provided
by the driver.  It also adds CPU port counters (which are not
exposed by ethtool).
This also adds support for configuring the network interface
parameters via ethtool: speed, duplex, aneg etc.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |    2 +-
 .../microchip/sparx5/sparx5_ethtool.c         | 1227 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |    4 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |   14 +
 .../ethernet/microchip/sparx5/sparx5_netdev.c |    2 +
 5 files changed, 1248 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index e7dea25eb479..5df99f9a12e9 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o \
- sparx5_switchdev.o sparx5_calendar.o
+ sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
new file mode 100644
index 000000000000..e537c358fb07
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -0,0 +1,1227 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/ethtool.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+#include "sparx5_port.h"
+
+/* Index of ANA_AC port counters */
+#define SPX5_PORT_POLICER_DROPS 0
+
+/* Add a potentially wrapping 32 bit value to a 64 bit counter */
+static void sparx5_update_counter(u64 *cnt, u32 val)
+{
+	if (val < (*cnt & U32_MAX))
+		*cnt += (u64)1 << 32; /* value has wrapped */
+	*cnt = (*cnt & ~(u64)U32_MAX) + val;
+}
+
+enum sparx5_stats_entry {
+	spx5_stats_rx_symbol_err_cnt = 0,
+	spx5_stats_pmac_rx_symbol_err_cnt = 1,
+	spx5_stats_tx_uc_cnt = 2,
+	spx5_stats_pmac_tx_uc_cnt = 3,
+	spx5_stats_tx_mc_cnt = 4,
+	spx5_stats_tx_bc_cnt = 5,
+	spx5_stats_tx_backoff1_cnt = 6,
+	spx5_stats_tx_multi_coll_cnt = 7,
+	spx5_stats_rx_uc_cnt = 8,
+	spx5_stats_pmac_rx_uc_cnt = 9,
+	spx5_stats_rx_mc_cnt = 10,
+	spx5_stats_rx_bc_cnt = 11,
+	spx5_stats_rx_crc_err_cnt = 12,
+	spx5_stats_pmac_rx_crc_err_cnt = 13,
+	spx5_stats_rx_alignment_lost_cnt = 14,
+	spx5_stats_pmac_rx_alignment_lost_cnt = 15,
+	spx5_stats_tx_ok_bytes_cnt = 16,
+	spx5_stats_pmac_tx_ok_bytes_cnt = 17,
+	spx5_stats_tx_defer_cnt = 18,
+	spx5_stats_tx_late_coll_cnt = 19,
+	spx5_stats_tx_xcoll_cnt = 20,
+	spx5_stats_tx_csense_cnt = 21,
+	spx5_stats_rx_ok_bytes_cnt = 22,
+	spx5_stats_pmac_rx_ok_bytes_cnt = 23,
+	spx5_stats_pmac_tx_mc_cnt = 24,
+	spx5_stats_pmac_tx_bc_cnt = 25,
+	spx5_stats_tx_xdefer_cnt = 26,
+	spx5_stats_pmac_rx_mc_cnt = 27,
+	spx5_stats_pmac_rx_bc_cnt = 28,
+	spx5_stats_rx_in_range_len_err_cnt = 29,
+	spx5_stats_pmac_rx_in_range_len_err_cnt = 30,
+	spx5_stats_rx_out_of_range_len_err_cnt = 31,
+	spx5_stats_pmac_rx_out_of_range_len_err_cnt = 32,
+	spx5_stats_rx_oversize_cnt = 33,
+	spx5_stats_pmac_rx_oversize_cnt = 34,
+	spx5_stats_tx_pause_cnt = 35,
+	spx5_stats_pmac_tx_pause_cnt = 36,
+	spx5_stats_rx_pause_cnt = 37,
+	spx5_stats_pmac_rx_pause_cnt = 38,
+	spx5_stats_rx_unsup_opcode_cnt = 39,
+	spx5_stats_pmac_rx_unsup_opcode_cnt = 40,
+	spx5_stats_rx_undersize_cnt = 41,
+	spx5_stats_pmac_rx_undersize_cnt = 42,
+	spx5_stats_rx_fragments_cnt = 43,
+	spx5_stats_pmac_rx_fragments_cnt = 44,
+	spx5_stats_rx_jabbers_cnt = 45,
+	spx5_stats_pmac_rx_jabbers_cnt = 46,
+	spx5_stats_rx_size64_cnt = 47,
+	spx5_stats_pmac_rx_size64_cnt = 48,
+	spx5_stats_rx_size65to127_cnt = 49,
+	spx5_stats_pmac_rx_size65to127_cnt = 50,
+	spx5_stats_rx_size128to255_cnt = 51,
+	spx5_stats_pmac_rx_size128to255_cnt = 52,
+	spx5_stats_rx_size256to511_cnt = 53,
+	spx5_stats_pmac_rx_size256to511_cnt = 54,
+	spx5_stats_rx_size512to1023_cnt = 55,
+	spx5_stats_pmac_rx_size512to1023_cnt = 56,
+	spx5_stats_rx_size1024to1518_cnt = 57,
+	spx5_stats_pmac_rx_size1024to1518_cnt = 58,
+	spx5_stats_rx_size1519tomax_cnt = 59,
+	spx5_stats_pmac_rx_size1519tomax_cnt = 60,
+	spx5_stats_tx_size64_cnt = 61,
+	spx5_stats_pmac_tx_size64_cnt = 62,
+	spx5_stats_tx_size65to127_cnt = 63,
+	spx5_stats_pmac_tx_size65to127_cnt = 64,
+	spx5_stats_tx_size128to255_cnt = 65,
+	spx5_stats_pmac_tx_size128to255_cnt = 66,
+	spx5_stats_tx_size256to511_cnt = 67,
+	spx5_stats_pmac_tx_size256to511_cnt = 68,
+	spx5_stats_tx_size512to1023_cnt = 69,
+	spx5_stats_pmac_tx_size512to1023_cnt = 70,
+	spx5_stats_tx_size1024to1518_cnt = 71,
+	spx5_stats_pmac_tx_size1024to1518_cnt = 72,
+	spx5_stats_tx_size1519tomax_cnt = 73,
+	spx5_stats_pmac_tx_size1519tomax_cnt = 74,
+	spx5_stats_mm_rx_assembly_err_cnt = 75,
+	spx5_stats_mm_rx_assembly_ok_cnt = 76,
+	spx5_stats_mm_rx_merge_frag_cnt = 77,
+	spx5_stats_mm_rx_smd_err_cnt = 78,
+	spx5_stats_mm_tx_pfragment_cnt = 79,
+	spx5_stats_rx_bad_bytes_cnt = 80,
+	spx5_stats_pmac_rx_bad_bytes_cnt = 81,
+	spx5_stats_rx_in_bytes_cnt = 82,
+	spx5_stats_rx_ipg_shrink_cnt = 83,
+	spx5_stats_rx_sync_lost_err_cnt = 84,
+	spx5_stats_rx_tagged_frms_cnt = 85,
+	spx5_stats_rx_untagged_frms_cnt = 86,
+	spx5_stats_tx_out_bytes_cnt = 87,
+	spx5_stats_tx_tagged_frms_cnt = 88,
+	spx5_stats_tx_untagged_frms_cnt = 89,
+	spx5_stats_rx_hih_cksm_err_cnt = 90,
+	spx5_stats_pmac_rx_hih_cksm_err_cnt = 91,
+	spx5_stats_rx_xgmii_prot_err_cnt = 92,
+	spx5_stats_pmac_rx_xgmii_prot_err_cnt = 93,
+	spx5_stats_ana_ac_port_stat_lsb_cnt = 94,
+	spx5_stats_green_p0_rx_fwd = 95,
+	spx5_stats_green_p0_rx_port_drop = 111,
+	spx5_stats_green_p0_tx_port = 127,
+	spx5_stats_rx_local_drop = 143,
+	spx5_stats_tx_local_drop = 144,
+	spx5_stats_count = 145,
+};
+
+static const char *const sparx5_stats_layout[] = {
+	"mm_rx_assembly_err_cnt",
+	"mm_rx_assembly_ok_cnt",
+	"mm_rx_merge_frag_cnt",
+	"mm_rx_smd_err_cnt",
+	"mm_tx_pfragment_cnt",
+	"rx_bad_bytes_cnt",
+	"pmac_rx_bad_bytes_cnt",
+	"rx_in_bytes_cnt",
+	"rx_ipg_shrink_cnt",
+	"rx_sync_lost_err_cnt",
+	"rx_tagged_frms_cnt",
+	"rx_untagged_frms_cnt",
+	"tx_out_bytes_cnt",
+	"tx_tagged_frms_cnt",
+	"tx_untagged_frms_cnt",
+	"rx_hih_cksm_err_cnt",
+	"pmac_rx_hih_cksm_err_cnt",
+	"rx_xgmii_prot_err_cnt",
+	"pmac_rx_xgmii_prot_err_cnt",
+	"rx_port_policer_drop",
+	"rx_fwd_green_p0",
+	"rx_fwd_green_p1",
+	"rx_fwd_green_p2",
+	"rx_fwd_green_p3",
+	"rx_fwd_green_p4",
+	"rx_fwd_green_p5",
+	"rx_fwd_green_p6",
+	"rx_fwd_green_p7",
+	"rx_fwd_yellow_p0",
+	"rx_fwd_yellow_p1",
+	"rx_fwd_yellow_p2",
+	"rx_fwd_yellow_p3",
+	"rx_fwd_yellow_p4",
+	"rx_fwd_yellow_p5",
+	"rx_fwd_yellow_p6",
+	"rx_fwd_yellow_p7",
+	"rx_port_drop_green_p0",
+	"rx_port_drop_green_p1",
+	"rx_port_drop_green_p2",
+	"rx_port_drop_green_p3",
+	"rx_port_drop_green_p4",
+	"rx_port_drop_green_p5",
+	"rx_port_drop_green_p6",
+	"rx_port_drop_green_p7",
+	"rx_port_drop_yellow_p0",
+	"rx_port_drop_yellow_p1",
+	"rx_port_drop_yellow_p2",
+	"rx_port_drop_yellow_p3",
+	"rx_port_drop_yellow_p4",
+	"rx_port_drop_yellow_p5",
+	"rx_port_drop_yellow_p6",
+	"rx_port_drop_yellow_p7",
+	"tx_port_green_p0",
+	"tx_port_green_p1",
+	"tx_port_green_p2",
+	"tx_port_green_p3",
+	"tx_port_green_p4",
+	"tx_port_green_p5",
+	"tx_port_green_p6",
+	"tx_port_green_p7",
+	"tx_port_yellow_p0",
+	"tx_port_yellow_p1",
+	"tx_port_yellow_p2",
+	"tx_port_yellow_p3",
+	"tx_port_yellow_p4",
+	"tx_port_yellow_p5",
+	"tx_port_yellow_p6",
+	"tx_port_yellow_p7",
+	"rx_local_drop",
+	"tx_local_drop",
+};
+
+static void sparx5_get_queue_sys_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats;
+	u64 *stats;
+	u32 addr;
+	int idx;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	mutex_lock(&sparx5->queue_stats_lock);
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(portno), sparx5, XQS_STAT_CFG);
+	addr = 0;
+	stats = &portstats[spx5_stats_green_p0_rx_fwd];
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++addr, ++stats)
+		sparx5_update_counter(stats, spx5_rd(sparx5, XQS_CNT(addr)));
+	addr = 16;
+	stats = &portstats[spx5_stats_green_p0_rx_port_drop];
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++addr, ++stats)
+		sparx5_update_counter(stats, spx5_rd(sparx5, XQS_CNT(addr)));
+	addr = 256;
+	stats = &portstats[spx5_stats_green_p0_tx_port];
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++addr, ++stats)
+		sparx5_update_counter(stats, spx5_rd(sparx5, XQS_CNT(addr)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(32)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(272)));
+	mutex_unlock(&sparx5->queue_stats_lock);
+}
+
+static void sparx5_get_ana_ac_stats_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+
+	sparx5_update_counter(&portstats[spx5_stats_ana_ac_port_stat_lsb_cnt],
+			      spx5_rd(sparx5, ANA_AC_PORT_STAT_LSB_CNT(portno,
+								       SPX5_PORT_POLICER_DROPS)));
+}
+
+static void sparx5_get_dev_phy_stats(u64 *portstats, void __iomem *inst, u32
+				     tinst)
+{
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SYMBOL_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SYMBOL_ERR_CNT(tinst)));
+}
+
+static void sparx5_get_dev_mac_stats(u64 *portstats, void __iomem *inst, u32
+				     tinst)
+{
+	sparx5_update_counter(&portstats[spx5_stats_tx_uc_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_uc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_mc_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_bc_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_uc_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_uc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_mc_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bc_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_alignment_lost_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_ALIGNMENT_LOST_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_alignment_lost_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_ALIGNMENT_LOST_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_mc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_bc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_mc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bc_cnt],
+			      spx5_inst_rd(inst, DEV5G_PMAC_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_in_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_out_of_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_out_of_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OVERSIZE_CNT(tinst)));
+}
+
+static void sparx5_get_dev_mac_ctrl_stats(u64 *portstats, void __iomem *inst,
+					  u32 tinst)
+{
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_UNSUP_OPCODE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(tinst)));
+}
+
+static void sparx5_get_dev_rmon_stats(u64 *portstats, void __iomem *inst, u32
+				      tinst)
+{
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64_cnt],
+			      spx5_inst_rd(inst, DEV5G_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE1519TOMAX_CNT(tinst)));
+}
+
+static void sparx5_get_dev_misc_stats(u64 *portstats, void __iomem *inst, u32
+				      tinst)
+{
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_assembly_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_MM_RX_ASSEMBLY_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_assembly_ok_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_MM_RX_ASSEMBLY_OK_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_merge_frag_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_MM_RX_MERGE_FRAG_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_smd_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_MM_RX_SMD_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_tx_pfragment_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_MM_TX_PFRAGMENT_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes_cnt],
+			      spx5_inst_rd(inst, DEV5G_RX_IN_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ipg_shrink_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_IPG_SHRINK_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_tagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_TAGGED_FRMS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_untagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_UNTAGGED_FRMS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_OUT_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_tagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_TAGGED_FRMS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_untagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_UNTAGGED_FRMS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_hih_cksm_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_HIH_CKSM_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_hih_cksm_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_HIH_CKSM_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_xgmii_prot_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_XGMII_PROT_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_xgmii_prot_err_cnt],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_XGMII_PROT_ERR_CNT(tinst)));
+}
+
+static void sparx5_get_device_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	u32 tinst = sparx5_port_dev_index(portno);
+	u32 dev = sparx5_to_high_dev(portno);
+	void __iomem *inst;
+
+	inst = spx5_inst_get(sparx5, dev, tinst);
+	sparx5_get_dev_phy_stats(portstats, inst, tinst);
+	sparx5_get_dev_mac_stats(portstats, inst, tinst);
+	sparx5_get_dev_mac_ctrl_stats(portstats, inst, tinst);
+	sparx5_get_dev_rmon_stats(portstats, inst, tinst);
+	sparx5_get_dev_misc_stats(portstats, inst, tinst);
+}
+
+static void sparx5_get_asm_phy_stats(u64 *portstats, void __iomem *inst, int
+				     portno)
+{
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SYMBOL_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SYMBOL_ERR_CNT(portno)));
+}
+
+static void sparx5_get_asm_mac_stats(u64 *portstats, void __iomem *inst, int
+				     portno)
+{
+	sparx5_update_counter(&portstats[spx5_stats_tx_uc_cnt],
+			      spx5_inst_rd(inst, ASM_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_uc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_mc_cnt],
+			      spx5_inst_rd(inst, ASM_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_bc_cnt],
+			      spx5_inst_rd(inst, ASM_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_backoff1_cnt],
+			      spx5_inst_rd(inst, ASM_TX_BACKOFF1_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multi_coll_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_MULTI_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_uc_cnt],
+			      spx5_inst_rd(inst, ASM_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_uc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_mc_cnt],
+			      spx5_inst_rd(inst, ASM_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bc_cnt],
+			      spx5_inst_rd(inst, ASM_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err_cnt],
+			      spx5_inst_rd(inst, ASM_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_alignment_lost_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_ALIGNMENT_LOST_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_alignment_lost_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_ALIGNMENT_LOST_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes_cnt],
+			      spx5_inst_rd(inst, ASM_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_defer_cnt],
+			      spx5_inst_rd(inst, ASM_TX_DEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_late_coll_cnt],
+			      spx5_inst_rd(inst, ASM_TX_LATE_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xcoll_cnt],
+			      spx5_inst_rd(inst, ASM_TX_XCOLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_csense_cnt],
+			      spx5_inst_rd(inst, ASM_TX_CSENSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes_cnt],
+			      spx5_inst_rd(inst, ASM_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_mc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_bc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xdefer_cnt],
+			      spx5_inst_rd(inst, ASM_TX_XDEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_mc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bc_cnt],
+			      spx5_inst_rd(inst, ASM_PMAC_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_in_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_out_of_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_out_of_range_len_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize_cnt],
+			      spx5_inst_rd(inst, ASM_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OVERSIZE_CNT(portno)));
+}
+
+static void sparx5_get_asm_mac_ctrl_stats(u64 *portstats, void __iomem *inst,
+					  int portno)
+{
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause_cnt],
+			      spx5_inst_rd(inst, ASM_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause_cnt],
+			      spx5_inst_rd(inst, ASM_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_UNSUP_OPCODE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UNSUP_OPCODE_CNT(portno)));
+}
+
+static void sparx5_get_asm_rmon_stats(u64 *portstats, void __iomem *inst, int
+				      portno)
+{
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize_cnt],
+			      spx5_inst_rd(inst, ASM_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize_cnt],
+			      spx5_inst_rd(inst, ASM_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments_cnt],
+			      spx5_inst_rd(inst, ASM_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers_cnt],
+			      spx5_inst_rd(inst, ASM_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64_cnt],
+			      spx5_inst_rd(inst, ASM_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64_cnt],
+			      spx5_inst_rd(inst, ASM_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65to127_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128to255_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256to511_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512to1023_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024to1518_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519tomax_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE1519TOMAX_CNT(portno)));
+}
+
+static void sparx5_get_asm_misc_stats(u64 *portstats, void __iomem *inst, int
+				      portno)
+{
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_assembly_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_MM_RX_ASSEMBLY_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_assembly_ok_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_MM_RX_ASSEMBLY_OK_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_merge_frag_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_MM_RX_MERGE_FRAG_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_rx_smd_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_MM_RX_SMD_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_mm_tx_pfragment_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_MM_TX_PFRAGMENT_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes_cnt],
+			      spx5_inst_rd(inst, ASM_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes_cnt],
+			      spx5_inst_rd(inst, ASM_RX_IN_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ipg_shrink_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_IPG_SHRINK_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_sync_lost_err_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SYNC_LOST_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_tagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_TAGGED_FRMS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_untagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_RX_UNTAGGED_FRMS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes_cnt],
+			      spx5_inst_rd(inst, ASM_TX_OUT_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_tagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_TAGGED_FRMS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_untagged_frms_cnt],
+			      spx5_inst_rd(inst,
+					   ASM_TX_UNTAGGED_FRMS_CNT(portno)));
+}
+
+static void sparx5_get_asm_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	void __iomem *inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+
+	sparx5_get_asm_phy_stats(portstats, inst, portno);
+	sparx5_get_asm_mac_stats(portstats, inst, portno);
+	sparx5_get_asm_mac_ctrl_stats(portstats, inst, portno);
+	sparx5_get_asm_rmon_stats(portstats, inst, portno);
+	sparx5_get_asm_misc_stats(portstats, inst, portno);
+}
+
+static const struct ethtool_rmon_hist_range sparx5_rmon_ranges[] = {
+	{    0,    64 },
+	{   65,   127 },
+	{  128,   255 },
+	{  256,   511 },
+	{  512,  1023 },
+	{ 1024,  1518 },
+	{ 1519, 10239 },
+	{}
+};
+
+static void sparx5_get_eth_phy_stats(struct net_device *ndev,
+				     struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	void __iomem *inst;
+	u64 *portstats;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	if (sparx5_is_high_speed_device(&port->conf)) {
+		u32 tinst = sparx5_port_dev_index(portno);
+		u32 dev = sparx5_to_high_dev(portno);
+
+		inst = spx5_inst_get(sparx5, dev, tinst);
+		sparx5_get_dev_phy_stats(portstats, inst, tinst);
+	} else {
+		inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+		sparx5_get_asm_phy_stats(portstats, inst, portno);
+	}
+	phy_stats->SymbolErrorDuringCarrier =
+		portstats[spx5_stats_rx_symbol_err_cnt] +
+		portstats[spx5_stats_pmac_rx_symbol_err_cnt];
+}
+
+static void sparx5_get_eth_mac_stats(struct net_device *ndev,
+				     struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	void __iomem *inst;
+	u64 *portstats;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	if (sparx5_is_high_speed_device(&port->conf)) {
+		u32 tinst = sparx5_port_dev_index(portno);
+		u32 dev = sparx5_to_high_dev(portno);
+
+		inst = spx5_inst_get(sparx5, dev, tinst);
+		sparx5_get_dev_mac_stats(portstats, inst, tinst);
+	} else {
+		inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+		sparx5_get_asm_mac_stats(portstats, inst, portno);
+	}
+	mac_stats->FramesTransmittedOK = portstats[spx5_stats_tx_uc_cnt] +
+		portstats[spx5_stats_pmac_tx_uc_cnt] +
+		portstats[spx5_stats_tx_mc_cnt] +
+		portstats[spx5_stats_tx_bc_cnt];
+	mac_stats->SingleCollisionFrames =
+		portstats[spx5_stats_tx_backoff1_cnt];
+	mac_stats->MultipleCollisionFrames =
+		portstats[spx5_stats_tx_multi_coll_cnt];
+	mac_stats->FramesReceivedOK = portstats[spx5_stats_rx_uc_cnt] +
+		portstats[spx5_stats_pmac_rx_uc_cnt] +
+		portstats[spx5_stats_rx_mc_cnt] +
+		portstats[spx5_stats_rx_bc_cnt];
+	mac_stats->FrameCheckSequenceErrors =
+		portstats[spx5_stats_rx_crc_err_cnt] +
+		portstats[spx5_stats_pmac_rx_crc_err_cnt];
+	mac_stats->AlignmentErrors = portstats[spx5_stats_rx_alignment_lost_cnt]
+		+ portstats[spx5_stats_pmac_rx_alignment_lost_cnt];
+	mac_stats->OctetsTransmittedOK = portstats[spx5_stats_tx_ok_bytes_cnt] +
+		portstats[spx5_stats_pmac_tx_ok_bytes_cnt];
+	mac_stats->FramesWithDeferredXmissions =
+		portstats[spx5_stats_tx_defer_cnt];
+	mac_stats->LateCollisions =
+		portstats[spx5_stats_tx_late_coll_cnt];
+	mac_stats->FramesAbortedDueToXSColls =
+		portstats[spx5_stats_tx_xcoll_cnt];
+	mac_stats->CarrierSenseErrors = portstats[spx5_stats_tx_csense_cnt];
+	mac_stats->OctetsReceivedOK = portstats[spx5_stats_rx_ok_bytes_cnt] +
+		portstats[spx5_stats_pmac_rx_ok_bytes_cnt];
+	mac_stats->MulticastFramesXmittedOK = portstats[spx5_stats_tx_mc_cnt] +
+		portstats[spx5_stats_pmac_tx_mc_cnt];
+	mac_stats->BroadcastFramesXmittedOK = portstats[spx5_stats_tx_bc_cnt] +
+		portstats[spx5_stats_pmac_tx_bc_cnt];
+	mac_stats->FramesWithExcessiveDeferral =
+		portstats[spx5_stats_tx_xdefer_cnt];
+	mac_stats->MulticastFramesReceivedOK = portstats[spx5_stats_rx_mc_cnt] +
+		portstats[spx5_stats_pmac_rx_mc_cnt];
+	mac_stats->BroadcastFramesReceivedOK = portstats[spx5_stats_rx_bc_cnt] +
+		portstats[spx5_stats_pmac_rx_bc_cnt];
+	mac_stats->InRangeLengthErrors =
+		portstats[spx5_stats_rx_in_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_in_range_len_err_cnt];
+	mac_stats->OutOfRangeLengthField =
+		portstats[spx5_stats_rx_out_of_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_out_of_range_len_err_cnt];
+	mac_stats->FrameTooLongErrors = portstats[spx5_stats_rx_oversize_cnt] +
+		portstats[spx5_stats_pmac_rx_oversize_cnt];
+}
+
+static void sparx5_get_eth_mac_ctrl_stats(struct net_device *ndev,
+					  struct ethtool_eth_ctrl_stats *mac_ctrl_stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	void __iomem *inst;
+	u64 *portstats;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	if (sparx5_is_high_speed_device(&port->conf)) {
+		u32 tinst = sparx5_port_dev_index(portno);
+		u32 dev = sparx5_to_high_dev(portno);
+
+		inst = spx5_inst_get(sparx5, dev, tinst);
+		sparx5_get_dev_mac_ctrl_stats(portstats, inst, tinst);
+	} else {
+		inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+		sparx5_get_asm_mac_ctrl_stats(portstats, inst, portno);
+	}
+	mac_ctrl_stats->MACControlFramesTransmitted =
+		portstats[spx5_stats_tx_pause_cnt] +
+		portstats[spx5_stats_pmac_tx_pause_cnt];
+	mac_ctrl_stats->MACControlFramesReceived =
+		portstats[spx5_stats_rx_pause_cnt] +
+		portstats[spx5_stats_pmac_rx_pause_cnt];
+	mac_ctrl_stats->UnsupportedOpcodesReceived =
+		portstats[spx5_stats_rx_unsup_opcode_cnt] +
+		portstats[spx5_stats_pmac_rx_unsup_opcode_cnt];
+}
+
+static void sparx5_get_eth_rmon_stats(struct net_device *ndev,
+				      struct ethtool_rmon_stats *rmon_stats,
+				      const struct ethtool_rmon_hist_range **ranges)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	void __iomem *inst;
+	u64 *portstats;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	if (sparx5_is_high_speed_device(&port->conf)) {
+		u32 tinst = sparx5_port_dev_index(portno);
+		u32 dev = sparx5_to_high_dev(portno);
+
+		inst = spx5_inst_get(sparx5, dev, tinst);
+		sparx5_get_dev_rmon_stats(portstats, inst, tinst);
+	} else {
+		inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+		sparx5_get_asm_rmon_stats(portstats, inst, portno);
+	}
+	rmon_stats->undersize_pkts = portstats[spx5_stats_rx_undersize_cnt] +
+		portstats[spx5_stats_pmac_rx_undersize_cnt];
+	rmon_stats->oversize_pkts = portstats[spx5_stats_rx_oversize_cnt] +
+		portstats[spx5_stats_pmac_rx_oversize_cnt];
+	rmon_stats->fragments = portstats[spx5_stats_rx_fragments_cnt] +
+		portstats[spx5_stats_pmac_rx_fragments_cnt];
+	rmon_stats->jabbers = portstats[spx5_stats_rx_jabbers_cnt] +
+		portstats[spx5_stats_pmac_rx_jabbers_cnt];
+	rmon_stats->hist[0] = portstats[spx5_stats_rx_size64_cnt] +
+		portstats[spx5_stats_pmac_rx_size64_cnt];
+	rmon_stats->hist[1] = portstats[spx5_stats_rx_size65to127_cnt] +
+		portstats[spx5_stats_pmac_rx_size65to127_cnt];
+	rmon_stats->hist[2] = portstats[spx5_stats_rx_size128to255_cnt] +
+		portstats[spx5_stats_pmac_rx_size128to255_cnt];
+	rmon_stats->hist[3] = portstats[spx5_stats_rx_size256to511_cnt] +
+		portstats[spx5_stats_pmac_rx_size256to511_cnt];
+	rmon_stats->hist[4] = portstats[spx5_stats_rx_size512to1023_cnt] +
+		portstats[spx5_stats_pmac_rx_size512to1023_cnt];
+	rmon_stats->hist[5] = portstats[spx5_stats_rx_size1024to1518_cnt] +
+		portstats[spx5_stats_pmac_rx_size1024to1518_cnt];
+	rmon_stats->hist[6] = portstats[spx5_stats_rx_size1519tomax_cnt] +
+		portstats[spx5_stats_pmac_rx_size1519tomax_cnt];
+	rmon_stats->hist_tx[0] = portstats[spx5_stats_tx_size64_cnt] +
+		portstats[spx5_stats_pmac_tx_size64_cnt];
+	rmon_stats->hist_tx[1] = portstats[spx5_stats_tx_size65to127_cnt] +
+		portstats[spx5_stats_pmac_tx_size65to127_cnt];
+	rmon_stats->hist_tx[2] = portstats[spx5_stats_tx_size128to255_cnt] +
+		portstats[spx5_stats_pmac_tx_size128to255_cnt];
+	rmon_stats->hist_tx[3] = portstats[spx5_stats_tx_size256to511_cnt] +
+		portstats[spx5_stats_pmac_tx_size256to511_cnt];
+	rmon_stats->hist_tx[4] = portstats[spx5_stats_tx_size512to1023_cnt] +
+		portstats[spx5_stats_pmac_tx_size512to1023_cnt];
+	rmon_stats->hist_tx[5] = portstats[spx5_stats_tx_size1024to1518_cnt] +
+		portstats[spx5_stats_pmac_tx_size1024to1518_cnt];
+	rmon_stats->hist_tx[6] = portstats[spx5_stats_tx_size1519tomax_cnt] +
+		portstats[spx5_stats_pmac_tx_size1519tomax_cnt];
+	*ranges = sparx5_rmon_ranges;
+}
+
+static int sparx5_get_sset_count(struct net_device *ndev, int sset)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+	return sparx5->num_ethtool_stats;
+}
+
+static void sparx5_get_sset_strings(struct net_device *ndev, u32 sset, u8 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+	int idx;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (idx = 0; idx < sparx5->num_ethtool_stats; idx++)
+		strncpy(data + idx * ETH_GSTRING_LEN,
+			sparx5->stats_layout[idx], ETH_GSTRING_LEN);
+}
+
+static void sparx5_get_sset_data(struct net_device *ndev,
+				 struct ethtool_stats *stats, u64 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	void __iomem *inst;
+	u64 *portstats;
+	int idx;
+
+	portstats = &sparx5->stats[portno * sparx5->num_stats];
+	if (sparx5_is_high_speed_device(&port->conf)) {
+		u32 tinst = sparx5_port_dev_index(portno);
+		u32 dev = sparx5_to_high_dev(portno);
+
+		inst = spx5_inst_get(sparx5, dev, tinst);
+		sparx5_get_dev_misc_stats(portstats, inst, tinst);
+	} else {
+		inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+		sparx5_get_asm_misc_stats(portstats, inst, portno);
+	}
+	sparx5_get_ana_ac_stats_stats(sparx5, portno);
+	sparx5_get_queue_sys_stats(sparx5, portno);
+	/* Copy port counters to the ethtool buffer */
+	for (idx = spx5_stats_mm_rx_assembly_err_cnt;
+	     idx < spx5_stats_mm_rx_assembly_err_cnt +
+	     sparx5->num_ethtool_stats; idx++)
+		*data++ = portstats[idx];
+}
+
+void sparx5_get_stats64(struct net_device *ndev,
+			struct rtnl_link_stats64 *stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u64 *portstats;
+	int idx;
+
+	if (!sparx5->stats)
+		return; /* Not initialized yet */
+
+	portstats = &sparx5->stats[port->portno * sparx5->num_stats];
+
+	stats->rx_packets = portstats[spx5_stats_rx_uc_cnt] +
+		portstats[spx5_stats_pmac_rx_uc_cnt] +
+		portstats[spx5_stats_rx_mc_cnt] +
+		portstats[spx5_stats_rx_bc_cnt];
+	stats->tx_packets = portstats[spx5_stats_tx_uc_cnt] +
+		portstats[spx5_stats_pmac_tx_uc_cnt] +
+		portstats[spx5_stats_tx_mc_cnt] +
+		portstats[spx5_stats_tx_bc_cnt];
+	stats->rx_bytes = portstats[spx5_stats_rx_ok_bytes_cnt] +
+		portstats[spx5_stats_pmac_rx_ok_bytes_cnt];
+	stats->tx_bytes = portstats[spx5_stats_tx_ok_bytes_cnt] +
+		portstats[spx5_stats_pmac_tx_ok_bytes_cnt];
+	stats->rx_errors = portstats[spx5_stats_rx_in_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_in_range_len_err_cnt] +
+		portstats[spx5_stats_rx_out_of_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_out_of_range_len_err_cnt] +
+		portstats[spx5_stats_rx_oversize_cnt] +
+		portstats[spx5_stats_pmac_rx_oversize_cnt] +
+		portstats[spx5_stats_rx_crc_err_cnt] +
+		portstats[spx5_stats_pmac_rx_crc_err_cnt] +
+		portstats[spx5_stats_rx_alignment_lost_cnt] +
+		portstats[spx5_stats_pmac_rx_alignment_lost_cnt];
+	stats->tx_errors = portstats[spx5_stats_tx_xcoll_cnt] +
+		portstats[spx5_stats_tx_csense_cnt] +
+		portstats[spx5_stats_tx_late_coll_cnt];
+	stats->multicast = portstats[spx5_stats_rx_mc_cnt] +
+		portstats[spx5_stats_pmac_rx_mc_cnt];
+	stats->collisions = portstats[spx5_stats_tx_late_coll_cnt] +
+		portstats[spx5_stats_tx_xcoll_cnt] +
+		portstats[spx5_stats_tx_backoff1_cnt];
+	stats->rx_length_errors = portstats[spx5_stats_rx_in_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_in_range_len_err_cnt] +
+		portstats[spx5_stats_rx_out_of_range_len_err_cnt] +
+		portstats[spx5_stats_pmac_rx_out_of_range_len_err_cnt] +
+		portstats[spx5_stats_rx_oversize_cnt] +
+		portstats[spx5_stats_pmac_rx_oversize_cnt];
+	stats->rx_crc_errors = portstats[spx5_stats_rx_crc_err_cnt] +
+		portstats[spx5_stats_pmac_rx_crc_err_cnt];
+	stats->rx_frame_errors = portstats[spx5_stats_rx_alignment_lost_cnt] +
+		portstats[spx5_stats_pmac_rx_alignment_lost_cnt];
+	stats->tx_aborted_errors = portstats[spx5_stats_tx_xcoll_cnt];
+	stats->tx_carrier_errors = portstats[spx5_stats_tx_csense_cnt];
+	stats->tx_window_errors = portstats[spx5_stats_tx_late_coll_cnt];
+	stats->rx_dropped = portstats[spx5_stats_ana_ac_port_stat_lsb_cnt];
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++stats)
+		stats->rx_dropped += portstats[spx5_stats_green_p0_rx_port_drop
+					       + idx];
+	stats->tx_dropped = portstats[spx5_stats_tx_local_drop];
+}
+
+static void sparx5_update_port_stats(struct sparx5 *sparx5, int portno)
+{
+	if (sparx5_is_high_speed_device(&sparx5->ports[portno]->conf))
+		sparx5_get_device_stats(sparx5, portno);
+	else
+		sparx5_get_asm_stats(sparx5, portno);
+	sparx5_get_ana_ac_stats_stats(sparx5, portno);
+	sparx5_get_queue_sys_stats(sparx5, portno);
+}
+
+static void sparx5_update_stats(struct sparx5 *sparx5)
+{
+	int idx;
+
+	for (idx = 0; idx < SPX5_PORTS; idx++)
+		if (sparx5->ports[idx])
+			sparx5_update_port_stats(sparx5, idx);
+}
+
+static void sparx5_check_stats_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sparx5 *sparx5 = container_of(dwork,
+					     struct sparx5,
+					     stats_work);
+
+	sparx5_update_stats(sparx5);
+
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+}
+
+static int sparx5_get_link_settings(struct net_device *ndev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(port->phylink, cmd);
+}
+
+static int sparx5_set_link_settings(struct net_device *ndev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(port->phylink, cmd);
+}
+
+static void sparx5_config_stats(struct sparx5 *sparx5)
+{
+	/* Enable global events for port policer drops */
+	spx5_rmw(ANA_AC_PORT_SGE_CFG_MASK_SET(0xf0f0),
+		 ANA_AC_PORT_SGE_CFG_MASK,
+		 sparx5,
+		 ANA_AC_PORT_SGE_CFG(SPX5_PORT_POLICER_DROPS));
+}
+
+static void sparx5_config_port_stats(struct sparx5 *sparx5, int portno)
+{
+	/* Clear Queue System counters */
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(portno) |
+		XQS_STAT_CFG_STAT_CLEAR_SHOT_SET(3), sparx5,
+		XQS_STAT_CFG);
+
+	/* Use counter for port policer drop count */
+	spx5_rmw(ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE_SET(1) |
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE_SET(0) |
+		 ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK_SET(0xff),
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE |
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE |
+		 ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK,
+		 sparx5, ANA_AC_PORT_STAT_CFG(portno, SPX5_PORT_POLICER_DROPS));
+}
+
+const struct ethtool_ops sparx5_ethtool_ops = {
+	.get_sset_count         = sparx5_get_sset_count,
+	.get_strings            = sparx5_get_sset_strings,
+	.get_ethtool_stats      = sparx5_get_sset_data,
+	.get_link_ksettings	= sparx5_get_link_settings,
+	.set_link_ksettings	= sparx5_set_link_settings,
+	.get_link               = ethtool_op_get_link,
+	.get_eth_phy_stats      = sparx5_get_eth_phy_stats,
+	.get_eth_mac_stats      = sparx5_get_eth_mac_stats,
+	.get_eth_ctrl_stats     = sparx5_get_eth_mac_ctrl_stats,
+	.get_rmon_stats         = sparx5_get_eth_rmon_stats,
+};
+
+int sparx_stats_init(struct sparx5 *sparx5)
+{
+	char queue_name[32];
+	int portno;
+
+	sparx5->stats_layout = sparx5_stats_layout;
+	sparx5->num_stats = spx5_stats_count;
+	sparx5->num_ethtool_stats = ARRAY_SIZE(sparx5_stats_layout);
+	sparx5->stats = devm_kcalloc(sparx5->dev,
+				     SPX5_PORTS_ALL * sparx5->num_stats,
+				     sizeof(u64), GFP_KERNEL);
+	if (!sparx5->stats)
+		return -ENOMEM;
+
+	mutex_init(&sparx5->queue_stats_lock);
+	sparx5_config_stats(sparx5);
+	for (portno = 0; portno < SPX5_PORTS; portno++)
+		if (sparx5->ports[portno])
+			sparx5_config_port_stats(sparx5, portno);
+
+	snprintf(queue_name, sizeof(queue_name), "%s-stats",
+		 dev_name(sparx5->dev));
+	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index dec66776371b..92f9dd204c3b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -623,6 +623,10 @@ static int sparx5_start(struct sparx5 *sparx5)
 	if (err)
 		return err;
 
+	/* Init stats */
+	err = sparx_stats_init(sparx5);
+	if (err)
+		return err;
 
 	/* Init mact_sw struct */
 	mutex_init(&sparx5->mact_lock);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 29b969891dfd..8b91f671e635 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -135,6 +135,15 @@ struct sparx5 {
 	/* port structures are in net device */
 	struct sparx5_port *ports[SPX5_PORTS];
 	enum sparx5_core_clockfreq coreclock;
+	/* Statistics */
+	u32 num_stats;
+	u32 num_ethtool_stats;
+	const char * const *stats_layout;
+	u64 *stats;
+	/* Workqueue for reading stats */
+	struct mutex queue_stats_lock;
+	struct delayed_work stats_work;
+	struct workqueue_struct *stats_queue;
 	/* Notifiers */
 	struct notifier_block netdevice_nb;
 	struct notifier_block switchdev_nb;
@@ -203,6 +212,10 @@ void sparx5_vlan_port_apply(struct sparx5 *sparx5, struct sparx5_port *port);
 int sparx5_config_auto_calendar(struct sparx5 *sparx5);
 int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
 
+/* sparx5_ethtool.c */
+void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
+int sparx_stats_init(struct sparx5 *sparx5);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
@@ -224,6 +237,7 @@ static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 }
 
 extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
+extern const struct ethtool_ops sparx5_ethtool_ops;
 
 /* Calculate raw offset */
 static inline __pure int spx5_offset(int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index efef88bbd7fe..0a9da6897def 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -180,6 +180,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_get_stats64        = sparx5_get_stats64,
 	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
 };
 
@@ -206,6 +207,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	sparx5_set_port_ifh(spx5_port->ifh, portno);
 
 	ndev->netdev_ops = &sparx5_port_netdev_ops;
+	ndev->ethtool_ops = &sparx5_ethtool_ops;
 
 	val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
 	u64_to_ether_addr(val, ndev->dev_addr);
-- 
2.31.1

