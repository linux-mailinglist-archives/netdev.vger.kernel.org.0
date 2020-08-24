Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5666B25067F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgHXRdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:33:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:29863 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgHXRdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:33:38 -0400
IronPort-SDR: F82myn6DJfXO3vFP/Z4uzJ/lOlbNnNMfFKjioP90K6Md0dn5AJnCG0Mn6yMqRReycdW6v8grDs
 4PHT4LfihrMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="157008566"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="157008566"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:23 -0700
IronPort-SDR: N2nNmzxNppKiSbdzCvn2GrRY4O6rEfQivNl+JAM8MMMRGZAjvwpvfjX7EQlrzOCnuF4GuxrwPB
 2V8ygbdPYsKQ==
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="336245347"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [net-next v5 06/15] iecm: Implement mailbox functionality
Date:   Mon, 24 Aug 2020 10:32:57 -0700
Message-Id: <20200824173306.3178343-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Implement mailbox setup, take down, and commands.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iecm/iecm_controlq.c   | 498 +++++++++++++++++-
 .../ethernet/intel/iecm/iecm_controlq_setup.c | 105 +++-
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  94 +++-
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 414 ++++++++++++++-
 4 files changed, 1082 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq.c b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
index 585392e4d72a..05451d96ee10 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_controlq.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
@@ -12,7 +12,15 @@ static void
 iecm_ctlq_setup_regs(struct iecm_ctlq_info *cq,
 		     struct iecm_ctlq_create_info *q_create_info)
 {
-	/* stub */
+	/* set head and tail registers in our local struct */
+	cq->reg.head = q_create_info->reg.head;
+	cq->reg.tail = q_create_info->reg.tail;
+	cq->reg.len = q_create_info->reg.len;
+	cq->reg.bah = q_create_info->reg.bah;
+	cq->reg.bal = q_create_info->reg.bal;
+	cq->reg.len_mask = q_create_info->reg.len_mask;
+	cq->reg.len_ena_mask = q_create_info->reg.len_ena_mask;
+	cq->reg.head_mask = q_create_info->reg.head_mask;
 }
 
 /**
@@ -28,7 +36,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
 					    struct iecm_ctlq_info *cq,
 					    bool is_rxq)
 {
-	/* stub */
+	u32 reg = 0;
+
+	if (is_rxq)
+		/* Update tail to post pre-allocated buffers for Rx queues */
+		wr32(hw, cq->reg.tail, (u32)(cq->ring_size - 1));
+	else
+		wr32(hw, cq->reg.tail, 0);
+
+	/* For non-Mailbox control queues only TAIL need to be set */
+	if (cq->q_id != -1)
+		return 0;
+
+	/* Clear Head for both send or receive */
+	wr32(hw, cq->reg.head, 0);
+
+	/* set starting point */
+	wr32(hw, cq->reg.bal, lower_32_bits(cq->desc_ring.pa));
+	wr32(hw, cq->reg.bah, upper_32_bits(cq->desc_ring.pa));
+	wr32(hw, cq->reg.len, (cq->ring_size | cq->reg.len_ena_mask));
+
+	/* Check one register to verify that config was applied */
+	reg = rd32(hw, cq->reg.bah);
+	if (reg != upper_32_bits(cq->desc_ring.pa))
+		return IECM_ERR_CTLQ_ERROR;
+
+	return 0;
 }
 
 /**
@@ -40,7 +73,30 @@ static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
  */
 static void iecm_ctlq_init_rxq_bufs(struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	int i = 0;
+
+	for (i = 0; i < cq->ring_size; i++) {
+		struct iecm_ctlq_desc *desc = IECM_CTLQ_DESC(cq, i);
+		struct iecm_dma_mem *bi = cq->bi.rx_buff[i];
+
+		/* No buffer to post to descriptor, continue */
+		if (!bi)
+			continue;
+
+		desc->flags =
+			cpu_to_le16(IECM_CTLQ_FLAG_BUF | IECM_CTLQ_FLAG_RD);
+		desc->opcode = 0;
+		desc->datalen = (__le16)cpu_to_le16(bi->size);
+		desc->ret_val = 0;
+		desc->cookie_high = 0;
+		desc->cookie_low = 0;
+		desc->params.indirect.addr_high =
+			cpu_to_le32(upper_32_bits(bi->pa));
+		desc->params.indirect.addr_low =
+			cpu_to_le32(lower_32_bits(bi->pa));
+		desc->params.indirect.param0 = 0;
+		desc->params.indirect.param1 = 0;
+	}
 }
 
 /**
@@ -52,7 +108,20 @@ static void iecm_ctlq_init_rxq_bufs(struct iecm_ctlq_info *cq)
  */
 static void iecm_ctlq_shutdown(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	mutex_lock(&cq->cq_lock);
+
+	if (!cq->ring_size)
+		goto shutdown_sq_out;
+
+	/* free ring buffers and the ring itself */
+	iecm_ctlq_dealloc_ring_res(hw, cq);
+
+	/* Set ring_size to 0 to indicate uninitialized queue */
+	cq->ring_size = 0;
+
+shutdown_sq_out:
+	mutex_unlock(&cq->cq_lock);
+	mutex_destroy(&cq->cq_lock);
 }
 
 /**
@@ -71,7 +140,74 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
 			       struct iecm_ctlq_create_info *qinfo,
 			       struct iecm_ctlq_info **cq_out)
 {
-	/* stub */
+	enum iecm_status status = 0;
+	bool is_rxq = false;
+
+	if (!qinfo->len || !qinfo->buf_size ||
+	    qinfo->len > IECM_CTLQ_MAX_RING_SIZE ||
+	    qinfo->buf_size > IECM_CTLQ_MAX_BUF_LEN)
+		return IECM_ERR_CFG;
+
+	*cq_out = kcalloc(1, sizeof(struct iecm_ctlq_info), GFP_KERNEL);
+	if (!(*cq_out))
+		return IECM_ERR_NO_MEMORY;
+
+	(*cq_out)->cq_type = qinfo->type;
+	(*cq_out)->q_id = qinfo->id;
+	(*cq_out)->buf_size = qinfo->buf_size;
+	(*cq_out)->ring_size = qinfo->len;
+
+	(*cq_out)->next_to_use = 0;
+	(*cq_out)->next_to_clean = 0;
+	(*cq_out)->next_to_post = (*cq_out)->ring_size - 1;
+
+	switch (qinfo->type) {
+	case IECM_CTLQ_TYPE_MAILBOX_RX:
+		is_rxq = true;
+		fallthrough;
+	case IECM_CTLQ_TYPE_MAILBOX_TX:
+		status = iecm_ctlq_alloc_ring_res(hw, *cq_out);
+		break;
+	default:
+		status = IECM_ERR_PARAM;
+		break;
+	}
+
+	if (status)
+		goto init_free_q;
+
+	if (is_rxq) {
+		iecm_ctlq_init_rxq_bufs(*cq_out);
+	} else {
+		/* Allocate the array of msg pointers for TX queues */
+		(*cq_out)->bi.tx_msg = kcalloc(qinfo->len,
+					       sizeof(struct iecm_ctlq_msg *),
+					       GFP_KERNEL);
+		if (!(*cq_out)->bi.tx_msg) {
+			status = IECM_ERR_NO_MEMORY;
+			goto init_dealloc_q_mem;
+		}
+	}
+
+	iecm_ctlq_setup_regs(*cq_out, qinfo);
+
+	status = iecm_ctlq_init_regs(hw, *cq_out, is_rxq);
+	if (status)
+		goto init_dealloc_q_mem;
+
+	mutex_init(&(*cq_out)->cq_lock);
+
+	list_add(&(*cq_out)->cq_list, &hw->cq_list_head);
+
+	return status;
+
+init_dealloc_q_mem:
+	/* free ring buffers and the ring itself */
+	iecm_ctlq_dealloc_ring_res(hw, *cq_out);
+init_free_q:
+	kfree(*cq_out);
+
+	return status;
 }
 
 /**
@@ -82,7 +218,9 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
 void iecm_ctlq_remove(struct iecm_hw *hw,
 		      struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	list_del(&cq->cq_list);
+	iecm_ctlq_shutdown(hw, cq);
+	kfree(cq);
 }
 
 /**
@@ -99,7 +237,27 @@ void iecm_ctlq_remove(struct iecm_hw *hw,
 enum iecm_status iecm_ctlq_init(struct iecm_hw *hw, u8 num_q,
 				struct iecm_ctlq_create_info *q_info)
 {
-	/* stub */
+	struct iecm_ctlq_info *cq = NULL, *tmp = NULL;
+	enum iecm_status ret_code = 0;
+	int i = 0;
+
+	INIT_LIST_HEAD(&hw->cq_list_head);
+
+	for (i = 0; i < num_q; i++) {
+		struct iecm_ctlq_create_info *qinfo = q_info + i;
+
+		ret_code = iecm_ctlq_add(hw, qinfo, &cq);
+		if (ret_code)
+			goto init_destroy_qs;
+	}
+
+	return ret_code;
+
+init_destroy_qs:
+	list_for_each_entry_safe(cq, tmp, &hw->cq_list_head, cq_list)
+		iecm_ctlq_remove(hw, cq);
+
+	return ret_code;
 }
 
 /**
@@ -108,7 +266,13 @@ enum iecm_status iecm_ctlq_init(struct iecm_hw *hw, u8 num_q,
  */
 enum iecm_status iecm_ctlq_deinit(struct iecm_hw *hw)
 {
-	/* stub */
+	struct iecm_ctlq_info *cq = NULL, *tmp = NULL;
+	enum iecm_status ret_code = 0;
+
+	list_for_each_entry_safe(cq, tmp, &hw->cq_list_head, cq_list)
+		iecm_ctlq_remove(hw, cq);
+
+	return ret_code;
 }
 
 /**
@@ -128,7 +292,79 @@ enum iecm_status iecm_ctlq_send(struct iecm_hw *hw,
 				u16 num_q_msg,
 				struct iecm_ctlq_msg q_msg[])
 {
-	/* stub */
+	enum iecm_status status = 0;
+	struct iecm_ctlq_desc *desc;
+	int num_desc_avail = 0;
+	int i = 0;
+
+	if (!cq || !cq->ring_size)
+		return IECM_ERR_CTLQ_EMPTY;
+
+	mutex_lock(&cq->cq_lock);
+
+	/* Ensure there are enough descriptors to send all messages */
+	num_desc_avail = IECM_CTLQ_DESC_UNUSED(cq);
+	if (num_desc_avail == 0 || num_desc_avail < num_q_msg) {
+		status = IECM_ERR_CTLQ_FULL;
+		goto sq_send_command_out;
+	}
+
+	for (i = 0; i < num_q_msg; i++) {
+		struct iecm_ctlq_msg *msg = &q_msg[i];
+		u64 msg_cookie;
+
+		desc = IECM_CTLQ_DESC(cq, cq->next_to_use);
+
+		desc->opcode = cpu_to_le16(msg->opcode);
+		desc->pfid_vfid = cpu_to_le16(msg->func_id);
+
+		msg_cookie = *(u64 *)&msg->cookie;
+		desc->cookie_high =
+			cpu_to_le32(upper_32_bits(msg_cookie));
+		desc->cookie_low =
+			cpu_to_le32(lower_32_bits(msg_cookie));
+
+		if (msg->data_len) {
+			struct iecm_dma_mem *buff = msg->ctx.indirect.payload;
+
+			desc->datalen = cpu_to_le16(msg->data_len);
+			desc->flags |= cpu_to_le16(IECM_CTLQ_FLAG_BUF);
+			desc->flags |= cpu_to_le16(IECM_CTLQ_FLAG_RD);
+
+			/* Update the address values in the desc with the pa
+			 * value for respective buffer
+			 */
+			desc->params.indirect.addr_high =
+				cpu_to_le32(upper_32_bits(buff->pa));
+			desc->params.indirect.addr_low =
+				cpu_to_le32(lower_32_bits(buff->pa));
+
+			memcpy(&desc->params, msg->ctx.indirect.context,
+			       IECM_INDIRECT_CTX_SIZE);
+		} else {
+			memcpy(&desc->params, msg->ctx.direct,
+			       IECM_DIRECT_CTX_SIZE);
+		}
+
+		/* Store buffer info */
+		cq->bi.tx_msg[cq->next_to_use] = msg;
+
+		(cq->next_to_use)++;
+		if (cq->next_to_use == cq->ring_size)
+			cq->next_to_use = 0;
+	}
+
+	/* Force memory write to complete before letting hardware
+	 * know that there are new descriptors to fetch.
+	 */
+	dma_wmb();
+
+	wr32(hw, cq->reg.tail, cq->next_to_use);
+
+sq_send_command_out:
+	mutex_unlock(&cq->cq_lock);
+
+	return status;
 }
 
 /**
@@ -150,7 +386,58 @@ enum iecm_status iecm_ctlq_clean_sq(struct iecm_ctlq_info *cq,
 				    u16 *clean_count,
 				    struct iecm_ctlq_msg *msg_status[])
 {
-	/* stub */
+	enum iecm_status ret = 0;
+	struct iecm_ctlq_desc *desc;
+	u16 i = 0, num_to_clean;
+	u16 ntc, desc_err;
+
+	if (!cq || !cq->ring_size)
+		return IECM_ERR_CTLQ_EMPTY;
+
+	if (*clean_count == 0)
+		return 0;
+	if (*clean_count > cq->ring_size)
+		return IECM_ERR_PARAM;
+
+	mutex_lock(&cq->cq_lock);
+
+	ntc = cq->next_to_clean;
+
+	num_to_clean = *clean_count;
+
+	for (i = 0; i < num_to_clean; i++) {
+		/* Fetch next descriptor and check if marked as done */
+		desc = IECM_CTLQ_DESC(cq, ntc);
+		if (!(le16_to_cpu(desc->flags) & IECM_CTLQ_FLAG_DD))
+			break;
+
+		desc_err = le16_to_cpu(desc->ret_val);
+		if (desc_err) {
+			/* strip off FW internal code */
+			desc_err &= 0xff;
+		}
+
+		msg_status[i] = cq->bi.tx_msg[ntc];
+		msg_status[i]->status = desc_err;
+
+		cq->bi.tx_msg[ntc] = NULL;
+
+		/* Zero out any stale data */
+		memset(desc, 0, sizeof(*desc));
+
+		ntc++;
+		if (ntc == cq->ring_size)
+			ntc = 0;
+	}
+
+	cq->next_to_clean = ntc;
+
+	mutex_unlock(&cq->cq_lock);
+
+	/* Return number of descriptors actually cleaned */
+	*clean_count = i;
+
+	return ret;
 }
 
 /**
@@ -173,7 +460,112 @@ enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
 					 u16 *buff_count,
 					 struct iecm_dma_mem **buffs)
 {
-	/* stub */
+	enum iecm_status status = 0;
+	struct iecm_ctlq_desc *desc;
+	u16 ntp = cq->next_to_post;
+	bool buffs_avail = false;
+	u16 tbp = ntp + 1;
+	int i = 0;
+
+	if (*buff_count > cq->ring_size)
+		return IECM_ERR_PARAM;
+
+	if (*buff_count > 0)
+		buffs_avail = true;
+
+	mutex_lock(&cq->cq_lock);
+
+	if (tbp >= cq->ring_size)
+		tbp = 0;
+
+	if (tbp == cq->next_to_clean)
+		/* Nothing to do */
+		goto post_buffs_out;
+
+	/* Post buffers for as many as provided or up until the last one used */
+	while (ntp != cq->next_to_clean) {
+		desc = IECM_CTLQ_DESC(cq, ntp);
+
+		if (cq->bi.rx_buff[ntp])
+			goto fill_desc;
+		if (!buffs_avail) {
+			/* If the caller hasn't given us any buffers or
+			 * there are none left, search the ring itself
+			 * for an available buffer to move to this
+			 * entry starting at the next entry in the ring
+			 */
+			tbp = ntp + 1;
+
+			/* Wrap ring if necessary */
+			if (tbp >= cq->ring_size)
+				tbp = 0;
+
+			while (tbp != cq->next_to_clean) {
+				if (cq->bi.rx_buff[tbp]) {
+					cq->bi.rx_buff[ntp] =
+						cq->bi.rx_buff[tbp];
+					cq->bi.rx_buff[tbp] = NULL;
+
+					/* Found a buffer, no need to
+					 * search anymore
+					 */
+					break;
+				}
+
+				/* Wrap ring if necessary */
+				tbp++;
+				if (tbp >= cq->ring_size)
+					tbp = 0;
+			}
+
+			if (tbp == cq->next_to_clean)
+				goto post_buffs_out;
+		} else {
+			/* Give back pointer to DMA buffer */
+			cq->bi.rx_buff[ntp] = buffs[i];
+			i++;
+
+			if (i >= *buff_count)
+				buffs_avail = false;
+		}
+
+fill_desc:
+		desc->flags =
+			cpu_to_le16(IECM_CTLQ_FLAG_BUF | IECM_CTLQ_FLAG_RD);
+
+		/* Post buffers to descriptor */
+		desc->datalen = cpu_to_le16(cq->bi.rx_buff[ntp]->size);
+		desc->params.indirect.addr_high =
+			cpu_to_le32(upper_32_bits(cq->bi.rx_buff[ntp]->pa));
+		desc->params.indirect.addr_low =
+			cpu_to_le32(lower_32_bits(cq->bi.rx_buff[ntp]->pa));
+
+		ntp++;
+		if (ntp == cq->ring_size)
+			ntp = 0;
+	}
+
+post_buffs_out:
+	/* Only update tail if buffers were actually posted */
+	if (cq->next_to_post != ntp) {
+		if (ntp)
+			/* Update next_to_post to ntp - 1 since current ntp
+			 * will not have a buffer
+			 */
+			cq->next_to_post = ntp - 1;
+		else
+			/* Wrap to end of end ring since current ntp is 0 */
+			cq->next_to_post = cq->ring_size - 1;
+
+		wr32(hw, cq->reg.tail, cq->next_to_post);
+	}
+
+	mutex_unlock(&cq->cq_lock);
+
+	/* return the number of buffers that were not posted */
+	*buff_count = *buff_count - i;
+
+	return status;
 }
 
 /**
@@ -190,5 +582,87 @@ enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
 enum iecm_status iecm_ctlq_recv(struct iecm_ctlq_info *cq,
 				u16 *num_q_msg, struct iecm_ctlq_msg *q_msg)
 {
-	/* stub */
+	u16 num_to_clean, ntc, ret_val, flags;
+	enum iecm_status ret_code = 0;
+	struct iecm_ctlq_desc *desc;
+	u16 i = 0;
+
+	if (!cq || !cq->ring_size)
+		return IECM_ERR_CTLQ_EMPTY;
+
+	if (*num_q_msg == 0)
+		return 0;
+	else if (*num_q_msg > cq->ring_size)
+		return IECM_ERR_PARAM;
+
+	/* take the lock before we start messing with the ring */
+	mutex_lock(&cq->cq_lock);
+
+	ntc = cq->next_to_clean;
+
+	num_to_clean = *num_q_msg;
+
+	for (i = 0; i < num_to_clean; i++) {
+		u64 msg_cookie;
+
+		/* Fetch next descriptor and check if marked as done */
+		desc = IECM_CTLQ_DESC(cq, ntc);
+		flags = le16_to_cpu(desc->flags);
+
+		if (!(flags & IECM_CTLQ_FLAG_DD))
+			break;
+
+		ret_val = le16_to_cpu(desc->ret_val);
+
+		q_msg[i].vmvf_type = (flags &
+				      (IECM_CTLQ_FLAG_FTYPE_VM |
+				       IECM_CTLQ_FLAG_FTYPE_PF)) >>
+				      IECM_CTLQ_FLAG_FTYPE_S;
+
+		if (flags & IECM_CTLQ_FLAG_ERR)
+			ret_code = IECM_ERR_CTLQ_ERROR;
+
+		msg_cookie = (u64)le32_to_cpu(desc->cookie_high) << 32;
+		msg_cookie |= (u64)le32_to_cpu(desc->cookie_low);
+		memcpy(&q_msg[i].cookie, &msg_cookie, sizeof(u64));
+
+		q_msg[i].opcode = le16_to_cpu(desc->opcode);
+		q_msg[i].data_len = le16_to_cpu(desc->datalen);
+		q_msg[i].status = ret_val;
+
+		if (desc->datalen) {
+			memcpy(q_msg[i].ctx.indirect.context,
+			       &desc->params.indirect, IECM_INDIRECT_CTX_SIZE);
+
+			/* Assign pointer to DMA buffer to ctlq_msg array
+			 * to be given to upper layer
+			 */
+			q_msg[i].ctx.indirect.payload = cq->bi.rx_buff[ntc];
+
+			/* Zero out pointer to DMA buffer info;
+			 * will be repopulated by post buffers API
+			 */
+			cq->bi.rx_buff[ntc] = NULL;
+		} else {
+			memcpy(q_msg[i].ctx.direct, desc->params.raw,
+			       IECM_DIRECT_CTX_SIZE);
+		}
+
+		/* Zero out stale data in descriptor */
+		memset(desc, 0, sizeof(struct iecm_ctlq_desc));
+
+		ntc++;
+		if (ntc == cq->ring_size)
+			ntc = 0;
+	};
+
+	cq->next_to_clean = ntc;
+
+	mutex_unlock(&cq->cq_lock);
+
+	*num_q_msg = i;
+	if (*num_q_msg == 0)
+		ret_code = IECM_ERR_CTLQ_NO_WORK;
+
+	return ret_code;
 }
diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c b/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
index d4402be5aa7f..c6f5c935f803 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
@@ -12,7 +12,13 @@ static enum iecm_status
 iecm_ctlq_alloc_desc_ring(struct iecm_hw *hw,
 			  struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	size_t size = cq->ring_size * sizeof(struct iecm_ctlq_desc);
+
+	cq->desc_ring.va = iecm_alloc_dma_mem(hw, &cq->desc_ring, size);
+	if (!cq->desc_ring.va)
+		return IECM_ERR_NO_MEMORY;
+
+	return 0;
 }
 
 /**
@@ -26,7 +32,52 @@ iecm_ctlq_alloc_desc_ring(struct iecm_hw *hw,
 static enum iecm_status iecm_ctlq_alloc_bufs(struct iecm_hw *hw,
 					     struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	int i = 0;
+
+	/* Do not allocate DMA buffers for transmit queues */
+	if (cq->cq_type == IECM_CTLQ_TYPE_MAILBOX_TX)
+		return 0;
+
+	/* We'll be allocating the buffer info memory first, then we can
+	 * allocate the mapped buffers for the event processing
+	 */
+	cq->bi.rx_buff = kcalloc(cq->ring_size, sizeof(struct iecm_dma_mem *),
+				 GFP_KERNEL);
+	if (!cq->bi.rx_buff)
+		return IECM_ERR_NO_MEMORY;
+
+	/* allocate the mapped buffers (except for the last one) */
+	for (i = 0; i < cq->ring_size - 1; i++) {
+		struct iecm_dma_mem *bi;
+		int num = 1; /* number of iecm_dma_mem to be allocated */
+
+		cq->bi.rx_buff[i] = kcalloc(num, sizeof(struct iecm_dma_mem),
+					    GFP_KERNEL);
+		if (!cq->bi.rx_buff[i])
+			goto unwind_alloc_cq_bufs;
+
+		bi = cq->bi.rx_buff[i];
+
+		bi->va = iecm_alloc_dma_mem(hw, bi, cq->buf_size);
+		if (!bi->va) {
+			/* unwind will not free the failed entry */
+			kfree(cq->bi.rx_buff[i]);
+			goto unwind_alloc_cq_bufs;
+		}
+	}
+
+	return 0;
+
+unwind_alloc_cq_bufs:
+	/* don't try to free the one that failed... */
+	i--;
+	for (; i >= 0; i--) {
+		iecm_free_dma_mem(hw, cq->bi.rx_buff[i]);
+		kfree(cq->bi.rx_buff[i]);
+	}
+	kfree(cq->bi.rx_buff);
+
+	return IECM_ERR_NO_MEMORY;
 }
 
 /**
@@ -40,7 +91,7 @@ static enum iecm_status iecm_ctlq_alloc_bufs(struct iecm_hw *hw,
 static void iecm_ctlq_free_desc_ring(struct iecm_hw *hw,
 				     struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	iecm_free_dma_mem(hw, &cq->desc_ring);
 }
 
 /**
@@ -53,7 +104,26 @@ static void iecm_ctlq_free_desc_ring(struct iecm_hw *hw,
  */
 static void iecm_ctlq_free_bufs(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	void *bi;
+
+	if (cq->cq_type == IECM_CTLQ_TYPE_MAILBOX_RX) {
+		int i;
+
+		/* free DMA buffers for Rx queues*/
+		for (i = 0; i < cq->ring_size; i++) {
+			if (cq->bi.rx_buff[i]) {
+				iecm_free_dma_mem(hw, cq->bi.rx_buff[i]);
+				kfree(cq->bi.rx_buff[i]);
+			}
+		}
+
+		bi = (void *)cq->bi.rx_buff;
+	} else {
+		bi = (void *)cq->bi.tx_msg;
+	}
+
+	/* free the buffer header */
+	kfree(bi);
 }
 
 /**
@@ -65,7 +135,9 @@ static void iecm_ctlq_free_bufs(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
  */
 void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	/* free ring buffers and the ring itself */
+	iecm_ctlq_free_bufs(hw, cq);
+	iecm_ctlq_free_desc_ring(hw, cq);
 }
 
 /**
@@ -79,5 +151,26 @@ void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
 enum iecm_status iecm_ctlq_alloc_ring_res(struct iecm_hw *hw,
 					  struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	enum iecm_status ret_code;
+
+	/* verify input for valid configuration */
+	if (!cq->ring_size || !cq->buf_size)
+		return IECM_ERR_CFG;
+
+	/* allocate the ring memory */
+	ret_code = iecm_ctlq_alloc_desc_ring(hw, cq);
+	if (ret_code)
+		return ret_code;
+
+	/* allocate buffers in the rings */
+	ret_code = iecm_ctlq_alloc_bufs(hw, cq);
+	if (ret_code)
+		goto iecm_init_cq_free_ring;
+
+	/* success! */
+	return 0;
+
+iecm_init_cq_free_ring:
+	iecm_free_dma_mem(hw, &cq->desc_ring);
+	return ret_code;
 }
diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index 23eef4a9c7ca..7151aa5fa95c 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -162,7 +162,82 @@ static int iecm_intr_req(struct iecm_adapter *adapter)
  */
 static int iecm_cfg_netdev(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	netdev_features_t dflt_features;
+	netdev_features_t offloads = 0;
+	struct iecm_netdev_priv *np;
+	struct net_device *netdev;
+	int err;
+
+	netdev = alloc_etherdev_mqs(sizeof(struct iecm_netdev_priv),
+				    IECM_MAX_Q, IECM_MAX_Q);
+	if (!netdev)
+		return -ENOMEM;
+	vport->netdev = netdev;
+	np = netdev_priv(netdev);
+	np->vport = vport;
+
+	if (!is_valid_ether_addr(vport->default_mac_addr)) {
+		eth_hw_addr_random(netdev);
+		ether_addr_copy(vport->default_mac_addr, netdev->dev_addr);
+	} else {
+		ether_addr_copy(netdev->dev_addr, vport->default_mac_addr);
+		ether_addr_copy(netdev->perm_addr, vport->default_mac_addr);
+	}
+
+	/* assign netdev_ops */
+	if (iecm_is_queue_model_split(vport->txq_model))
+		netdev->netdev_ops = &iecm_netdev_ops_splitq;
+	else
+		netdev->netdev_ops = &iecm_netdev_ops_singleq;
+
+	/* setup watchdog timeout value to be 5 second */
+	netdev->watchdog_timeo = 5 * HZ;
+
+	/* configure default MTU size */
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = vport->max_mtu;
+
+	dflt_features = NETIF_F_SG	|
+			NETIF_F_HIGHDMA	|
+			NETIF_F_RXHASH;
+
+	if (iecm_is_cap_ena(adapter, VIRTCHNL_CAP_STATELESS_OFFLOADS)) {
+		dflt_features |=
+			NETIF_F_RXCSUM |
+			NETIF_F_IP_CSUM |
+			NETIF_F_IPV6_CSUM |
+			0;
+		offloads |= NETIF_F_TSO |
+			    NETIF_F_TSO6;
+	}
+	if (iecm_is_cap_ena(adapter, VIRTCHNL_CAP_UDP_SEG_OFFLOAD))
+		offloads |= NETIF_F_GSO_UDP_L4;
+
+	netdev->features |= dflt_features;
+	netdev->hw_features |= dflt_features | offloads;
+	netdev->hw_enc_features |= dflt_features | offloads;
+
+	iecm_set_ethtool_ops(netdev);
+	SET_NETDEV_DEV(netdev, &adapter->pdev->dev);
+
+	/* carrier off on init to avoid Tx hangs */
+	netif_carrier_off(netdev);
+
+	/* make sure transmit queues start off as stopped */
+	netif_tx_stop_all_queues(netdev);
+
+	/* register last */
+	err = register_netdev(netdev);
+	if (err)
+		goto err;
+
+	return 0;
+err:
+	free_netdev(vport->netdev);
+	vport->netdev = NULL;
+
+	return err;
 }
 
 /**
@@ -796,12 +871,25 @@ static int iecm_change_mtu(struct net_device *netdev, int new_mtu)
 
 void *iecm_alloc_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem, u64 size)
 {
-	/* stub */
+	size_t sz = ALIGN(size, 4096);
+	struct iecm_adapter *pf = hw->back;
+
+	mem->va = dma_alloc_coherent(&pf->pdev->dev, sz,
+				     &mem->pa, GFP_KERNEL | __GFP_ZERO);
+	mem->size = size;
+
+	return mem->va;
 }
 
 void iecm_free_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem)
 {
-	/* stub */
+	struct iecm_adapter *pf = hw->back;
+
+	dma_free_coherent(&pf->pdev->dev, mem->size,
+			  mem->va, mem->pa);
+	mem->size = 0;
+	mem->va = NULL;
+	mem->pa = 0;
 }
 
 static const struct net_device_ops iecm_netdev_ops_splitq = {
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index 838bdeba8e61..86de33c308e3 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -39,7 +39,42 @@ struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE] = {
  */
 static void iecm_recv_event_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	enum virtchnl_link_speed link_speed;
+	struct virtchnl_pf_event *vpe;
+
+	vpe = (struct virtchnl_pf_event *)vport->adapter->vc_msg;
+
+	switch (vpe->event) {
+	case VIRTCHNL_EVENT_LINK_CHANGE:
+		link_speed = vpe->event_data.link_event.link_speed;
+		adapter->link_speed = link_speed;
+		if (adapter->link_up !=
+		    vpe->event_data.link_event.link_status) {
+			adapter->link_up =
+				vpe->event_data.link_event.link_status;
+			if (adapter->link_up) {
+				netif_tx_start_all_queues(vport->netdev);
+				netif_carrier_on(vport->netdev);
+			} else {
+				netif_tx_stop_all_queues(vport->netdev);
+				netif_carrier_off(vport->netdev);
+			}
+		}
+		break;
+	case VIRTCHNL_EVENT_RESET_IMPENDING:
+			mutex_lock(&adapter->reset_lock);
+			set_bit(__IECM_HR_CORE_RESET, adapter->flags);
+			queue_delayed_work(adapter->vc_event_wq,
+					   &adapter->vc_event_task,
+					   msecs_to_jiffies(10));
+		break;
+	default:
+		dev_err(&vport->adapter->pdev->dev,
+			"Unknown event %d from PF\n", vpe->event);
+		break;
+	}
+	mutex_unlock(&vport->adapter->vc_msg_lock);
 }
 
 /**
@@ -52,7 +87,29 @@ static void iecm_recv_event_msg(struct iecm_vport *vport)
  */
 static int iecm_mb_clean(struct iecm_adapter *adapter)
 {
-	/* stub */
+	u16 i, num_q_msg = IECM_DFLT_MBX_Q_LEN;
+	struct iecm_ctlq_msg **q_msg;
+	struct iecm_dma_mem *dma_mem;
+	int err = 0;
+
+	q_msg = kcalloc(num_q_msg, sizeof(struct iecm_ctlq_msg *), GFP_KERNEL);
+	if (!q_msg)
+		return -ENOMEM;
+
+	err = iecm_ctlq_clean_sq(adapter->hw.asq, &num_q_msg, q_msg);
+	if (err)
+		goto error;
+
+	for (i = 0; i < num_q_msg; i++) {
+		dma_mem = q_msg[i]->ctx.indirect.payload;
+		if (dma_mem)
+			dmam_free_coherent(&adapter->pdev->dev, dma_mem->size,
+					   dma_mem->va, dma_mem->pa);
+		kfree(q_msg[i]);
+	}
+error:
+	kfree(q_msg);
+	return err;
 }
 
 /**
@@ -69,7 +126,53 @@ static int iecm_mb_clean(struct iecm_adapter *adapter)
 int iecm_send_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
 		     u16 msg_size, u8 *msg)
 {
-	/* stub */
+	struct iecm_ctlq_msg *ctlq_msg;
+	struct iecm_dma_mem *dma_mem;
+	int err = 0;
+
+	err = iecm_mb_clean(adapter);
+	if (err)
+		return err;
+
+	ctlq_msg = kzalloc(sizeof(*ctlq_msg), GFP_KERNEL);
+	if (!ctlq_msg)
+		return -ENOMEM;
+
+	dma_mem = kzalloc(sizeof(*dma_mem), GFP_KERNEL);
+	if (!dma_mem) {
+		err = -ENOMEM;
+		goto dma_mem_error;
+	}
+
+	memset(ctlq_msg, 0, sizeof(struct iecm_ctlq_msg));
+	ctlq_msg->opcode = iecm_mbq_opc_send_msg_to_cp;
+	ctlq_msg->func_id = 0;
+	ctlq_msg->data_len = msg_size;
+	ctlq_msg->cookie.mbx.chnl_opcode = op;
+	ctlq_msg->cookie.mbx.chnl_retval = VIRTCHNL_STATUS_SUCCESS;
+	dma_mem->size = IECM_DFLT_MBX_BUF_SIZE;
+	dma_mem->va = dmam_alloc_coherent(&adapter->pdev->dev, dma_mem->size,
+					  &dma_mem->pa, GFP_KERNEL);
+	if (!dma_mem->va) {
+		err = -ENOMEM;
+		goto dma_alloc_error;
+	}
+	memcpy(dma_mem->va, msg, msg_size);
+	ctlq_msg->ctx.indirect.payload = dma_mem;
+
+	err = iecm_ctlq_send(&adapter->hw, adapter->hw.asq, 1, ctlq_msg);
+	if (err)
+		goto send_error;
+
+	return 0;
+send_error:
+	dmam_free_coherent(&adapter->pdev->dev, dma_mem->size, dma_mem->va,
+			   dma_mem->pa);
+dma_alloc_error:
+	kfree(dma_mem);
+dma_mem_error:
+	kfree(ctlq_msg);
+	return err;
 }
 EXPORT_SYMBOL(iecm_send_mb_msg);
 
@@ -86,7 +189,264 @@ EXPORT_SYMBOL(iecm_send_mb_msg);
 int iecm_recv_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
 		     void *msg, int msg_size)
 {
-	/* stub */
+	struct iecm_ctlq_msg ctlq_msg;
+	struct iecm_dma_mem *dma_mem;
+	struct iecm_vport *vport;
+	bool work_done = false;
+	int payload_size = 0;
+	int num_retry = 10;
+	u16 num_q_msg;
+	int err = 0;
+
+	vport = adapter->vports[0];
+	while (1) {
+		/* Try to get one message */
+		num_q_msg = 1;
+		dma_mem = NULL;
+		err = iecm_ctlq_recv(adapter->hw.arq, &num_q_msg, &ctlq_msg);
+		/* If no message then decide if we have to retry based on
+		 * opcode
+		 */
+		if (err || !num_q_msg) {
+			if (op && num_retry--) {
+				msleep(20);
+				continue;
+			} else {
+				break;
+			}
+		}
+
+		/* If we are here a message is received. Check if we are looking
+		 * for a specific message based on opcode. If it is different
+		 * ignore and post buffers
+		 */
+		if (op && ctlq_msg.cookie.mbx.chnl_opcode != op)
+			goto post_buffs;
+
+		if (ctlq_msg.data_len)
+			payload_size = ctlq_msg.ctx.indirect.payload->size;
+
+		/* All conditions are met. Either a message requested is
+		 * received or we received a message to be processed
+		 */
+		switch (ctlq_msg.cookie.mbx.chnl_opcode) {
+		case VIRTCHNL_OP_VERSION:
+		case VIRTCHNL_OP_GET_CAPS:
+		case VIRTCHNL_OP_CREATE_VPORT:
+			if (msg)
+				memcpy(msg, ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int,
+					     payload_size, msg_size));
+			work_done = true;
+			break;
+		case VIRTCHNL_OP_ENABLE_VPORT:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_ENA_VPORT_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_ENA_VPORT, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_DISABLE_VPORT:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_DIS_VPORT_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_DIS_VPORT, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_DESTROY_VPORT:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_DESTROY_VPORT_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_DESTROY_VPORT, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_CONFIG_TX_QUEUES:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_CONFIG_TXQ_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_CONFIG_TXQ, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_CONFIG_RX_QUEUES:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_CONFIG_RXQ_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_CONFIG_RXQ, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_ENABLE_QUEUES_V2:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_ENA_QUEUES_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_ENA_QUEUES, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_DISABLE_QUEUES_V2:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_DIS_QUEUES_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_DIS_QUEUES, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_ADD_QUEUES:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				set_bit(IECM_VC_ADD_QUEUES_ERR,
+					adapter->vc_state);
+			} else {
+				mutex_lock(&adapter->vc_msg_lock);
+				memcpy(adapter->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min((int)
+					   ctlq_msg.ctx.indirect.payload->size,
+					   IECM_DFLT_MBX_BUF_SIZE));
+			}
+			set_bit(IECM_VC_ADD_QUEUES, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_DEL_QUEUES:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_DEL_QUEUES_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_DEL_QUEUES, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_MAP_QUEUE_VECTOR:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_MAP_IRQ_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_MAP_IRQ, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_UNMAP_QUEUE_VECTOR:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_UNMAP_IRQ_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_UNMAP_IRQ, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_GET_STATS:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				set_bit(IECM_VC_GET_STATS_ERR,
+					adapter->vc_state);
+			} else {
+				mutex_lock(&adapter->vc_msg_lock);
+				memcpy(adapter->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int,
+					     payload_size,
+					     IECM_DFLT_MBX_BUF_SIZE));
+			}
+			set_bit(IECM_VC_GET_STATS, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_GET_RSS_HASH:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				set_bit(IECM_VC_GET_RSS_HASH_ERR,
+					adapter->vc_state);
+			} else {
+				mutex_lock(&adapter->vc_msg_lock);
+				memcpy(adapter->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int,
+					     payload_size,
+					     IECM_DFLT_MBX_BUF_SIZE));
+			}
+			set_bit(IECM_VC_GET_RSS_HASH, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_SET_RSS_HASH:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_SET_RSS_HASH_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_SET_RSS_HASH, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_GET_RSS_LUT:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				set_bit(IECM_VC_GET_RSS_LUT_ERR,
+					adapter->vc_state);
+			} else {
+				mutex_lock(&adapter->vc_msg_lock);
+				memcpy(adapter->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int,
+					     payload_size,
+					     IECM_DFLT_MBX_BUF_SIZE));
+			}
+			set_bit(IECM_VC_GET_RSS_LUT, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_SET_RSS_LUT:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_SET_RSS_LUT_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_SET_RSS_LUT, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_GET_RSS_KEY:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				set_bit(IECM_VC_GET_RSS_KEY_ERR,
+					adapter->vc_state);
+			} else {
+				mutex_lock(&adapter->vc_msg_lock);
+				memcpy(adapter->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int,
+					     payload_size,
+					     IECM_DFLT_MBX_BUF_SIZE));
+			}
+			set_bit(IECM_VC_GET_RSS_KEY, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_CONFIG_RSS_KEY:
+			if (ctlq_msg.cookie.mbx.chnl_retval)
+				set_bit(IECM_VC_CONFIG_RSS_KEY_ERR,
+					adapter->vc_state);
+			set_bit(IECM_VC_CONFIG_RSS_KEY, adapter->vc_state);
+			wake_up(&adapter->vchnl_wq);
+			break;
+		case VIRTCHNL_OP_EVENT:
+			mutex_lock(&adapter->vc_msg_lock);
+			memcpy(adapter->vc_msg,
+			       ctlq_msg.ctx.indirect.payload->va,
+			       min_t(int,
+				     payload_size,
+				     IECM_DFLT_MBX_BUF_SIZE));
+			iecm_recv_event_msg(vport);
+			break;
+		default:
+			if (adapter->dev_ops.vc_ops.recv_mbx_msg)
+				err =
+				adapter->dev_ops.vc_ops.recv_mbx_msg(adapter,
+								   msg,
+								   msg_size,
+								   &ctlq_msg,
+								   &work_done);
+			else
+				dev_warn(&adapter->pdev->dev,
+					 "Unhandled virtchnl response %d\n",
+					 ctlq_msg.cookie.mbx.chnl_opcode);
+			break;
+		} /* switch v_opcode */
+post_buffs:
+		if (ctlq_msg.data_len)
+			dma_mem = ctlq_msg.ctx.indirect.payload;
+		else
+			num_q_msg = 0;
+
+		err = iecm_ctlq_post_rx_buffs(&adapter->hw, adapter->hw.arq,
+					      &num_q_msg, &dma_mem);
+
+		/* If post failed clear the only buffer we supplied */
+		if (err && dma_mem)
+			dmam_free_coherent(&adapter->pdev->dev, dma_mem->size,
+					   dma_mem->va, dma_mem->pa);
+		/* Applies only if we are looking for a specific opcode */
+		if (work_done)
+			break;
+	}
+
+	return err;
 }
 EXPORT_SYMBOL(iecm_recv_mb_msg);
 
@@ -177,7 +537,23 @@ int iecm_wait_for_event(struct iecm_adapter *adapter,
 			enum iecm_vport_vc_state state,
 			enum iecm_vport_vc_state err_check)
 {
-	/* stub */
+	int event;
+
+	event = wait_event_timeout(adapter->vchnl_wq,
+				   test_and_clear_bit(state, adapter->vc_state),
+				   msecs_to_jiffies(500));
+	if (event) {
+		if (test_and_clear_bit(err_check, adapter->vc_state)) {
+			dev_err(&adapter->pdev->dev,
+				"VC response error %d\n", err_check);
+			return -EINVAL;
+		}
+		return 0;
+	}
+
+	/* Timeout occurred */
+	dev_err(&adapter->pdev->dev, "VC timeout, state = %u\n", state);
+	return -ETIMEDOUT;
 }
 EXPORT_SYMBOL(iecm_wait_for_event);
 
@@ -404,7 +780,14 @@ int iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
 static struct iecm_ctlq_info *iecm_find_ctlq(struct iecm_hw *hw,
 					     enum iecm_ctlq_type type, int id)
 {
-	/* stub */
+	struct iecm_ctlq_info *cq, *tmp;
+
+	list_for_each_entry_safe(cq, tmp, &hw->cq_list_head, cq_list) {
+		if (cq->q_id == id && cq->cq_type == type)
+			return cq;
+	}
+
+	return NULL;
 }
 
 /**
@@ -413,7 +796,8 @@ static struct iecm_ctlq_info *iecm_find_ctlq(struct iecm_hw *hw,
  */
 void iecm_deinit_dflt_mbx(struct iecm_adapter *adapter)
 {
-	/* stub */
+	cancel_delayed_work_sync(&adapter->init_task);
+	iecm_ctlq_deinit(&adapter->hw);
 }
 
 /**
@@ -474,7 +858,21 @@ int iecm_init_dflt_mbx(struct iecm_adapter *adapter)
  */
 int iecm_vport_params_buf_alloc(struct iecm_adapter *adapter)
 {
-	/* stub */
+	adapter->vport_params_reqd = kcalloc(IECM_MAX_NUM_VPORTS,
+					     sizeof(*adapter->vport_params_reqd),
+					     GFP_KERNEL);
+	if (!adapter->vport_params_reqd)
+		return -ENOMEM;
+
+	adapter->vport_params_recvd = kcalloc(IECM_MAX_NUM_VPORTS,
+					      sizeof(*adapter->vport_params_recvd),
+					      GFP_KERNEL);
+	if (!adapter->vport_params_recvd) {
+		kfree(adapter->vport_params_reqd);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.26.2

