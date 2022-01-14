Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4E48E1FB
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbiANBHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:07:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:55112 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238617AbiANBG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=l5ZyudE+O+ISuV8Uo+QOvqaUbwbXOEP5joCXBRjsVQg=;
  b=NIXVTbvf2nnVpBX8jCCulYimdcwfpk2Ia7P2XHiM1WfHT9eOBH9GNbp3
   t8XJxLYKQ9JHL5Np216a/tIafOqQPMWY1ylc17X2AapKpmo4TiyKVHz3v
   OS2hphZBSgBLkBbcuoKL/prbc8xw9vVmAkwuVZc0YTgO1BwCCvlKQwfFX
   pJ9HfzPODePDfwVMKRb2ZjWb5IGIjlko70pXP+4yjz5bxuSv+4OhuTLd+
   9xNkn0zbEX9ga0A5LukxKBEH0ey2d6DMj8GN9ldtvtYlr2CzBuICymgUV
   TXkOn6ecdoZAYXf+1yvGG753WEelCHx5mifQAUp3Qchh0FVGT8d2eUtRO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268516445"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="268516445"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014199"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:53 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 05/13] net: wwan: t7xx: Add control port
Date:   Thu, 13 Jan 2022 18:06:19 -0700
Message-Id: <20220114010627.21104-6-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
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
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 252 ++++++++++++++++++++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   3 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c | 190 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    |  74 +++++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  15 ++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   3 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   3 +
 8 files changed, 538 insertions(+), 3 deletions(-)
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
index df317714ba06..ec55845e7ac0 100644
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
 static unsigned int t7xx_get_interrupt_status(struct t7xx_pci_dev *t7xx_dev)
 {
 	return t7xx_mhccif_read_sw_int_sts(t7xx_dev) & D2H_SW_INT_MASK;
@@ -254,16 +270,243 @@ static void t7xx_md_sys_sw_init(struct t7xx_pci_dev *t7xx_dev)
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
+	t7xx_ccci_header_init(ccci_h, 0, packet_size, port_static->tx_ch, 0);
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
+
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
+	t7xx_ctrl_msg_header_init(ctrl_msg_h, CTL_ID_HS1_MSG, 0, sizeof(*ft_query));
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
+	t7xx_ccci_header_init(ccci_h, 0, packet_size, port_static->tx_ch, 0);
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
+	t7xx_ctrl_msg_header_init(ctrl_msg_h, CTL_ID_HS3_MSG, 0, 0);
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
@@ -353,6 +596,7 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 	md->t7xx_dev = t7xx_dev;
 	t7xx_dev->md = md;
 	md->core_md.ready = false;
+	md->core_md.handshake_ongoing = false;
 	spin_lock_init(&md->exp_lock);
 	md->handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
 					   0, "md_hk_wq");
@@ -360,6 +604,9 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 		return NULL;
 
 	INIT_WORK(&md->handshake_work, t7xx_md_hk_wq);
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
+		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
 	return md;
 }
 
@@ -374,6 +621,7 @@ void t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
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
index 000000000000..87c9c0b9c2a7
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -0,0 +1,190 @@
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
+static int port_ctl_rx_thread(void *arg)
+{
+	while (!kthread_should_stop()) {
+		struct t7xx_port *port = arg;
+		struct sk_buff *skb;
+		unsigned long flags;
+
+		spin_lock_irqsave(&port->rx_wq.lock, flags);
+		if (skb_queue_empty(&port->rx_skb_list) &&
+		    wait_event_interruptible_locked_irq(port->rx_wq,
+							!skb_queue_empty(&port->rx_skb_list) ||
+							kthread_should_stop())) {
+			spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+			continue;
+		}
+
+		if (kthread_should_stop()) {
+			spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+			break;
+		}
+
+		skb = __skb_dequeue(&port->rx_skb_list);
+		spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+		port->skb_handler(port, skb);
+	}
+
+	return 0;
+}
+
+static int port_ctl_init(struct t7xx_port *port)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	port->skb_handler = &control_msg_handler;
+	port->thread = kthread_run(port_ctl_rx_thread, port, "%s", port_static->name);
+	if (IS_ERR(port->thread)) {
+		dev_err(port->dev, "Failed to start port control thread\n");
+		return PTR_ERR(port->thread);
+	}
+
+	port->rx_length_th = CTRL_QUEUE_MAXLEN;
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
index af16cb01c607..ec7bb31fa9ea 100644
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
@@ -275,6 +288,62 @@ static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
 	}
 }
 
+void t7xx_ccci_header_init(struct ccci_header *ccci_h, unsigned int pkt_header,
+			   size_t pkt_len, enum port_ch ch, unsigned int ex_msg)
+{
+	ccci_h->packet_header = cpu_to_le32(pkt_header);
+	ccci_h->packet_len = cpu_to_le32(pkt_len);
+	ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+	ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, ch));
+	ccci_h->ex_msg = cpu_to_le32(ex_msg);
+}
+
+void t7xx_ctrl_msg_header_init(struct ctrl_msg_header *ctrl_msg_h, unsigned int msg_id,
+			       unsigned int ex_msg, unsigned int len)
+{
+	ctrl_msg_h->ctrl_msg_id = cpu_to_le32(msg_id);
+	ctrl_msg_h->ex_msg = cpu_to_le32(ex_msg);
+	ctrl_msg_h->data_length = cpu_to_le32(len);
+}
+
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
+		t7xx_ccci_header_init(ccci_h, CCCI_HEADER_NO_DATA,
+				      sizeof(*ctrl_msg_h) + CCCI_H_LEN, ch, 0);
+		ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + CCCI_H_LEN);
+		t7xx_ctrl_msg_header_init(ctrl_msg_h, msg, ex_msg, 0);
+		skb_put(skb, CCCI_H_LEN + sizeof(*ctrl_msg_h));
+	} else {
+		ccci_h = skb_put(skb, sizeof(*ccci_h));
+		t7xx_ccci_header_init(ccci_h, CCCI_HEADER_NO_DATA, msg, ch, ex_msg);
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
@@ -394,6 +463,9 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
 
 		t7xx_port_struct_init(port);
 
+		if (port_static->tx_ch == PORT_CH_CONTROL_TX)
+			md->core_md.ctl_port = port;
+
 		port->t7xx_dev = md->t7xx_dev;
 		port->dev = &md->t7xx_dev->pdev->dev;
 		spin_lock_init(&port->port_update_lock);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index c0d1b9636c12..a6c51e3bb373 100644
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
@@ -60,12 +66,21 @@ struct port_msg {
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
+void t7xx_ccci_header_init(struct ccci_header *ccci_h, unsigned int pkt_header,
+			   size_t pkt_len, enum port_ch ch, unsigned int ex_msg);
+void t7xx_ctrl_msg_header_init(struct ctrl_msg_header *ctrl_msg_h, unsigned int msg_id,
+			       unsigned int ex_msg, unsigned int len);
 
 #endif /* __T7XX_PORT_PROXY_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index e26a3d6a324f..73fab28848c6 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -294,6 +294,9 @@ static void fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
 
 	if (!md->core_md.ready) {
 		dev_err(dev, "MD handshake timeout\n");
+		if (md->core_md.handshake_ongoing)
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
+
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 	} else {
 		fsm_routine_ready(ctl);
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
index 39c89b10a3bb..197b02d4e09a 100644
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

