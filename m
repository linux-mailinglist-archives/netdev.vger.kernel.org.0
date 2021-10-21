Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF17A436C25
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhJUUcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:32:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:46172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhJUUcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="315343863"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="315343863"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:23 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625073"
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
Subject: [PATCH 06/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
Date:   Thu, 21 Oct 2021 13:27:30 -0700
Message-Id: <20211021202738.729-7-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds AT and MBIM ports to the port proxy infrastructure.
The initialization method is responsible for creating the corresponding
ports using the WWAN framework infrastructure. The implemented WWAN port
operations are start, stop, and TX.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile          |   1 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |   4 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   1 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c  | 271 ++++++++++++++++++++++++
 4 files changed, 277 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index b0fac99420a0..9b3cc4c5ebae 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -13,3 +13,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_cldma.o  \
 		t7xx_port_proxy.o  \
 		t7xx_port_ctrl_msg.o \
+		t7xx_port_wwan.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 8e7fada49fc0..6d97d21d9d13 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -41,6 +41,10 @@ static struct port_proxy *port_prox;
 	     i++, (p) = &(proxy)->ports[i])
 
 static struct t7xx_port md_ccci_ports[] = {
+	{CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, DATA_AT_CMD_Q, 0xff,
+	 0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 0, "ttyC0", WWAN_PORT_AT},
+	{CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", WWAN_PORT_MBIM},
 	{CCCI_CONTROL_TX, CCCI_CONTROL_RX, 0, 0, 0, 0, ID_CLDMA1,
 	 0, &ctl_port_ops, 0xff, "ccci_ctrl",},
 };
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index d709b2d781f6..ca3acb2e0020 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -74,6 +74,7 @@ struct port_msg {
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
 /* port operations mapping */
+extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
 
 int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
new file mode 100644
index 000000000000..f2cb7c9cffd0
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+#include <linux/bitfield.h>
+
+#include "t7xx_common.h"
+#include "t7xx_hif_cldma.h"
+#include "t7xx_monitor.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_skb_util.h"
+
+static int mtk_port_ctrl_start(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk;
+
+	port_mtk = wwan_port_get_drvdata(port);
+
+	if (atomic_read(&port_mtk->usage_cnt))
+		return -EBUSY;
+
+	atomic_inc(&port_mtk->usage_cnt);
+	return 0;
+}
+
+static void mtk_port_ctrl_stop(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk;
+
+	port_mtk = wwan_port_get_drvdata(port);
+
+	atomic_dec(&port_mtk->usage_cnt);
+}
+
+static int mtk_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	size_t actual_count = 0, alloc_size = 0, txq_mtu = 0;
+	struct sk_buff *skb_ccci = NULL;
+	struct t7xx_port *port_ccci;
+	int i, multi_packet = 1;
+	enum md_state md_state;
+	unsigned int count;
+	int ret = 0;
+
+	count = skb->len;
+	if (!count)
+		return -EINVAL;
+
+	port_ccci = wwan_port_get_drvdata(port);
+	md_state = ccci_fsm_get_md_state();
+	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
+		dev_warn(port_ccci->dev, "port %s ch%d write fail when md_state=%d!\n",
+			 port_ccci->name, port_ccci->tx_ch, md_state);
+		return -ENODEV;
+	}
+
+	txq_mtu = CLDMA_TXQ_MTU;
+
+	if (port_ccci->flags & PORT_F_RAW_DATA || port_ccci->flags & PORT_F_USER_HEADER) {
+		if (port_ccci->flags & PORT_F_USER_HEADER && count > txq_mtu) {
+			dev_err(port_ccci->dev, "reject packet(size=%u), larger than MTU on %s\n",
+				count, port_ccci->name);
+			return -ENOMEM;
+		}
+
+		alloc_size = min_t(size_t, txq_mtu, count);
+		actual_count = alloc_size;
+	} else {
+		alloc_size = min_t(size_t, txq_mtu, count + CCCI_H_ELEN);
+		actual_count = alloc_size - CCCI_H_ELEN;
+		if (count + CCCI_H_ELEN > txq_mtu &&
+		    (port_ccci->tx_ch == CCCI_MBIM_TX ||
+		     (port_ccci->tx_ch >= CCCI_DSS0_TX && port_ccci->tx_ch <= CCCI_DSS7_TX)))
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
+		skb_ccci = ccci_alloc_skb_from_pool(&port_ccci->mtk_dev->pools, alloc_size,
+						    GFS_BLOCKING);
+		if (!skb_ccci)
+			return -ENOMEM;
+
+		if (port_ccci->flags & PORT_F_RAW_DATA) {
+			memcpy(skb_put(skb_ccci, actual_count), skb->data, actual_count);
+
+			if (port_ccci->flags & PORT_F_USER_HEADER) {
+				/* The ccci_header is provided by user.
+				 *
+				 * For only send ccci_header without additional data
+				 * case, data[0]=CCCI_HEADER_NO_DATA, data[1]=user_data,
+				 * ch=tx_channel, reserved=no_use.
+				 *
+				 * For send ccci_header
+				 * with additional data case, data[0]=0,
+				 * data[1]=data_size, ch=tx_channel,
+				 * reserved=user_data.
+				 */
+				ccci_h = (struct ccci_header *)skb->data;
+				if (actual_count == CCCI_H_LEN)
+					ccci_h->data[0] = CCCI_HEADER_NO_DATA;
+				else
+					ccci_h->data[1] = actual_count;
+
+				ccci_h->status &= ~HDR_FLD_CHN;
+				ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, port_ccci->tx_ch);
+			}
+		} else {
+			/* ccci_header is provided by driver */
+			ccci_h = skb_put(skb_ccci, CCCI_H_LEN);
+			ccci_h->data[0] = 0;
+			ccci_h->data[1] = actual_count + CCCI_H_LEN;
+			ccci_h->status &= ~HDR_FLD_CHN;
+			ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, port_ccci->tx_ch);
+			ccci_h->reserved = 0;
+
+			memcpy(skb_put(skb_ccci, actual_count),
+			       skb->data + i * (txq_mtu - CCCI_H_ELEN), actual_count);
+		}
+
+		port_proxy_set_seq_num(port_ccci, ccci_h);
+		ret = port_send_skb_to_md(port_ccci, skb_ccci, true);
+		if (ret)
+			goto err_out;
+
+		/* record the port seq_num after the data is sent to HIF */
+		port_ccci->seq_nums[MTK_OUT]++;
+
+		if (multi_packet == 1)
+			return actual_count;
+		else if (multi_packet == i + 1)
+			return count;
+	}
+
+err_out:
+	if (ret != -ENOMEM) {
+		dev_err(port_ccci->dev, "write error done on %s, size=%zu, ret=%d\n",
+			port_ccci->name, actual_count, ret);
+		ccci_free_skb(&port_ccci->mtk_dev->pools, skb_ccci);
+	}
+
+	return ret;
+}
+
+static const struct wwan_port_ops mtk_wwan_port_ops = {
+	.start = mtk_port_ctrl_start,
+	.stop = mtk_port_ctrl_stop,
+	.tx = mtk_port_ctrl_tx,
+};
+
+static int port_wwan_init(struct t7xx_port *port)
+{
+	port->rx_length_th = MAX_RX_QUEUE_LENGTH;
+	port->skb_from_pool = true;
+
+	if (!(port->flags & PORT_F_RAW_DATA))
+		port->flags |= PORT_F_RX_ADJUST_HEADER;
+
+	if (port->rx_ch == CCCI_UART2_RX)
+		port->flags |= PORT_F_RX_CH_TRAFFIC;
+
+	if (port->mtk_port_type != WWAN_PORT_UNKNOWN) {
+		port->mtk_wwan_port =
+			wwan_create_port(port->dev, port->mtk_port_type, &mtk_wwan_port_ops, port);
+		if (IS_ERR(port->mtk_wwan_port))
+			return PTR_ERR(port->mtk_wwan_port);
+	} else {
+		port->mtk_wwan_port = NULL;
+	}
+
+	return 0;
+}
+
+static void port_wwan_uninit(struct t7xx_port *port)
+{
+	if (port->mtk_wwan_port) {
+		if (port->chn_crt_stat == CCCI_CHAN_ENABLE) {
+			spin_lock(&port->port_update_lock);
+			port->chn_crt_stat = CCCI_CHAN_DISABLE;
+			spin_unlock(&port->port_update_lock);
+		}
+
+		wwan_remove_port(port->mtk_wwan_port);
+		port->mtk_wwan_port = NULL;
+	}
+}
+
+static int port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	if (port->flags & PORT_F_RX_CHAR_NODE) {
+		if (!atomic_read(&port->usage_cnt)) {
+			dev_err_ratelimited(port->dev, "port %s is not opened, drop packets\n",
+					    port->name);
+			return -ENETDOWN;
+		}
+	}
+
+	return port_recv_skb(port, skb);
+}
+
+static int port_status_update(struct t7xx_port *port)
+{
+	if (port->flags & PORT_F_RX_CHAR_NODE) {
+		if (port->chan_enable == CCCI_CHAN_ENABLE) {
+			port->flags &= ~PORT_F_RX_ALLOW_DROP;
+		} else {
+			port->flags |= PORT_F_RX_ALLOW_DROP;
+			spin_lock(&port->port_update_lock);
+			port->chn_crt_stat = CCCI_CHAN_DISABLE;
+			spin_unlock(&port->port_update_lock);
+			return port_proxy_broadcast_state(port, MTK_PORT_STATE_DISABLE);
+		}
+	}
+
+	return 0;
+}
+
+static int port_wwan_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_ENABLE;
+	spin_unlock(&port->port_update_lock);
+
+	if (port->chn_crt_stat != port->chan_enable)
+		return port_status_update(port);
+
+	return 0;
+}
+
+static int port_wwan_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_DISABLE;
+	spin_unlock(&port->port_update_lock);
+
+	if (port->chn_crt_stat != port->chan_enable)
+		return port_status_update(port);
+
+	return 0;
+}
+
+static void port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	if (state == MD_STATE_READY)
+		port_status_update(port);
+}
+
+struct port_ops wwan_sub_port_ops = {
+	.init = &port_wwan_init,
+	.recv_skb = &port_wwan_recv_skb,
+	.uninit = &port_wwan_uninit,
+	.enable_chl = &port_wwan_enable_chl,
+	.disable_chl = &port_wwan_disable_chl,
+	.md_state_notify = &port_wwan_md_state_notify,
+};
-- 
2.17.1

