Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEA1436C12
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJUUbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:57396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhJUUbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598290"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598290"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:23 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625065"
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
Subject: [PATCH 04/14] net: wwan: t7xx: Add port proxy infrastructure
Date:   Thu, 21 Oct 2021 13:27:28 -0700
Message-Id: <20211021202738.729-5-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port-proxy provides a common interface to interact with different types
of ports. Ports export their configuration via `struct t7xx_port` and
operate as defined by `struct port_ops`.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  14 +-
 drivers/net/wwan/t7xx/t7xx_port.h          | 153 +++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 765 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  86 +++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |  28 +-
 6 files changed, 1044 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index dc0e6e025d55..1f117f36124a 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -11,3 +11,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_skb_util.o \
 		t7xx_cldma.o \
 		t7xx_hif_cldma.o  \
+		t7xx_port_proxy.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index b47ce6e55758..ade5e76396be 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -15,6 +15,8 @@
 #include "t7xx_monitor.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
 
 #define RGU_RESET_DELAY_US	20
 #define PORT_RESET_DELAY_US	2000
@@ -212,12 +214,14 @@ static void md_exception(struct mtk_modem *md, enum hif_ex_stage stage)
 
 	mtk_dev = md->mtk_dev;
 
-	if (stage == HIF_EX_CLEARQ_DONE)
+	if (stage == HIF_EX_CLEARQ_DONE) {
 		/* give DHL time to flush data.
 		 * this is an empirical value that assure
 		 * that DHL have enough time to flush all the date.
 		 */
 		msleep(PORT_RESET_DELAY_US);
+		port_proxy_reset(&mtk_dev->pdev->dev);
+	}
 
 	cldma_exception(ID_CLDMA1, stage);
 
@@ -404,6 +408,7 @@ void mtk_md_reset(struct mtk_pci_dev *mtk_dev)
 	md_structure_reset(md);
 	ccci_fsm_reset();
 	cldma_reset(ID_CLDMA1);
+	port_proxy_reset(&mtk_dev->pdev->dev);
 	md->md_init_finish = true;
 }
 
@@ -442,6 +447,10 @@ int mtk_md_init(struct mtk_pci_dev *mtk_dev)
 	if (ret)
 		goto err_fsm_init;
 
+	ret = port_proxy_init(mtk_dev->md);
+	if (ret)
+		goto err_cldma_init;
+
 	fsm_ctl = fsm_get_entry();
 	fsm_append_command(fsm_ctl, CCCI_COMMAND_START, 0);
 
@@ -450,6 +459,8 @@ int mtk_md_init(struct mtk_pci_dev *mtk_dev)
 	md->md_init_finish = true;
 	return 0;
 
+err_cldma_init:
+	cldma_exit(ID_CLDMA1);
 err_fsm_init:
 	ccci_fsm_uninit();
 err_alloc:
@@ -474,6 +485,7 @@ void mtk_md_exit(struct mtk_pci_dev *mtk_dev)
 	fsm_ctl = fsm_get_entry();
 	/* change FSM state, will auto jump to stopped */
 	fsm_append_command(fsm_ctl, CCCI_COMMAND_PRE_STOP, 1);
+	port_proxy_uninit();
 	cldma_exit(ID_CLDMA1);
 	ccci_fsm_uninit();
 	destroy_workqueue(md->handshake_wq);
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
new file mode 100644
index 000000000000..d516e9059cb2
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_PORT_H__
+#define __T7XX_PORT_H__
+
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+#include <linux/types.h>
+
+#include "t7xx_hif_cldma.h"
+
+#define PORT_F_RX_ALLOW_DROP	BIT(0)	/* packet will be dropped if port's RX buffer full */
+#define PORT_F_RX_FULLED	BIT(1)	/* RX buffer has been full once */
+#define PORT_F_USER_HEADER	BIT(2)	/* CCCI header will be provided by user, but not by CCCI */
+#define PORT_F_RX_EXCLUSIVE	BIT(3)	/* RX queue only has this one port */
+#define PORT_F_RX_ADJUST_HEADER	BIT(4)	/* check whether need remove CCCI header while recv skb */
+#define PORT_F_RX_CH_TRAFFIC	BIT(5)	/* enable port channel traffic */
+#define PORT_F_RX_CHAR_NODE	BIT(7)	/* need export char dev node for userspace */
+#define PORT_F_CHAR_NODE_SHOW	BIT(10)	/* char dev node is shown to userspace at default */
+
+/* reused for net TX, Data queue, same bit as RX_FULLED */
+#define PORT_F_TX_DATA_FULLED	BIT(1)
+#define PORT_F_TX_ACK_FULLED	BIT(8)
+#define PORT_F_RAW_DATA		BIT(9)
+
+#define CCCI_MAX_CH_ID		0xff /* RX channel ID should NOT be >= this!! */
+#define CCCI_CH_ID_MASK		0xff
+
+/* Channel ID and Message ID definitions.
+ * The channel number consists of peer_id(15:12) , channel_id(11:0)
+ * peer_id:
+ * 0:reserved, 1: to sAP, 2: to MD
+ */
+enum ccci_ch {
+	/* to MD */
+	CCCI_CONTROL_RX = 0x2000,
+	CCCI_CONTROL_TX = 0x2001,
+	CCCI_SYSTEM_RX = 0x2002,
+	CCCI_SYSTEM_TX = 0x2003,
+	CCCI_UART1_RX = 0x2006,			/* META */
+	CCCI_UART1_RX_ACK = 0x2007,
+	CCCI_UART1_TX = 0x2008,
+	CCCI_UART1_TX_ACK = 0x2009,
+	CCCI_UART2_RX = 0x200a,			/* AT */
+	CCCI_UART2_RX_ACK = 0x200b,
+	CCCI_UART2_TX = 0x200c,
+	CCCI_UART2_TX_ACK = 0x200d,
+	CCCI_MD_LOG_RX = 0x202a,		/* MD logging */
+	CCCI_MD_LOG_TX = 0x202b,
+	CCCI_LB_IT_RX = 0x203e,			/* loop back test */
+	CCCI_LB_IT_TX = 0x203f,
+	CCCI_STATUS_RX = 0x2043,		/* status polling */
+	CCCI_STATUS_TX = 0x2044,
+	CCCI_MIPC_RX = 0x20ce,			/* MIPC */
+	CCCI_MIPC_TX = 0x20cf,
+	CCCI_MBIM_RX = 0x20d0,
+	CCCI_MBIM_TX = 0x20d1,
+	CCCI_DSS0_RX = 0x20d2,
+	CCCI_DSS0_TX = 0x20d3,
+	CCCI_DSS1_RX = 0x20d4,
+	CCCI_DSS1_TX = 0x20d5,
+	CCCI_DSS2_RX = 0x20d6,
+	CCCI_DSS2_TX = 0x20d7,
+	CCCI_DSS3_RX = 0x20d8,
+	CCCI_DSS3_TX = 0x20d9,
+	CCCI_DSS4_RX = 0x20da,
+	CCCI_DSS4_TX = 0x20db,
+	CCCI_DSS5_RX = 0x20dc,
+	CCCI_DSS5_TX = 0x20dd,
+	CCCI_DSS6_RX = 0x20de,
+	CCCI_DSS6_TX = 0x20df,
+	CCCI_DSS7_RX = 0x20e0,
+	CCCI_DSS7_TX = 0x20e1,
+	CCCI_MAX_CH_NUM,
+	CCCI_MONITOR_CH_ID = GENMASK(31, 28), /* for MD init */
+	CCCI_INVALID_CH_ID = GENMASK(15, 0),
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
+struct t7xx_port {
+	/* members used for initialization, do not change the order */
+	enum ccci_ch		tx_ch;
+	enum ccci_ch		rx_ch;
+	unsigned char		txq_index;
+	unsigned char		rxq_index;
+	unsigned char		txq_exp_index;
+	unsigned char		rxq_exp_index;
+	enum cldma_id		path_id;
+	unsigned int		flags;
+	struct port_ops		*ops;
+	unsigned int		minor;
+	char			*name;
+	enum wwan_port_type	mtk_port_type;
+	struct wwan_port	*mtk_wwan_port;
+	struct mtk_pci_dev	*mtk_dev;
+	struct device		*dev;
+
+	/* un-initialized in definition, always put them at the end */
+	short			seq_nums[2];
+	struct port_proxy	*port_proxy;
+	atomic_t		usage_cnt;
+	struct			list_head entry;
+	struct			list_head queue_entry;
+	unsigned int		major;
+	unsigned int		minor_base;
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
+	bool			skb_from_pool;
+	spinlock_t		port_update_lock; /* protects port configuration */
+	wait_queue_head_t	rx_wq;
+	int			rx_length_th;
+	port_skb_handler	skb_handler;
+	unsigned char		chan_enable;
+	unsigned char		chn_crt_stat;
+	struct cdev		*cdev;
+	struct task_struct	*thread;
+	struct mutex		tx_mutex_lock; /* protects the seq number operation */
+};
+
+int port_kthread_handler(void *arg);
+int port_recv_skb(struct t7xx_port *port, struct sk_buff *skb);
+int port_write_room_to_md(struct t7xx_port *port);
+struct t7xx_port *port_get_by_minor(int minor);
+struct t7xx_port *port_get_by_name(char *port_name);
+int port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb, bool blocking);
+
+#endif /* __T7XX_PORT_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
new file mode 100644
index 000000000000..ae90afc72e40
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -0,0 +1,765 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/netlink.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_skb_util.h"
+
+#define MTK_DEV_NAME				"MTK_WWAN_M80"
+
+#define PORT_NETLINK_MSG_MAX_PAYLOAD		32
+#define PORT_NOTIFY_PROTOCOL			NETLINK_USERSOCK
+#define PORT_STATE_BROADCAST_GROUP		21
+#define CHECK_RX_SEQ_MASK			0x7fff
+#define DATA_AT_CMD_Q				5
+
+/* port->minor is configured in-sequence, but when we use it in code
+ * it should be unique among all ports for addressing.
+ */
+#define TTY_IPC_MINOR_BASE			100
+#define TTY_PORT_MINOR_BASE			250
+#define TTY_PORT_MINOR_INVALID			-1
+
+static struct port_proxy *port_prox;
+
+#define for_each_proxy_port(i, p, proxy)	\
+	for (i = 0, (p) = &(proxy)->ports[i];	\
+	     i < (proxy)->port_number;		\
+	     i++, (p) = &(proxy)->ports[i])
+
+static struct port_ops dummy_port_ops;
+
+static struct t7xx_port md_ccci_ports[] = {
+	{0, 0, 0, 0, 0, 0, ID_CLDMA1, 0, &dummy_port_ops, 0xff, "dummy_port",},
+};
+
+static int port_netlink_send_msg(struct t7xx_port *port, int grp,
+				 const char *buf, size_t len)
+{
+	struct port_proxy *pprox;
+	struct sk_buff *nl_skb;
+	struct nlmsghdr *nlh;
+
+	nl_skb = nlmsg_new(len, GFP_KERNEL);
+	if (!nl_skb)
+		return -ENOMEM;
+
+	nlh = nlmsg_put(nl_skb, 0, 1, NLMSG_DONE, len, 0);
+	if (!nlh) {
+		dev_err(port->dev, "could not release netlink\n");
+		nlmsg_free(nl_skb);
+		return -EFAULT;
+	}
+
+	/* Add new netlink message to the skb
+	 * after checking if header+payload
+	 * can be handled.
+	 */
+	memcpy(nlmsg_data(nlh), buf, len);
+
+	pprox = port->port_proxy;
+	return netlink_broadcast(pprox->netlink_sock, nl_skb,
+				 0, grp, GFP_KERNEL);
+}
+
+static int port_netlink_init(void)
+{
+	port_prox->netlink_sock = netlink_kernel_create(&init_net, PORT_NOTIFY_PROTOCOL, NULL);
+
+	if (!port_prox->netlink_sock) {
+		dev_err(port_prox->dev, "failed to create netlink socket\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void port_netlink_uninit(void)
+{
+	if (port_prox->netlink_sock) {
+		netlink_kernel_release(port_prox->netlink_sock);
+		port_prox->netlink_sock = NULL;
+	}
+}
+
+static struct t7xx_port *proxy_get_port(int minor, enum ccci_ch ch)
+{
+	struct t7xx_port *port;
+	int i;
+
+	if (!port_prox)
+		return NULL;
+
+	for_each_proxy_port(i, port, port_prox) {
+		if (minor >= 0 && port->minor == minor)
+			return port;
+
+		if (ch != CCCI_INVALID_CH_ID && (port->rx_ch == ch || port->tx_ch == ch))
+			return port;
+	}
+
+	return NULL;
+}
+
+struct t7xx_port *port_proxy_get_port(int major, int minor)
+{
+	if (port_prox && port_prox->major == major)
+		return proxy_get_port(minor, CCCI_INVALID_CH_ID);
+
+	return NULL;
+}
+
+static inline struct t7xx_port *port_get_by_ch(enum ccci_ch ch)
+{
+	return proxy_get_port(TTY_PORT_MINOR_INVALID, ch);
+}
+
+/* Sequence numbering to track for lost packets */
+void port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
+{
+	if (ccci_h && port) {
+		ccci_h->status &= ~HDR_FLD_SEQ;
+		ccci_h->status |= FIELD_PREP(HDR_FLD_SEQ, port->seq_nums[MTK_OUT]);
+		ccci_h->status &= ~HDR_FLD_AST;
+		ccci_h->status |= FIELD_PREP(HDR_FLD_AST, 1);
+	}
+}
+
+static u16 port_check_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
+{
+	u16 channel, seq_num, assert_bit;
+
+	channel = FIELD_GET(HDR_FLD_CHN, ccci_h->status);
+	seq_num = FIELD_GET(HDR_FLD_SEQ, ccci_h->status);
+	assert_bit = FIELD_GET(HDR_FLD_AST, ccci_h->status);
+	if (assert_bit && port->seq_nums[MTK_IN] &&
+	    ((seq_num - port->seq_nums[MTK_IN]) & CHECK_RX_SEQ_MASK) != 1) {
+		dev_err(port->dev, "channel %d seq number out-of-order %d->%d (data: %X, %X)\n",
+			channel, seq_num, port->seq_nums[MTK_IN],
+			ccci_h->data[0], ccci_h->data[1]);
+	}
+
+	return seq_num;
+}
+
+void port_proxy_reset(struct device *dev)
+{
+	struct t7xx_port *port;
+	int i;
+
+	if (!port_prox) {
+		dev_err(dev, "invalid port proxy\n");
+		return;
+	}
+
+	for_each_proxy_port(i, port, port_prox) {
+		port->seq_nums[MTK_IN] = -1;
+		port->seq_nums[MTK_OUT] = 0;
+	}
+}
+
+static inline int port_get_queue_no(struct t7xx_port *port)
+{
+	return ccci_fsm_get_md_state() == MD_STATE_EXCEPTION ?
+		port->txq_exp_index : port->txq_index;
+}
+
+static inline void port_struct_init(struct t7xx_port *port)
+{
+	INIT_LIST_HEAD(&port->entry);
+	INIT_LIST_HEAD(&port->queue_entry);
+	skb_queue_head_init(&port->rx_skb_list);
+	init_waitqueue_head(&port->rx_wq);
+	port->seq_nums[MTK_IN] = -1;
+	port->seq_nums[MTK_OUT] = 0;
+	atomic_set(&port->usage_cnt, 0);
+	port->port_proxy = port_prox;
+}
+
+static void port_adjust_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct ccci_header *ccci_h;
+
+	ccci_h = (struct ccci_header *)skb->data;
+	if (port->flags & PORT_F_USER_HEADER) { /* header provide by user */
+		/* CCCI_MON_CH should fall in here, as header must be
+		 * send to md_init.
+		 */
+		if (ccci_h->data[0] == CCCI_HEADER_NO_DATA) {
+			if (skb->len > sizeof(struct ccci_header)) {
+				dev_err_ratelimited(port->dev,
+						    "recv unexpected data for %s, skb->len=%d\n",
+						    port->name, skb->len);
+				skb_trim(skb, sizeof(struct ccci_header));
+			}
+		}
+	} else {
+		/* remove CCCI header */
+		skb_pull(skb, sizeof(struct ccci_header));
+	}
+}
+
+/**
+ * port_recv_skb() - receive skb from modem or HIF
+ * @port: port to use
+ * @skb: skb to use
+ *
+ * Used to receive native HIF RX data,
+ * which have same RX receive flow.
+ *
+ * Return: 0 for success or error code
+ */
+int port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	if (port->rx_skb_list.qlen < port->rx_length_th) {
+		struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
+
+		port->flags &= ~PORT_F_RX_FULLED;
+		if (port->flags & PORT_F_RX_ADJUST_HEADER)
+			port_adjust_skb(port, skb);
+
+		if (!(port->flags & PORT_F_RAW_DATA) &&
+		    FIELD_GET(HDR_FLD_CHN, ccci_h->status) == CCCI_STATUS_RX) {
+			port->skb_handler(port, skb);
+		} else {
+			if (port->mtk_wwan_port)
+				wwan_port_rx(port->mtk_wwan_port, skb);
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
+	if (port->flags & PORT_F_RX_ALLOW_DROP) {
+		dev_err(port->dev, "port %s RX full, drop packet\n", port->name);
+		return -ENETDOWN;
+	}
+
+	return -ENOBUFS;
+}
+
+/**
+ * port_kthread_handler() - kthread handler for specific port
+ * @arg: port pointer
+ *
+ * Receive native HIF RX data,
+ * which have same RX receive flow.
+ *
+ * Return: Always 0 to kthread_run
+ */
+int port_kthread_handler(void *arg)
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
+
+		if (port->skb_handler)
+			port->skb_handler(port, skb);
+	}
+
+	return 0;
+}
+
+int port_write_room_to_md(struct t7xx_port *port)
+{
+	return cldma_write_room(port->path_id, port_get_queue_no(port));
+}
+
+int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool)
+{
+	struct ccci_header *ccci_h;
+	unsigned char tx_qno;
+	int ret;
+
+	ccci_h = (struct ccci_header *)(skb->data);
+	tx_qno = port_get_queue_no(port);
+	port_proxy_set_seq_num(port, (struct ccci_header *)ccci_h);
+	ret = cldma_send_skb(port->path_id, tx_qno, skb, from_pool, true);
+	if (ret) {
+		dev_err(port->dev, "failed to send skb, error: %d\n", ret);
+	} else {
+		/* Record the port seq_num after the data is sent to HIF.
+		 * Only bits 0-14 are used, thus negating overflow.
+		 */
+		port->seq_nums[MTK_OUT]++;
+	}
+
+	return ret;
+}
+
+int port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb, bool blocking)
+{
+	enum md_state md_state;
+	unsigned int fsm_state;
+
+	md_state = ccci_fsm_get_md_state();
+	fsm_state = ccci_fsm_get_current_state();
+	if (fsm_state != CCCI_FSM_PRE_START) {
+		if (md_state == MD_STATE_WAITING_FOR_HS1 ||
+		    md_state == MD_STATE_WAITING_FOR_HS2) {
+			return -ENODEV;
+		}
+
+		if (md_state == MD_STATE_EXCEPTION &&
+		    port->tx_ch != CCCI_MD_LOG_TX &&
+		    port->tx_ch != CCCI_UART1_TX) {
+			return -ETXTBSY;
+		}
+
+		if (md_state == MD_STATE_STOPPED ||
+		    md_state == MD_STATE_WAITING_TO_STOP ||
+		    md_state == MD_STATE_INVALID) {
+			return -ENODEV;
+		}
+	}
+
+	return cldma_send_skb(port->path_id, port_get_queue_no(port),
+				   skb, port->skb_from_pool, blocking);
+}
+
+static void proxy_setup_channel_mapping(void)
+{
+	struct t7xx_port *port;
+	int i, j;
+
+	/* init RX_CH=>port list mapping */
+	for (i = 0; i < ARRAY_SIZE(port_prox->rx_ch_ports); i++)
+		INIT_LIST_HEAD(&port_prox->rx_ch_ports[i]);
+	/* init queue_id=>port list mapping per HIF */
+	for (j = 0; j < ARRAY_SIZE(port_prox->queue_ports); j++) {
+		for (i = 0; i < ARRAY_SIZE(port_prox->queue_ports[j]); i++)
+			INIT_LIST_HEAD(&port_prox->queue_ports[j][i]);
+	}
+
+	/* setup port mapping */
+	for_each_proxy_port(i, port, port_prox) {
+		/* setup RX_CH=>port list mapping */
+		list_add_tail(&port->entry,
+			      &port_prox->rx_ch_ports[port->rx_ch & CCCI_CH_ID_MASK]);
+		/* setup QUEUE_ID=>port list mapping */
+		list_add_tail(&port->queue_entry,
+			      &port_prox->queue_ports[port->path_id][port->rxq_index]);
+	}
+}
+
+/* inject CCCI message to modem */
+void port_proxy_send_msg_to_md(int ch, unsigned int msg, unsigned int resv)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct ccci_header *ccci_h;
+	struct t7xx_port *port;
+	struct sk_buff *skb;
+	int ret;
+
+	port = port_get_by_ch(ch);
+	if (!port)
+		return;
+
+	skb = ccci_alloc_skb_from_pool(&port->mtk_dev->pools, sizeof(struct ccci_header),
+				       GFS_BLOCKING);
+	if (!skb)
+		return;
+
+	if (ch == CCCI_CONTROL_TX) {
+		ccci_h = (struct ccci_header *)(skb->data);
+		ccci_h->data[0] = CCCI_HEADER_NO_DATA;
+		ccci_h->data[1] = sizeof(struct ctrl_msg_header) + CCCI_H_LEN;
+		ccci_h->status &= ~HDR_FLD_CHN;
+		ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, ch);
+		ccci_h->reserved = 0;
+		ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + CCCI_H_LEN);
+		ctrl_msg_h->data_length = 0;
+		ctrl_msg_h->reserved = resv;
+		ctrl_msg_h->ctrl_msg_id = msg;
+		skb_put(skb, CCCI_H_LEN + sizeof(struct ctrl_msg_header));
+	} else {
+		ccci_h = skb_put(skb, sizeof(struct ccci_header));
+		ccci_h->data[0] = CCCI_HEADER_NO_DATA;
+		ccci_h->data[1] = msg;
+		ccci_h->status &= ~HDR_FLD_CHN;
+		ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, ch);
+		ccci_h->reserved = resv;
+	}
+
+	ret = port_proxy_send_skb(port, skb, port->skb_from_pool);
+	if (ret) {
+		dev_err(port->dev, "port%s send to MD fail\n", port->name);
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+	}
+}
+
+/**
+ * port_proxy_recv_skb_from_q() - receive raw data from dedicated queue
+ * @queue: CLDMA queue
+ * @skb: socket buffer
+ *
+ * Return: 0 for success or error code for drops
+ */
+static int port_proxy_recv_skb_from_q(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	struct t7xx_port *port;
+	int ret = 0;
+
+	port = port_prox->dedicated_ports[queue->hif_id][queue->index];
+
+	if (skb && port->ops->recv_skb)
+		ret = port->ops->recv_skb(port, skb);
+
+	if (ret < 0 && ret != -ENOBUFS) {
+		dev_err(port->dev, "drop on RX ch %d, ret %d\n", port->rx_ch, ret);
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+		return -ENETDOWN;
+	}
+
+	return ret;
+}
+
+/**
+ * port_proxy_dispatch_recv_skb() - dispatch received skb
+ * @queue: CLDMA queue
+ * @skb: socket buffer
+ *
+ * If recv_request returns 0 or -ENETDOWN, then it's the port's duty
+ * to free the request and the caller should no longer reference the request.
+ * If recv_request returns any other error, caller should free the request.
+ *
+ * Return: 0 or greater for success, or negative error code
+ */
+static int port_proxy_dispatch_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	struct list_head *port_list;
+	struct ccci_header *ccci_h;
+	struct t7xx_port *port;
+	u16 seq_num, channel;
+	int ret = -ENETDOWN;
+
+	if (!skb)
+		return -EINVAL;
+
+	ccci_h = (struct ccci_header *)skb->data;
+	channel = FIELD_GET(HDR_FLD_CHN, ccci_h->status);
+
+	if (channel >= CCCI_MAX_CH_NUM ||
+	    ccci_fsm_get_md_state() == MD_STATE_INVALID)
+		goto err_exit;
+
+	port_list = &port_prox->rx_ch_ports[channel & CCCI_CH_ID_MASK];
+	list_for_each_entry(port, port_list, entry) {
+		if (queue->hif_id != port->path_id || channel != port->rx_ch)
+			continue;
+
+		/* Multi-cast is not supported, because one port may be freed
+		 * and can modify this request before another port can process it.
+		 * However we still can use req->state to achieve some kind of
+		 * multi-cast if needed.
+		 */
+		if (port->ops->recv_skb) {
+			seq_num = port_check_rx_seq_num(port, ccci_h);
+			ret = port->ops->recv_skb(port, skb);
+			/* If the packet is stored to RX buffer
+			 * successfully or drop, the sequence
+			 * num will be updated.
+			 */
+			if (ret == -ENOBUFS)
+				return ret;
+
+			port->seq_nums[MTK_IN] = seq_num;
+		}
+
+		break;
+	}
+
+err_exit:
+	if (ret < 0) {
+		struct skb_pools *pools;
+
+		pools = &queue->md->mtk_dev->pools;
+		ccci_free_skb(pools, skb);
+		return -ENETDOWN;
+	}
+
+	return 0;
+}
+
+static int port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	if (queue->q_type == CLDMA_SHARED_Q)
+		return port_proxy_dispatch_recv_skb(queue, skb);
+
+	return port_proxy_recv_skb_from_q(queue, skb);
+}
+
+/**
+ * port_proxy_md_status_notify() - notify all ports of state
+ * @state: state
+ *
+ * Called by ccci_fsm,
+ * Used to dispatch modem status for all ports,
+ * which want to know MD state transition.
+ */
+void port_proxy_md_status_notify(unsigned int state)
+{
+	struct t7xx_port *port;
+	int i;
+
+	if (!port_prox)
+		return;
+
+	for_each_proxy_port(i, port, port_prox)
+		if (port->ops->md_state_notify)
+			port->ops->md_state_notify(port, state);
+}
+
+static int proxy_register_char_dev(void)
+{
+	dev_t dev = 0;
+	int ret;
+
+	if (port_prox->major) {
+		dev = MKDEV(port_prox->major, port_prox->minor_base);
+		ret = register_chrdev_region(dev, TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
+	} else {
+		ret = alloc_chrdev_region(&dev, port_prox->minor_base,
+					  TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
+		if (ret)
+			dev_err(port_prox->dev, "failed to alloc chrdev region, ret=%d\n", ret);
+
+		port_prox->major = MAJOR(dev);
+	}
+
+	return ret;
+}
+
+static void proxy_init_all_ports(struct mtk_modem *md)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		port_struct_init(port);
+
+		port->major = port_prox->major;
+		port->minor_base = port_prox->minor_base;
+		port->mtk_dev = md->mtk_dev;
+		port->dev = &md->mtk_dev->pdev->dev;
+		spin_lock_init(&port->port_update_lock);
+		spin_lock(&port->port_update_lock);
+		mutex_init(&port->tx_mutex_lock);
+		if (port->flags & PORT_F_CHAR_NODE_SHOW)
+			port->chan_enable = CCCI_CHAN_ENABLE;
+		else
+			port->chan_enable = CCCI_CHAN_DISABLE;
+
+		port->chn_crt_stat = CCCI_CHAN_DISABLE;
+		spin_unlock(&port->port_update_lock);
+		if (port->ops->init)
+			port->ops->init(port);
+
+		if (port->flags & PORT_F_RAW_DATA)
+			port_prox->dedicated_ports[port->path_id][port->rxq_index] = port;
+	}
+
+	proxy_setup_channel_mapping();
+}
+
+static int proxy_alloc(struct mtk_modem *md)
+{
+	int ret;
+
+	port_prox = devm_kzalloc(&md->mtk_dev->pdev->dev, sizeof(*port_prox), GFP_KERNEL);
+	if (!port_prox)
+		return -ENOMEM;
+
+	ret = proxy_register_char_dev();
+	if (ret)
+		return ret;
+
+	port_prox->dev = &md->mtk_dev->pdev->dev;
+	port_prox->ports = md_ccci_ports;
+	port_prox->port_number = ARRAY_SIZE(md_ccci_ports);
+	proxy_init_all_ports(md);
+
+	return 0;
+};
+
+struct t7xx_port *port_get_by_minor(int minor)
+{
+	return proxy_get_port(minor, CCCI_INVALID_CH_ID);
+}
+
+struct t7xx_port *port_get_by_name(char *port_name)
+{
+	struct t7xx_port *port;
+	int i;
+
+	if (!port_prox)
+		return NULL;
+
+	for_each_proxy_port(i, port, port_prox)
+		if (!strncmp(port->name, port_name, strlen(port->name)))
+			return port;
+
+	return NULL;
+}
+
+int port_proxy_broadcast_state(struct t7xx_port *port, int state)
+{
+	char msg[PORT_NETLINK_MSG_MAX_PAYLOAD];
+
+	if (state >= MTK_PORT_STATE_INVALID)
+		return -EINVAL;
+
+	switch (state) {
+	case MTK_PORT_STATE_ENABLE:
+		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "enable %s", port->name);
+		break;
+
+	case MTK_PORT_STATE_DISABLE:
+		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "disable %s", port->name);
+		break;
+
+	default:
+		snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "invalid operation");
+		break;
+	}
+
+	return port_netlink_send_msg(port, PORT_STATE_BROADCAST_GROUP, msg, strlen(msg) + 1);
+}
+
+/**
+ * port_proxy_init() - init ports
+ * @md: modem
+ *
+ * Called by CCCI modem,
+ * used to create all CCCI port instances.
+ *
+ * Return: 0 for success or error
+ */
+int port_proxy_init(struct mtk_modem *md)
+{
+	int ret;
+
+	ret = proxy_alloc(md);
+	if (ret)
+		return ret;
+
+	ret = port_netlink_init();
+	if (ret)
+		goto err_netlink;
+
+	cldma_set_recv_skb(ID_CLDMA1, port_proxy_recv_skb);
+
+	return 0;
+
+err_netlink:
+	port_proxy_uninit();
+
+	return ret;
+}
+
+void port_proxy_uninit(void)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox)
+		if (port->ops->uninit)
+			port->ops->uninit(port);
+
+	unregister_chrdev_region(MKDEV(port_prox->major, port_prox->minor_base),
+				 TTY_IPC_MINOR_BASE);
+	port_netlink_uninit();
+}
+
+/**
+ * port_proxy_node_control() - create/remove node
+ * @dev: device
+ * @port_msg: message
+ *
+ * Used to control create/remove device node.
+ *
+ * Return: 0 for success or error
+ */
+int port_proxy_node_control(struct device *dev, struct port_msg *port_msg)
+{
+	struct t7xx_port *port;
+	unsigned int ports, i;
+	unsigned int version;
+
+	version = FIELD_GET(PORT_MSG_VERSION, port_msg->info);
+	if (version != PORT_ENUM_VER ||
+	    port_msg->head_pattern != PORT_ENUM_HEAD_PATTERN ||
+	    port_msg->tail_pattern != PORT_ENUM_TAIL_PATTERN) {
+		dev_err(dev, "port message enumeration invalid %x:%x:%x\n",
+			version, port_msg->head_pattern, port_msg->tail_pattern);
+		return -EFAULT;
+	}
+
+	ports = FIELD_GET(PORT_MSG_PRT_CNT, port_msg->info);
+
+	for (i = 0; i < ports; i++) {
+		u32 *port_info = (u32 *)(port_msg->data + sizeof(*port_info) * i);
+		unsigned int en_flag = FIELD_GET(PORT_INFO_ENFLG, *port_info);
+		unsigned int ch_id = FIELD_GET(PORT_INFO_CH_ID, *port_info);
+
+		port = port_get_by_ch(ch_id);
+
+		if (!port) {
+			dev_warn(dev, "Port:%x not found\n", ch_id);
+			continue;
+		}
+
+		if (ccci_fsm_get_md_state() == MD_STATE_READY) {
+			if (en_flag == CCCI_CHAN_ENABLE) {
+				if (port->ops->enable_chl)
+					port->ops->enable_chl(port);
+			} else {
+				if (port->ops->disable_chl)
+					port->ops->disable_chl(port);
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
index 000000000000..f8d4ec27ec38
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_PORT_PROXY_H__
+#define __T7XX_PORT_PROXY_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <net/sock.h>
+
+#include "t7xx_common.h"
+#include "t7xx_hif_cldma.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_port.h"
+
+/* CCCI logic channel enable & disable flag */
+#define CCCI_CHAN_ENABLE	1
+#define CCCI_CHAN_DISABLE	0
+
+#define MTK_MAX_QUEUE_NUM	16
+#define MTK_PORT_STATE_ENABLE	0
+#define MTK_PORT_STATE_DISABLE	1
+#define MTK_PORT_STATE_INVALID	2
+
+#define MAX_RX_QUEUE_LENGTH	32
+#define MAX_CTRL_QUEUE_LENGTH	16
+
+#define CCCI_MTU		3568 /* 3.5kB -16 */
+#define CLDMA_TXQ_MTU		MTK_SKB_4K
+
+struct port_proxy {
+	int			port_number;
+	unsigned int		major;
+	unsigned int		minor_base;
+	struct t7xx_port	*ports;
+	struct t7xx_port	*dedicated_ports[CLDMA_NUM][MTK_MAX_QUEUE_NUM];
+	/* port list of each RX channel, for RX dispatching */
+	struct list_head	rx_ch_ports[CCCI_MAX_CH_ID];
+	/* port list of each queue for receiving queue status dispatching */
+	struct list_head	queue_ports[CLDMA_NUM][MTK_MAX_QUEUE_NUM];
+	struct sock		*netlink_sock;
+	struct device		*dev;
+};
+
+struct ctrl_msg_header {
+	u32			ctrl_msg_id;
+	u32			reserved;
+	u32			data_length;
+	u8			data[0];
+};
+
+struct port_msg {
+	u32			head_pattern;
+	u32			info;
+	u32			tail_pattern;
+	u8			data[0]; /* port set info */
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
+int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool);
+void port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h);
+int port_proxy_node_control(struct device *dev, struct port_msg *port_msg);
+void port_proxy_reset(struct device *dev);
+int port_proxy_broadcast_state(struct t7xx_port *port, int state);
+void port_proxy_send_msg_to_md(int ch, unsigned int msg, unsigned int resv);
+void port_proxy_uninit(void);
+int port_proxy_init(struct mtk_modem *md);
+void port_proxy_md_status_notify(unsigned int state);
+struct t7xx_port *port_proxy_get_port(int major, int minor);
+
+#endif /* __T7XX_PORT_PROXY_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index e4d7fd9fa8b1..5eeba515b057 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -17,6 +17,8 @@
 #include "t7xx_monitor.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
 
 #define FSM_DRM_DISABLE_DELAY_MS 200
 #define FSM_EX_REASON GENMASK(23, 16)
@@ -77,6 +79,9 @@ void fsm_broadcast_state(struct ccci_fsm_ctl *ctl, enum md_state state)
 
 	ctl->md_state = state;
 
+	/* update to port first, otherwise sending message on HS2 may fail */
+	port_proxy_md_status_notify(state);
+
 	fsm_state_notify(state);
 }
 
@@ -134,7 +139,8 @@ static void fsm_flush_queue(struct ccci_fsm_ctl *ctl)
 static void fsm_routine_exception(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd,
 				  enum ccci_ex_reason reason)
 {
-	bool rec_ok = false;
+	struct t7xx_port *log_port, *meta_port;
+	bool rec_ok = false, pass = false;
 	struct ccci_fsm_event *event;
 	unsigned long flags;
 	struct device *dev;
@@ -195,11 +201,29 @@ static void fsm_routine_exception(struct ccci_fsm_ctl *ctl, struct ccci_fsm_comm
 			if (!list_empty(&ctl->event_queue)) {
 				event = list_first_entry(&ctl->event_queue,
 							 struct ccci_fsm_event, entry);
-				if (event->event_id == CCCI_EVENT_MD_EX_PASS)
+				if (event->event_id == CCCI_EVENT_MD_EX_PASS) {
+					pass = true;
 					fsm_finish_event(ctl, event);
+				}
 			}
 
 			spin_unlock_irqrestore(&ctl->event_lock, flags);
+			if (pass) {
+				log_port = port_get_by_name("ttyCMdLog");
+				if (log_port)
+					log_port->ops->enable_chl(log_port);
+				else
+					dev_err(dev, "ttyCMdLog port not found\n");
+
+				meta_port = port_get_by_name("ttyCMdMeta");
+				if (meta_port)
+					meta_port->ops->enable_chl(meta_port);
+				else
+					dev_err(dev, "ttyCMdMeta port not found\n");
+
+				break;
+			}
+
 			cnt++;
 			msleep(EVENT_POLL_INTERVAL_MS);
 		}
-- 
2.17.1

