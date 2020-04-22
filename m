Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A444C1B39A8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgDVIJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:44 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41213 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgDVIJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542977; x=1619078977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Msnd84qBQYm4DKqejTe9PyJUI6reM4yHHZnM3E65/g4=;
  b=Yfhg7C36TvW+rsKZuJLF0IEHfxRveN0WtHATJsggvXy9JbAvDjOzane3
   gvGSsr1tj+QsnUQgApsosUsLQjjNZYT+xdVO2UgnWkJyXphTh35pDG8gM
   Lb8azPMvNDUII9nRDhZ+QSh88QBVcOGpWTBqXqP7tp2NI/+lTtUFR2Epo
   Y=;
IronPort-SDR: gg+Y5DIpwD0CkkMPxIWlRN/5g+tgtZ4W6kiSAvgoqco7TXYmfBgTVQWadHQiERSTV1tGe6Kl3S
 nZXvt1mitwxQ==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="40115009"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Apr 2020 08:09:34 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 6AF0FC05CF;
        Wed, 22 Apr 2020 08:09:32 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 60A4981D00; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 04/13] net: ena: change default RSS hash function to Toeplitz
Date:   Wed, 22 Apr 2020 08:09:14 +0000
Message-ID: <20200422080923.6697-5-sameehj@amazon.com>
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

From: Arthur Kiyanovski <akiyano@amazon.com>

Currently in the driver we are setting the hash function to be CRC32.
Starting with this commit we want to change the default behaviour so that
we set the hash function to be Toeplitz instead.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2cc765df8da3..6baafc3aebea 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3991,7 +3991,7 @@ static int ena_rss_init_default(struct ena_adapter *adapter)
 		}
 	}
 
-	rc = ena_com_fill_hash_function(ena_dev, ENA_ADMIN_CRC32, NULL,
+	rc = ena_com_fill_hash_function(ena_dev, ENA_ADMIN_TOEPLITZ, NULL,
 					ENA_HASH_KEY_SIZE, 0xFFFFFFFF);
 	if (unlikely(rc && (rc != -EOPNOTSUPP))) {
 		dev_err(dev, "Cannot fill hash function\n");
-- 
2.24.1.AMZN

