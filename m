Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF11B39AE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDVIJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55180 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgDVIJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542996; x=1619078996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/2Dpi1Hlbs5TnalumwrJEGMPPpKeXIO/Id9hDrXaleg=;
  b=S1tX7vsxOquXuj6cR3b8T88QdNbEoV5edEvagGJVnrh55d3HTSrx8J+K
   QE01evCmcGFdXax4kWFdQM0Kc0+1PbLMABcDzQaxYKNy1GfxC3dqQESoI
   61SjPCFGTE0zBAIRixaIRO7PpwleofGPNSfur8bH55krpdpJsnvSIeE+u
   o=;
IronPort-SDR: f9LO1cPVQ2745tIAlwbjdFbbHCzPtnJrknwgqmPpwUmtr33+dgOluXjtf2yX0zYPM/aKsGFGwh
 RV/vdaaJej8A==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="28152319"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Apr 2020 08:09:55 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 50F34A06D7;
        Wed, 22 Apr 2020 08:09:54 +0000 (UTC)
Received: from EX13d09UWA003.ant.amazon.com (10.43.160.227) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA003.ant.amazon.com (10.43.160.227) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 639D281D02; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 05/13] net: ena: changes to RSS hash key allocation
Date:   Wed, 22 Apr 2020 08:09:15 +0000
Message-ID: <20200422080923.6697-6-sameehj@amazon.com>
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

