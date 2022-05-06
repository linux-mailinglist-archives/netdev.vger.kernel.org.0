Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F751DEDD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389411AbiEFSRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389412AbiEFSRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:17:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF766E8D6;
        Fri,  6 May 2022 11:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860800; x=1683396800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WnmvbH6CNRE+KRRtMsEATclI2bMOB+1GkI83ZD2iCAc=;
  b=RiEi4xttZvoxyvtd67Wp75pUHr+9ms71KOTiVQ3mZnQO0OE7qRQnDLPW
   gkDwWBXjpqzINnVmVItaVUm++wuEbkA9Wvof52IqjV157fExnKbTyXCQQ
   Knm2QuYDcK+X9NKKP2gAM+Rv/ye4uzqee0v7uvEoVS+2zTKzTfW/ZL8UA
   Um8OfG4VvPEG3cSVEMOUW5OvqwFicilQ5T82CT7P0scuuPymEMeeYfcMz
   L1I5Tw8mkjAqb0lxIgxdErZHZLoBsjTSPENsD2XSFSnIuCqfb2zsxjgVb
   Aau0ZHOD08uPDhn8P/IXFhhTv0P/iYTS5g7Iy0igQ05jWsmv5NlHlknpV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="267379056"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="267379056"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:13:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="621931091"
Received: from jpankrat-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.209.104.156])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:13:19 -0700
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
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH net-next v8 07/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
Date:   Fri,  6 May 2022 11:13:03 -0700
Message-Id: <20220506181310.2183829-8-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile          |   1 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  20 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   1 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c  | 176 ++++++++++++++++++++++++
 4 files changed, 198 insertions(+)
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
index 55f932d2c126..7d2c0e81e33d 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -50,6 +50,26 @@
 
 static const struct t7xx_port_conf t7xx_md_port_conf[] = {
 	{
+		.tx_ch = PORT_CH_UART2_TX,
+		.rx_ch = PORT_CH_UART2_RX,
+		.txq_index = Q_IDX_AT_CMD,
+		.rxq_index = Q_IDX_AT_CMD,
+		.txq_exp_index = 0xff,
+		.rxq_exp_index = 0xff,
+		.path_id = CLDMA_ID_MD,
+		.ops = &wwan_sub_port_ops,
+		.name = "AT",
+		.port_type = WWAN_PORT_AT,
+	}, {
+		.tx_ch = PORT_CH_MBIM_TX,
+		.rx_ch = PORT_CH_MBIM_RX,
+		.txq_index = Q_IDX_MBIM,
+		.rxq_index = Q_IDX_MBIM,
+		.path_id = CLDMA_ID_MD,
+		.ops = &wwan_sub_port_ops,
+		.name = "MBIM",
+		.port_type = WWAN_PORT_MBIM,
+	}, {
 		.tx_ch = PORT_CH_CONTROL_TX,
 		.rx_ch = PORT_CH_CONTROL_RX,
 		.txq_index = Q_IDX_CTRL,
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index 23f6af0ba3eb..bc1ff5c6c700 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -84,6 +84,7 @@ struct ctrl_msg_header {
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
 /* Port operations mapping */
+extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
 
 void t7xx_port_proxy_reset(struct port_proxy *port_prox);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
new file mode 100644
index 000000000000..33931bfd78fd
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez <ricardo.martinez@linux.intel.com>
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
+static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
+	size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
+	const struct t7xx_port_conf *port_conf;
+	struct t7xx_fsm_ctl *ctl;
+	enum md_state md_state;
+
+	len = skb->len;
+	if (!len || !port_private->chan_enable)
+		return -EINVAL;
+
+	port_conf = port_private->port_conf;
+	ctl = port_private->t7xx_dev->md->fsm_ctl;
+	md_state = t7xx_fsm_get_md_state(ctl);
+	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
+		dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
+			 port_conf->name, md_state);
+		return -ENODEV;
+	}
+
+	for (offset = 0; offset < len; offset += chunk_len) {
+		struct sk_buff *skb_ccci;
+		int ret;
+
+		chunk_len = min(len - offset, txq_mtu - sizeof(struct ccci_header));
+		skb_ccci = t7xx_port_alloc_skb(chunk_len);
+		if (!skb_ccci)
+			return -ENOMEM;
+
+		skb_put_data(skb_ccci, skb->data + offset, chunk_len);
+		ret = t7xx_port_send_skb(port_private, skb_ccci, 0, 0);
+		if (ret) {
+			dev_kfree_skb_any(skb_ccci);
+			dev_err(port_private->dev, "Write error on %s port, %d\n",
+				port_conf->name, ret);
+			return ret;
+		}
+	}
+
+	dev_kfree_skb(skb);
+	return 0;
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
+	port->rx_length_th = RX_QUEUE_MAXLEN;
+	return 0;
+}
+
+static void t7xx_port_wwan_uninit(struct t7xx_port *port)
+{
+	if (!port->wwan_port)
+		return;
+
+	port->rx_length_th = 0;
+	wwan_remove_port(port->wwan_port);
+	port->wwan_port = NULL;
+}
+
+static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	if (!atomic_read(&port->usage_cnt) || !port->chan_enable) {
+		const struct t7xx_port_conf *port_conf = port->port_conf;
+
+		dev_kfree_skb_any(skb);
+		dev_err_ratelimited(port->dev, "Port %s is not opened, drop packets\n",
+				    port_conf->name);
+		/* Dropping skb, caller should not access skb.*/
+		return 0;
+	}
+
+	wwan_port_rx(port->wwan_port, skb);
+	return 0;
+}
+
+static int t7xx_port_wwan_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = true;
+	spin_unlock(&port->port_update_lock);
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
+	return 0;
+}
+
+static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	const struct t7xx_port_conf *port_conf = port->port_conf;
+
+	if (state != MD_STATE_READY)
+		return;
+
+	if (!port->wwan_port) {
+		port->wwan_port = wwan_create_port(port->dev, port_conf->port_type,
+						   &wwan_ops, port);
+		if (IS_ERR(port->wwan_port))
+			dev_err(port->dev, "Unable to create WWWAN port %s", port_conf->name);
+	}
+}
+
+struct port_ops wwan_sub_port_ops = {
+	.init = t7xx_port_wwan_init,
+	.recv_skb = t7xx_port_wwan_recv_skb,
+	.uninit = t7xx_port_wwan_uninit,
+	.enable_chl = t7xx_port_wwan_enable_chl,
+	.disable_chl = t7xx_port_wwan_disable_chl,
+	.md_state_notify = t7xx_port_wwan_md_state_notify,
+};
-- 
2.25.1

