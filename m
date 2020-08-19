Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1379524A4EF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHSR3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:29:46 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:2799 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgHSR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597858176; x=1629394176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Xsotrssq+Q1P63K2G7lM/tGNujvHp98On7xHBF59HWE=;
  b=KN8we73aQGumTuhclif1g6knPm2+ZOfIzCv/Na2EigCl+QcjLcara1Z8
   x6lkAvGj333ZJhG4/ed/T0AT46kRC5pF3x2FNM+a6fDdSjzGbVUdZzHOy
   cK2wYGu2To4YrPgX9GjqN2CX8PbtT0rrIBa1rpEBliwh5YdZWpJr3XJZI
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="48752198"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Aug 2020 17:29:34 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id DAB57A236D;
        Wed, 19 Aug 2020 17:29:33 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:32 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.192) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:25 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V3 net 2/3] net: ena: Change WARN_ON expression in ena_del_napi_in_range()
Date:   Wed, 19 Aug 2020 20:28:37 +0300
Message-ID: <20200819172838.20564-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819172838.20564-1-shayagr@amazon.com>
References: <20200819172838.20564-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena_del_napi_in_range() function unregisters the napi handler for
rings in a given range.
This function had the following WARN_ON macro:

    WARN_ON(ENA_IS_XDP_INDEX(adapter, i) &&
	    adapter->ena_napi[i].xdp_ring);

This macro prints the call stack if the expression inside of it is
true [1], but the expression inside of it is the wanted situation.
The expression checks whether the ring has an XDP queue and its index
corresponds to a XDP one.

This patch changes the expression to
    !ENA_IS_XDP_INDEX(adapter, i) && adapter->ena_napi[i].xdp_ring
which indicates an unwanted situation.

Also, change the structure of the function. The napi handler is
unregistered for all rings, and so there's no need to check whether the
index is an XDP index or not. By removing this check the code becomes
much more readable.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 44aeace196f0..233db15c970d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2180,13 +2180,10 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
 	int i;
 
 	for (i = first_index; i < first_index + count; i++) {
-		/* Check if napi was initialized before */
-		if (!ENA_IS_XDP_INDEX(adapter, i) ||
-		    adapter->ena_napi[i].xdp_ring)
-			netif_napi_del(&adapter->ena_napi[i].napi);
-		else
-			WARN_ON(ENA_IS_XDP_INDEX(adapter, i) &&
-				adapter->ena_napi[i].xdp_ring);
+		netif_napi_del(&adapter->ena_napi[i].napi);
+
+		WARN_ON(!ENA_IS_XDP_INDEX(adapter, i) &&
+			adapter->ena_napi[i].xdp_ring);
 	}
 }
 
-- 
2.17.1

