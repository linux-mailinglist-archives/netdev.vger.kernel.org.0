Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128264FA97
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFWHL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:11:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:38307 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFWHL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561273887; x=1592809887;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=cncU9le643RubrS0CTUy2hKr1Q/YtB0ZgOcvsWtuFcw=;
  b=e+mF60ldTMLDgHa9NdPowVg7ndmD28BkDQmsl0MI/OgCBeRlZ3gagsRw
   5gg2fN8ZxhbhRf3jjoRceigDAtpR+oqv+6OE36uOnWohRnyca1kdQxBU7
   fwCZspwxv6lwokBhzSzJwq6dDZEQnlWQVbfa39+Ci/xiH6orpT6IAp+5X
   s=;
X-IronPort-AV: E=Sophos;i="5.62,407,1554768000"; 
   d="scan'208";a="807089739"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jun 2019 07:11:26 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id EDAFF282353;
        Sun, 23 Jun 2019 07:11:25 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:11:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:11:24 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 07:11:22 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next] net: ena: Fix bug where ring allocation backoff stopped too late
Date:   Sun, 23 Jun 2019 10:11:10 +0300
Message-ID: <20190623071110.18687-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The current code of create_queues_with_size_backoff() allows the ring size
to become as small as ENA_MIN_RING_SIZE/2. This is a bug since we don't
want the queue ring to be smaller than ENA_MIN_RING_SIZE

In this commit we change the loop's termination condition to look at the
queue size of the next iteration instead of that of the current one,
so that the minimal queue size again becomes ENA_MIN_RING_SIZE.

Fixes: eece4d2ab9d2 ("net: ena: add ethtool function for changing io queue sizes")

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b7865ee1d..20ec8ff03 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1839,8 +1839,8 @@ err_setup_tx:
 		if (cur_rx_ring_size >= cur_tx_ring_size)
 			new_rx_ring_size = cur_rx_ring_size / 2;
 
-		if (cur_tx_ring_size < ENA_MIN_RING_SIZE ||
-		    cur_rx_ring_size < ENA_MIN_RING_SIZE) {
+		if (new_tx_ring_size < ENA_MIN_RING_SIZE ||
+		    new_rx_ring_size < ENA_MIN_RING_SIZE) {
 			netif_err(adapter, ifup, adapter->netdev,
 				  "Queue creation failed with the smallest possible queue size of %d for both queues. Not retrying with smaller queues\n",
 				  ENA_MIN_RING_SIZE);
-- 
2.17.1

