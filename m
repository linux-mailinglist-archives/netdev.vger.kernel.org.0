Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E7A1C2B08
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgECJwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:21426 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgECJwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499560; x=1620035560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xxcn6bDxLptwcRV0JOrmuuxRt/l/J6qUEO+vgADaBzg=;
  b=qv2PXrd1zxd9NIjGqzFOSAcUo8a3ds1nUx29V90/P7e7OCyL6V/t04r1
   s9dvooYAJEusDX4OOC+toof56cK30SEh9VGQR/3jty90frtz1ZKtaf05z
   2DA2RNMa9EJ2r0qRJAiCgV/b144ZK+1nuWjCCj9+D3ogr3mblKGzh9y6D
   Y=;
IronPort-SDR: VJ1w8Xw6xw1JfFfKNEQjsoL08yvXj/d73dTSPYMCHtwZL/LvOg8b4H5ZQBKyoexDAzg4rxIlYt
 scTMzniSFdag==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="32538901"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 03 May 2020 09:52:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 198F1A1E4C;
        Sun,  3 May 2020 09:52:39 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 8B35581F74; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 12/12] net: ena: cosmetic: extract code to ena_indirection_table_set()
Date:   Sun, 3 May 2020 09:52:21 +0000
Message-ID: <20200503095221.6408-13-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
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
index 74725d606964..830d3711d6ee 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -636,6 +636,32 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
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
@@ -710,26 +736,12 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
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

