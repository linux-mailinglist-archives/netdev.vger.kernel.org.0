Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4D6589ED
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiL2Ha0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiL2HaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:23 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5C4F58B
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299021; x=1703835021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NRtsLk/gmepDLhUk0MRjKFok2+jVmRjz5mib6xckxKA=;
  b=c5IBfi21tJx2xDFn/j8Er0JRqhHpgkqf/hMe1Vr0GnrSydnLN/+C9vcF
   ZXEkz3x1C/kXLQ/4uDBlQVO/Bps+NjpORxFGqlu46/NF4fVoN6RUlD+rW
   JGoR0dfW4mD36izMgqHaovmxYYLl5tuTF4zhnCW0QbntoNr3NuzHCjuof
   0=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="283448122"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:21 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 7B77541E46;
        Thu, 29 Dec 2022 07:30:20 +0000 (UTC)
Received: from EX19D002UWC002.ant.amazon.com (10.13.138.166) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:20 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC002.ant.amazon.com (10.13.138.166) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:19 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:17
 +0000
From:   <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Nati Koler <nkoler@amazon.com>
Subject: [PATCH V1 net 1/7] net: ena: Fix toeplitz initial hash value
Date:   Thu, 29 Dec 2022 07:30:05 +0000
Message-ID: <20221229073011.19687-2-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229073011.19687-1-darinzon@amazon.com>
References: <20221229073011.19687-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

On driver initialization, RSS hash initial value is set to zero,
instead of the default value. This happens because we pass NULL as
the RSS key parameter, which caused us to never initialize
the RSS hash value.

This patch fixes it by making sure the initial value is set, no matter
what the value of the RSS key is.

Fixes: 91a65b7d3ed8 ("net: ena: fix potential crash when rxfh key is NULL")
Signed-off-by: Nati Koler <nkoler@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 29 +++++++----------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 8c8b4c88c7de..451c3a1b6255 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2400,29 +2400,18 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EOPNOTSUPP;
 	}
 
-	switch (func) {
-	case ENA_ADMIN_TOEPLITZ:
-		if (key) {
-			if (key_len != sizeof(hash_key->key)) {
-				netdev_err(ena_dev->net_device,
-					   "key len (%u) doesn't equal the supported size (%zu)\n",
-					   key_len, sizeof(hash_key->key));
-				return -EINVAL;
-			}
-			memcpy(hash_key->key, key, key_len);
-			rss->hash_init_val = init_val;
-			hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
+	if ((func == ENA_ADMIN_TOEPLITZ) && key) {
+		if (key_len != sizeof(hash_key->key)) {
+			netdev_err(ena_dev->net_device,
+				   "key len (%u) doesn't equal the supported size (%zu)\n",
+				   key_len, sizeof(hash_key->key));
+			return -EINVAL;
 		}
-		break;
-	case ENA_ADMIN_CRC32:
-		rss->hash_init_val = init_val;
-		break;
-	default:
-		netdev_err(ena_dev->net_device, "Invalid hash function (%d)\n",
-			   func);
-		return -EINVAL;
+		memcpy(hash_key->key, key, key_len);
+		hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
 	}
 
+	rss->hash_init_val = init_val;
 	old_func = rss->hash_func;
 	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
-- 
2.38.1

