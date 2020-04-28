Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E111BB775
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgD1H1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:58005 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgD1H1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058865; x=1619594865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9KKkkWG8qlWFH3vPfz/TkHC12f7ZUSJ6bXmUWSoBFxs=;
  b=mRAhBeyqr76h6JIDeUpvRjhTEK+YH9W62SkNSvYnl10fJttPpksOduHm
   zBmu1/RxAjUsJ/4CthYIuHceadhQFEqKjS5wgmYf1Pp4Tdww0w8bIhXcw
   1wIHcwEpXIsHsuk7SP7cfgVraXVpHMjpdHlN2ozXxFqDB58cyfgVjMe2L
   8=;
IronPort-SDR: 4axicbIhr0z0DSdvEKu+dsmq/uR8iV53tbuMzi27kgaB0+Q16zNERfothU4B+wE/l+pYfz+Fg8
 k1xWZAbLaSQw==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="27868175"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 Apr 2020 07:27:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id E4BF3A2278;
        Tue, 28 Apr 2020 07:27:31 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:30 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:30 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 4CE5F81C80; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 01/13] net: ena: avoid unnecessary admin command when RSS function set fails
Date:   Tue, 28 Apr 2020 07:27:14 +0000
Message-ID: <20200428072726.22247-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200428072726.22247-1-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
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
index a250046b8e18..424ba08955e9 100644
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

