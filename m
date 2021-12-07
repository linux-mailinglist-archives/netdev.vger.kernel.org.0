Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1EF46B0DD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhLGCvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:51:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:27266 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhLGCvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:51:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300860564"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="300860564"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="748524144"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:46 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v3 04/12] net: wwan: t7xx: Add control port
Date:   Mon,  6 Dec 2021 19:47:03 -0700
Message-Id: <20211207024711.2765-5-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Control Port implements driver control messages such as modem-host
handshaking, controls port enumeration, and handles exception messages.

The handshaking process between the driver and the modem happens during
the init sequence. The process involves the exchange of a list of
supported runtime features to make sure that modem and host are ready
to provide proper feature lists including port enumeration. Further
features can be enabled and controlled in this handshaking process.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 263 ++++++++++++++++++++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   3 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c | 161 +++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    |  65 ++++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  11 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   3 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   3 +
 8 files changed, 507 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 99f9ca3b4b51..63e1c67b82b5 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -11,3 +11,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_cldma.o \
 		t7xx_hif_cldma.o  \
 		t7xx_port_proxy.o  \
+		t7xx_port_ctrl_msg.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index 304b096366a6..3db5e86c23e5 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -16,6 +16,8 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/bits.h>
+#include <linux/bitfield.h>
 #include <linux/dev_printk.h>
 #include <linux/device.h>
 #include <linux/delay.h>
@@ -27,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/wait.h>
 #include <linux/workqueue.h>
 
 #include "t7xx_hif_cldma.h"
@@ -39,11 +42,24 @@
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
+#define RT_ID_MD_PORT_ENUM	0
+/* Modem feature query identification code - "ICCC" */
+#define MD_FEATURE_QUERY_ID	0x49434343
+
+#define FEATURE_VER		GENMASK(7, 4)
+#define FEATURE_MSK		GENMASK(3, 0)
+
 #define RGU_RESET_DELAY_MS	10
 #define PORT_RESET_DELAY_MS	2000
 #define EX_HS_TIMEOUT_MS	5000
 #define EX_HS_POLL_DELAY_MS	10
 
+enum mtk_feature_support_type {
+	MTK_FEATURE_DOES_NOT_EXIST,
+	MTK_FEATURE_NOT_SUPPORTED,
+	MTK_FEATURE_MUST_BE_SUPPORTED,
+};
+
 static inline unsigned int t7xx_get_interrupt_status(struct t7xx_pci_dev *t7xx_dev)
 {
 	return t7xx_mhccif_read_sw_int_sts(t7xx_dev) & D2H_SW_INT_MASK;
@@ -254,16 +270,254 @@ static void t7xx_md_sys_sw_init(struct t7xx_pci_dev *t7xx_dev)
 	t7xx_pcie_register_rgu_isr(t7xx_dev);
 }
 
+struct feature_query {
+	__le32 head_pattern;
+	u8 feature_set[FEATURE_COUNT];
+	__le32 tail_pattern;
+};
+
+static void t7xx_prepare_host_rt_data_query(struct t7xx_sys_info *core)
+{
+	struct t7xx_port_static *port_static = core->ctl_port->port_static;
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct feature_query *ft_query;
+	struct ccci_header *ccci_h;
+	struct sk_buff *skb;
+	size_t packet_size;
+
+	packet_size = sizeof(*ccci_h) + sizeof(*ctrl_msg_h) + sizeof(*ft_query);
+	skb = __dev_alloc_skb(packet_size, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	skb_put(skb, packet_size);
+
+	ccci_h = (struct ccci_header *)skb->data;
+	ccci_h->packet_header = 0;
+	ccci_h->packet_len = cpu_to_le32(packet_size);
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+	ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
+	ccci_h->ex_msg = 0;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
+	ctrl_msg_h->ctrl_msg_id = cpu_to_le32(CTL_ID_HS1_MSG);
+	ctrl_msg_h->ex_msg = 0;
+	ctrl_msg_h->data_length = cpu_to_le32(sizeof(*ft_query));
+
+	ft_query = (struct feature_query *)(skb->data + sizeof(*ccci_h) + sizeof(*ctrl_msg_h));
+	ft_query->head_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
+	memcpy(ft_query->feature_set, core->feature_set, FEATURE_COUNT);
+	ft_query->tail_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
+
+	/* Send HS1 message to device */
+	t7xx_port_proxy_send_skb(core->ctl_port, skb);
+}
+
+static int t7xx_prepare_device_rt_data(struct t7xx_sys_info *core, struct device *dev,
+				       void *data, int data_length)
+{
+	struct t7xx_port_static *port_static = core->ctl_port->port_static;
+	struct mtk_runtime_feature rt_feature;
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct feature_query *md_feature;
+	unsigned int total_data_len;
+	struct ccci_header *ccci_h;
+	size_t packet_size = 0;
+	struct sk_buff *skb;
+	char *rt_data;
+	int i;
+
+	skb = __dev_alloc_skb(MTK_SKB_4K, GFP_KERNEL);
+	if (!skb)
+		return -EFAULT;
+
+	ccci_h = (struct ccci_header *)skb->data;
+	ccci_h->packet_header = 0;
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+	ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
+	ccci_h->ex_msg = 0;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
+	ctrl_msg_h->ctrl_msg_id = cpu_to_le32(CTL_ID_HS3_MSG);
+	ctrl_msg_h->ex_msg = 0;
+	rt_data = skb->data + sizeof(*ccci_h) + sizeof(*ctrl_msg_h);
+
+	/* Parse MD runtime data query */
+	md_feature = data;
+	if (le32_to_cpu(md_feature->head_pattern) != MD_FEATURE_QUERY_ID ||
+	    le32_to_cpu(md_feature->tail_pattern) != MD_FEATURE_QUERY_ID) {
+		dev_err(dev, "Invalid feature pattern: head 0x%x, tail 0x%x\n",
+			le32_to_cpu(md_feature->head_pattern),
+			le32_to_cpu(md_feature->tail_pattern));
+		return -EINVAL;
+	}
+
+	/* Fill runtime feature */
+	for (i = 0; i < FEATURE_COUNT; i++) {
+		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
+
+		memset(&rt_feature, 0, sizeof(rt_feature));
+		rt_feature.feature_id = i;
+
+		switch (md_feature_mask) {
+		case MTK_FEATURE_DOES_NOT_EXIST:
+		case MTK_FEATURE_MUST_BE_SUPPORTED:
+			rt_feature.support_info = md_feature->feature_set[i];
+			break;
+
+		default:
+			break;
+		}
+
+		if (FIELD_GET(FEATURE_MSK, rt_feature.support_info) !=
+		    MTK_FEATURE_MUST_BE_SUPPORTED) {
+			memcpy(rt_data, &rt_feature, sizeof(rt_feature));
+			rt_data += sizeof(rt_feature);
+		}
+
+		packet_size += sizeof(struct mtk_runtime_feature);
+	}
+
+	ctrl_msg_h->data_length = cpu_to_le32(packet_size);
+	total_data_len = packet_size + sizeof(*ctrl_msg_h) + sizeof(*ccci_h);
+	ccci_h->packet_len = cpu_to_le32(total_data_len);
+	skb_put(skb, total_data_len);
+
+	/* Send HS3 message to device */
+	t7xx_port_proxy_send_skb(core->ctl_port, skb);
+	return 0;
+}
+
+static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_info *core,
+				   struct device *dev, void *data, int data_length)
+{
+	enum mtk_feature_support_type ft_spt_st, ft_spt_cfg;
+	struct mtk_runtime_feature *rt_feature;
+	int i, offset;
+
+	offset = sizeof(struct feature_query);
+	for (i = 0; i < FEATURE_COUNT && offset < data_length; i++) {
+		rt_feature = data + offset;
+		ft_spt_st = FIELD_GET(FEATURE_MSK, rt_feature->support_info);
+		offset += sizeof(*rt_feature) + le32_to_cpu(rt_feature->data_len);
+
+		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
+		if (ft_spt_cfg != MTK_FEATURE_MUST_BE_SUPPORTED)
+			continue;
+
+		if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED)
+			return -EINVAL;
+
+		if (i == RT_ID_MD_PORT_ENUM) {
+			struct port_msg *p_msg = (void *)rt_feature + sizeof(*rt_feature);
+
+			t7xx_port_proxy_node_control(ctl->md, p_msg);
+		}
+	}
+
+	return 0;
+}
+
+static void t7xx_core_reset(struct t7xx_modem *md)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	md->core_md.ready = false;
+
+	if (!ctl) {
+		struct device *dev = &md->t7xx_dev->pdev->dev;
+
+		dev_err(dev, "FSM is not initialized\n");
+		return;
+	}
+
+	if (md->core_md.handshake_ongoing)
+		t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
+
+	md->core_md.handshake_ongoing = false;
+}
+
+static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
+				 enum t7xx_fsm_event_state event_id,
+				 enum t7xx_fsm_event_state err_detect)
+{
+	struct t7xx_sys_info *core_info = &md->core_md;
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	struct t7xx_fsm_event *event, *event_next;
+	unsigned long flags;
+	void *event_data;
+	int ret;
+
+	t7xx_prepare_host_rt_data_query(core_info);
+
+	while (!kthread_should_stop()) {
+		bool event_received = false;
+
+		spin_lock_irqsave(&ctl->event_lock, flags);
+		list_for_each_entry_safe(event, event_next, &ctl->event_queue, entry) {
+			if (event->event_id == err_detect) {
+				list_del(&event->entry);
+				spin_unlock_irqrestore(&ctl->event_lock, flags);
+				dev_err(dev, "Core handshake error event received\n");
+				goto err_free_event;
+			} else if (event->event_id == event_id) {
+				list_del(&event->entry);
+				event_received = true;
+				break;
+			}
+		}
+
+		spin_unlock_irqrestore(&ctl->event_lock, flags);
+
+		if (event_received)
+			break;
+
+		wait_event_interruptible(ctl->event_wq, !list_empty(&ctl->event_queue) ||
+					 kthread_should_stop());
+		if (kthread_should_stop())
+			goto err_free_event;
+	}
+
+	if (ctl->exp_flg)
+		goto err_free_event;
+
+	event_data = (void *)event + sizeof(*event);
+	ret = t7xx_parse_host_rt_data(ctl, core_info, dev, event_data, event->length);
+	if (ret) {
+		dev_err(dev, "Host failure parsing runtime data: %d\n", ret);
+		goto err_free_event;
+	}
+
+	if (ctl->exp_flg)
+		goto err_free_event;
+
+	ret = t7xx_prepare_device_rt_data(core_info, dev, event_data, event->length);
+	if (ret) {
+		dev_err(dev, "Device failure parsing runtime data: %d", ret);
+		goto err_free_event;
+	}
+
+	core_info->ready = true;
+	core_info->handshake_ongoing = false;
+	wake_up(&ctl->async_hk_wq);
+err_free_event:
+	kfree(event);
+}
+
 static void t7xx_md_hk_wq(struct work_struct *work)
 {
 	struct t7xx_modem *md = container_of(work, struct t7xx_modem, handshake_work);
 	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
 
+	/* Clear the HS2 EXIT event appended in core_reset() */
+	t7xx_fsm_clr_event(ctl, FSM_EVENT_MD_HS2_EXIT);
 	t7xx_cldma_switch_cfg(md->md_ctrl[ID_CLDMA1]);
 	t7xx_cldma_start(md->md_ctrl[ID_CLDMA1]);
 	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
-	md->core_md.ready = true;
-	wake_up(&ctl->async_hk_wq);
+	md->core_md.handshake_ongoing = true;
+	t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
 }
 
 void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
@@ -353,6 +607,7 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 	md->t7xx_dev = t7xx_dev;
 	t7xx_dev->md = md;
 	md->core_md.ready = false;
+	md->core_md.handshake_ongoing = false;
 	spin_lock_init(&md->exp_lock);
 	md->handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
 					   0, "md_hk_wq");
@@ -360,6 +615,9 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 		return NULL;
 
 	INIT_WORK(&md->handshake_work, t7xx_md_hk_wq);
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
+		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
 	return md;
 }
 
@@ -374,6 +632,7 @@ void t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
 	t7xx_cldma_reset(md->md_ctrl[ID_CLDMA1]);
 	t7xx_port_proxy_reset(md->port_prox);
 	md->md_init_finish = true;
+	t7xx_core_reset(md);
 }
 
 /**
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
index 24d2ee5bfbda..842def631b21 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -56,6 +56,9 @@ enum md_event_id {
 
 struct t7xx_sys_info {
 	bool				ready;
+	bool				handshake_ongoing;
+	u8				feature_set[FEATURE_COUNT];
+	struct t7xx_port		*ctl_port;
 };
 
 struct t7xx_modem {
diff --git a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
new file mode 100644
index 000000000000..24ab0607e8ba
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kthread.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_common.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+static void fsm_ee_message_handler(struct t7xx_fsm_ctl *ctl, struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
+	struct port_proxy *port_prox = ctl->md->port_prox;
+	enum md_state md_state;
+
+	md_state = t7xx_fsm_get_md_state(ctl);
+	if (md_state != MD_STATE_EXCEPTION) {
+		dev_err(dev, "Receive invalid MD_EX %x when MD state is %d\n",
+			ctrl_msg_h->ex_msg, md_state);
+		return;
+	}
+
+	switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {
+	case CTL_ID_MD_EX:
+		if (le32_to_cpu(ctrl_msg_h->ex_msg) != MD_EX_CHK_ID) {
+			dev_err(dev, "Receive invalid MD_EX %x\n", ctrl_msg_h->ex_msg);
+		} else {
+			t7xx_port_proxy_send_msg_to_md(port_prox, PORT_CH_CONTROL_TX, CTL_ID_MD_EX,
+						       MD_EX_CHK_ID);
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX, NULL, 0);
+		}
+
+		break;
+
+	case CTL_ID_MD_EX_ACK:
+		if (le32_to_cpu(ctrl_msg_h->ex_msg) != MD_EX_CHK_ACK_ID)
+			dev_err(dev, "Receive invalid MD_EX_ACK %x\n", ctrl_msg_h->ex_msg);
+		else
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX_REC_OK, NULL, 0);
+
+		break;
+
+	case CTL_ID_MD_EX_PASS:
+		t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX_PASS, NULL, 0);
+		break;
+
+	case CTL_ID_DRV_VER_ERROR:
+		dev_err(dev, "AP/MD driver version mismatch\n");
+	}
+}
+
+static void control_msg_handler(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+	struct port_proxy *port_prox = ctl->md->port_prox;
+	struct ctrl_msg_header *ctrl_msg_h;
+	int ret = 0;
+
+	skb_pull(skb, sizeof(struct ccci_header));
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {
+	case CTL_ID_HS2_MSG:
+		skb_pull(skb, sizeof(*ctrl_msg_h));
+
+		if (port_static->rx_ch == PORT_CH_CONTROL_RX)
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2,
+					      skb->data, le32_to_cpu(ctrl_msg_h->data_length));
+
+		dev_kfree_skb_any(skb);
+		break;
+
+	case CTL_ID_MD_EX:
+	case CTL_ID_MD_EX_ACK:
+	case CTL_ID_MD_EX_PASS:
+	case CTL_ID_DRV_VER_ERROR:
+		fsm_ee_message_handler(ctl, skb);
+		dev_kfree_skb_any(skb);
+		break;
+
+	case CTL_ID_PORT_ENUM:
+		skb_pull(skb, sizeof(*ctrl_msg_h));
+		ret = t7xx_port_proxy_node_control(ctl->md, (struct port_msg *)skb->data);
+		if (!ret)
+			t7xx_port_proxy_send_msg_to_md(port_prox, PORT_CH_CONTROL_TX,
+						       CTL_ID_PORT_ENUM, 0);
+		else
+			t7xx_port_proxy_send_msg_to_md(port_prox, PORT_CH_CONTROL_TX,
+						       CTL_ID_PORT_ENUM, PORT_ENUM_VER_MISMATCH);
+
+		break;
+
+	default:
+		dev_err(port->dev, "Unknown control message ID to FSM %x\n",
+			le32_to_cpu(ctrl_msg_h->ctrl_msg_id));
+		break;
+	}
+
+	if (ret)
+		dev_err(port->dev, "%s control message handle error: %d\n", port_static->name,
+			ret);
+}
+
+static int port_ctl_init(struct t7xx_port *port)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	port->skb_handler = &control_msg_handler;
+	port->thread = kthread_run(t7xx_port_kthread_handler, port, "%s", port_static->name);
+	if (IS_ERR(port->thread)) {
+		dev_err(port->dev, "Failed to start port control thread\n");
+		return PTR_ERR(port->thread);
+	}
+
+	port->rx_length_th = MAX_CTRL_QUEUE_LENGTH;
+	return 0;
+}
+
+static void port_ctl_uninit(struct t7xx_port *port)
+{
+	unsigned long flags;
+	struct sk_buff *skb;
+
+	if (port->thread)
+		kthread_stop(port->thread);
+
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
+		dev_kfree_skb_any(skb);
+
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+}
+
+struct port_ops ctl_port_ops = {
+	.init = &port_ctl_init,
+	.recv_skb = &t7xx_port_recv_skb,
+	.uninit = &port_ctl_uninit,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 4885c6791c2b..67219319e9f7 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -49,7 +49,20 @@
 	     i < (proxy)->port_number;		\
 	     i++, (p) = &(proxy)->ports_private[i])
 
-static struct t7xx_port_static t7xx_md_ports[1];
+static struct t7xx_port_static t7xx_md_ports[] = {
+	{
+		.tx_ch = PORT_CH_CONTROL_TX,
+		.rx_ch = PORT_CH_CONTROL_RX,
+		.txq_index = Q_IDX_CTRL,
+		.rxq_index = Q_IDX_CTRL,
+		.txq_exp_index = 0,
+		.rxq_exp_index = 0,
+		.path_id = ID_CLDMA1,
+		.flags = 0,
+		.ops = &ctl_port_ops,
+		.name = "t7xx_ctrl",
+	},
+};
 
 static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
 {
@@ -319,6 +332,53 @@ static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
 	}
 }
 
+void t7xx_port_proxy_send_msg_to_md(struct port_proxy *port_prox, enum port_ch ch,
+				    unsigned int msg, unsigned int ex_msg)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct ccci_header *ccci_h;
+	struct t7xx_port *port;
+	struct sk_buff *skb;
+	int ret;
+
+	port = t7xx_proxy_get_port_by_ch(port_prox, ch);
+	if (!port)
+		return;
+
+	skb = __dev_alloc_skb(sizeof(*ccci_h), GFP_KERNEL);
+	if (!skb)
+		return;
+
+	if (ch == PORT_CH_CONTROL_TX) {
+		ccci_h = (struct ccci_header *)(skb->data);
+		ccci_h->packet_header = cpu_to_le32(CCCI_HEADER_NO_DATA);
+		ccci_h->packet_len = cpu_to_le32(sizeof(*ctrl_msg_h) + CCCI_H_LEN);
+		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, ch));
+		ccci_h->ex_msg = 0;
+		ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + CCCI_H_LEN);
+		ctrl_msg_h->data_length = 0;
+		ctrl_msg_h->ex_msg = cpu_to_le32(ex_msg);
+		ctrl_msg_h->ctrl_msg_id = cpu_to_le32(msg);
+		skb_put(skb, CCCI_H_LEN + sizeof(*ctrl_msg_h));
+	} else {
+		ccci_h = skb_put(skb, sizeof(*ccci_h));
+		ccci_h->packet_header = cpu_to_le32(CCCI_HEADER_NO_DATA);
+		ccci_h->packet_len = cpu_to_le32(msg);
+		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, ch));
+		ccci_h->ex_msg = cpu_to_le32(ex_msg);
+	}
+
+	ret = t7xx_port_proxy_send_skb(port, skb);
+	if (ret) {
+		struct t7xx_port_static *port_static = port->port_static;
+
+		dev_err(port->dev, "port%s send to MD fail\n", port_static->name);
+		dev_kfree_skb_any(skb);
+	}
+}
+
 /**
  * t7xx_port_proxy_dispatch_recv_skb() - Dispatch received skb.
  * @queue: CLDMA queue.
@@ -438,6 +498,9 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
 
 		t7xx_port_struct_init(port);
 
+		if (port_static->tx_ch == PORT_CH_CONTROL_TX)
+			md->core_md.ctl_port = port;
+
 		port->t7xx_dev = md->t7xx_dev;
 		port->dev = &md->t7xx_dev->pdev->dev;
 		spin_lock_init(&port->port_update_lock);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index de7ba70bd471..06ccda839445 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -42,6 +42,12 @@ struct port_proxy {
 	struct device			*dev;
 };
 
+struct ctrl_msg_header {
+	__le32	ctrl_msg_id;
+	__le32	ex_msg;
+	__le32	data_length;
+};
+
 struct port_msg {
 	__le32	head_pattern;
 	__le32	info;
@@ -60,10 +66,15 @@ struct port_msg {
 #define PORT_ENUM_TAIL_PATTERN	0xa5a5a5a5
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
+/* Port operations mapping */
+extern struct port_ops ctl_port_ops;
+
 int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb);
 void t7xx_port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h);
 int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg);
 void t7xx_port_proxy_reset(struct port_proxy *port_prox);
+void t7xx_port_proxy_send_msg_to_md(struct port_proxy *port_prox, enum port_ch ch,
+				    unsigned int msg, unsigned int ex_msg);
 void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
 int t7xx_port_proxy_init(struct t7xx_modem *md);
 void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state);
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index a436e1450af6..d09a64518b8b 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -315,6 +315,9 @@ static void fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
 
 	if (!md->core_md.ready) {
 		dev_err(dev, "MD handshake timeout\n");
+		if (md->core_md.handshake_ongoing)
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
+
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 	} else {
 		fsm_routine_ready(ctl);
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
index f1e0b1a3f8de..e00aae054d4d 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
@@ -38,9 +38,12 @@ enum t7xx_fsm_state {
 
 enum t7xx_fsm_event_state {
 	FSM_EVENT_INVALID,
+	FSM_EVENT_MD_HS2,
 	FSM_EVENT_MD_EX,
 	FSM_EVENT_MD_EX_REC_OK,
 	FSM_EVENT_MD_EX_PASS,
+	FSM_EVENT_MD_HS2_EXIT,
+	FSM_EVENT_AP_HS2_EXIT,
 	FSM_EVENT_MAX
 };
 
-- 
2.17.1

