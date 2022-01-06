Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE15486A82
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbiAFT3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:29:52 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:32532 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243323AbiAFT3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497387; x=1673033387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sAyHvla/aXjJhTtL+MMGA2aWsmcLF6uz73KMCxr+xcw=;
  b=jZWIL0WJe9hP36u27Lj48EPptILnEapyCgTsGGEVLr82EoDFjI+9+6VZ
   xZ+/q4pDx4Z0Iqqh/AczEcbqSqtFc50tcQPQ3dXLtHC/jdmfjTO5/BLMO
   37TZkQW5w7/YeU9GAPc4izg11WH1RGAlohFY+u6lRelZR9L034KxpbkL2
   g=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="982817123"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 06 Jan 2022 19:29:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id D6692430E0;
        Thu,  6 Jan 2022 19:29:30 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:30 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:28 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net-next 03/10] net: ena: Change ENI stats support check to use capabilities field
Date:   Thu, 6 Jan 2022 19:29:08 +0000
Message-ID: <20220106192915.22616-4-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the capabilities field to query the device for ENI stats
support.

This replaces the previous method that tried to get the ENI stats
during ena_probe() and used the success or failure as an indication
for support by the device.

Remove eni_stats_supported field from struct ena_adapter. This field
was used for the previous method of queriying for ENI stats support.

Change the severity level of the print in case of
ena_com_get_eni_stats() failure from info to error.
With the previous method of querying form ENI stats support, failure
to get ENI stats was normal for devices that don't support it.
With the use of the capabilities field such a failure is unexpected,
as it is called only if the device reported that it supports ENI
stats.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 13 ++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  9 ++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  1 -
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 6b9b43e422c1..c09e1b37048e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -110,8 +110,7 @@ static const struct ena_stats ena_stats_ena_com_strings[] = {
 #define ENA_STATS_ARRAY_TX		ARRAY_SIZE(ena_stats_tx_strings)
 #define ENA_STATS_ARRAY_RX		ARRAY_SIZE(ena_stats_rx_strings)
 #define ENA_STATS_ARRAY_ENA_COM		ARRAY_SIZE(ena_stats_ena_com_strings)
-#define ENA_STATS_ARRAY_ENI(adapter)	\
-	(ARRAY_SIZE(ena_stats_eni_strings) * (adapter)->eni_stats_supported)
+#define ENA_STATS_ARRAY_ENI(adapter)	ARRAY_SIZE(ena_stats_eni_strings)
 
 static void ena_safe_update_stat(u64 *src, u64 *dst,
 				 struct u64_stats_sync *syncp)
@@ -213,8 +212,9 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 				  u64 *data)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct ena_com_dev *dev = adapter->ena_dev;
 
-	ena_get_stats(adapter, data, adapter->eni_stats_supported);
+	ena_get_stats(adapter, data, ena_com_get_cap(dev, ENA_ADMIN_ENI_STATS));
 }
 
 static int ena_get_sw_stats_count(struct ena_adapter *adapter)
@@ -226,7 +226,9 @@ static int ena_get_sw_stats_count(struct ena_adapter *adapter)
 
 static int ena_get_hw_stats_count(struct ena_adapter *adapter)
 {
-	return ENA_STATS_ARRAY_ENI(adapter);
+	bool supported = ena_com_get_cap(adapter->ena_dev, ENA_ADMIN_ENI_STATS);
+
+	return ENA_STATS_ARRAY_ENI(adapter) * supported;
 }
 
 int ena_get_sset_count(struct net_device *netdev, int sset)
@@ -316,10 +318,11 @@ static void ena_get_ethtool_strings(struct net_device *netdev,
 				    u8 *data)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct ena_com_dev *dev = adapter->ena_dev;
 
 	switch (sset) {
 	case ETH_SS_STATS:
-		ena_get_strings(adapter, data, adapter->eni_stats_supported);
+		ena_get_strings(adapter, data, ena_com_get_cap(dev, ENA_ADMIN_ENI_STATS));
 		break;
 	}
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 78770984ec95..f0fbecb8019f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3253,11 +3253,11 @@ static void ena_config_debug_area(struct ena_adapter *adapter)
 
 int ena_update_hw_stats(struct ena_adapter *adapter)
 {
-	int rc = 0;
+	int rc;
 
 	rc = ena_com_get_eni_stats(adapter->ena_dev, &adapter->eni_stats);
 	if (rc) {
-		dev_info_once(&adapter->pdev->dev, "Failed to get ENI stats\n");
+		netdev_err(adapter->netdev, "Failed to get ENI stats\n");
 		return rc;
 	}
 
@@ -4385,11 +4385,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_config_debug_area(adapter);
 
-	if (!ena_update_hw_stats(adapter))
-		adapter->eni_stats_supported = true;
-	else
-		adapter->eni_stats_supported = false;
-
 	memcpy(adapter->netdev->perm_addr, adapter->mac_addr, netdev->addr_len);
 
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 9391c7101fba..f70f1242e5b5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -379,7 +379,6 @@ struct ena_adapter {
 	struct u64_stats_sync syncp;
 	struct ena_stats_dev dev_stats;
 	struct ena_admin_eni_stats eni_stats;
-	bool eni_stats_supported;
 
 	/* last queue index that was checked for uncompleted tx packets */
 	u32 last_monitored_tx_qid;
-- 
2.32.0

