Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18331C2B04
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgECJwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:30 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:21410 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgECJw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499549; x=1620035549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/2Dpi1Hlbs5TnalumwrJEGMPPpKeXIO/Id9hDrXaleg=;
  b=UZ3DO+2Fy2KB38xHI5hWQQLbNmGj585wGqIdb4IxuMMcFILsUpRMSnGE
   f5+Rp758zgAxj5Lg/LgzzzdiJXrxge7lJHE34BdFVZt+JXZvEiTdHRlzg
   EX5EzMF818AQTV4+sDbfXovERUdIgMDNQvwJbPvjXqB37pN7EhEk3GF3n
   4=;
IronPort-SDR: R1J3rjgrOpII075dv1J8LFUVwC807hkJZ2a7GQuF8t/qEMmuOuHcnrj+cnbyOrZgMx+RFI57g2
 HRiJ+DeEc+vA==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="32538899"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 03 May 2020 09:52:28 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 4B51DA02F9;
        Sun,  3 May 2020 09:52:26 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 781DC81D13; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 05/12] net: ena: changes to RSS hash key allocation
Date:   Sun, 3 May 2020 09:52:14 +0000
Message-ID: <20200503095221.6408-6-sameehj@amazon.com>
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

From: Sameeh Jubran <sameehj@amazon.com>

This commit contains 2 cosmetic changes:

1. Use ena_com_check_supported_feature_id() in
   ena_com_hash_key_fill_default_key() instead of rewriting
   its implementation. This also saves us a superfluous admin
   command by using the cached value.

2. Change if conditions in ena_com_rss_init() to be clearer.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index d428d0606166..b51bf62af11b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1067,16 +1067,10 @@ static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
-	struct ena_admin_get_feat_resp get_resp;
-	int rc;
 
-	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
-				    ENA_ADMIN_RSS_HASH_FUNCTION,
-				    ena_dev->rss.hash_key_dma_addr,
-				    sizeof(ena_dev->rss.hash_key), 0);
-	if (unlikely(rc)) {
+	if (!ena_com_check_supported_feature_id(ena_dev,
+						ENA_ADMIN_RSS_HASH_FUNCTION))
 		return -EOPNOTSUPP;
-	}
 
 	rss->hash_key =
 		dma_alloc_coherent(ena_dev->dmadev, sizeof(*rss->hash_key),
@@ -2650,10 +2644,10 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	 * ignore this error and have indirection table support only.
 	 */
 	rc = ena_com_hash_key_allocate(ena_dev);
-	if (unlikely(rc) && rc != -EOPNOTSUPP)
-		goto err_hash_key;
-	else if (rc != -EOPNOTSUPP)
+	if (likely(!rc))
 		ena_com_hash_key_fill_default_key(ena_dev);
+	else if (rc != -EOPNOTSUPP)
+		goto err_hash_key;
 
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
-- 
2.24.1.AMZN

