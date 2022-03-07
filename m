Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1AF4CF5A4
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbiCGJaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiCGJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:29:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45F55BD19;
        Mon,  7 Mar 2022 01:27:21 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2278qQAo024110;
        Mon, 7 Mar 2022 01:26:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Vr4WJ0TqyrdxTM7x878OAAVTjR6l2Yl7dve7XWI9TTk=;
 b=FAC2xZcuyWIOJcJe6B3lRY/UYnoONGFNVGNFE43jclIe9enFhAUeWCWC5r80p65V4XAk
 IT4KQ6fpgZzNih806ESV/tXUKJXfjBhBeBmkPTClOQewEldb3Gx8ooKLG1jlRr3roJdz
 2FfC5FLdIvfv+VSTUizTJcF+Zj4pu6WjPceEFcBaLb1jaCuIJwgTFYO6t2aEXT+0dSgh
 oJfHgEHp2sqg5UJNF0pbArDfGclpRYXUVPjBVe0UdorYGzefKHSLP/f5oU5y6l4zzE6m
 fR3cQi0HhquWFHZOaPaHP9sETyX4oIOKWjaEaSQmNbksMVcc7iSGXYGoSWPDtSIRn447 nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3em88re1h5-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 01:26:54 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Mar
 2022 01:26:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 01:26:51 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 569B13F7040;
        Mon,  7 Mar 2022 01:26:51 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [PATCH v3 7/7] octeon_ep: add ethtool support for Octeon PCI Endpoint NIC
Date:   Mon, 7 Mar 2022 01:26:46 -0800
Message-ID: <20220307092646.17156-8-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220307092646.17156-1-vburru@marvell.com>
References: <20220307092646.17156-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VoprWyqHmNygImxCu_u8fOHwEOSdcMI4
X-Proofpoint-GUID: VoprWyqHmNygImxCu_u8fOHwEOSdcMI4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_01,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following ethtool commands:

ethtool -i|--driver devname
ethtool devname
ethtool -s devname [speed N] [autoneg on|off] [advertise N]
ethtool -S|--statistics devname

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
V2 -> V3: no change.

V1 -> V2:
  - Fix build errors observed with clang and "make W=1 C=1".
  - Address review comments:
      - removed setting version string in get_drvinfo.
      - defined helper macro for common code to set supported and
        advertised modes in get_link_ksettings.

 .../net/ethernet/marvell/octeon_ep/Makefile   |   2 +-
 .../marvell/octeon_ep/octep_ethtool.c         | 463 ++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.c   |   1 +
 3 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c

diff --git a/drivers/net/ethernet/marvell/octeon_ep/Makefile b/drivers/net/ethernet/marvell/octeon_ep/Makefile
index 6e2db8e80b4a..2026c8118158 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/Makefile
+++ b/drivers/net/ethernet/marvell/octeon_ep/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OCTEON_EP) += octeon_ep.o
 
 octeon_ep-y := octep_main.o octep_cn9k_pf.o octep_tx.o octep_rx.o \
-	       octep_ctrl_mbox.o octep_ctrl_net.o
+	       octep_ethtool.o octep_ctrl_mbox.o octep_ctrl_net.o
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
new file mode 100644
index 000000000000..5c3b52c375cb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
@@ -0,0 +1,463 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+#include "octep_ctrl_net.h"
+
+static const char octep_gstrings_global_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets",
+	"tx_packets",
+	"rx_bytes",
+	"tx_bytes",
+	"rx_alloc_errors",
+	"tx_busy_errors",
+	"rx_dropped",
+	"tx_dropped",
+	"tx_hw_pkts",
+	"tx_hw_octs",
+	"tx_hw_bcast",
+	"tx_hw_mcast",
+	"tx_hw_underflow",
+	"tx_hw_control",
+	"tx_less_than_64",
+	"tx_equal_64",
+	"tx_equal_65_to_127",
+	"tx_equal_128_to_255",
+	"tx_equal_256_to_511",
+	"tx_equal_512_to_1023",
+	"tx_equal_1024_to_1518",
+	"tx_greater_than_1518",
+	"rx_hw_pkts",
+	"rx_hw_bytes",
+	"rx_hw_bcast",
+	"rx_hw_mcast",
+	"rx_pause_pkts",
+	"rx_pause_bytes",
+	"rx_dropped_pkts_fifo_full",
+	"rx_dropped_bytes_fifo_full",
+	"rx_err_pkts",
+};
+
+#define OCTEP_GLOBAL_STATS_CNT (sizeof(octep_gstrings_global_stats) / ETH_GSTRING_LEN)
+
+static const char octep_gstrings_tx_q_stats[][ETH_GSTRING_LEN] = {
+	"tx_packets_posted[Q-%u]",
+	"tx_packets_completed[Q-%u]",
+	"tx_bytes[Q-%u]",
+	"tx_busy[Q-%u]",
+};
+
+#define OCTEP_TX_Q_STATS_CNT (sizeof(octep_gstrings_tx_q_stats) / ETH_GSTRING_LEN)
+
+static const char octep_gstrings_rx_q_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets[Q-%u]",
+	"rx_bytes[Q-%u]",
+	"rx_alloc_errors[Q-%u]",
+};
+
+#define OCTEP_RX_Q_STATS_CNT (sizeof(octep_gstrings_rx_q_stats) / ETH_GSTRING_LEN)
+
+static void octep_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *info)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+
+	strscpy(info->driver, OCTEP_DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(oct->pdev), sizeof(info->bus_info));
+}
+
+static void octep_get_strings(struct net_device *netdev,
+			      u32 stringset, u8 *data)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	u16 num_queues = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+	char *strings = (char *)data;
+	int i, j;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < OCTEP_GLOBAL_STATS_CNT; i++) {
+			snprintf(strings, ETH_GSTRING_LEN,
+				 octep_gstrings_global_stats[i]);
+			strings += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < num_queues; i++) {
+			for (j = 0; j < OCTEP_TX_Q_STATS_CNT; j++) {
+				snprintf(strings, ETH_GSTRING_LEN,
+					 octep_gstrings_tx_q_stats[j], i);
+				strings += ETH_GSTRING_LEN;
+			}
+		}
+
+		for (i = 0; i < num_queues; i++) {
+			for (j = 0; j < OCTEP_RX_Q_STATS_CNT; j++) {
+				snprintf(strings, ETH_GSTRING_LEN,
+					 octep_gstrings_rx_q_stats[j], i);
+				strings += ETH_GSTRING_LEN;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int octep_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	u16 num_queues = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return OCTEP_GLOBAL_STATS_CNT + (num_queues *
+		       (OCTEP_TX_Q_STATS_CNT + OCTEP_RX_Q_STATS_CNT));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void
+octep_get_ethtool_stats(struct net_device *netdev,
+			struct ethtool_stats *stats, u64 *data)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	struct octep_iface_tx_stats *iface_tx_stats;
+	struct octep_iface_rx_stats *iface_rx_stats;
+	u64 rx_packets, rx_bytes;
+	u64 tx_packets, tx_bytes;
+	u64 rx_alloc_errors, tx_busy_errors;
+	int q, i;
+
+	rx_packets = 0;
+	rx_bytes = 0;
+	tx_packets = 0;
+	tx_bytes = 0;
+	rx_alloc_errors = 0;
+	tx_busy_errors = 0;
+	tx_packets = 0;
+	tx_bytes = 0;
+	rx_packets = 0;
+	rx_bytes = 0;
+
+	octep_get_if_stats(oct);
+	iface_tx_stats = &oct->iface_tx_stats;
+	iface_rx_stats = &oct->iface_rx_stats;
+
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_iq *iq = oct->iq[q];
+		struct octep_oq *oq = oct->oq[q];
+
+		tx_packets += iq->stats.instr_completed;
+		tx_bytes += iq->stats.bytes_sent;
+		tx_busy_errors += iq->stats.tx_busy;
+
+		rx_packets += oq->stats.packets;
+		rx_bytes += oq->stats.bytes;
+		rx_alloc_errors += oq->stats.alloc_failures;
+	}
+	i = 0;
+	data[i++] = rx_packets;
+	data[i++] = tx_packets;
+	data[i++] = rx_bytes;
+	data[i++] = tx_bytes;
+	data[i++] = rx_alloc_errors;
+	data[i++] = tx_busy_errors;
+	data[i++] = iface_rx_stats->dropped_pkts_fifo_full +
+		    iface_rx_stats->err_pkts;
+	data[i++] = iface_tx_stats->xscol +
+		    iface_tx_stats->xsdef;
+	data[i++] = iface_tx_stats->pkts;
+	data[i++] = iface_tx_stats->octs;
+	data[i++] = iface_tx_stats->bcst;
+	data[i++] = iface_tx_stats->mcst;
+	data[i++] = iface_tx_stats->undflw;
+	data[i++] = iface_tx_stats->ctl;
+	data[i++] = iface_tx_stats->hist_lt64;
+	data[i++] = iface_tx_stats->hist_eq64;
+	data[i++] = iface_tx_stats->hist_65to127;
+	data[i++] = iface_tx_stats->hist_128to255;
+	data[i++] = iface_tx_stats->hist_256to511;
+	data[i++] = iface_tx_stats->hist_512to1023;
+	data[i++] = iface_tx_stats->hist_1024to1518;
+	data[i++] = iface_tx_stats->hist_gt1518;
+	data[i++] = iface_rx_stats->pkts;
+	data[i++] = iface_rx_stats->octets;
+	data[i++] = iface_rx_stats->mcast_pkts;
+	data[i++] = iface_rx_stats->bcast_pkts;
+	data[i++] = iface_rx_stats->pause_pkts;
+	data[i++] = iface_rx_stats->pause_octets;
+	data[i++] = iface_rx_stats->dropped_pkts_fifo_full;
+	data[i++] = iface_rx_stats->dropped_octets_fifo_full;
+	data[i++] = iface_rx_stats->err_pkts;
+
+	/* Per Tx Queue stats */
+	for (q = 0; q < oct->num_iqs; q++) {
+		struct octep_iq *iq = oct->iq[q];
+
+		data[i++] = iq->stats.instr_posted;
+		data[i++] = iq->stats.instr_completed;
+		data[i++] = iq->stats.bytes_sent;
+		data[i++] = iq->stats.tx_busy;
+	}
+
+	/* Per Rx Queue stats */
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_oq *oq = oct->oq[q];
+
+		data[i++] = oq->stats.packets;
+		data[i++] = oq->stats.bytes;
+		data[i++] = oq->stats.alloc_failures;
+	}
+}
+
+#define OCTEP_SET_ETHTOOL_LINK_MODES_BITMAP(octep_speeds, ksettings, name) \
+{ \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_T)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseT_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_R)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseR_FEC); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseCR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseKR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_LR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseLR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_10GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseSR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_25GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseCR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_25GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseKR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_25GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseSR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_40GBASE_CR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseCR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_40GBASE_KR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseKR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_40GBASE_LR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseLR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_40GBASE_SR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseSR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_CR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseCR2_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_KR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseKR2_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_SR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseSR2_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseCR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseKR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_LR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseLR_ER_FR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_50GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseSR_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_100GBASE_CR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseCR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_100GBASE_KR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseKR4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_100GBASE_LR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseLR4_ER4_Full); \
+	if ((octep_speeds) & BIT(OCTEP_LINK_MODE_100GBASE_SR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseSR4_Full); \
+}
+
+static int octep_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	struct octep_iface_link_info *link_info;
+	u32 advertised_modes, supported_modes;
+
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
+
+	octep_get_link_info(oct);
+
+	advertised_modes = oct->link_info.advertised_modes;
+	supported_modes = oct->link_info.supported_modes;
+	link_info = &oct->link_info;
+
+	OCTEP_SET_ETHTOOL_LINK_MODES_BITMAP(supported_modes, cmd, supported);
+	OCTEP_SET_ETHTOOL_LINK_MODES_BITMAP(advertised_modes, cmd, advertising);
+
+	if (link_info->autoneg) {
+		if (link_info->autoneg & OCTEP_LINK_MODE_AUTONEG_SUPPORTED)
+			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+		if (link_info->autoneg & OCTEP_LINK_MODE_AUTONEG_ADVERTISED) {
+			ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
+			cmd->base.autoneg = AUTONEG_ENABLE;
+		} else {
+			cmd->base.autoneg = AUTONEG_DISABLE;
+		}
+	} else {
+		cmd->base.autoneg = AUTONEG_DISABLE;
+	}
+
+	if (link_info->pause) {
+		if (link_info->pause & OCTEP_LINK_MODE_PAUSE_SUPPORTED)
+			ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+		if (link_info->pause & OCTEP_LINK_MODE_PAUSE_ADVERTISED)
+			ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+	}
+
+	cmd->base.port = PORT_FIBRE;
+	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, FIBRE);
+
+	if (netif_carrier_ok(netdev)) {
+		cmd->base.speed = link_info->speed;
+		cmd->base.duplex = DUPLEX_FULL;
+	} else {
+		cmd->base.speed = SPEED_UNKNOWN;
+		cmd->base.duplex = DUPLEX_UNKNOWN;
+	}
+	return 0;
+}
+
+static int octep_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	struct octep_iface_link_info link_info_new;
+	struct octep_iface_link_info *link_info;
+	u64 advertised = 0;
+	u8 autoneg = 0;
+	int err;
+
+	link_info = &oct->link_info;
+	memcpy(&link_info_new, link_info, sizeof(struct octep_iface_link_info));
+
+	/* Only Full duplex is supported;
+	 * Assume full duplex when duplex is unknown.
+	 */
+	if (cmd->base.duplex != DUPLEX_FULL &&
+	    cmd->base.duplex != DUPLEX_UNKNOWN)
+		return -EOPNOTSUPP;
+
+	if (cmd->base.autoneg == AUTONEG_ENABLE) {
+		if (!(link_info->autoneg & OCTEP_LINK_MODE_AUTONEG_SUPPORTED))
+			return -EOPNOTSUPP;
+		autoneg = 1;
+	}
+
+	if (!bitmap_subset(cmd->link_modes.advertising,
+			   cmd->link_modes.supported,
+			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
+
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseT_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_T);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseR_FEC))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_R);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseCR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_CR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseKR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_KR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseLR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_LR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  10000baseSR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_10GBASE_SR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  25000baseCR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_25GBASE_CR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  25000baseKR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_25GBASE_KR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  25000baseSR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_25GBASE_SR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  40000baseCR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_40GBASE_CR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  40000baseKR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_40GBASE_KR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  40000baseLR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_40GBASE_LR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  40000baseSR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_40GBASE_SR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseCR2_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_CR2);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseKR2_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_KR2);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseSR2_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_SR2);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseCR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_CR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseKR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_KR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseLR_ER_FR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_LR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  50000baseSR_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_50GBASE_SR);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  100000baseCR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_100GBASE_CR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  100000baseKR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_100GBASE_KR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  100000baseLR4_ER4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_100GBASE_LR4);
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+						  100000baseSR4_Full))
+		advertised |= BIT(OCTEP_LINK_MODE_100GBASE_SR4);
+
+	if (advertised == link_info->advertised_modes &&
+	    cmd->base.speed == link_info->speed &&
+	    cmd->base.autoneg == link_info->autoneg)
+		return 0;
+
+	link_info_new.advertised_modes = advertised;
+	link_info_new.speed = cmd->base.speed;
+	link_info_new.autoneg = autoneg;
+
+	err = octep_set_link_info(oct, &link_info_new);
+	if (err)
+		return err;
+
+	memcpy(link_info, &link_info_new, sizeof(struct octep_iface_link_info));
+	return 0;
+}
+
+const struct ethtool_ops octep_ethtool_ops = {
+	.get_drvinfo = octep_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_strings = octep_get_strings,
+	.get_sset_count = octep_get_sset_count,
+	.get_ethtool_stats = octep_get_ethtool_stats,
+	.get_link_ksettings = octep_get_link_ksettings,
+	.set_link_ksettings = octep_set_link_ksettings,
+};
+
+void octep_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &octep_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 1c9c00cc4641..31435c41e3f0 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1059,6 +1059,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
 
 	netdev->netdev_ops = &octep_netdev_ops;
+	octep_set_ethtool_ops(netdev);
 	netif_carrier_off(netdev);
 
 	netdev->hw_features = NETIF_F_SG;
-- 
2.17.1

