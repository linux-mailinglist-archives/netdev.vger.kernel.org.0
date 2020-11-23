Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F310C2C0C38
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgKWNwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:03 -0500
IronPort-SDR: uh+k3GaCQSkiL32ulq9mH4CcFElO0Jm11PWkTinFBDJWH6xlgp4ber8KSfdjRBKybkdSwH6qzu
 OLztLQ/xouJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981430"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981430"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:01 -0800
IronPort-SDR: Ww9AaGlhAfGyRUQ6LJT5xyDF1atjaDfnOgi387oyIU2NM2jNQu79p40q5v2a0b7V5WD9TqB6Ov
 f0kU1f7oRsSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035499"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:51:58 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 04/18] net: iosm: shared memory IPC interface
Date:   Mon, 23 Nov 2020 19:21:09 +0530
Message-Id: <20201123135123.48892-5-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Initializes shared memory for host-device communication.
2) Allocate resources required for control & data operations.
3) Transfers the Device IRQ to IPC execution thread.
4) Defines the timer cbs for async events.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 1466 +++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.h |  606 ++++++++++++++
 2 files changed, 2072 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
new file mode 100644
index 000000000000..7c26e2fdf77b
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -0,0 +1,1466 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/if_vlan.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_mbim.h"
+#include "iosm_ipc_sio.h"
+#include "iosm_ipc_task_queue.h"
+
+/* Check the wwan ips if it is valid with Channel as input. */
+static inline int ipc_imem_check_wwan_ips(struct ipc_mem_channel *chnl)
+{
+	if (chnl)
+		return chnl->ctype == IPC_CTYPE_WWAN &&
+		       chnl->vlan_id == IPC_MEM_MUX_IP_CH_VLAN_ID;
+	return false;
+}
+
+static int imem_msg_send_device_sleep(struct iosm_imem *ipc_imem, u32 state)
+{
+	union ipc_msg_prep_args prep_args = {
+		.sleep.target = 1,
+		.sleep.state = state,
+	};
+
+	ipc_imem->device_sleep = state;
+
+	return ipc_protocol_tq_msg_send(ipc_imem->ipc_protocol,
+					IPC_MSG_PREP_SLEEP, &prep_args, NULL);
+}
+
+static bool imem_dl_skb_alloc(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe)
+{
+	/* limit max. nr of entries */
+	if (pipe->nr_of_queued_entries >= pipe->max_nr_of_queued_entries)
+		return false;
+
+	return ipc_protocol_dl_td_prepare(ipc_imem->ipc_protocol, pipe);
+}
+
+/* This timer handler will retry DL buff allocation if a pipe has no free buf */
+static int imem_tq_td_alloc_timer(void *instance, int arg, void *msg,
+				  size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+	bool new_buffers_available = false;
+	bool retry_allocation = false;
+	int i;
+
+	for (i = 0; i < IPC_MEM_MAX_CHANNELS; i++) {
+		struct ipc_pipe *pipe = &ipc_imem->channels[i].dl_pipe;
+
+		if (!pipe->is_open || pipe->nr_of_queued_entries > 0)
+			continue;
+
+		while (imem_dl_skb_alloc(ipc_imem, pipe))
+			new_buffers_available = true;
+
+		if (pipe->nr_of_queued_entries == 0)
+			retry_allocation = true;
+	}
+
+	if (new_buffers_available)
+		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+					      IPC_HP_DL_PROCESS);
+
+	if (retry_allocation)
+		imem_hrtimer_start(ipc_imem, &ipc_imem->td_alloc_timer,
+				   IPC_TD_ALLOC_TIMER_PERIOD_MS * 1000);
+	return 0;
+}
+
+static enum hrtimer_restart imem_td_alloc_timer_cb(struct hrtimer *hr_timer)
+{
+	struct iosm_imem *ipc_imem =
+		container_of(hr_timer, struct iosm_imem, td_alloc_timer);
+	/* Post an async tasklet event to trigger HP update Doorbell */
+	ipc_task_queue_send_task(ipc_imem, imem_tq_td_alloc_timer, 0, NULL, 0,
+				 false);
+	return HRTIMER_NORESTART;
+}
+
+/* Fast update timer tasklet handler to trigger HP update */
+static int imem_tq_fast_update_timer_cb(void *instance, int arg, void *msg,
+					size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+
+	ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+				      IPC_HP_FAST_TD_UPD_TMR);
+
+	return 0;
+}
+
+static enum hrtimer_restart imem_fast_update_timer_cb(struct hrtimer *hr_timer)
+{
+	struct iosm_imem *ipc_imem =
+		container_of(hr_timer, struct iosm_imem, fast_update_timer);
+	/* Post an async tasklet event to trigger HP update Doorbell */
+	ipc_task_queue_send_task(ipc_imem, imem_tq_fast_update_timer_cb, 0,
+				 NULL, 0, false);
+	return HRTIMER_NORESTART;
+}
+
+static void
+imem_hrtimer_init(struct hrtimer *hr_timer,
+		  enum hrtimer_restart (*callback)(struct hrtimer *hr_timer))
+{
+	hrtimer_init(hr_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hr_timer->function = callback;
+}
+
+static int imem_setup_cp_mux_cap_init(struct iosm_imem *ipc_imem,
+				      struct ipc_mux_config *cfg)
+{
+	ipc_mmio_update_cp_capability(ipc_imem->mmio);
+
+	if (!ipc_imem->mmio->has_mux_lite) {
+		dev_err(ipc_imem->dev, "Failed to get Mux capability.");
+		return -1;
+	}
+
+	cfg->protocol = MUX_LITE;
+
+	cfg->ul_flow = (ipc_imem->mmio->has_ul_flow_credit == 1) ?
+			       MUX_UL_ON_CREDITS :
+			       MUX_UL;
+
+	/* The instance ID is same as channel ID because this is been reused
+	 * for channel alloc function.
+	 */
+	cfg->instance_id = IPC_MEM_MUX_IP_CH_VLAN_ID;
+	cfg->nr_sessions = IPC_MEM_MUX_IP_SESSION_ENTRIES;
+
+	return 0;
+}
+
+void imem_msg_send_feature_set(struct iosm_imem *ipc_imem,
+			       unsigned int reset_enable, bool atomic_ctx)
+{
+	union ipc_msg_prep_args prep_args = { .feature_set.reset_enable =
+						      reset_enable };
+
+	if (atomic_ctx)
+		ipc_protocol_tq_msg_send(ipc_imem->ipc_protocol,
+					 IPC_MSG_PREP_FEATURE_SET, &prep_args,
+					 NULL);
+	else
+		ipc_protocol_msg_send(ipc_imem->ipc_protocol,
+				      IPC_MSG_PREP_FEATURE_SET, &prep_args);
+}
+
+void imem_hrtimer_start(struct iosm_imem *ipc_imem, struct hrtimer *hr_timer,
+			unsigned long period)
+{
+	ipc_imem->hrtimer_period = ktime_set(0, period * 1000ULL);
+	if (!hrtimer_active(hr_timer) && period != 0)
+		hrtimer_start(hr_timer, ipc_imem->hrtimer_period,
+			      HRTIMER_MODE_REL);
+}
+
+void imem_td_update_timer_start(struct iosm_imem *ipc_imem)
+{
+	/* Use the UL timer only in the runtime phase and
+	 * trigger the doorbell irq on CP directly.
+	 */
+	if (!ipc_imem->enter_runtime || ipc_imem->td_update_timer_suspended) {
+		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+					      IPC_HP_TD_UPD_TMR_START);
+		return;
+	}
+
+	if (!hrtimer_active(&ipc_imem->tdupdate_timer))
+		imem_hrtimer_start(ipc_imem, &ipc_imem->tdupdate_timer,
+				   TD_UPDATE_DEFAULT_TIMEOUT_USEC);
+}
+
+void imem_hrtimer_stop(struct hrtimer *hr_timer)
+{
+	if (hrtimer_active(hr_timer))
+		hrtimer_cancel(hr_timer);
+}
+
+bool imem_ul_write_td(struct iosm_imem *ipc_imem)
+{
+	struct ipc_mem_channel *channel;
+	struct sk_buff_head *ul_list;
+	bool hpda_pending = false;
+	bool forced_hpdu = false;
+	struct ipc_pipe *pipe;
+	int i;
+
+	/* Analyze the uplink pipe of all active channels. */
+	for (i = 0; i < ipc_imem->nr_of_channels; i++) {
+		channel = &ipc_imem->channels[i];
+
+		if (channel->state != IMEM_CHANNEL_ACTIVE)
+			continue;
+
+		pipe = &channel->ul_pipe;
+
+		/* Get the reference to the skbuf accumulator list. */
+		ul_list = &channel->ul_list;
+
+		/* Fill the transfer descriptor with the uplink buffer info. */
+		hpda_pending |= ipc_protocol_ul_td_send(ipc_imem->ipc_protocol,
+							pipe, ul_list);
+
+		/* forced HP update needed for non data channels */
+		if (hpda_pending && !ipc_imem_check_wwan_ips(channel))
+			forced_hpdu = true;
+	}
+
+	if (forced_hpdu) {
+		hpda_pending = false;
+		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+					      IPC_HP_UL_WRITE_TD);
+	}
+
+	return hpda_pending;
+}
+
+void imem_ipc_init_check(struct iosm_imem *ipc_imem)
+{
+	int timeout = IPC_MODEM_BOOT_TIMEOUT;
+
+	/* Trigger the CP interrupt to enter the init state. */
+	ipc_imem->ipc_requested_state = IPC_MEM_DEVICE_IPC_INIT;
+
+	ipc_doorbell_fire(ipc_imem->pcie, IPC_DOORBELL_IRQ_IPC,
+			  IPC_MEM_DEVICE_IPC_INIT);
+	/* Wait for the CP update. */
+	do {
+		if (ipc_mmio_get_ipc_state(ipc_imem->mmio) ==
+		    ipc_imem->ipc_requested_state) {
+			/* Prepare the MMIO space */
+			ipc_mmio_config(ipc_imem->mmio);
+
+			/* Trigger the CP irq to enter the running state. */
+			ipc_imem->ipc_requested_state =
+				IPC_MEM_DEVICE_IPC_RUNNING;
+			ipc_doorbell_fire(ipc_imem->pcie, IPC_DOORBELL_IRQ_IPC,
+					  IPC_MEM_DEVICE_IPC_RUNNING);
+
+			return;
+		}
+		msleep(20);
+	} while (--timeout);
+
+	/* timeout */
+	dev_err(ipc_imem->dev, "%s: ipc_status(%d) ne. IPC_MEM_DEVICE_IPC_INIT",
+		ipc_ap_phase_get_string(ipc_imem->phase),
+		ipc_mmio_get_ipc_state(ipc_imem->mmio));
+
+	ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_TIMEOUT);
+}
+
+/* Analyze the packet type and distribute it. */
+static void imem_dl_skb_process(struct iosm_imem *ipc_imem,
+				struct ipc_pipe *pipe, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	/* An AT/control or IP packet is expected. */
+	switch (pipe->channel->ctype) {
+	case IPC_CTYPE_FLASH:
+		/* Pass the packet to the char layer. */
+		if (imem_sys_sio_receive(ipc_imem->sio, skb))
+			goto rcv_err;
+		break;
+
+	case IPC_CTYPE_MBIM:
+		/* Pass the packet to the char layer. */
+		if (imem_sys_sio_receive(ipc_imem->mbim, skb))
+			goto rcv_err;
+		break;
+
+	case IPC_CTYPE_WWAN:
+		/* drop the packet if vlan id = 0 */
+		if (pipe->channel->vlan_id == 0)
+			goto rcv_err;
+
+		if (pipe->channel->vlan_id > 256 &&
+		    pipe->channel->vlan_id < 512) {
+			if (pipe->channel->state != IMEM_CHANNEL_ACTIVE)
+				goto rcv_err;
+
+			skb_push(skb, ETH_HLEN);
+			/* map session to vlan */
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       pipe->channel->vlan_id);
+
+			IPC_CB(skb)->mapping = 0;
+			/* unmap skb from address mapping */
+			ipc_pcie_addr_unmap(ipc_imem->pcie, IPC_CB(skb)->len,
+					    IPC_CB(skb)->mapping,
+					    IPC_CB(skb)->direction);
+
+			if (ipc_wwan_receive(ipc_imem->wwan, skb, true))
+				pipe->channel->net_err_count++;
+			/* DL packet through IP MUX layer */
+		} else if (pipe->channel->vlan_id ==
+			   IPC_MEM_MUX_IP_CH_VLAN_ID) {
+			ipc_mux_dl_decode(ipc_imem->mux, skb);
+		}
+		break;
+	default:
+		dev_err(ipc_imem->dev, "Invalid channel type");
+		break;
+	}
+	return;
+
+rcv_err:
+	ipc_pcie_kfree_skb(ipc_imem->pcie, skb);
+}
+
+/* Process the downlink data and pass them to the char or net layer. */
+static void imem_dl_pipe_process(struct iosm_imem *ipc_imem,
+				 struct ipc_pipe *pipe)
+{
+	s32 cnt = 0, processed_td_cnt = 0;
+	struct ipc_mem_channel *channel;
+	u32 head = 0, tail = 0;
+	bool processed = false;
+	struct sk_buff *skb;
+
+	channel = pipe->channel;
+
+	ipc_protocol_get_head_tail_index(ipc_imem->ipc_protocol, pipe, &head,
+					 &tail);
+	if (pipe->old_tail != tail) {
+		if (pipe->old_tail < tail)
+			cnt = tail - pipe->old_tail;
+		else
+			cnt = pipe->nr_of_entries - pipe->old_tail + tail;
+	}
+
+	processed_td_cnt = cnt;
+
+	/* Seek for pipes with pending DL data. */
+	while (cnt--) {
+		skb = ipc_protocol_dl_td_process(ipc_imem->ipc_protocol, pipe);
+
+		/* Analyze the packet type and distribute it. */
+		imem_dl_skb_process(ipc_imem, pipe, skb);
+	}
+
+	/* try to allocate new empty DL SKbs from head..tail - 1*/
+	while (imem_dl_skb_alloc(ipc_imem, pipe))
+		processed = true;
+
+	/* flush net interfaces if needed */
+	if (processed && !ipc_imem_check_wwan_ips(channel)) {
+		/* Force HP update for non IP channels */
+		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+					      IPC_HP_DL_PROCESS);
+		processed = false;
+
+		/* If Fast Update timer is already running then stop */
+		imem_hrtimer_stop(&ipc_imem->fast_update_timer);
+	}
+
+	/* Any control channel process will get immediate HP update.
+	 * Start Fast update timer only for IP channel if all the TDs were
+	 * used in last process.
+	 */
+	if (processed && (processed_td_cnt == pipe->nr_of_entries - 1))
+		imem_hrtimer_start(ipc_imem, &ipc_imem->fast_update_timer,
+				   FORCE_UPDATE_DEFAULT_TIMEOUT_USEC);
+
+	if (ipc_imem->app_notify_dl_pend)
+		complete(&ipc_imem->dl_pend_sem);
+}
+
+/* Free the uplink buffer. */
+static void imem_ul_pipe_process(struct iosm_imem *ipc_imem,
+				 struct ipc_pipe *pipe)
+{
+	struct ipc_mem_channel *channel;
+	u32 tail = 0, head = 0;
+	struct sk_buff *skb;
+	s32 cnt = 0;
+
+	channel = pipe->channel;
+
+	/* Get the internal phase. */
+	ipc_protocol_get_head_tail_index(ipc_imem->ipc_protocol, pipe, &head,
+					 &tail);
+
+	if (pipe->old_tail != tail) {
+		if (pipe->old_tail < tail)
+			cnt = tail - pipe->old_tail;
+		else
+			cnt = pipe->nr_of_entries - pipe->old_tail + tail;
+	}
+
+	/* Free UL buffers. */
+	while (cnt--) {
+		skb = ipc_protocol_ul_td_process(ipc_imem->ipc_protocol, pipe);
+
+		if (!skb)
+			continue;
+
+		/* If the user app was suspended in uplink direction - blocking
+		 * write, resume it.
+		 */
+		if (IPC_CB(skb)->op_type == UL_USR_OP_BLOCKED)
+			complete(&channel->ul_sem);
+
+		/* Free the skbuf element. */
+		if (IPC_CB(skb)->op_type == UL_MUX_OP_ADB) {
+			if (channel->vlan_id == IPC_MEM_MUX_IP_CH_VLAN_ID)
+				ipc_mux_ul_encoded_process(ipc_imem->mux, skb);
+			else
+				dev_err(ipc_imem->dev,
+					"Channel OP Type is UL_MUX but vlan_id %d is unknown",
+					channel->vlan_id);
+		} else {
+			ipc_pcie_kfree_skb(ipc_imem->pcie, skb);
+		}
+	}
+
+	/* Trace channel stats for IP UL pipe. */
+	if (ipc_imem_check_wwan_ips(pipe->channel)) {
+		if (channel->vlan_id == IPC_MEM_MUX_IP_CH_VLAN_ID)
+			ipc_mux_check_n_restart_tx(ipc_imem->mux);
+	}
+
+	if (ipc_imem->app_notify_ul_pend)
+		complete(&ipc_imem->ul_pend_sem);
+}
+
+/* Triggers the irq. */
+static void imem_rom_irq_exec(struct iosm_imem *ipc_imem)
+{
+	struct ipc_mem_channel *channel;
+
+	if (ipc_imem->flash_channel_id < 0) {
+		ipc_imem->rom_exit_code = IMEM_ROM_EXIT_FAIL;
+		dev_err(ipc_imem->dev, "Missing flash app:%d",
+			ipc_imem->flash_channel_id);
+		return;
+	}
+
+	ipc_imem->rom_exit_code = ipc_mmio_get_rom_exit_code(ipc_imem->mmio);
+
+	/* Wake up the flash app to continue or to terminate depending
+	 * on the CP ROM exit code.
+	 */
+	channel = &ipc_imem->channels[ipc_imem->flash_channel_id];
+	complete(&channel->ul_sem);
+}
+
+/* Execute the UL bundle timer actions. */
+static int imem_tq_td_update_timer_cb(void *instance, int arg, void *msg,
+				      size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+
+	ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
+				      IPC_HP_TD_UPD_TMR);
+	return 0;
+}
+
+/* Consider link power management in the runtime phase. */
+static void imem_slp_control_exec(struct iosm_imem *ipc_imem)
+{
+	if (ipc_protocol_pm_dev_sleep_handle(ipc_imem->ipc_protocol) &&
+	    /* link will go down, Test pending UL packets.*/
+	    hrtimer_active(&ipc_imem->tdupdate_timer)) {
+		/* Generate the doorbell irq. */
+		imem_tq_td_update_timer_cb(ipc_imem, 0, NULL, 0);
+		/* Deactivate the TD update timer. */
+		imem_hrtimer_stop(&ipc_imem->tdupdate_timer);
+		/* Deactivate the force update timer. */
+		imem_hrtimer_stop(&ipc_imem->fast_update_timer);
+	}
+}
+
+/* Execute startup timer and wait for delayed start (e.g. NAND) */
+static int imem_tq_startup_timer_cb(void *instance, int arg, void *msg,
+				    size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+
+	/* Update & check the current operation phase. */
+	if (imem_ap_phase_update(ipc_imem) != IPC_P_RUN)
+		return -1;
+
+	if (ipc_mmio_get_ipc_state(ipc_imem->mmio) ==
+	    IPC_MEM_DEVICE_IPC_UNINIT) {
+		ipc_imem->ipc_requested_state = IPC_MEM_DEVICE_IPC_INIT;
+
+		ipc_doorbell_fire(ipc_imem->pcie, IPC_DOORBELL_IRQ_IPC,
+				  IPC_MEM_DEVICE_IPC_INIT);
+
+		/* reduce period to 100 ms to check for mmio init state */
+		imem_hrtimer_start(ipc_imem, &ipc_imem->startup_timer,
+				   100 * 1000UL);
+	} else if (ipc_mmio_get_ipc_state(ipc_imem->mmio) ==
+		   IPC_MEM_DEVICE_IPC_INIT) {
+		/* Startup complete  - disable timer */
+		imem_hrtimer_stop(&ipc_imem->startup_timer);
+
+		/* Prepare the MMIO space */
+		ipc_mmio_config(ipc_imem->mmio);
+		ipc_imem->ipc_requested_state = IPC_MEM_DEVICE_IPC_RUNNING;
+		ipc_doorbell_fire(ipc_imem->pcie, IPC_DOORBELL_IRQ_IPC,
+				  IPC_MEM_DEVICE_IPC_RUNNING);
+	}
+
+	return 0;
+}
+
+static enum hrtimer_restart imem_startup_timer_cb(struct hrtimer *hr_timer)
+{
+	enum hrtimer_restart result = HRTIMER_NORESTART;
+	struct iosm_imem *ipc_imem =
+		container_of(hr_timer, struct iosm_imem, startup_timer);
+
+	if (ktime_to_ns(ipc_imem->hrtimer_period) != 0) {
+		hrtimer_forward(&ipc_imem->startup_timer, ktime_get(),
+				ipc_imem->hrtimer_period);
+		result = HRTIMER_RESTART;
+	}
+
+	ipc_task_queue_send_task(ipc_imem, imem_tq_startup_timer_cb, 0, NULL, 0,
+				 false);
+	return result;
+}
+
+/* Get the CP execution stage */
+static enum ipc_mem_exec_stage
+ipc_imem_get_exec_stage_buffered(struct iosm_imem *ipc_imem)
+{
+	return (ipc_imem->phase == IPC_P_RUN &&
+		ipc_imem->ipc_status == IPC_MEM_DEVICE_IPC_RUNNING) ?
+		       ipc_protocol_get_ap_exec_stage(ipc_imem->ipc_protocol) :
+		       ipc_mmio_get_exec_stage(ipc_imem->mmio);
+}
+
+/* Callback to send the modem ready uevent */
+static int imem_send_mdm_rdy_cb(void *instance, int arg, void *msg, size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+	enum ipc_mem_exec_stage exec_stage =
+		ipc_imem_get_exec_stage_buffered(ipc_imem);
+
+	if (exec_stage == IPC_MEM_EXEC_STAGE_RUN)
+		ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_READY);
+
+	return 0;
+}
+
+/* Steps to be executed when modem reaches RUN state.
+ * This function is executed in a task context via an ipc_worker object,
+ * as the creation or removal of device can't be done from tasklet.
+ */
+static void ipc_imem_run_state_worker(struct work_struct *instance)
+{
+	struct ipc_mux_config mux_cfg;
+	struct iosm_imem *ipc_imem;
+	int total_sessions = 0;
+
+	ipc_imem = container_of(instance, struct iosm_imem, run_state_worker);
+
+	if (ipc_imem->phase != IPC_P_RUN) {
+		dev_err(ipc_imem->dev,
+			"Modem link down. Exit run state worker.");
+		return;
+	}
+
+	if (!imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg)) {
+		ipc_imem->mux = mux_init(&mux_cfg, ipc_imem);
+		if (ipc_imem->mux)
+			total_sessions += mux_cfg.nr_sessions;
+	}
+
+	wwan_channel_init(ipc_imem, total_sessions, mux_cfg.protocol);
+	if (ipc_imem->mux)
+		ipc_imem->mux->wwan = ipc_imem->wwan;
+
+	/* Remove boot sio device */
+	ipc_sio_deinit(ipc_imem->sio);
+
+	ipc_imem->sio = NULL;
+
+	ipc_task_queue_send_task(ipc_imem, imem_send_mdm_rdy_cb, 0, NULL, 0,
+				 false);
+}
+
+static void imem_handle_irq(struct iosm_imem *ipc_imem, int irq)
+{
+	enum ipc_mem_device_ipc_state curr_ipc_status;
+	enum ipc_phase old_phase, phase;
+	bool retry_allocation = false;
+	bool ul_pending = false;
+	int ch_id, i;
+
+	if (irq != IMEM_IRQ_DONT_CARE)
+		ipc_imem->ev_irq_pending[irq] = false;
+
+	/* Get the internal phase. */
+	old_phase = ipc_imem->phase;
+
+	if (old_phase == IPC_P_OFF_REQ) {
+		dev_dbg(ipc_imem->dev,
+			"[%s]: Ignoring MSI. Deinit sequence in progress!",
+			ipc_ap_phase_get_string(old_phase));
+		return;
+	}
+
+	/* Update the phase controlled by CP. */
+	phase = imem_ap_phase_update(ipc_imem);
+
+	switch (phase) {
+	case IPC_P_RUN:
+		if (!ipc_imem->enter_runtime) {
+			/* Excute the transition from flash/boot to runtime. */
+			ipc_imem->enter_runtime = 1;
+
+			/* allow device to sleep, default value is
+			 * IPC_HOST_SLEEP_ENTER_SLEEP
+			 */
+			imem_msg_send_device_sleep(ipc_imem,
+						   ipc_imem->device_sleep);
+
+			imem_msg_send_feature_set(ipc_imem,
+						  IPC_MEM_INBAND_CRASH_SIG,
+						  true);
+		}
+
+		curr_ipc_status =
+			ipc_protocol_get_ipc_status(ipc_imem->ipc_protocol);
+
+		/* check ipc_status change */
+		if (ipc_imem->ipc_status != curr_ipc_status) {
+			ipc_imem->ipc_status = curr_ipc_status;
+
+			if (ipc_imem->ipc_status ==
+			    IPC_MEM_DEVICE_IPC_RUNNING) {
+				schedule_work(&ipc_imem->run_state_worker);
+			}
+		}
+
+		/* Consider power management in the runtime phase. */
+		imem_slp_control_exec(ipc_imem);
+		break; /* Continue with skbuf processing. */
+
+		/* Unexpected phases. */
+	case IPC_P_OFF:
+	case IPC_P_OFF_REQ:
+		dev_err(ipc_imem->dev, "confused phase %s",
+			ipc_ap_phase_get_string(phase));
+		return;
+
+	case IPC_P_PSI:
+		if (old_phase != IPC_P_ROM)
+			break;
+
+		fallthrough;
+		/* On CP the PSI phase is already active. */
+
+	case IPC_P_ROM:
+		/* Before CP ROM driver starts the PSI image, it sets
+		 * the exit_code field on the doorbell scratchpad and
+		 * triggers the irq.
+		 */
+		imem_rom_irq_exec(ipc_imem);
+		return;
+
+	default:
+		break;
+	}
+
+	/* process message ring */
+	ipc_protocol_msg_process(ipc_imem->ipc_protocol, irq);
+
+	/* process all open pipes */
+	for (i = 0; i < IPC_MEM_MAX_CHANNELS; i++) {
+		struct ipc_pipe *ul_pipe = &ipc_imem->channels[i].ul_pipe;
+		struct ipc_pipe *dl_pipe = &ipc_imem->channels[i].dl_pipe;
+
+		if (dl_pipe->is_open &&
+		    (irq == IMEM_IRQ_DONT_CARE || irq == dl_pipe->irq)) {
+			imem_dl_pipe_process(ipc_imem, dl_pipe);
+
+			if (dl_pipe->nr_of_queued_entries == 0)
+				retry_allocation = true;
+		}
+
+		if (ul_pipe->is_open)
+			imem_ul_pipe_process(ipc_imem, ul_pipe);
+	}
+
+	/* Try to generate new ADB or ADGH. */
+	if (ipc_mux_ul_data_encode(ipc_imem->mux))
+		/* Do not restart the timer if already running */
+		imem_td_update_timer_start(ipc_imem);
+
+	/* Continue the send procedure with accumulated SIO or NETIF packets.
+	 * Reset the debounce flags.
+	 */
+	ul_pending |= imem_ul_write_td(ipc_imem);
+
+	/* if UL data is processed restart TD update timer */
+	if (ul_pending)
+		imem_hrtimer_start(ipc_imem, &ipc_imem->tdupdate_timer,
+				   TD_UPDATE_DEFAULT_TIMEOUT_USEC);
+
+	/* If CP has executed the transition
+	 * from IPC_INIT to IPC_RUNNING in the PSI
+	 * phase, wake up the flash app to open the pipes.
+	 */
+	if ((phase == IPC_P_PSI || phase == IPC_P_EBL) &&
+	    ipc_imem->ipc_requested_state == IPC_MEM_DEVICE_IPC_RUNNING &&
+	    ipc_mmio_get_ipc_state(ipc_imem->mmio) ==
+		    IPC_MEM_DEVICE_IPC_RUNNING &&
+	    ipc_imem->flash_channel_id >= 0) {
+		/* Wake up the flash app to open the pipes. */
+		ch_id = ipc_imem->flash_channel_id;
+		complete(&ipc_imem->channels[ch_id].ul_sem);
+	}
+
+	/* Reset the expected CP state. */
+	ipc_imem->ipc_requested_state = IPC_MEM_DEVICE_IPC_DONT_CARE;
+
+	if (retry_allocation)
+		imem_hrtimer_start(ipc_imem, &ipc_imem->td_alloc_timer,
+				   IPC_TD_ALLOC_TIMER_PERIOD_MS * 1000);
+}
+
+/* Tasklet callback for interrupt handler.*/
+static int imem_tq_irq_cb(void *instance, int arg, void *msg, size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+
+	imem_handle_irq(ipc_imem, arg);
+
+	return 0;
+}
+
+/* Verify the CP execution save, copy the chip info, change the execution pahse
+ * to ROM and resume the flash app.
+ */
+static int imem_tq_trigger_chip_info_cb(void *instance, int arg, void *msg,
+					size_t msgsize)
+{
+	struct iosm_imem *ipc_imem = instance;
+	enum ipc_mem_exec_stage stage;
+	struct sk_buff *skb;
+	size_t size;
+	int rc = -1;
+
+	/* Test the CP execution state. */
+	stage = ipc_mmio_get_exec_stage(ipc_imem->mmio);
+	if (stage != IPC_MEM_EXEC_STAGE_BOOT) {
+		dev_err(ipc_imem->dev,
+			"execution_stage: expected BOOT,received=%X", stage);
+		return rc;
+	}
+
+	/* Allocate a new sk buf for the chip info. */
+	size = ipc_imem->mmio->chip_info_size;
+	skb = ipc_pcie_alloc_local_skb(ipc_imem->pcie, GFP_ATOMIC, size);
+	if (!skb) {
+		dev_err(ipc_imem->dev, "exhausted skbuf kernel DL memory");
+		return rc;
+	}
+
+	/* Copy the chip info characters into the ipc_skb. */
+	ipc_mmio_copy_chip_info(ipc_imem->mmio, skb_put(skb, size), size);
+
+	/* First change to the ROM boot phase. */
+	dev_dbg(ipc_imem->dev, "execution_stage[%X] eq. BOOT", stage);
+	ipc_imem->phase = IPC_P_ROM;
+
+	/* Inform the flash app, that the chip info are present. */
+	rc = imem_sys_sio_receive(ipc_imem->sio, skb);
+	if (rc) {
+		dev_err(ipc_imem->dev, "rejected downlink data");
+		ipc_pcie_kfree_skb(ipc_imem->pcie, skb);
+	}
+
+	return rc;
+}
+
+void imem_ul_send(struct iosm_imem *ipc_imem)
+{
+	/* start doorbell irq delay timer if UL is pending */
+	if (imem_ul_write_td(ipc_imem))
+		imem_td_update_timer_start(ipc_imem);
+}
+
+/* Check the execution stage and update the AP phase */
+static enum ipc_phase imem_ap_phase_update_check(struct iosm_imem *ipc_imem,
+						 enum ipc_mem_exec_stage stage)
+{
+	switch (stage) {
+	case IPC_MEM_EXEC_STAGE_BOOT:
+		if (ipc_imem->phase != IPC_P_ROM) {
+			/* Send this event only once */
+			ipc_uevent_send(ipc_imem->dev, UEVENT_ROM_READY);
+		}
+
+		return ipc_imem->phase = IPC_P_ROM;
+
+	case IPC_MEM_EXEC_STAGE_PSI:
+		return ipc_imem->phase = IPC_P_PSI;
+
+	case IPC_MEM_EXEC_STAGE_EBL:
+		return ipc_imem->phase = IPC_P_EBL;
+
+	case IPC_MEM_EXEC_STAGE_RUN:
+		if (ipc_imem->phase != IPC_P_RUN &&
+		    ipc_imem->ipc_status == IPC_MEM_DEVICE_IPC_RUNNING) {
+			ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_READY);
+		}
+		return ipc_imem->phase = IPC_P_RUN;
+
+	case IPC_MEM_EXEC_STAGE_CRASH:
+		if (ipc_imem->phase != IPC_P_CRASH)
+			ipc_uevent_send(ipc_imem->dev, UEVENT_CRASH);
+
+		return ipc_imem->phase = IPC_P_CRASH;
+
+	case IPC_MEM_EXEC_STAGE_CD_READY:
+		if (ipc_imem->phase != IPC_P_CD_READY)
+			ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY);
+		return ipc_imem->phase = IPC_P_CD_READY;
+
+	default:
+		/* unknown exec stage:
+		 * assume that link is down and send info to listeners
+		 */
+		ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);
+		break;
+	}
+
+	return ipc_imem->phase;
+}
+
+/* Send msg to device to open pipe */
+static bool imem_pipe_open(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe)
+{
+	union ipc_msg_prep_args prep_args = {
+		.pipe_open.pipe = pipe,
+	};
+
+	if (ipc_protocol_msg_send(ipc_imem->ipc_protocol,
+				  IPC_MSG_PREP_PIPE_OPEN, &prep_args) == 0)
+		pipe->is_open = true;
+
+	return pipe->is_open;
+}
+
+/* Allocates the TDs for the given pipe along with firing HP update DB. */
+static int imem_tq_pipe_td_alloc(void *instance, int arg, void *msg,
+				 size_t size)
+{
+	struct iosm_imem *ipc_imem = instance;
+	struct ipc_pipe *dl_pipe = msg;
+	bool processed = false;
+	int i;
+
+	for (i = 0; i < dl_pipe->nr_of_entries - 1; i++)
+		processed |= imem_dl_skb_alloc(ipc_imem, dl_pipe);
+
+	/* Trigger the doorbell irq to inform CP that new downlink buffers are
+	 * available.
+	 */
+	if (processed)
+		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol, arg);
+
+	return 0;
+}
+
+static enum hrtimer_restart imem_td_update_timer_cb(struct hrtimer *hr_timer)
+{
+	struct iosm_imem *ipc_imem =
+		container_of(hr_timer, struct iosm_imem, tdupdate_timer);
+
+	ipc_task_queue_send_task(ipc_imem, imem_tq_td_update_timer_cb, 0, NULL,
+				 0, false);
+	return HRTIMER_NORESTART;
+}
+
+/* Get the CP execution state and map it to the AP phase. */
+enum ipc_phase imem_ap_phase_update(struct iosm_imem *ipc_imem)
+{
+	enum ipc_mem_exec_stage exec_stage =
+				ipc_imem_get_exec_stage_buffered(ipc_imem);
+	/* If the CP stage is undef, return the internal precalculated phase. */
+	return ipc_imem->phase == IPC_P_OFF_REQ ?
+		       ipc_imem->phase :
+		       imem_ap_phase_update_check(ipc_imem, exec_stage);
+}
+
+const char *ipc_ap_phase_get_string(enum ipc_phase phase)
+{
+	switch (phase) {
+	case IPC_P_RUN:
+		return "A-RUN";
+
+	case IPC_P_OFF:
+		return "A-OFF";
+
+	case IPC_P_ROM:
+		return "A-ROM";
+
+	case IPC_P_PSI:
+		return "A-PSI";
+
+	case IPC_P_EBL:
+		return "A-EBL";
+
+	case IPC_P_CRASH:
+		return "A-CRASH";
+
+	case IPC_P_CD_READY:
+		return "A-CD_READY";
+
+	case IPC_P_OFF_REQ:
+		return "A-OFF_REQ";
+
+	default:
+		return "A-???";
+	}
+}
+
+void imem_pipe_close(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe)
+{
+	union ipc_msg_prep_args prep_args = { .pipe_close.pipe = pipe };
+
+	pipe->is_open = false;
+	ipc_protocol_msg_send(ipc_imem->ipc_protocol, IPC_MSG_PREP_PIPE_CLOSE,
+			      &prep_args);
+
+	imem_pipe_cleanup(ipc_imem, pipe);
+}
+
+void imem_channel_close(struct iosm_imem *ipc_imem, int channel_id)
+{
+	struct ipc_mem_channel *channel;
+
+	if (channel_id < 0 || channel_id >= ipc_imem->nr_of_channels) {
+		dev_err(ipc_imem->dev, "invalid channel id %d", channel_id);
+		return;
+	}
+
+	channel = &ipc_imem->channels[channel_id];
+
+	if (channel->state == IMEM_CHANNEL_FREE) {
+		dev_err(ipc_imem->dev, "ch[%d]: invalid channel state %d",
+			channel_id, channel->state);
+		return;
+	}
+
+	/* Free only the channel id in the CP power off mode. */
+	if (channel->state == IMEM_CHANNEL_RESERVED)
+		/* Release only the channel id. */
+		goto channel_free;
+
+	if (ipc_imem->phase == IPC_P_RUN) {
+		imem_pipe_close(ipc_imem, &channel->ul_pipe);
+		imem_pipe_close(ipc_imem, &channel->dl_pipe);
+	}
+
+	imem_pipe_cleanup(ipc_imem, &channel->ul_pipe);
+	imem_pipe_cleanup(ipc_imem, &channel->dl_pipe);
+
+channel_free:
+	imem_channel_free(channel);
+}
+
+struct ipc_mem_channel *imem_channel_open(struct iosm_imem *ipc_imem,
+					  int channel_id, u32 db_id)
+{
+	struct ipc_mem_channel *channel;
+
+	if (channel_id < 0 || channel_id >= IPC_MEM_MAX_CHANNELS) {
+		dev_err(ipc_imem->dev, "invalid channel ID: %d", channel_id);
+		return NULL;
+	}
+
+	channel = &ipc_imem->channels[channel_id];
+
+	channel->state = IMEM_CHANNEL_ACTIVE;
+
+	if (!imem_pipe_open(ipc_imem, &channel->ul_pipe))
+		goto ul_pipe_err;
+
+	if (!imem_pipe_open(ipc_imem, &channel->dl_pipe))
+		goto dl_pipe_err;
+
+	/* Allocate the downlink buffers and inform CP in tasklet context. */
+	if (ipc_task_queue_send_task(ipc_imem, imem_tq_pipe_td_alloc, db_id,
+				     &channel->dl_pipe, 0, false)) {
+		dev_err(ipc_imem->dev, "td allocation failed : %d", channel_id);
+		goto task_failed;
+	}
+
+	/* Active channel. */
+	return channel;
+task_failed:
+	imem_pipe_close(ipc_imem, &channel->dl_pipe);
+dl_pipe_err:
+	imem_pipe_close(ipc_imem, &channel->ul_pipe);
+ul_pipe_err:
+	imem_channel_free(channel);
+	return NULL;
+}
+
+int ipc_imem_pm_suspend(struct iosm_imem *ipc_imem)
+{
+	return ipc_protocol_suspend(ipc_imem->ipc_protocol) ? 0 : -1;
+}
+
+void ipc_imem_pm_resume(struct iosm_imem *ipc_imem)
+{
+	enum ipc_mem_exec_stage stage;
+
+	if (ipc_protocol_resume(ipc_imem->ipc_protocol)) {
+		stage = ipc_mmio_get_exec_stage(ipc_imem->mmio);
+		imem_ap_phase_update_check(ipc_imem, stage);
+	}
+}
+
+int imem_trigger_chip_info(struct iosm_imem *ipc_imem)
+{
+	return ipc_task_queue_send_task(ipc_imem, imem_tq_trigger_chip_info_cb,
+					0, NULL, 0, true);
+}
+
+void imem_channel_free(struct ipc_mem_channel *channel)
+{
+	/* Reset dynamic channel elements. */
+	channel->sio_id = -1;
+	channel->state = IMEM_CHANNEL_FREE;
+}
+
+int imem_channel_alloc(struct iosm_imem *ipc_imem, int index,
+		       enum ipc_ctype ctype)
+{
+	struct ipc_mem_channel *channel;
+	int i;
+
+	/* Find channel of given type/index */
+	for (i = 0; i < ipc_imem->nr_of_channels; i++) {
+		channel = &ipc_imem->channels[i];
+		if (channel->ctype == ctype && channel->index == index)
+			break;
+	}
+
+	if (i >= ipc_imem->nr_of_channels) {
+		dev_dbg(ipc_imem->dev,
+			"no channel definition for index=%d ctype=%d", index,
+			ctype);
+		return -1;
+	}
+
+	if (ipc_imem->channels[i].state != IMEM_CHANNEL_FREE) {
+		dev_dbg(ipc_imem->dev, "channel is in use");
+		return -1;
+	}
+
+	/* Initialize the reserved channel element. */
+	channel->sio_id = index;
+	/* set vlan id here only for dss channels */
+	if (channel->ctype == IPC_CTYPE_WWAN &&
+	    ((index > 256 && index < 512) ||
+	     index == IPC_MEM_MUX_IP_CH_VLAN_ID))
+		channel->vlan_id = index;
+
+	channel->state = IMEM_CHANNEL_RESERVED;
+
+	return i;
+}
+
+void imem_channel_init(struct iosm_imem *ipc_imem, enum ipc_ctype ctype,
+		       struct ipc_chnl_cfg chnl_cfg, u32 irq_moderation)
+{
+	struct ipc_mem_channel *channel;
+
+	if (chnl_cfg.ul_pipe >= IPC_MEM_MAX_PIPES ||
+	    chnl_cfg.dl_pipe >= IPC_MEM_MAX_PIPES) {
+		dev_err(ipc_imem->dev, "invalid pipe: ul_pipe=%d, dl_pipe=%d",
+			chnl_cfg.ul_pipe, chnl_cfg.dl_pipe);
+		return;
+	}
+
+	if (ipc_imem->nr_of_channels >= IPC_MEM_MAX_CHANNELS) {
+		dev_err(ipc_imem->dev, "too many channels");
+		return;
+	}
+
+	channel = &ipc_imem->channels[ipc_imem->nr_of_channels];
+	channel->channel_id = ipc_imem->nr_of_channels;
+	channel->ctype = ctype;
+	channel->index = chnl_cfg.id;
+	channel->sio_id = -1;
+	channel->net_err_count = 0;
+	channel->state = IMEM_CHANNEL_FREE;
+	ipc_imem->nr_of_channels++;
+
+	ipc_imem_channel_update(ipc_imem, channel->channel_id, chnl_cfg,
+				IRQ_MOD_OFF);
+
+	skb_queue_head_init(&channel->ul_list);
+
+	init_completion(&channel->ul_sem);
+}
+
+void ipc_imem_channel_update(struct iosm_imem *ipc_imem, int id,
+			     struct ipc_chnl_cfg chnl_cfg, u32 irq_moderation)
+{
+	struct ipc_mem_channel *channel;
+
+	if (id < 0 || id >= ipc_imem->nr_of_channels) {
+		dev_err(ipc_imem->dev, "invalid channel id %d", id);
+		return;
+	}
+
+	channel = &ipc_imem->channels[id];
+
+	if (channel->state != IMEM_CHANNEL_FREE &&
+	    channel->state != IMEM_CHANNEL_RESERVED) {
+		dev_err(ipc_imem->dev, "invalid channel state %d",
+			channel->state);
+		return;
+	}
+
+	channel->ul_pipe.nr_of_entries = chnl_cfg.ul_nr_of_entries;
+	channel->ul_pipe.pipe_nr = chnl_cfg.ul_pipe;
+	channel->ul_pipe.is_open = false;
+	channel->ul_pipe.irq = IPC_UL_PIPE_IRQ_VECTOR;
+	channel->ul_pipe.channel = channel;
+	channel->ul_pipe.dir = IPC_MEM_DIR_UL;
+	channel->ul_pipe.accumulation_backoff = chnl_cfg.accumulation_backoff;
+	channel->ul_pipe.irq_moderation = irq_moderation;
+	channel->ul_pipe.buf_size = 0;
+
+	channel->dl_pipe.nr_of_entries = chnl_cfg.dl_nr_of_entries;
+	channel->dl_pipe.pipe_nr = chnl_cfg.dl_pipe;
+	channel->dl_pipe.is_open = false;
+	channel->dl_pipe.irq = IPC_DL_PIPE_IRQ_VECTOR;
+	channel->dl_pipe.channel = channel;
+	channel->dl_pipe.dir = IPC_MEM_DIR_DL;
+	channel->dl_pipe.accumulation_backoff = chnl_cfg.accumulation_backoff;
+	channel->dl_pipe.irq_moderation = irq_moderation;
+	channel->dl_pipe.buf_size = chnl_cfg.dl_buf_size;
+}
+
+/* reset volatile pipe content for all channels */
+static void imem_channel_reset(struct iosm_imem *ipc_imem)
+{
+	int i;
+
+	for (i = 0; i < ipc_imem->nr_of_channels; i++) {
+		struct ipc_mem_channel *channel;
+
+		channel = &ipc_imem->channels[i];
+
+		imem_pipe_cleanup(ipc_imem, &channel->dl_pipe);
+		imem_pipe_cleanup(ipc_imem, &channel->ul_pipe);
+
+		imem_channel_free(channel);
+	}
+}
+
+void imem_pipe_cleanup(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe)
+{
+	struct sk_buff *skb;
+
+	/* Force pipe to closed state also when not explicitly closed through
+	 * imem_pipe_close()
+	 */
+	pipe->is_open = false;
+
+	/* Empty the uplink skb accumulator. */
+	while ((skb = skb_dequeue(&pipe->channel->ul_list)))
+		ipc_pcie_kfree_skb(ipc_imem->pcie, skb);
+
+	ipc_protocol_pipe_cleanup(ipc_imem->ipc_protocol, pipe);
+}
+
+/* Send IPC protocol uninit to the modem when Link is active. */
+static void ipc_imem_device_ipc_uninit(struct iosm_imem *ipc_imem)
+{
+	int timeout = IPC_MODEM_UNINIT_TIMEOUT_MS;
+	enum ipc_mem_device_ipc_state ipc_state;
+
+	/* When PCIe link is up set IPC_UNINIT
+	 * of the modem otherwise ignore it when PCIe link down happens.
+	 */
+	if (ipc_pcie_check_data_link_active(ipc_imem->pcie)) {
+		/* set modem to UNINIT
+		 * (in case we want to reload the AP driver without resetting
+		 * the modem)
+		 */
+		ipc_doorbell_fire(ipc_imem->pcie, IPC_DOORBELL_IRQ_IPC,
+				  IPC_MEM_DEVICE_IPC_UNINIT);
+		ipc_state = ipc_mmio_get_ipc_state(ipc_imem->mmio);
+
+		/* Wait for maximum 30ms to allow the Modem to uninitialize the
+		 * protocol.
+		 */
+		while ((ipc_state <= IPC_MEM_DEVICE_IPC_DONT_CARE) &&
+		       (ipc_state != IPC_MEM_DEVICE_IPC_UNINIT) &&
+		       (timeout > 0)) {
+			usleep_range(1000, 1250);
+			timeout--;
+			ipc_state = ipc_mmio_get_ipc_state(ipc_imem->mmio);
+		}
+	}
+}
+
+void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
+{
+	ipc_imem->phase = IPC_P_OFF_REQ;
+
+	/* forward MDM_NOT_READY to listeners */
+	ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_NOT_READY);
+
+	ipc_imem_device_ipc_uninit(ipc_imem);
+
+	hrtimer_cancel(&ipc_imem->td_alloc_timer);
+
+	hrtimer_cancel(&ipc_imem->tdupdate_timer);
+
+	hrtimer_cancel(&ipc_imem->fast_update_timer);
+
+	hrtimer_cancel(&ipc_imem->startup_timer);
+
+	/* cancel the workqueue */
+	cancel_work_sync(&ipc_imem->run_state_worker);
+
+	ipc_mux_deinit(ipc_imem->mux);
+
+	ipc_wwan_deinit(ipc_imem->wwan);
+
+	imem_channel_reset(ipc_imem);
+
+	ipc_mbim_deinit(ipc_imem->mbim);
+
+	ipc_protocol_deinit(ipc_imem->ipc_protocol);
+
+	tasklet_kill(ipc_imem->ipc_tasklet);
+	kfree(ipc_imem->ipc_tasklet);
+	ipc_imem->ipc_tasklet = NULL;
+
+	ipc_task_queue_deinit(ipc_imem->ipc_task);
+
+	kfree(ipc_imem->mmio);
+
+	ipc_imem->phase = IPC_P_OFF;
+
+	ipc_imem->pcie = NULL;
+	ipc_imem->dev = NULL;
+}
+
+/* After CP has unblocked the PCIe link, save the start address of the doorbell
+ * scratchpad and prepare the shared memory region. If the flashing to RAM
+ * procedure shall be executed, copy the chip information from the doorbell
+ * scratchtpad to the application buffer and wake up the flash app.
+ */
+static int ipc_imem_config(struct iosm_imem *ipc_imem)
+{
+	enum ipc_phase phase;
+
+	/* Initialize the semaphore for the blocking read UL/DL transfer. */
+	init_completion(&ipc_imem->ul_pend_sem);
+
+	init_completion(&ipc_imem->dl_pend_sem);
+
+	/* clear internal flags */
+	ipc_imem->ipc_status = IPC_MEM_DEVICE_IPC_UNINIT;
+	ipc_imem->enter_runtime = 0;
+
+	phase = imem_ap_phase_update(ipc_imem);
+
+	/* Either CP shall be in the power off or power on phase. */
+	switch (phase) {
+	case IPC_P_ROM:
+		/* poll execution stage (for delayed start, e.g. NAND) */
+		imem_hrtimer_start(ipc_imem, &ipc_imem->startup_timer,
+				   1000 * 1000);
+		return 0;
+
+	case IPC_P_PSI:
+	case IPC_P_EBL:
+	case IPC_P_RUN:
+		/* The initial IPC state is IPC_MEM_DEVICE_IPC_UNINIT. */
+		ipc_imem->ipc_requested_state = IPC_MEM_DEVICE_IPC_UNINIT;
+
+		/* Verify the exepected initial state. */
+		if (ipc_imem->ipc_requested_state ==
+		    ipc_mmio_get_ipc_state(ipc_imem->mmio)) {
+			imem_ipc_init_check(ipc_imem);
+
+			return 0;
+		}
+		dev_err(ipc_imem->dev,
+			"ipc_status(%d) != IPC_MEM_DEVICE_IPC_UNINIT",
+			ipc_mmio_get_ipc_state(ipc_imem->mmio));
+		break;
+	case IPC_P_CRASH:
+	case IPC_P_CD_READY:
+		dev_dbg(ipc_imem->dev,
+			"Modem is in phase %d, reset Modem to collect CD",
+			phase);
+		return 0;
+	default:
+		dev_err(ipc_imem->dev, "unexpected operation phase %d", phase);
+		break;
+	}
+
+	complete(&ipc_imem->dl_pend_sem);
+	complete(&ipc_imem->ul_pend_sem);
+	ipc_imem->phase = IPC_P_OFF;
+	return -1;
+}
+
+/* Pass the dev ptr to the shared memory driver and request the entry points */
+struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
+				void __iomem *mmio, struct device *dev)
+{
+	struct iosm_imem *ipc_imem = kzalloc(sizeof(*pcie->imem), GFP_KERNEL);
+
+	struct ipc_chnl_cfg chnl_cfg_flash = { 0 };
+	struct ipc_chnl_cfg chnl_cfg_mbim = { 0 };
+
+	char name_flash[32] = { 0 }; /* Holds Flash device name */
+	char name_mbim[32] = { 0 }; /* Holds mbim device name */
+
+	if (!ipc_imem)
+		return NULL;
+
+	/* Save the device address. */
+	ipc_imem->pcie = pcie;
+	ipc_imem->dev = dev;
+
+	ipc_imem->pci_device_id = device_id;
+
+	ipc_imem->ev_sio_write_pending = false;
+	ipc_imem->cp_version = 0;
+	ipc_imem->device_sleep = IPC_HOST_SLEEP_ENTER_SLEEP;
+
+	/* Reset the flash channel id. */
+	ipc_imem->flash_channel_id = -1;
+
+	/* Reset the max number of configured channels */
+	ipc_imem->nr_of_channels = 0;
+
+	/* allocate IPC MMIO */
+	ipc_imem->mmio = ipc_mmio_init(mmio, ipc_imem->dev);
+	if (!ipc_imem->mmio) {
+		dev_err(ipc_imem->dev, "failed to initialize mmio region");
+		goto mmio_init_fail;
+	}
+
+	ipc_imem->ipc_tasklet =
+		kzalloc(sizeof(*ipc_imem->ipc_tasklet), GFP_KERNEL);
+
+	/* Create tasklet for event handling*/
+	ipc_imem->ipc_task =
+		ipc_task_queue_init(ipc_imem->ipc_tasklet, ipc_imem->dev);
+
+	if (!ipc_imem->ipc_task)
+		goto ipc_task_init_fail;
+
+	INIT_WORK(&ipc_imem->run_state_worker, ipc_imem_run_state_worker);
+
+	ipc_imem->ipc_protocol = ipc_protocol_init(ipc_imem);
+
+	if (!ipc_imem->ipc_protocol)
+		goto protocol_init_fail;
+
+	/* The phase is set to power off. */
+	ipc_imem->phase = IPC_P_OFF;
+
+	/* Initialize flash channel.
+	 * The actual pipe configuration will be set once PSI has executed
+	 */
+	imem_channel_init(ipc_imem, IPC_CTYPE_FLASH, chnl_cfg_flash, 0);
+
+	snprintf(name_flash, sizeof(name_flash) - 1, "iat");
+
+	ipc_imem->sio = ipc_sio_init(ipc_imem, name_flash);
+
+	if (!ipc_imem->sio)
+		goto sio_init_fail;
+
+	if (!ipc_chnl_cfg_get(&chnl_cfg_mbim, IPC_MEM_MBIM_CTRL_CH_ID,
+			      MUX_UNKNOWN)) {
+		imem_channel_init(ipc_imem, IPC_CTYPE_MBIM, chnl_cfg_mbim,
+				  IRQ_MOD_OFF);
+	}
+
+	snprintf(name_mbim, sizeof(name_mbim) - 1, "wwanctrl");
+
+	ipc_imem->mbim = ipc_mbim_init(ipc_imem, name_mbim);
+
+	if (!ipc_imem->mbim) {
+		imem_channel_reset(ipc_imem);
+		goto mbim_init_fail;
+	}
+
+	imem_hrtimer_init(&ipc_imem->startup_timer, imem_startup_timer_cb);
+
+	imem_hrtimer_init(&ipc_imem->tdupdate_timer, imem_td_update_timer_cb);
+
+	imem_hrtimer_init(&ipc_imem->fast_update_timer,
+			  imem_fast_update_timer_cb);
+
+	imem_hrtimer_init(&ipc_imem->td_alloc_timer, imem_td_alloc_timer_cb);
+
+	if (ipc_imem_config(ipc_imem)) {
+		dev_err(ipc_imem->dev, "failed to initialize the imem");
+		goto imem_config_fail;
+	}
+
+	return ipc_imem;
+
+imem_config_fail:
+	hrtimer_cancel(&ipc_imem->td_alloc_timer);
+	hrtimer_cancel(&ipc_imem->fast_update_timer);
+	hrtimer_cancel(&ipc_imem->tdupdate_timer);
+	hrtimer_cancel(&ipc_imem->startup_timer);
+	ipc_mbim_deinit(ipc_imem->mbim);
+mbim_init_fail:
+	ipc_sio_deinit(ipc_imem->sio);
+sio_init_fail:
+	imem_channel_reset(ipc_imem);
+	ipc_protocol_deinit(ipc_imem->ipc_protocol);
+protocol_init_fail:
+	cancel_work_sync(&ipc_imem->run_state_worker);
+	ipc_task_queue_deinit(ipc_imem->ipc_task);
+ipc_task_init_fail:
+	kfree(ipc_imem->ipc_tasklet);
+	ipc_imem->ipc_tasklet = NULL;
+	kfree(ipc_imem->mmio);
+mmio_init_fail:
+	kfree(ipc_imem);
+	return NULL;
+}
+
+void ipc_imem_irq_process(struct iosm_imem *ipc_imem, int irq)
+{
+	/* Debounce IPC_EV_IRQ. */
+	if (ipc_imem && ipc_imem->ipc_task && !ipc_imem->ev_irq_pending[irq]) {
+		ipc_imem->ev_irq_pending[irq] = true;
+		ipc_task_queue_send_task(ipc_imem, imem_tq_irq_cb, irq, NULL, 0,
+					 false);
+	}
+}
+
+void imem_td_update_timer_suspend(struct iosm_imem *ipc_imem, bool suspend)
+{
+	ipc_imem->td_update_timer_suspended = suspend;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
new file mode 100644
index 000000000000..bd516e968247
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -0,0 +1,606 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_IMEM_H
+#define IOSM_IPC_IMEM_H
+
+#include <linux/skbuff.h>
+#include <stdbool.h>
+
+#include "iosm_ipc_mmio.h"
+#include "iosm_ipc_pcie.h"
+#include "iosm_ipc_uevent.h"
+#include "iosm_ipc_wwan.h"
+
+struct ipc_chnl_cfg;
+
+/* IRQ moderation in usec */
+#define IRQ_MOD_OFF 0
+#define IRQ_MOD_NET 1000
+#define IRQ_MOD_TRC 4000
+
+/* Either the PSI image is accepted by CP or the suspended flash tool is waken,
+ * informed that the CP ROM driver is not ready to process the PSI image.
+ * unit : milliseconds
+ */
+#define IPC_PSI_TRANSFER_TIMEOUT 3000
+
+/* Timeout in 20 msec to wait for the modem to boot up to
+ * IPC_MEM_DEVICE_IPC_INIT state.
+ * unit : milliseconds (500 * ipc_util_msleep(20))
+ */
+#define IPC_MODEM_BOOT_TIMEOUT 500
+
+/* Wait timeout for ipc status reflects IPC_MEM_DEVICE_IPC_UNINIT
+ * unit : milliseconds
+ */
+#define IPC_MODEM_UNINIT_TIMEOUT_MS 30
+
+/* Pending time for processing data.
+ * unit : milliseconds
+ */
+#define IPC_PEND_DATA_TIMEOUT 500
+
+/* The timeout in milliseconds for application to wait for remote time. */
+#define IPC_REMOTE_TS_TIMEOUT_MS 10
+
+/* Timeout for TD allocation retry.
+ * unit : milliseconds
+ */
+#define IPC_TD_ALLOC_TIMER_PERIOD_MS 100
+
+/* Channel Index for SW download */
+#define IPC_MEM_FLASH_CH_ID 0
+
+/* Control Channel for MBIM */
+#define IPC_MEM_MBIM_CTRL_CH_ID 1
+
+/* Host sleep target & state. */
+
+/* Host sleep target is host */
+#define IPC_HOST_SLEEP_HOST 0
+
+/* Host sleep target is device */
+#define IPC_HOST_SLEEP_DEVICE 1
+
+/* Sleep message, target host: AP enters sleep / target device: CP is
+ * allowed to enter sleep and shall use the device sleep protocol
+ */
+#define IPC_HOST_SLEEP_ENTER_SLEEP 0
+
+/* Sleep_message, target host: AP exits  sleep / target device: CP is
+ * NOT allowed to enter sleep
+ */
+#define IPC_HOST_SLEEP_EXIT_SLEEP 1
+
+#define IMEM_IRQ_DONT_CARE (-1)
+
+#define IPC_MEM_MAX_CHANNELS 8
+
+#define IPC_MEM_MUX_IP_SESSION_ENTRIES 8
+
+#define IPC_MEM_MUX_IP_CH_VLAN_ID (-1)
+
+#define TD_UPDATE_DEFAULT_TIMEOUT_USEC 1900
+
+#define FORCE_UPDATE_DEFAULT_TIMEOUT_USEC 500
+
+/* Sleep_message, target host: not applicable  / target device: CP is
+ * allowed to enter sleep and shall NOT use the device sleep protocol
+ */
+#define IPC_HOST_SLEEP_ENTER_SLEEP_NO_PROTOCOL 2
+
+/* in_band_crash_signal IPC_MEM_INBAND_CRASH_SIG
+ * Modem crash notification configuration. If this value is non-zero then
+ * FEATURE_SET message will be sent to the Modem as a result the Modem will
+ * signal Crash via Execution Stage register. If this value is zero then Modem
+ * will use out-of-band method to notify about it's Crash.
+ */
+#define IPC_MEM_INBAND_CRASH_SIG 1
+
+/* Extra headroom to be allocated for DL SKBs to allow addition of Ethernet
+ * header
+ */
+#define IPC_MEM_DL_ETH_OFFSET 16
+#define WAIT_FOR_TIMEOUT(sem, timeout)                                         \
+	wait_for_completion_interruptible_timeout((sem),                       \
+						  msecs_to_jiffies(timeout))
+
+#define IPC_CB(skb) ((struct ipc_skb_cb *)((skb)->cb))
+
+/* List of the supported UL/DL pipes. */
+enum ipc_mem_pipes {
+	IPC_MEM_PIPE_0 = 0,
+	IPC_MEM_PIPE_1,
+	IPC_MEM_PIPE_2,
+	IPC_MEM_PIPE_3,
+	IPC_MEM_PIPE_4,
+	IPC_MEM_PIPE_5,
+	IPC_MEM_PIPE_6,
+	IPC_MEM_PIPE_7,
+	IPC_MEM_PIPE_8,
+	IPC_MEM_PIPE_9,
+	IPC_MEM_PIPE_10,
+	IPC_MEM_PIPE_11,
+	IPC_MEM_PIPE_12,
+	IPC_MEM_PIPE_13,
+	IPC_MEM_PIPE_14,
+	IPC_MEM_PIPE_15,
+	IPC_MEM_PIPE_16,
+	IPC_MEM_PIPE_17,
+	IPC_MEM_PIPE_18,
+	IPC_MEM_PIPE_19,
+	IPC_MEM_PIPE_20,
+	IPC_MEM_PIPE_21,
+	IPC_MEM_PIPE_22,
+	IPC_MEM_PIPE_23,
+	IPC_MEM_MAX_PIPES
+};
+
+/* Enum defining channel states. */
+enum ipc_channel_state {
+	IMEM_CHANNEL_FREE,
+	IMEM_CHANNEL_RESERVED,
+	IMEM_CHANNEL_ACTIVE,
+	IMEM_CHANNEL_CLOSING,
+};
+
+/* Time Unit */
+enum ipc_time_unit {
+	IPC_SEC = 0,
+	IPC_MILLI_SEC = 1,
+	IPC_MICRO_SEC = 2,
+	IPC_NANO_SEC = 3,
+	IPC_PICO_SEC = 4,
+	IPC_FEMTO_SEC = 5,
+	IPC_ATTO_SEC = 6,
+};
+
+/**
+ * enum ipc_ctype - Enum defining supported channel type needed to control the
+ *		    cp or to transfer IP packets.
+ * @IPC_CTYPE_FLASH:		Used for flashing to RAM
+ * @IPC_CTYPE_WWAN:		Used for Control and IP data
+ * @IPC_CTYPE_MBIM:		Used for MBIM Control
+ */
+enum ipc_ctype {
+	IPC_CTYPE_FLASH,
+	IPC_CTYPE_WWAN,
+	IPC_CTYPE_MBIM,
+};
+
+/* Pipe direction. */
+enum ipc_mem_pipe_dir {
+	IPC_MEM_DIR_UL,
+	IPC_MEM_DIR_DL,
+};
+
+/* HP update identifier. To be used as data for ipc_cp_irq_hpda_update() */
+enum ipc_hp_identifier {
+	IPC_HP_MR = 0,
+	IPC_HP_PM_TRIGGER,
+	IPC_HP_WAKEUP_SPEC_TMR,
+	IPC_HP_TD_UPD_TMR_START,
+	IPC_HP_TD_UPD_TMR,
+	IPC_HP_FAST_TD_UPD_TMR,
+	IPC_HP_UL_WRITE_TD,
+	IPC_HP_DL_PROCESS,
+	IPC_HP_NET_CHANNEL_INIT,
+	IPC_HP_SIO_OPEN,
+};
+
+/**
+ * struct ipc_pipe - Structure for Pipe.
+ * @tdr_start:			Ipc private protocol Transfer Descriptor Ring
+ * @channel:			Id of the sio device, set by imem_sio_open,
+ *				needed to pass DL char to the user terminal
+ * @skbr_start:			Circular buffer for skbuf and the buffer
+ *				reference in a tdr_start entry.
+ * @phy_tdr_start:		Transfer descriptor start address
+ * @old_head:			last head pointer reported to CP.
+ * @old_tail:			AP read position before CP moves the read
+ *				position to write/head. If CP has consumed the
+ *				buffers, AP has to freed the skbuf starting at
+ *				tdr_start[old_tail].
+ * @nr_of_entries:		Number of elements of skb_start and tdr_start.
+ * @max_nr_of_queued_entries:	Maximum number of queued entries in TDR
+ * @accumulation_backoff:	Accumulation in usec for accumulation
+ *				backoff (0 = no acc backoff)
+ * @irq_moderation:		timer in usec for irq_moderation
+ *				(0=no irq moderation)
+ * @pipe_nr:			Pipe identification number
+ * @irq:			Interrupt vector
+ * @dir:			Direction of data stream in pipe
+ * @td_tag:			Unique tag of the buffer queued
+ * @buf_size:			Buffer size (in bytes) for preallocated
+ *				buffers (for DL pipes)
+ * @nr_of_queued_entries:	Aueued number of entries
+ * @is_open:			Check for open pipe status
+ */
+struct ipc_pipe {
+	struct ipc_protocol_td *tdr_start;
+	struct ipc_mem_channel *channel;
+	struct sk_buff **skbr_start;
+	dma_addr_t phy_tdr_start;
+	u32 old_head;
+	u32 old_tail;
+	u32 nr_of_entries;
+	u32 max_nr_of_queued_entries;
+	u32 accumulation_backoff;
+	u32 irq_moderation;
+	u32 pipe_nr;
+	u32 irq;
+	enum ipc_mem_pipe_dir dir;
+	u32 td_tag;
+	u32 buf_size;
+	u16 nr_of_queued_entries;
+	u8 is_open : 1;
+};
+
+/**
+ * struct ipc_mem_channel - Structure for Channel.
+ * @channel_id:		Instance of the channel list and is return to the user
+ *			at the end of the open operation.
+ * @ctype:		Control or netif channel.
+ * @index:		unique index per ctype
+ * @ul_pipe:		pipe objects
+ * @dl_pipe:		pipe objects
+ * @sio_id:		Id of the sio device, set by imem_sio_open, needed to
+ *			pass downlink characters to user terminal.
+ * @vlan_id:		VLAN ID
+ * @net_err_count:	Number of downlink errors returned by ipc_wwan_receive
+ *			interface at the entry point of the IP stack.
+ * @state:		Free, reserved or busy (in use).
+ * @ul_sem:		Needed for the blocking write or uplink transfer.
+ * @ul_list:		Uplink accumulator which is filled by the uplink
+ *			char app or IP stack. The socket buffer pointer are
+ *			added to the descriptor list in the kthread context.
+ */
+struct ipc_mem_channel {
+	int channel_id;
+	enum ipc_ctype ctype;
+	int index;
+	struct ipc_pipe ul_pipe;
+	struct ipc_pipe dl_pipe;
+	int sio_id;
+	int vlan_id;
+	u32 net_err_count;
+	enum ipc_channel_state state;
+	struct completion ul_sem;
+	struct sk_buff_head ul_list;
+};
+
+/**
+ * enum ipc_phase - Different AP and CP phases.
+ *		    The enums defined after "IPC_P_ROM" and before
+ *		    "IPC_P_RUN" indicates the operating state where CP can
+ *		    respond to any requests. So while introducing new phase
+ *		    this shall be taken into consideration.
+ * @IPC_P_OFF:		On host PC, the PCIe device link settings are known
+ *			about the combined power on. PC is running, the driver
+ *			is loaded and CP is in power off mode. The PCIe bus
+ *			driver call the device power mode D3hot. In this phase
+ *			the driver the polls the device, until the device is in
+ *			the power on state and signals the power mode D0.
+ * @IPC_P_OFF_REQ:	The intermediate phase between cleanup activity starts
+ *			and ends.
+ * @IPC_P_CRASH:	The phase indicating CP crash
+ * @IPC_P_CD_READY:	The phase indicating CP core dump is ready
+ * @IPC_P_ROM:		After power on, CP starts in ROM mode and the IPC ROM
+ *			driver is waiting 150 ms for the AP active notification
+ *			saved in the PCI link status register.
+ * @IPC_P_PSI:		Primary signed image download phase
+ * @IPC_P_EBL:		Extended bootloader pahse
+ * @IPC_P_RUN:		The phase after flashing to RAM is the RUNTIME phase.
+ */
+enum ipc_phase {
+	IPC_P_OFF,
+	IPC_P_OFF_REQ,
+	IPC_P_CRASH,
+	IPC_P_CD_READY,
+	IPC_P_ROM,
+	IPC_P_PSI,
+	IPC_P_EBL,
+	IPC_P_RUN,
+};
+
+/**
+ * struct iosm_imem - Current state of the IPC shared memory.
+ * @mmio:			mmio instance to access CP MMIO area /
+ *				doorbell scratchpad.
+ * @ipc_protocol:		IPC Protocol instance
+ * @ipc_tasklet:		Tasklet for serialized work offload
+ *				from interrupts and OS callbacks
+ * @ipc_task:			Task for entry into ipc task queue
+ * @wwan:			WWAN device pointer
+ * @mux:			IP Data multiplexing state.
+ * @sio:			IPC SIO data structure pointer
+ * @mbim:			IPC MBIM data structure pointer
+ * @pcie:			IPC PCIe
+ * @dev:			Pointer to device structure
+ * @flash_channel_id:		Reserved channel id for flashing to RAM.
+ * @ipc_requested_state:	Expected IPC state on CP.
+ * @channels:			Channel list with UL/DL pipe pairs.
+ * @ipc_status:			local ipc_status
+ * @nr_of_channels:		number of configured channels
+ * @startup_timer:		startup timer for NAND support.
+ * @hrtimer_period:		Hr timer period
+ * @tdupdate_timer:		Delay the TD update doorbell.
+ * @fast_update_timer:		forced head pointer update delay timer.
+ * @td_alloc_timer:		Timer for DL pipe TD allocation retry
+ * @rom_exit_code:		Mapped boot rom exit code.
+ * @enter_runtime:		1 means the transition to runtime phase was
+ *				executed.
+ * @ul_pend_sem:		Semaphore to wait/complete of UL TDs
+ *				before closing pipe.
+ * @app_notify_ul_pend:		Signal app if UL TD is pending
+ * @dl_pend_sem:		Semaphore to wait/complete of DL TDs
+ *				before closing pipe.
+ * @app_notify_dl_pend:		Signal app if DL TD is pending
+ * @phase:			Operating phase like runtime.
+ * @pci_device_id:		Device ID
+ * @cp_version:			CP version
+ * @device_sleep:		Device sleep state
+ * @run_state_worker:		Pointer to worker component for device
+ *				setup operations to be called when modem
+ *				reaches RUN state
+ * @ev_irq_pending:		0 means inform the IPC tasklet to
+ *				process the irq actions.
+ * @td_update_timer_suspended:	if true then td update timer suspend
+ * @ev_sio_write_pending:	0 means inform the IPC tasklet to pass
+ *				the accumulated uplink buffers to CP.
+ * @ev_mux_net_transmit_pending:0 means inform the IPC tasklet to pass
+ * @reset_det_n:		Reset detect flag
+ * @pcie_wake_n:		Pcie wake flag
+ */
+struct iosm_imem {
+	struct iosm_mmio *mmio;
+	struct iosm_protocol *ipc_protocol;
+	struct tasklet_struct *ipc_tasklet;
+	struct ipc_task_queue *ipc_task;
+	struct iosm_wwan *wwan;
+	struct iosm_mux *mux;
+	struct iosm_sio *sio;
+	struct iosm_sio *mbim;
+	struct iosm_pcie *pcie;
+	struct device *dev;
+	int flash_channel_id;
+	enum ipc_mem_device_ipc_state ipc_requested_state;
+	struct ipc_mem_channel channels[IPC_MEM_MAX_CHANNELS];
+	u32 ipc_status;
+	u32 nr_of_channels;
+	struct hrtimer startup_timer;
+	ktime_t hrtimer_period;
+	struct hrtimer tdupdate_timer;
+	struct hrtimer fast_update_timer;
+	struct hrtimer td_alloc_timer;
+	enum rom_exit_code rom_exit_code;
+	u32 enter_runtime;
+	struct completion ul_pend_sem;
+	u32 app_notify_ul_pend;
+	struct completion dl_pend_sem;
+	u32 app_notify_dl_pend;
+	enum ipc_phase phase;
+	u16 pci_device_id;
+	int cp_version;
+	int device_sleep;
+	struct work_struct run_state_worker;
+	u8 ev_irq_pending[IPC_IRQ_VECTORS];
+	u8 td_update_timer_suspended : 1;
+	u8 ev_sio_write_pending : 1;
+	u8 ev_mux_net_transmit_pending : 1;
+	u8 reset_det_n : 1;
+	u8 pcie_wake_n : 1;
+};
+
+/**
+ * ipc_imem_init - Install the shared memory system
+ * @pcie:	Pointer to core driver data-struct
+ * @device_id:	PCI device ID
+ * @mmio:	Pointer to the mmio area
+ * @dev:	Pointer to device structure
+ *
+ * Returns:  Initialized imem pointer on success else NULL
+ */
+struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
+				void __iomem *mmio, struct device *dev);
+
+/**
+ * ipc_imem_pm_suspend - The HAL shall ask the shared memory layer
+ *			 whether D3 is allowed.
+ * @ipc_imem:	Pointer to imem data-struct
+ *
+ * Returns: 0 On success else negative value
+ */
+int ipc_imem_pm_suspend(struct iosm_imem *ipc_imem);
+
+/**
+ * ipc_imem_pm_resume - The HAL shall inform the shared memory layer
+ *			that the device is active.
+ * @ipc_imem:	Pointer to imem data-struct
+ */
+void ipc_imem_pm_resume(struct iosm_imem *ipc_imem);
+
+/**
+ * ipc_imem_cleanup -	Inform CP and free the shared memory resources.
+ * @ipc_imem:	Pointer to imem data-struct
+ */
+void ipc_imem_cleanup(struct iosm_imem *ipc_imem);
+
+/**
+ * ipc_imem_irq_process - Shift the IRQ actions to the IPC thread.
+ * @ipc_imem:	Pointer to imem data-struct
+ * @irq:	Irq number
+ */
+void ipc_imem_irq_process(struct iosm_imem *ipc_imem, int irq);
+
+/**
+ * imem_get_device_sleep_state - Get the device sleep state value.
+ * @ipc_imem:	Pointer to imem instance
+ *
+ * Returns: device sleep state
+ */
+int imem_get_device_sleep_state(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_td_update_timer_suspend - Updates the TD Update Timer suspend flag.
+ * @ipc_imem:	Pointer to imem data-struct
+ * @suspend:	Flag to update. If TRUE then HP update doorbell is triggered to
+ *		device without any wait. If FALSE then HP update doorbell is
+ *		delayed until timeout.
+ */
+void imem_td_update_timer_suspend(struct iosm_imem *ipc_imem, bool suspend);
+
+/**
+ * imem_channel_close - Release the channel resources.
+ * @ipc_imem:		Pointer to imem data-struct
+ * @channel_id:		Channel ID to be cleaned up.
+ */
+void imem_channel_close(struct iosm_imem *ipc_imem, int channel_id);
+
+/**
+ * imem_channel_alloc - Reserves a channel
+ * @ipc_imem:	Pointer to imem data-struct
+ * @index:	ID to lookup from the preallocated list.
+ * @ctype:	Channel type.
+ *
+ * Returns: Index on success and -1 on failure.
+ */
+int imem_channel_alloc(struct iosm_imem *ipc_imem, int index,
+		       enum ipc_ctype ctype);
+
+/**
+ * imem_channel_open - Establish the pipes.
+ * @ipc_imem:		Pointer to imem data-struct
+ * @channel_id:		Channel ID returned during alloc.
+ * @db_id:		Doorbell ID for trigger identifier.
+ *
+ * Returns: Pointer of ipc_mem_channel on success and NULL on failure.
+ */
+struct ipc_mem_channel *imem_channel_open(struct iosm_imem *ipc_imem,
+					  int channel_id, u32 db_id);
+
+/**
+ * imem_td_update_timer_start - Starts the TD Update Timer if not running.
+ * @ipc_imem:	Pointer to imem data-struct
+ */
+void imem_td_update_timer_start(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_hrtimer_start - Starts the hr Timer if not running.
+ * @hr_timer:	Pointer to hrtimer instance
+ * @period:	Timer value
+ */
+void imem_hrtimer_start(struct iosm_imem *ipc_imem, struct hrtimer *hr_timer,
+			unsigned long period);
+
+/**
+ * imem_ul_write_td - Pass the channel UL list to protocol layer for TD
+ *		      preparation and sending them to the device.
+ * @ipc_imem:	Pointer to imem data-struct
+ *
+ * Returns: TRUE of HP Doorbell trigger is pending. FALSE otherwise.
+ */
+bool imem_ul_write_td(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_ul_send - Dequeue SKB from channel list and start with
+ *		  the uplink transfer.If HP Doorbell is pending to be
+ *		  triggered then starts the TD Update Timer.
+ * @ipc_imem:	Pointer to imem data-struct
+ */
+void imem_ul_send(struct iosm_imem *ipc_imem);
+
+/**
+ * ipc_imem_channel_update - Set or modify pipe config of an existing channel
+ * @ipc_imem:		Pointer to imem data-struct
+ * @id:			Channel config index
+ * @chnl_cfg:		Channel config struct
+ * @irq_moderation:	Timer in usec for irq_moderation
+ */
+void ipc_imem_channel_update(struct iosm_imem *ipc_imem, int id,
+			     struct ipc_chnl_cfg chnl_cfg, u32 irq_moderation);
+
+/**
+ * imem_trigger_chip_info - Inform the char that the chip information are
+ *			    available if the flashing to RAM interworking shall
+ *			    be executed.
+ * @ipc_imem:	Pointer to imem data-struct
+ *
+ * Returns: 0 on success, -1 on failure
+ */
+int imem_trigger_chip_info(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_channel_free -Free an IPC channel.
+ * @channel:	Channel to be freed
+ */
+void imem_channel_free(struct ipc_mem_channel *channel);
+
+/**
+ * imem_hrtimer_stop - Stop the hrtimer
+ * @hr_timer:	Pointer to hrtimer instance
+ */
+void imem_hrtimer_stop(struct hrtimer *hr_timer);
+
+/**
+ * imem_pipe_cleanup - Reset volatile pipe content for all channels
+ * @ipc_imem:	Pointer to imem data-struct
+ * @pipe:	Pipe to cleaned up
+ */
+void imem_pipe_cleanup(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe);
+
+/**
+ * imem_pipe_close - Send msg to device to close pipe
+ * @ipc_imem:	Pointer to imem data-struct
+ * @pipe:	Pipe to be closed
+ */
+void imem_pipe_close(struct iosm_imem *ipc_imem, struct ipc_pipe *pipe);
+
+/**
+ * imem_ap_phase_update - Get the CP execution state
+ *			  and map it to the AP phase.
+ * @ipc_imem:	Pointer to imem data-struct
+ *
+ * Returns: Current ap updated phase
+ */
+enum ipc_phase imem_ap_phase_update(struct iosm_imem *ipc_imem);
+
+/**
+ * ipc_ap_phase_get_string - Return the current operation
+ *			     phase as string.
+ * @phase:	AP phase
+ *
+ * Returns: AP phase string
+ */
+const char *ipc_ap_phase_get_string(enum ipc_phase phase);
+
+/**
+ * imem_msg_send_feature_set - Send feature set message to modem
+ * @ipc_imem:		Pointer to imem data-struct
+ * @reset_enable:	0 = out-of-band, 1 = in-band-crash notification
+ * @atomic_ctx:		if disabled call in tasklet context
+ *
+ */
+void imem_msg_send_feature_set(struct iosm_imem *ipc_imem,
+			       unsigned int reset_enable, bool atomic_ctx);
+
+/**
+ * imem_ipc_init_check - Send the init event to CP, wait a certain time and set
+ *			 CP to runtime with the context information
+ * @ipc_imem:	Pointer to imem data-struct
+ */
+void imem_ipc_init_check(struct iosm_imem *ipc_imem);
+
+/**
+ * imem_channel_init -	Initialize the channel list with UL/DL pipe pairs.
+ * @ipc_imem:		Pointer to imem data-struct
+ * @ctype:		Channel type
+ * @chnl_cfg:		Channel configuration struct
+ * @irq_moderation:	Timer in usec for irq_moderation
+ */
+void imem_channel_init(struct iosm_imem *ipc_imem, enum ipc_ctype ctype,
+		       struct ipc_chnl_cfg chnl_cfg, u32 irq_moderation);
+#endif
-- 
2.12.3

