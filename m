Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9E3328A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFCOo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:27 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:34266 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbfFCOo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573066; x=1591109066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=RqqOh7b8pJGEOQ5eCKSWJZz+Xx3mV36GrTVqRWDL/q0=;
  b=XLebJpryKO2PR+iUsho5wpFNkk6lirUOb0HcznRTl2IVYw/bqWHymd/Z
   G00O2SYK5WMPSWe3b4BayyUgR4E81eXUurbZu26VeOYsnQp4QvPJvNk8K
   khbAWOaiTT08/v9OEIedwUOYNsrXcDfMrqvrImjU89o4W9uKg7PmIF6mG
   M=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="404808687"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Jun 2019 14:44:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 79704A212B;
        Mon,  3 Jun 2019 14:44:25 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:03 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:03 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:44:00 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V2 net 09/11] net: ena: optimise calculations for CQ doorbell
Date:   Mon, 3 Jun 2019 17:43:27 +0300
Message-ID: <20190603144329.16366-10-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patch initially checks if CQ doorbell
is needed before proceeding with the calculations.

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 0a3d9180e..77986c0ea 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -195,15 +195,17 @@ static inline int ena_com_update_dev_comp_head(struct ena_com_io_cq *io_cq)
 	u16 unreported_comp, head;
 	bool need_update;
 
-	head = io_cq->head;
-	unreported_comp = head - io_cq->last_head_update;
-	need_update = unreported_comp > (io_cq->q_depth / ENA_COMP_HEAD_THRESH);
-
-	if (io_cq->cq_head_db_reg && need_update) {
-		pr_debug("Write completion queue doorbell for queue %d: head: %d\n",
-			 io_cq->qid, head);
-		writel(head, io_cq->cq_head_db_reg);
-		io_cq->last_head_update = head;
+	if (unlikely(io_cq->cq_head_db_reg)) {
+		head = io_cq->head;
+		unreported_comp = head - io_cq->last_head_update;
+		need_update = unreported_comp > (io_cq->q_depth / ENA_COMP_HEAD_THRESH);
+
+		if (unlikely(need_update)) {
+			pr_debug("Write completion queue doorbell for queue %d: head: %d\n",
+				 io_cq->qid, head);
+			writel(head, io_cq->cq_head_db_reg);
+			io_cq->last_head_update = head;
+		}
 	}
 
 	return 0;
-- 
2.17.1

