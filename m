Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C68C4F8ADE
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiDGWjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiDGWj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:39:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF1B12B5EB;
        Thu,  7 Apr 2022 15:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649371037; x=1680907037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+AleXrw1ZaVg9bxnjQZkhhHzcdp3WgkGudpTG4eA8w4=;
  b=UzFCA2iX8B0iYYgjMTJ5C13GNYOg+W7ssKg93jf2c/15IXXB6rxWoLlK
   WE1q9TCu+yu0kDlR97wCxZmSuJk8rMYU0YajlkCgbWtUYgcl3YgxLd4jb
   0G1d0W7rzF1jAFT2eZxpdn6Aazvc7IoJHDlX50fsEXxVnlpVHi8wrqIq5
   PFVcpdkAhAQMoMzm5pW9SMOLLzXY4zBRQodtZwCPRjgOZr8mUnsIBkiYI
   nW0Jr2Th861RpEqJYi4x7iC4lIEDGNYOMYNGLQ6cKYylAsbF09+icg78X
   NsBzxY5YztllNIRbYQiRu0kZXtccy6O0HSLjurLSP+y/FoWbkW+veHtC4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261449312"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="261449312"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="659242883"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
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
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v6 05/13] net: wwan: t7xx: Add control port
Date:   Thu,  7 Apr 2022 15:36:21 -0700
Message-Id: <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From a WWAN framework perspective:
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 214 +++++++++++++++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   3 +
 drivers/net/wwan/t7xx/t7xx_port.h          |   3 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c | 273 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    |  43 +++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  25 ++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   3 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   2 +
 9 files changed, 563 insertions(+), 4 deletions(-)
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
index d1d3384608be..d97350238540 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -16,6 +16,8 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/bits.h>
+#include <linux/bitfield.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/gfp.h>
@@ -26,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/wait.h>
 #include <linux/workqueue.h>
 
 #include "t7xx_cldma.h"
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
@@ -314,16 +330,205 @@ static void t7xx_md_sys_sw_init(struct t7xx_pci_dev *t7xx_dev)
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
+	struct feature_query *ft_query;
+	struct sk_buff *skb;
+
+	skb = t7xx_ctrl_alloc_skb(sizeof(*ft_query));
+	if (!skb)
+		return;
+
+	ft_query = skb_put(skb, sizeof(*ft_query));
+	ft_query->head_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
+	memcpy(ft_query->feature_set, core->feature_set, FEATURE_COUNT);
+	ft_query->tail_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
+
+	/* Send HS1 message to device */
+	t7xx_port_send_ctl_skb(core->ctl_port, skb, CTL_ID_HS1_MSG, 0);
+}
+
+static int t7xx_prepare_device_rt_data(struct t7xx_sys_info *core, struct device *dev,
+				       void *data)
+{
+	struct feature_query *md_feature = data;
+	struct mtk_runtime_feature *rt_feature;
+	unsigned int i, rt_data_len = 0;
+	struct sk_buff *skb;
+
+	/* Parse MD runtime data query */
+	if (le32_to_cpu(md_feature->head_pattern) != MD_FEATURE_QUERY_ID ||
+	    le32_to_cpu(md_feature->tail_pattern) != MD_FEATURE_QUERY_ID) {
+		dev_err(dev, "Invalid feature pattern: head 0x%x, tail 0x%x\n",
+			le32_to_cpu(md_feature->head_pattern),
+			le32_to_cpu(md_feature->tail_pattern));
+		return -EINVAL;
+	}
+
+	for (i = 0; i < FEATURE_COUNT; i++) {
+		if (FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]) !=
+		    MTK_FEATURE_MUST_BE_SUPPORTED)
+			rt_data_len += sizeof(*rt_feature);
+	}
+
+	skb = t7xx_ctrl_alloc_skb(rt_data_len);
+	if (!skb)
+		return -ENOMEM;
+
+	rt_feature  = skb_put(skb, rt_data_len);
+	memset(rt_feature, 0, rt_data_len);
+
+	/* Fill runtime feature */
+	for (i = 0; i < FEATURE_COUNT; i++) {
+		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
+
+		if (md_feature_mask == MTK_FEATURE_MUST_BE_SUPPORTED)
+			continue;
+
+		rt_feature->feature_id = i;
+		if (md_feature_mask == MTK_FEATURE_DOES_NOT_EXIST)
+			rt_feature->support_info = md_feature->feature_set[i];
+
+		rt_feature++;
+	}
+
+	/* Send HS3 message to device */
+	t7xx_port_send_ctl_skb(core->ctl_port, skb, CTL_ID_HS3_MSG, 0);
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
+		offset += sizeof(*rt_feature) + le32_to_cpu(rt_feature->data_len);
+
+		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
+		if (ft_spt_cfg != MTK_FEATURE_MUST_BE_SUPPORTED)
+			continue;
+
+		ft_spt_st = FIELD_GET(FEATURE_MSK, rt_feature->support_info);
+		if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED)
+			return -EINVAL;
+
+		if (i == RT_ID_MD_PORT_ENUM)
+			t7xx_port_enum_msg_handler(ctl->md, rt_feature->data);
+	}
+
+	return 0;
+}
+
+static int t7xx_core_reset(struct t7xx_modem *md)
+{
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	md->core_md.ready = false;
+
+	if (!ctl) {
+		dev_err(dev, "FSM is not initialized\n");
+		return -EINVAL;
+	}
+
+	if (md->core_md.handshake_ongoing) {
+		int ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
+
+		if (ret)
+			return ret;
+	}
+
+	md->core_md.handshake_ongoing = false;
+	return 0;
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
+	ret = t7xx_parse_host_rt_data(ctl, core_info, dev, event->data, event->length);
+	if (ret) {
+		dev_err(dev, "Host failure parsing runtime data: %d\n", ret);
+		goto err_free_event;
+	}
+
+	if (ctl->exp_flg)
+		goto err_free_event;
+
+	ret = t7xx_prepare_device_rt_data(core_info, dev, event->data);
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
 	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
-	md->core_md.ready = true;
-	wake_up(&ctl->async_hk_wq);
+	md->core_md.handshake_ongoing = true;
+	t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
 }
 
 void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
@@ -418,6 +623,9 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 		return NULL;
 
 	INIT_WORK(&md->handshake_work, t7xx_md_hk_wq);
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
+		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
 	return md;
 }
 
@@ -431,7 +639,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
 	t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_port_proxy_reset(md->port_prox);
 	md->md_init_finish = true;
-	return 0;
+	return t7xx_core_reset(md);
 }
 
 /**
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
index 1fc286fa1a14..7469ed636ae8 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -57,6 +57,9 @@ enum md_event_id {
 
 struct t7xx_sys_info {
 	bool				ready;
+	bool				handshake_ongoing;
+	u8				feature_set[FEATURE_COUNT];
+	struct t7xx_port		*ctl_port;
 };
 
 struct t7xx_modem {
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index 3abf092bcd88..f4edec38fd28 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -129,8 +129,11 @@ struct t7xx_port {
 };
 
 struct sk_buff *t7xx_port_alloc_skb(int payload);
+struct sk_buff *t7xx_ctrl_alloc_skb(int payload);
 int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);
 int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
 		       unsigned int ex_msg);
+int t7xx_port_send_ctl_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int msg,
+			   unsigned int ex_msg);
 
 #endif /* __T7XX_PORT_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
new file mode 100644
index 000000000000..01df69b25a5d
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Ricardo Martinez <ricardo.martinez@linux.intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kthread.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+#define PORT_MSG_VERSION	GENMASK(31, 16)
+#define PORT_MSG_PRT_CNT	GENMASK(15, 0)
+
+struct port_msg {
+	__le32	head_pattern;
+	__le32	info;
+	__le32	tail_pattern;
+	__le32	data[];
+};
+
+static int port_ctl_send_msg_to_md(struct t7xx_port *port, unsigned int msg, unsigned int ex_msg)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	skb = t7xx_ctrl_alloc_skb(0);
+	if (!skb)
+		return -ENOMEM;
+
+	ret = t7xx_port_send_ctl_skb(port, skb, msg, ex_msg);
+	if (ret)
+		dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+static int fsm_ee_message_handler(struct t7xx_port *port, struct t7xx_fsm_ctl *ctl,
+				  struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
+	enum md_state md_state;
+	int ret = -EINVAL;
+
+	md_state = t7xx_fsm_get_md_state(ctl);
+	if (md_state != MD_STATE_EXCEPTION) {
+		dev_err(dev, "Receive invalid MD_EX %x when MD state is %d\n",
+			ctrl_msg_h->ex_msg, md_state);
+		return -EINVAL;
+	}
+
+	switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {
+	case CTL_ID_MD_EX:
+		if (le32_to_cpu(ctrl_msg_h->ex_msg) != MD_EX_CHK_ID) {
+			dev_err(dev, "Receive invalid MD_EX %x\n", ctrl_msg_h->ex_msg);
+			break;
+		}
+
+		ret = port_ctl_send_msg_to_md(port, CTL_ID_MD_EX, MD_EX_CHK_ID);
+		if (ret) {
+			dev_err(dev, "Failed to send exception message to modem\n");
+			break;
+		}
+
+		ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX, NULL, 0);
+		if (ret)
+			dev_err(dev, "Failed to append Modem Exception event");
+
+		break;
+
+	case CTL_ID_MD_EX_ACK:
+		if (le32_to_cpu(ctrl_msg_h->ex_msg) != MD_EX_CHK_ACK_ID) {
+			dev_err(dev, "Receive invalid MD_EX_ACK %x\n", ctrl_msg_h->ex_msg);
+			break;
+		}
+
+		ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX_REC_OK, NULL, 0);
+		if (ret)
+			dev_err(dev, "Failed to append Modem Exception Received event");
+
+		break;
+
+	case CTL_ID_MD_EX_PASS:
+		ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_EX_PASS, NULL, 0);
+		if (ret)
+			dev_err(dev, "Failed to append Modem Exception Passed event");
+
+		break;
+
+	case CTL_ID_DRV_VER_ERROR:
+		dev_err(dev, "AP/MD driver version mismatch\n");
+	}
+
+	return ret;
+}
+
+/**
+ * t7xx_port_enum_msg_handler() - Parse the port enumeration message to create/remove nodes.
+ * @md: Modem context.
+ * @msg: Message.
+ *
+ * Used to control create/remove device node.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -EFAULT	- Message check failure.
+ */
+int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg)
+{
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	unsigned int version, port_count, i;
+	struct port_msg *port_msg = msg;
+
+	version = FIELD_GET(PORT_MSG_VERSION, le32_to_cpu(port_msg->info));
+	if (version != PORT_ENUM_VER ||
+	    le32_to_cpu(port_msg->head_pattern) != PORT_ENUM_HEAD_PATTERN ||
+	    le32_to_cpu(port_msg->tail_pattern) != PORT_ENUM_TAIL_PATTERN) {
+		dev_err(dev, "Invalid port control message %x:%x:%x\n",
+			version, le32_to_cpu(port_msg->head_pattern),
+			le32_to_cpu(port_msg->tail_pattern));
+		return -EFAULT;
+	}
+
+	port_count = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
+	for (i = 0; i < port_count; i++) {
+		u32 port_info = le32_to_cpu(port_msg->data[i]);
+		unsigned int ch_id;
+		bool en_flag;
+
+		ch_id = FIELD_GET(PORT_INFO_CH_ID, port_info);
+		en_flag = !!(port_info & PORT_INFO_ENFLG);
+		if (t7xx_port_proxy_chl_enable_disable(md->port_prox, ch_id, en_flag))
+			dev_dbg(dev, "Port:%x not found\n", ch_id);
+	}
+
+	return 0;
+}
+
+static int control_msg_handler(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+	struct t7xx_port_conf *port_conf = port->port_conf;
+	struct ctrl_msg_header *ctrl_msg_h;
+	int ret = 0;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {
+	case CTL_ID_HS2_MSG:
+		skb_pull(skb, sizeof(*ctrl_msg_h));
+
+		if (port_conf->rx_ch == PORT_CH_CONTROL_RX) {
+			ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2, skb->data,
+						    le32_to_cpu(ctrl_msg_h->data_length));
+			if (ret)
+				dev_err(port->dev, "Failed to append Handshake 2 event");
+		}
+
+		dev_kfree_skb_any(skb);
+		break;
+
+	case CTL_ID_MD_EX:
+	case CTL_ID_MD_EX_ACK:
+	case CTL_ID_MD_EX_PASS:
+	case CTL_ID_DRV_VER_ERROR:
+		ret = fsm_ee_message_handler(port, ctl, skb);
+		dev_kfree_skb_any(skb);
+		break;
+
+	case CTL_ID_PORT_ENUM:
+		skb_pull(skb, sizeof(*ctrl_msg_h));
+		ret = t7xx_port_enum_msg_handler(ctl->md, (struct port_msg *)skb->data);
+		if (!ret)
+			ret = port_ctl_send_msg_to_md(port, CTL_ID_PORT_ENUM, 0);
+		else
+			ret = port_ctl_send_msg_to_md(port, CTL_ID_PORT_ENUM,
+						      PORT_ENUM_VER_MISMATCH);
+
+		break;
+
+	default:
+		ret = -EINVAL;
+		dev_err(port->dev, "Unknown control message ID to FSM %x\n",
+			le32_to_cpu(ctrl_msg_h->ctrl_msg_id));
+		break;
+	}
+
+	if (ret)
+		dev_err(port->dev, "%s control message handle error: %d\n", port_conf->name, ret);
+
+	return ret;
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
+		if (kthread_should_stop()) {
+			spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+			break;
+		}
+		skb = __skb_dequeue(&port->rx_skb_list);
+		spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+
+		control_msg_handler(port, skb);
+	}
+
+	return 0;
+}
+
+static int port_ctl_init(struct t7xx_port *port)
+{
+	struct t7xx_port_conf *port_conf = port->port_conf;
+
+	port->thread = kthread_run(port_ctl_rx_thread, port, "%s", port_conf->name);
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
+	port->rx_length_th = 0;
+	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
+		dev_kfree_skb_any(skb);
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+}
+
+struct port_ops ctl_port_ops = {
+	.init = port_ctl_init,
+	.recv_skb = t7xx_port_enqueue_skb,
+	.uninit = port_ctl_uninit,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 8d813b0c144d..a76d65c070bd 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -48,7 +48,17 @@
 	     i < (proxy)->port_number;		\
 	     i++, (p) = &(proxy)->ports[i])
 
-static struct t7xx_port_conf t7xx_md_port_conf[] = {};
+static struct t7xx_port_conf t7xx_md_port_conf[] = {
+	{
+		.tx_ch = PORT_CH_CONTROL_TX,
+		.rx_ch = PORT_CH_CONTROL_RX,
+		.txq_index = Q_IDX_CTRL,
+		.rxq_index = Q_IDX_CTRL,
+		.path_id = CLDMA_ID_MD,
+		.ops = &ctl_port_ops,
+		.name = "t7xx_ctrl",
+	},
+};
 
 static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
 {
@@ -127,6 +137,16 @@ struct sk_buff *t7xx_port_alloc_skb(int payload)
 	return skb;
 }
 
+struct sk_buff *t7xx_ctrl_alloc_skb(int payload)
+{
+	struct sk_buff *skb = t7xx_port_alloc_skb(payload + sizeof(struct ctrl_msg_header));
+
+	if (skb)
+		skb_reserve(skb, sizeof(struct ctrl_msg_header));
+
+	return skb;
+}
+
 /**
  * t7xx_port_enqueue_skb() - Enqueue the received skb into the port's rx_skb_list.
  * @port: port context.
@@ -192,6 +212,24 @@ static int t7xx_port_send_ccci_skb(struct t7xx_port *port, struct sk_buff *skb,
 	return 0;
 }
 
+int t7xx_port_send_ctl_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int msg,
+			   unsigned int ex_msg)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	unsigned int msg_len = skb->len;
+	u32 pkt_header = 0;
+
+	ctrl_msg_h = skb_push(skb, sizeof(*ctrl_msg_h));
+	ctrl_msg_h->ctrl_msg_id = cpu_to_le32(msg);
+	ctrl_msg_h->ex_msg = cpu_to_le32(ex_msg);
+	ctrl_msg_h->data_length = cpu_to_le32(msg_len);
+
+	if (!msg_len)
+		pkt_header = CCCI_HEADER_NO_DATA;
+
+	return t7xx_port_send_ccci_skb(port, skb, pkt_header, ex_msg);
+}
+
 int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
 		       unsigned int ex_msg)
 {
@@ -356,6 +394,9 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
 
 		t7xx_port_struct_init(port);
 
+		if (port_conf->tx_ch == PORT_CH_CONTROL_TX)
+			md->core_md.ctl_port = port;
+
 		port->t7xx_dev = md->t7xx_dev;
 		port->dev = &md->t7xx_dev->pdev->dev;
 		spin_lock_init(&port->port_update_lock);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index 2bb50b18f1a1..300dd297f9e5 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -53,6 +53,27 @@ struct ccci_header {
 #define CCCI_H_SEQ_FLD		GENMASK(30, 16)
 #define CCCI_H_CHN_FLD		GENMASK(15, 0)
 
+struct ctrl_msg_header {
+	__le32	ctrl_msg_id;
+	__le32	ex_msg;
+	__le32	data_length;
+};
+
+/* Control identification numbers for AP<->MD messages  */
+#define CTL_ID_HS1_MSG		0x0
+#define CTL_ID_HS2_MSG		0x1
+#define CTL_ID_HS3_MSG		0x2
+#define CTL_ID_MD_EX		0x4
+#define CTL_ID_DRV_VER_ERROR	0x5
+#define CTL_ID_MD_EX_ACK	0x6
+#define CTL_ID_MD_EX_PASS	0x8
+#define CTL_ID_PORT_ENUM	0x9
+
+/* Modem exception check identification code - "EXCP" */
+#define MD_EX_CHK_ID		0x45584350
+/* Modem exception check acknowledge identification code - "EREC" */
+#define MD_EX_CHK_ACK_ID	0x45524543
+
 #define PORT_INFO_RSRVD		GENMASK(31, 16)
 #define PORT_INFO_ENFLG		BIT(15)
 #define PORT_INFO_CH_ID		GENMASK(14, 0)
@@ -62,10 +83,14 @@ struct ccci_header {
 #define PORT_ENUM_TAIL_PATTERN	0xa5a5a5a5
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
+/* Port operations mapping */
+extern struct port_ops ctl_port_ops;
+
 void t7xx_port_proxy_reset(struct port_proxy *port_prox);
 void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
 int t7xx_port_proxy_init(struct t7xx_modem *md);
 void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state);
+int t7xx_port_enum_msg_handler(struct t7xx_modem *md,  void *msg);
 int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned int ch_id,
 				       bool en_flag);
 
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 30f3739f1d83..d841f5051af8 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -293,6 +293,9 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
 
 	if (!md->core_md.ready) {
 		dev_err(dev, "MD handshake timeout\n");
+		if (md->core_md.handshake_ongoing)
+			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
+
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
index a6041a51809e..b1af0259d4c5 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
@@ -37,9 +37,11 @@ enum t7xx_fsm_state {
 
 enum t7xx_fsm_event_state {
 	FSM_EVENT_INVALID,
+	FSM_EVENT_MD_HS2,
 	FSM_EVENT_MD_EX,
 	FSM_EVENT_MD_EX_REC_OK,
 	FSM_EVENT_MD_EX_PASS,
+	FSM_EVENT_MD_HS2_EXIT,
 	FSM_EVENT_MAX
 };
 
-- 
2.17.1

