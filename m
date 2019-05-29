Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF46F2D977
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE2JvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:06 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:63545 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2JvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123465; x=1590659465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mLh3Pw7qVMvyS1EgLBS4XSpI/lP+6GY7oPvDDUQjFMg=;
  b=XCNU4RAeNa/SSGFubiemPqtHBPSiOotqHMokU3T+uVbdmfloSTWtXnvG
   QS+hGTJ0KOCgezFKWgf7PF5b80t3gtOqTePHmsho5VwBK2pAvRMar/+Md
   +9mmiVcXGK1wjZrDYGqXMyKOdG9GiTplXpODGOyJ+ISnBrgnh61QXiP22
   w=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="398482705"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 May 2019 09:51:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 51841A1E9C;
        Wed, 29 May 2019 09:51:04 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:42 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:38 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 07/11] net: ena: allow automatic fallback to polling mode
Date:   Wed, 29 May 2019 12:50:00 +0300
Message-ID: <20190529095004.13341-8-sameehj@amazon.com>
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

