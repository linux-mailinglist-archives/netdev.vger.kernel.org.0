Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FEB2C0C56
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388561AbgKWNwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:1517 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbgKWNwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:34 -0500
IronPort-SDR: XStbASFVSRavlsKS0uEm6WzUZIsP1kP+qQVYz9QMUb7sVEdTaYI/cTLTRz8evLDQtmEXMYhLBY
 dEjPZwm0xeqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981501"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981501"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:32 -0800
IronPort-SDR: Wa9qEG3JHKipt+C88bFXTBcXfeGhkn43MSNYTinJ6wLU76AcZTWpZcTPcuFbLacDxh1giMr4c8
 pKwx0EUmbf8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035642"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:30 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 14/18] net: iosm: protocol operations
Date:   Mon, 23 Nov 2020 19:21:19 +0530
Message-Id: <20201123135123.48892-15-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Update UL/DL transfer descriptors in message ring.
2) Define message set for pipe/sleep protocol.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 563 ++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h | 358 ++++++++++++++++
 2 files changed, 921 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
new file mode 100644
index 000000000000..beca5e06203a
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -0,0 +1,563 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include "iosm_ipc_protocol.h"
+#include "iosm_ipc_protocol_ops.h"
+
+/* Get the next free message element.*/
+static union ipc_mem_msg_entry *
+ipc_protocol_free_msg_get(struct iosm_protocol *ipc_protocol, int *index)
+{
+	u32 head = ipc_protocol->p_ap_shm->msg_head;
+	u32 new_head = (head + 1) % IPC_MEM_MSG_ENTRIES;
+	union ipc_mem_msg_entry *msg;
+
+	if (new_head == ipc_protocol->p_ap_shm->msg_tail) {
+		dev_err(ipc_protocol->dev, "message ring is full");
+		return NULL;
+	}
+
+	/* Get the pointer to the next free message element,
+	 * reset the fields and mark is as invalid.
+	 */
+	msg = &ipc_protocol->p_ap_shm->msg_ring[head];
+	memset(msg, 0, sizeof(*msg));
+
+	/* return index in message ring */
+	*index = head;
+
+	return msg;
+}
+
+/* Updates the message ring Head pointer */
+void ipc_protocol_msg_hp_update(void *instance)
+{
+	struct iosm_protocol *ipc_protocol = instance;
+	u32 head = ipc_protocol->p_ap_shm->msg_head;
+	u32 new_head = (head + 1) % IPC_MEM_MSG_ENTRIES;
+
+	/* Update head pointer and fire doorbell. */
+	ipc_protocol->p_ap_shm->msg_head = new_head;
+	ipc_protocol->old_msg_tail = ipc_protocol->p_ap_shm->msg_tail;
+
+	/* Host Sleep negotiation happens through Message Ring. So Host Sleep
+	 * check should be avoided by sending false as last argument.
+	 */
+	ipc_pm_signal_hpda_doorbell(ipc_protocol->pm, IPC_HP_MR, false);
+}
+
+/* Allocate and prepare a OPEN_PIPE message.
+ * This also allocates the memory for the new TDR structure and
+ * updates the pipe structure referenced in the preparation arguments.
+ */
+static int ipc_protocol_msg_prepipe_open(struct iosm_protocol *ipc_protocol,
+					 union ipc_msg_prep_args *args)
+{
+	int index = -1;
+	union ipc_mem_msg_entry *msg =
+		ipc_protocol_free_msg_get(ipc_protocol, &index);
+	struct ipc_pipe *pipe = args->pipe_open.pipe;
+	struct ipc_protocol_td *tdr;
+	struct sk_buff **skbr;
+
+	if (!msg) {
+		dev_err(ipc_protocol->dev, "failed to get free message");
+		return -1;
+	}
+
+	/* Allocate the skbuf elements for the skbuf which are on the way.
+	 * SKB ring is internal memory allocation for driver. No need to
+	 * re-calculate the start and end addresses.
+	 */
+	skbr = kcalloc(pipe->nr_of_entries, sizeof(*skbr), GFP_ATOMIC);
+	if (!skbr)
+		return -ENOMEM;
+
+	/* Allocate the transfer descriptors for the pipe. */
+	tdr = pci_alloc_consistent(ipc_protocol->pcie->pci,
+				   pipe->nr_of_entries * sizeof(*tdr),
+				   &pipe->phy_tdr_start);
+	if (!tdr) {
+		kfree(skbr);
+		dev_err(ipc_protocol->dev, "tdr alloc error");
+		return -ENOMEM;
+	}
+
+	pipe->max_nr_of_queued_entries = pipe->nr_of_entries - 1;
+	pipe->nr_of_queued_entries = 0;
+	pipe->tdr_start = tdr;
+	pipe->skbr_start = skbr;
+	pipe->old_tail = 0;
+
+	ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr] = 0;
+
+	msg->open_pipe.type_of_message = IPC_MEM_MSG_OPEN_PIPE;
+	msg->open_pipe.pipe_nr = pipe->pipe_nr;
+	msg->open_pipe.tdr_addr = pipe->phy_tdr_start;
+	msg->open_pipe.tdr_entries = pipe->nr_of_entries;
+	msg->open_pipe.interrupt_moderation = pipe->irq_moderation;
+	msg->open_pipe.accumulation_backoff = pipe->accumulation_backoff;
+	msg->open_pipe.reliable = true;
+	msg->open_pipe.optimized_completion = true;
+	msg->open_pipe.irq_vector = pipe->irq;
+
+	return index;
+}
+
+static int ipc_protocol_msg_prepipe_close(struct iosm_protocol *ipc_protocol,
+					  union ipc_msg_prep_args *args)
+{
+	int index = -1;
+	union ipc_mem_msg_entry *msg =
+		ipc_protocol_free_msg_get(ipc_protocol, &index);
+	struct ipc_pipe *pipe = args->pipe_close.pipe;
+
+	if (!msg)
+		return -1;
+
+	msg->close_pipe.type_of_message = IPC_MEM_MSG_CLOSE_PIPE;
+	msg->close_pipe.pipe_nr = pipe->pipe_nr;
+
+	dev_dbg(ipc_protocol->dev, "IPC_MEM_MSG_CLOSE_PIPE(pipe_nr=%d)",
+		msg->close_pipe.pipe_nr);
+
+	return index;
+}
+
+static int ipc_protocol_msg_prep_sleep(struct iosm_protocol *ipc_protocol,
+				       union ipc_msg_prep_args *args)
+{
+	int index = -1;
+	union ipc_mem_msg_entry *msg =
+		ipc_protocol_free_msg_get(ipc_protocol, &index);
+
+	if (!msg) {
+		dev_err(ipc_protocol->dev, "failed to get free message");
+		return -1;
+	}
+
+	/* Prepare and send the host sleep message to CP to enter or exit D3. */
+	msg->host_sleep.type_of_message = IPC_MEM_MSG_SLEEP;
+	msg->host_sleep.target = args->sleep.target; /* 0=host, 1=device */
+
+	/* state; 0=enter, 1=exit 2=enter w/o protocol */
+	msg->host_sleep.state = args->sleep.state;
+
+	dev_dbg(ipc_protocol->dev, "IPC_MEM_MSG_SLEEP(target=%d; state=%d)",
+		msg->host_sleep.target, msg->host_sleep.state);
+
+	return index;
+}
+
+static int ipc_protocol_msg_prep_feature_set(struct iosm_protocol *ipc_protocol,
+					     union ipc_msg_prep_args *args)
+{
+	int index = -1;
+	union ipc_mem_msg_entry *msg =
+		ipc_protocol_free_msg_get(ipc_protocol, &index);
+
+	if (!msg) {
+		dev_err(ipc_protocol->dev, "failed to get free message");
+		return -1;
+	}
+
+	msg->feature_set.type_of_message = IPC_MEM_MSG_FEATURE_SET;
+	msg->feature_set.reset_enable = args->feature_set.reset_enable;
+
+	dev_dbg(ipc_protocol->dev, "IPC_MEM_MSG_FEATURE_SET(reset_enable=%d)",
+		msg->feature_set.reset_enable);
+
+	return index;
+}
+
+/* Processes the message consumed by CP. */
+bool ipc_protocol_msg_process(void *instance, int irq)
+{
+	struct iosm_protocol *ipc_protocol = instance;
+	struct ipc_rsp **rsp_ring = ipc_protocol->rsp_ring;
+	bool msg_processed = false;
+	int i;
+
+	if (ipc_protocol->p_ap_shm->msg_tail >= IPC_MEM_MSG_ENTRIES) {
+		dev_err(ipc_protocol->dev, "msg_tail out of range: %d",
+			ipc_protocol->p_ap_shm->msg_tail);
+		return msg_processed;
+	}
+
+	if (irq != IMEM_IRQ_DONT_CARE &&
+	    irq != ipc_protocol->p_ap_shm->ci.msg_irq_vector)
+		return msg_processed;
+
+	for (i = ipc_protocol->old_msg_tail;
+	     i != ipc_protocol->p_ap_shm->msg_tail;
+	     i = (i + 1) % IPC_MEM_MSG_ENTRIES) {
+		union ipc_mem_msg_entry *msg =
+			&ipc_protocol->p_ap_shm->msg_ring[i];
+
+		dev_dbg(ipc_protocol->dev, "msg[%d]: type=%u status=%d", i,
+			msg->common.type_of_message,
+			msg->common.completion_status);
+
+		/* Update response with status and wake up waiting requestor */
+		if (rsp_ring[i]) {
+			rsp_ring[i]->status =
+				(enum ipc_mem_msg_cs)
+					msg->common.completion_status;
+			complete(&rsp_ring[i]->completion);
+			rsp_ring[i] = NULL;
+		}
+		msg_processed = true;
+	}
+
+	ipc_protocol->old_msg_tail = i;
+	return msg_processed;
+}
+
+/* Sends data from UL list to CP for the provided pipe by updating the Head
+ * pointer of given pipe.
+ */
+bool ipc_protocol_ul_td_send(void *protocol_inst, struct ipc_pipe *pipe,
+			     struct sk_buff_head *p_ul_list)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+	struct ipc_protocol_td *td;
+	bool hpda_pending = false;
+	s32 free_elements = 0;
+	struct sk_buff *skb;
+	u32 head;
+	u32 tail;
+
+	if (!ipc_protocol->p_ap_shm) {
+		dev_err(ipc_protocol->dev, "driver is not initialized");
+		return false;
+	}
+
+	/* Get head and tail of the td list and calculate
+	 * the number of free elements.
+	 */
+	head = ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr];
+	tail = pipe->old_tail;
+
+	while (!skb_queue_empty(p_ul_list)) {
+		if (head < tail)
+			free_elements = tail - head - 1;
+		else
+			free_elements =
+				pipe->nr_of_entries - head + ((s32)tail - 1);
+
+		if (free_elements <= 0) {
+			dev_dbg(ipc_protocol->dev,
+				"no free td elements for UL pipe %d",
+				pipe->pipe_nr);
+			break;
+		}
+
+		/* Get the td address. */
+		td = &pipe->tdr_start[head];
+
+		/* Take the first element of the uplink list and add it
+		 * to the td list.
+		 */
+		skb = skb_dequeue(p_ul_list);
+		if (WARN_ON(!skb))
+			break;
+
+		/* Save the reference to the uplink skbuf. */
+		pipe->skbr_start[head] = skb;
+
+		td->buffer.address = IPC_CB(skb)->mapping;
+		td->scs.size = skb->len;
+		td->scs.completion_status = 0;
+		td->next = 0;
+		td->reserved1 = 0;
+
+		pipe->nr_of_queued_entries++;
+
+		/* Calculate the new head and save it. */
+		head++;
+		if (head >= pipe->nr_of_entries)
+			head = 0;
+
+		ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr] = head;
+	}
+
+	if (pipe->old_head != head) {
+		dev_dbg(ipc_protocol->dev, "New UL TDs Pipe:%d", pipe->pipe_nr);
+
+		pipe->old_head = head;
+		/* Trigger doorbell because of pending UL packets. */
+		hpda_pending = true;
+	}
+
+	return hpda_pending;
+}
+
+/* Checks for Tail pointer update from CP and returns the data as SKB. */
+struct sk_buff *ipc_protocol_ul_td_process(void *protocol_inst,
+					   struct ipc_pipe *pipe)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+	struct ipc_protocol_td *p_td = &pipe->tdr_start[pipe->old_tail];
+	struct sk_buff *skb = pipe->skbr_start[pipe->old_tail];
+
+	pipe->nr_of_queued_entries--;
+	pipe->old_tail++;
+	if (pipe->old_tail >= pipe->nr_of_entries)
+		pipe->old_tail = 0;
+
+	if (!p_td->buffer.address) {
+		dev_err(ipc_protocol->dev, "Td buffer address is NULL");
+		return NULL;
+	}
+
+	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
+		dev_err(ipc_protocol->dev,
+			"pipe(%d): invalid buf_addr=%p or skb->data=%llx",
+			pipe->pipe_nr, (void *)p_td->buffer.address,
+			skb ? IPC_CB(skb)->mapping : 0);
+		return NULL;
+	}
+
+	return skb;
+}
+
+/* Allocates an SKB for CP to send data and updates the Head Pointer
+ * of the given Pipe#.
+ */
+bool ipc_protocol_dl_td_prepare(void *protocol_inst, struct ipc_pipe *pipe)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+	u32 head, new_head;
+	struct ipc_protocol_td *td;
+	dma_addr_t mapping = 0;
+	struct sk_buff *skb;
+	u32 tail;
+
+	/* Get head and tail of the td list and calculate
+	 * the number of free elements.
+	 */
+	head = ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr];
+	tail = ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr];
+
+	new_head = head + 1;
+	if (new_head >= pipe->nr_of_entries)
+		new_head = 0;
+
+	if (new_head == tail)
+		return false;
+
+	/* Get the td address. */
+	td = &pipe->tdr_start[head];
+
+	/* Allocate the skbuf for the descriptor. */
+	skb = ipc_pcie_alloc_skb(ipc_protocol->pcie, pipe->buf_size, GFP_ATOMIC,
+				 &mapping, DMA_FROM_DEVICE,
+				 IPC_MEM_DL_ETH_OFFSET);
+	if (!skb)
+		return false;
+
+	td->buffer.address = mapping;
+	td->scs.size = pipe->buf_size;
+	td->scs.completion_status = 0;
+	td->next = 0;
+	td->reserved1 = 0;
+
+	/* store the new head value. */
+	ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr] = new_head;
+
+	/* Save the reference to the skbuf. */
+	pipe->skbr_start[head] = skb;
+
+	pipe->nr_of_queued_entries++;
+
+	return true;
+}
+
+/* Processes the TD processed from CP by checking the Tail Pointer for given
+ * pipe.
+ */
+struct sk_buff *ipc_protocol_dl_td_process(void *protocol_inst,
+					   struct ipc_pipe *pipe)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+	u32 tail = ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr];
+	struct ipc_protocol_td *p_td;
+	struct sk_buff *skb;
+
+	if (!pipe->tdr_start)
+		return NULL;
+
+	/* Copy the reference to the downlink buffer. */
+	p_td = &pipe->tdr_start[pipe->old_tail];
+	skb = pipe->skbr_start[pipe->old_tail];
+
+	/* Reset the ring elements. */
+	pipe->skbr_start[pipe->old_tail] = NULL;
+
+	pipe->nr_of_queued_entries--;
+
+	pipe->old_tail++;
+	if (pipe->old_tail >= pipe->nr_of_entries)
+		pipe->old_tail = 0;
+
+	if (!skb->data) {
+		dev_err(ipc_protocol->dev, "skb is null");
+		goto ret;
+	} else if (!p_td->buffer.address) {
+		dev_err(ipc_protocol->dev, "td/buffer address is null");
+		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+		skb = NULL;
+		goto ret;
+	}
+
+	if (!IPC_CB(skb)) {
+		dev_err(ipc_protocol->dev, "pipe# %d, tail: %d skb_cb is NULL",
+			pipe->pipe_nr, tail);
+		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+		skb = NULL;
+		goto ret;
+	}
+
+	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
+		dev_err(ipc_protocol->dev, "invalid buf=%p or skb=%p",
+			(void *)p_td->buffer.address, skb->data);
+		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+		skb = NULL;
+		goto ret;
+	} else if (p_td->scs.size > pipe->buf_size) {
+		dev_err(ipc_protocol->dev, "invalid buffer size %d > %d",
+			p_td->scs.size, pipe->buf_size);
+		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+		skb = NULL;
+		goto ret;
+	} else if (p_td->scs.completion_status == IPC_MEM_TD_CS_ABORT) {
+		/* Discard aborted buffers. */
+		dev_dbg(ipc_protocol->dev, "discard 'aborted' buffers");
+		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+		skb = NULL;
+		goto ret;
+	}
+
+	/* Set the length field in skbuf. */
+	skb_put(skb, p_td->scs.size);
+
+ret:
+	return skb;
+}
+
+void ipc_protocol_get_head_tail_index(void *protocol_inst,
+				      struct ipc_pipe *pipe, u32 *head,
+				      u32 *tail)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+
+	if (head)
+		*head = ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr];
+
+	if (tail)
+		*tail = ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr];
+}
+
+/* Frees the TDs given to CP.  */
+void ipc_protocol_pipe_cleanup(void *protocol_inst, struct ipc_pipe *pipe)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+	struct sk_buff *skb;
+	u32 head;
+	u32 tail;
+
+	if (!ipc_protocol->p_ap_shm) {
+		dev_err(ipc_protocol->dev, "p_ap_shm is NULL");
+		return;
+	}
+
+	/* Get the start and the end of the buffer list. */
+	head = ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr];
+	tail = pipe->old_tail;
+
+	/* Reset tail and head to 0. */
+	ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr] = 0;
+	ipc_protocol->p_ap_shm->head_array[pipe->pipe_nr] = 0;
+
+	/* Free pending uplink and downlink buffers. */
+	if (pipe->skbr_start) {
+		while (head != tail) {
+			/* Get the reference to the skbuf,
+			 * which is on the way and free it.
+			 */
+			skb = pipe->skbr_start[tail];
+			if (skb)
+				ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
+
+			tail++;
+			if (tail >= pipe->nr_of_entries)
+				tail = 0;
+		}
+
+		kfree(pipe->skbr_start);
+		pipe->skbr_start = NULL;
+	}
+
+	pipe->old_tail = 0;
+
+	/* Free and reset the td and skbuf circular buffers. kfree is save! */
+	if (pipe->tdr_start) {
+		pci_free_consistent(ipc_protocol->pcie->pci,
+				    sizeof(*pipe->tdr_start) *
+					    pipe->nr_of_entries,
+				    pipe->tdr_start, pipe->phy_tdr_start);
+
+		pipe->tdr_start = NULL;
+	}
+}
+
+enum ipc_mem_device_ipc_state ipc_protocol_get_ipc_status(void *protocol_inst)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+
+	return (enum ipc_mem_device_ipc_state)
+		ipc_protocol->p_ap_shm->device_info.ipc_status;
+}
+
+enum ipc_mem_exec_stage
+ipc_protocol_get_ap_exec_stage(struct iosm_protocol *ipc_protocol)
+{
+	return ipc_protocol->p_ap_shm->device_info.execution_stage;
+}
+
+int ipc_protocol_msg_prep(void *instance, enum ipc_msg_prep_type msg_type,
+			  union ipc_msg_prep_args *args)
+{
+	struct iosm_protocol *ipc_protocol = instance;
+
+	switch (msg_type) {
+	case IPC_MSG_PREP_SLEEP:
+		return ipc_protocol_msg_prep_sleep(ipc_protocol, args);
+
+	case IPC_MSG_PREP_PIPE_OPEN:
+		return ipc_protocol_msg_prepipe_open(ipc_protocol, args);
+
+	case IPC_MSG_PREP_PIPE_CLOSE:
+		return ipc_protocol_msg_prepipe_close(ipc_protocol, args);
+
+	case IPC_MSG_PREP_FEATURE_SET:
+		return ipc_protocol_msg_prep_feature_set(ipc_protocol, args);
+
+		/* Unsupported messages in protocol */
+	case IPC_MSG_PREP_MAP:
+	case IPC_MSG_PREP_UNMAP:
+	default:
+		dev_err(ipc_protocol->dev,
+			"unsupported message type: %d in protocol", msg_type);
+		return -1;
+	}
+}
+
+u32 ipc_protocol_pm_dev_get_sleep_notification(void *protocol_inst)
+{
+	struct iosm_protocol *ipc_protocol = protocol_inst;
+
+	return ipc_protocol->p_ap_shm->device_info.device_sleep_notification;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h
new file mode 100644
index 000000000000..d59324faff2b
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h
@@ -0,0 +1,358 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_PROTOCOL_OPS_H
+#define IOSM_IPC_PROTOCOL_OPS_H
+
+#include "iosm_ipc_protocol.h"
+
+/**
+ * enum ipc_mem_td_cs - Completion status of a TD
+ * @IPC_MEM_TD_CS_INVALID:	      Initial status - td not yet used.
+ * @IPC_MEM_TD_CS_PARTIAL_TRANSFER:   More data pending -> next TD used for this
+ * @IPC_MEM_TD_CS_END_TRANSFER:	      IO transfer is complete.
+ * @IPC_MEM_TD_CS_OVERFLOW:	      IO transfer to small for the buff to write
+ * @IPC_MEM_TD_CS_ABORT:	      TD marked as abort and shall be discarded
+ *				      by AP.
+ * @IPC_MEM_TD_CS_ERROR:	      General error.
+ */
+enum ipc_mem_td_cs {
+	IPC_MEM_TD_CS_INVALID,
+	IPC_MEM_TD_CS_PARTIAL_TRANSFER,
+	IPC_MEM_TD_CS_END_TRANSFER,
+	IPC_MEM_TD_CS_OVERFLOW,
+	IPC_MEM_TD_CS_ABORT,
+	IPC_MEM_TD_CS_ERROR,
+};
+
+/* Completion status of IPC Message */
+enum ipc_mem_msg_cs {
+	IPC_MEM_MSG_CS_INVALID,
+	IPC_MEM_MSG_CS_SUCCESS,
+	IPC_MEM_MSG_CS_ERROR,
+};
+
+/**
+ * struct ipc_msg_prep_args_pipe - Structures for argument passing towards
+ *				   the actual message preparation
+ * @pipe:	Pipe to open/close
+ */
+struct ipc_msg_prep_args_pipe {
+	struct ipc_pipe *pipe; /* pipe to open/close */
+};
+
+struct ipc_msg_prep_args_sleep {
+	unsigned int target; /* 0=host, 1=device */
+	unsigned int state; /* 0=enter sleep, 1=exit sleep */
+};
+
+struct ipc_msg_prep_feature_set {
+	/* 0 = out-of-band, 1 = in-band-crash notification */
+	unsigned int reset_enable;
+};
+
+struct ipc_msg_prep_map {
+	unsigned int region_id;
+	unsigned long addr;
+	size_t size;
+};
+
+struct ipc_msg_prep_unmap {
+	unsigned int region_id;
+};
+
+/* Union for message to handle the message to CP in the tasklet context. */
+union ipc_msg_prep_args {
+	struct ipc_msg_prep_args_pipe pipe_open;
+	struct ipc_msg_prep_args_pipe pipe_close;
+	struct ipc_msg_prep_args_sleep sleep;
+	struct ipc_msg_prep_feature_set feature_set;
+	struct ipc_msg_prep_map map;
+	struct ipc_msg_prep_unmap unmap;
+};
+
+/**
+ * enum ipc_msg_prep_type - Enum for message prepare actions
+ * @IPC_MSG_PREP_SLEEP:		prepare a sleep message
+ * @IPC_MSG_PREP_PIPE_OPEN:	prepare a pipe open message
+ * @IPC_MSG_PREP_PIPE_CLOSE:	prepare a pipe close message
+ * @IPC_MSG_PREP_FEATURE_SET:	prepare a feature set message
+ * @IPC_MSG_PREP_MAP:		prepare a memory map message
+ * @IPC_MSG_PREP_UNMAP:		prepare a memory unmap message
+ */
+enum ipc_msg_prep_type {
+	IPC_MSG_PREP_SLEEP,
+	IPC_MSG_PREP_PIPE_OPEN,
+	IPC_MSG_PREP_PIPE_CLOSE,
+	IPC_MSG_PREP_FEATURE_SET,
+	IPC_MSG_PREP_MAP,
+	IPC_MSG_PREP_UNMAP,
+};
+
+/**
+ * struct ipc_rsp - Response for message to CP
+ * @completion:	For waking up requestor
+ * @status:	Completion status
+ */
+struct ipc_rsp {
+	struct completion completion;
+	enum ipc_mem_msg_cs status;
+};
+
+/**
+ * enum ipc_mem_msg - Type-definition of the messages.
+ * @IPC_MEM_MSG_OPEN_PIPE:	AP ->CP: Open a pipe
+ * @IPC_MEM_MSG_CLOSE_PIPE:	AP ->CP: Close a pipe
+ * @IPC_MEM_MSG_ABORT_PIPE:	AP ->CP: wait for completion of the
+ *				running transfer and abort all pending
+ *				IO-transfers for the pipe
+ * @IPC_MEM_MSG_SLEEP:		AP ->CP: host enter or exit sleep
+ * @IPC_MEM_MSG_FEATURE_SET:	AP ->CP: Intel feature configuration
+ */
+enum ipc_mem_msg {
+	IPC_MEM_MSG_OPEN_PIPE = 0x01,
+	IPC_MEM_MSG_CLOSE_PIPE = 0x02,
+	IPC_MEM_MSG_ABORT_PIPE = 0x03,
+	IPC_MEM_MSG_SLEEP = 0x04,
+	IPC_MEM_MSG_FEATURE_SET = 0xF0,
+};
+
+struct ipc_mem_msg_open_pipe {
+	u64 tdr_addr;
+	u32 tdr_entries : 16;
+	u32 pipe_nr : 8;
+	u32 type_of_message : 8;
+	u32 irq_vector : 5;
+	u32 optimized_completion : 1;
+	u32 reliable : 1;
+	u32 reserved1 : 1;
+	u32 interrupt_moderation : 24;
+	u32 accumulation_backoff : 24;
+	u32 reserved2 : 8;
+	u32 completion_status;
+};
+
+/* Message structure for close pipe. */
+struct ipc_mem_msg_close_pipe {
+	u32 reserved1[2];
+	u32 reserved2 : 16;
+	u32 pipe_nr : 8;
+	u32 type_of_message : 8;
+	u32 reserved3;
+	u32 reserved4;
+	u32 completion_status;
+};
+
+/* Message structure for abort pipe. */
+struct ipc_mem_msg_abort_pipe {
+	u32 reserved1[2];
+	u32 reserved2 : 16;
+	u32 pipe_nr : 8;
+	u32 type_of_message : 8;
+	u32 reserved3;
+	u32 reserved4;
+	u32 completion_status;
+};
+
+/**
+ * struct ipc_mem_msg_host_sleep - Message structure for sleep message.
+ * @reserved1:		Reserved
+ * @target:		0=host, 1=device, host or EP devie
+ *			is the message target
+ * @state:		0=enter sleep, 1=exit sleep,
+ *			2=enter sleep no protocol
+ * @reserved2:		Reserved
+ * @type_of_message:	Message type
+ * @reserved3:		Reserved
+ * @reserved4:		Reserved
+ * @completion_status:	Message Completion Status
+ */
+struct ipc_mem_msg_host_sleep {
+	u32 reserved1[2];
+	u32 target : 8;
+	u32 state : 8;
+	u32 reserved2 : 8;
+	u32 type_of_message : 8;
+	u32 reserved3;
+	u32 reserved4;
+	u32 completion_status;
+};
+
+/* Message structure for feature_set message */
+struct ipc_mem_msg_feature_set {
+	u32 reserved1[2];
+	u32 reserved2 : 23;
+	u32 reset_enable : 1;
+	u32 type_of_message : 8;
+	u32 reserved3;
+	u32 reserved4;
+	u32 completion_status;
+};
+
+/* Message structure for completion status update. */
+struct ipc_mem_msg_common {
+	u32 reserved1[2];
+	u32 reserved2 : 24;
+	u32 type_of_message : 8;
+	u32 reserved3;
+	u32 reserved4;
+	u32 completion_status;
+};
+
+/* Union with all possible messages. */
+union ipc_mem_msg_entry {
+	struct ipc_mem_msg_open_pipe open_pipe;
+	struct ipc_mem_msg_close_pipe close_pipe;
+	struct ipc_mem_msg_abort_pipe abort_pipe;
+	struct ipc_mem_msg_host_sleep host_sleep;
+	struct ipc_mem_msg_feature_set feature_set;
+	/* Used to access msg_type and to set the completion status. */
+	struct ipc_mem_msg_common common;
+};
+
+/* Transfer descriptor definition. */
+struct ipc_protocol_td {
+	union {
+		/*   0 :  63 - 64-bit address of a buffer in host memory. */
+		dma_addr_t address;
+		struct {
+			/*   0 :  31 - 32 bit address */
+			__le32 address;
+			/*  32 :  63 - corresponding descriptor */
+			__le32 desc;
+		} __attribute__ ((__packed__)) shm;
+	} buffer;
+
+	struct {
+	/*	64 :  87 - Size of the buffer.
+	 *	The host provides the size of the buffer queued.
+	 *	The EP device reads this value and shall update
+	 *	it for downlink transfers to indicate the
+	 *	amount of data written in buffer.
+	 */
+		u32 size : 24;
+	/*	88 :  95 - This field provides the completion status
+	 *	of the TD. When queuing the TD, the host sets
+	 *	the status to 0. The EP device updates this
+	 *	field when completing the TD.
+	 */
+		u32 completion_status : 8;
+	} __attribute__ ((__packed__)) scs;
+
+	/*  96 : 103 - nr of following descriptors */
+	u32 next : 8;
+	/* 104 : 127 - reserved */
+	u32 reserved1 : 24;
+} __attribute__ ((__packed__));
+
+/**
+ * ipc_protocol_msg_prep - Prepare message based upon message type
+ * @ptr:	iosm_protocol instance
+ * @msg_type:	message prepare type
+ * @args:	message arguments
+ *
+ * Return: 0 on success, -1 in case of failure
+ */
+int ipc_protocol_msg_prep(void *ptr, enum ipc_msg_prep_type msg_type,
+			  union ipc_msg_prep_args *args);
+
+/**
+ * ipc_protocol_msg_hp_update - Function for head pointer update
+ *				of message ring
+ * @ptr:	iosm_protocol instance
+ */
+void ipc_protocol_msg_hp_update(void *ptr);
+
+/**
+ * ipc_protocol_msg_process - Function for processing responses
+ *			      to IPC messages
+ * @ptr:	iosm_protocol instance
+ * @irq:	IRQ vector
+ *
+ * Return:	True on success; false if error
+ */
+bool ipc_protocol_msg_process(void *ptr, int irq);
+
+/**
+ * ipc_protocol_ul_td_send - Function for sending the data to CP
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe instance
+ * @p_ul_list: uplink sk_buff list
+ *
+ * Return: true in success; false in case of error
+ */
+bool ipc_protocol_ul_td_send(void *ptr, struct ipc_pipe *pipe,
+			     struct sk_buff_head *p_ul_list);
+
+/**
+ * ipc_protocol_ul_td_process - Function for processing the sent data
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe instance
+ *
+ * Return: sk_buff instance
+ */
+struct sk_buff *ipc_protocol_ul_td_process(void *ptr, struct ipc_pipe *pipe);
+
+/**
+ * ipc_protocol_dl_td_prepare - Function for providing DL TDs to CP
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe instance
+ *
+ * Return: true in success; false in case of error
+ */
+bool ipc_protocol_dl_td_prepare(void *ptr, struct ipc_pipe *pipe);
+
+/**
+ * ipc_protocol_dl_td_process - Function for processing the DL data
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe instance
+ *
+ * Return: sk_buff instance
+ */
+struct sk_buff *ipc_protocol_dl_td_process(void *ptr, struct ipc_pipe *pipe);
+
+/**
+ * ipc_protocol_get_head_tail_index - Function for getting Head and Tail
+ *				      pointer index of given pipe
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe Instance
+ * @head: head pointer index of the given pipe
+ * @tail: tail pointer index of the given pipe
+ */
+void ipc_protocol_get_head_tail_index(void *ptr, struct ipc_pipe *pipe,
+				      u32 *head, u32 *tail);
+/**
+ * ipc_protocol_get_ipc_status - Function for getting the IPC Status
+ * @ptr: iosm_protocol instance
+ *
+ * Return: Returns IPC State
+ */
+enum ipc_mem_device_ipc_state ipc_protocol_get_ipc_status(void *ptr);
+
+/**
+ * ipc_protocol_pipe_cleanup - Function to cleanup pipe resources
+ * @ptr: iosm_protocol instance
+ * @pipe: Pipe instance
+ */
+void ipc_protocol_pipe_cleanup(void *ptr, struct ipc_pipe *pipe);
+
+/**
+ * ipc_protocol_get_ap_exec_stage - Function for getting AP Exec Stage
+ * @ipc_protocol: pointer to struct iosm protocol
+ *
+ * Return: returns BOOT Stages
+ */
+enum ipc_mem_exec_stage
+ipc_protocol_get_ap_exec_stage(struct iosm_protocol *ipc_protocol);
+
+/**
+ * ipc_protocol_pm_dev_get_sleep_notification - Function for getting Dev Sleep
+ *						notification
+ * @ptr: iosm_protocol instance
+ *
+ * Return: Returns dev PM State
+ */
+u32 ipc_protocol_pm_dev_get_sleep_notification(void *ptr);
+#endif
-- 
2.12.3

