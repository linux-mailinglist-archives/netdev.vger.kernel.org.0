Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78073436C13
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhJUUbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:57398 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhJUUbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598297"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598297"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:23 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625068"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:22 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 05/14] net: wwan: t7xx: Add control port
Date:   Thu, 21 Oct 2021 13:27:29 -0700
Message-Id: <20211021202738.729-6-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Control Port implements driver control messages such as modem-host
handshaking, controls port enumeration, and handles exception messages.

The handshaking process between the driver and the modem happens during
the init sequence. The process involves the exchange of a list of
supported runtime features to make sure that modem and host are ready
to provide proper feature lists including port enumeration. Further
features can be enabled and controlled in this handshaking process.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 244 ++++++++++++++++++++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   2 +
 drivers/net/wwan/t7xx/t7xx_monitor.h       |   3 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c | 142 ++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    |   9 +-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |   4 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   3 +
 8 files changed, 403 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 1f117f36124a..b0fac99420a0 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -12,3 +12,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_cldma.o \
 		t7xx_hif_cldma.o  \
 		t7xx_port_proxy.o  \
+		t7xx_port_ctrl_msg.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index ade5e76396be..8802948fb6ef 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -262,6 +262,242 @@ static void md_sys_sw_init(struct mtk_pci_dev *mtk_dev)
 	mtk_pcie_register_rgu_isr(mtk_dev);
 }
 
+struct feature_query {
+	u32 head_pattern;
+	u8 feature_set[FEATURE_COUNT];
+	u32 tail_pattern;
+};
+
+static void prepare_host_rt_data_query(struct core_sys_info *core)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct feature_query *ft_query;
+	struct ccci_header *ccci_h;
+	struct sk_buff *skb;
+	size_t packet_size;
+
+	packet_size = sizeof(struct ccci_header) +
+		      sizeof(struct ctrl_msg_header) +
+		      sizeof(struct feature_query);
+	skb = ccci_alloc_skb(packet_size, GFS_BLOCKING);
+	if (!skb)
+		return;
+
+	skb_put(skb, packet_size);
+	/* fill CCCI header */
+	ccci_h = (struct ccci_header *)skb->data;
+	ccci_h->data[0] = 0;
+	ccci_h->data[1] = packet_size;
+	ccci_h->status &= ~HDR_FLD_CHN;
+	ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, core->ctl_port->tx_ch);
+	ccci_h->status &= ~HDR_FLD_SEQ;
+	ccci_h->reserved = 0;
+	/* fill control message */
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data +
+						sizeof(struct ccci_header));
+	ctrl_msg_h->ctrl_msg_id = CTL_ID_HS1_MSG;
+	ctrl_msg_h->reserved = 0;
+	ctrl_msg_h->data_length = sizeof(struct feature_query);
+	/* fill feature query */
+	ft_query = (struct feature_query *)(skb->data +
+					    sizeof(struct ccci_header) +
+					    sizeof(struct ctrl_msg_header));
+	ft_query->head_pattern = MD_FEATURE_QUERY_ID;
+	memcpy(ft_query->feature_set, core->feature_set, FEATURE_COUNT);
+	ft_query->tail_pattern = MD_FEATURE_QUERY_ID;
+	/* send HS1 message to device */
+	port_proxy_send_skb(core->ctl_port, skb, 0);
+}
+
+static int prepare_device_rt_data(struct core_sys_info *core, struct device *dev,
+				  void *data, int data_length)
+{
+	struct mtk_runtime_feature rt_feature;
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct feature_query *md_feature;
+	struct ccci_header *ccci_h;
+	struct sk_buff *skb;
+	int packet_size = 0;
+	char *rt_data;
+	int i;
+
+	skb = ccci_alloc_skb(MTK_SKB_4K, GFS_BLOCKING);
+	if (!skb)
+		return -EFAULT;
+
+	/* fill CCCI header */
+	ccci_h = (struct ccci_header *)skb->data;
+	ccci_h->data[0] = 0;
+	ccci_h->status &= ~HDR_FLD_CHN;
+	ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, core->ctl_port->tx_ch);
+	ccci_h->status &= ~HDR_FLD_SEQ;
+	ccci_h->reserved = 0;
+	/* fill control message header */
+	ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(struct ccci_header));
+	ctrl_msg_h->ctrl_msg_id = CTL_ID_HS3_MSG;
+	ctrl_msg_h->reserved = 0;
+	rt_data = (skb->data + sizeof(struct ccci_header) + sizeof(struct ctrl_msg_header));
+
+	/* parse MD runtime data query */
+	md_feature = data;
+	if (md_feature->head_pattern != MD_FEATURE_QUERY_ID ||
+	    md_feature->tail_pattern != MD_FEATURE_QUERY_ID) {
+		dev_err(dev, "md_feature pattern is wrong: head 0x%x, tail 0x%x\n",
+			md_feature->head_pattern, md_feature->tail_pattern);
+		return -EINVAL;
+	}
+
+	/* fill runtime feature */
+	for (i = 0; i < FEATURE_COUNT; i++) {
+		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
+
+		memset(&rt_feature, 0, sizeof(rt_feature));
+		rt_feature.feature_id = i;
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
+			rt_feature.data_len = 0;
+			memcpy(rt_data, &rt_feature, sizeof(struct mtk_runtime_feature));
+			rt_data += sizeof(struct mtk_runtime_feature);
+		}
+
+		packet_size += (sizeof(struct mtk_runtime_feature) + rt_feature.data_len);
+	}
+
+	ctrl_msg_h->data_length = packet_size;
+	ccci_h->data[1] = packet_size + sizeof(struct ctrl_msg_header) +
+			  sizeof(struct ccci_header);
+	skb_put(skb, ccci_h->data[1]);
+	/* send HS3 message to device */
+	port_proxy_send_skb(core->ctl_port, skb, 0);
+	return 0;
+}
+
+static int parse_host_rt_data(struct core_sys_info *core, struct device *dev,
+			      void *data, int data_length)
+{
+	enum mtk_feature_support_type ft_spt_st, ft_spt_cfg;
+	struct mtk_runtime_feature *rt_feature;
+	int i, offset;
+
+	offset = sizeof(struct feature_query);
+	for (i = 0; i < FEATURE_COUNT && offset < data_length; i++) {
+		rt_feature = (struct mtk_runtime_feature *)(data + offset);
+		ft_spt_st = FIELD_GET(FEATURE_MSK, rt_feature->support_info);
+		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
+		offset += sizeof(struct mtk_runtime_feature) + rt_feature->data_len;
+
+		if (ft_spt_cfg == MTK_FEATURE_MUST_BE_SUPPORTED) {
+			if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED) {
+				dev_err(dev, "mismatch: runtime feature%d (%d,%d)\n",
+					i, ft_spt_cfg, ft_spt_st);
+				return -EINVAL;
+			}
+
+			if (i == RT_ID_MD_PORT_ENUM)
+				port_proxy_node_control(dev, (struct port_msg *)rt_feature->data);
+		}
+	}
+
+	return 0;
+}
+
+static void core_reset(struct mtk_modem *md)
+{
+	struct ccci_fsm_ctl *fsm_ctl;
+
+	atomic_set(&md->core_md.ready, 0);
+	fsm_ctl = fsm_get_entry();
+
+	if (!fsm_ctl) {
+		dev_err(&md->mtk_dev->pdev->dev, "fsm ctl is not initialized\n");
+		return;
+	}
+
+	/* append HS2_EXIT event to cancel the ongoing handshake in core_hk_handler() */
+	if (atomic_read(&md->core_md.handshake_ongoing))
+		fsm_append_event(fsm_ctl, CCCI_EVENT_MD_HS2_EXIT, NULL, 0);
+
+	atomic_set(&md->core_md.handshake_ongoing, 0);
+}
+
+static void core_hk_handler(struct mtk_modem *md, struct ccci_fsm_ctl *ctl,
+			    enum ccci_fsm_event_state event_id,
+			    enum ccci_fsm_event_state err_detect)
+{
+	struct core_sys_info *core_info;
+	struct ccci_fsm_event *event, *event_next;
+	unsigned long flags;
+	struct device *dev;
+	int ret;
+
+	core_info = &md->core_md;
+	dev = &md->mtk_dev->pdev->dev;
+	prepare_host_rt_data_query(core_info);
+	while (!kthread_should_stop()) {
+		bool event_received = false;
+
+		spin_lock_irqsave(&ctl->event_lock, flags);
+		list_for_each_entry_safe(event, event_next, &ctl->event_queue, entry) {
+			if (event->event_id == err_detect) {
+				list_del(&event->entry);
+				spin_unlock_irqrestore(&ctl->event_lock, flags);
+				dev_err(dev, "core handshake error event received\n");
+				goto exit;
+			}
+
+			if (event->event_id == event_id) {
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
+			goto exit;
+	}
+
+	if (atomic_read(&ctl->exp_flg))
+		goto exit;
+
+	ret = parse_host_rt_data(core_info, dev, event->data, event->length);
+	if (ret) {
+		dev_err(dev, "host runtime data parsing fail:%d\n", ret);
+		goto exit;
+	}
+
+	if (atomic_read(&ctl->exp_flg))
+		goto exit;
+
+	ret = prepare_device_rt_data(core_info, dev, event->data, event->length);
+	if (ret) {
+		dev_err(dev, "device runtime data parsing fail:%d", ret);
+		goto exit;
+	}
+
+	atomic_set(&core_info->ready, 1);
+	atomic_set(&core_info->handshake_ongoing, 0);
+	wake_up(&ctl->async_hk_wq);
+exit:
+	kfree(event);
+}
+
 static void md_hk_wq(struct work_struct *work)
 {
 	struct ccci_fsm_ctl *ctl;
@@ -269,12 +505,14 @@ static void md_hk_wq(struct work_struct *work)
 
 	ctl = fsm_get_entry();
 
+	/* clear the HS2 EXIT event appended in core_reset() */
+	fsm_clear_event(ctl, CCCI_EVENT_MD_HS2_EXIT);
 	cldma_switch_cfg(ID_CLDMA1);
 	cldma_start(ID_CLDMA1);
 	fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
 	md = container_of(work, struct mtk_modem, handshake_work);
-	atomic_set(&md->core_md.ready, 1);
-	wake_up(&ctl->async_hk_wq);
+	atomic_set(&md->core_md.handshake_ongoing, 1);
+	core_hk_handler(md, ctl, CCCI_EVENT_MD_HS2, CCCI_EVENT_MD_HS2_EXIT);
 }
 
 void mtk_md_event_notify(struct mtk_modem *md, enum md_event_id evt_id)
@@ -386,6 +624,7 @@ static struct mtk_modem *ccci_md_alloc(struct mtk_pci_dev *mtk_dev)
 	md->mtk_dev = mtk_dev;
 	mtk_dev->md = md;
 	atomic_set(&md->core_md.ready, 0);
+	atomic_set(&md->core_md.handshake_ongoing, 0);
 	md->handshake_wq = alloc_workqueue("%s",
 					   WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
 					   0, "md_hk_wq");
@@ -410,6 +649,7 @@ void mtk_md_reset(struct mtk_pci_dev *mtk_dev)
 	cldma_reset(ID_CLDMA1);
 	port_proxy_reset(&mtk_dev->pdev->dev);
 	md->md_init_finish = true;
+	core_reset(md);
 }
 
 /**
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
index 1d2fee18b559..06d6f6b45e3b 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -52,7 +52,9 @@ enum md_event_id {
 
 struct core_sys_info {
 	atomic_t ready;
+	atomic_t handshake_ongoing;
 	u8 feature_set[FEATURE_COUNT];
+	struct t7xx_port *ctl_port;
 };
 
 struct mtk_modem {
diff --git a/drivers/net/wwan/t7xx/t7xx_monitor.h b/drivers/net/wwan/t7xx/t7xx_monitor.h
index 42dec0e19035..bfc2a164e5d9 100644
--- a/drivers/net/wwan/t7xx/t7xx_monitor.h
+++ b/drivers/net/wwan/t7xx/t7xx_monitor.h
@@ -29,9 +29,12 @@ enum ccci_fsm_state {
 
 enum ccci_fsm_event_state {
 	CCCI_EVENT_INVALID,
+	CCCI_EVENT_MD_HS2,
 	CCCI_EVENT_MD_EX,
 	CCCI_EVENT_MD_EX_REC_OK,
 	CCCI_EVENT_MD_EX_PASS,
+	CCCI_EVENT_MD_HS2_EXIT,
+	CCCI_EVENT_AP_HS2_EXIT,
 	CCCI_EVENT_MAX
 };
 
diff --git a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
new file mode 100644
index 000000000000..0a998bb0db83
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/kthread.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_common.h"
+#include "t7xx_monitor.h"
+#include "t7xx_port_proxy.h"
+
+static void fsm_ee_message_handler(struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct ccci_fsm_ctl *ctl;
+	enum md_state md_state;
+	struct device *dev;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	md_state = ccci_fsm_get_md_state();
+	ctl = fsm_get_entry();
+	dev = &ctl->md->mtk_dev->pdev->dev;
+	if (md_state != MD_STATE_EXCEPTION) {
+		dev_err(dev, "receive invalid MD_EX %x when MD state is %d\n",
+			ctrl_msg_h->reserved, md_state);
+		return;
+	}
+
+	switch (ctrl_msg_h->ctrl_msg_id) {
+	case CTL_ID_MD_EX:
+		if (ctrl_msg_h->reserved != MD_EX_CHK_ID) {
+			dev_err(dev, "receive invalid MD_EX %x\n", ctrl_msg_h->reserved);
+		} else {
+			port_proxy_send_msg_to_md(CCCI_CONTROL_TX, CTL_ID_MD_EX, MD_EX_CHK_ID);
+			fsm_append_event(ctl, CCCI_EVENT_MD_EX, NULL, 0);
+		}
+
+		break;
+
+	case CTL_ID_MD_EX_ACK:
+		if (ctrl_msg_h->reserved != MD_EX_CHK_ACK_ID)
+			dev_err(dev, "receive invalid MD_EX_ACK %x\n", ctrl_msg_h->reserved);
+		else
+			fsm_append_event(ctl, CCCI_EVENT_MD_EX_REC_OK, NULL, 0);
+
+		break;
+
+	case CTL_ID_MD_EX_PASS:
+		fsm_append_event(ctl, CCCI_EVENT_MD_EX_PASS, NULL, 0);
+		break;
+
+	case CTL_ID_DRV_VER_ERROR:
+		dev_err(dev, "AP/MD driver version mismatch\n");
+	}
+}
+
+static void control_msg_handler(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct ccci_fsm_ctl *ctl;
+	int ret = 0;
+
+	skb_pull(skb, sizeof(struct ccci_header));
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	ctl = fsm_get_entry();
+
+	switch (ctrl_msg_h->ctrl_msg_id) {
+	case CTL_ID_HS2_MSG:
+		skb_pull(skb, sizeof(struct ctrl_msg_header));
+		if (port->rx_ch == CCCI_CONTROL_RX)
+			fsm_append_event(ctl, CCCI_EVENT_MD_HS2,
+					 skb->data, ctrl_msg_h->data_length);
+
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+		break;
+
+	case CTL_ID_MD_EX:
+	case CTL_ID_MD_EX_ACK:
+	case CTL_ID_MD_EX_PASS:
+	case CTL_ID_DRV_VER_ERROR:
+		fsm_ee_message_handler(skb);
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+		break;
+
+	case CTL_ID_PORT_ENUM:
+		skb_pull(skb, sizeof(struct ctrl_msg_header));
+		ret = port_proxy_node_control(port->dev, (struct port_msg *)skb->data);
+		if (!ret)
+			port_proxy_send_msg_to_md(CCCI_CONTROL_TX, CTL_ID_PORT_ENUM, 0);
+		else
+			port_proxy_send_msg_to_md(CCCI_CONTROL_TX,
+						  CTL_ID_PORT_ENUM, PORT_ENUM_VER_MISMATCH);
+
+		break;
+
+	default:
+		dev_err(port->dev, "unknown control message ID to FSM %x\n",
+			ctrl_msg_h->ctrl_msg_id);
+		break;
+	}
+
+	if (ret)
+		dev_err(port->dev, "%s control message handle error: %d\n", port->name, ret);
+}
+
+static int port_ctl_init(struct t7xx_port *port)
+{
+	port->skb_handler = &control_msg_handler;
+	port->thread = kthread_run(port_kthread_handler, port, "%s", port->name);
+	if (IS_ERR(port->thread)) {
+		dev_err(port->dev, "failed to start port control thread\n");
+		return PTR_ERR(port->thread);
+	}
+
+	port->rx_length_th = MAX_CTRL_QUEUE_LENGTH;
+	port->skb_from_pool = true;
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
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+}
+
+struct port_ops ctl_port_ops = {
+	.init = &port_ctl_init,
+	.recv_skb = &port_recv_skb,
+	.uninit = &port_ctl_uninit,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index ae90afc72e40..8e7fada49fc0 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -40,10 +40,9 @@ static struct port_proxy *port_prox;
 	     i < (proxy)->port_number;		\
 	     i++, (p) = &(proxy)->ports[i])
 
-static struct port_ops dummy_port_ops;
-
 static struct t7xx_port md_ccci_ports[] = {
-	{0, 0, 0, 0, 0, 0, ID_CLDMA1, 0, &dummy_port_ops, 0xff, "dummy_port",},
+	{CCCI_CONTROL_TX, CCCI_CONTROL_RX, 0, 0, 0, 0, ID_CLDMA1,
+	 0, &ctl_port_ops, 0xff, "ccci_ctrl",},
 };
 
 static int port_netlink_send_msg(struct t7xx_port *port, int grp,
@@ -576,6 +575,10 @@ static void proxy_init_all_ports(struct mtk_modem *md)
 
 	for_each_proxy_port(i, port, port_prox) {
 		port_struct_init(port);
+		if (port->tx_ch == CCCI_CONTROL_TX) {
+			port_prox->ctl_port = port;
+			md->core_md.ctl_port = port;
+		}
 
 		port->major = port_prox->major;
 		port->minor_base = port_prox->minor_base;
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index f8d4ec27ec38..d709b2d781f6 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -37,6 +37,7 @@ struct port_proxy {
 	unsigned int		major;
 	unsigned int		minor_base;
 	struct t7xx_port	*ports;
+	struct t7xx_port	*ctl_port;
 	struct t7xx_port	*dedicated_ports[CLDMA_NUM][MTK_MAX_QUEUE_NUM];
 	/* port list of each RX channel, for RX dispatching */
 	struct list_head	rx_ch_ports[CCCI_MAX_CH_ID];
@@ -72,6 +73,9 @@ struct port_msg {
 #define PORT_ENUM_TAIL_PATTERN	0xa5a5a5a5
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
+/* port operations mapping */
+extern struct port_ops ctl_port_ops;
+
 int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool);
 void port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h);
 int port_proxy_node_control(struct device *dev, struct port_msg *port_msg);
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 5eeba515b057..9c9dd3c03678 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -327,6 +327,9 @@ static void fsm_routine_starting(struct ccci_fsm_ctl *ctl)
 
 	if (!atomic_read(&md->core_md.ready)) {
 		dev_err(dev, "MD handshake timeout\n");
+		if (atomic_read(&md->core_md.handshake_ongoing))
+			fsm_append_event(ctl, CCCI_EVENT_MD_HS2_EXIT, NULL, 0);
+
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 	} else {
 		fsm_routine_ready(ctl);
-- 
2.17.1

