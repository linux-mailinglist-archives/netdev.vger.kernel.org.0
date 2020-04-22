Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56521B39CE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgDVIQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:35 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:52216 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgDVIQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543393; x=1619079393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9dspdJNzaLm7kLaiJFm9YUrpXIHwD0NMdM++Y1nwIbY=;
  b=k19lIxFi2o3Gtax6OIRimHBjYPIS4IQUuUgYNMo1eerNBUReOpUv8Avo
   lnIoLQ5x9SJ8nWbwEvqYpHOOO3Vr6+OpNYShFCxIcfMD8YIk4MoPwOw9J
   ja9a1aNgWsBUegskb6hZRmvCgw3ekxfLw0PIy2rY9jJbl0NwOjv45dTF7
   w=;
IronPort-SDR: Yukt3VulYPehU2PBnrQ9LtS+d8McN5O9311XQBlEwr9dSmvKYCKwcmlZY7xvIjeIsRwXZ2JPAI
 SMiEv2XVhgfg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="27054099"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id BCE26A2326;
        Wed, 22 Apr 2020 08:16:31 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:30 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:30 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6815C81CFE; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 02/13] net: ena: avoid unnecessary admin command when RSS function set fails
Date:   Wed, 22 Apr 2020 08:16:17 +0000
Message-ID: <20200422081628.8103-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Currently when ena_set_hash_function() fails the hash function is
restored to the previous value by calling an admin command to get
the hash function from the device.

In this commit we avoid the admin command, by saving the previous
hash function before calling ena_set_hash_function() and using this
previous value to restore the hash function in case of failure of
ena_set_hash_function().

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 07b0f396d3c2..66edc86c41c9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2286,6 +2286,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 	struct ena_admin_get_feat_resp get_resp;
 	struct ena_admin_feature_rss_flow_hash_control *hash_key =
 		rss->hash_key;
+	enum ena_admin_hash_functions old_func;
 	int rc;
 
 	/* Make sure size is a mult of DWs */
@@ -2325,12 +2326,13 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
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
-- 
2.24.1.AMZN

