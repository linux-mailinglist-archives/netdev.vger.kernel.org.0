Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196312ED50D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbhAGRGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:06:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:22136 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGRGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:06:50 -0500
IronPort-SDR: 4ehpP3xb3hyqSPf/L9xQ+WTXtyqCNdPXFWy6jhVoLFO4qQmQru/ZNDWAwo1CvLC+KZynbHsIR6
 B2AfIWMEIUTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="173952008"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="173952008"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:06:01 -0800
IronPort-SDR: MMvr2Jyds40HFW4PyYhiKH620o+viK3J3G6+MF4ogbyD/y+xm8rhKrPfjWhK/prCoa0ZZW3Px4
 Epb35F5pp+0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422643769"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:05:59 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 05/18] net: iosm: shared memory I/O operations
Date:   Thu,  7 Jan 2021 22:35:10 +0530
Message-Id: <20210107170523.26531-6-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Binds logical channel between host-device for communication.
2) Implements device specific(Char/Net) IO operations.
3) Inject primary BootLoader FW image to modem.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 768 ++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h | 129 +++++
 2 files changed, 897 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
new file mode 100644
index 000000000000..b6da96ca1332
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -0,0 +1,768 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/delay.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_imem_ops.h"
+#include "iosm_ipc_sio.h"
+#include "iosm_ipc_task_queue.h"
+
+/* Open a packet data online channel between the network layer and CP. */
+int imem_sys_wwan_open(struct iosm_imem *ipc_imem, int vlan_id)
+{
+	dev_dbg(ipc_imem->dev, "%s[vlan id:%d]",
+		ipc_ap_phase_get_string(ipc_imem->phase), vlan_id);
+
+	/* The network interface is only supported in the runtime phase. */
+	if (imem_ap_phase_update(ipc_imem) != IPC_P_RUN) {
+		dev_err(ipc_imem->dev, "[net:%d]: refused phase %s", vlan_id,
+			ipc_ap_phase_get_string(ipc_imem->phase));
+		return -1;
+	}
+
+	/* check for the vlan tag
+	 * if tag 1 to 8 then create IP MUX channel sessions.
+	 * if tag 257 to 512 then create dss channel.
+	 * To start MUX session from 0 as vlan tag would start from 1
+	 * so map it to if_id = vlan_id - 1
+	 */
+	if (vlan_id > 0 && vlan_id <= ipc_mux_get_max_sessions(ipc_imem->mux)) {
+		return ipc_mux_open_session(ipc_imem->mux, vlan_id - 1);
+	} else if (vlan_id > 256 && vlan_id < 512) {
+		int ch_id =
+			imem_channel_alloc(ipc_imem, vlan_id, IPC_CTYPE_WWAN);
+
+		if (imem_channel_open(ipc_imem, ch_id, IPC_HP_NET_CHANNEL_INIT))
+			return ch_id;
+	}
+
+	return -1;
+}
+
+/* Release a net link to CP. */
+void imem_sys_wwan_close(struct iosm_imem *ipc_imem, int vlan_id,
+			 int channel_id)
+{
+	if (ipc_imem->mux && vlan_id > 0 &&
+	    vlan_id <= ipc_mux_get_max_sessions(ipc_imem->mux))
+		ipc_mux_close_session(ipc_imem->mux, vlan_id - 1);
+
+	else if ((vlan_id > 256 && vlan_id < 512))
+		imem_channel_close(ipc_imem, channel_id);
+}
+
+/* Tasklet call to do uplink transfer. */
+static int imem_tq_sio_write(struct iosm_imem *ipc_imem, int arg, void *msg,
+			     size_t size)
+{
+	ipc_imem->ev_sio_write_pending = false;
+	imem_ul_send(ipc_imem);
+
+	return 0;
+}
+
+/* Through tasklet to do sio write. */
+static bool imem_call_sio_write(struct iosm_imem *ipc_imem)
+{
+	if (ipc_imem->ev_sio_write_pending)
+		return false;
+
+	ipc_imem->ev_sio_write_pending = true;
+
+	return (!ipc_task_queue_send_task(ipc_imem, imem_tq_sio_write, 0, NULL,
+					  0, false));
+}
+
+/* Add skb to the ul list */
+static int imem_wwan_transmit(struct iosm_imem *ipc_imem, int vlan_id,
+			      int channel_id, struct sk_buff *skb)
+{
+	struct ipc_mem_channel *channel;
+
+	channel = &ipc_imem->channels[channel_id];
+
+	if (channel->state != IMEM_CHANNEL_ACTIVE) {
+		dev_err(ipc_imem->dev, "invalid state of channel %d",
+			channel_id);
+		return -1;
+	}
+
+	if (ipc_pcie_addr_map(ipc_imem->pcie, skb->data, skb->len,
+			      &IPC_CB(skb)->mapping, DMA_TO_DEVICE)) {
+		dev_err(ipc_imem->dev, "failed to map skb");
+		IPC_CB(skb)->direction = DMA_TO_DEVICE;
+		IPC_CB(skb)->len = skb->len;
+		IPC_CB(skb)->op_type = UL_DEFAULT;
+		return -1;
+	}
+
+	/* Add skb to the uplink skbuf accumulator */
+	skb_queue_tail(&channel->ul_list, skb);
+	imem_call_sio_write(ipc_imem);
+
+	return 0;
+}
+
+/* Function for transfer UL data */
+int imem_sys_wwan_transmit(struct iosm_imem *ipc_imem, int vlan_id,
+			   int channel_id, struct sk_buff *skb)
+{
+	int ret = -1;
+
+	if (!ipc_imem || channel_id < 0)
+		return -EINVAL;
+
+	/* Is CP Running? */
+	if (ipc_imem->phase != IPC_P_RUN) {
+		dev_dbg(ipc_imem->dev, "%s[transmit, vlanid:%d]",
+			ipc_ap_phase_get_string(ipc_imem->phase), vlan_id);
+		return -EBUSY;
+	}
+
+	if (ipc_imem->channels[channel_id].ctype == IPC_CTYPE_WWAN) {
+		if (vlan_id > 0 &&
+		    vlan_id <= ipc_mux_get_max_sessions(ipc_imem->mux))
+			/* Route the UL packet through IP MUX Layer */
+			ret = ipc_mux_ul_trigger_encode(ipc_imem->mux,
+							vlan_id - 1, skb);
+		/* Control channels and Low latency data channel for VoLTE*/
+		else if (vlan_id > 256 && vlan_id < 512)
+			ret = imem_wwan_transmit(ipc_imem, vlan_id, channel_id,
+						 skb);
+	} else {
+		dev_err(ipc_imem->dev,
+			"invalid channel type on channel %d: ctype: %d",
+			channel_id, ipc_imem->channels[channel_id].ctype);
+	}
+
+	return ret;
+}
+
+void wwan_channel_init(struct iosm_imem *ipc_imem, int total_sessions,
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
+	while (ipc_imem->nr_of_channels < IPC_MEM_MAX_CHANNELS &&
+	       !ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels)) {
+		imem_channel_init(ipc_imem, IPC_CTYPE_WWAN, chnl_cfg,
+				  IRQ_MOD_OFF);
+	}
+	/* WWAN registration. */
+	ipc_imem->wwan = ipc_wwan_init(ipc_imem, ipc_imem->dev, total_sessions);
+	if (!ipc_imem->wwan)
+		dev_err(ipc_imem->dev,
+			"failed to register the ipc_wwan interfaces");
+}
+
+/* Copies the data from user space */
+static struct sk_buff *
+imem_sio_copy_from_user_to_skb(struct iosm_imem *ipc_imem, int channel_id,
+			       const unsigned char __user *buf, int size,
+			       int is_blocking)
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
+	if (copy_from_user(skb_put(skb, size), buf, size) != 0) {
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
+static int imem_psi_transfer(struct iosm_imem *ipc_imem,
+			     struct ipc_mem_channel *channel,
+			     const unsigned char __user *buf, int count)
+{
+	enum ipc_mem_exec_stage exec_stage = IPC_MEM_EXEC_STAGE_INVALID;
+	int psi_start_timeout = PSI_START_DEFAULT_TIMEOUT;
+	dma_addr_t mapping = 0;
+	int status;
+	void *dest_buf;
+
+	imem_hrtimer_stop(&ipc_imem->startup_timer);
+
+	/* Allocate the buffer for the PSI image. */
+	dest_buf = pci_alloc_consistent(ipc_imem->pcie->pci, count, &mapping);
+	if (!dest_buf) {
+		dev_err(ipc_imem->dev, "ch[%d] cannot allocate %d bytes",
+			channel->channel_id, count);
+		return -1;
+	}
+
+	/* Copy the PSI image from user to kernel space. */
+	if (copy_from_user(dest_buf, buf, count) != 0) {
+		dev_err(ipc_imem->dev, "ch[%d] copy from user failed",
+			channel->channel_id);
+		goto error;
+	}
+
+	/* Save the PSI information for the CP ROM driver on the doorbell
+	 * scratchpad.
+	 */
+	ipc_mmio_set_psi_addr_and_size(ipc_imem->mmio, mapping, count);
+
+	/* Trigger the CP interrupt to process the PSI information. */
+	ipc_doorbell_fire(ipc_imem->pcie, 0, IPC_MEM_EXEC_STAGE_BOOT);
+	/* Suspend the flash app and wait for irq. */
+	status = wait_for_completion_interruptible_timeout
+			(&channel->ul_sem,
+			 msecs_to_jiffies(IPC_PSI_TRANSFER_TIMEOUT));
+
+	if (status <= 0) {
+		dev_err(ipc_imem->dev,
+			"ch[%d] timeout, failed PSI transfer to CP",
+			channel->channel_id);
+		ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_TIMEOUT);
+		goto error;
+	}
+
+	/* CP should have copied the PSI image. */
+	pci_free_consistent(ipc_imem->pcie->pci, count, dest_buf, mapping);
+
+	/* If the PSI download fails, return the CP boot ROM exit code to the
+	 * flash app received about the doorbell scratchpad.
+	 */
+	if (ipc_imem->rom_exit_code != IMEM_ROM_EXIT_OPEN_EXT &&
+	    ipc_imem->rom_exit_code != IMEM_ROM_EXIT_CERT_EXT)
+		return (-1) * ((int)ipc_imem->rom_exit_code);
+
+	dev_dbg(ipc_imem->dev, "PSI image successfully downloaded");
+
+	/* Wait psi_start_timeout milliseconds until the CP PSI image is
+	 * running and updates the execution_stage field with
+	 * IPC_MEM_EXEC_STAGE_PSI. Verify the execution stage.
+	 */
+	do {
+		exec_stage = ipc_mmio_get_exec_stage(ipc_imem->mmio);
+
+		if (exec_stage == IPC_MEM_EXEC_STAGE_PSI)
+			break;
+
+		msleep(20);
+		psi_start_timeout -= 20;
+	} while (psi_start_timeout > 0);
+
+	if (exec_stage != IPC_MEM_EXEC_STAGE_PSI)
+		return -1; /* Unknown status of the CP PSI process. */
+
+	/* Enter the PSI phase. */
+	dev_dbg(ipc_imem->dev, "execution_stage[%X] eq. PSI", exec_stage);
+
+	ipc_imem->phase = IPC_P_PSI;
+
+	/* Request the RUNNING state from CP and wait until it was reached
+	 * or timeout.
+	 */
+	imem_ipc_init_check(ipc_imem);
+
+	/* Suspend the flash app, wait for irq and evaluate the CP IPC state. */
+	status = wait_for_completion_interruptible_timeout
+		 (&channel->ul_sem, msecs_to_jiffies(IPC_PSI_TRANSFER_TIMEOUT));
+	if (status <= 0) {
+		dev_err(ipc_imem->dev,
+			"ch[%d] timeout, failed PSI RUNNING state on CP",
+			channel->channel_id);
+		ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_TIMEOUT);
+		return -1;
+	}
+
+	if (ipc_mmio_get_ipc_state(ipc_imem->mmio) !=
+	    IPC_MEM_DEVICE_IPC_RUNNING) {
+		dev_err(ipc_imem->dev,
+			"ch[%d] %s: unexpected CP IPC state %d, not RUNNING",
+			channel->channel_id,
+			ipc_ap_phase_get_string(ipc_imem->phase),
+			ipc_mmio_get_ipc_state(ipc_imem->mmio));
+
+		return -1;
+	}
+
+	/* Create the flash channel for the transfer of the images. */
+	if (!imem_sys_sio_open(ipc_imem)) {
+		dev_err(ipc_imem->dev, "can't open flash_channel");
+		return -1;
+	}
+
+	/* Inform the flash app that the PSI was sent and start on CP.
+	 * The flash app shall wait for the CP status in blocking read
+	 * entry point.
+	 */
+	return count;
+error:
+	pci_free_consistent(ipc_imem->pcie->pci, count, dest_buf, mapping);
+
+	return -1;
+}
+
+/* Get the write active channel */
+static struct ipc_mem_channel *
+imem_sio_write_channel(struct iosm_imem *ipc_imem,
+		       struct ipc_mem_channel *channel,
+		       const unsigned char __user *buf, int size)
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
+void imem_sys_sio_close(struct iosm_sio *ipc_sio)
+{
+	struct iosm_imem *ipc_imem = ipc_sio->ipc_imem;
+	struct ipc_mem_channel *channel = ipc_sio->channel;
+	enum ipc_phase curr_phase;
+	int boot_check_timeout = 0;
+	int status = 0;
+	u32 tail = 0;
+
+	if (channel->channel_id != IPC_MEM_MBIM_CTRL_CH_ID)
+		boot_check_timeout = BOOT_CHECK_DEFAULT_TIMEOUT;
+
+	curr_phase = ipc_imem->phase;
+
+	/* If current phase is IPC_P_OFF or SIO ID is -ve then
+	 * channel is already freed. Nothing to do.
+	 */
+	if (curr_phase == IPC_P_OFF || channel->sio_id < 0) {
+		dev_err(ipc_imem->dev,
+			"nothing to do. Current Phase: %s SIO ID: %d",
+			ipc_ap_phase_get_string(curr_phase), channel->sio_id);
+		return;
+	}
+
+	if (channel->state == IMEM_CHANNEL_FREE) {
+		dev_err(ipc_imem->dev, "ch[%d]: invalid channel state %d",
+			channel->channel_id, channel->state);
+		return;
+	}
+	/* Free only the channel id in the CP power off mode. */
+	if (channel->state == IMEM_CHANNEL_RESERVED) {
+		imem_channel_free(channel);
+		return;
+	}
+
+	if (channel->channel_id != IPC_MEM_MBIM_CTRL_CH_ID &&
+	    ipc_imem->flash_channel_id >= 0) {
+		int i;
+		enum ipc_mem_exec_stage exec_stage;
+
+		/* Increase the total wait time to boot_check_timeout */
+		for (i = 0; i < boot_check_timeout; i++) {
+			/* user space can terminate either the modem is finished
+			 * with Downloading or finished transferring Coredump.
+			 */
+			exec_stage = ipc_mmio_get_exec_stage(ipc_imem->mmio);
+			if (exec_stage == IPC_MEM_EXEC_STAGE_RUN ||
+			    exec_stage == IPC_MEM_EXEC_STAGE_PSI)
+				break;
+
+			msleep(20);
+		}
+
+		msleep(100);
+	}
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
+	/* Release the pipe resources */
+	if (channel->channel_id != IPC_MEM_MBIM_CTRL_CH_ID &&
+	    ipc_imem->flash_channel_id != -1) {
+		/* don't send close for software download pipes, as
+		 * the device is already rebooting
+		 */
+		imem_pipe_cleanup(ipc_imem, &channel->ul_pipe);
+		imem_pipe_cleanup(ipc_imem, &channel->dl_pipe);
+	} else {
+		imem_pipe_close(ipc_imem, &channel->ul_pipe);
+		imem_pipe_close(ipc_imem, &channel->dl_pipe);
+	}
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
+	channel = imem_channel_open(ipc_imem, ch_id, IPC_HP_SIO_OPEN);
+
+	if (!channel) {
+		dev_err(ipc_imem->dev, "MBIM channel id open failed");
+		return NULL;
+	}
+
+	return channel;
+}
+
+/* Open a SIO link to CP and return the channel id. */
+struct ipc_mem_channel *imem_sys_sio_open(struct iosm_imem *ipc_imem)
+{
+	struct ipc_chnl_cfg chnl_cfg = { 0 };
+	enum ipc_phase phase;
+	int channel_id;
+	struct ipc_mem_channel *channel;
+
+	phase = imem_ap_phase_update(ipc_imem);
+
+	/* The control link to CP is only supported in the power off, psi or
+	 * run phase.
+	 */
+	switch (phase) {
+	case IPC_P_OFF:
+	case IPC_P_ROM:
+		/* Get a channel id as flash id and reserve it. */
+		channel_id = imem_channel_alloc(ipc_imem, IPC_MEM_FLASH_CH_ID,
+						IPC_CTYPE_FLASH);
+		if (channel_id < 0) {
+			dev_err(ipc_imem->dev,
+				"reservation of a flash channel id failed");
+			return NULL;
+		}
+
+		/* Enqueue chip info data to be read */
+		if (imem_trigger_chip_info(ipc_imem)) {
+			imem_channel_close(ipc_imem, channel_id);
+			return NULL;
+		}
+
+		/* Save the flash channel id to execute the ROM interworking. */
+		ipc_imem->flash_channel_id = channel_id;
+
+		channel = &ipc_imem->channels[channel_id];
+		return channel;
+
+	case IPC_P_PSI:
+	case IPC_P_EBL:
+		/* The channel id used as flash id shall be already
+		 * present as reserved.
+		 */
+		if (ipc_imem->flash_channel_id < 0) {
+			dev_err(ipc_imem->dev,
+				"missing a valid flash channel id");
+			return NULL;
+		}
+		channel_id = ipc_imem->flash_channel_id;
+
+		ipc_imem->cp_version = ipc_mmio_get_cp_version(ipc_imem->mmio);
+		if (ipc_imem->cp_version == -1) {
+			dev_err(ipc_imem->dev, "invalid CP version");
+			return NULL;
+		}
+
+		/* PSI may have changed the CP version field, which may
+		 * result in a different channel configuration.
+		 * Fetch and update the flash channel config
+		 */
+		if (ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->flash_channel_id)) {
+			dev_err(ipc_imem->dev,
+				"failed to get flash pipe configuration");
+			return NULL;
+		}
+
+		ipc_imem_channel_update(ipc_imem, channel_id, chnl_cfg,
+					IRQ_MOD_OFF);
+
+		channel = imem_channel_open(ipc_imem, channel_id,
+					    IPC_HP_SIO_OPEN);
+		if (!channel)
+			return NULL;
+
+		return channel;
+
+	default:
+		/* CP is in the wrong state (e.g. CRASH or CD_READY) */
+		dev_err(ipc_imem->dev, "SIO open refused, phase %d", phase);
+		return NULL;
+	}
+}
+
+ssize_t imem_sys_sio_read(struct iosm_sio *ipc_sio, unsigned char __user *buf,
+			  size_t size, struct sk_buff *skb)
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
+			dev_err(ipc_sio->dev,
+				"chid[%d] userspace copy failed n=%zu\n",
+				ipc_sio->channel->channel_id, copied_b);
+			ipc_pcie_kfree_skb(ipc_sio->pcie, skb);
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
+				ipc_pcie_kfree_skb(ipc_sio->pcie, skb);
+			else
+				ipc_sio->rx_pending_buf = skb;
+
+			/* Return the number of saved chars. */
+			break;
+		}
+
+		/* Free the consumed skbuf. */
+		ipc_pcie_kfree_skb(ipc_sio->pcie, skb);
+
+		/* Get the next skbuf element. */
+		skb = skb_dequeue(&ipc_sio->rx_list);
+	}
+
+	/* Return the number of saved chars. */
+	copied_b = dest_buf - buf;
+	return copied_b;
+}
+
+int imem_sys_sio_write(struct iosm_sio *ipc_sio,
+		       const unsigned char __user *buf, int count,
+		       bool blocking_write)
+{
+	struct iosm_imem *ipc_imem = ipc_sio->ipc_imem;
+	struct ipc_mem_channel *channel = ipc_sio->channel;
+	struct sk_buff *skb;
+	int ret = -1;
+
+	set_bit(WRITE_IN_USE, &ipc_sio->flag);
+	/* Applying memory barrier so that ipc_sio->flag is updated
+	 * before being read
+	 */
+	smp_mb__after_atomic();
+
+	channel = imem_sio_write_channel(ipc_imem, channel, buf, count);
+
+	if (!channel || ipc_imem->phase == IPC_P_OFF_REQ)
+		goto err;
+
+	/* In the ROM phase the PSI image is passed to CP about a specific
+	 * shared memory area and doorbell scratchpad directly.
+	 */
+	if (ipc_imem->phase == IPC_P_ROM) {
+		ret = imem_psi_transfer(ipc_imem, channel, buf, count);
+
+		/* If the PSI transfer fails then send crash
+		 * Signature.
+		 */
+		if (ret > 0)
+			imem_msg_send_feature_set(ipc_imem,
+						  IPC_MEM_INBAND_CRASH_SIG,
+						  false);
+		goto err;
+	}
+
+	/* Allocate skb memory for the uplink buffer.*/
+	skb = imem_sio_copy_from_user_to_skb(ipc_imem, channel->channel_id, buf,
+					     count, blocking_write);
+	if (!skb)
+		goto err;
+
+	/* Add skb to the uplink skbuf accumulator. */
+	skb_queue_tail(&channel->ul_list, skb);
+
+	/* Inform the IPC tasklet to pass uplink IP packets to CP.
+	 * Blocking write waits for UL completion notification,
+	 * non-blocking write simply returns the count.
+	 */
+	if (imem_call_sio_write(ipc_imem) && blocking_write) {
+		/* Suspend the app and wait for UL data completion. */
+		ret = wait_for_completion_interruptible(&channel->ul_sem);
+
+		if (ret < 0) {
+			dev_err(ipc_imem->dev,
+				"ch[%d] no CP confirmation, status=%d",
+				channel->channel_id, ret);
+			goto err;
+		}
+	}
+	ret = count;
+err:
+	clear_bit(WRITE_IN_USE, &ipc_sio->flag);
+	/* Applying memory barrier so that ipc_sio->flag is updated
+	 * before being read
+	 */
+	smp_mb__after_atomic();
+	return ret;
+}
+
+int imem_sys_sio_receive(struct iosm_sio *ipc_sio, struct sk_buff *skb)
+{
+	skb_queue_tail((&ipc_sio->rx_list), skb);
+
+	if (test_bit(IS_BLOCKING, &ipc_sio->flag))
+		complete(&ipc_sio->read_sem);
+	else if (!test_bit(IS_BLOCKING, &ipc_sio->flag))
+		wake_up_interruptible(&ipc_sio->poll_inq);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
new file mode 100644
index 000000000000..75af9d838742
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_IMEM_OPS_H
+#define IOSM_IPC_IMEM_OPS_H
+
+#include "iosm_ipc_mux_codec.h"
+
+/* Maximum length of the SIO device names */
+#define IPC_SIO_DEVNAME_LEN 32
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
+/**
+ * imem_sys_sio_open - Open a sio link to CP.
+ * @ipc_imem:	Imem instance.
+ *
+ * Return: channel instance on success, NULL for failure
+ */
+struct ipc_mem_channel *imem_sys_sio_open(struct iosm_imem *ipc_imem);
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
+ * imem_sys_sio_close - Release a sio link to CP.
+ * @ipc_sio:		iosm sio instance.
+ */
+void imem_sys_sio_close(struct iosm_sio *ipc_sio);
+
+/**
+ * imem_sys_sio_read - Copy the rx data to the user space buffer and free the
+ *		       skbuf.
+ * @ipc_sio:	Pointer to iosm_sio structi.
+ * @buf:	Pointer to destination buffer.
+ * @size:	Size of destination buffer.
+ * @skb:	Pointer to source buffer.
+ *
+ * Return: Number of bytes read, -EFAULT and -EINVAL for failure
+ */
+ssize_t imem_sys_sio_read(struct iosm_sio *ipc_sio, unsigned char __user *buf,
+			  size_t size, struct sk_buff *skb);
+
+/**
+ * imem_sys_sio_write - Route the uplink buffer to CP.
+ * @ipc_sio:		iosm_sio instance.
+ * @buf:		Pointer to source buffer.
+ * @count:		Number of data bytes to write.
+ * @blocking_write:	if true wait for UL data completion.
+ *
+ * Return: Number of bytes read, -EINVAL and -1  for failure
+ */
+int imem_sys_sio_write(struct iosm_sio *ipc_sio,
+		       const unsigned char __user *buf, int count,
+		       bool blocking_write);
+
+/**
+ * imem_sys_sio_receive - Receive downlink characters from CP, the downlink
+ *		skbuf is added at the end of the downlink or rx list.
+ * @ipc_sio:    Pointer to ipc char data-struct
+ * @skb:        Pointer to sk buffer
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ */
+int imem_sys_sio_receive(struct iosm_sio *ipc_sio, struct sk_buff *skb);
+
+/**
+ * imem_sys_wwan_open - Open packet data online channel between network layer
+ *			and CP.
+ * @ipc_imem:		Imem instance.
+ * @vlan_id:		VLAN tag of the VLAN device.
+ *
+ * Return: Channel ID on success, -1 on failure
+ */
+int imem_sys_wwan_open(struct iosm_imem *ipc_imem, int vlan_id);
+
+/**
+ * imem_sys_wwan_close - Close packet data online channel between network layer
+ *			 and CP.
+ * @ipc_imem:		Imem instance.
+ * @vlan_id:		VLAN tag of the VLAN device.
+ * @channel_id:		Channel ID to be closed.
+ */
+void imem_sys_wwan_close(struct iosm_imem *ipc_imem, int vlan_id,
+			 int channel_id);
+
+/**
+ * imem_sys_wwan_transmit - Function for transfer UL data
+ * @ipc_imem:		Imem instance.
+ * @vlan_id:		VLAN tag of the VLAN device.
+ * @channel_id:		Channel ID used
+ * @skb:		Pointer to sk buffer
+ *
+ * Return: 0 on success, negative value on failure
+ */
+int imem_sys_wwan_transmit(struct iosm_imem *ipc_imem, int vlan_id,
+			   int channel_id, struct sk_buff *skb);
+/**
+ * wwan_channel_init - Initializes WWAN channels and the channel for MUX.
+ * @ipc_imem:		Pointer to iosm_imem struct.
+ * @total_sessions:	Total sessions.
+ * @mux_type:		Type of mux protocol.
+ */
+void wwan_channel_init(struct iosm_imem *ipc_imem, int total_sessions,
+		       enum ipc_mux_protocol mux_type);
+#endif
-- 
2.12.3

