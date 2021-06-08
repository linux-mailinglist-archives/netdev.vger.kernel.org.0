Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3739FB9D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhFHQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:04:17 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:35145 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhFHQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168139; x=1654704139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jaIrQbTmHjhBCEkpGGndwuFVN7Pg/5jqmJ31mnrVIKQ=;
  b=fThV/YDz9wxl0QnLa7gJ6gdhjS6T+h8K9eZ9REHcLiQWhT1Ec4gl52sQ
   9sh+WUkOp5U1PHst2sWd3ucTCcJPqswKARlFNG6r8916ALFM/hVbILkJE
   YTIskwnrRVwXEzGRE6eofRmHqzLxFTFsZpDPfPK2ikiS49RB4xWLyCY9c
   U=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="129862211"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 16:02:19 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id C4046A220E;
        Tue,  8 Jun 2021 16:02:17 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.147) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:02:10 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 03/10] net: ena: Improve error logging in driver
Date:   Tue, 8 Jun 2021 19:01:11 +0300
Message-ID: <20210608160118.3767932-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add prints to improve logging of driver's errors.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 28 +++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 2aecd4c3de59..3d6f0a466a9e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -154,8 +154,11 @@ static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 	if (likely(pkt_ctrl->idx)) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+				   "Failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -185,8 +188,11 @@ static int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 	if (!pkt_ctrl->descs_left_in_line) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+				   "Failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -406,8 +412,11 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	}
 
 	if (unlikely(io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV &&
-		     !buffer_to_push))
+		     !buffer_to_push)) {
+		netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+			   "Push header wasn't provided in LLQ mode\n");
 		return -EINVAL;
+	}
 
 	rc = ena_com_write_header_to_bounce(io_sq, buffer_to_push, header_len);
 	if (unlikely(rc))
@@ -423,6 +432,9 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	/* If the caller doesn't want to send packets */
 	if (unlikely(!num_bufs && !header_len)) {
 		rc = ena_com_close_bounce_buffer(io_sq);
+		if (rc)
+			netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+				   "Failed to write buffers to LLQ\n");
 		*nb_hw_desc = io_sq->tail - start_tail;
 		return rc;
 	}
@@ -482,8 +494,11 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 		/* The first desc share the same desc as the header */
 		if (likely(i != 0)) {
 			rc = ena_com_sq_update_tail(io_sq);
-			if (unlikely(rc))
+			if (unlikely(rc)) {
+				netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+					   "Failed to update sq tail\n");
 				return rc;
+			}
 
 			desc = get_sq_desc(io_sq);
 			if (unlikely(!desc))
@@ -512,8 +527,11 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	desc->len_ctrl |= ENA_ETH_IO_TX_DESC_LAST_MASK;
 
 	rc = ena_com_sq_update_tail(io_sq);
-	if (unlikely(rc))
+	if (unlikely(rc)) {
+		netdev_err(ena_com_io_sq_to_ena_dev(io_sq)->net_device,
+			   "Failed to update sq tail of the last descriptor\n");
 		return rc;
+	}
 
 	rc = ena_com_close_bounce_buffer(io_sq);
 
-- 
2.25.1

