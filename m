Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A631B39D1
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDVIQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:38 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:20174 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgDVIQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543394; x=1619079394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVTJV5JwUQo1OJFdp4+zEFoQwshHnnlyJfWzPtFccRk=;
  b=v2A+1YqLtcXnF5jVpOl7POjc3qgCMheDS8Ko/qXJBW1wu/6V61CV6lBj
   jgXsOX5MoZN78WUNTJbwK17TD+53cpGkksUBD2Oh7RqDUFGtLGMnIu9fN
   6/RaRqszsoDFtPd/zwwwj2VwO6n5MAUBlM350ha+vNzRaXuqYI/26KOkO
   g=;
IronPort-SDR: tInS5ZlhOVNnCl3b91mmoX3GJVlYwIPJgmdjRzRQnKcIUTi+I7ViKq6laGuW/98q+cv8TWP8Sq
 EVtaFIsIeNvA==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="26716751"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 708D5A2031;
        Wed, 22 Apr 2020 08:16:32 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 8A5B081D43; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 13/13] net: ena: cosmetic: extract code to ena_indirection_table_set()
Date:   Wed, 22 Apr 2020 08:16:28 +0000
Message-ID: <20200422081628.8103-14-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
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

