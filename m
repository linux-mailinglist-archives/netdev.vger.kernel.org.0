Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63861592C8
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgBKPSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:31 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1800 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730338AbgBKPS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434307; x=1612970307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YSsJ0iK3iqY4N2zMgWbTRsLmGYFSKLe8j6oU5rsDQbY=;
  b=YPIg2fHFNgN0vmm5s+c9zDMrVm3K9EGFvxWYut80WT2ZWkpkvPqh55Rk
   uQN+yC5RbLV/OIGZHV8ZJE295jTMOzv516JD/77RT0hGOAB1hI6DRtzoN
   SnYH2VbF1jll9y+jslQ7g9v8/Z94ouSMUYZ3hIMh6wHz7gzYArYMkrani
   Y=;
IronPort-SDR: Flw39PEOZ5pDClsp14rl+YBAefX4Y36Euy5BV9NRw5qw4CBCnPatWrAbnB1i8Y2kjPwxvbWVKQ
 6rZA44nHKk2w==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="17206463"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Feb 2020 15:18:14 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 33C1AA202F;
        Tue, 11 Feb 2020 15:18:13 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id B947C81D42; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 10/12] net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
Date:   Tue, 11 Feb 2020 15:17:49 +0000
Message-ID: <20200211151751.29718-11-sameehj@amazon.com>
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

As the name suggests ETH_RSS_HASH_NO_CHANGE is received upon changing
the key or indirection table using ethtool while keeping the same hash
function.

Also add a function for retrieving the current hash function from
the ena-com layer.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Saeed Bshara <saeedb@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 5 +++++
 drivers/net/ethernet/amazon/ena/ena_com.h     | 8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 74743fd8a..0f93d1092 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1041,6 +1041,11 @@ static int ena_com_get_feature(struct ena_com_dev *ena_dev,
 				      feature_ver);
 }
 
+int ena_com_get_current_hash_function(struct ena_com_dev *ena_dev)
+{
+	return ena_dev->rss.hash_func;
+}
+
 static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
 {
 	struct ena_admin_feature_rss_flow_hash_control *hash_key =
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 9b5bd28ed..469f29819 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -656,6 +656,14 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 log_size);
  */
 void ena_com_rss_destroy(struct ena_com_dev *ena_dev);
 
+/* ena_com_get_current_hash_function - Get RSS hash function
+ * @ena_dev: ENA communication layer struct
+ *
+ * Return the current hash function.
+ * @return: 0 or one of the ena_admin_hash_functions values.
+ */
+int ena_com_get_current_hash_function(struct ena_com_dev *ena_dev);
+
 /* ena_com_fill_hash_function - Fill RSS hash function
  * @ena_dev: ENA communication layer struct
  * @func: The hash function (Toeplitz or crc)
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 610a7c63e..b8ce7adb2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -736,6 +736,9 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	}
 
 	switch (hfunc) {
+	case ETH_RSS_HASH_NO_CHANGE:
+		func = ena_com_get_current_hash_function(ena_dev);
+		break;
 	case ETH_RSS_HASH_TOP:
 		func = ENA_ADMIN_TOEPLITZ;
 		break;
-- 
2.24.1.AMZN

