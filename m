Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E16348E1EC
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbiANBG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:27438 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235825AbiANBGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=EzCFLZVessNebctA+SGfCRiYvzDgySHCFh+lGjinp8Y=;
  b=TKjeTnj0HkHb6Y2voK12xkKixW2xXfScq6B6/uiPd2cgnKJ6sWRUajBq
   bdigkmI8RJqPdySODfPUsZ/2ax469G29591zU/uAjHzs3G0dc+mwe+SUZ
   9v+kH9gzoCGmyEtS+VDnWK49It1DWecsMxm+yhA+cVN1+4JoUXjTOr3Wq
   CghhDi9bMh1SnxqhU4Tt+2bNviJwZCmATyNdbWiq7hvTLxm5HxDcOPeT7
   fAnJN1ifNXj4MYUXr/56apH2FfGL96DaeX9guIcW4xi6Qr+aqUTqS83Mz
   BvsKeUBM4hoGZz+GeTEKO32NJ9ni+KX5yAAMWIeM5QCOCNVsX6FbdFmKk
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242970848"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242970848"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014195"
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
Subject: [PATCH net-next v4 04/13] net: wwan: t7xx: Add port proxy infrastructure
Date:   Thu, 13 Jan 2022 18:06:18 -0700
Message-Id: <20220114010627.21104-5-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Port-proxy provides a common interface to interact with different types
of ports. Ports export their configuration via `struct t7xx_port` and
operate as defined by `struct port_ops`.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  12 +
 drivers/net/wwan/t7xx/t7xx_port.h          | 151 ++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 546 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  71 +++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   4 +
 6 files changed, 785 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 6a49013bc343..99f9ca3b4b51 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -10,3 +10,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_modem_ops.o \
 		t7xx_cldma.o \
 		t7xx_hif_cldma.o  \
+		t7xx_port_proxy.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index a106dbb526ea..df317714ba06 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -34,6 +34,8 @@
 #include "t7xx_modem_ops.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
@@ -212,6 +214,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
 	if (stage == HIF_EX_CLEARQ_DONE) {
 		/* Give DHL time to flush data */
 		msleep(PORT_RESET_DELAY_MS);
+		t7xx_port_proxy_reset(md->port_prox);
 	}
 
 	t7xx_cldma_exception(md->md_ctrl[ID_CLDMA1], stage);
@@ -369,6 +372,7 @@ void t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
 	spin_lock_init(&md->exp_lock);
 	t7xx_fsm_reset(md);
 	t7xx_cldma_reset(md->md_ctrl[ID_CLDMA1]);
+	t7xx_port_proxy_reset(md->port_prox);
 	md->md_init_finish = true;
 }
 
@@ -404,11 +408,18 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 	if (ret)
 		goto err_uninit_fsm;
 
+	ret = t7xx_port_proxy_init(md);
+	if (ret)
+		goto err_uninit_cldma;
+
 	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
 	t7xx_md_sys_sw_init(t7xx_dev);
 	md->md_init_finish = true;
 	return 0;
 
+err_uninit_cldma:
+	t7xx_cldma_exit(md->md_ctrl[ID_CLDMA1]);
+
 err_uninit_fsm:
 	t7xx_fsm_uninit(md);
 
@@ -428,6 +439,7 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
 		return;
 
 	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
+	t7xx_port_proxy_uninit(md->port_prox);
 	t7xx_cldma_exit(md->md_ctrl[ID_CLDMA1]);
 	t7xx_fsm_uninit(md);
 	destroy_workqueue(md->handshake_wq);
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
new file mode 100644
index 000000000000..eeddbb361f81
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ */
+
+#ifndef __T7XX_PORT_H__
+#define __T7XX_PORT_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_pci.h"
+
+#define PORT_F_RX_ALLOW_DROP	BIT(0)	/* Packet will be dropped if port's RX buffer full */
+#define PORT_F_RX_FULLED	BIT(1)	/* RX buffer has been detected to be full */
+#define PORT_F_USER_HEADER	BIT(2)	/* CCCI header will be provided by user, but not by CCCI */
+#define PORT_F_RX_EXCLUSIVE	BIT(3)	/* RX queue only has this one port */
+#define PORT_F_RX_ADJUST_HEADER	BIT(4)	/* Check whether need remove CCCI header while recv skb */
+#define PORT_F_RX_CH_TRAFFIC	BIT(5)	/* Enable port channel traffic */
+#define PORT_F_RX_CHAR_NODE	BIT(7)	/* Requires exporting char dev node to userspace */
+#define PORT_F_CHAR_NODE_SHOW	BIT(10)	/* The char dev node is shown to userspace by default */
+
+/* Reused for net TX, Data queue, same bit as RX_FULLED */
+#define PORT_F_TX_DATA_FULLED	BIT(1)
+#define PORT_F_TX_ACK_FULLED	BIT(8)
+
+#define PORT_CH_ID_MASK		GENMASK(7, 0)
+#define	PORT_INVALID_CH_ID	GENMASK(15, 0)
+
+/* Channel ID and Message ID definitions.
+ * The channel number consists of peer_id(15:12) , channel_id(11:0)
+ * peer_id:
+ * 0:reserved, 1: to sAP, 2: to MD
+ */
+enum port_ch {
+	/* to MD */
+	PORT_CH_CONTROL_RX = 0x2000,
+	PORT_CH_CONTROL_TX = 0x2001,
+	PORT_CH_UART1_RX = 0x2006,	/* META */
+	PORT_CH_UART1_TX = 0x2008,
+	PORT_CH_UART2_RX = 0x200a,	/* AT */
+	PORT_CH_UART2_TX = 0x200c,
+	PORT_CH_MD_LOG_RX = 0x202a,	/* MD logging */
+	PORT_CH_MD_LOG_TX = 0x202b,
+	PORT_CH_LB_IT_RX = 0x203e,	/* Loop back test */
+	PORT_CH_LB_IT_TX = 0x203f,
+	PORT_CH_STATUS_RX = 0x2043,	/* Status polling */
+	PORT_CH_MIPC_RX = 0x20ce,	/* MIPC */
+	PORT_CH_MIPC_TX = 0x20cf,
+	PORT_CH_MBIM_RX = 0x20d0,
+	PORT_CH_MBIM_TX = 0x20d1,
+	PORT_CH_DSS0_RX = 0x20d2,
+	PORT_CH_DSS0_TX = 0x20d3,
+	PORT_CH_DSS1_RX = 0x20d4,
+	PORT_CH_DSS1_TX = 0x20d5,
+	PORT_CH_DSS2_RX = 0x20d6,
+	PORT_CH_DSS2_TX = 0x20d7,
+	PORT_CH_DSS3_RX = 0x20d8,
+	PORT_CH_DSS3_TX = 0x20d9,
+	PORT_CH_DSS4_RX = 0x20da,
+	PORT_CH_DSS4_TX = 0x20db,
+	PORT_CH_DSS5_RX = 0x20dc,
+	PORT_CH_DSS5_TX = 0x20dd,
+	PORT_CH_DSS6_RX = 0x20de,
+	PORT_CH_DSS6_TX = 0x20df,
+	PORT_CH_DSS7_RX = 0x20e0,
+	PORT_CH_DSS7_TX = 0x20e1,
+};
+
+struct t7xx_port;
+struct port_ops {
+	int (*init)(struct t7xx_port *port);
+	int (*recv_skb)(struct t7xx_port *port, struct sk_buff *skb);
+	void (*md_state_notify)(struct t7xx_port *port, unsigned int md_state);
+	void (*uninit)(struct t7xx_port *port);
+	int (*enable_chl)(struct t7xx_port *port);
+	int (*disable_chl)(struct t7xx_port *port);
+};
+
+typedef void (*port_skb_handler)(struct t7xx_port *port, struct sk_buff *skb);
+
+struct t7xx_port_static {
+	enum port_ch		tx_ch;
+	enum port_ch		rx_ch;
+	unsigned char		txq_index;
+	unsigned char		rxq_index;
+	unsigned char		txq_exp_index;
+	unsigned char		rxq_exp_index;
+	enum cldma_id		path_id;
+	unsigned int		flags;
+	struct port_ops		*ops;
+	char			*name;
+	enum wwan_port_type	port_type;
+};
+
+struct t7xx_port {
+	/* Members not initialized in definition */
+	struct t7xx_port_static *port_static;
+	struct wwan_port	*wwan_port;
+	struct t7xx_pci_dev	*t7xx_dev;
+	struct device		*dev;
+	short			seq_nums[2];
+	atomic_t		usage_cnt;
+	struct			list_head entry;
+	struct			list_head queue_entry;
+	/* TX and RX flows are asymmetric since ports are multiplexed on
+	 * queues.
+	 *
+	 * TX: data blocks are sent directly to a queue. Each port
+	 * does not maintain a TX list; instead, they only provide
+	 * a wait_queue_head for blocking writes.
+	 *
+	 * RX: Each port uses a RX list to hold packets,
+	 * allowing the modem to dispatch RX packet as quickly as possible.
+	 */
+	struct sk_buff_head	rx_skb_list;
+	spinlock_t		port_update_lock; /* Protects port configuration */
+	wait_queue_head_t	rx_wq;
+	int			rx_length_th;
+	port_skb_handler	skb_handler;
+	bool			chan_enable;
+	bool			chn_crt_stat;
+	struct task_struct	*thread;
+	struct mutex		tx_mutex_lock; /* Protects the seq number operation */
+	unsigned int		flags;
+};
+
+int t7xx_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb);
+int t7xx_port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb, bool blocking);
+
+#endif /* __T7XX_PORT_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
new file mode 100644
index 000000000000..af16cb01c607
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -0,0 +1,546 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitfield.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+
+#include "t7xx_common.h"
+#include "t7xx_hif_cldma.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+#define CHECK_RX_SEQ_MASK		GENMASK(14, 0)
+#define Q_IDX_CTRL			0
+#define Q_IDX_MBIM			2
+#define Q_IDX_AT_CMD			5
+
+#define for_each_proxy_port(i, p, proxy)	\
+	for (i = 0, (p) = &(proxy)->ports_private[i];	\
+	     i < (proxy)->port_number;		\
+	     i++, (p) = &(proxy)->ports_private[i])
+
+static struct t7xx_port_static t7xx_md_ports[1];
+
+static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
+{
+	struct t7xx_port_static *port_static;
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		port_static = port->port_static;
+		if (port_static->rx_ch == ch || port_static->tx_ch == ch)
+			return port;
+	}
+
+	return NULL;
+}
+
+/* Sequence numbering to track for lost packets */
+void t7xx_port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
+{
+	if (ccci_h && port) {
+		ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
+		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_SEQ, port->seq_nums[MTK_TX]));
+		ccci_h->status &= cpu_to_le32(~HDR_FLD_AST);
+		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_AST, 1));
+	}
+}
+
+static u16 t7xx_port_check_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
+{
+	u16 seq_num, assert_bit;
+
+	seq_num = FIELD_GET(HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+	assert_bit = FIELD_GET(HDR_FLD_AST, le32_to_cpu(ccci_h->status));
+	if (assert_bit && port->seq_nums[MTK_RX] &&
+	    ((seq_num - port->seq_nums[MTK_RX]) & CHECK_RX_SEQ_MASK) != 1) {
+		dev_warn_ratelimited(port->dev,
+				     "seq num out-of-order %d->%d (header %X, len %X)\n",
+				     seq_num, port->seq_nums[MTK_RX],
+				     le32_to_cpu(ccci_h->packet_header),
+				     le32_to_cpu(ccci_h->packet_len));
+	}
+
+	return seq_num;
+}
+
+void t7xx_port_proxy_reset(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		port->seq_nums[MTK_RX] = -1;
+		port->seq_nums[MTK_TX] = 0;
+	}
+}
+
+static int t7xx_port_get_queue_no(struct t7xx_port *port)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+
+	return t7xx_fsm_get_md_state(ctl) == MD_STATE_EXCEPTION ?
+		port_static->txq_exp_index : port_static->txq_index;
+}
+
+static void t7xx_port_struct_init(struct t7xx_port *port)
+{
+	INIT_LIST_HEAD(&port->entry);
+	INIT_LIST_HEAD(&port->queue_entry);
+	skb_queue_head_init(&port->rx_skb_list);
+	init_waitqueue_head(&port->rx_wq);
+	port->seq_nums[MTK_RX] = -1;
+	port->seq_nums[MTK_TX] = 0;
+	atomic_set(&port->usage_cnt, 0);
+}
+
+static void t7xx_port_adjust_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
+	struct t7xx_port_static *port_static = port->port_static;
+
+	if (port->flags & PORT_F_USER_HEADER) {
+		if (le32_to_cpu(ccci_h->packet_header) == CCCI_HEADER_NO_DATA) {
+			if (skb->len > sizeof(*ccci_h)) {
+				dev_err_ratelimited(port->dev,
+						    "Recv unexpected data for %s, skb->len=%d\n",
+						    port_static->name, skb->len);
+				skb_trim(skb, sizeof(*ccci_h));
+			}
+		}
+	} else {
+		skb_pull(skb, sizeof(*ccci_h));
+	}
+}
+
+/**
+ * t7xx_port_recv_skb() - receive skb from modem or HIF.
+ * @port: port to use.
+ * @skb: skb to use.
+ *
+ * Used to receive native HIF RX data, which has same the RX receive flow.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ENOBUFS	- Not enough queue length.
+ */
+int t7xx_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	if (port->rx_skb_list.qlen < port->rx_length_th) {
+		struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
+		u32 channel;
+
+		port->flags &= ~PORT_F_RX_FULLED;
+		if (port->flags & PORT_F_RX_ADJUST_HEADER)
+			t7xx_port_adjust_skb(port, skb);
+
+		channel = FIELD_GET(HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
+		if (channel == PORT_CH_STATUS_RX) {
+			port->skb_handler(port, skb);
+		} else {
+			if (port->wwan_port)
+				wwan_port_rx(port->wwan_port, skb);
+			else
+				__skb_queue_tail(&port->rx_skb_list, skb);
+		}
+
+		spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+		wake_up_all(&port->rx_wq);
+		return 0;
+	}
+
+	port->flags |= PORT_F_RX_FULLED;
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+	return -ENOBUFS;
+}
+
+static struct cldma_ctrl *get_md_ctrl(struct t7xx_port *port)
+{
+	enum cldma_id id = port->port_static->path_id;
+
+	return port->t7xx_dev->md->md_ctrl[id];
+}
+
+int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct ccci_header *ccci_h = (struct ccci_header *)(skb->data);
+	struct cldma_ctrl *md_ctrl;
+	unsigned char tx_qno;
+	int ret;
+
+	tx_qno = t7xx_port_get_queue_no(port);
+	t7xx_port_proxy_set_seq_num(port, ccci_h);
+
+	md_ctrl = get_md_ctrl(port);
+	ret = t7xx_cldma_send_skb(md_ctrl, tx_qno, skb, true);
+	if (ret) {
+		dev_err(port->dev, "Failed to send skb: %d\n", ret);
+		return ret;
+	}
+
+	/* Record the port seq_num after the data is sent to HIF.
+	 * Only bits 0-14 are used, thus negating overflow.
+	 */
+	port->seq_nums[MTK_TX]++;
+
+	return 0;
+}
+
+int t7xx_port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb, bool blocking)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+	struct cldma_ctrl *md_ctrl;
+	enum md_state md_state;
+	unsigned int fsm_state;
+
+	md_state = t7xx_fsm_get_md_state(ctl);
+
+	fsm_state = t7xx_fsm_get_ctl_state(ctl);
+	if (fsm_state != FSM_STATE_PRE_START) {
+		if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2)
+			return -ENODEV;
+
+		if (md_state == MD_STATE_EXCEPTION && port_static->tx_ch != PORT_CH_MD_LOG_TX &&
+		    port_static->tx_ch != PORT_CH_UART1_TX)
+			return -EBUSY;
+
+		if (md_state == MD_STATE_STOPPED || md_state == MD_STATE_WAITING_TO_STOP ||
+		    md_state == MD_STATE_INVALID)
+			return -ENODEV;
+	}
+
+	md_ctrl = get_md_ctrl(port);
+	return t7xx_cldma_send_skb(md_ctrl, t7xx_port_get_queue_no(port), skb, blocking);
+}
+
+static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(port_prox->rx_ch_ports); i++)
+		INIT_LIST_HEAD(&port_prox->rx_ch_ports[i]);
+
+	for (j = 0; j < ARRAY_SIZE(port_prox->queue_ports); j++) {
+		for (i = 0; i < ARRAY_SIZE(port_prox->queue_ports[j]); i++)
+			INIT_LIST_HEAD(&port_prox->queue_ports[j][i]);
+	}
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_static *port_static = port->port_static;
+		enum cldma_id path_id = port_static->path_id;
+		u8 ch_id;
+
+		ch_id = FIELD_GET(PORT_CH_ID_MASK, port_static->rx_ch);
+		list_add_tail(&port->entry, &port_prox->rx_ch_ports[ch_id]);
+		list_add_tail(&port->queue_entry,
+			      &port_prox->queue_ports[path_id][port_static->rxq_index]);
+	}
+}
+
+/**
+ * t7xx_port_proxy_dispatch_recv_skb() - Dispatch received skb.
+ * @queue: CLDMA queue.
+ * @skb: Socket buffer.
+ * @drop_skb_on_err: Return value that indicates in case of an error that the skb should be dropped.
+ *
+ * If recv_skb return with 0 or drop_skb_on_err is true, then it's the port's duty
+ * to free the request and the caller should no longer reference the request.
+ * If recv_skb returns any other error, caller should free the request.
+ *
+ * Return:
+ ** 0		- Success.
+ ** -EINVAL	- Failed to get skb, channel out-of-range, or invalid MD state.
+ ** -ENETDOWN	- Network time out.
+ */
+static int t7xx_port_proxy_dispatch_recv_skb(struct cldma_queue *queue, struct sk_buff *skb,
+					     bool *drop_skb_on_err)
+{
+	struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
+	struct port_proxy *port_prox = queue->md->port_prox;
+	struct t7xx_fsm_ctl *ctl = queue->md->fsm_ctl;
+	struct list_head *port_list;
+	struct t7xx_port *port;
+	u16 seq_num, channel;
+	int ret = 0;
+	u8 ch_id;
+
+	channel = FIELD_GET(HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
+	ch_id = FIELD_GET(PORT_CH_ID_MASK, channel);
+
+	if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
+		*drop_skb_on_err = true;
+		return -EINVAL;
+	}
+
+	port_list = &port_prox->rx_ch_ports[ch_id];
+	list_for_each_entry(port, port_list, entry) {
+		struct t7xx_port_static *port_static = port->port_static;
+
+		if (queue->md_ctrl->hif_id != port_static->path_id || channel !=
+		    port_static->rx_ch)
+			continue;
+
+		/* Multi-cast is not supported, because one port may be freed and can modify
+		 * this request before another port can process it.
+		 * However we still can use req->state to do some kind of multi-cast if needed.
+		 */
+		if (port_static->ops->recv_skb) {
+			seq_num = t7xx_port_check_rx_seq_num(port, ccci_h);
+			ret = port_static->ops->recv_skb(port, skb);
+			/* If the packet is stored to RX buffer successfully or dropped,
+			 * the sequence number will be updated.
+			 */
+			if (ret == -ENETDOWN || (ret < 0 && port->flags & PORT_F_RX_ALLOW_DROP)) {
+				*drop_skb_on_err = true;
+				dev_err_ratelimited(port->dev,
+						    "port %s RX full, drop packet\n",
+						    port_static->name);
+			}
+
+			if (!ret || drop_skb_on_err)
+				port->seq_nums[MTK_RX] = seq_num;
+		}
+
+		break;
+	}
+
+	return ret;
+}
+
+static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	bool drop_skb_on_err = false;
+	int ret;
+
+	if (!skb)
+		return -EINVAL;
+
+	ret = t7xx_port_proxy_dispatch_recv_skb(queue, skb, &drop_skb_on_err);
+	if (ret < 0 && drop_skb_on_err) {
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
+	return ret;
+}
+
+/**
+ * t7xx_port_proxy_md_status_notify() - Notify all ports of state.
+ *@port_prox: The port_proxy pointer.
+ *@state: State.
+ *
+ * Called by t7xx_fsm. Used to dispatch modem status for all ports,
+ * which want to know MD state transition.
+ */
+void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_static *port_static = port->port_static;
+
+		if (port_static->ops->md_state_notify)
+			port_static->ops->md_state_notify(port, state);
+	}
+}
+
+static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
+{
+	struct port_proxy *port_prox = md->port_prox;
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_static *port_static = port->port_static;
+
+		t7xx_port_struct_init(port);
+
+		port->t7xx_dev = md->t7xx_dev;
+		port->dev = &md->t7xx_dev->pdev->dev;
+		spin_lock_init(&port->port_update_lock);
+		spin_lock(&port->port_update_lock);
+		mutex_init(&port->tx_mutex_lock);
+
+		if (port->flags & PORT_F_CHAR_NODE_SHOW)
+			port->chan_enable = true;
+		else
+			port->chan_enable = false;
+
+		port->chn_crt_stat = false;
+		spin_unlock(&port->port_update_lock);
+
+		if (port_static->ops->init)
+			port_static->ops->init(port);
+	}
+
+	t7xx_proxy_setup_ch_mapping(port_prox);
+}
+
+static int t7xx_proxy_alloc(struct t7xx_modem *md)
+{
+	unsigned int port_number = ARRAY_SIZE(t7xx_md_ports);
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	struct t7xx_port *ports_private;
+	struct port_proxy *port_prox;
+	int i;
+
+	port_prox = devm_kzalloc(dev, sizeof(*port_prox), GFP_KERNEL);
+	if (!port_prox)
+		return -ENOMEM;
+
+	md->port_prox = port_prox;
+	port_prox->dev = dev;
+	port_prox->ports_shared = t7xx_md_ports;
+
+	ports_private = devm_kzalloc(dev, sizeof(*ports_private) * port_number, GFP_KERNEL);
+	if (!ports_private)
+		return -ENOMEM;
+
+	for (i = 0; i < port_number; i++) {
+		ports_private[i].port_static = &port_prox->ports_shared[i];
+		ports_private[i].flags = port_prox->ports_shared[i].flags;
+	}
+
+	port_prox->ports_private = ports_private;
+	port_prox->port_number = port_number;
+	t7xx_proxy_init_all_ports(md);
+	return 0;
+};
+
+/**
+ * t7xx_port_proxy_init() - Initialize ports.
+ * @md: Modem.
+ *
+ * Create all port instances.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ERROR	- Error code from failure sub-initializations.
+ */
+int t7xx_port_proxy_init(struct t7xx_modem *md)
+{
+	int ret;
+
+	ret = t7xx_proxy_alloc(md);
+	if (ret)
+		return ret;
+
+	t7xx_cldma_set_recv_skb(md->md_ctrl[ID_CLDMA1], t7xx_port_proxy_recv_skb);
+	return 0;
+}
+
+void t7xx_port_proxy_uninit(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_static *port_static = port->port_static;
+
+		if (port_static->ops->uninit)
+			port_static->ops->uninit(port);
+	}
+}
+
+/**
+ * t7xx_port_proxy_node_control() - Create/remove node.
+ * @md: Modem.
+ * @port_msg: Message.
+ *
+ * Used to control create/remove device node.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -EFAULT	- Message check failure.
+ */
+int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg)
+{
+	u32 *port_info_base = (void *)port_msg + sizeof(*port_msg);
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	unsigned int ports, i;
+	unsigned int version;
+
+	version = FIELD_GET(PORT_MSG_VERSION, le32_to_cpu(port_msg->info));
+	if (version != PORT_ENUM_VER ||
+	    le32_to_cpu(port_msg->head_pattern) != PORT_ENUM_HEAD_PATTERN ||
+	    le32_to_cpu(port_msg->tail_pattern) != PORT_ENUM_TAIL_PATTERN) {
+		dev_err(dev, "Port message enumeration invalid %x:%x:%x\n",
+			version, le32_to_cpu(port_msg->head_pattern),
+			le32_to_cpu(port_msg->tail_pattern));
+		return -EFAULT;
+	}
+
+	ports = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
+
+	for (i = 0; i < ports; i++) {
+		struct t7xx_port_static *port_static;
+		u32 *port_info = port_info_base + i;
+		struct t7xx_port *port;
+		unsigned int ch_id;
+		bool en_flag;
+
+		ch_id = FIELD_GET(PORT_INFO_CH_ID, *port_info);
+		port = t7xx_proxy_get_port_by_ch(md->port_prox, ch_id);
+		if (!port) {
+			dev_warn(dev, "Port:%x not found\n", ch_id);
+			continue;
+		}
+
+		en_flag = !!FIELD_GET(PORT_INFO_ENFLG, *port_info);
+
+		if (t7xx_fsm_get_md_state(md->fsm_ctl) == MD_STATE_READY) {
+			port_static = port->port_static;
+
+			if (en_flag) {
+				if (port_static->ops->enable_chl)
+					port_static->ops->enable_chl(port);
+			} else {
+				if (port_static->ops->disable_chl)
+					port_static->ops->disable_chl(port);
+			}
+		} else {
+			port->chan_enable = en_flag;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
new file mode 100644
index 000000000000..c0d1b9636c12
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_PORT_PROXY_H__
+#define __T7XX_PORT_PROXY_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+#include "t7xx_common.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_port.h"
+
+#define MTK_QUEUES		16
+#define RX_QUEUE_MAXLEN		32
+#define CTRL_QUEUE_MAXLEN	16
+
+#define CLDMA_TXQ_MTU		MTK_SKB_4K
+
+struct port_proxy {
+	int				port_number;
+	struct t7xx_port_static		*ports_shared;
+	struct t7xx_port		*ports_private;
+	struct list_head		rx_ch_ports[PORT_CH_ID_MASK + 1];
+	struct list_head		queue_ports[CLDMA_NUM][MTK_QUEUES];
+	struct device			*dev;
+};
+
+struct port_msg {
+	__le32	head_pattern;
+	__le32	info;
+	__le32	tail_pattern;
+};
+
+#define PORT_INFO_RSRVD		GENMASK(31, 16)
+#define PORT_INFO_ENFLG		GENMASK(15, 15)
+#define PORT_INFO_CH_ID		GENMASK(14, 0)
+
+#define PORT_MSG_VERSION	GENMASK(31, 16)
+#define PORT_MSG_PRT_CNT	GENMASK(15, 0)
+
+#define PORT_ENUM_VER		0
+#define PORT_ENUM_HEAD_PATTERN	0x5a5a5a5a
+#define PORT_ENUM_TAIL_PATTERN	0xa5a5a5a5
+#define PORT_ENUM_VER_MISMATCH	0x00657272
+
+int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb);
+void t7xx_port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h);
+int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg);
+void t7xx_port_proxy_reset(struct port_proxy *port_prox);
+void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
+int t7xx_port_proxy_init(struct t7xx_modem *md);
+void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state);
+
+#endif /* __T7XX_PORT_PROXY_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index a353eac3e23b..e26a3d6a324f 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -38,6 +38,7 @@
 #include "t7xx_modem_ops.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port_proxy.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
@@ -97,6 +98,9 @@ void t7xx_fsm_broadcast_state(struct t7xx_fsm_ctl *ctl, enum md_state state)
 
 	ctl->md_state = state;
 
+	/* Update to port first, otherwise sending message on HS2 may fail */
+	t7xx_port_proxy_md_status_notify(ctl->md->port_prox, state);
+
 	fsm_state_notify(ctl->md, state);
 }
 
-- 
2.17.1

