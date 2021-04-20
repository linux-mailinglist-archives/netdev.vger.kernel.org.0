Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14EF365D06
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhDTQPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:15:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:42699 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233161AbhDTQPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:15:05 -0400
IronPort-SDR: QT24B7wO+m+hqOHggK/KfcePnXd5IWx3kgQAHEUAEu2sATkz23wEKtA6dEAH10GOfzKlWJV1Iq
 BDv9GToc2hbA==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="280865946"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="280865946"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 09:14:33 -0700
IronPort-SDR: qt0j6SRTUIyR/H1+vbmIa3iuw32i04/HDTiZjhA/wDFnhee9JasbVVRd7N7cN6Usrbs3JKn8E/
 /EbXZdoL6QqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="454883091"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2021 09:14:32 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 05/16] net: iosm: shared memory I/O operations
Date:   Tue, 20 Apr 2021 21:42:59 +0530
Message-Id: <20210420161310.16189-6-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210420161310.16189-1-m.chetan.kumar@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Binds logical channel between host-device for communication.
2) Implements device specific(Char/Net) IO operations.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v2:
* Change vlan_id to ip link if_id & document correction.
* Define new enums for IP & DSS session mapping.
* Return proper error code instead of returning -1.
* Clean-up vlan tag id & removed FW flashing logic.
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 512 ++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h | 135 ++++++
 2 files changed, 647 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
new file mode 100644
index 000000000000..ed7ae138c3ae
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -0,0 +1,512 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include <linux/delay.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_imem_ops.h"
+#include "iosm_ipc_mbim.h"
+#include "iosm_ipc_task_queue.h"
+
+/* Open a packet data online channel between the network layer and CP. */
+int imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id)
+{
+	dev_dbg(ipc_imem->dev, "%s if id: %d",
+		ipc_ap_phase_get_string(ipc_imem->phase), if_id);
+
+	/* The network interface is only supported in the runtime phase. */
+	if (imem_ap_phase_update(ipc_imem) != IPC_P_RUN) {
+		dev_err(ipc_imem->dev, "net:%d : refused phase %s", if_id,
+			ipc_ap_phase_get_string(ipc_imem->phase));
+		return -EIO;
+	}
+
+	/* check for the interafce id
+	 * if tag 1 to 8 then create IP MUX channel sessions.
+	 * if tag 257 to 261 then create dss channel.
+	 * To start MUX session from 0 as network interface id would start
+	 * from 1 so map it to if_id = if_id - 1
+	 */
+	if (if_id >= IP_MUX_SESSION_START && if_id <= IP_MUX_SESSION_END) {
+		return ipc_mux_open_session(ipc_imem->mux, if_id - 1);
+	} else if (if_id >= DSS_CHANNEL_START && if_id <= DSS_CHANNEL_END) {
+		int ch_id =
+			imem_channel_alloc(ipc_imem, if_id, IPC_CTYPE_WWAN);
+
+		if (imem_channel_open(ipc_imem, ch_id, IPC_HP_NET_CHANNEL_INIT))
+			return ch_id;
+	}
+
+	return -EINVAL;
+}
+
+/* Release a net link to CP. */
+void imem_sys_wwan_close(struct iosm_imem *ipc_imem, int if_id,
+			 int channel_id)
+{
+	if (ipc_imem->mux && if_id >= IP_MUX_SESSION_START &&
+	    if_id <= IP_MUX_SESSION_END)
+		ipc_mux_close_session(ipc_imem->mux, if_id - 1);
+
+	else if ((if_id >= DSS_CHANNEL_START && if_id <= DSS_CHANNEL_END))
+		imem_channel_close(ipc_imem, channel_id);
+}
+
+/* Tasklet call to do uplink transfer. */
+static int imem_tq_cdev_write(struct iosm_imem *ipc_imem, int arg, void *msg,
+			      size_t size)
+{
+	ipc_imem->ev_cdev_write_pending = false;
+	imem_ul_send(ipc_imem);
+
+	return 0;
+}
+
+/* Through tasklet to do sio write. */
+static bool imem_call_cdev_write(struct iosm_imem *ipc_imem)
+{
+	if (ipc_imem->ev_cdev_write_pending)
+		return false;
+
+	ipc_imem->ev_cdev_write_pending = true;
+
+	return (!ipc_task_queue_send_task(ipc_imem, imem_tq_cdev_write, 0, NULL,
+					  0, false));
+}
+
+/* Add skb to the ul list */
+static int imem_wwan_transmit(struct iosm_imem *ipc_imem,
+			      int channel_id, struct sk_buff *skb)
+{
+	struct ipc_mem_channel *channel;
+	int ret = -EIO;
+
+	channel = &ipc_imem->channels[channel_id];
+
+	if (channel->state != IMEM_CHANNEL_ACTIVE) {
+		dev_err(ipc_imem->dev, "invalid state of channel %d",
+			channel_id);
+		goto out;
+	}
+
+	ret = ipc_pcie_addr_map(ipc_imem->pcie, skb->data, skb->len,
+				&IPC_CB(skb)->mapping, DMA_TO_DEVICE);
+	if (ret) {
+		dev_err(ipc_imem->dev, "failed to map skb");
+		IPC_CB(skb)->direction = DMA_TO_DEVICE;
+		IPC_CB(skb)->len = skb->len;
+		IPC_CB(skb)->op_type = UL_DEFAULT;
+		goto out;
+	}
+
+	/* Add skb to the uplink skbuf accumulator */
+	skb_queue_tail(&channel->ul_list, skb);
+	imem_call_cdev_write(ipc_imem);
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/* Function for transfer UL data */
+int imem_sys_wwan_transmit(struct iosm_imem *ipc_imem,
+			   int if_id, int channel_id, struct sk_buff *skb)
+{
+	int ret = -EINVAL;
+
+	if (!ipc_imem || channel_id < 0)
+		goto out;
+
+	/* Is CP Running? */
+	if (ipc_imem->phase != IPC_P_RUN) {
+		dev_dbg(ipc_imem->dev, "phase %s transmit",
+			ipc_ap_phase_get_string(ipc_imem->phase));
+		ret = -EIO;
+		goto out;
+	}
+
+	if (if_id >= IP_MUX_SESSION_START && if_id <= IP_MUX_SESSION_END)
+		/* Route the UL packet through IP MUX Layer */
+		ret = ipc_mux_ul_trigger_encode(ipc_imem->mux,
+						if_id - 1, skb);
+	/* DSS channels */
+	else if (if_id >= DSS_CHANNEL_START && if_id <= DSS_CHANNEL_END)
+		ret = imem_wwan_transmit(ipc_imem, channel_id, skb);
+	else
+		dev_err(ipc_imem->dev,
+			"invalid if_id %d: ", if_id);
+out:
+	return ret;
+}
+
+void wwan_channel_init(struct iosm_imem *ipc_imem,
+		       enum ipc_mux_protocol mux_type)
+{
+	struct ipc_chnl_cfg chnl_cfg = { 0 };
+
+	ipc_imem->cp_version = ipc_mmio_get_cp_version(ipc_imem->mmio);
+
+	/* If modem version is invalid (0xffffffff), do not initialize WWAN. */
+	if (ipc_imem->cp_version == -1) {
+		dev_err(ipc_imem->dev, "invalid CP version");
+		return;
+	}
+
+	while (ipc_imem->nr_of_channels < (IPC_MEM_MAX_CHANNELS - 1) &&
+	       !ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels)) {
+		imem_channel_init(ipc_imem, IPC_CTYPE_WWAN, chnl_cfg,
+				  IRQ_MOD_OFF);
+	}
+	/* WWAN registration. */
+	ipc_imem->wwan = ipc_wwan_init(ipc_imem, ipc_imem->dev);
+	if (!ipc_imem->wwan)
+		dev_err(ipc_imem->dev,
+			"failed to register the ipc_wwan interfaces");
+}
+
+/* Copies the data from user space */
+static struct sk_buff *
+imem_cdev_copy_from_user_to_skb(struct iosm_imem *ipc_imem, int channel_id,
+				const unsigned char __user *buf, int size,
+				int is_blocking)
+{
+	struct sk_buff *skb;
+	dma_addr_t mapping;
+
+	/* Allocate skb memory for the uplink buffer. */
+	skb = ipc_pcie_alloc_skb(ipc_imem->pcie, size, GFP_KERNEL, &mapping,
+				 DMA_TO_DEVICE, 0);
+	if (!skb)
+		return skb;
+
+	if (copy_from_user(skb_put(skb, size), buf, size)) {
+		dev_err(ipc_imem->dev, "ch[%d]: copy from user failed",
+			channel_id);
+		ipc_pcie_kfree_skb(ipc_imem->pcie, skb);
+		return NULL;
+	}
+
+	IPC_CB(skb)->op_type =
+		(u8)(is_blocking ? UL_USR_OP_BLOCKED : UL_DEFAULT);
+
+	return skb;
+}
+
+/* Get the write active channel */
+static struct ipc_mem_channel *
+imem_cdev_get_write_channel(struct iosm_imem *ipc_imem,
+			    struct ipc_mem_channel *channel,
+			    const unsigned char __user *buf, int size)
+{
+	enum ipc_phase phase;
+
+	if (size <= 0) {
+		dev_err(ipc_imem->dev, "invalid buff size");
+		return NULL;
+	}
+
+	/* Update the current operation phase. */
+	phase = ipc_imem->phase;
+
+	/* Select the operation depending on the execution stage. */
+	switch (phase) {
+	case IPC_P_RUN:
+	case IPC_P_PSI:
+	case IPC_P_EBL:
+		break;
+
+	case IPC_P_ROM:
+		/* Prepare the PSI image for the CP ROM driver and
+		 * suspend the flash app.
+		 */
+		if (channel->state != IMEM_CHANNEL_RESERVED) {
+			dev_err(ipc_imem->dev,
+				"ch[%d]:invalid channel state %d,expected %d",
+				channel->channel_id, channel->state,
+				IMEM_CHANNEL_RESERVED);
+			return NULL;
+		}
+		return channel;
+
+	default:
+		/* Ignore uplink actions in all other phases. */
+		dev_err(ipc_imem->dev, "ch[%d]: confused phase %d",
+			channel->channel_id, phase);
+		return NULL;
+	}
+
+	/* Check the full availability of the channel. */
+	if (channel->state != IMEM_CHANNEL_ACTIVE) {
+		dev_err(ipc_imem->dev, "ch[%d]: confused channel state %d",
+			channel->channel_id, channel->state);
+		return NULL;
+	}
+
+	return channel;
+}
+
+/* Release a sio link to CP. */
+void imem_sys_cdev_close(struct iosm_cdev *ipc_cdev)
+{
+	struct iosm_imem *ipc_imem = ipc_cdev->ipc_imem;
+	struct ipc_mem_channel *channel = ipc_cdev->channel;
+	enum ipc_phase curr_phase;
+	int status = 0;
+	u32 tail = 0;
+
+	curr_phase = ipc_imem->phase;
+
+	/* If current phase is IPC_P_OFF or SIO ID is -ve then
+	 * channel is already freed. Nothing to do.
+	 */
+	if (curr_phase == IPC_P_OFF) {
+		dev_err(ipc_imem->dev,
+			"nothing to do. Current Phase: %s",
+			ipc_ap_phase_get_string(curr_phase));
+		return;
+	}
+
+	if (channel->state == IMEM_CHANNEL_FREE) {
+		dev_err(ipc_imem->dev, "ch[%d]: invalid channel state %d",
+			channel->channel_id, channel->state);
+		return;
+	}
+
+	/* If there are any pending TDs then wait for Timeout/Completion before
+	 * closing pipe.
+	 */
+	if (channel->ul_pipe.old_tail != channel->ul_pipe.old_head) {
+		ipc_imem->app_notify_ul_pend = 1;
+
+		/* Suspend the user app and wait a certain time for processing
+		 * UL Data.
+		 */
+		status = wait_for_completion_interruptible_timeout
+			 (&ipc_imem->ul_pend_sem,
+			  msecs_to_jiffies(IPC_PEND_DATA_TIMEOUT));
+		if (status == 0) {
+			dev_dbg(ipc_imem->dev,
+				"Pending data Timeout on UL-Pipe:%d Head:%d Tail:%d",
+				channel->ul_pipe.pipe_nr,
+				channel->ul_pipe.old_head,
+				channel->ul_pipe.old_tail);
+		}
+
+		ipc_imem->app_notify_ul_pend = 0;
+	}
+
+	/* If there are any pending TDs then wait for Timeout/Completion before
+	 * closing pipe.
+	 */
+	ipc_protocol_get_head_tail_index(ipc_imem->ipc_protocol,
+					 &channel->dl_pipe, NULL, &tail);
+
+	if (tail != channel->dl_pipe.old_tail) {
+		ipc_imem->app_notify_dl_pend = 1;
+
+		/* Suspend the user app and wait a certain time for processing
+		 * DL Data.
+		 */
+		status = wait_for_completion_interruptible_timeout
+			 (&ipc_imem->dl_pend_sem,
+			  msecs_to_jiffies(IPC_PEND_DATA_TIMEOUT));
+		if (status == 0) {
+			dev_dbg(ipc_imem->dev,
+				"Pending data Timeout on DL-Pipe:%d Head:%d Tail:%d",
+				channel->dl_pipe.pipe_nr,
+				channel->dl_pipe.old_head,
+				channel->dl_pipe.old_tail);
+		}
+
+		ipc_imem->app_notify_dl_pend = 0;
+	}
+
+	/* Due to wait for completion in messages, there is a small window
+	 * between closing the pipe and updating the channel is closed. In this
+	 * small window there could be HP update from Host Driver. Hence update
+	 * the channel state as CLOSING to aviod unnecessary interrupt
+	 * towards CP.
+	 */
+	channel->state = IMEM_CHANNEL_CLOSING;
+
+	imem_pipe_close(ipc_imem, &channel->ul_pipe);
+	imem_pipe_close(ipc_imem, &channel->dl_pipe);
+
+	imem_channel_free(channel);
+
+	if (channel->channel_id != IPC_MEM_MBIM_CTRL_CH_ID)
+		/* Reset the global flash channel id. */
+		ipc_imem->flash_channel_id = -1;
+}
+
+/* Open a MBIM link to CP and return the channel */
+struct ipc_mem_channel *imem_sys_mbim_open(struct iosm_imem *ipc_imem)
+{
+	int ch_id;
+	struct ipc_mem_channel *channel;
+
+	/* The MBIM interface is only supported in the runtime phase. */
+	if (imem_ap_phase_update(ipc_imem) != IPC_P_RUN) {
+		dev_err(ipc_imem->dev, "MBIM open refused, phase %s",
+			ipc_ap_phase_get_string(ipc_imem->phase));
+		return NULL;
+	}
+
+	ch_id = imem_channel_alloc(ipc_imem, IPC_MEM_MBIM_CTRL_CH_ID,
+				   IPC_CTYPE_MBIM);
+
+	if (ch_id < 0) {
+		dev_err(ipc_imem->dev, "reservation of an MBIM chnl id failed");
+		return NULL;
+	}
+
+	channel = imem_channel_open(ipc_imem, ch_id, IPC_HP_CDEV_OPEN);
+
+	if (!channel) {
+		dev_err(ipc_imem->dev, "MBIM channel id open failed");
+		return NULL;
+	}
+
+	return channel;
+}
+
+ssize_t imem_sys_cdev_read(struct iosm_cdev *ipc_cdev, unsigned char __user *buf,
+			   size_t size, struct sk_buff *skb)
+{
+	unsigned char __user *dest_buf, *dest_end;
+	size_t dest_len, src_len, copied_b = 0;
+	unsigned char *src_buf;
+
+	/* Prepare the destination space. */
+	dest_buf = buf;
+	dest_end = dest_buf + size;
+
+	/* Copy the accumulated rx packets. */
+	while (skb) {
+		/* Prepare the source elements. */
+		src_buf = skb->data;
+		src_len = skb->len;
+
+		/* Calculate the current size of the destination buffer. */
+		dest_len = dest_end - dest_buf;
+
+		/* Compute the number of bytes to copy. */
+		copied_b = (dest_len < src_len) ? dest_len : src_len;
+
+		/* Copy the chars into the user space buffer. */
+		if (copy_to_user((void __user *)dest_buf, src_buf, copied_b) !=
+		    0) {
+			dev_err(ipc_cdev->dev,
+				"chid[%d] userspace copy failed n=%zu\n",
+				ipc_cdev->channel->channel_id, copied_b);
+			ipc_pcie_kfree_skb(ipc_cdev->pcie, skb);
+			return -EFAULT;
+		}
+
+		/* Update the source elements. */
+		skb->data = src_buf + copied_b;
+		skb->len = skb->len - copied_b;
+
+		/* Update the desctination pointer. */
+		dest_buf += copied_b;
+
+		/* Test the fill level of the user buffer. */
+		if (dest_buf >= dest_end) {
+			/* Free the consumed skbuf or save the pending skbuf
+			 * to consume it in the read call.
+			 */
+			if (skb->len == 0)
+				ipc_pcie_kfree_skb(ipc_cdev->pcie, skb);
+			else
+				ipc_cdev->rx_pending_buf = skb;
+
+			/* Return the number of saved chars. */
+			break;
+		}
+
+		/* Free the consumed skbuf. */
+		ipc_pcie_kfree_skb(ipc_cdev->pcie, skb);
+
+		/* Get the next skbuf element. */
+		skb = skb_dequeue(&ipc_cdev->rx_list);
+	}
+
+	/* Return the number of saved chars. */
+	copied_b = dest_buf - buf;
+	return copied_b;
+}
+
+int imem_sys_cdev_write(struct iosm_cdev *ipc_cdev,
+			const unsigned char __user *buf, int count,
+			bool blocking_write)
+{
+	struct iosm_imem *ipc_imem = ipc_cdev->ipc_imem;
+	struct ipc_mem_channel *channel = ipc_cdev->channel;
+	struct sk_buff *skb;
+	int ret = -EIO;
+
+	/* Complete all memory stores before setting bit */
+	smp_mb__before_atomic();
+
+	set_bit(WRITE_IN_USE, &ipc_cdev->flag);
+
+	/* Complete all memory stores after setting bit */
+	smp_mb__after_atomic();
+
+	channel = imem_cdev_get_write_channel(ipc_imem, channel, buf, count);
+
+	if (!channel || ipc_imem->phase == IPC_P_OFF_REQ)
+		goto out;
+
+	/* Allocate skb memory for the uplink buffer.*/
+	skb = imem_cdev_copy_from_user_to_skb(ipc_imem, channel->channel_id, buf,
+					      count, blocking_write);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Add skb to the uplink skbuf accumulator. */
+	skb_queue_tail(&channel->ul_list, skb);
+
+	/* Inform the IPC tasklet to pass uplink IP packets to CP.
+	 * Blocking write waits for UL completion notification,
+	 * non-blocking write simply returns the count.
+	 */
+	if (imem_call_cdev_write(ipc_imem) && blocking_write) {
+		/* Suspend the app and wait for UL data completion. */
+		ret = wait_for_completion_interruptible(&channel->ul_sem);
+
+		if (ret < 0) {
+			dev_err(ipc_imem->dev,
+				"ch[%d] no CP confirmation, status=%d",
+				channel->channel_id, ret);
+			goto out;
+		}
+	}
+	ret = count;
+out:
+	/* Complete all memory stores before clearing bit. */
+	smp_mb__before_atomic();
+
+	clear_bit(WRITE_IN_USE, &ipc_cdev->flag);
+
+	/* Complete all memory stores after clearing bit. */
+	smp_mb__after_atomic();
+	return ret;
+}
+
+int imem_sys_cdev_receive(struct iosm_cdev *ipc_cdev, struct sk_buff *skb)
+{
+	skb_queue_tail((&ipc_cdev->rx_list), skb);
+
+	if (test_bit(IS_BLOCKING, &ipc_cdev->flag))
+		complete(&ipc_cdev->read_sem);
+	else if (!test_bit(IS_BLOCKING, &ipc_cdev->flag))
+		wake_up_interruptible(&ipc_cdev->poll_inq);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
new file mode 100644
index 000000000000..d8220f039f87
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_IMEM_OPS_H
+#define IOSM_IPC_IMEM_OPS_H
+
+#include "iosm_ipc_mux_codec.h"
+
+/* Maximum length of the cdev device names */
+#define IPC_CDEV_NAME_LEN 32
+
+/* Maximum wait time for blocking read */
+#define IPC_READ_TIMEOUT 500
+
+/* The delay in ms for defering the unregister */
+#define SIO_UNREGISTER_DEFER_DELAY_MS 1
+
+/* Default delay till CP PSI image is running and modem updates the
+ * execution stage.
+ * unit : milliseconds
+ */
+#define PSI_START_DEFAULT_TIMEOUT 3000
+
+/* Default time out when closing SIO, till the modem is in
+ * running state.
+ * unit : milliseconds
+ */
+#define BOOT_CHECK_DEFAULT_TIMEOUT 400
+
+/* IP MUX and DSS channel range */
+#define IP_MUX_SESSION_START 1
+#define IP_MUX_SESSION_END 8
+
+#define IP_DSS_SESSION_START 9
+#define IP_DSS_SESSION_END 13
+
+#define DSS_SESSION_START IPC_WWAN_DSS_ID_0
+#define DSS_SESSION_END IPC_WWAN_DSS_ID_4
+
+#define NET_SESSION_START 1
+#define MAX_NET_SESSION 13
+
+#define DSS_CHANNEL_START IPC_WWAN_DSS_ID_0
+#define DSS_CHANNEL_END IPC_WWAN_DSS_ID_4
+
+/**
+ * imem_sys_mbim_open - Open a mbim link to CP.
+ * @ipc_imem:	Imem instance.
+ *
+ * Return: channel instance on success, NULL for failure
+ */
+struct ipc_mem_channel *imem_sys_mbim_open(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_sys_cdev_close - Release a sio link to CP.
+ * @ipc_cdev:		iosm sio instance.
+ */
+void imem_sys_cdev_close(struct iosm_cdev *ipc_cdev);
+
+/**
+ * imem_sys_cdev_read - Copy the rx data to the user space buffer and free the
+ *		       skbuf.
+ * @ipc_cdev:	Pointer to iosm_cdev structi.
+ * @buf:	Pointer to destination buffer.
+ * @size:	Size of destination buffer.
+ * @skb:	Pointer to source buffer.
+ *
+ * Return: Number of bytes read and failure value on error
+ */
+ssize_t imem_sys_cdev_read(struct iosm_cdev *ipc_cdev, unsigned char __user *buf,
+			   size_t size, struct sk_buff *skb);
+
+/**
+ * imem_sys_cdev_write - Route the uplink buffer to CP.
+ * @ipc_cdev:		iosm_cdev instance.
+ * @buf:		Pointer to source buffer.
+ * @count:		Number of data bytes to write.
+ * @blocking_write:	if true wait for UL data completion.
+ *
+ * Return: Number of bytes read and failure value on error
+ */
+int imem_sys_cdev_write(struct iosm_cdev *ipc_cdev,
+			const unsigned char __user *buf, int count,
+			bool blocking_write);
+
+/**
+ * imem_sys_cdev_receive - Receive downlink characters from CP, the downlink
+ *		skbuf is added at the end of the downlink or rx list.
+ * @ipc_cdev:    Pointer to ipc char data-struct
+ * @skb:        Pointer to sk buffer
+ * Returns:  0 on success
+ */
+int imem_sys_cdev_receive(struct iosm_cdev *ipc_cdev, struct sk_buff *skb);
+
+/**
+ * imem_sys_wwan_open - Open packet data online channel between network layer
+ *			and CP.
+ * @ipc_imem:		Imem instance.
+ * @if_id:		ip link tag of the net device.
+ *
+ * Return: Channel ID on success and failure value on error
+ */
+int imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id);
+
+/**
+ * imem_sys_wwan_close - Close packet data online channel between network layer
+ *			 and CP.
+ * @ipc_imem:		Imem instance.
+ * @if_id:		IP link id net device.
+ * @channel_id:		Channel ID to be closed.
+ */
+void imem_sys_wwan_close(struct iosm_imem *ipc_imem, int if_id,
+			 int channel_id);
+
+/**
+ * imem_sys_wwan_transmit - Function for transfer UL data
+ * @ipc_imem:		Imem instance.
+ * @if_id:		link ID of the device.
+ * @channel_id:		Channel ID used
+ * @skb:		Pointer to sk buffer
+ *
+ * Return: 0 on success and failure value on error
+ */
+int imem_sys_wwan_transmit(struct iosm_imem *ipc_imem, int if_id,
+			   int channel_id, struct sk_buff *skb);
+/**
+ * wwan_channel_init - Initializes WWAN channels and the channel for MUX.
+ * @ipc_imem:		Pointer to iosm_imem struct.
+ * @mux_type:		Type of mux protocol.
+ */
+void wwan_channel_init(struct iosm_imem *ipc_imem,
+		       enum ipc_mux_protocol mux_type);
+#endif
-- 
2.25.1

