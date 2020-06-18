Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C11FEAC4
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFRFOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:25338 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgFRFOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:01 -0400
IronPort-SDR: ntVWa2YVaM7YjR81d76Xu8eDkwdg+0EwzkKm0xtrDf8WgwRO9b6C9Yfdneh+y0ZKUgmF9MZYPS
 8URh2h5aWiDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378050"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:51 -0700
IronPort-SDR: 3iLwSwbDuD9ch0flrSJKBSEIjhnTSMIRMo2NnGL2TFZ9NI40Q6DjGeKcy2arqZeyoG5DaLR2ES
 63lG2eAkvnUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495593"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] iecm: Implement mailbox functionality
Date:   Wed, 17 Jun 2020 22:13:35 -0700
Message-Id: <20200618051344.516587-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
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
---
 .../net/ethernet/intel/iecm/iecm_controlq.c   | 497 +++++++++++++++++-
 .../ethernet/intel/iecm/iecm_controlq_setup.c | 105 +++-
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  71 ++-
 drivers/net/ethernet/intel/iecm/iecm_osdep.c  |  17 +-
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 427 ++++++++++++++-
 5 files changed, 1088 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq.c b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
index 390c499d9eb5..1232a9374046 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_controlq.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
@@ -14,7 +14,15 @@ static void
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
@@ -30,7 +38,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
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
+	wr32(hw, cq->reg.bal, IECM_LO_DWORD(cq->desc_ring.pa));
+	wr32(hw, cq->reg.bah, IECM_HI_DWORD(cq->desc_ring.pa));
+	wr32(hw, cq->reg.len, (cq->ring_size | cq->reg.len_ena_mask));
+
+	/* Check one register to verify that config was applied */
+	reg = rd32(hw, cq->reg.bah);
+	if (reg != IECM_HI_DWORD(cq->desc_ring.pa))
+		return IECM_ERR_CTLQ_ERROR;
+
+	return 0;
 }
 
 /**
@@ -42,7 +75,30 @@ static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
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
+			cpu_to_le32(IECM_HI_DWORD(bi->pa));
+		desc->params.indirect.addr_low =
+			cpu_to_le32(IECM_LO_DWORD(bi->pa));
+		desc->params.indirect.param0 = 0;
+		desc->params.indirect.param1 = 0;
+	}
 }
 
 /**
@@ -54,7 +110,20 @@ static void iecm_ctlq_init_rxq_bufs(struct iecm_ctlq_info *cq)
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
@@ -73,7 +142,74 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
 			       struct iecm_ctlq_create_info *qinfo,
 			       struct iecm_ctlq_info **cq)
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
+	*cq = kcalloc(1, sizeof(struct iecm_ctlq_info), GFP_KERNEL);
+	if (!(*cq))
+		return IECM_ERR_NO_MEMORY;
+
+	(*cq)->cq_type = qinfo->type;
+	(*cq)->q_id = qinfo->id;
+	(*cq)->buf_size = qinfo->buf_size;
+	(*cq)->ring_size = qinfo->len;
+
+	(*cq)->next_to_use = 0;
+	(*cq)->next_to_clean = 0;
+	(*cq)->next_to_post = (*cq)->ring_size - 1;
+
+	switch (qinfo->type) {
+	case IECM_CTLQ_TYPE_MAILBOX_RX:
+		is_rxq = true;
+		fallthrough;
+	case IECM_CTLQ_TYPE_MAILBOX_TX:
+		status = iecm_ctlq_alloc_ring_res(hw, *cq);
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
+		iecm_ctlq_init_rxq_bufs(*cq);
+	} else {
+		/* Allocate the array of msg pointers for TX queues */
+		(*cq)->bi.tx_msg = kcalloc(qinfo->len,
+					   sizeof(struct iecm_ctlq_msg *),
+					   GFP_KERNEL);
+		if (!(*cq)->bi.tx_msg) {
+			status = IECM_ERR_NO_MEMORY;
+			goto init_dealloc_q_mem;
+		}
+	}
+
+	iecm_ctlq_setup_regs(*cq, qinfo);
+
+	status = iecm_ctlq_init_regs(hw, *cq, is_rxq);
+	if (status)
+		goto init_dealloc_q_mem;
+
+	mutex_init(&(*cq)->cq_lock);
+
+	list_add(&(*cq)->cq_list, &hw->cq_list_head);
+
+	return status;
+
+init_dealloc_q_mem:
+	/* free ring buffers and the ring itself */
+	iecm_ctlq_dealloc_ring_res(hw, *cq);
+init_free_q:
+	kfree(*cq);
+
+	return status;
 }
 
 /**
@@ -84,7 +220,9 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
 void iecm_ctlq_remove(struct iecm_hw *hw,
 		      struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	list_del(&cq->cq_list);
+	iecm_ctlq_shutdown(hw, cq);
+	kfree(cq);
 }
 
 /**
@@ -101,7 +239,27 @@ void iecm_ctlq_remove(struct iecm_hw *hw,
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
@@ -110,7 +268,13 @@ enum iecm_status iecm_ctlq_init(struct iecm_hw *hw, u8 num_q,
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
@@ -130,7 +294,79 @@ enum iecm_status iecm_ctlq_send(struct iecm_hw *hw,
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
+		desc->pfid_vfid = msg->func_id;
+
+		msg_cookie = *(u64 *)&msg->cookie;
+		desc->cookie_high =
+			cpu_to_le32(IECM_HI_DWORD(msg_cookie));
+		desc->cookie_low =
+			cpu_to_le32(IECM_LO_DWORD(msg_cookie));
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
+				cpu_to_le32(IECM_HI_DWORD(buff->pa));
+			desc->params.indirect.addr_low =
+				cpu_to_le32(IECM_LO_DWORD(buff->pa));
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
+	iecm_wmb();
+
+	wr32(hw, cq->reg.tail, cq->next_to_use);
+
+sq_send_command_out:
+	mutex_unlock(&cq->cq_lock);
+
+	return status;
 }
 
 /**
@@ -154,7 +390,58 @@ enum iecm_status iecm_ctlq_clean_sq(struct iecm_hw *hw,
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
+	else if (*clean_count > cq->ring_size)
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
@@ -177,7 +464,111 @@ enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
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
+		if (!cq->bi.rx_buff[ntp]) {
+			if (!buffs_avail) {
+				/* If the caller hasn't given us any buffers or
+				 * there are none left, search the ring itself
+				 * for an available buffer to move to this
+				 * entry starting at the next entry in the ring
+				 */
+				tbp = ntp + 1;
+
+				/* Wrap ring if necessary */
+				if (tbp >= cq->ring_size)
+					tbp = 0;
+
+				while (tbp != cq->next_to_clean) {
+					if (cq->bi.rx_buff[tbp]) {
+						cq->bi.rx_buff[ntp] =
+							cq->bi.rx_buff[tbp];
+						cq->bi.rx_buff[tbp] = NULL;
+
+						/* Found a buffer, no need to
+						 * search anymore
+						 */
+						break;
+					}
+
+					/* Wrap ring if necessary */
+					tbp++;
+					if (tbp >= cq->ring_size)
+						tbp = 0;
+				}
+
+				if (tbp == cq->next_to_clean)
+					goto post_buffs_out;
+			} else {
+				/* Give back pointer to DMA buffer */
+				cq->bi.rx_buff[ntp] = buffs[i];
+				i++;
+
+				if (i >= *buff_count)
+					buffs_avail = false;
+			}
+		}
+
+		desc->flags =
+			cpu_to_le16(IECM_CTLQ_FLAG_BUF | IECM_CTLQ_FLAG_RD);
+
+		/* Post buffers to descriptor */
+		desc->datalen = cpu_to_le16(cq->bi.rx_buff[ntp]->size);
+		desc->params.indirect.addr_high =
+			cpu_to_le32(IECM_HI_DWORD(cq->bi.rx_buff[ntp]->pa));
+		desc->params.indirect.addr_low =
+			cpu_to_le32(IECM_LO_DWORD(cq->bi.rx_buff[ntp]->pa));
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
@@ -196,5 +587,87 @@ enum iecm_status iecm_ctlq_recv(struct iecm_hw *hw,
 				struct iecm_ctlq_info *cq,
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
index 2fd6e3d15a1a..f230f2044a48 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
@@ -13,7 +13,13 @@ static enum iecm_status
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
@@ -27,7 +33,52 @@ iecm_ctlq_alloc_desc_ring(struct iecm_hw *hw,
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
@@ -41,7 +92,7 @@ static enum iecm_status iecm_ctlq_alloc_bufs(struct iecm_hw *hw,
 static void iecm_ctlq_free_desc_ring(struct iecm_hw *hw,
 				     struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	iecm_free_dma_mem(hw, &cq->desc_ring);
 }
 
 /**
@@ -54,7 +105,26 @@ static void iecm_ctlq_free_desc_ring(struct iecm_hw *hw,
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
@@ -66,7 +136,9 @@ static void iecm_ctlq_free_bufs(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
  */
 void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
 {
-	/* stub */
+	/* free ring buffers and the ring itself */
+	iecm_ctlq_free_bufs(hw, cq);
+	iecm_ctlq_free_desc_ring(hw, cq);
 }
 
 /**
@@ -80,5 +152,26 @@ void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
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
index 6023d0c727fb..3f6878704b3e 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -163,7 +163,76 @@ static int iecm_intr_req(struct iecm_adapter *adapter)
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
+	err = register_netdev(netdev);
+	if (err)
+		return err;
+
+	/* carrier off on init to avoid Tx hangs */
+	netif_carrier_off(netdev);
+
+	/* make sure transmit queues start off as stopped */
+	netif_tx_stop_all_queues(netdev);
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iecm/iecm_osdep.c b/drivers/net/ethernet/intel/iecm/iecm_osdep.c
index d0534df357d0..be5dbe1d23b2 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_osdep.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_osdep.c
@@ -6,10 +6,23 @@
 
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
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index 7bf7c02f2d6f..0fdf87d6e98f 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -11,7 +11,42 @@
  */
 void iecm_recv_event_msg(struct iecm_vport *vport)
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
@@ -25,7 +60,34 @@ void iecm_recv_event_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_mb_clean(struct iecm_adapter *adapter)
 {
-	/* stub */
+	enum iecm_status err = 0;
+	u16 num_q_msg = IECM_DFLT_MBX_Q_LEN;
+	struct iecm_ctlq_msg **q_msg;
+	struct iecm_dma_mem *dma_mem;
+	u16 i;
+
+	q_msg = kcalloc(num_q_msg, sizeof(struct iecm_ctlq_msg *), GFP_KERNEL);
+	if (!q_msg) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	err = iecm_ctlq_clean_sq(&adapter->hw, adapter->hw.asq, &num_q_msg,
+				 q_msg);
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
+	kfree(q_msg);
+
+error:
+	return err;
 }
 
 /**
@@ -43,7 +105,56 @@ enum iecm_status
 iecm_send_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
 		 u16 msg_size, u8 *msg)
 {
-	/* stub */
+	enum iecm_status err = 0;
+	struct iecm_ctlq_msg *ctlq_msg;
+	struct iecm_dma_mem *dma_mem;
+
+	err = iecm_mb_clean(adapter);
+	if (err)
+		goto err;
+
+	ctlq_msg = kzalloc(sizeof(struct iecm_ctlq_msg), GFP_KERNEL);
+	if (!ctlq_msg) {
+		err = IECM_ERR_NO_MEMORY;
+		goto err;
+	}
+
+	dma_mem = kzalloc(sizeof(struct iecm_dma_mem), GFP_KERNEL);
+	if (!dma_mem) {
+		err = IECM_ERR_NO_MEMORY;
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
+		err = IECM_ERR_NO_MEMORY;
+		goto dma_alloc_error;
+	}
+	memcpy(dma_mem->va, msg, msg_size);
+	ctlq_msg->ctx.indirect.payload = dma_mem;
+
+	err = iecm_ctlq_send(&adapter->hw, adapter->hw.asq, 1, ctlq_msg);
+	if (err)
+		goto send_error;
+
+	return err;
+send_error:
+	dmam_free_coherent(&adapter->pdev->dev, dma_mem->size, dma_mem->va,
+			   dma_mem->pa);
+dma_alloc_error:
+	kfree(dma_mem);
+dma_mem_error:
+	kfree(ctlq_msg);
+err:
+	return err;
 }
 EXPORT_SYMBOL(iecm_send_mb_msg);
 
@@ -60,7 +171,265 @@ enum iecm_status
 iecm_recv_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
 		 void *msg, int msg_size)
 {
-	/* stub */
+	enum iecm_status status = 0;
+	struct iecm_ctlq_msg ctlq_msg;
+	struct iecm_dma_mem *dma_mem;
+	struct iecm_vport *vport;
+	bool work_done = false;
+	int payload_size = 0;
+	int num_retry = 10;
+	u16 num_q_msg;
+
+	vport = adapter->vports[0];
+	while (1) {
+		/* Try to get one message */
+		num_q_msg = 1;
+		dma_mem = NULL;
+		status = iecm_ctlq_recv(&adapter->hw, adapter->hw.arq,
+					&num_q_msg, &ctlq_msg);
+		/* If no message then decide if we have to retry based on
+		 * opcode
+		 */
+		if (status || !num_q_msg) {
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
+				status =
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
+		status = iecm_ctlq_post_rx_buffs(&adapter->hw, adapter->hw.arq,
+						 &num_q_msg,
+						 &dma_mem);
+		/* If post failed clear the only buffer we supplied */
+		if (status && dma_mem)
+			dmam_free_coherent(&adapter->pdev->dev, dma_mem->size,
+					   dma_mem->va, dma_mem->pa);
+		/* Applies only if we are looking for a specific opcode */
+		if (work_done)
+			break;
+	}
+
+	return status;
 }
 EXPORT_SYMBOL(iecm_recv_mb_msg);
 
@@ -158,7 +527,27 @@ iecm_wait_for_event(struct iecm_adapter *adapter,
 		    enum iecm_vport_vc_state state,
 		    enum iecm_vport_vc_state err_check)
 {
-	/* stub */
+	enum iecm_status status;
+	int event;
+
+	event = wait_event_timeout(adapter->vchnl_wq,
+				   test_and_clear_bit(state, adapter->vc_state),
+				   msecs_to_jiffies(500));
+	if (event) {
+		if (test_and_clear_bit(err_check, adapter->vc_state)) {
+			dev_err(&adapter->pdev->dev,
+				"VC response error %d", err_check);
+			status = IECM_ERR_CFG;
+		} else {
+			status = 0;
+		}
+	} else {
+		/* Timeout occurred */
+		status = IECM_ERR_NOT_READY;
+		dev_err(&adapter->pdev->dev, "VC timeout, state = %u", state);
+	}
+
+	return status;
 }
 EXPORT_SYMBOL(iecm_wait_for_event);
 
@@ -398,7 +787,14 @@ enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
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
@@ -407,7 +803,8 @@ static struct iecm_ctlq_info *iecm_find_ctlq(struct iecm_hw *hw,
  */
 void iecm_deinit_dflt_mbx(struct iecm_adapter *adapter)
 {
-	/* stub */
+	cancel_delayed_work_sync(&adapter->init_task);
+	iecm_ctlq_deinit(&adapter->hw);
 }
 
 /**
@@ -469,7 +866,21 @@ enum iecm_status iecm_init_dflt_mbx(struct iecm_adapter *adapter)
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

