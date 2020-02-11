Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50C51592C0
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgBKPSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:13 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1963 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbgBKPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434292; x=1612970292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/M3YMWDXinVWSFZB3uwNNvdhROuACGBLiY9j4t7vGzk=;
  b=BJxA/x5g1bU+lz2uqpKVWbYzbDsNJ7gOgPqS0Pqd8pw+sLw7DUX0Xzbb
   bZRXbAK8B7UyFBZAAbcdJOBBIgxD+KV4qEUqU6eJWBexGh7ezN4aghcdi
   FO4XjOpzHOoBwijBrGbYMyoLmuH5UKE0oEqE8ZEG+0aO/zvX/QTpK5ikW
   k=;
IronPort-SDR: QM37gYPcP5isKazn/HJxhN7axpS/JE/PyJ9hHHv+u7+R3UJYzNJx5L47VRE3NRAi6iIR5gh/Zr
 CsUNywTspCYQ==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="25719231"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Feb 2020 15:17:59 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id DDB40A242C;
        Tue, 11 Feb 2020 15:17:57 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:56 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A46C181D33; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 02/12] net: ena: fix uses of round_jiffies()
Date:   Tue, 11 Feb 2020 15:17:41 +0000
Message-ID: <20200211151751.29718-3-sameehj@amazon.com>
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

From the documentation of round_jiffies():
"Rounds a time delta  in the future (in jiffies) up or down to
(approximately) full seconds. This is useful for timers for which
the exact time they fire does not matter too much, as long as
they fire approximately every X seconds.
By rounding these timers to whole seconds, all such timers will fire
at the same time, rather than at various times spread out. The goal
of this is to have the CPU wake up less, which saves power."

There are 2 parts to this patch:
================================
Part 1:
-------
In our case we need timer_service to be called approximately every
X=1 seconds, and the exact time does not matter, so using round_jiffies()
is the right way to go.

Therefore we add round_jiffies() to the mod_timer() in ena_timer_service().

Part 2:
-------
round_jiffies() is used in check_for_missing_keep_alive() when
getting the jiffies of the expiration of the keep_alive timeout. Here it
is actually a mistake to use round_jiffies() because we want the exact
time when keep_alive should expire and not an approximate rounded time,
which can cause early, false positive, timeouts.

Therefore we remove round_jiffies() in the calculation of
keep_alive_expired() in check_for_missing_keep_alive().

Fixes: 82ef30f13be0 ("net: ena: add hardware hints capability to the driver")
Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 948583fdc..1c1a41bd1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3049,8 +3049,8 @@ static void check_for_missing_keep_alive(struct ena_adapter *adapter)
 	if (adapter->keep_alive_timeout == ENA_HW_HINTS_NO_TIMEOUT)
 		return;
 
-	keep_alive_expired = round_jiffies(adapter->last_keep_alive_jiffies +
-					   adapter->keep_alive_timeout);
+	keep_alive_expired = adapter->last_keep_alive_jiffies +
+			     adapter->keep_alive_timeout;
 	if (unlikely(time_is_before_jiffies(keep_alive_expired))) {
 		netif_err(adapter, drv, adapter->netdev,
 			  "Keep alive watchdog timeout.\n");
@@ -3152,7 +3152,7 @@ static void ena_timer_service(struct timer_list *t)
 	}
 
 	/* Reset the timer */
-	mod_timer(&adapter->timer_service, jiffies + HZ);
+	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 }
 
 static int ena_calc_max_io_queue_num(struct pci_dev *pdev,
-- 
2.24.1.AMZN

