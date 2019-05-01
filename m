Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB5C1086B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfEANrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:47:41 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:15733 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfEANrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718460; x=1588254460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nY0yr+D6XUKk/UlZvrjxbbGtN97kkewFubs3+zTXiYA=;
  b=P9/KZgbBPaLRfOePJ/0mOFt8Rd1wZrqYP+haFfxi76GytnezqAqWp+NK
   e7u9rG5TwlwAO08ulY5ir7fv8EYaDPG6/ZikvW3PSN0QPg94dSH3me5X9
   DSGqzwjCL2t90GmHNoGDT3vttlR+9aunAedCxE0ORYh4c987XOsev2g4l
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="672061635"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:47:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41DlYXK116403
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:47:38 GMT
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:26 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:26 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:22 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 2/8] net: ena: fix: set freed objects to NULL to avoid failing future allocations
Date:   Wed, 1 May 2019 16:47:04 +0300
Message-ID: <20190501134710.8938-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501134710.8938-1-sameehj@amazon.com>
References: <20190501134710.8938-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

In some cases when a queue related allocation fails, successful past
allocations are freed but the pointer that pointed to them is not
set to NULL. This is a problem for 2 reasons:
1. This is generally a bad practice since this pointer might be
accidentally accessed in the future.
2. Future allocations using the same pointer check if the pointer
is NULL and fail if it is not.

Fixed this by setting such pointers to NULL in the allocation of
queue related objects.

Also refactored the code of ena_setup_tx_resources() to goto-style
error handling to avoid code duplication of resource freeing.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a6eacf2099c3..dbcd58ebd0a9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -224,28 +224,23 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	if (!tx_ring->tx_buffer_info) {
 		tx_ring->tx_buffer_info = vzalloc(size);
 		if (!tx_ring->tx_buffer_info)
-			return -ENOMEM;
+			goto err_tx_buffer_info;
 	}
 
 	size = sizeof(u16) * tx_ring->ring_size;
 	tx_ring->free_tx_ids = vzalloc_node(size, node);
 	if (!tx_ring->free_tx_ids) {
 		tx_ring->free_tx_ids = vzalloc(size);
-		if (!tx_ring->free_tx_ids) {
-			vfree(tx_ring->tx_buffer_info);
-			return -ENOMEM;
-		}
+		if (!tx_ring->free_tx_ids)
+			goto err_free_tx_ids;
 	}
 
 	size = tx_ring->tx_max_header_size;
 	tx_ring->push_buf_intermediate_buf = vzalloc_node(size, node);
 	if (!tx_ring->push_buf_intermediate_buf) {
 		tx_ring->push_buf_intermediate_buf = vzalloc(size);
-		if (!tx_ring->push_buf_intermediate_buf) {
-			vfree(tx_ring->tx_buffer_info);
-			vfree(tx_ring->free_tx_ids);
-			return -ENOMEM;
-		}
+		if (!tx_ring->push_buf_intermediate_buf)
+			goto err_push_buf_intermediate_buf;
 	}
 
 	/* Req id ring for TX out of order completions */
@@ -259,6 +254,15 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->next_to_clean = 0;
 	tx_ring->cpu = ena_irq->cpu;
 	return 0;
+
+err_push_buf_intermediate_buf:
+	vfree(tx_ring->free_tx_ids);
+	tx_ring->free_tx_ids = NULL;
+err_free_tx_ids:
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+err_tx_buffer_info:
+	return -ENOMEM;
 }
 
 /* ena_free_tx_resources - Free I/O Tx Resources per Queue
@@ -378,6 +382,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 		rx_ring->free_rx_ids = vzalloc(size);
 		if (!rx_ring->free_rx_ids) {
 			vfree(rx_ring->rx_buffer_info);
+			rx_ring->rx_buffer_info = NULL;
 			return -ENOMEM;
 		}
 	}
-- 
2.17.1

