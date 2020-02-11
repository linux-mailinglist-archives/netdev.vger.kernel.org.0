Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8B21592C1
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgBKPSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:15 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1963 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbgBKPSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434293; x=1612970293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l/a1pLNWWE2OchmWArAIEYrBwi6n5EuRPWvZ0cV8+z0=;
  b=H0LyKUD+7uLGH44mamln/3wsbZJWjx+WctejIVGSsSxCA/23uSNYdvj4
   lu31GuVitp2gIP5wm0hOn42krc6lwJzDWPBtYvqw9quuj6kip71NIuVJA
   Ka3qfE7xYo1d2kUNA9wwIuls0c9qtVZUzvchMc+mcAkrPOCEdG43kD1ec
   Q=;
IronPort-SDR: s+gzmK/yT3G17MdGcE2WzKsCbZVvy3bIIxnwAlGsZu5YSJ1Jatrzt4M9/x5IW9SJXJwtkm3Rye
 sRfwxlGC5qSQ==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="25719275"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Feb 2020 15:18:13 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 23E46A26B9;
        Tue, 11 Feb 2020 15:18:13 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id B415B81D3F; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 08/12] net: ena: fix incorrectly saving queue numbers when setting RSS indirection table
Date:   Tue, 11 Feb 2020 15:17:47 +0000
Message-ID: <20200211151751.29718-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
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
uneven indices for Rx, where every Tx/Rx pair are in a consecutive order
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

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 24 ++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8be9df885..610a7c63e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -636,6 +636,28 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 	return ENA_HASH_KEY_SIZE;
 }
 
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
@@ -644,7 +666,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	u8 func;
 	int rc;
 
-	rc = ena_com_indirect_table_get(adapter->ena_dev, indir);
+	rc = ena_indirection_table_get(adapter, indir);
 	if (rc)
 		return rc;
 
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

