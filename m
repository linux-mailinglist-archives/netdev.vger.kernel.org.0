Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06EE4CF7B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbfFTNsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:48:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18651 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732146AbfFTNsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:48:23 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A03A499ACDA2D9ED1EDC;
        Thu, 20 Jun 2019 21:48:17 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 21:48:11 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next] hinic: implement the statistical interface of ethtool
Date:   Thu, 20 Jun 2019 05:58:08 +0000
Message-ID: <20190620055808.13474-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implement the statistical interface of ethtool, user can use 
ethtool -S to show hinic statistics.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 341 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   8 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |   5 +
 .../net/ethernet/huawei/hinic/hinic_port.c    |  66 ++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 174 +++++++++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  15 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.h  |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |   8 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.h  |   1 +
 9 files changed, 620 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index be28a9a7f033..01e8793fcb7f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -438,6 +438,344 @@ static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
 	return HINIC_RSS_INDIR_SIZE;
 }
 
+#define ARRAY_LEN(arr) ((int)((int)sizeof(arr) / (int)sizeof(arr[0])))
+
+#define HINIC_NETDEV_STAT(_stat_item) { \
+	.name = #_stat_item, \
+	.size = FIELD_SIZEOF(struct rtnl_link_stats64, _stat_item), \
+	.offset = offsetof(struct rtnl_link_stats64, _stat_item) \
+}
+
+static struct hinic_stats hinic_netdev_stats[] = {
+	HINIC_NETDEV_STAT(rx_packets),
+	HINIC_NETDEV_STAT(tx_packets),
+	HINIC_NETDEV_STAT(rx_bytes),
+	HINIC_NETDEV_STAT(tx_bytes),
+	HINIC_NETDEV_STAT(rx_errors),
+	HINIC_NETDEV_STAT(tx_errors),
+	HINIC_NETDEV_STAT(rx_dropped),
+	HINIC_NETDEV_STAT(tx_dropped),
+	HINIC_NETDEV_STAT(multicast),
+	HINIC_NETDEV_STAT(collisions),
+	HINIC_NETDEV_STAT(rx_length_errors),
+	HINIC_NETDEV_STAT(rx_over_errors),
+	HINIC_NETDEV_STAT(rx_crc_errors),
+	HINIC_NETDEV_STAT(rx_frame_errors),
+	HINIC_NETDEV_STAT(rx_fifo_errors),
+	HINIC_NETDEV_STAT(rx_missed_errors),
+	HINIC_NETDEV_STAT(tx_aborted_errors),
+	HINIC_NETDEV_STAT(tx_carrier_errors),
+	HINIC_NETDEV_STAT(tx_fifo_errors),
+	HINIC_NETDEV_STAT(tx_heartbeat_errors),
+};
+
+#define HINIC_FUNC_STAT(_stat_item) {	\
+	.name = #_stat_item, \
+	.size = FIELD_SIZEOF(struct hinic_vport_stats, _stat_item), \
+	.offset = offsetof(struct hinic_vport_stats, _stat_item) \
+}
+
+static struct hinic_stats hinic_function_stats[] = {
+	HINIC_FUNC_STAT(tx_unicast_pkts_vport),
+	HINIC_FUNC_STAT(tx_unicast_bytes_vport),
+	HINIC_FUNC_STAT(tx_multicast_pkts_vport),
+	HINIC_FUNC_STAT(tx_multicast_bytes_vport),
+	HINIC_FUNC_STAT(tx_broadcast_pkts_vport),
+	HINIC_FUNC_STAT(tx_broadcast_bytes_vport),
+
+	HINIC_FUNC_STAT(rx_unicast_pkts_vport),
+	HINIC_FUNC_STAT(rx_unicast_bytes_vport),
+	HINIC_FUNC_STAT(rx_multicast_pkts_vport),
+	HINIC_FUNC_STAT(rx_multicast_bytes_vport),
+	HINIC_FUNC_STAT(rx_broadcast_pkts_vport),
+	HINIC_FUNC_STAT(rx_broadcast_bytes_vport),
+
+	HINIC_FUNC_STAT(tx_discard_vport),
+	HINIC_FUNC_STAT(rx_discard_vport),
+	HINIC_FUNC_STAT(tx_err_vport),
+	HINIC_FUNC_STAT(rx_err_vport),
+};
+
+#define HINIC_PORT_STAT(_stat_item) { \
+	.name = #_stat_item, \
+	.size = FIELD_SIZEOF(struct hinic_phy_port_stats, _stat_item), \
+	.offset = offsetof(struct hinic_phy_port_stats, _stat_item) \
+}
+
+static struct hinic_stats hinic_port_stats[] = {
+	HINIC_PORT_STAT(mac_rx_total_pkt_num),
+	HINIC_PORT_STAT(mac_rx_total_oct_num),
+	HINIC_PORT_STAT(mac_rx_bad_pkt_num),
+	HINIC_PORT_STAT(mac_rx_bad_oct_num),
+	HINIC_PORT_STAT(mac_rx_good_pkt_num),
+	HINIC_PORT_STAT(mac_rx_good_oct_num),
+	HINIC_PORT_STAT(mac_rx_uni_pkt_num),
+	HINIC_PORT_STAT(mac_rx_multi_pkt_num),
+	HINIC_PORT_STAT(mac_rx_broad_pkt_num),
+	HINIC_PORT_STAT(mac_tx_total_pkt_num),
+	HINIC_PORT_STAT(mac_tx_total_oct_num),
+	HINIC_PORT_STAT(mac_tx_bad_pkt_num),
+	HINIC_PORT_STAT(mac_tx_bad_oct_num),
+	HINIC_PORT_STAT(mac_tx_good_pkt_num),
+	HINIC_PORT_STAT(mac_tx_good_oct_num),
+	HINIC_PORT_STAT(mac_tx_uni_pkt_num),
+	HINIC_PORT_STAT(mac_tx_multi_pkt_num),
+	HINIC_PORT_STAT(mac_tx_broad_pkt_num),
+	HINIC_PORT_STAT(mac_rx_fragment_pkt_num),
+	HINIC_PORT_STAT(mac_rx_undersize_pkt_num),
+	HINIC_PORT_STAT(mac_rx_undermin_pkt_num),
+	HINIC_PORT_STAT(mac_rx_64_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_65_127_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_128_255_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_256_511_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_512_1023_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_1024_1518_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_1519_2047_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_2048_4095_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_4096_8191_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_8192_9216_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_9217_12287_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_12288_16383_oct_pkt_num),
+	HINIC_PORT_STAT(mac_rx_1519_max_good_pkt_num),
+	HINIC_PORT_STAT(mac_rx_1519_max_bad_pkt_num),
+	HINIC_PORT_STAT(mac_rx_oversize_pkt_num),
+	HINIC_PORT_STAT(mac_rx_jabber_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pause_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri0_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri1_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri2_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri3_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri4_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri5_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri6_pkt_num),
+	HINIC_PORT_STAT(mac_rx_pfc_pri7_pkt_num),
+	HINIC_PORT_STAT(mac_rx_control_pkt_num),
+	HINIC_PORT_STAT(mac_rx_sym_err_pkt_num),
+	HINIC_PORT_STAT(mac_rx_fcs_err_pkt_num),
+	HINIC_PORT_STAT(mac_rx_send_app_good_pkt_num),
+	HINIC_PORT_STAT(mac_rx_send_app_bad_pkt_num),
+	HINIC_PORT_STAT(mac_tx_fragment_pkt_num),
+	HINIC_PORT_STAT(mac_tx_undersize_pkt_num),
+	HINIC_PORT_STAT(mac_tx_undermin_pkt_num),
+	HINIC_PORT_STAT(mac_tx_64_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_65_127_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_128_255_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_256_511_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_512_1023_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_1024_1518_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_1519_2047_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_2048_4095_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_4096_8191_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_8192_9216_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_9217_12287_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_12288_16383_oct_pkt_num),
+	HINIC_PORT_STAT(mac_tx_1519_max_good_pkt_num),
+	HINIC_PORT_STAT(mac_tx_1519_max_bad_pkt_num),
+	HINIC_PORT_STAT(mac_tx_oversize_pkt_num),
+	HINIC_PORT_STAT(mac_tx_jabber_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pause_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri0_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri1_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri2_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri3_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri4_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri5_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri6_pkt_num),
+	HINIC_PORT_STAT(mac_tx_pfc_pri7_pkt_num),
+	HINIC_PORT_STAT(mac_tx_control_pkt_num),
+	HINIC_PORT_STAT(mac_tx_err_all_pkt_num),
+	HINIC_PORT_STAT(mac_tx_from_app_good_pkt_num),
+	HINIC_PORT_STAT(mac_tx_from_app_bad_pkt_num),
+};
+
+#define HINIC_TXQ_STAT(_stat_item) { \
+	.name = "txq%d_"#_stat_item, \
+	.size = FIELD_SIZEOF(struct hinic_txq_stats, _stat_item), \
+	.offset = offsetof(struct hinic_txq_stats, _stat_item) \
+}
+
+static struct hinic_stats hinic_tx_queue_stats[] = {
+	HINIC_TXQ_STAT(pkts),
+	HINIC_TXQ_STAT(bytes),
+	HINIC_TXQ_STAT(tx_busy),
+	HINIC_TXQ_STAT(tx_wake),
+	HINIC_TXQ_STAT(tx_dropped),
+	HINIC_TXQ_STAT(big_frags_pkts),
+};
+
+#define HINIC_RXQ_STAT(_stat_item) { \
+	.name = "rxq%d_"#_stat_item, \
+	.size = FIELD_SIZEOF(struct hinic_rxq_stats, _stat_item), \
+	.offset = offsetof(struct hinic_rxq_stats, _stat_item) \
+}
+
+static struct hinic_stats hinic_rx_queue_stats[] = {
+	HINIC_RXQ_STAT(pkts),
+	HINIC_RXQ_STAT(bytes),
+	HINIC_RXQ_STAT(errors),
+	HINIC_RXQ_STAT(csum_errors),
+	HINIC_RXQ_STAT(other_errors),
+};
+
+static void get_drv_queue_stats(struct hinic_dev *nic_dev, u64 *data)
+{
+	struct hinic_txq_stats txq_stats;
+	struct hinic_rxq_stats rxq_stats;
+	u16 i = 0, j = 0, qid = 0;
+	char *p;
+
+	for (qid = 0; qid < nic_dev->num_qps; qid++) {
+		if (!nic_dev->txqs)
+			break;
+
+		hinic_txq_get_stats(&nic_dev->txqs[qid], &txq_stats);
+		for (j = 0; j < ARRAY_LEN(hinic_tx_queue_stats); j++, i++) {
+			p = (char *)(&txq_stats) +
+				hinic_tx_queue_stats[j].offset;
+			data[i] = (hinic_tx_queue_stats[j].size ==
+					sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+		}
+	}
+
+	for (qid = 0; qid < nic_dev->num_qps; qid++) {
+		if (!nic_dev->rxqs)
+			break;
+
+		hinic_rxq_get_stats(&nic_dev->rxqs[qid], &rxq_stats);
+		for (j = 0; j < ARRAY_LEN(hinic_rx_queue_stats); j++, i++) {
+			p = (char *)(&rxq_stats) +
+				hinic_rx_queue_stats[j].offset;
+			data[i] = (hinic_rx_queue_stats[j].size ==
+					sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+		}
+	}
+}
+
+static void hinic_get_ethtool_stats(struct net_device *netdev,
+				    struct ethtool_stats *stats, u64 *data)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_vport_stats vport_stats = {0};
+	const struct rtnl_link_stats64 *net_stats;
+	struct hinic_phy_port_stats *port_stats;
+	struct rtnl_link_stats64 temp;
+	u16 i = 0, j = 0;
+	char *p;
+	int err;
+
+	net_stats = dev_get_stats(netdev, &temp);
+	for (j = 0; j < ARRAY_LEN(hinic_netdev_stats); j++, i++) {
+		p = (char *)(net_stats) + hinic_netdev_stats[j].offset;
+		data[i] = (hinic_netdev_stats[j].size ==
+				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+	}
+
+	err = hinic_get_vport_stats(nic_dev, &vport_stats);
+	if (err)
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get vport stats from firmware\n");
+
+	for (j = 0; j < ARRAY_LEN(hinic_function_stats); j++, i++) {
+		p = (char *)(&vport_stats) + hinic_function_stats[j].offset;
+		data[i] = (hinic_function_stats[j].size ==
+				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+	}
+
+	port_stats = kzalloc(sizeof(*port_stats), GFP_KERNEL);
+	if (!port_stats) {
+		memset(&data[i], 0,
+		       ARRAY_LEN(hinic_port_stats) * sizeof(*data));
+		i += ARRAY_LEN(hinic_port_stats);
+		goto get_drv_stats;
+	}
+
+	err = hinic_get_phy_port_stats(nic_dev, port_stats);
+	if (err)
+		netif_err(nic_dev, drv, netdev,
+			  "Failed to get port stats from firmware\n");
+
+	for (j = 0; j < ARRAY_LEN(hinic_port_stats); j++, i++) {
+		p = (char *)(port_stats) + hinic_port_stats[j].offset;
+		data[i] = (hinic_port_stats[j].size ==
+				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+	}
+
+	kfree(port_stats);
+
+get_drv_stats:
+	get_drv_queue_stats(nic_dev, data + i);
+}
+
+static int hinic_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int count, q_num;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		q_num = nic_dev->num_qps;
+		count = ARRAY_LEN(hinic_netdev_stats) +
+			ARRAY_LEN(hinic_function_stats) +
+			(ARRAY_LEN(hinic_tx_queue_stats) +
+			ARRAY_LEN(hinic_rx_queue_stats)) * q_num;
+
+		count += ARRAY_LEN(hinic_port_stats);
+
+		return count;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void hinic_get_strings(struct net_device *netdev,
+			      u32 stringset, u8 *data)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	char *p = (char *)data;
+	u16 i, j;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < ARRAY_LEN(hinic_netdev_stats); i++) {
+			memcpy(p, hinic_netdev_stats[i].name,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < ARRAY_LEN(hinic_function_stats); i++) {
+			memcpy(p, hinic_function_stats[i].name,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < ARRAY_LEN(hinic_port_stats); i++) {
+			memcpy(p, hinic_port_stats[i].name,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < nic_dev->num_qps; i++) {
+			for (j = 0; j < ARRAY_LEN(hinic_tx_queue_stats); j++) {
+				sprintf(p, hinic_tx_queue_stats[j].name, i);
+				p += ETH_GSTRING_LEN;
+			}
+		}
+
+		for (i = 0; i < nic_dev->num_qps; i++) {
+			for (j = 0; j < ARRAY_LEN(hinic_rx_queue_stats); j++) {
+				sprintf(p, hinic_rx_queue_stats[j].name, i);
+				p += ETH_GSTRING_LEN;
+			}
+		}
+
+		return;
+	default:
+		return;
+	}
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_link_ksettings = hinic_get_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
@@ -450,6 +788,9 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_rxfh_indir_size = hinic_get_rxfh_indir_size,
 	.get_rxfh = hinic_get_rxfh,
 	.set_rxfh = hinic_set_rxfh,
+	.get_sset_count = hinic_get_sset_count,
+	.get_ethtool_stats = hinic_get_ethtool_stats,
+	.get_strings = hinic_get_strings,
 };
 
 void hinic_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 7f854392f4e7..1220321614b4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -54,6 +54,14 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
 
+	HINIC_PORT_CMD_GET_PORT_STATISTICS = 28,
+
+	HINIC_PORT_CMD_CLEAR_PORT_STATISTICS = 29,
+
+	HINIC_PORT_CMD_GET_VPORT_STAT	= 30,
+
+	HINIC_PORT_CMD_CLEAN_VPORT_STAT	= 31,
+
 	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 37,
 
 	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 853fc3e7b514..152d16eabb1a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -92,6 +92,9 @@ static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
 	u64_stats_update_begin(&nic_rx_stats->syncp);
 	nic_rx_stats->bytes += rx_stats.bytes;
 	nic_rx_stats->pkts  += rx_stats.pkts;
+	nic_rx_stats->errors += rx_stats.errors;
+	nic_rx_stats->csum_errors += rx_stats.csum_errors;
+	nic_rx_stats->other_errors += rx_stats.other_errors;
 	u64_stats_update_end(&nic_rx_stats->syncp);
 
 	hinic_rxq_clean_stats(rxq);
@@ -112,6 +115,7 @@ static void update_tx_stats(struct hinic_dev *nic_dev, struct hinic_txq *txq)
 	nic_tx_stats->tx_busy += tx_stats.tx_busy;
 	nic_tx_stats->tx_wake += tx_stats.tx_wake;
 	nic_tx_stats->tx_dropped += tx_stats.tx_dropped;
+	nic_tx_stats->big_frags_pkts += tx_stats.big_frags_pkts;
 	u64_stats_update_end(&nic_tx_stats->syncp);
 
 	hinic_txq_clean_stats(txq);
@@ -791,6 +795,7 @@ static void hinic_get_stats64(struct net_device *netdev,
 
 	stats->rx_bytes   = nic_rx_stats->bytes;
 	stats->rx_packets = nic_rx_stats->pkts;
+	stats->rx_errors  = nic_rx_stats->errors;
 
 	stats->tx_bytes   = nic_tx_stats->bytes;
 	stats->tx_packets = nic_tx_stats->pkts;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 3bd24cb8ed4b..85a56ecd1e66 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -942,3 +942,69 @@ int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx)
 
 	return 0;
 }
+
+int hinic_get_vport_stats(struct hinic_dev *nic_dev,
+			  struct hinic_vport_stats *stats)
+{
+	struct hinic_cmd_vport_stats vport_stats = {0};
+	struct hinic_port_stats_info stats_info = {0};
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(vport_stats);
+	struct pci_dev *pdev = hwif->pdev;
+	int err;
+
+	stats_info.stats_version = HINIC_PORT_STATS_VERSION;
+	stats_info.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	stats_info.stats_size = sizeof(vport_stats);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_VPORT_STAT,
+				 &stats_info, sizeof(stats_info),
+				 &vport_stats, &out_size);
+	if (err || !out_size || vport_stats.status) {
+		dev_err(&pdev->dev,
+			"Failed to get function statistics, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, vport_stats.status, out_size);
+		return -EFAULT;
+	}
+
+	memcpy(stats, &vport_stats.stats, sizeof(*stats));
+	return 0;
+}
+
+int hinic_get_phy_port_stats(struct hinic_dev *nic_dev,
+			     struct hinic_phy_port_stats *stats)
+{
+	struct hinic_port_stats_info stats_info = {0};
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct hinic_port_stats *port_stats;
+	u16 out_size = sizeof(*port_stats);
+	struct pci_dev *pdev = hwif->pdev;
+	int err;
+
+	port_stats = kzalloc(sizeof(*port_stats), GFP_KERNEL);
+	if (!port_stats)
+		return -ENOMEM;
+
+	stats_info.stats_version = HINIC_PORT_STATS_VERSION;
+	stats_info.stats_size = sizeof(*port_stats);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_PORT_STATISTICS,
+				 &stats_info, sizeof(stats_info),
+				 port_stats, &out_size);
+	if (err || !out_size || port_stats->status) {
+		dev_err(&pdev->dev,
+			"Failed to get port statistics, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_stats->status, out_size);
+		err = -EINVAL;
+		goto out;
+	}
+
+	memcpy(stats, &port_stats->stats, sizeof(*stats));
+
+out:
+	kfree(port_stats);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index f177945d64ae..8640ac0dc3ea 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -24,6 +24,7 @@
 
 #define HINIC_RSS_KEY_SIZE	40
 #define HINIC_RSS_INDIR_SIZE	256
+#define HINIC_PORT_STATS_VERSION	0
 
 enum hinic_rx_mode {
 	HINIC_RX_MODE_UC        = BIT(0),
@@ -325,6 +326,173 @@ struct hinic_rss_config {
 	u8	rsvd1[11];
 };
 
+struct hinic_stats {
+	char name[ETH_GSTRING_LEN];
+	u32 size;
+	int offset;
+};
+
+struct hinic_vport_stats {
+	u64 tx_unicast_pkts_vport;
+	u64 tx_unicast_bytes_vport;
+	u64 tx_multicast_pkts_vport;
+	u64 tx_multicast_bytes_vport;
+	u64 tx_broadcast_pkts_vport;
+	u64 tx_broadcast_bytes_vport;
+
+	u64 rx_unicast_pkts_vport;
+	u64 rx_unicast_bytes_vport;
+	u64 rx_multicast_pkts_vport;
+	u64 rx_multicast_bytes_vport;
+	u64 rx_broadcast_pkts_vport;
+	u64 rx_broadcast_bytes_vport;
+
+	u64 tx_discard_vport;
+	u64 rx_discard_vport;
+	u64 tx_err_vport;
+	u64 rx_err_vport;
+};
+
+struct hinic_phy_port_stats {
+	u64 mac_rx_total_pkt_num;
+	u64 mac_rx_total_oct_num;
+	u64 mac_rx_bad_pkt_num;
+	u64 mac_rx_bad_oct_num;
+	u64 mac_rx_good_pkt_num;
+	u64 mac_rx_good_oct_num;
+	u64 mac_rx_uni_pkt_num;
+	u64 mac_rx_multi_pkt_num;
+	u64 mac_rx_broad_pkt_num;
+
+	u64 mac_tx_total_pkt_num;
+	u64 mac_tx_total_oct_num;
+	u64 mac_tx_bad_pkt_num;
+	u64 mac_tx_bad_oct_num;
+	u64 mac_tx_good_pkt_num;
+	u64 mac_tx_good_oct_num;
+	u64 mac_tx_uni_pkt_num;
+	u64 mac_tx_multi_pkt_num;
+	u64 mac_tx_broad_pkt_num;
+
+	u64 mac_rx_fragment_pkt_num;
+	u64 mac_rx_undersize_pkt_num;
+	u64 mac_rx_undermin_pkt_num;
+	u64 mac_rx_64_oct_pkt_num;
+	u64 mac_rx_65_127_oct_pkt_num;
+	u64 mac_rx_128_255_oct_pkt_num;
+	u64 mac_rx_256_511_oct_pkt_num;
+	u64 mac_rx_512_1023_oct_pkt_num;
+	u64 mac_rx_1024_1518_oct_pkt_num;
+	u64 mac_rx_1519_2047_oct_pkt_num;
+	u64 mac_rx_2048_4095_oct_pkt_num;
+	u64 mac_rx_4096_8191_oct_pkt_num;
+	u64 mac_rx_8192_9216_oct_pkt_num;
+	u64 mac_rx_9217_12287_oct_pkt_num;
+	u64 mac_rx_12288_16383_oct_pkt_num;
+	u64 mac_rx_1519_max_bad_pkt_num;
+	u64 mac_rx_1519_max_good_pkt_num;
+	u64 mac_rx_oversize_pkt_num;
+	u64 mac_rx_jabber_pkt_num;
+
+	u64 mac_rx_pause_num;
+	u64 mac_rx_pfc_pkt_num;
+	u64 mac_rx_pfc_pri0_pkt_num;
+	u64 mac_rx_pfc_pri1_pkt_num;
+	u64 mac_rx_pfc_pri2_pkt_num;
+	u64 mac_rx_pfc_pri3_pkt_num;
+	u64 mac_rx_pfc_pri4_pkt_num;
+	u64 mac_rx_pfc_pri5_pkt_num;
+	u64 mac_rx_pfc_pri6_pkt_num;
+	u64 mac_rx_pfc_pri7_pkt_num;
+	u64 mac_rx_control_pkt_num;
+	u64 mac_rx_y1731_pkt_num;
+	u64 mac_rx_sym_err_pkt_num;
+	u64 mac_rx_fcs_err_pkt_num;
+	u64 mac_rx_send_app_good_pkt_num;
+	u64 mac_rx_send_app_bad_pkt_num;
+
+	u64 mac_tx_fragment_pkt_num;
+	u64 mac_tx_undersize_pkt_num;
+	u64 mac_tx_undermin_pkt_num;
+	u64 mac_tx_64_oct_pkt_num;
+	u64 mac_tx_65_127_oct_pkt_num;
+	u64 mac_tx_128_255_oct_pkt_num;
+	u64 mac_tx_256_511_oct_pkt_num;
+	u64 mac_tx_512_1023_oct_pkt_num;
+	u64 mac_tx_1024_1518_oct_pkt_num;
+	u64 mac_tx_1519_2047_oct_pkt_num;
+	u64 mac_tx_2048_4095_oct_pkt_num;
+	u64 mac_tx_4096_8191_oct_pkt_num;
+	u64 mac_tx_8192_9216_oct_pkt_num;
+	u64 mac_tx_9217_12287_oct_pkt_num;
+	u64 mac_tx_12288_16383_oct_pkt_num;
+	u64 mac_tx_1519_max_bad_pkt_num;
+	u64 mac_tx_1519_max_good_pkt_num;
+	u64 mac_tx_oversize_pkt_num;
+	u64 mac_tx_jabber_pkt_num;
+
+	u64 mac_tx_pause_num;
+	u64 mac_tx_pfc_pkt_num;
+	u64 mac_tx_pfc_pri0_pkt_num;
+	u64 mac_tx_pfc_pri1_pkt_num;
+	u64 mac_tx_pfc_pri2_pkt_num;
+	u64 mac_tx_pfc_pri3_pkt_num;
+	u64 mac_tx_pfc_pri4_pkt_num;
+	u64 mac_tx_pfc_pri5_pkt_num;
+	u64 mac_tx_pfc_pri6_pkt_num;
+	u64 mac_tx_pfc_pri7_pkt_num;
+	u64 mac_tx_control_pkt_num;
+	u64 mac_tx_y1731_pkt_num;
+	u64 mac_tx_1588_pkt_num;
+	u64 mac_tx_err_all_pkt_num;
+	u64 mac_tx_from_app_good_pkt_num;
+	u64 mac_tx_from_app_bad_pkt_num;
+
+	u64 mac_rx_higig2_ext_pkt_num;
+	u64 mac_rx_higig2_message_pkt_num;
+	u64 mac_rx_higig2_error_pkt_num;
+	u64 mac_rx_higig2_cpu_ctrl_pkt_num;
+	u64 mac_rx_higig2_unicast_pkt_num;
+	u64 mac_rx_higig2_broadcast_pkt_num;
+	u64 mac_rx_higig2_l2_multicast_pkt_num;
+	u64 mac_rx_higig2_l3_multicast_pkt_num;
+
+	u64 mac_tx_higig2_message_pkt_num;
+	u64 mac_tx_higig2_ext_pkt_num;
+	u64 mac_tx_higig2_cpu_ctrl_pkt_num;
+	u64 mac_tx_higig2_unicast_pkt_num;
+	u64 mac_tx_higig2_broadcast_pkt_num;
+	u64 mac_tx_higig2_l2_multicast_pkt_num;
+	u64 mac_tx_higig2_l3_multicast_pkt_num;
+};
+
+struct hinic_port_stats_info {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+	u32	stats_version;
+	u32	stats_size;
+};
+
+struct hinic_port_stats {
+	u8 status;
+	u8 version;
+	u8 rsvd[6];
+
+	struct hinic_phy_port_stats stats;
+};
+
+struct hinic_cmd_vport_stats {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	struct hinic_vport_stats stats;
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -393,4 +561,10 @@ int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 
 int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx,
 			      u8 *type);
+
+int hinic_get_phy_port_stats(struct hinic_dev *nic_dev,
+			     struct hinic_phy_port_stats *stats);
+
+int hinic_get_vport_stats(struct hinic_dev *nic_dev,
+			  struct hinic_vport_stats *stats);
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 04c887d13848..a6c498e9a0fd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -65,6 +65,9 @@ void hinic_rxq_clean_stats(struct hinic_rxq *rxq)
 	u64_stats_update_begin(&rxq_stats->syncp);
 	rxq_stats->pkts  = 0;
 	rxq_stats->bytes = 0;
+	rxq_stats->errors = 0;
+	rxq_stats->csum_errors = 0;
+	rxq_stats->other_errors = 0;
 	u64_stats_update_end(&rxq_stats->syncp);
 }
 
@@ -83,6 +86,10 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 		start = u64_stats_fetch_begin(&rxq_stats->syncp);
 		stats->pkts = rxq_stats->pkts;
 		stats->bytes = rxq_stats->bytes;
+		stats->errors = rxq_stats->csum_errors +
+				rxq_stats->other_errors;
+		stats->csum_errors = rxq_stats->csum_errors;
+		stats->other_errors = rxq_stats->other_errors;
 	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
 	u64_stats_update_end(&stats->syncp);
 }
@@ -110,10 +117,14 @@ static void rx_csum(struct hinic_rxq *rxq, u32 status,
 	if (!(netdev->features & NETIF_F_RXCSUM))
 		return;
 
-	if (!csum_err)
+	if (!csum_err) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-	else
+	} else {
+		if (!(csum_err & (HINIC_RX_CSUM_HW_CHECK_NONE |
+			HINIC_RX_CSUM_IPSU_OTHER_ERR)))
+			rxq->rxq_stats.csum_errors++;
 		skb->ip_summed = CHECKSUM_NONE;
+	}
 }
 /**
  * rx_alloc_skb - allocate skb and map it to dma address
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.h b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
index 08e7d88382cd..233d3850b7a8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.h
@@ -30,7 +30,10 @@
 struct hinic_rxq_stats {
 	u64                     pkts;
 	u64                     bytes;
-
+	u64			errors;
+	u64			csum_errors;
+	u64			other_errors;
+	u64			alloc_skb_err;
 	struct u64_stats_sync   syncp;
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 0fbe8046824b..639ec81e0e10 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -92,6 +92,7 @@ void hinic_txq_clean_stats(struct hinic_txq *txq)
 	txq_stats->tx_busy = 0;
 	txq_stats->tx_wake = 0;
 	txq_stats->tx_dropped = 0;
+	txq_stats->big_frags_pkts = 0;
 	u64_stats_update_end(&txq_stats->syncp);
 }
 
@@ -113,6 +114,7 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 		stats->tx_busy = txq_stats->tx_busy;
 		stats->tx_wake = txq_stats->tx_wake;
 		stats->tx_dropped = txq_stats->tx_dropped;
+		stats->big_frags_pkts = txq_stats->big_frags_pkts;
 	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
 	u64_stats_update_end(&stats->syncp);
 }
@@ -473,6 +475,12 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 	nr_sges = skb_shinfo(skb)->nr_frags + 1;
+	if (nr_sges > 17) {
+		u64_stats_update_begin(&txq->txq_stats.syncp);
+		txq->txq_stats.big_frags_pkts++;
+		u64_stats_update_end(&txq->txq_stats.syncp);
+	}
+
 	if (nr_sges > txq->max_sges) {
 		netdev_err(netdev, "Too many Tx sges\n");
 		goto skb_error;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.h b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
index 1fa55dce5aa7..f1ee0376dc88 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
@@ -30,6 +30,7 @@ struct hinic_txq_stats {
 	u64     tx_busy;
 	u64     tx_wake;
 	u64     tx_dropped;
+	u64	big_frags_pkts;
 
 	struct u64_stats_sync   syncp;
 };
-- 
2.17.1

