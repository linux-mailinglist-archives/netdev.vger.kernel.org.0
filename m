Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C622E242818
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgHLKMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 06:12:42 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34450 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgHLKMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 06:12:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597227161; x=1628763161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fQc6qqOfI/lwu7nYkZ6D71WjAgjtnM97j5OY01xd6NM=;
  b=Q3a2Qom4WAF36Ig16a87R6XAnj6OOLjh1FU+kHQz/r1LSJfznjJ+QX7f
   8T/6tkuLfGJ0OfB8FqATdRxCAVniw7OB0riNdMfSPLUQMDOVkqJZGhubc
   UkLc63qPBUpFvnNGVt2OvbL0KSxCq3HaIndTNeuFw1xuGnoTYl7nGLVNn
   I=;
IronPort-SDR: 5cm737R2GNl2wDxV3SOQHfieOuUC1Vl4mkUMfy6FyVWMslY12DRTEOy8/c9BpiQVTA8Ue3QijN
 5yhAEu7HsqZg==
X-IronPort-AV: E=Sophos;i="5.76,303,1592870400"; 
   d="scan'208";a="66195448"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Aug 2020 10:12:41 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 36E32A23D1;
        Wed, 12 Aug 2020 10:12:39 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:38 +0000
Received: from u4b1e9be9d67d5a.ant.amazon.com (10.43.161.34) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:30 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <akiyano@amazon.com>,
        <sameehj@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net 2/3] net: ena: Change WARN_ON expression in ena_del_napi_in_range()
Date:   Wed, 12 Aug 2020 13:10:58 +0300
Message-ID: <20200812101059.5501-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200812101059.5501-1-shayagr@amazon.com>
References: <20200812101059.5501-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
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

[1]:
https://elixir.bootlin.com/linux/latest/source/arch/parisc/include/asm/bug.h#L79

Fixes: 8c5c7abdeb2d ("net: ena: add power management ops to the ENA driver")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0488fcbf48f7..3e12065482c2 100644
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
2.28.0

