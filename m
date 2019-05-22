Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF92B26F93
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbfEVTYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731092AbfEVTYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:24:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBAED20879;
        Wed, 22 May 2019 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553046;
        bh=0MBBHq+/wwPBgj0o4eISPDyMTLG6cab4FTlC0BHuuHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzvfh2UGXDwul5eQ0AVfbUfBYmUurNqpC9ghYCmARuUyyobtqwDeActmgZgBgwApP
         Q3yuNX1fr4AoLAuhUVuGMVm9E0HoumdrlojaIa6XNGAluF1h+bRYy47FQ6FF7u4mJZ
         y3Xjh1+q9CW86t9rNX5PaFqbZ9g7+66fizQbhT3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 018/317] net: ena: fix: set freed objects to NULL to avoid failing future allocations
Date:   Wed, 22 May 2019 15:18:39 -0400
Message-Id: <20190522192338.23715-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 8ee8ee7fe87bf64738ab4e31be036a7165608b27 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 41c1c9acb3246..9b03d7e404f83 100644
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
2.20.1

