Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E0D18DFC4
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCULXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:23:55 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:37175 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgCULXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:23:55 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02LBNjkt021088;
        Sat, 21 Mar 2020 04:23:46 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next] cxgb4/chcr: nic-tls stats in ethtool
Date:   Sat, 21 Mar 2020 16:53:36 +0530
Message-Id: <20200321112336.8771-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Included nic tls statistics in ethtool stats.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 398ade42476c..4998f1d1e218 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -134,6 +134,28 @@ static char loopback_stats_strings[][ETH_GSTRING_LEN] = {
 	"bg3_frames_trunc       ",
 };
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+struct chcr_tls_stats {
+	u64 tx_tls_encrypted_packets;
+	u64 tx_tls_encrypted_bytes;
+	u64 tx_tls_ctx;
+	u64 tx_tls_ooo;
+	u64 tx_tls_skip_no_sync_data;
+	u64 tx_tls_drop_no_sync_data;
+	u64 tx_tls_drop_bypass_req;
+};
+
+static char chcr_tls_stats_strings[][ETH_GSTRING_LEN] = {
+	"tx_tls_encrypted_pkts  ",
+	"tx_tls_encrypted_bytes ",
+	"tx_tls_ctx             ",
+	"tx_tls_ooo             ",
+	"tx_tls_skip_nosync_data",
+	"tx_tls_drop_nosync_data",
+	"tx_tls_drop_bypass_req ",
+};
+#endif
+
 static const char cxgb4_priv_flags_strings[][ETH_GSTRING_LEN] = {
 	[PRIV_FLAG_PORT_TX_VM_BIT] = "port_tx_vm_wr",
 };
@@ -144,6 +166,9 @@ static int get_sset_count(struct net_device *dev, int sset)
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(stats_strings) +
 		       ARRAY_SIZE(adapter_stats_strings) +
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		       ARRAY_SIZE(chcr_tls_stats_strings) +
+#endif
 		       ARRAY_SIZE(loopback_stats_strings);
 	case ETH_SS_PRIV_FLAGS:
 		return ARRAY_SIZE(cxgb4_priv_flags_strings);
@@ -204,6 +229,11 @@ static void get_strings(struct net_device *dev, u32 stringset, u8 *data)
 		memcpy(data, adapter_stats_strings,
 		       sizeof(adapter_stats_strings));
 		data += sizeof(adapter_stats_strings);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		memcpy(data, chcr_tls_stats_strings,
+		       sizeof(chcr_tls_stats_strings));
+		data += sizeof(chcr_tls_stats_strings);
+#endif
 		memcpy(data, loopback_stats_strings,
 		       sizeof(loopback_stats_strings));
 	} else if (stringset == ETH_SS_PRIV_FLAGS) {
@@ -289,6 +319,29 @@ static void collect_adapter_stats(struct adapter *adap, struct adapter_stats *s)
 	}
 }
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+static void collect_chcr_tls_stats(struct adapter *adap,
+				   struct chcr_tls_stats *s)
+{
+	struct chcr_stats_debug *stats = &adap->chcr_stats;
+
+	memset(s, 0, sizeof(*s));
+
+	s->tx_tls_encrypted_packets =
+		atomic64_read(&stats->ktls_tx_encrypted_packets);
+	s->tx_tls_encrypted_bytes =
+		atomic64_read(&stats->ktls_tx_encrypted_bytes);
+	s->tx_tls_ctx = atomic64_read(&stats->ktls_tx_ctx);
+	s->tx_tls_ooo = atomic64_read(&stats->ktls_tx_ooo);
+	s->tx_tls_skip_no_sync_data =
+		atomic64_read(&stats->ktls_tx_skip_no_sync_data);
+	s->tx_tls_drop_no_sync_data =
+		atomic64_read(&stats->ktls_tx_drop_no_sync_data);
+	s->tx_tls_drop_bypass_req =
+		atomic64_read(&stats->ktls_tx_drop_bypass_req);
+}
+#endif
+
 static void get_stats(struct net_device *dev, struct ethtool_stats *stats,
 		      u64 *data)
 {
@@ -307,6 +360,10 @@ static void get_stats(struct net_device *dev, struct ethtool_stats *stats,
 	data += sizeof(struct queue_port_stats) / sizeof(u64);
 	collect_adapter_stats(adapter, (struct adapter_stats *)data);
 	data += sizeof(struct adapter_stats) / sizeof(u64);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	collect_chcr_tls_stats(adapter, (struct chcr_tls_stats *)data);
+	data += sizeof(struct chcr_tls_stats) / sizeof(u64);
+#endif
 
 	*data++ = (u64)pi->port_id;
 	memset(&s, 0, sizeof(s));
-- 
2.18.1

