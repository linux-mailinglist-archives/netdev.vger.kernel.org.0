Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC521169445
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgBWC3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbgBWCYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2902224653;
        Sun, 23 Feb 2020 02:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424642;
        bh=6RAYqhZkztp9brYEQNnupL4sGw7t+n7osvA4zS4qfLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L69e7+S/sN3YtWHX6GbYLYQCRVU8Z4wIXu/mycMkVhXV0jPai7j12zj2fUM7NJIkw
         mfz6HJlzDaCIqU5RYD5UqHfRKs/K20RlOJdWLMO8zVGhxxZ34pUSzz2fnmOUPyW1v9
         HQrBchfwrI+9laLvrYYJ3OY1HCWoneloZOrm51y0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/25] net: ena: fix incorrectly saving queue numbers when setting RSS indirection table
Date:   Sat, 22 Feb 2020 21:23:33 -0500
Message-Id: <20200223022339.1885-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022339.1885-1-sashal@kernel.org>
References: <20200223022339.1885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 92569fd27f5cb0ccbdf7c7d70044b690e89a0277 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 24 ++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index dc63aa912aebb..d6d79366b7fc1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -649,6 +649,28 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
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
@@ -657,7 +679,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	u8 func;
 	int rc;
 
-	rc = ena_com_indirect_table_get(adapter->ena_dev, indir);
+	rc = ena_indirection_table_get(adapter, indir);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 7c7ae56c52cfd..f4783effe5c04 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -113,6 +113,8 @@
 
 #define ENA_IO_TXQ_IDX(q)	(2 * (q))
 #define ENA_IO_RXQ_IDX(q)	(2 * (q) + 1)
+#define ENA_IO_TXQ_IDX_TO_COMBINED_IDX(q)	((q) / 2)
+#define ENA_IO_RXQ_IDX_TO_COMBINED_IDX(q)	(((q) - 1) / 2)
 
 #define ENA_MGMNT_IRQ_IDX		0
 #define ENA_IO_IRQ_FIRST_IDX		1
-- 
2.20.1

