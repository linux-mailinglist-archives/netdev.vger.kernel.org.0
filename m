Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2C2646A2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 15:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgIJNL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 09:11:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:21214 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbgIJNH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599743245; x=1631279245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=50eDR9FL5juD7hBgsulVouqLNS611vlu0lO1OnyM2/E=;
  b=GCd3/s/AcfF1DVFOByJ6w7TxjioD9frFjPZf9r9YWRGr9oVBV3CRiu78
   lJI7uISoaPFChRMZnZqzfszeB+k2YVHjcT+HQoneGJBgQbF5jk//AMaFv
   MsxKGjv+pvYxSyyzuYyHa3iAbZ9ze3YR2FvAHEavoKeFHmSc7QR44NH2x
   w=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="54603096"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Sep 2020 13:07:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 6407AA184F;
        Thu, 10 Sep 2020 13:07:23 +0000 (UTC)
Received: from EX13D21UWB004.ant.amazon.com (10.43.161.221) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D21UWB004.ant.amazon.com (10.43.161.221) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 10 Sep 2020 13:07:22 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1AAEF81C39; Thu, 10 Sep 2020 13:07:22 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V4 net-next 2/4] net: ena: ethtool: Add new device statistics
Date:   Thu, 10 Sep 2020 13:07:11 +0000
Message-ID: <20200910130713.26074-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200910130713.26074-1-sameehj@amazon.com>
References: <20200910130713.26074-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The new metrics provide granular visibility along multiple network
dimensions and enable troubleshooting and remediation of issues caused
by instances exceeding network performance allowances.

The new statistics can be queried using ethtool command.

Signed-off-by: Guy Tzalik <gtzalik@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  37 +++++++-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  19 +++-
 drivers/net/ethernet/amazon/ena/ena_com.h        |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 106 ++++++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  18 ++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   4 +
 6 files changed, 170 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index b818a169c..86869baa7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -117,6 +117,8 @@ enum ena_admin_completion_policy_type {
 enum ena_admin_get_stats_type {
 	ENA_ADMIN_GET_STATS_TYPE_BASIC              = 0,
 	ENA_ADMIN_GET_STATS_TYPE_EXTENDED           = 1,
+	/* extra HW stats for specific network interface */
+	ENA_ADMIN_GET_STATS_TYPE_ENI                = 2,
 };
 
 enum ena_admin_get_stats_scope {
@@ -410,10 +412,43 @@ struct ena_admin_basic_stats {
 	u32 tx_drops_high;
 };
 
+/* ENI Statistics Command. */
+struct ena_admin_eni_stats {
+	/* The number of packets shaped due to inbound aggregate BW
+	 * allowance being exceeded
+	 */
+	u64 bw_in_allowance_exceeded;
+
+	/* The number of packets shaped due to outbound aggregate BW
+	 * allowance being exceeded
+	 */
+	u64 bw_out_allowance_exceeded;
+
+	/* The number of packets shaped due to PPS allowance being exceeded */
+	u64 pps_allowance_exceeded;
+
+	/* The number of packets shaped due to connection tracking
+	 * allowance being exceeded and leading to failure in establishment
+	 * of new connections
+	 */
+	u64 conntrack_allowance_exceeded;
+
+	/* The number of packets shaped due to linklocal packet rate
+	 * allowance being exceeded
+	 */
+	u64 linklocal_allowance_exceeded;
+};
+
 struct ena_admin_acq_get_stats_resp {
 	struct ena_admin_acq_common_desc acq_common_desc;
 
-	struct ena_admin_basic_stats basic_stats;
+	union {
+		u64 raw[7];
+
+		struct ena_admin_basic_stats basic_stats;
+
+		struct ena_admin_eni_stats eni_stats;
+	} u;
 };
 
 struct ena_admin_get_set_feature_common_desc {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 435bf05a8..452e66b39 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2167,6 +2167,21 @@ static int ena_get_dev_stats(struct ena_com_dev *ena_dev,
 	return ret;
 }
 
+int ena_com_get_eni_stats(struct ena_com_dev *ena_dev,
+			  struct ena_admin_eni_stats *stats)
+{
+	struct ena_com_stats_ctx ctx;
+	int ret;
+
+	memset(&ctx, 0x0, sizeof(ctx));
+	ret = ena_get_dev_stats(ena_dev, &ctx, ENA_ADMIN_GET_STATS_TYPE_ENI);
+	if (likely(ret == 0))
+		memcpy(stats, &ctx.get_resp.u.eni_stats,
+		       sizeof(ctx.get_resp.u.eni_stats));
+
+	return ret;
+}
+
 int ena_com_get_dev_basic_stats(struct ena_com_dev *ena_dev,
 				struct ena_admin_basic_stats *stats)
 {
@@ -2176,8 +2191,8 @@ int ena_com_get_dev_basic_stats(struct ena_com_dev *ena_dev,
 	memset(&ctx, 0x0, sizeof(ctx));
 	ret = ena_get_dev_stats(ena_dev, &ctx, ENA_ADMIN_GET_STATS_TYPE_BASIC);
 	if (likely(ret == 0))
-		memcpy(stats, &ctx.get_resp.basic_stats,
-		       sizeof(ctx.get_resp.basic_stats));
+		memcpy(stats, &ctx.get_resp.u.basic_stats,
+		       sizeof(ctx.get_resp.u.basic_stats));
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 4287d47b2..e4aafeda0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -616,6 +616,15 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 int ena_com_get_dev_basic_stats(struct ena_com_dev *ena_dev,
 				struct ena_admin_basic_stats *stats);
 
+/* ena_com_get_eni_stats - Get extended network interface statistics
+ * @ena_dev: ENA communication layer struct
+ * @stats: stats return value
+ *
+ * @return: 0 on Success and negative value otherwise.
+ */
+int ena_com_get_eni_stats(struct ena_com_dev *ena_dev,
+			  struct ena_admin_eni_stats *stats);
+
 /* ena_com_set_dev_mtu - Configure the device mtu.
  * @ena_dev: ENA communication layer struct
  * @mtu: mtu value
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 291d169dd..07e9f3df0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -49,6 +49,11 @@ struct ena_stats {
 	.stat_offset = offsetof(struct ena_stats_##stat_type, stat) / sizeof(u64) \
 }
 
+#define ENA_STAT_HW_ENTRY(stat, stat_type) { \
+	.name = #stat, \
+	.stat_offset = offsetof(struct ena_admin_##stat_type, stat) / sizeof(u64) \
+}
+
 #define ENA_STAT_RX_ENTRY(stat) \
 	ENA_STAT_ENTRY(stat, rx)
 
@@ -58,6 +63,9 @@ struct ena_stats {
 #define ENA_STAT_GLOBAL_ENTRY(stat) \
 	ENA_STAT_ENTRY(stat, dev)
 
+#define ENA_STAT_ENI_ENTRY(stat) \
+	ENA_STAT_HW_ENTRY(stat, eni_stats)
+
 static const struct ena_stats ena_stats_global_strings[] = {
 	ENA_STAT_GLOBAL_ENTRY(tx_timeout),
 	ENA_STAT_GLOBAL_ENTRY(suspend),
@@ -68,6 +76,14 @@ static const struct ena_stats ena_stats_global_strings[] = {
 	ENA_STAT_GLOBAL_ENTRY(admin_q_pause),
 };
 
+static const struct ena_stats ena_stats_eni_strings[] = {
+	ENA_STAT_ENI_ENTRY(bw_in_allowance_exceeded),
+	ENA_STAT_ENI_ENTRY(bw_out_allowance_exceeded),
+	ENA_STAT_ENI_ENTRY(pps_allowance_exceeded),
+	ENA_STAT_ENI_ENTRY(conntrack_allowance_exceeded),
+	ENA_STAT_ENI_ENTRY(linklocal_allowance_exceeded),
+};
+
 static const struct ena_stats ena_stats_tx_strings[] = {
 	ENA_STAT_TX_ENTRY(cnt),
 	ENA_STAT_TX_ENTRY(bytes),
@@ -110,10 +126,12 @@ static const struct ena_stats ena_stats_ena_com_strings[] = {
 	ENA_STAT_ENA_COM_ENTRY(no_completion),
 };
 
-#define ENA_STATS_ARRAY_GLOBAL	ARRAY_SIZE(ena_stats_global_strings)
-#define ENA_STATS_ARRAY_TX	ARRAY_SIZE(ena_stats_tx_strings)
-#define ENA_STATS_ARRAY_RX	ARRAY_SIZE(ena_stats_rx_strings)
-#define ENA_STATS_ARRAY_ENA_COM	ARRAY_SIZE(ena_stats_ena_com_strings)
+#define ENA_STATS_ARRAY_GLOBAL		ARRAY_SIZE(ena_stats_global_strings)
+#define ENA_STATS_ARRAY_TX		ARRAY_SIZE(ena_stats_tx_strings)
+#define ENA_STATS_ARRAY_RX		ARRAY_SIZE(ena_stats_rx_strings)
+#define ENA_STATS_ARRAY_ENA_COM		ARRAY_SIZE(ena_stats_ena_com_strings)
+#define ENA_STATS_ARRAY_ENI(adapter)	\
+	(ARRAY_SIZE(ena_stats_eni_strings) * (adapter)->eni_stats_supported)
 
 static void ena_safe_update_stat(u64 *src, u64 *dst,
 				 struct u64_stats_sync *syncp)
@@ -176,11 +194,10 @@ static void ena_dev_admin_queue_stats(struct ena_adapter *adapter, u64 **data)
 	}
 }
 
-static void ena_get_ethtool_stats(struct net_device *netdev,
-				  struct ethtool_stats *stats,
-				  u64 *data)
+static void ena_get_stats(struct ena_adapter *adapter,
+			  u64 *data,
+			  bool eni_stats_needed)
 {
-	struct ena_adapter *adapter = netdev_priv(netdev);
 	const struct ena_stats *ena_stats;
 	u64 *ptr;
 	int i;
@@ -193,10 +210,42 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 		ena_safe_update_stat(ptr, data++, &adapter->syncp);
 	}
 
+	if (eni_stats_needed) {
+		ena_update_hw_stats(adapter);
+		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
+			ena_stats = &ena_stats_eni_strings[i];
+
+			ptr = (u64 *)&adapter->eni_stats +
+				ena_stats->stat_offset;
+
+			ena_safe_update_stat(ptr, data++, &adapter->syncp);
+		}
+	}
+
 	ena_queue_stats(adapter, &data);
 	ena_dev_admin_queue_stats(adapter, &data);
 }
 
+static void ena_get_ethtool_stats(struct net_device *netdev,
+				  struct ethtool_stats *stats,
+				  u64 *data)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	ena_get_stats(adapter, data, adapter->eni_stats_supported);
+}
+
+static int ena_get_sw_stats_count(struct ena_adapter *adapter)
+{
+	return adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
+}
+
+static int ena_get_hw_stats_count(struct ena_adapter *adapter)
+{
+	return ENA_STATS_ARRAY_ENI(adapter);
+}
+
 int ena_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
@@ -204,8 +253,7 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
-	return adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
-		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
+	return ena_get_sw_stats_count(adapter) + ena_get_hw_stats_count(adapter);
 }
 
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
@@ -247,25 +295,43 @@ static void ena_com_dev_strings(u8 **data)
 	}
 }
 
-static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+static void ena_get_strings(struct ena_adapter *adapter,
+			    u8 *data,
+			    bool eni_stats_needed)
 {
-	struct ena_adapter *adapter = netdev_priv(netdev);
 	const struct ena_stats *ena_stats;
 	int i;
 
-	if (sset != ETH_SS_STATS)
-		return;
-
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
 		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
 		data += ETH_GSTRING_LEN;
 	}
 
+	if (eni_stats_needed) {
+		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
+			ena_stats = &ena_stats_eni_strings[i];
+			memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+	}
+
 	ena_queue_strings(adapter, &data);
 	ena_com_dev_strings(&data);
 }
 
+static void ena_get_ethtool_strings(struct net_device *netdev,
+				    u32 sset,
+				    u8 *data)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	ena_get_strings(adapter, data, adapter->eni_stats_supported);
+}
+
 static int ena_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *link_ksettings)
 {
@@ -845,7 +911,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_ringparam		= ena_get_ringparam,
 	.set_ringparam		= ena_set_ringparam,
 	.get_sset_count         = ena_get_sset_count,
-	.get_strings		= ena_get_strings,
+	.get_strings		= ena_get_ethtool_strings,
 	.get_ethtool_stats      = ena_get_ethtool_stats,
 	.get_rxnfc		= ena_get_rxnfc,
 	.set_rxnfc		= ena_set_rxnfc,
@@ -873,7 +939,7 @@ static void ena_dump_stats_ex(struct ena_adapter *adapter, u8 *buf)
 	int strings_num;
 	int i, rc;
 
-	strings_num = ena_get_sset_count(netdev, ETH_SS_STATS);
+	strings_num = ena_get_sw_stats_count(adapter);
 	if (strings_num <= 0) {
 		netif_err(adapter, drv, netdev, "Can't get stats num\n");
 		return;
@@ -893,13 +959,13 @@ static void ena_dump_stats_ex(struct ena_adapter *adapter, u8 *buf)
 				GFP_ATOMIC);
 	if (!data_buf) {
 		netif_err(adapter, drv, netdev,
-			  "failed to allocate data buf\n");
+			  "Failed to allocate data buf\n");
 		devm_kfree(&adapter->pdev->dev, strings_buf);
 		return;
 	}
 
-	ena_get_strings(netdev, ETH_SS_STATS, strings_buf);
-	ena_get_ethtool_stats(netdev, NULL, data_buf);
+	ena_get_strings(adapter, strings_buf, false);
+	ena_get_stats(adapter, data_buf, false);
 
 	/* If there is a buffer, dump stats, otherwise print them to dmesg */
 	if (buf)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a3a8edf9a..08474db75 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3178,6 +3178,19 @@ err:
 	ena_com_delete_debug_area(adapter->ena_dev);
 }
 
+int ena_update_hw_stats(struct ena_adapter *adapter)
+{
+	int rc = 0;
+
+	rc = ena_com_get_eni_stats(adapter->ena_dev, &adapter->eni_stats);
+	if (rc) {
+		dev_info_once(&adapter->pdev->dev, "Failed to get ENI stats\n");
+		return rc;
+	}
+
+	return 0;
+}
+
 static void ena_get_stats64(struct net_device *netdev,
 			    struct rtnl_link_stats64 *stats)
 {
@@ -4296,6 +4309,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_config_debug_area(adapter);
 
+	if (!ena_update_hw_stats(adapter))
+		adapter->eni_stats_supported = true;
+	else
+		adapter->eni_stats_supported = false;
+
 	memcpy(adapter->netdev->perm_addr, adapter->mac_addr, netdev->addr_len);
 
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0c8504006..4c95a4d93 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -405,6 +405,8 @@ struct ena_adapter {
 
 	struct u64_stats_sync syncp;
 	struct ena_stats_dev dev_stats;
+	struct ena_admin_eni_stats eni_stats;
+	bool eni_stats_supported;
 
 	/* last queue index that was checked for uncompleted tx packets */
 	u32 last_monitored_tx_qid;
@@ -422,6 +424,8 @@ void ena_dump_stats_to_dmesg(struct ena_adapter *adapter);
 
 void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 
+int ena_update_hw_stats(struct ena_adapter *adapter);
+
 int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size);
-- 
2.16.6

