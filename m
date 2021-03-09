Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E66332CEF
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCIRL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:11:26 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:52242 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhCIRLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615309881; x=1646845881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4MvWE3cDFSMIbrb+BK9H/+yAHFhHkaEy5fuukDMO1ko=;
  b=WQGjVHanzQ0+MJ3HSAfwgK8OcoA2D1A/BPLP3sFIDf4ILbdqkx0qz/zB
   cUVB4ERaKt6BZZ4+qtdHaeKRPCcktXEa51Zb4xBA41/YTI5hX2HO0nSNS
   IiQkCYJvKXTpA3wBaJsvK3yHPeg96J2Oc2T42CprrdpBZz3tKdNL5Wf96
   o=;
X-IronPort-AV: E=Sophos;i="5.81,236,1610409600"; 
   d="scan'208";a="97176919"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Mar 2021 17:11:14 +0000
Received: from EX13D28EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 0C74DA2059;
        Tue,  9 Mar 2021 17:11:13 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.161.244) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Mar 2021 17:11:04 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [RFC Patch v1 3/3] net: ena: support ethtool priv-flags and LPC state change
Date:   Tue, 9 Mar 2021 19:10:14 +0200
Message-ID: <20210309171014.2200020-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309171014.2200020-1-shayagr@amazon.com>
References: <20210309171014.2200020-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D10UWA001.ant.amazon.com (10.43.160.216) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ethtool private flags show/set to the driver.
The first feature added to this infrastructure is Local Page Cache.

The LPC state query returns whether the LPC is currently used in the
driver. This is not the same as if LPC is enabled since in XDP case LPC
won't be used even if the user required it, and the cache might be
turned on right after the XDP program is unloaded.

The LPC state change toggles between an LPC cache size of 0 (i.e.
disabled cache) and the size ENA_LPC_DEFAULT_MULTIPLIER * 1024
(equals to 2048).

This patch also documents the private flag support for LPC it the
README.rst file.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    |  3 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 53 ++++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 32 +++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 4 files changed, 83 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index d3423a2f472c..63735f1dc216 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -232,6 +232,9 @@ size).
 
 When enabled, LPC cache size is ENA_LPC_DEFAULT_MULTIPLIER * 1024 (2048 by
 default) pages.
+The feature can be toggled between on/off state using ethtool private flags,
+e.g.
+    # ethtool --set-priv-flags eth1 local_page_cache off
 
 The cache usage for each queue can be monitored using ``ethtool -S`` counters. Where:
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index fe16b3d5bd73..aea76dc51dff 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -116,6 +116,13 @@ static const struct ena_stats ena_stats_ena_com_strings[] = {
 #define ENA_STATS_ARRAY_ENI(adapter)	\
 	(ARRAY_SIZE(ena_stats_eni_strings) * (adapter)->eni_stats_supported)
 
+static const char ena_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define ENA_PRIV_FLAGS_LPC	BIT(0)
+	"local_page_cache",
+};
+
+#define ENA_PRIV_FLAGS_NR ARRAY_SIZE(ena_priv_flags_strings)
+
 static void ena_safe_update_stat(u64 *src, u64 *dst,
 				 struct u64_stats_sync *syncp)
 {
@@ -236,10 +243,15 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	if (sset != ETH_SS_STATS)
-		return -EOPNOTSUPP;
+	switch (sset) {
+	case ETH_SS_STATS:
+		return ena_get_sw_stats_count(adapter) +
+		       ena_get_hw_stats_count(adapter);
+	case ETH_SS_PRIV_FLAGS:
+		return ENA_PRIV_FLAGS_NR;
+	}
 
-	return ena_get_sw_stats_count(adapter) + ena_get_hw_stats_count(adapter);
+	return -EOPNOTSUPP;
 }
 
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
@@ -320,10 +332,14 @@ static void ena_get_ethtool_strings(struct net_device *netdev,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	if (sset != ETH_SS_STATS)
-		return;
-
-	ena_get_strings(adapter, data, adapter->eni_stats_supported);
+	switch (sset) {
+	case ETH_SS_STATS:
+		ena_get_strings(adapter, data, adapter->eni_stats_supported);
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, ena_priv_flags_strings, sizeof(ena_priv_flags_strings));
+		break;
+	}
 }
 
 static int ena_get_link_ksettings(struct net_device *netdev,
@@ -460,6 +476,8 @@ static void ena_get_drvinfo(struct net_device *dev,
 	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
+
+	info->n_priv_flags = ENA_PRIV_FLAGS_NR;
 }
 
 static void ena_get_ringparam(struct net_device *netdev,
@@ -892,6 +910,25 @@ static int ena_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
+static u32 ena_get_priv_flags(struct net_device *netdev)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (adapter->rx_ring->page_cache)
+		priv_flags |= ENA_PRIV_FLAGS_LPC;
+
+	return priv_flags;
+}
+
+static int ena_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	/* LPC is the only supported private flag for now */
+	return ena_set_lpc_state(adapter, !!(priv_flags & ENA_PRIV_FLAGS_LPC));
+}
+
 static const struct ethtool_ops ena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
@@ -918,6 +955,8 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
 	.get_ts_info            = ethtool_op_get_ts_info,
+	.get_priv_flags		= ena_get_priv_flags,
+	.set_priv_flags		= ena_set_priv_flags,
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 9f6cc479506f..1ec9e24d8c8c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2804,6 +2804,11 @@ static bool ena_is_lpc_supported(struct ena_adapter *adapter,
 			  "Local page cache is disabled for less than %d channels\n",
 			  ENA_LPC_MIN_NUM_OF_CHANNELS);
 
+		/* Disable LPC for such case. It can enabled again through
+		 * ethtool private-flag.
+		 */
+		adapter->lpc_size = 0;
+
 		return false;
 	}
 
@@ -3063,6 +3068,33 @@ static int ena_close(struct net_device *netdev)
 	return 0;
 }
 
+int ena_set_lpc_state(struct ena_adapter *adapter, bool enabled)
+{
+	/* In XDP, lpc_size might be positive even with LPC disabled, use cache
+	 * pointer instead.
+	 */
+	struct ena_page_cache *page_cache = adapter->rx_ring->page_cache;
+
+	/* Exit early if LPC state doesn't change */
+	if (enabled == !!page_cache)
+		return 0;
+
+	if (enabled && !ena_is_lpc_supported(adapter, adapter->rx_ring, true))
+		return -EOPNOTSUPP;
+
+	adapter->lpc_size = enabled ? ENA_LPC_DEFAULT_MULTIPLIER : 0;
+
+	/* rtnl lock is already obtained in dev_ioctl() layer, so it's safe to
+	 * re-initialize IO resources.
+	 */
+	if (test_bit(ENA_FLAG_DEV_UP, &adapter->flags)) {
+		ena_close(adapter->netdev);
+		ena_up(adapter);
+	}
+
+	return 0;
+}
+
 int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 242c9ce4a782..95b0d16dc71e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -430,6 +430,8 @@ void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 
 int ena_update_hw_stats(struct ena_adapter *adapter);
 
+int ena_set_lpc_state(struct ena_adapter *adapter, bool enabled);
+
 int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size);
-- 
2.25.1

