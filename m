Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DD946B0DE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhLGCvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:51:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:27273 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhLGCvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:51:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300860567"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="300860567"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="748524151"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:47 -0800
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
Subject: [PATCH net-next v3 05/12] net: wwan: t7xx: Add AT and MBIM WWAN ports
Date:   Mon,  6 Dec 2021 19:47:04 -0700
Message-Id: <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

Adds AT and MBIM ports to the port proxy infrastructure.
The initialization method is responsible for creating the corresponding
ports using the WWAN framework infrastructure. The implemented WWAN port
operations are start, stop, and TX.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile          |   1 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  24 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   1 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c  | 258 ++++++++++++++++++++++++
 4 files changed, 284 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 63e1c67b82b5..9eec2e2472fb 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -12,3 +12,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_cldma.o  \
 		t7xx_port_proxy.o  \
 		t7xx_port_ctrl_msg.o \
+		t7xx_port_wwan.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 67219319e9f7..4c6f255c4d2f 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -51,6 +51,30 @@
 
 static struct t7xx_port_static t7xx_md_ports[] = {
 	{
+		.tx_ch = PORT_CH_UART2_TX,
+		.rx_ch = PORT_CH_UART2_RX,
+		.txq_index = Q_IDX_AT_CMD,
+		.rxq_index = Q_IDX_AT_CMD,
+		.txq_exp_index = 0xff,
+		.rxq_exp_index = 0xff,
+		.path_id = ID_CLDMA1,
+		.flags = PORT_F_RX_CHAR_NODE,
+		.ops = &wwan_sub_port_ops,
+		.name = "AT",
+		.port_type = WWAN_PORT_AT,
+	}, {
+		.tx_ch = PORT_CH_MBIM_TX,
+		.rx_ch = PORT_CH_MBIM_RX,
+		.txq_index = Q_IDX_MBIM,
+		.rxq_index = Q_IDX_MBIM,
+		.txq_exp_index = 0,
+		.rxq_exp_index = 0,
+		.path_id = ID_CLDMA1,
+		.flags = PORT_F_RX_CHAR_NODE,
+		.ops = &wwan_sub_port_ops,
+		.name = "MBIM",
+		.port_type = WWAN_PORT_MBIM,
+	}, {
 		.tx_ch = PORT_CH_CONTROL_TX,
 		.rx_ch = PORT_CH_CONTROL_RX,
 		.txq_index = Q_IDX_CTRL,
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index 06ccda839445..1f49d1ef6bad 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -67,6 +67,7 @@ struct port_msg {
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
 /* Port operations mapping */
+extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
 
 int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
new file mode 100644
index 000000000000..79831291e490
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <linux/dev_printk.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/minmax.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/wwan.h>
+
+#include "t7xx_common.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+static int t7xx_port_ctrl_start(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk = wwan_port_get_drvdata(port);
+
+	if (atomic_read(&port_mtk->usage_cnt))
+		return -EBUSY;
+
+	atomic_inc(&port_mtk->usage_cnt);
+	return 0;
+}
+
+static void t7xx_port_ctrl_stop(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk = wwan_port_get_drvdata(port);
+
+	atomic_dec(&port_mtk->usage_cnt);
+}
+
+static inline bool t7xx_port_wwan_multipkt_capable(struct t7xx_port_static *port)
+{
+	return port->tx_ch == PORT_CH_MBIM_TX ||
+		(port->tx_ch >= PORT_CH_DSS0_TX && port->tx_ch <= PORT_CH_DSS7_TX);
+}
+
+static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
+	size_t actual_count = 0, alloc_size = 0, txq_mtu = 0;
+	struct t7xx_port_static *port_static;
+	int i, multi_packet = 1, ret = 0;
+	struct sk_buff *skb_ccci = NULL;
+	struct t7xx_fsm_ctl *ctl;
+	enum md_state md_state;
+	unsigned int count;
+	bool port_multi;
+
+	count = skb->len;
+	if (!count)
+		return -EINVAL;
+
+	port_static = port_private->port_static;
+	ctl = port_private->t7xx_dev->md->fsm_ctl;
+	md_state = t7xx_fsm_get_md_state(ctl);
+	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
+		dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
+			 port_static->name, md_state);
+		return -ENODEV;
+	}
+
+	txq_mtu = CLDMA_TXQ_MTU;
+
+	if (port_private->flags & PORT_F_USER_HEADER) {
+		if (port_private->flags & PORT_F_USER_HEADER && count > txq_mtu) {
+			dev_err(port_private->dev, "Packet %u larger than MTU on %s port\n",
+				count, port_static->name);
+			return -ENOMEM;
+		}
+
+		alloc_size = min_t(size_t, txq_mtu, count);
+		actual_count = alloc_size;
+	} else {
+		alloc_size = min_t(size_t, txq_mtu, count + CCCI_H_ELEN);
+		actual_count = alloc_size - CCCI_H_ELEN;
+		port_multi = t7xx_port_wwan_multipkt_capable(port_static);
+		if ((count + CCCI_H_ELEN > txq_mtu) && port_multi)
+			multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);
+	}
+
+	for (i = 0; i < multi_packet; i++) {
+		struct ccci_header *ccci_h = NULL;
+
+		if (multi_packet > 1 && multi_packet == i + 1) {
+			actual_count = count % (txq_mtu - CCCI_H_ELEN);
+			alloc_size = actual_count + CCCI_H_ELEN;
+		}
+
+		skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
+		if (!skb_ccci)
+			return -ENOMEM;
+
+		ccci_h = skb_put(skb_ccci, CCCI_H_LEN);
+		ccci_h->packet_header = 0;
+		ccci_h->packet_len = cpu_to_le32(actual_count + CCCI_H_LEN);
+		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
+		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
+		ccci_h->ex_msg = 0;
+
+		memcpy(skb_put(skb_ccci, actual_count), skb->data + i * (txq_mtu - CCCI_H_ELEN),
+		       actual_count);
+
+		t7xx_port_proxy_set_seq_num(port_private, ccci_h);
+
+		ret = t7xx_port_send_skb_to_md(port_private, skb_ccci, true);
+		if (ret)
+			goto err_free_skb;
+
+		port_private->seq_nums[MTK_TX]++;
+
+		if (multi_packet == 1)
+			return actual_count;
+		else if (multi_packet == i + 1)
+			return count;
+	}
+
+err_free_skb:
+	if (ret != -ENOMEM) {
+		dev_err(port_private->dev, "Write error on %s port, %d\n", port_static->name, ret);
+		dev_kfree_skb_any(skb_ccci);
+	}
+
+	return ret;
+}
+
+static const struct wwan_port_ops wwan_ops = {
+	.start = t7xx_port_ctrl_start,
+	.stop = t7xx_port_ctrl_stop,
+	.tx = t7xx_port_ctrl_tx,
+};
+
+static int t7xx_port_wwan_init(struct t7xx_port *port)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	port->rx_length_th = MAX_RX_QUEUE_LENGTH;
+	port->flags |= PORT_F_RX_ADJUST_HEADER;
+
+	if (port_static->rx_ch == PORT_CH_UART2_RX)
+		port->flags |= PORT_F_RX_CH_TRAFFIC;
+
+	if (port_static->port_type != WWAN_PORT_UNKNOWN) {
+		port->wwan_port = wwan_create_port(port->dev, port_static->port_type,
+						   &wwan_ops, port);
+		if (IS_ERR(port->wwan_port))
+			return PTR_ERR(port->wwan_port);
+	} else {
+		port->wwan_port = NULL;
+	}
+
+	return 0;
+}
+
+static void t7xx_port_wwan_uninit(struct t7xx_port *port)
+{
+	if (port->wwan_port) {
+		if (port->chn_crt_stat) {
+			spin_lock(&port->port_update_lock);
+			port->chn_crt_stat = false;
+			spin_unlock(&port->port_update_lock);
+		}
+
+		wwan_remove_port(port->wwan_port);
+		port->wwan_port = NULL;
+	}
+}
+
+static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	if (port->flags & PORT_F_RX_CHAR_NODE) {
+		if (!atomic_read(&port->usage_cnt)) {
+			dev_err_ratelimited(port->dev, "Port %s is not opened, drop packets\n",
+					    port_static->name);
+			return -ENETDOWN;
+		}
+	}
+
+	return t7xx_port_recv_skb(port, skb);
+}
+
+static void port_status_update(struct t7xx_port *port)
+{
+	if (port->flags & PORT_F_RX_CHAR_NODE) {
+		if (port->chan_enable) {
+			port->flags &= ~PORT_F_RX_ALLOW_DROP;
+		} else {
+			port->flags |= PORT_F_RX_ALLOW_DROP;
+			spin_lock(&port->port_update_lock);
+			port->chn_crt_stat = false;
+			spin_unlock(&port->port_update_lock);
+		}
+	}
+}
+
+static int t7xx_port_wwan_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = true;
+	spin_unlock(&port->port_update_lock);
+
+	if (port->chn_crt_stat != port->chan_enable)
+		port_status_update(port);
+
+	return 0;
+}
+
+static int t7xx_port_wwan_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = false;
+	spin_unlock(&port->port_update_lock);
+
+	if (port->chn_crt_stat != port->chan_enable)
+		port_status_update(port);
+
+	return 0;
+}
+
+static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	if (state == MD_STATE_READY)
+		port_status_update(port);
+}
+
+struct port_ops wwan_sub_port_ops = {
+	.init = &t7xx_port_wwan_init,
+	.recv_skb = &t7xx_port_wwan_recv_skb,
+	.uninit = &t7xx_port_wwan_uninit,
+	.enable_chl = &t7xx_port_wwan_enable_chl,
+	.disable_chl = &t7xx_port_wwan_disable_chl,
+	.md_state_notify = &t7xx_port_wwan_md_state_notify,
+};
-- 
2.17.1

