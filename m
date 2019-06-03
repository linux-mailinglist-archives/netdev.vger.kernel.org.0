Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514C333284
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbfFCOoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:16847 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbfFCOoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573051; x=1591109051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mLh3Pw7qVMvyS1EgLBS4XSpI/lP+6GY7oPvDDUQjFMg=;
  b=EUOjzgoBDbtM19xIDzQs1groAw+5FO7Tg/pGuqfk0+jIphHF06xbXJiI
   1phrPbhI3BC8QEhspk1XTKimFwPgtWiD7t+7T3bto6r0/oGDb4PAy/eEZ
   ggXcTvBzuoAljOKAFeXIiN++INjjWHA2quvDUE87UDBT6IY3mFyCBL0f8
   w=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="803248359"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 Jun 2019 14:44:09 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 12666141808;
        Mon,  3 Jun 2019 14:44:09 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:57 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:57 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:54 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V2 net 07/11] net: ena: allow automatic fallback to polling mode
Date:   Mon, 3 Jun 2019 17:43:25 +0300
Message-ID: <20190603144329.16366-8-sameehj@amazon.com>
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

Enable fallback to polling mode for Admin queue
when identified a command response arrival
without an accompanying MSI-X interrupt

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 34 +++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_com.h | 14 ++++++++++
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 139b31549..5e2abdda7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -762,16 +762,26 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 		admin_queue->stats.no_completion++;
 		spin_unlock_irqrestore(&admin_queue->q_lock, flags);
 
-		if (comp_ctx->status == ENA_CMD_COMPLETED)
-			pr_err("The ena device have completion but the driver didn't receive any MSI-X interrupt (cmd %d)\n",
-			       comp_ctx->cmd_opcode);
-		else
-			pr_err("The ena device doesn't send any completion for the admin cmd %d status %d\n",
+		if (comp_ctx->status == ENA_CMD_COMPLETED) {
+			pr_err("The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d), autopolling mode is %s\n",
+			       comp_ctx->cmd_opcode,
+			       admin_queue->auto_polling ? "ON" : "OFF");
+			/* Check if fallback to polling is enabled */
+			if (admin_queue->auto_polling)
+				admin_queue->polling = true;
+		} else {
+			pr_err("The ena device doesn't send a completion for the admin cmd %d status %d\n",
 			       comp_ctx->cmd_opcode, comp_ctx->status);
-
-		admin_queue->running_state = false;
-		ret = -ETIME;
-		goto err;
+		}
+		/* Check if shifted to polling mode.
+		 * This will happen if there is a completion without an interrupt
+		 * and autopolling mode is enabled. Continuing normal execution in such case
+		 */
+		if (!admin_queue->polling) {
+			admin_queue->running_state = false;
+			ret = -ETIME;
+			goto err;
+		}
 	}
 
 	ret = ena_com_comp_status_to_errno(comp_ctx->comp_status);
@@ -1650,6 +1660,12 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling)
 	ena_dev->admin_queue.polling = polling;
 }
 
+void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
+					 bool polling)
+{
+	ena_dev->admin_queue.auto_polling = polling;
+}
+
 int ena_com_mmio_reg_read_request_init(struct ena_com_dev *ena_dev)
 {
 	struct ena_com_mmio_read *mmio_read = &ena_dev->mmio_read;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index ce36444c3..6d356cb05 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -283,6 +283,9 @@ struct ena_com_admin_queue {
 	/* Indicate if the admin queue should poll for completion */
 	bool polling;
 
+	/* Define if fallback to polling mode should occur */
+	bool auto_polling;
+
 	u16 curr_cmd_id;
 
 	/* Indicate that the ena was initialized and can
@@ -545,6 +548,17 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
  */
 bool ena_com_get_ena_admin_polling_mode(struct ena_com_dev *ena_dev);
 
+/* ena_com_set_admin_auto_polling_mode - Enable autoswitch to polling mode
+ * @ena_dev: ENA communication layer struct
+ * @polling: Enable/Disable polling mode
+ *
+ * Set the autopolling mode.
+ * If autopolling is on:
+ * In case of missing interrupt when data is available switch to polling.
+ */
+void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
+					 bool polling);
+
 /* ena_com_admin_q_comp_intr_handler - admin queue interrupt handler
  * @ena_dev: ENA communication layer struct
  *
-- 
2.17.1

