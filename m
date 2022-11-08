Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D82621DE6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKHUom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiKHUoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:44:02 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E92ADFF4;
        Tue,  8 Nov 2022 12:43:43 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8H0akd008591;
        Tue, 8 Nov 2022 12:43:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=MyaPjk7aFzhkK+cdFN8RiKyE2fvE2EKaWSXAosYokDc=;
 b=ihT3Q0Ccwd/UFZ79qdNbBylKUFVbL9yt26ildnchcGuYS9z+jw7g5aImFjAzYNrnKSTB
 SQDpNiqDPYky0XIS8jnK3ZWBR8oEWq5hru2omTHNZHlruB6+DQBvmO9wUPEQcUp5/fqV
 D7Nmr6ZSZf1iJFDzcOJHhrHkDG6P15x7PSvT0j+mZXv0ECaAMtOAB5mZ7jK/9LwJ85no
 rSeYSWuq4/3FAoVx9PcwgRyQp1hVe91DzDUjtzFQlf0sJhF2zXjb1lDuFki1KFp7tE6i
 LYMVufW6vfrbP/7eeJ258s5qCHP500t1EfxOOqSux6NNYVhVOj1Ofx8wQQD/QqYIwj2S UA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kqu4vh098-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:43:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Nov
 2022 12:43:36 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Nov 2022 12:43:36 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id BB5B53F7089;
        Tue,  8 Nov 2022 12:43:35 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 7/8] octeon_ep_vf: add ethtool support
Date:   Tue, 8 Nov 2022 12:41:58 -0800
Message-ID: <20221108204209.23071-8-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Rky8_HYmD4ib9Wv8ceHY9Yq5WV6sYcF6
X-Proofpoint-GUID: Rky8_HYmD4ib9Wv8ceHY9Yq5WV6sYcF6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following ethtool commands:

ethtool -i|--driver devname
ethtool devname
ethtool -S|--statistics devname

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
 .../ethernet/marvell/octeon_ep_vf/Makefile    |   2 +-
 .../marvell/octeon_ep_vf/octep_vf_ethtool.c   | 307 ++++++++++++++++++
 .../marvell/octeon_ep_vf/octep_vf_main.c      |   1 +
 .../marvell/octeon_ep_vf/octep_vf_main.h      |   1 +
 .../marvell/octeon_ep_vf/octep_vf_mbox.c      |   3 +-
 5 files changed, 312 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/Makefile b/drivers/net/ethernet/marvell/octeon_ep_vf/Makefile
index d958640ba9c9..75a711a6c199 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/Makefile
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OCTEON_EP_VF) += octeon_ep_vf.o
 
 octeon_ep_vf-y := octep_vf_main.o octep_vf_cn9k.o octep_vf_tx.o octep_vf_rx.o \
-		  octep_vf_mbox.o
+		  octep_vf_ethtool.o octep_vf_mbox.o
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
new file mode 100644
index 000000000000..25e6f643cd9f
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) VF Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+
+#include "octep_vf_config.h"
+#include "octep_vf_main.h"
+
+static const char octep_vf_gstrings_global_stats[][ETH_GSTRING_LEN] = {
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
+	"rx_hw_pkts",
+	"rx_hw_bytes",
+	"rx_hw_bcast",
+	"rx_hw_mcast",
+	"rx_dropped_pkts_fifo_full",
+	"rx_dropped_bytes_fifo_full",
+	"rx_err_pkts",
+};
+
+#define OCTEP_VF_GLOBAL_STATS_CNT (sizeof(octep_vf_gstrings_global_stats) / ETH_GSTRING_LEN)
+
+static const char octep_vf_gstrings_tx_q_stats[][ETH_GSTRING_LEN] = {
+	"tx_packets_posted[Q-%u]",
+	"tx_packets_completed[Q-%u]",
+	"tx_bytes[Q-%u]",
+	"tx_busy[Q-%u]",
+};
+
+#define OCTEP_VF_TX_Q_STATS_CNT (sizeof(octep_vf_gstrings_tx_q_stats) / ETH_GSTRING_LEN)
+
+static const char octep_vf_gstrings_rx_q_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets[Q-%u]",
+	"rx_bytes[Q-%u]",
+	"rx_alloc_errors[Q-%u]",
+};
+
+#define OCTEP_VF_RX_Q_STATS_CNT (sizeof(octep_vf_gstrings_rx_q_stats) / ETH_GSTRING_LEN)
+
+static void octep_vf_get_drvinfo(struct net_device *netdev,
+				 struct ethtool_drvinfo *info)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+
+	strscpy(info->driver, OCTEP_VF_DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(oct->pdev), sizeof(info->bus_info));
+}
+
+static void octep_vf_get_strings(struct net_device *netdev,
+				 u32 stringset, u8 *data)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	u16 num_queues = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+	char *strings = (char *)data;
+	int i, j;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < OCTEP_VF_GLOBAL_STATS_CNT; i++) {
+			snprintf(strings, ETH_GSTRING_LEN,
+				 octep_vf_gstrings_global_stats[i]);
+			strings += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < num_queues; i++) {
+			for (j = 0; j < OCTEP_VF_TX_Q_STATS_CNT; j++) {
+				snprintf(strings, ETH_GSTRING_LEN,
+					 octep_vf_gstrings_tx_q_stats[j], i);
+				strings += ETH_GSTRING_LEN;
+			}
+		}
+
+		for (i = 0; i < num_queues; i++) {
+			for (j = 0; j < OCTEP_VF_RX_Q_STATS_CNT; j++) {
+				snprintf(strings, ETH_GSTRING_LEN,
+					 octep_vf_gstrings_rx_q_stats[j], i);
+				strings += ETH_GSTRING_LEN;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int octep_vf_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	u16 num_queues = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return OCTEP_VF_GLOBAL_STATS_CNT + (num_queues *
+		       (OCTEP_VF_TX_Q_STATS_CNT + OCTEP_VF_RX_Q_STATS_CNT));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void octep_vf_get_ethtool_stats(struct net_device *netdev,
+				       struct ethtool_stats *stats, u64 *data)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	struct octep_vf_iface_tx_stats *iface_tx_stats;
+	struct octep_vf_iface_rx_stats *iface_rx_stats;
+	u64 rx_alloc_errors, tx_busy_errors;
+	u64 rx_packets, rx_bytes;
+	u64 tx_packets, tx_bytes;
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
+	octep_vf_get_if_stats(oct);
+	iface_tx_stats = &oct->iface_tx_stats;
+	iface_rx_stats = &oct->iface_rx_stats;
+
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_vf_iq *iq = oct->iq[q];
+		struct octep_vf_oq *oq = oct->oq[q];
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
+	data[i++] = iface_tx_stats->dropped;
+	data[i++] = iface_tx_stats->pkts;
+	data[i++] = iface_tx_stats->octs;
+	data[i++] = iface_tx_stats->bcst;
+	data[i++] = iface_tx_stats->mcst;
+	data[i++] = iface_rx_stats->pkts;
+	data[i++] = iface_rx_stats->octets;
+	data[i++] = iface_rx_stats->mcast_pkts;
+	data[i++] = iface_rx_stats->bcast_pkts;
+	data[i++] = iface_rx_stats->dropped_pkts_fifo_full;
+	data[i++] = iface_rx_stats->dropped_octets_fifo_full;
+	data[i++] = iface_rx_stats->err_pkts;
+
+	/* Per Tx Queue stats */
+	for (q = 0; q < oct->num_iqs; q++) {
+		struct octep_vf_iq *iq = oct->iq[q];
+
+		data[i++] = iq->stats.instr_posted;
+		data[i++] = iq->stats.instr_completed;
+		data[i++] = iq->stats.bytes_sent;
+		data[i++] = iq->stats.tx_busy;
+	}
+
+	/* Per Rx Queue stats */
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_vf_oq *oq = oct->oq[q];
+
+		data[i++] = oq->stats.packets;
+		data[i++] = oq->stats.bytes;
+		data[i++] = oq->stats.alloc_failures;
+	}
+}
+
+#define OCTEP_VF_SET_ETHTOOL_LINK_MODES_BITMAP(octep_vf_speeds, ksettings, name) \
+{ \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_T)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseT_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_R)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseR_FEC); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseCR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseKR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_LR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseLR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_10GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 10000baseSR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_25GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseCR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_25GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseKR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_25GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 25000baseSR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_40GBASE_CR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseCR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_40GBASE_KR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseKR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_40GBASE_LR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseLR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_40GBASE_SR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 40000baseSR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_CR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseCR2_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_KR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseKR2_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_SR2)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseSR2_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_CR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseCR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_KR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseKR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_LR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseLR_ER_FR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_50GBASE_SR)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 50000baseSR_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_100GBASE_CR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseCR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_100GBASE_KR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseKR4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_100GBASE_LR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseLR4_ER4_Full); \
+	if ((octep_vf_speeds) & BIT(OCTEP_VF_LINK_MODE_100GBASE_SR4)) \
+		ethtool_link_ksettings_add_link_mode(ksettings, name, 100000baseSR4_Full); \
+}
+
+static int octep_vf_get_link_ksettings(struct net_device *netdev,
+				       struct ethtool_link_ksettings *cmd)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	struct octep_vf_iface_link_info *link_info;
+	u32 advertised_modes, supported_modes;
+
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
+
+	octep_vf_get_link_info(oct);
+
+	advertised_modes = oct->link_info.advertised_modes;
+	supported_modes = oct->link_info.supported_modes;
+	link_info = &oct->link_info;
+
+	OCTEP_VF_SET_ETHTOOL_LINK_MODES_BITMAP(supported_modes, cmd, supported);
+	OCTEP_VF_SET_ETHTOOL_LINK_MODES_BITMAP(advertised_modes, cmd, advertising);
+
+	if (link_info->autoneg) {
+		if (link_info->autoneg & OCTEP_VF_LINK_MODE_AUTONEG_SUPPORTED)
+			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+		if (link_info->autoneg & OCTEP_VF_LINK_MODE_AUTONEG_ADVERTISED) {
+			ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
+			cmd->base.autoneg = AUTONEG_ENABLE;
+		} else {
+			cmd->base.autoneg = AUTONEG_DISABLE;
+		}
+	} else {
+		cmd->base.autoneg = AUTONEG_DISABLE;
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
+static const struct ethtool_ops octep_vf_ethtool_ops = {
+	.get_drvinfo = octep_vf_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_strings = octep_vf_get_strings,
+	.get_sset_count = octep_vf_get_sset_count,
+	.get_ethtool_stats = octep_vf_get_ethtool_stats,
+	.get_link_ksettings = octep_vf_get_link_ksettings,
+};
+
+void octep_vf_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &octep_vf_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index c39d2fb10cfc..707243d5e6b4 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -1003,6 +1003,7 @@ static int octep_vf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&octep_vf_dev->tx_timeout_task, octep_vf_tx_timeout_task);
 
 	netdev->netdev_ops = &octep_vf_netdev_ops;
+	octep_vf_set_ethtool_ops(netdev);
 	netif_carrier_off(netdev);
 
 	netdev->hw_features = NETIF_F_SG;
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
index 7d0c18aa6f4d..32e6b5664df5 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
@@ -298,6 +298,7 @@ void octep_vf_oq_dbell_init(struct octep_vf_device *oct);
 void octep_vf_device_setup_cn93(struct octep_vf_device *oct);
 int octep_vf_iq_process_completions(struct octep_vf_iq *iq, u16 budget);
 int octep_vf_oq_process_rx(struct octep_vf_oq *oq, int budget);
+void octep_vf_set_ethtool_ops(struct net_device *netdev);
 int octep_vf_get_link_info(struct octep_vf_device *oct);
 int octep_vf_get_if_stats(struct octep_vf_device *oct);
 void octep_vf_mbox_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
index 931dadc14be2..aecb8e56d4e6 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
@@ -105,7 +105,7 @@ static int __octep_vf_mbox_send_cmd(struct octep_vf_device *oct,
 	long timeout = OCTEP_PFVF_MBOX_WRITE_WAIT_TIME;
 	struct octep_vf_mbox *mbox = oct->mbox;
 	u64 reg_val = 0ull;
-	int count;
+	int count = 0;
 
 	if (!mbox)
 		return OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP;
@@ -119,6 +119,7 @@ static int __octep_vf_mbox_send_cmd(struct octep_vf_device *oct,
 			rsp->u64 = reg_val;
 			break;
 		}
+		count++;
 	}
 	if (count == OCTEP_PFVF_MBOX_TIMEOUT_MS) {
 		dev_err(&oct->pdev->dev, "mbox send command timed out\n");
-- 
2.36.0

