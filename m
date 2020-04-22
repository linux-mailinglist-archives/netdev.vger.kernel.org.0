Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4201B39A9
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDVIJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:47 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:24755 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgDVIJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542975; x=1619078975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aAkVTBRIyyA6AVYINcgVpTmOBNzbXYQ6vXQ9yuj7pUc=;
  b=t3GLkKerC+4qy9KRQse+WqTwfU4G5aTiTlZuaBYNoetPTtxsbd+fzSYk
   6Sptdx7zfZc0k7/LJxWzOZq4oyadF6UJ23hkZc7fIlJXiMvT+P7QYvGl+
   nni/n9VItSdCi7MdFxBNT6Ri+Y3ccc8IZvr1RBGtfSQHAhPzvtzcNiOEh
   0=;
IronPort-SDR: zslQAAXfpn4DFcwWNPe7z/VYYL0x0Iwx3hYPP9xaSl+xEZeaczuUnB03XTLLYFDCdvptmJUgNE
 A+aI6sa0e+9w==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="38702251"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Apr 2020 08:09:33 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 6A6C3A2388;
        Wed, 22 Apr 2020 08:09:32 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 5DADB81CFE; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 03/13] net: ena: allow setting the hash function without changing the key
Date:   Wed, 22 Apr 2020 08:09:13 +0000
Message-ID: <20200422080923.6697-4-sameehj@amazon.com>
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

From: Sameeh Jubran <sameehj@amazon.com>

Current code does not allow setting the hash function without
changing the key. This commit enables it.

To achieve this we separate ena_com_get_hash_function() to 2 functions:
ena_com_get_hash_function() - which gets only the hash function, and
ena_com_get_hash_key() - which gets only the hash key.

Also return 0 instead of rc at the end of ena_get_rxfh() since all
previous operations succeeded.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 13 ++++++++----
 drivers/net/ethernet/amazon/ena/ena_com.h     | 21 +++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 12 +++++++----
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 66edc86c41c9..d428d0606166 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2338,13 +2338,10 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
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
 
 	if (unlikely(!func))
@@ -2364,6 +2361,14 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 
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
index 9cc28b4b2627..0c3a2f14387e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -672,7 +672,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	/* We call this function in order to check if the device
 	 * supports getting/setting the hash function.
 	 */
-	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
+	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func);
 	if (rc) {
 		if (rc == -EOPNOTSUPP) {
 			key = NULL;
@@ -683,6 +683,10 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		return rc;
 	}
 
+	rc = ena_com_get_hash_key(adapter->ena_dev, key);
+	if (rc)
+		return rc;
+
 	switch (ena_func) {
 	case ENA_ADMIN_TOEPLITZ:
 		func = ETH_RSS_HASH_TOP;
@@ -699,7 +703,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (hfunc)
 		*hfunc = func;
 
-	return rc;
+	return 0;
 }
 
 static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
@@ -707,7 +711,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	enum ena_admin_hash_functions func;
+	enum ena_admin_hash_functions func = 0;
 	int rc, i;
 
 	if (indir) {
@@ -746,7 +750,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 		return -EOPNOTSUPP;
 	}
 
-	if (key) {
+	if (key || func) {
 		rc = ena_com_fill_hash_function(ena_dev, func, key,
 						ENA_HASH_KEY_SIZE,
 						0xFFFFFFFF);
-- 
2.24.1.AMZN

