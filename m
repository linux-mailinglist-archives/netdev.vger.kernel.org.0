Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8132E186B31
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgCPMjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:39:11 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:33738 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731009AbgCPMjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362351; x=1615898351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=pvZBrFtkxBkW6alsPie/s0p9CuEtGpQ8ElBRMG34V+M=;
  b=EyKwdQYFQxjr8vMwCMMfcJL1kI4vTf7SCTSEeVfth52gaZFqhZn6bfpJ
   +Mow+F9ojZGZ4TrqivYN4AxU9VNESCGKbl7zgh8bAySebNKJWNJEyA1Gl
   bx1s1GPwd0aVlNOLjIBjGrrFf7T9wXzICzE9KsGwjS5BGpZ9LhqyYcVJj
   o=;
IronPort-SDR: EiIJafrQ5lI4wt/cBHprymZVL/V2VCYYkVeKdIc97yDLsa/nSBAITi1e6lx1Ddvp7PJOTqTgQl
 UQN8RBCxsDcw==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="32802885"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Mar 2020 12:39:09 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 059CAA2108;
        Mon, 16 Mar 2020 12:39:07 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:38:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:38:47 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:38:42 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 3/7] net: ena: fix inability to set RSS hash function without changing the key
Date:   Mon, 16 Mar 2020 14:38:20 +0200
Message-ID: <1584362304-274-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584362304-274-1-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Current code does not allow setting the hash function without
changing the key. This commit enables it.

To achieve this we separate ena_com_get_hash_function() into 2 functions:
ena_com_get_hash_function() - which gets only the hash function, and
ena_com_get_hash_key() - which gets only the hash key.

Also return 0 instead of rc at the end of ena_get_rxfh() since all
previous operations succeeded.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 13 ++++++++----
 drivers/net/ethernet/amazon/ena/ena_com.h     | 21 +++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 10 ++++-----
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e648773e3d11..340e5a288ff9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2342,13 +2342,10 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
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
@@ -2366,6 +2363,14 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
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
index 469f298199a7..e2e2fd1dc820 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -695,13 +695,11 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
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
@@ -709,9 +707,20 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev);
  * @return: 0 on Success and negative value otherwise.
  */
 int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
-			      enum ena_admin_hash_functions *func,
-			      u8 *key);
+			      enum ena_admin_hash_functions *func);
 
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
  * @proto: The protocol to configure.
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index ced1d577b62a..d1a320b1774d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -673,8 +673,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	/* We call this function in order to check if the device
 	 * supports getting/setting the hash function.
 	 */
-	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
-
+	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func);
 	if (rc) {
 		if (rc == -EOPNOTSUPP) {
 			key = NULL;
@@ -685,6 +684,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		return rc;
 	}
 
+	rc = ena_com_get_hash_key(adapter->ena_dev, key);
 	if (rc)
 		return rc;
 
@@ -704,7 +704,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (hfunc)
 		*hfunc = func;
 
-	return rc;
+	return 0;
 }
 
 static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
@@ -712,7 +712,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	enum ena_admin_hash_functions func;
+	enum ena_admin_hash_functions func = 0;
 	int rc, i;
 
 	if (indir) {
@@ -751,7 +751,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 		return -EOPNOTSUPP;
 	}
 
-	if (key) {
+	if (key || func) {
 		rc = ena_com_fill_hash_function(ena_dev, func, key,
 						ENA_HASH_KEY_SIZE,
 						0xFFFFFFFF);
-- 
2.17.1

