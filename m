Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9D2D979
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfE2JvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:12 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:41595 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfE2JvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123471; x=1590659471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hJIfv+YvOqC6nf+osnm2hz5353vzZ4LrZ1GmJAKHP8M=;
  b=mJpQTCtCyNUUtVfof8g1zvpxciHqBENJHuT1FVGgmdUshbezHdDdHakZ
   9rU6O80OYmtyB3TtOPbsARONBzX5Z/EI7btvnoRhpKCTAyYEn4SkUOys+
   RrzjTVrK0cZNFXYX9D9Vqf+u2YVWHEP0uAwJkS6C/zrqwjfCqVbKHWroo
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="807352913"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 29 May 2019 09:51:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 73B47A1EA5;
        Wed, 29 May 2019 09:51:10 +0000 (UTC)
Received: from EX13D10UWB001.ant.amazon.com (10.43.161.111) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB001.ant.amazon.com (10.43.161.111) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:50 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:47 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 09/11] net: ena: optimise calculations for CQ doorbell
Date:   Wed, 29 May 2019 12:50:02 +0300
Message-ID: <20190529095004.13341-10-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
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
index 2a37463bc..e3f6b6295 100644
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

