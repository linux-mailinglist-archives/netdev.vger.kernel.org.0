Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E251DD6B0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgEUTJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:01 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:22115 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgEUTJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088139; x=1621624139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kOzaFrr307M+sMz7fwiYRR5XB1rCI4kO9F6+gZPejUk=;
  b=SbeiwnVSpTuwKdMEVqYvJY3Irs/nboVvJeEA5genomo7meYXmnH5c3x3
   wSziS/z0YzJy6+BxEWhS7rVUk6pkCqddoc2AagPAInB/v8H13NXZ5O1eS
   p1YNLLt0RYkzxWrtGRX/YQp6puERYwzk9sefbO+II6d2KwSVzLaygn3zO
   Y=;
IronPort-SDR: jD7Pj3+UGsc1bmhZJEw/WcrLHgn4vSxFfdVUkFSpQLAEcBqjDF/UQbwJA8B89Amla6AQIhFehu
 nDAb2AUCH4Rw==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="45151185"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 May 2020 19:08:56 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 12013A054D;
        Thu, 21 May 2020 19:08:56 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:54 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:54 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:51 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 05/15] net: ena: add prints to failed commands
Date:   Thu, 21 May 2020 22:08:24 +0300
Message-ID: <1590088114-381-6-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Error prints were added to provide some context to
what the driver did when receiving this error (e.g.
trying to update metadata when receiving a PCI write error).

The prints were only added to places where the connection
between the failed function, and the requested operation is
not clear.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index a014f514c069..f0b90e1551a3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -175,8 +175,10 @@ static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 	if (pkt_ctrl->idx) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			pr_err("failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -206,8 +208,10 @@ static int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 	if (!pkt_ctrl->descs_left_in_line) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			pr_err("failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -395,8 +399,10 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	}
 
 	if (unlikely(io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV &&
-		     !buffer_to_push))
+		     !buffer_to_push)) {
+		pr_err("push header wasn't provided on LLQ mode\n");
 		return -EINVAL;
+	}
 
 	rc = ena_com_write_header_to_bounce(io_sq, buffer_to_push, header_len);
 	if (unlikely(rc))
@@ -413,6 +419,8 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	/* If the caller doesn't want to send packets */
 	if (unlikely(!num_bufs && !header_len)) {
 		rc = ena_com_close_bounce_buffer(io_sq);
+		if (rc)
+			pr_err("failed to write buffers to LLQ\n");
 		*nb_hw_desc = io_sq->tail - start_tail;
 		return rc;
 	}
@@ -472,8 +480,10 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 		/* The first desc share the same desc as the header */
 		if (likely(i != 0)) {
 			rc = ena_com_sq_update_tail(io_sq);
-			if (unlikely(rc))
+			if (unlikely(rc)) {
+				pr_err("failed to update sq tail\n");
 				return rc;
+			}
 
 			desc = get_sq_desc(io_sq);
 			if (unlikely(!desc))
@@ -502,10 +512,14 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	desc->len_ctrl |= ENA_ETH_IO_TX_DESC_LAST_MASK;
 
 	rc = ena_com_sq_update_tail(io_sq);
-	if (unlikely(rc))
+	if (unlikely(rc)) {
+		pr_err("failed to update sq tail of the last descriptor\n");
 		return rc;
+	}
 
 	rc = ena_com_close_bounce_buffer(io_sq);
+	if (unlikely(rc))
+		pr_err("failed when closing bounce buffer\n");
 
 	*nb_hw_desc = io_sq->tail - start_tail;
 	return rc;
-- 
2.23.1

