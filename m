Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8951592BF
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgBKPSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:12 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1963 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729839AbgBKPSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434290; x=1612970290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9O5cdndmrbHqA+Z/oL0/muBoegmNWw1pGoduas0RDk=;
  b=EOoM2BGKOxR702hmYodPxkAlBQatWP6IHD/Xb99vk5RiItiDg5Gq32WF
   NGNb6wMGuuMVWiGUNtq0HclmEPXAsHIHHw3JOKtFVE/0wiuW81JI1axpy
   R2JLNQPDchRZmjTC1pE10afRXor8dMO+e1pR0M4yoCETMz801Z3/Vx+o4
   s=;
IronPort-SDR: R68+OPh50F/VHSredeHLCxplVfBc8DogOHTHDGnb6B4m1UYWeccJUrZU05O3O4pVjHSawA2oKs
 dm3q2BsPYxAA==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="25719235"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Feb 2020 15:17:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 9A887A259C;
        Tue, 11 Feb 2020 15:17:58 +0000 (UTC)
Received: from EX13D02UWB004.ant.amazon.com (10.43.161.11) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB004.ant.amazon.com (10.43.161.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id B17FC81D3B; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 07/12] net: ena: rss: store hash function as values and not bits
Date:   Tue, 11 Feb 2020 15:17:46 +0000
Message-ID: <20200211151751.29718-8-sameehj@amazon.com>
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

From: Arthur Kiyanovski <akiyano@amazon.com>

The device receives, stores and retrieves the hash function value as bits
and not as their enum value.

The bug:
* In ena_com_set_hash_function() we set
  cmd.u.flow_hash_func.selected_func to the bit value of rss->hash_func.
 (1 << rss->hash_func)
* In ena_com_get_hash_function() we retrieve the hash function and store
  it's bit value in rss->hash_func. (Now the bit value of rss->hash_func
  is stored in rss->hash_func instead of it's enum value)

The fix:
This commit fixes the issue by converting the retrieved hash function
values from the device to the matching enum value of the set bit using
ffs(). ffs() finds the first set bit's index in a word. Since the function
returns 1 for the LSB's index, we need to subtract 1 from the returned
value (note that BIT(0) is 1).

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 6f758ece8..8ab192cb2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2370,7 +2370,11 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (unlikely(rc))
 		return rc;
 
-	rss->hash_func = get_resp.u.flow_hash_func.selected_func;
+	/* ffs() returns 1 in case the lsb is set */
+	rss->hash_func = ffs(get_resp.u.flow_hash_func.selected_func);
+	if (rss->hash_func)
+		rss->hash_func--;
+
 	if (func)
 		*func = rss->hash_func;
 
-- 
2.24.1.AMZN

