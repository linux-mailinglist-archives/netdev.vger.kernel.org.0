Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D419014CC0A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgA2OEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:51 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5578 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgA2OEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306688; x=1611842688;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FEa6qnZP6c9EhlesHMXmTJOmhSWzu6aadMb/V9rP/sc=;
  b=Ygm+XphdqYlXYJH2R7eoL9g6/D8kp7+De76xx9cidyhJB/RnlwN7yvUT
   AzUWBocsWQW3P/xWV89uYHOWMB+VoCgQwfMbvHJVFBOLZARabP9/8nEjS
   KAWm9G76Zq8pjoq7YslqKw05oc3KCQXATZ1lJrvN3ABr9qz3TT7bM9QfH
   U=;
IronPort-SDR: Hzcbn0MepiG7gjIbin3rfJw67iglhVHoePL6Tqld24NRD2tqISE2mNAOoJvXHO8cPcBCcu+Wtl
 spUMRRZaolHQ==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="14761248"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 Jan 2020 14:04:46 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id C74DEA2397;
        Wed, 29 Jan 2020 14:04:45 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:30 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:25 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A600E81D0C; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 06/11] net: ena: rss: fix failure to get indirection table
Date:   Wed, 29 Jan 2020 14:04:17 +0000
Message-ID: <20200129140422.20166-7-sameehj@amazon.com>
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

Bug:
The get indirection table will fail on older hardware versions. This
happens because getting/setting the hash function is not supported on
this hardware. In short ena_indirection_table_get() succeeds while
the call to ena_com_get_hash_function() fails when ena_get_rxfh() is
executed.

Fix:
Simply set the hash function to the default value - Toeplitz - in case the
error is EOPNOTSUPP.

Also:
* Separate hash and key retrieval
* Fix restoring the hash function in ena_com_fill_hash_function()
* Reverse christmas tree in ena_com_fill_hash_function()

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 24 ++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_com.h     | 22 ++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 10 +++++---
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 9e6c50b97..8bcf76f92 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2295,12 +2295,14 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 			       enum ena_admin_hash_functions func,
 			       const u8 *key, u16 key_len, u32 init_val)
 {
-	struct ena_rss *rss = &ena_dev->rss;
+	struct ena_admin_feature_rss_flow_hash_control *hash_key;
 	struct ena_admin_get_feat_resp get_resp;
-	struct ena_admin_feature_rss_flow_hash_control *hash_key =
-		rss->hash_key;
+	enum ena_admin_hash_functions old_func;
+	struct ena_rss *rss = &ena_dev->rss;
 	int rc;
 
+	hash_key = rss->hash_key;
+
 	/* Make sure size is a mult of DWs */
 	if (unlikely(key_len & 0x3))
 		return -EINVAL;
@@ -2338,24 +2340,22 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EINVAL;
 	}
 
+	old_func = rss->hash_func;
 	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
 
 	/* Restore the old function */
 	if (unlikely(rc))
-		ena_com_get_hash_function(ena_dev, NULL, NULL);
+		rss->hash_func = old_func;
 
 	return rc;
 }
 
 int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
-			      enum ena_admin_hash_functions *func,
-			      u8 *key)
+			      enum ena_admin_hash_functions *func)
 {
 	struct ena_rss *rss = &ena_dev->rss;
 	struct ena_admin_get_feat_resp get_resp;
-	struct ena_admin_feature_rss_flow_hash_control *hash_key =
-		rss->hash_key;
 	int rc;
 
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
@@ -2373,6 +2373,14 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (func)
 		*func = rss->hash_func;
 
+	return 0;
+}
+
+int ena_com_get_hash_key(struct ena_com_dev *ena_dev, u8 *key)
+{
+	struct ena_admin_feature_rss_flow_hash_control *hash_key =
+		ena_dev->rss.hash_key;
+
 	if (key)
 		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 91c048872..ea925bb01 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -687,13 +687,11 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
  */
 int ena_com_set_hash_function(struct ena_com_dev *ena_dev);
 
-/* ena_com_get_hash_function - Retrieve the hash function and the hash key
- * from the device.
+/* ena_com_get_hash_function - Retrieve the hash function from the device.
  * @ena_dev: ENA communication layer struct
  * @func: hash function
- * @key: hash key
  *
- * Retrieve the hash function and the hash key from the device.
+ * Retrieve the hash function from the device.
  *
  * @note: If the caller called ena_com_fill_hash_function but didn't flash
  * it to the device, the new configuration will be lost.
@@ -701,8 +699,20 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev);
  * @return: 0 on Success and negative value otherwise.
  */
 int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
-			      enum ena_admin_hash_functions *func,
-			      u8 *key);
+			      enum ena_admin_hash_functions *func);
+
+/* ena_com_get_hash_key - Retrieve the hash key
+ * @ena_dev: ENA communication layer struct
+ * @key: hash key
+ *
+ * Retrieve the hash key.
+ *
+ * @note: If the caller called ena_com_fill_hash_key but didn't flash
+ * it to the device, the new configuration will be lost.
+ *
+ * @return: 0 on Success and negative value otherwise.
+ */
+int ena_com_get_hash_key(struct ena_com_dev *ena_dev, u8 *key);
 
 /* ena_com_fill_hash_ctrl - Fill RSS hash control
  * @ena_dev: ENA communication layer struct.
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8b56383b6..d0d91dbe0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -640,7 +640,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 			u8 *hfunc)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
-	enum ena_admin_hash_functions ena_func;
+	enum ena_admin_hash_functions ena_func = ENA_ADMIN_TOEPLITZ;
 	u8 func;
 	int rc;
 
@@ -648,10 +648,14 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (rc)
 		return rc;
 
-	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
+	rc = ena_com_get_hash_key(adapter->ena_dev, key);
 	if (rc)
 		return rc;
 
+	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func);
+	if (rc && rc != -EOPNOTSUPP)
+		return rc;
+
 	switch (ena_func) {
 	case ENA_ADMIN_TOEPLITZ:
 		func = ETH_RSS_HASH_TOP;
@@ -668,7 +672,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (hfunc)
 		*hfunc = func;
 
-	return rc;
+	return 0;
 }
 
 static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
-- 
2.24.1.AMZN

