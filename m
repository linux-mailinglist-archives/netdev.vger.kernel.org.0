Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2171592C2
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgBKPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:19 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62417 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgBKPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434299; x=1612970299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FGp+Rcc/qlSDGQ5PrluTCOhn6C/8zh7ZQK/FKMLno+E=;
  b=EeE2FHmqO56kTRCwQJZDbM/3PFerIUMqis5Fpoe7nmDIrNsFeQKYYGcV
   wchr1MZsHAAJg6VyzwyM218VESrn/NVVVTuNsianDDhwSLqL0dBS4mEi5
   nNcY8OQviKyg6mdiFh+qpwMxpz8Q1hnC6rF2fhQbM7m9AaUhx5GInjKi4
   A=;
IronPort-SDR: 5EKKNsIXKL+4K6rtjlDcUZOwwRnB8qB32xILurpGFVXDXuKlX3HjW25ZBk9rgbXofPKkxwKGMR
 Sgx3dvSPS8RA==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="24354285"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Feb 2020 15:18:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id C0CA4A2CDF;
        Tue, 11 Feb 2020 15:18:12 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id AEE8381D3A; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 06/12] net: ena: rss: fix failure to get indirection table
Date:   Tue, 11 Feb 2020 15:17:45 +0000
Message-ID: <20200211151751.29718-7-sameehj@amazon.com>
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

From: Sameeh Jubran <sameehj@amazon.com>

On old hardware, getting / setting the hash function is not supported while
gettting / setting the indirection table is.

This commit enables us to still show the indirection table on older
hardwares by setting the hash function and key to NULL.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8b56383b6..8be9df885 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -648,7 +648,21 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (rc)
 		return rc;
 
+	/* We call this function in order to check if the device
+	 * supports getting/setting the hash function.
+	 */
 	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
+
+	if (rc) {
+		if (rc == -EOPNOTSUPP) {
+			key = NULL;
+			hfunc = NULL;
+			rc = 0;
+		}
+
+		return rc;
+	}
+
 	if (rc)
 		return rc;
 
-- 
2.24.1.AMZN

