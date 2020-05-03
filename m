Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3701C2B0C
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgECJwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:51 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6426 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgECJwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499562; x=1620035562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9KKkkWG8qlWFH3vPfz/TkHC12f7ZUSJ6bXmUWSoBFxs=;
  b=I6E0vjUlsgdVNzzpUvx7smHhW1Eu5rcM/+usvBfZ7JS/PJ0MnTonta8y
   ijdNoQS/4xBb0axtfuQiQrAQIlNdcIe2poL4QcI6XtDncPPu+3Ogou4uv
   +owwVbfCUCvFmIKtepY/a4IZhzF4isnrlMNJIqz9PzGxMKWmLx+ug2K8+
   g=;
IronPort-SDR: dqvbtnnXW8P2Ju0qro2LEnwlSvJNiJmIoTcZ5QNBCFPqkkTuouRl7asDVNRknCsYr3zNl8pDi4
 K+5DL1/9+oqQ==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="40862730"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 May 2020 09:52:42 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 52031A1F44;
        Sun,  3 May 2020 09:52:40 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:27 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:23 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:23 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6CAF881CB9; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 01/12] net: ena: avoid unnecessary admin command when RSS function set fails
Date:   Sun, 3 May 2020 09:52:10 +0000
Message-ID: <20200503095221.6408-2-sameehj@amazon.com>
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

