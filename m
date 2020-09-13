Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD53267E89
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgIMISC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:18:02 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:55963 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgIMIR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599985071; x=1631521071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=zYxVGP0R4z4o0q+o7WdbtVqZw+sEbf/phVr3IhR7CWM=;
  b=CUHZ06rHcK+5XwscANJHYV7PeAjUZ0cJg1qEWK6stxP+fsvD7KAZvvgf
   XyQELC8UtZlHA2sv7mwmPgQzZdnzcNSiXDTDunaBIiDyxTu78Z8am7n74
   zsSmttWKquiWvuqkKc35V5DIYIlfhxz0xMS5/xK5SicwWfoyBb33BavV+
   8=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="75662573"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Sep 2020 08:17:44 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id F02A9A0371;
        Sun, 13 Sep 2020 08:17:43 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.145) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 08:17:33 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Amit Bernstein <amitbern@amazon.com>
Subject: [PATCH V1 net-next 2/8] net: ena: Add device distinct log prefix to files
Date:   Sun, 13 Sep 2020 11:16:34 +0300
Message-ID: <20200913081640.19560-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200913081640.19560-1-shayagr@amazon.com>
References: <20200913081640.19560-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENA logs are adjusted to display the full ENA representation to
distinct each ENA device in case of multiple interfaces.
Using dev_err/warn/info function family for logging provides uniform
printing with clear distinction of the driver and device.

This patch changes all printing in ena_com files to use dev_* logging
messages. It also adds some log messages to make driver debugging
easier.

Signed-off-by: Amit Bernstein <amitbern@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 369 +++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  20 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  99 +++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  23 +-
 4 files changed, 321 insertions(+), 190 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 12ae2636e57b..a37d9fdc1398 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -71,7 +71,8 @@ static int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
 				       dma_addr_t addr)
 {
 	if ((addr & GENMASK_ULL(ena_dev->dma_addr_bits - 1, 0)) != addr) {
-		pr_err("dma address has more bits that the device supports\n");
+		dev_err(ena_dev->dmadev,
+			"dma address has more bits that the device supports\n");
 		return -EINVAL;
 	}
 
@@ -83,6 +84,7 @@ static int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
 
 static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
 {
+	struct ena_com_dev *ena_dev = queue->ena_dev;
 	struct ena_com_admin_sq *sq = &queue->sq;
 	u16 size = ADMIN_SQ_SIZE(queue->q_depth);
 
@@ -90,7 +92,7 @@ static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
 					 GFP_KERNEL);
 
 	if (!sq->entries) {
-		pr_err("memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -105,6 +107,7 @@ static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
 
 static int ena_com_admin_init_cq(struct ena_com_admin_queue *queue)
 {
+	struct ena_com_dev *ena_dev = queue->ena_dev;
 	struct ena_com_admin_cq *cq = &queue->cq;
 	u16 size = ADMIN_CQ_SIZE(queue->q_depth);
 
@@ -112,7 +115,7 @@ static int ena_com_admin_init_cq(struct ena_com_admin_queue *queue)
 					 GFP_KERNEL);
 
 	if (!cq->entries) {
-		pr_err("memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -135,7 +138,7 @@ static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
 					   GFP_KERNEL);
 
 	if (!aenq->entries) {
-		pr_err("memory allocation failed\n");
+		dev_err(dev->dmadev, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -156,7 +159,7 @@ static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
 	writel(aenq_caps, dev->reg_bar + ENA_REGS_AENQ_CAPS_OFF);
 
 	if (unlikely(!aenq_handlers)) {
-		pr_err("aenq handlers pointer is NULL\n");
+		dev_err(dev->dmadev, "aenq handlers pointer is NULL\n");
 		return -EINVAL;
 	}
 
@@ -176,18 +179,21 @@ static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *queue,
 					  u16 command_id, bool capture)
 {
 	if (unlikely(command_id >= queue->q_depth)) {
-		pr_err("command id is larger than the queue size. cmd_id: %u queue size %d\n",
-		       command_id, queue->q_depth);
+		dev_err(queue->ena_dev->dmadev,
+			"command id is larger than the queue size. cmd_id: %u queue size %d\n",
+			command_id, queue->q_depth);
 		return NULL;
 	}
 
 	if (unlikely(!queue->comp_ctx)) {
-		pr_err("Completion context is NULL\n");
+		dev_err(queue->ena_dev->dmadev,
+			"Completion context is NULL\n");
 		return NULL;
 	}
 
 	if (unlikely(queue->comp_ctx[command_id].occupied && capture)) {
-		pr_err("Completion context is occupied\n");
+		dev_err(queue->ena_dev->dmadev,
+			"Completion context is occupied\n");
 		return NULL;
 	}
 
@@ -217,7 +223,7 @@ static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queu
 	/* In case of queue FULL */
 	cnt = (u16)atomic_read(&admin_queue->outstanding_cmds);
 	if (cnt >= admin_queue->q_depth) {
-		pr_debug("admin queue is full.\n");
+		dev_dbg(admin_queue->ena_dev->dmadev, "admin queue is full.\n");
 		admin_queue->stats.out_of_space++;
 		return ERR_PTR(-ENOSPC);
 	}
@@ -259,13 +265,14 @@ static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queu
 
 static int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
 {
+	struct ena_com_dev *ena_dev = queue->ena_dev;
 	size_t size = queue->q_depth * sizeof(struct ena_comp_ctx);
 	struct ena_comp_ctx *comp_ctx;
 	u16 i;
 
 	queue->comp_ctx = devm_kzalloc(queue->q_dmadev, size, GFP_KERNEL);
 	if (unlikely(!queue->comp_ctx)) {
-		pr_err("memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -336,7 +343,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		}
 
 		if (!io_sq->desc_addr.virt_addr) {
-			pr_err("memory allocation failed\n");
+			dev_err(ena_dev->dmadev, "memory allocation failed\n");
 			return -ENOMEM;
 		}
 	}
@@ -362,7 +369,8 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 				devm_kzalloc(ena_dev->dmadev, size, GFP_KERNEL);
 
 		if (!io_sq->bounce_buf_ctrl.base_buffer) {
-			pr_err("bounce buffer memory allocation failed\n");
+			dev_err(ena_dev->dmadev,
+				"bounce buffer memory allocation failed\n");
 			return -ENOMEM;
 		}
 
@@ -422,7 +430,7 @@ static int ena_com_init_io_cq(struct ena_com_dev *ena_dev,
 	}
 
 	if (!io_cq->cdesc_addr.virt_addr) {
-		pr_err("memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -443,7 +451,8 @@ static void ena_com_handle_single_admin_completion(struct ena_com_admin_queue *a
 
 	comp_ctx = get_comp_ctxt(admin_queue, cmd_id, false);
 	if (unlikely(!comp_ctx)) {
-		pr_err("comp_ctx is NULL. Changing the admin queue running state\n");
+		dev_err(admin_queue->ena_dev->dmadev,
+			"comp_ctx is NULL. Changing the admin queue running state\n");
 		admin_queue->running_state = false;
 		return;
 	}
@@ -495,10 +504,12 @@ static void ena_com_handle_admin_completion(struct ena_com_admin_queue *admin_qu
 	admin_queue->stats.completed_cmd += comp_num;
 }
 
-static int ena_com_comp_status_to_errno(u8 comp_status)
+static int ena_com_comp_status_to_errno(struct ena_com_admin_queue *admin_queue,
+					u8 comp_status)
 {
 	if (unlikely(comp_status != 0))
-		pr_err("admin command failed[%u]\n", comp_status);
+		dev_err(admin_queue->ena_dev->dmadev,
+			"admin command failed[%u]\n", comp_status);
 
 	switch (comp_status) {
 	case ENA_ADMIN_SUCCESS:
@@ -543,7 +554,8 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 			break;
 
 		if (time_is_before_jiffies(timeout)) {
-			pr_err("Wait for completion (polling) timeout\n");
+			dev_err(admin_queue->ena_dev->dmadev,
+				"Wait for completion (polling) timeout\n");
 			/* ENA didn't have any completion */
 			spin_lock_irqsave(&admin_queue->q_lock, flags);
 			admin_queue->stats.no_completion++;
@@ -559,7 +571,7 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 	}
 
 	if (unlikely(comp_ctx->status == ENA_CMD_ABORTED)) {
-		pr_err("Command was aborted\n");
+		dev_err(admin_queue->ena_dev->dmadev, "Command was aborted\n");
 		spin_lock_irqsave(&admin_queue->q_lock, flags);
 		admin_queue->stats.aborted_cmd++;
 		spin_unlock_irqrestore(&admin_queue->q_lock, flags);
@@ -570,7 +582,7 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 	WARN(comp_ctx->status != ENA_CMD_COMPLETED, "Invalid comp status %d\n",
 	     comp_ctx->status);
 
-	ret = ena_com_comp_status_to_errno(comp_ctx->comp_status);
+	ret = ena_com_comp_status_to_errno(admin_queue, comp_ctx->comp_status);
 err:
 	comp_ctxt_release(admin_queue, comp_ctx);
 	return ret;
@@ -612,7 +624,8 @@ static int ena_com_set_llq(struct ena_com_dev *ena_dev)
 					    sizeof(resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to set LLQ configurations: %d\n", ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to set LLQ configurations: %d\n", ret);
 
 	return ret;
 }
@@ -634,8 +647,9 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 		llq_info->header_location_ctrl =
 			llq_default_cfg->llq_header_location;
 	} else {
-		pr_err("Invalid header location control, supported: 0x%x\n",
-		       supported_feat);
+		dev_err(ena_dev->dmadev,
+			"Invalid header location control, supported: 0x%x\n",
+			supported_feat);
 		return -EINVAL;
 	}
 
@@ -649,14 +663,16 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 			} else if (supported_feat & ENA_ADMIN_SINGLE_DESC_PER_ENTRY) {
 				llq_info->desc_stride_ctrl = ENA_ADMIN_SINGLE_DESC_PER_ENTRY;
 			} else {
-				pr_err("Invalid desc_stride_ctrl, supported: 0x%x\n",
-				       supported_feat);
+				dev_err(ena_dev->dmadev,
+					"Invalid desc_stride_ctrl, supported: 0x%x\n",
+					supported_feat);
 				return -EINVAL;
 			}
 
-			pr_err("Default llq stride ctrl is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
-			       llq_default_cfg->llq_stride_ctrl, supported_feat,
-			       llq_info->desc_stride_ctrl);
+			dev_err(ena_dev->dmadev,
+				"Default llq stride ctrl is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
+				llq_default_cfg->llq_stride_ctrl,
+				supported_feat, llq_info->desc_stride_ctrl);
 		}
 	} else {
 		llq_info->desc_stride_ctrl = 0;
@@ -677,20 +693,23 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 			llq_info->desc_list_entry_size_ctrl = ENA_ADMIN_LIST_ENTRY_SIZE_256B;
 			llq_info->desc_list_entry_size = 256;
 		} else {
-			pr_err("Invalid entry_size_ctrl, supported: 0x%x\n",
-			       supported_feat);
+			dev_err(ena_dev->dmadev,
+				"Invalid entry_size_ctrl, supported: 0x%x\n",
+				supported_feat);
 			return -EINVAL;
 		}
 
-		pr_err("Default llq ring entry size is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
-		       llq_default_cfg->llq_ring_entry_size, supported_feat,
-		       llq_info->desc_list_entry_size);
+		dev_err(ena_dev->dmadev,
+			"Default llq ring entry size is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
+			llq_default_cfg->llq_ring_entry_size, supported_feat,
+			llq_info->desc_list_entry_size);
 	}
 	if (unlikely(llq_info->desc_list_entry_size & 0x7)) {
 		/* The desc list entry size should be whole multiply of 8
 		 * This requirement comes from __iowrite64_copy()
 		 */
-		pr_err("illegal entry size %d\n", llq_info->desc_list_entry_size);
+		dev_err(ena_dev->dmadev, "illegal entry size %d\n",
+			llq_info->desc_list_entry_size);
 		return -EINVAL;
 	}
 
@@ -713,14 +732,16 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 		} else if (supported_feat & ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_8) {
 			llq_info->descs_num_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_8;
 		} else {
-			pr_err("Invalid descs_num_before_header, supported: 0x%x\n",
-			       supported_feat);
+			dev_err(ena_dev->dmadev,
+				"Invalid descs_num_before_header, supported: 0x%x\n",
+				supported_feat);
 			return -EINVAL;
 		}
 
-		pr_err("Default llq num descs before header is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
-		       llq_default_cfg->llq_num_decs_before_header,
-		       supported_feat, llq_info->descs_num_before_header);
+		dev_err(ena_dev->dmadev,
+			"Default llq num descs before header is not supported, performing fallback, default: 0x%x, supported: 0x%x, used: 0x%x\n",
+			llq_default_cfg->llq_num_decs_before_header,
+			supported_feat, llq_info->descs_num_before_header);
 	}
 	/* Check for accelerated queue supported */
 	llq_accel_mode_get = llq_features->accel_mode.u.get;
@@ -736,7 +757,8 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 
 	rc = ena_com_set_llq(ena_dev);
 	if (rc)
-		pr_err("Cannot set LLQ configuration: %d\n", rc);
+		dev_err(ena_dev->dmadev, "Cannot set LLQ configuration: %d\n",
+			rc);
 
 	return rc;
 }
@@ -763,15 +785,17 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 		spin_unlock_irqrestore(&admin_queue->q_lock, flags);
 
 		if (comp_ctx->status == ENA_CMD_COMPLETED) {
-			pr_err("The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d), autopolling mode is %s\n",
-			       comp_ctx->cmd_opcode,
-			       admin_queue->auto_polling ? "ON" : "OFF");
+			dev_err(admin_queue->ena_dev->dmadev,
+				"The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d), autopolling mode is %s\n",
+				comp_ctx->cmd_opcode,
+				admin_queue->auto_polling ? "ON" : "OFF");
 			/* Check if fallback to polling is enabled */
 			if (admin_queue->auto_polling)
 				admin_queue->polling = true;
 		} else {
-			pr_err("The ena device didn't send a completion for the admin cmd %d status %d\n",
-			       comp_ctx->cmd_opcode, comp_ctx->status);
+			dev_err(admin_queue->ena_dev->dmadev,
+				"The ena device didn't send a completion for the admin cmd %d status %d\n",
+				comp_ctx->cmd_opcode, comp_ctx->status);
 		}
 		/* Check if shifted to polling mode.
 		 * This will happen if there is a completion without an interrupt
@@ -784,7 +808,7 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 		}
 	}
 
-	ret = ena_com_comp_status_to_errno(comp_ctx->comp_status);
+	ret = ena_com_comp_status_to_errno(admin_queue, comp_ctx->comp_status);
 err:
 	comp_ctxt_release(admin_queue, comp_ctx);
 	return ret;
@@ -831,15 +855,16 @@ static u32 ena_com_reg_bar_read32(struct ena_com_dev *ena_dev, u16 offset)
 	}
 
 	if (unlikely(i == timeout)) {
-		pr_err("reading reg failed for timeout. expected: req id[%hu] offset[%hu] actual: req id[%hu] offset[%hu]\n",
-		       mmio_read->seq_num, offset, read_resp->req_id,
-		       read_resp->reg_off);
+		dev_err(ena_dev->dmadev,
+			"reading reg failed for timeout. expected: req id[%hu] offset[%hu] actual: req id[%hu] offset[%hu]\n",
+			mmio_read->seq_num, offset, read_resp->req_id,
+			read_resp->reg_off);
 		ret = ENA_MMIO_READ_TIMEOUT;
 		goto err;
 	}
 
 	if (read_resp->reg_off != offset) {
-		pr_err("Read failure: wrong offset provided\n");
+		dev_err(ena_dev->dmadev, "Read failure: wrong offset provided");
 		ret = ENA_MMIO_READ_TIMEOUT;
 	} else {
 		ret = read_resp->reg_val;
@@ -898,7 +923,8 @@ static int ena_com_destroy_io_sq(struct ena_com_dev *ena_dev,
 					    sizeof(destroy_resp));
 
 	if (unlikely(ret && (ret != -ENODEV)))
-		pr_err("failed to destroy io sq error: %d\n", ret);
+		dev_err(ena_dev->dmadev, "failed to destroy io sq error: %d\n",
+			ret);
 
 	return ret;
 }
@@ -948,7 +974,7 @@ static int wait_for_reset_state(struct ena_com_dev *ena_dev, u32 timeout,
 		val = ena_com_reg_bar_read32(ena_dev, ENA_REGS_DEV_STS_OFF);
 
 		if (unlikely(val == ENA_MMIO_READ_TIMEOUT)) {
-			pr_err("Reg read timeout occurred\n");
+			dev_err(ena_dev->dmadev, "Reg read timeout occurred\n");
 			return -ETIME;
 		}
 
@@ -988,7 +1014,8 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 	int ret;
 
 	if (!ena_com_check_supported_feature_id(ena_dev, feature_id)) {
-		pr_debug("Feature %d isn't supported\n", feature_id);
+		dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+			feature_id);
 		return -EOPNOTSUPP;
 	}
 
@@ -1007,7 +1034,7 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 				   &get_cmd.control_buffer.address,
 				   control_buf_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "memory address set failed\n");
 		return ret;
 	}
 
@@ -1024,8 +1051,9 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 					    sizeof(*get_resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to submit get_feature command %d error: %d\n",
-		       feature_id, ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to submit get_feature command %d error: %d\n",
+			feature_id, ret);
 
 	return ret;
 }
@@ -1128,9 +1156,10 @@ static int ena_com_indirect_table_allocate(struct ena_com_dev *ena_dev,
 
 	if ((get_resp.u.ind_table.min_size > log_size) ||
 	    (get_resp.u.ind_table.max_size < log_size)) {
-		pr_err("indirect table size doesn't fit. requested size: %d while min is:%d and max %d\n",
-		       1 << log_size, 1 << get_resp.u.ind_table.min_size,
-		       1 << get_resp.u.ind_table.max_size);
+		dev_err(ena_dev->dmadev,
+			"indirect table size doesn't fit. requested size: %d while min is:%d and max %d\n",
+			1 << log_size, 1 << get_resp.u.ind_table.min_size,
+			1 << get_resp.u.ind_table.max_size);
 		return -EINVAL;
 	}
 
@@ -1221,7 +1250,7 @@ static int ena_com_create_io_sq(struct ena_com_dev *ena_dev,
 					   &create_cmd.sq_ba,
 					   io_sq->desc_addr.phys_addr);
 		if (unlikely(ret)) {
-			pr_err("memory address set failed\n");
+			dev_err(ena_dev->dmadev, "memory address set failed\n");
 			return ret;
 		}
 	}
@@ -1232,7 +1261,8 @@ static int ena_com_create_io_sq(struct ena_com_dev *ena_dev,
 					    (struct ena_admin_acq_entry *)&cmd_completion,
 					    sizeof(cmd_completion));
 	if (unlikely(ret)) {
-		pr_err("Failed to create IO SQ. error: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to create IO SQ. error: %d\n",
+			ret);
 		return ret;
 	}
 
@@ -1250,7 +1280,8 @@ static int ena_com_create_io_sq(struct ena_com_dev *ena_dev,
 			cmd_completion.llq_descriptors_offset);
 	}
 
-	pr_debug("created sq[%u], depth[%u]\n", io_sq->idx, io_sq->q_depth);
+	dev_dbg(ena_dev->dmadev, "created sq[%u], depth[%u]\n", io_sq->idx,
+		io_sq->q_depth);
 
 	return ret;
 }
@@ -1284,7 +1315,8 @@ static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 	u16 prev_intr_delay_resolution = ena_dev->intr_delay_resolution;
 
 	if (unlikely(!intr_delay_resolution)) {
-		pr_err("Illegal intr_delay_resolution provided. Going to use default 1 usec resolution\n");
+		dev_err(ena_dev->dmadev,
+			"Illegal intr_delay_resolution provided. Going to use default 1 usec resolution\n");
 		intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	}
 
@@ -1320,11 +1352,13 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
 					    comp, comp_size);
 	if (IS_ERR(comp_ctx)) {
 		if (comp_ctx == ERR_PTR(-ENODEV))
-			pr_debug("Failed to submit command [%ld]\n",
-				 PTR_ERR(comp_ctx));
+			dev_dbg(admin_queue->ena_dev->dmadev,
+				"Failed to submit command [%ld]\n",
+				PTR_ERR(comp_ctx));
 		else
-			pr_err("Failed to submit command [%ld]\n",
-			       PTR_ERR(comp_ctx));
+			dev_err(admin_queue->ena_dev->dmadev,
+				"Failed to submit command [%ld]\n",
+				PTR_ERR(comp_ctx));
 
 		return PTR_ERR(comp_ctx);
 	}
@@ -1332,9 +1366,11 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
 	ret = ena_com_wait_and_process_admin_cq(comp_ctx, admin_queue);
 	if (unlikely(ret)) {
 		if (admin_queue->running_state)
-			pr_err("Failed to process command. ret = %d\n", ret);
+			dev_err(admin_queue->ena_dev->dmadev,
+				"Failed to process command. ret = %d\n", ret);
 		else
-			pr_debug("Failed to process command. ret = %d\n", ret);
+			dev_dbg(admin_queue->ena_dev->dmadev,
+				"Failed to process command. ret = %d\n", ret);
 	}
 	return ret;
 }
@@ -1363,7 +1399,7 @@ int ena_com_create_io_cq(struct ena_com_dev *ena_dev,
 				   &create_cmd.cq_ba,
 				   io_cq->cdesc_addr.phys_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -1373,7 +1409,8 @@ int ena_com_create_io_cq(struct ena_com_dev *ena_dev,
 					    (struct ena_admin_acq_entry *)&cmd_completion,
 					    sizeof(cmd_completion));
 	if (unlikely(ret)) {
-		pr_err("Failed to create IO CQ. error: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to create IO CQ. error: %d\n",
+			ret);
 		return ret;
 	}
 
@@ -1392,7 +1429,8 @@ int ena_com_create_io_cq(struct ena_com_dev *ena_dev,
 			(u32 __iomem *)((uintptr_t)ena_dev->reg_bar +
 			cmd_completion.numa_node_register_offset);
 
-	pr_debug("created cq[%u], depth[%u]\n", io_cq->idx, io_cq->q_depth);
+	dev_dbg(ena_dev->dmadev, "created cq[%u], depth[%u]\n", io_cq->idx,
+		io_cq->q_depth);
 
 	return ret;
 }
@@ -1402,8 +1440,9 @@ int ena_com_get_io_handlers(struct ena_com_dev *ena_dev, u16 qid,
 			    struct ena_com_io_cq **io_cq)
 {
 	if (qid >= ENA_TOTAL_NUM_QUEUES) {
-		pr_err("Invalid queue number %d but the max is %d\n", qid,
-		       ENA_TOTAL_NUM_QUEUES);
+		dev_err(ena_dev->dmadev,
+			"Invalid queue number %d but the max is %d\n", qid,
+			ENA_TOTAL_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -1469,7 +1508,8 @@ int ena_com_destroy_io_cq(struct ena_com_dev *ena_dev,
 					    sizeof(destroy_resp));
 
 	if (unlikely(ret && (ret != -ENODEV)))
-		pr_err("Failed to destroy IO CQ. error: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to destroy IO CQ. error: %d\n",
+			ret);
 
 	return ret;
 }
@@ -1511,13 +1551,14 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
 
 	ret = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_AENQ_CONFIG, 0);
 	if (ret) {
-		pr_info("Can't get aenq configuration\n");
+		dev_info(ena_dev->dmadev, "Can't get aenq configuration\n");
 		return ret;
 	}
 
 	if ((get_resp.u.aenq.supported_groups & groups_flag) != groups_flag) {
-		pr_warn("Trying to set unsupported aenq events. supported flag: 0x%x asked flag: 0x%x\n",
-			get_resp.u.aenq.supported_groups, groups_flag);
+		dev_warn(ena_dev->dmadev,
+			 "Trying to set unsupported aenq events. supported flag: 0x%x asked flag: 0x%x\n",
+			 get_resp.u.aenq.supported_groups, groups_flag);
 		return -EOPNOTSUPP;
 	}
 
@@ -1536,7 +1577,7 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
 					    sizeof(resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to config AENQ ret: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to config AENQ ret: %d\n", ret);
 
 	return ret;
 }
@@ -1547,17 +1588,17 @@ int ena_com_get_dma_width(struct ena_com_dev *ena_dev)
 	int width;
 
 	if (unlikely(caps == ENA_MMIO_READ_TIMEOUT)) {
-		pr_err("Reg read timeout occurred\n");
+		dev_err(ena_dev->dmadev, "Reg read timeout occurred\n");
 		return -ETIME;
 	}
 
 	width = (caps & ENA_REGS_CAPS_DMA_ADDR_WIDTH_MASK) >>
 		ENA_REGS_CAPS_DMA_ADDR_WIDTH_SHIFT;
 
-	pr_debug("ENA dma width: %d\n", width);
+	dev_dbg(ena_dev->dmadev, "ENA dma width: %d\n", width);
 
 	if ((width < 32) || width > ENA_MAX_PHYS_ADDR_SIZE_BITS) {
-		pr_err("DMA width illegal value: %d\n", width);
+		dev_err(ena_dev->dmadev, "DMA width illegal value: %d\n", width);
 		return -EINVAL;
 	}
 
@@ -1581,23 +1622,24 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev)
 
 	if (unlikely((ver == ENA_MMIO_READ_TIMEOUT) ||
 		     (ctrl_ver == ENA_MMIO_READ_TIMEOUT))) {
-		pr_err("Reg read timeout occurred\n");
+		dev_err(ena_dev->dmadev, "Reg read timeout occurred\n");
 		return -ETIME;
 	}
 
-	pr_info("ena device version: %d.%d\n",
-		(ver & ENA_REGS_VERSION_MAJOR_VERSION_MASK) >>
-			ENA_REGS_VERSION_MAJOR_VERSION_SHIFT,
-		ver & ENA_REGS_VERSION_MINOR_VERSION_MASK);
+	dev_info(ena_dev->dmadev, "ena device version: %d.%d\n",
+		 (ver & ENA_REGS_VERSION_MAJOR_VERSION_MASK) >>
+			 ENA_REGS_VERSION_MAJOR_VERSION_SHIFT,
+		 ver & ENA_REGS_VERSION_MINOR_VERSION_MASK);
 
-	pr_info("ena controller version: %d.%d.%d implementation version %d\n",
-		(ctrl_ver & ENA_REGS_CONTROLLER_VERSION_MAJOR_VERSION_MASK) >>
-			ENA_REGS_CONTROLLER_VERSION_MAJOR_VERSION_SHIFT,
-		(ctrl_ver & ENA_REGS_CONTROLLER_VERSION_MINOR_VERSION_MASK) >>
-			ENA_REGS_CONTROLLER_VERSION_MINOR_VERSION_SHIFT,
-		(ctrl_ver & ENA_REGS_CONTROLLER_VERSION_SUBMINOR_VERSION_MASK),
-		(ctrl_ver & ENA_REGS_CONTROLLER_VERSION_IMPL_ID_MASK) >>
-			ENA_REGS_CONTROLLER_VERSION_IMPL_ID_SHIFT);
+	dev_info(ena_dev->dmadev,
+		 "ENA controller version: %d.%d.%d implementation version %d\n",
+		 (ctrl_ver & ENA_REGS_CONTROLLER_VERSION_MAJOR_VERSION_MASK) >>
+			 ENA_REGS_CONTROLLER_VERSION_MAJOR_VERSION_SHIFT,
+		 (ctrl_ver & ENA_REGS_CONTROLLER_VERSION_MINOR_VERSION_MASK) >>
+			 ENA_REGS_CONTROLLER_VERSION_MINOR_VERSION_SHIFT,
+		 (ctrl_ver & ENA_REGS_CONTROLLER_VERSION_SUBMINOR_VERSION_MASK),
+		 (ctrl_ver & ENA_REGS_CONTROLLER_VERSION_IMPL_ID_MASK) >>
+			 ENA_REGS_CONTROLLER_VERSION_IMPL_ID_SHIFT);
 
 	ctrl_ver_masked =
 		(ctrl_ver & ENA_REGS_CONTROLLER_VERSION_MAJOR_VERSION_MASK) |
@@ -1606,7 +1648,8 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev)
 
 	/* Validate the ctrl version without the implementation ID */
 	if (ctrl_ver_masked < MIN_ENA_CTRL_VER) {
-		pr_err("ENA ctrl version is lower than the minimal ctrl version the driver supports\n");
+		dev_err(ena_dev->dmadev,
+			"ENA ctrl version is lower than the minimal ctrl version the driver supports\n");
 		return -1;
 	}
 
@@ -1727,12 +1770,12 @@ int ena_com_admin_init(struct ena_com_dev *ena_dev,
 	dev_sts = ena_com_reg_bar_read32(ena_dev, ENA_REGS_DEV_STS_OFF);
 
 	if (unlikely(dev_sts == ENA_MMIO_READ_TIMEOUT)) {
-		pr_err("Reg read timeout occurred\n");
+		dev_err(ena_dev->dmadev, "Reg read timeout occurred\n");
 		return -ETIME;
 	}
 
 	if (!(dev_sts & ENA_REGS_DEV_STS_READY_MASK)) {
-		pr_err("Device isn't ready, abort com init\n");
+		dev_err(ena_dev->dmadev, "Device isn't ready, abort com init\n");
 		return -ENODEV;
 	}
 
@@ -1809,8 +1852,9 @@ int ena_com_create_io_queue(struct ena_com_dev *ena_dev,
 	int ret;
 
 	if (ctx->qid >= ENA_TOTAL_NUM_QUEUES) {
-		pr_err("Qid (%d) is bigger than max num of queues (%d)\n",
-		       ctx->qid, ENA_TOTAL_NUM_QUEUES);
+		dev_err(ena_dev->dmadev,
+			"Qid (%d) is bigger than max num of queues (%d)\n",
+			ctx->qid, ENA_TOTAL_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -1868,8 +1912,9 @@ void ena_com_destroy_io_queue(struct ena_com_dev *ena_dev, u16 qid)
 	struct ena_com_io_cq *io_cq;
 
 	if (qid >= ENA_TOTAL_NUM_QUEUES) {
-		pr_err("Qid (%d) is bigger than max num of queues (%d)\n", qid,
-		       ENA_TOTAL_NUM_QUEUES);
+		dev_err(ena_dev->dmadev,
+			"Qid (%d) is bigger than max num of queues (%d)\n", qid,
+			ENA_TOTAL_NUM_QUEUES);
 		return;
 	}
 
@@ -2019,8 +2064,10 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 
 		timestamp = (u64)aenq_common->timestamp_low |
 			    ((u64)aenq_common->timestamp_high << 32);
-		pr_debug("AENQ! Group[%x] Syndrom[%x] timestamp: [%llus]\n",
-			 aenq_common->group, aenq_common->syndrom, timestamp);
+
+		dev_dbg(dev->dmadev,
+			"AENQ! Group[%x] Syndrom[%x] timestamp: [%llus]\n",
+			aenq_common->group, aenq_common->syndrom, timestamp);
 
 		/* Handle specific event*/
 		handler_cb = ena_com_get_specific_aenq_cb(dev,
@@ -2062,19 +2109,20 @@ int ena_com_dev_reset(struct ena_com_dev *ena_dev,
 
 	if (unlikely((stat == ENA_MMIO_READ_TIMEOUT) ||
 		     (cap == ENA_MMIO_READ_TIMEOUT))) {
-		pr_err("Reg read32 timeout occurred\n");
+		dev_err(ena_dev->dmadev, "Reg read32 timeout occurred\n");
 		return -ETIME;
 	}
 
 	if ((stat & ENA_REGS_DEV_STS_READY_MASK) == 0) {
-		pr_err("Device isn't ready, can't reset device\n");
+		dev_err(ena_dev->dmadev,
+			"Device isn't ready, can't reset device\n");
 		return -EINVAL;
 	}
 
 	timeout = (cap & ENA_REGS_CAPS_RESET_TIMEOUT_MASK) >>
 			ENA_REGS_CAPS_RESET_TIMEOUT_SHIFT;
 	if (timeout == 0) {
-		pr_err("Invalid timeout value\n");
+		dev_err(ena_dev->dmadev, "Invalid timeout value\n");
 		return -EINVAL;
 	}
 
@@ -2090,7 +2138,7 @@ int ena_com_dev_reset(struct ena_com_dev *ena_dev,
 	rc = wait_for_reset_state(ena_dev, timeout,
 				  ENA_REGS_DEV_STS_RESET_IN_PROGRESS_MASK);
 	if (rc != 0) {
-		pr_err("Reset indication didn't turn on\n");
+		dev_err(ena_dev->dmadev, "Reset indication didn't turn on\n");
 		return rc;
 	}
 
@@ -2098,7 +2146,7 @@ int ena_com_dev_reset(struct ena_com_dev *ena_dev,
 	writel(0, ena_dev->reg_bar + ENA_REGS_DEV_CTL_OFF);
 	rc = wait_for_reset_state(ena_dev, timeout, 0);
 	if (rc != 0) {
-		pr_err("Reset indication didn't turn off\n");
+		dev_err(ena_dev->dmadev, "Reset indication didn't turn off\n");
 		return rc;
 	}
 
@@ -2135,7 +2183,7 @@ static int ena_get_dev_stats(struct ena_com_dev *ena_dev,
 					     sizeof(*get_resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to get stats. error: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to get stats. error: %d\n", ret);
 
 	return ret;
 }
@@ -2178,7 +2226,8 @@ int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu)
 	int ret;
 
 	if (!ena_com_check_supported_feature_id(ena_dev, ENA_ADMIN_MTU)) {
-		pr_debug("Feature %d isn't supported\n", ENA_ADMIN_MTU);
+		dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+			ENA_ADMIN_MTU);
 		return -EOPNOTSUPP;
 	}
 
@@ -2197,7 +2246,8 @@ int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu)
 					    sizeof(resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to set mtu %d. error: %d\n", mtu, ret);
+		dev_err(ena_dev->dmadev, "Failed to set mtu %d. error: %d\n",
+			mtu, ret);
 
 	return ret;
 }
@@ -2211,7 +2261,8 @@ int ena_com_get_offload_settings(struct ena_com_dev *ena_dev,
 	ret = ena_com_get_feature(ena_dev, &resp,
 				  ENA_ADMIN_STATELESS_OFFLOAD_CONFIG, 0);
 	if (unlikely(ret)) {
-		pr_err("Failed to get offload capabilities %d\n", ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to get offload capabilities %d\n", ret);
 		return ret;
 	}
 
@@ -2231,8 +2282,8 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 
 	if (!ena_com_check_supported_feature_id(ena_dev,
 						ENA_ADMIN_RSS_HASH_FUNCTION)) {
-		pr_debug("Feature %d isn't supported\n",
-			 ENA_ADMIN_RSS_HASH_FUNCTION);
+		dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+			ENA_ADMIN_RSS_HASH_FUNCTION);
 		return -EOPNOTSUPP;
 	}
 
@@ -2243,8 +2294,9 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 		return ret;
 
 	if (!(get_resp.u.flow_hash_func.supported_func & BIT(rss->hash_func))) {
-		pr_err("Func hash %d isn't supported by device, abort\n",
-		       rss->hash_func);
+		dev_err(ena_dev->dmadev,
+			"Func hash %d isn't supported by device, abort\n",
+			rss->hash_func);
 		return -EOPNOTSUPP;
 	}
 
@@ -2261,7 +2313,7 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 				   &cmd.control_buffer.address,
 				   rss->hash_key_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -2273,8 +2325,9 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 					    (struct ena_admin_acq_entry *)&resp,
 					    sizeof(resp));
 	if (unlikely(ret)) {
-		pr_err("Failed to set hash function %d. error: %d\n",
-		       rss->hash_func, ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to set hash function %d. error: %d\n",
+			rss->hash_func, ret);
 		return -EINVAL;
 	}
 
@@ -2305,7 +2358,8 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return rc;
 
 	if (!(BIT(func) & get_resp.u.flow_hash_func.supported_func)) {
-		pr_err("Flow hash function %d isn't supported\n", func);
+		dev_err(ena_dev->dmadev,
+			"Flow hash function %d isn't supported\n", func);
 		return -EOPNOTSUPP;
 	}
 
@@ -2313,8 +2367,9 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 	case ENA_ADMIN_TOEPLITZ:
 		if (key) {
 			if (key_len != sizeof(hash_key->key)) {
-				pr_err("key len (%hu) doesn't equal the supported size (%zu)\n",
-				       key_len, sizeof(hash_key->key));
+				dev_err(ena_dev->dmadev,
+					"key len (%hu) doesn't equal the supported size (%zu)\n",
+					key_len, sizeof(hash_key->key));
 				return -EINVAL;
 			}
 			memcpy(hash_key->key, key, key_len);
@@ -2326,7 +2381,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		rss->hash_init_val = init_val;
 		break;
 	default:
-		pr_err("Invalid hash function (%d)\n", func);
+		dev_err(ena_dev->dmadev, "Invalid hash function (%d)\n", func);
 		return -EINVAL;
 	}
 
@@ -2411,8 +2466,8 @@ int ena_com_set_hash_ctrl(struct ena_com_dev *ena_dev)
 
 	if (!ena_com_check_supported_feature_id(ena_dev,
 						ENA_ADMIN_RSS_HASH_INPUT)) {
-		pr_debug("Feature %d isn't supported\n",
-			 ENA_ADMIN_RSS_HASH_INPUT);
+		dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+			ENA_ADMIN_RSS_HASH_INPUT);
 		return -EOPNOTSUPP;
 	}
 
@@ -2430,7 +2485,7 @@ int ena_com_set_hash_ctrl(struct ena_com_dev *ena_dev)
 				   &cmd.control_buffer.address,
 				   rss->hash_ctrl_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "memory address set failed\n");
 		return ret;
 	}
 	cmd.control_buffer.length = sizeof(*hash_ctrl);
@@ -2441,7 +2496,8 @@ int ena_com_set_hash_ctrl(struct ena_com_dev *ena_dev)
 					    (struct ena_admin_acq_entry *)&resp,
 					    sizeof(resp));
 	if (unlikely(ret))
-		pr_err("Failed to set hash input. error: %d\n", ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to set hash input. error: %d\n", ret);
 
 	return ret;
 }
@@ -2491,9 +2547,10 @@ int ena_com_set_default_hash_ctrl(struct ena_com_dev *ena_dev)
 		available_fields = hash_ctrl->selected_fields[i].fields &
 				hash_ctrl->supported_fields[i].fields;
 		if (available_fields != hash_ctrl->selected_fields[i].fields) {
-			pr_err("hash control doesn't support all the desire configuration. proto %x supported %x selected %x\n",
-			       i, hash_ctrl->supported_fields[i].fields,
-			       hash_ctrl->selected_fields[i].fields);
+			dev_err(ena_dev->dmadev,
+				"hash control doesn't support all the desire configuration. proto %x supported %x selected %x\n",
+				i, hash_ctrl->supported_fields[i].fields,
+				hash_ctrl->selected_fields[i].fields);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -2517,7 +2574,7 @@ int ena_com_fill_hash_ctrl(struct ena_com_dev *ena_dev,
 	int rc;
 
 	if (proto >= ENA_ADMIN_RSS_PROTO_NUM) {
-		pr_err("Invalid proto num (%u)\n", proto);
+		dev_err(ena_dev->dmadev, "Invalid proto num (%u)\n", proto);
 		return -EINVAL;
 	}
 
@@ -2529,8 +2586,9 @@ int ena_com_fill_hash_ctrl(struct ena_com_dev *ena_dev,
 	/* Make sure all the fields are supported */
 	supported_fields = hash_ctrl->supported_fields[proto].fields;
 	if ((hash_fields & supported_fields) != hash_fields) {
-		pr_err("proto %d doesn't support the required fields %x. supports only: %x\n",
-		       proto, hash_fields, supported_fields);
+		dev_err(ena_dev->dmadev,
+			"proto %d doesn't support the required fields %x. supports only: %x\n",
+			proto, hash_fields, supported_fields);
 	}
 
 	hash_ctrl->selected_fields[proto].fields = hash_fields;
@@ -2570,14 +2628,15 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 
 	if (!ena_com_check_supported_feature_id(
 		    ena_dev, ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG)) {
-		pr_debug("Feature %d isn't supported\n",
-			 ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG);
+		dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+			ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG);
 		return -EOPNOTSUPP;
 	}
 
 	ret = ena_com_ind_tbl_convert_to_device(ena_dev);
 	if (ret) {
-		pr_err("Failed to convert host indirection table to device table\n");
+		dev_err(ena_dev->dmadev,
+			"Failed to convert host indirection table to device table\n");
 		return ret;
 	}
 
@@ -2594,7 +2653,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 				   &cmd.control_buffer.address,
 				   rss->rss_ind_tbl_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "memory address set failed\n");
 		return ret;
 	}
 
@@ -2608,7 +2667,8 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 					    sizeof(resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to set indirect table. error: %d\n", ret);
+		dev_err(ena_dev->dmadev,
+			"Failed to set indirect table. error: %d\n", ret);
 
 	return ret;
 }
@@ -2765,7 +2825,7 @@ int ena_com_set_host_attributes(struct ena_com_dev *ena_dev)
 				   &cmd.u.host_attr.debug_ba,
 				   host_attr->debug_area_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "memory address set failed\n");
 		return ret;
 	}
 
@@ -2773,7 +2833,7 @@ int ena_com_set_host_attributes(struct ena_com_dev *ena_dev)
 				   &cmd.u.host_attr.os_info_ba,
 				   host_attr->host_info_dma_addr);
 	if (unlikely(ret)) {
-		pr_err("memory address set failed\n");
+		dev_err(ena_dev->dmadev, "memory address set failed\n");
 		return ret;
 	}
 
@@ -2786,7 +2846,8 @@ int ena_com_set_host_attributes(struct ena_com_dev *ena_dev)
 					    sizeof(resp));
 
 	if (unlikely(ret))
-		pr_err("Failed to set host attributes: %d\n", ret);
+		dev_err(ena_dev->dmadev, "Failed to set host attributes: %d\n",
+			ret);
 
 	return ret;
 }
@@ -2798,12 +2859,14 @@ bool ena_com_interrupt_moderation_supported(struct ena_com_dev *ena_dev)
 						  ENA_ADMIN_INTERRUPT_MODERATION);
 }
 
-static int ena_com_update_nonadaptive_moderation_interval(u32 coalesce_usecs,
+static int ena_com_update_nonadaptive_moderation_interval(struct ena_com_dev *ena_dev,
+							  u32 coalesce_usecs,
 							  u32 intr_delay_resolution,
 							  u32 *intr_moder_interval)
 {
 	if (!intr_delay_resolution) {
-		pr_err("Illegal interrupt delay granularity value\n");
+		dev_err(ena_dev->dmadev,
+			"Illegal interrupt delay granularity value\n");
 		return -EFAULT;
 	}
 
@@ -2815,7 +2878,8 @@ static int ena_com_update_nonadaptive_moderation_interval(u32 coalesce_usecs,
 int ena_com_update_nonadaptive_moderation_interval_tx(struct ena_com_dev *ena_dev,
 						      u32 tx_coalesce_usecs)
 {
-	return ena_com_update_nonadaptive_moderation_interval(tx_coalesce_usecs,
+	return ena_com_update_nonadaptive_moderation_interval(ena_dev,
+							      tx_coalesce_usecs,
 							      ena_dev->intr_delay_resolution,
 							      &ena_dev->intr_moder_tx_interval);
 }
@@ -2823,7 +2887,8 @@ int ena_com_update_nonadaptive_moderation_interval_tx(struct ena_com_dev *ena_de
 int ena_com_update_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_dev,
 						      u32 rx_coalesce_usecs)
 {
-	return ena_com_update_nonadaptive_moderation_interval(rx_coalesce_usecs,
+	return ena_com_update_nonadaptive_moderation_interval(ena_dev,
+							      rx_coalesce_usecs,
 							      ena_dev->intr_delay_resolution,
 							      &ena_dev->intr_moder_rx_interval);
 }
@@ -2839,12 +2904,13 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 
 	if (rc) {
 		if (rc == -EOPNOTSUPP) {
-			pr_debug("Feature %d isn't supported\n",
-				 ENA_ADMIN_INTERRUPT_MODERATION);
+			dev_dbg(ena_dev->dmadev, "Feature %d isn't supported\n",
+				ENA_ADMIN_INTERRUPT_MODERATION);
 			rc = 0;
 		} else {
-			pr_err("Failed to get interrupt moderation admin cmd. rc: %d\n",
-			       rc);
+			dev_err(ena_dev->dmadev,
+				"Failed to get interrupt moderation admin cmd. rc: %d\n",
+				rc);
 		}
 
 		/* no moderation supported, disable adaptive support */
@@ -2892,7 +2958,8 @@ int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 		(llq_info->descs_num_before_header * sizeof(struct ena_eth_io_tx_desc));
 
 	if (unlikely(ena_dev->tx_max_header_size == 0)) {
-		pr_err("the size of the LLQ entry is smaller than needed\n");
+		dev_err(ena_dev->dmadev,
+			"the size of the LLQ entry is smaller than needed\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index fe60a5696d9e..ffd2137e59b9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -931,6 +931,26 @@ int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 			    struct ena_admin_feature_llq_desc *llq_features,
 			    struct ena_llq_configurations *llq_default_config);
 
+/* ena_com_io_sq_to_ena_dev - Extract ena_com_dev using contained field io_sq.
+ * @io_sq: IO submit queue struct
+ *
+ * @return - ena_com_dev struct extracted from io_sq
+ */
+static inline struct ena_com_dev *ena_com_io_sq_to_ena_dev(struct ena_com_io_sq *io_sq)
+{
+	return container_of(io_sq, struct ena_com_dev, io_sq_queues[io_sq->qid]);
+}
+
+/* ena_com_io_cq_to_ena_dev - Extract ena_com_dev using contained field io_cq.
+ * @io_sq: IO submit queue struct
+ *
+ * @return - ena_com_dev struct extracted from io_sq
+ */
+static inline struct ena_com_dev *ena_com_io_cq_to_ena_dev(struct ena_com_io_cq *io_cq)
+{
+	return container_of(io_cq, struct ena_com_dev, io_cq_queues[io_cq->qid]);
+}
+
 static inline bool ena_com_get_adaptive_moderation_enabled(struct ena_com_dev *ena_dev)
 {
 	return ena_dev->adaptive_coalescing;
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index a47830ca5b99..2814a712318b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -57,13 +57,15 @@ static int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
 
 	if (is_llq_max_tx_burst_exists(io_sq)) {
 		if (unlikely(!io_sq->entries_in_tx_burst_left)) {
-			pr_err("Error: trying to send more packets than tx burst allows\n");
+			dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+				"Error: trying to send more packets than tx burst allows\n");
 			return -ENOSPC;
 		}
 
 		io_sq->entries_in_tx_burst_left--;
-		pr_debug("decreasing entries_in_tx_burst_left of queue %d to %d\n",
-			 io_sq->qid, io_sq->entries_in_tx_burst_left);
+		dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"decreasing entries_in_tx_burst_left of queue %d to %d\n",
+			io_sq->qid, io_sq->entries_in_tx_burst_left);
 	}
 
 	/* Make sure everything was written into the bounce buffer before
@@ -101,12 +103,14 @@ static int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
 
 	if (unlikely((header_offset + header_len) >
 		     llq_info->desc_list_entry_size)) {
-		pr_err("trying to write header larger than llq entry can accommodate\n");
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"trying to write header larger than llq entry can accommodate\n");
 		return -EFAULT;
 	}
 
 	if (unlikely(!bounce_buffer)) {
-		pr_err("bounce buffer is NULL\n");
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"bounce buffer is NULL\n");
 		return -EFAULT;
 	}
 
@@ -124,7 +128,8 @@ static void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
 	bounce_buffer = pkt_ctrl->curr_bounce_buf;
 
 	if (unlikely(!bounce_buffer)) {
-		pr_err("bounce buffer is NULL\n");
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"bounce buffer is NULL\n");
 		return NULL;
 	}
 
@@ -148,8 +153,11 @@ static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 	if (pkt_ctrl->idx) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+				"Failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -179,8 +187,11 @@ static int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 	if (!pkt_ctrl->descs_left_in_line) {
 		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
 							pkt_ctrl->curr_bounce_buf);
-		if (unlikely(rc))
+		if (unlikely(rc)) {
+			dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+				"Failed to write bounce buffer to device\n");
 			return rc;
+		}
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
@@ -248,8 +259,9 @@ static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 		io_cq->cur_rx_pkt_cdesc_count = 0;
 		io_cq->cur_rx_pkt_cdesc_start_idx = head_masked;
 
-		pr_debug("ena q_id: %d packets were completed. first desc idx %u descs# %d\n",
-			 io_cq->qid, *first_cdesc_idx, count);
+		dev_dbg(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+			"ENA q_id: %d packets were completed. first desc idx %u descs# %d\n",
+			io_cq->qid, *first_cdesc_idx, count);
 	} else {
 		io_cq->cur_rx_pkt_cdesc_count += count;
 		count = 0;
@@ -330,8 +342,9 @@ static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 	return 0;
 }
 
-static void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
-					struct ena_eth_io_rx_cdesc_base *cdesc)
+static void ena_com_rx_set_flags(struct ena_com_io_cq *io_cq,
+				 struct ena_com_rx_ctx *ena_rx_ctx,
+				 struct ena_eth_io_rx_cdesc_base *cdesc)
 {
 	ena_rx_ctx->l3_proto = cdesc->status &
 		ENA_ETH_IO_RX_CDESC_BASE_L3_PROTO_IDX_MASK;
@@ -352,10 +365,11 @@ static void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
 		(cdesc->status & ENA_ETH_IO_RX_CDESC_BASE_IPV4_FRAG_MASK) >>
 		ENA_ETH_IO_RX_CDESC_BASE_IPV4_FRAG_SHIFT;
 
-	pr_debug("ena_rx_ctx->l3_proto %d ena_rx_ctx->l4_proto %d\nena_rx_ctx->l3_csum_err %d ena_rx_ctx->l4_csum_err %d\nhash frag %d frag: %d cdesc_status: %x\n",
-		 ena_rx_ctx->l3_proto, ena_rx_ctx->l4_proto,
-		 ena_rx_ctx->l3_csum_err, ena_rx_ctx->l4_csum_err,
-		 ena_rx_ctx->hash, ena_rx_ctx->frag, cdesc->status);
+	dev_dbg(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+		"l3_proto %d l4_proto %d l3_csum_err %d l4_csum_err %d hash %d frag %d cdesc_status %x\n",
+		ena_rx_ctx->l3_proto, ena_rx_ctx->l4_proto,
+		ena_rx_ctx->l3_csum_err, ena_rx_ctx->l4_csum_err,
+		ena_rx_ctx->hash, ena_rx_ctx->frag, cdesc->status);
 }
 
 /*****************************************************************************/
@@ -380,19 +394,24 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 
 	/* num_bufs +1 for potential meta desc */
 	if (unlikely(!ena_com_sq_have_enough_space(io_sq, num_bufs + 1))) {
-		pr_debug("Not enough space in the tx queue\n");
+		dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"Not enough space in the tx queue\n");
 		return -ENOMEM;
 	}
 
 	if (unlikely(header_len > io_sq->tx_max_header_size)) {
-		pr_err("header size is too large %d max header: %d\n",
-		       header_len, io_sq->tx_max_header_size);
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"header size is too large %d max header: %d\n",
+			header_len, io_sq->tx_max_header_size);
 		return -EINVAL;
 	}
 
 	if (unlikely(io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV &&
-		     !buffer_to_push))
+		     !buffer_to_push)) {
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"Push header wasn't provided on LLQ mode\n");
 		return -EINVAL;
+	}
 
 	rc = ena_com_write_header_to_bounce(io_sq, buffer_to_push, header_len);
 	if (unlikely(rc))
@@ -400,13 +419,17 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 
 	rc = ena_com_create_and_store_tx_meta_desc(io_sq, ena_tx_ctx, &have_meta);
 	if (unlikely(rc)) {
-		pr_err("failed to create and store tx meta desc\n");
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"failed to create and store tx meta desc\n");
 		return rc;
 	}
 
 	/* If the caller doesn't want to send packets */
 	if (unlikely(!num_bufs && !header_len)) {
 		rc = ena_com_close_bounce_buffer(io_sq);
+		if (rc)
+			dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+				"Failed to write buffers to LLQ\n");
 		*nb_hw_desc = io_sq->tail - start_tail;
 		return rc;
 	}
@@ -466,8 +489,11 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 		/* The first desc share the same desc as the header */
 		if (likely(i != 0)) {
 			rc = ena_com_sq_update_tail(io_sq);
-			if (unlikely(rc))
+			if (unlikely(rc)) {
+				dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+					"Failed to update sq tail\n");
 				return rc;
+			}
 
 			desc = get_sq_desc(io_sq);
 			if (unlikely(!desc))
@@ -496,10 +522,16 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	desc->len_ctrl |= ENA_ETH_IO_TX_DESC_LAST_MASK;
 
 	rc = ena_com_sq_update_tail(io_sq);
-	if (unlikely(rc))
+	if (unlikely(rc)) {
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"Failed to update sq tail of the last descriptor\n");
 		return rc;
+	}
 
 	rc = ena_com_close_bounce_buffer(io_sq);
+	if (rc)
+		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"Failed when closing bounce buffer\n");
 
 	*nb_hw_desc = io_sq->tail - start_tail;
 	return rc;
@@ -523,12 +555,14 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 		return 0;
 	}
 
-	pr_debug("fetch rx packet: queue %d completed desc: %d\n", io_cq->qid,
-		 nb_hw_desc);
+	dev_dbg(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+		"Fetch rx packet: queue %d completed desc: %d\n", io_cq->qid,
+		nb_hw_desc);
 
 	if (unlikely(nb_hw_desc > ena_rx_ctx->max_bufs)) {
-		pr_err("Too many RX cdescs (%d) > MAX(%d)\n", nb_hw_desc,
-		       ena_rx_ctx->max_bufs);
+		dev_err(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+			"Too many RX cdescs (%d) > MAX(%d)\n", nb_hw_desc,
+			ena_rx_ctx->max_bufs);
 		return -ENOSPC;
 	}
 
@@ -549,11 +583,12 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	/* Update SQ head ptr */
 	io_sq->next_to_comp += nb_hw_desc;
 
-	pr_debug("[%s][QID#%d] Updating SQ head to: %d\n", __func__, io_sq->qid,
-		 io_sq->next_to_comp);
+	dev_dbg(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+		"[%s][QID#%d] Updating SQ head to: %d\n", __func__, io_sq->qid,
+		io_sq->next_to_comp);
 
 	/* Get rx flags from the last pkt */
-	ena_com_rx_set_flags(ena_rx_ctx, cdesc);
+	ena_com_rx_set_flags(io_cq, ena_rx_ctx, cdesc);
 
 	ena_rx_ctx->descs = nb_hw_desc;
 	return 0;
@@ -585,6 +620,10 @@ int ena_com_add_single_rx_desc(struct ena_com_io_sq *io_sq,
 
 	desc->req_id = req_id;
 
+	dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+		"[%s] Adding single RX desc, Queue: %u, req_id: %u\n", __func__,
+		io_sq->qid, req_id);
+
 	desc->buff_addr_lo = (u32)ena_buf->paddr;
 	desc->buff_addr_hi =
 		((ena_buf->paddr & GENMASK_ULL(io_sq->dma_addr_bits - 1, 32)) >> 32);
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 74c9a72ec3ef..8fc67592b637 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -140,8 +140,9 @@ static inline bool ena_com_is_doorbell_needed(struct ena_com_io_sq *io_sq,
 						   llq_info->descs_per_entry);
 	}
 
-	pr_debug("queue: %d num_descs: %d num_entries_needed: %d\n", io_sq->qid,
-		 num_descs, num_entries_needed);
+	dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+		"queue: %d num_descs: %d num_entries_needed: %d\n", io_sq->qid,
+		num_descs, num_entries_needed);
 
 	return num_entries_needed > io_sq->entries_in_tx_burst_left;
 }
@@ -151,14 +152,16 @@ static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
 	u16 max_entries_in_tx_burst = io_sq->llq_info.max_entries_in_tx_burst;
 	u16 tail = io_sq->tail;
 
-	pr_debug("write submission queue doorbell for queue: %d tail: %d\n",
-		 io_sq->qid, tail);
+	dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+		"write submission queue doorbell for queue: %d tail: %d\n",
+		io_sq->qid, tail);
 
 	writel(tail, io_sq->db_addr);
 
 	if (is_llq_max_tx_burst_exists(io_sq)) {
-		pr_debug("reset available entries in tx burst for queue %d to %d\n",
-			 io_sq->qid, max_entries_in_tx_burst);
+		dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
+			"reset available entries in tx burst for queue %d to %d\n",
+			io_sq->qid, max_entries_in_tx_burst);
 		io_sq->entries_in_tx_burst_left = max_entries_in_tx_burst;
 	}
 
@@ -176,8 +179,9 @@ static inline int ena_com_update_dev_comp_head(struct ena_com_io_cq *io_cq)
 		need_update = unreported_comp > (io_cq->q_depth / ENA_COMP_HEAD_THRESH);
 
 		if (unlikely(need_update)) {
-			pr_debug("Write completion queue doorbell for queue %d: head: %d\n",
-				 io_cq->qid, head);
+			dev_dbg(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+				"Write completion queue doorbell for queue %d: head: %d\n",
+				io_cq->qid, head);
 			writel(head, io_cq->cq_head_db_reg);
 			io_cq->last_head_update = head;
 		}
@@ -240,7 +244,8 @@ static inline int ena_com_tx_comp_req_id_get(struct ena_com_io_cq *io_cq,
 
 	*req_id = READ_ONCE(cdesc->req_id);
 	if (unlikely(*req_id >= io_cq->q_depth)) {
-		pr_err("Invalid req id %d\n", cdesc->req_id);
+		dev_err(ena_com_io_cq_to_ena_dev(io_cq)->dmadev,
+			"Invalid req id %d\n", cdesc->req_id);
 		return -EINVAL;
 	}
 
-- 
2.17.1

