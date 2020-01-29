Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C814CC05
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgA2OEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:42 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41370 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgA2OEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306682; x=1611842682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zjKmNALX3+qjJj5nuVDKPCkPe54PfDQLdbaLM3R8g2s=;
  b=u8Q2jvDB+afeqWza/fAMaYk01gQJZkL4+1PogZdb6+/7kRbzoOoR19n6
   7ot/6a2YIhh+cBp+ZD9RAM7NXMvN6T4g8b3/RKVQDpG1QgqVD+1/ZntfI
   Wv+0y7q/9onS9UdmcZOVAzL54pQHJkBVtEIxfxRewRJJvFUId7TKcOFN3
   c=;
IronPort-SDR: 35GEvo6Ia06vdQ4myw29Pe2OgnkGkMPG2zjIb8WkrfFINb/+7I9Rb9VOOFK2rjYMbhXSgFtH4g
 E/yhpQT93UDw==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="15296998"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Jan 2020 14:04:41 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id AADC7286E5D;
        Wed, 29 Jan 2020 14:04:40 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A0A9081D08; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 04/11] net: ena: fix incorrect default RSS key
Date:   Wed, 29 Jan 2020 14:04:15 +0000
Message-ID: <20200129140422.20166-5-sameehj@amazon.com>
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

Bug description:
When running "ethtool -x <if_name>" the key shows up as all zeros.

When we use "ethtool -X <if_name> hfunc toeplitz hkey <some:random:key>" to
set the key and then try to retrieve it using "ethtool -x <if_name>" then
we return the correct key because we return the one we saved.

Bug cause:
We don't fetch the key from the device but instead return the key
that we have saved internally which is by default set to zero upon
allocation.

Fix:
This commit fixes the issue by initializing the key to the default key that
is used by the device.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 24 +++++++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_com.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e54c44fdc..769339043 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -64,6 +64,15 @@
 
 #define ENA_POLL_MS	5
 
+/* Default Microsoft RSS key, used for HRSS. */
+static const u8 rss_hash_key[ENA_HASH_KEY_SIZE] = {
+		0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
+		0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
+		0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
+		0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
+		0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa
+};
+
 /*****************************************************************************/
 /*****************************************************************************/
 /*****************************************************************************/
@@ -1041,6 +1050,19 @@ static int ena_com_get_feature(struct ena_com_dev *ena_dev,
 				      feature_ver);
 }
 
+static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
+{
+	struct ena_admin_feature_rss_flow_hash_control *hash_key =
+		(ena_dev->rss).hash_key;
+
+	memcpy(hash_key->key, rss_hash_key, sizeof(rss_hash_key));
+	/* The key is stored in the device in u32 array
+	 * as well as the API requires the key to be passed in this
+	 * format. Thus the size of our array should be divided by 4
+	 */
+	hash_key->keys_num = sizeof(rss_hash_key) / sizeof(u32);
+}
+
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
@@ -2631,6 +2653,8 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	if (unlikely(rc))
 		goto err_hash_key;
 
+	ena_com_hash_key_fill_default_key(ena_dev);
+
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
 		goto err_hash_ctrl;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 0ce37d54e..91c048872 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -75,6 +75,7 @@
 #define ENA_INTR_INITIAL_TX_INTERVAL_USECS		64
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
 #define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
+#define ENA_HASH_KEY_SIZE				40
 
 #define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
 
-- 
2.24.1.AMZN

