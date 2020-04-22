Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE981B39B2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgDVIKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:10:12 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:51418 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgDVIKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543009; x=1619079009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVTJV5JwUQo1OJFdp4+zEFoQwshHnnlyJfWzPtFccRk=;
  b=txiw1gaOP2wkB5NRbZE3gRd1J1m6/PNvHahytnQvy9B08olAK+na9JTb
   AhQU9B+lCZ/z72L94obXuZD5YkRxYKpjv8flf4KP7EfGTQWQ35Prl6UAG
   zktDSKuNFiaRNeKNx4Pw0/C/TxxtgvYg3hdNm0qSKSc9wVcVYDzZZAd5g
   k=;
IronPort-SDR: sUHRSKk5fa4aB4gFKIsJvGEP+J29QVfIyu0Ui8SbSpUJCkhX/HmYhmuN2Gbf+opWkRkV/vgGY2
 WoKvUiH0rXjA==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="27053369"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Apr 2020 08:09:55 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id DF966A0578;
        Wed, 22 Apr 2020 08:09:54 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:40 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:38 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7BC6D81D32; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 13/13] net: ena: cosmetic: extract code to ena_indirection_table_set()
Date:   Wed, 22 Apr 2020 08:09:23 +0000
Message-ID: <20200422080923.6697-14-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422080923.6697-1-sameehj@amazon.com>
References: <20200422080923.6697-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Extract code to ena_indirection_table_set() to make
the code cleaner.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 48 ++++++++++++-------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index a736ad62af78..51efb9463b5d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -638,6 +638,32 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
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
 static int ena_indirection_table_get(struct ena_adapter *adapter, u32 *indir)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
@@ -712,26 +738,12 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	enum ena_admin_hash_functions func = 0;
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
-- 
2.24.1.AMZN

