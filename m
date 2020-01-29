Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEED414CC00
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA2OE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:28 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41315 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgA2OE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306668; x=1611842668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJFqh4EX9DHia08wJq+17pwt+aQQDRbv3zQZUN6U6LI=;
  b=n4V1gDZtYin5BtAt11zM4vK3oYmYCgVaL0Ydnb/YD+tjaC3+l1LGYu3G
   Il1K6TwnuLwGpdTMyIFiXLU45LhH3ltwQ2wkXuti0USg8bREQXqeL4YJc
   n33hkv+fHJUHSYBBU+NuNLDtYsJiXgkHupxL0KsPcUd8MYNgCiE7JGmkn
   4=;
IronPort-SDR: OUqEeLInstc3/o7Zm9tTDsHn+bCDth+RW24mb8NL8yBrpfnlwD+aTkwuIzYvN/WvNGQjk8iLnd
 t7GyZSSK/LwA==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="15296951"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Jan 2020 14:04:27 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 826A0A1B0F;
        Wed, 29 Jan 2020 14:04:26 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:25 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A8BD281D0D; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 07/11] net: ena: fix incorrectly saving queue numbers when setting RSS indirection table
Date:   Wed, 29 Jan 2020 14:04:18 +0000
Message-ID: <20200129140422.20166-8-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200129140422.20166-1-sameehj@amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

The indirection table has the indices of the Rx queues. When we store it
during set indirection operation, we convert the indices to our internal
representation of the indices.

Our internal representation of the indices is: even indices for Tx and
odd indices for Rx, where every Tx/Rx pair are in a consecutive order
starting from 0. For example if the driver has 3 queues (3 for Tx and 3
for Rx) then the indices are as follows:
0  1  2  3  4  5
Tx Rx Tx Rx Tx Rx

The BUG:
The issue is that when we satisfy a get request for the indirection
table, we don't convert the indices back to the original representation.

The FIX:
Simply apply the inverse function for the indices of the indirection
table after we set it.

Also move the set code to a standalone function for code clarity.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 72 ++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 2 files changed, 55 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d0d91dbe0..accc4c8d1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -636,6 +636,54 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 	return ENA_HASH_KEY_SIZE;
 }
 
+static int ena_indirection_table_set(struct ena_adapter *adapter,
+				     const u32 *indir)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int i, rc;
+
+	for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
+		rc = ena_com_indirect_table_fill_entry(ena_dev,
+						       i,
+						       ENA_IO_RXQ_IDX(indir[i]));
+		if (unlikely(rc)) {
+			netif_err(adapter, drv, adapter->netdev,
+				  "Cannot fill indirect table (index is too large)\n");
+			return rc;
+		}
+	}
+
+	rc = ena_com_indirect_table_set(ena_dev);
+	if (rc) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "Cannot set indirect table\n");
+		return rc == -EPERM ? -EOPNOTSUPP : rc;
+	}
+	return rc;
+}
+
+static int ena_indirection_table_get(struct ena_adapter *adapter, u32 *indir)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int i, rc;
+
+	if (!indir)
+		return 0;
+
+	rc = ena_com_indirect_table_get(ena_dev, indir);
+	if (rc)
+		return rc;
+
+	/* Our internal representation of the indices is: even indices
+	 * for Tx and uneven indices for Rx. We need to convert the Rx
+	 * indices to be consecutive
+	 */
+	for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++)
+		indir[i] = ENA_IO_RXQ_IDX_TO_COMBINED_IDX(indir[i]);
+
+	return rc;
+}
+
 static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 			u8 *hfunc)
 {
@@ -644,7 +692,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	u8 func;
 	int rc;
 
-	rc = ena_com_indirect_table_get(adapter->ena_dev, indir);
+	rc = ena_indirection_table_get(adapter, indir);
 	if (rc)
 		return rc;
 
@@ -681,26 +729,12 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	enum ena_admin_hash_functions func;
-	int rc, i;
+	int rc;
 
 	if (indir) {
-		for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
-			rc = ena_com_indirect_table_fill_entry(ena_dev,
-							       i,
-							       ENA_IO_RXQ_IDX(indir[i]));
-			if (unlikely(rc)) {
-				netif_err(adapter, drv, netdev,
-					  "Cannot fill indirect table (index is too large)\n");
-				return rc;
-			}
-		}
-
-		rc = ena_com_indirect_table_set(ena_dev);
-		if (rc) {
-			netif_err(adapter, drv, netdev,
-				  "Cannot set indirect table\n");
-			return rc == -EPERM ? -EOPNOTSUPP : rc;
-		}
+		rc = ena_indirection_table_set(adapter, indir);
+		if (rc)
+			return rc;
 	}
 
 	switch (hfunc) {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index bffd778f2..2fe5eeea6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -129,6 +129,8 @@
 
 #define ENA_IO_TXQ_IDX(q)	(2 * (q))
 #define ENA_IO_RXQ_IDX(q)	(2 * (q) + 1)
+#define ENA_IO_TXQ_IDX_TO_COMBINED_IDX(q)	((q) / 2)
+#define ENA_IO_RXQ_IDX_TO_COMBINED_IDX(q)	(((q) - 1) / 2)
 
 #define ENA_MGMNT_IRQ_IDX		0
 #define ENA_IO_IRQ_FIRST_IDX		1
-- 
2.24.1.AMZN

