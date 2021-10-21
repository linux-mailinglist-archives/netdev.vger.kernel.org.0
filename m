Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DD5436C22
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhJUUcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:32:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:46172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhJUUcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="315343875"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="315343875"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:25 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625116"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:24 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 13/14] net: wwan: t7xx: Add debug and test ports
Date:   Thu, 21 Oct 2021 13:27:37 -0700
Message-Id: <20211021202738.729-14-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creates char and tty port infrastructure for debug and testing.
Those ports support use cases such as:
* Modem log collection
* Memory dump
* Loop-back test
* Factory tests
* Device Service Streams

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile          |   3 +
 drivers/net/wwan/t7xx/t7xx_port.h       |   2 +
 drivers/net/wwan/t7xx/t7xx_port_char.c  | 416 ++++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  49 ++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   3 +
 drivers/net/wwan/t7xx/t7xx_port_tty.c   | 185 +++++++++++
 drivers/net/wwan/t7xx/t7xx_tty_ops.c    | 200 ++++++++++++
 drivers/net/wwan/t7xx/t7xx_tty_ops.h    |  39 +++
 8 files changed, 896 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_char.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_tty.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index fcee61e7c4bc..ba5c602a734b 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -19,3 +19,6 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_dpmaif_tx.o \
 		t7xx_hif_dpmaif_rx.o  \
 		t7xx_netdev.o \
+		t7xx_port_char.o  \
+		t7xx_port_tty.o \
+		t7xx_tty_ops.o
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index d516e9059cb2..315691fa0605 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -149,5 +149,7 @@ int port_write_room_to_md(struct t7xx_port *port);
 struct t7xx_port *port_get_by_minor(int minor);
 struct t7xx_port *port_get_by_name(char *port_name);
 int port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb, bool blocking);
+int port_register_device(const char *name, int major, int minor);
+void port_unregister_device(int major, int minor);
 
 #endif /* __T7XX_PORT_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_char.c b/drivers/net/wwan/t7xx/t7xx_port_char.c
new file mode 100644
index 000000000000..923161acb0c1
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_char.c
@@ -0,0 +1,416 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/cdev.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_common.h"
+#include "t7xx_monitor.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_skb_util.h"
+
+static __poll_t port_char_poll(struct file *fp, struct poll_table_struct *poll)
+{
+	struct t7xx_port *port;
+	enum md_state md_state;
+	__poll_t mask = 0;
+
+	port = fp->private_data;
+	md_state = ccci_fsm_get_md_state();
+	poll_wait(fp, &port->rx_wq, poll);
+
+	spin_lock_irq(&port->rx_wq.lock);
+	if (!skb_queue_empty(&port->rx_skb_list))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	spin_unlock_irq(&port->rx_wq.lock);
+	if (port_write_room_to_md(port) > 0)
+		mask |= EPOLLOUT | EPOLLWRNORM;
+
+	if (port->rx_ch == CCCI_UART1_RX &&
+	    md_state != MD_STATE_READY &&
+	    md_state != MD_STATE_EXCEPTION) {
+		/* notify MD logger to save its log before md_init kills it */
+		mask |= EPOLLERR;
+		dev_err(port->dev, "poll error for MD logger at state: %d, mask: %u\n",
+			md_state, mask);
+	}
+
+	return mask;
+}
+
+/**
+ * port_char_open() - open char port
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * Open a char port using pre-defined md_ccci_ports structure in port_proxy
+ *
+ * Return: 0 for success, -EINVAL for failure
+ */
+static int port_char_open(struct inode *inode, struct file *file)
+{
+	int major = imajor(inode);
+	int minor = iminor(inode);
+	struct t7xx_port *port;
+
+	port = port_proxy_get_port(major, minor);
+	if (!port)
+		return -EINVAL;
+
+	atomic_inc(&port->usage_cnt);
+	file->private_data = port;
+	return nonseekable_open(inode, file);
+}
+
+static int port_char_close(struct inode *inode, struct file *file)
+{
+	struct t7xx_port *port;
+	struct sk_buff *skb;
+	int clear_cnt = 0;
+
+	port = file->private_data;
+	/* decrease usage count, so when we ask again,
+	 * the packet can be dropped in recv_request.
+	 */
+	atomic_dec(&port->usage_cnt);
+
+	/* purge RX request list */
+	spin_lock_irq(&port->rx_wq.lock);
+	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL) {
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+		clear_cnt++;
+	}
+
+	spin_unlock_irq(&port->rx_wq.lock);
+	return 0;
+}
+
+static ssize_t port_char_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	bool full_req_done = false;
+	struct t7xx_port *port;
+	int ret = 0, read_len;
+	struct sk_buff *skb;
+
+	port = file->private_data;
+	spin_lock_irq(&port->rx_wq.lock);
+	if (skb_queue_empty(&port->rx_skb_list)) {
+		if (file->f_flags & O_NONBLOCK) {
+			spin_unlock_irq(&port->rx_wq.lock);
+			return -EAGAIN;
+		}
+
+		ret = wait_event_interruptible_locked_irq(port->rx_wq,
+							  !skb_queue_empty(&port->rx_skb_list));
+		if (ret == -ERESTARTSYS) {
+			spin_unlock_irq(&port->rx_wq.lock);
+			return -EINTR;
+		}
+	}
+
+	skb = skb_peek(&port->rx_skb_list);
+
+	if (count >= skb->len) {
+		read_len = skb->len;
+		full_req_done = true;
+		__skb_unlink(skb, &port->rx_skb_list);
+	} else {
+		read_len = count;
+	}
+
+	spin_unlock_irq(&port->rx_wq.lock);
+	if (copy_to_user(buf, skb->data, read_len)) {
+		dev_err(port->dev, "read on %s, copy to user failed, %d/%zu\n",
+			port->name, read_len, count);
+		ret = -EFAULT;
+	}
+
+	skb_pull(skb, read_len);
+	if (full_req_done)
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+
+	return ret ? ret : read_len;
+}
+
+static ssize_t port_char_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	size_t actual_count, alloc_size, txq_mtu;
+	int i, multi_packet = 1;
+	struct t7xx_port *port;
+	enum md_state md_state;
+	struct sk_buff *skb;
+	bool blocking;
+	int ret;
+
+	blocking = !(file->f_flags & O_NONBLOCK);
+	port = file->private_data;
+	md_state = ccci_fsm_get_md_state();
+	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
+		dev_warn(port->dev, "port: %s ch: %d, write fail when md_state: %d\n",
+			 port->name, port->tx_ch, md_state);
+		return -ENODEV;
+	}
+
+	if (port_write_room_to_md(port) <= 0 && !blocking)
+		return -EAGAIN;
+
+	txq_mtu = CLDMA_TXQ_MTU;
+	if (port->flags & PORT_F_RAW_DATA || port->flags & PORT_F_USER_HEADER) {
+		if (port->flags & PORT_F_USER_HEADER && count > txq_mtu) {
+			dev_err(port->dev, "packet size: %zu larger than MTU on %s\n",
+				count, port->name);
+			return -ENOMEM;
+		}
+
+		actual_count = count > txq_mtu ? txq_mtu : count;
+		alloc_size = actual_count;
+	} else {
+		actual_count = (count + CCCI_H_ELEN) > txq_mtu ? (txq_mtu - CCCI_H_ELEN) : count;
+		alloc_size = actual_count + CCCI_H_ELEN;
+		if (count + CCCI_H_ELEN > txq_mtu && (port->tx_ch == CCCI_MBIM_TX ||
+						      (port->tx_ch >= CCCI_DSS0_TX &&
+						       port->tx_ch <= CCCI_DSS7_TX))) {
+			multi_packet = (count + txq_mtu - CCCI_H_ELEN - 1) /
+					(txq_mtu - CCCI_H_ELEN);
+		}
+	}
+	mutex_lock(&port->tx_mutex_lock);
+	for (i = 0; i < multi_packet; i++) {
+		struct ccci_header *ccci_h = NULL;
+
+		if (multi_packet > 1 && multi_packet == i + 1) {
+			actual_count = count % (txq_mtu - CCCI_H_ELEN);
+			alloc_size = actual_count + CCCI_H_ELEN;
+		}
+
+		skb = ccci_alloc_skb_from_pool(&port->mtk_dev->pools, alloc_size, blocking);
+		if (!skb) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
+
+		/* Get the user data, no need to validate the data since the driver is just
+		 * passing it to the device.
+		 */
+		if (port->flags & PORT_F_RAW_DATA) {
+			ret = copy_from_user(skb_put(skb, actual_count), buf, actual_count);
+			if (port->flags & PORT_F_USER_HEADER) {
+				/* The ccci_header is provided by user.
+				 *
+				 * For only sending ccci_header without additional data
+				 * case, data[0]=CCCI_HEADER_NO_DATA, data[1]=user_data,
+				 * ch=tx_channel, reserved=no_use.
+				 *
+				 * For send ccci_header with additional data case,
+				 * data[0]=0, data[1]=data_size, ch=tx_channel,
+				 * reserved=user_data.
+				 */
+				ccci_h = (struct ccci_header *)skb->data;
+				if (actual_count == CCCI_H_LEN)
+					ccci_h->data[0] = CCCI_HEADER_NO_DATA;
+				else
+					ccci_h->data[1] = actual_count;
+
+				ccci_h->status &= ~HDR_FLD_CHN;
+				ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, port->tx_ch);
+			}
+		} else {
+			/* ccci_header is provided by driver */
+			ccci_h = skb_put(skb, CCCI_H_LEN);
+			ccci_h->data[0] = 0;
+			ccci_h->data[1] = actual_count + CCCI_H_LEN;
+			ccci_h->status &= ~HDR_FLD_CHN;
+			ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, port->tx_ch);
+			ccci_h->reserved = 0;
+
+			ret = copy_from_user(skb_put(skb, actual_count),
+					     buf + i * (txq_mtu - CCCI_H_ELEN), actual_count);
+		}
+
+		if (ret) {
+			ret = -EFAULT;
+			goto err_out;
+		}
+
+		/* send out */
+		port_proxy_set_seq_num(port, ccci_h);
+		ret = port_send_skb_to_md(port, skb, blocking);
+		if (ret) {
+			if (ret == -EBUSY && !blocking)
+				ret = -EAGAIN;
+
+			goto err_out;
+		} else {
+			/* Record the port seq_num after the data is sent to HIF.
+			 * Only bits 0-14 are used, thus negating overflow.
+			 */
+			port->seq_nums[MTK_OUT]++;
+		}
+
+		if (multi_packet == 1) {
+			mutex_unlock(&port->tx_mutex_lock);
+			return actual_count;
+		} else if (multi_packet == i + 1) {
+			mutex_unlock(&port->tx_mutex_lock);
+			return count;
+		}
+	}
+
+err_out:
+	mutex_unlock(&port->tx_mutex_lock);
+	dev_err(port->dev, "write error done on %s, size: %zu, ret: %d\n",
+		port->name, actual_count, ret);
+	ccci_free_skb(&port->mtk_dev->pools, skb);
+	return ret;
+}
+
+static const struct file_operations char_fops = {
+	.owner = THIS_MODULE,
+	.open = &port_char_open,
+	.read = &port_char_read,
+	.write = &port_char_write,
+	.release = &port_char_close,
+	.poll = &port_char_poll,
+};
+
+static int port_char_init(struct t7xx_port *port)
+{
+	struct cdev *dev;
+
+	port->rx_length_th = MAX_RX_QUEUE_LENGTH;
+	port->skb_from_pool = true;
+	if (port->flags & PORT_F_RX_CHAR_NODE) {
+		dev = cdev_alloc();
+		if (!dev)
+			return -ENOMEM;
+
+		dev->ops = &char_fops;
+		dev->owner = THIS_MODULE;
+		if (cdev_add(dev, MKDEV(port->major, port->minor_base + port->minor), 1)) {
+			kobject_put(&dev->kobj);
+			return -ENOMEM;
+		}
+
+		if (!(port->flags & PORT_F_RAW_DATA))
+			port->flags |= PORT_F_RX_ADJUST_HEADER;
+
+		port->cdev = dev;
+	}
+
+	if (port->rx_ch == CCCI_UART2_RX)
+		port->flags |= PORT_F_RX_CH_TRAFFIC;
+
+	return 0;
+}
+
+static void port_char_uninit(struct t7xx_port *port)
+{
+	unsigned long flags;
+	struct sk_buff *skb;
+
+	if (port->flags & PORT_F_RX_CHAR_NODE && port->cdev) {
+		if (port->chn_crt_stat == CCCI_CHAN_ENABLE) {
+			port_unregister_device(port->major, port->minor_base + port->minor);
+			spin_lock(&port->port_update_lock);
+			port->chn_crt_stat = CCCI_CHAN_DISABLE;
+			spin_unlock(&port->port_update_lock);
+		}
+
+		cdev_del(port->cdev);
+		port->cdev = NULL;
+	}
+
+	/* interrupts need to be disabled */
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
+		ccci_free_skb(&port->mtk_dev->pools, skb);
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+}
+
+static int port_char_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	if ((port->flags & PORT_F_RX_CHAR_NODE) && !atomic_read(&port->usage_cnt)) {
+		dev_err_ratelimited(port->dev,
+				    "port %s is not opened, dropping packets\n", port->name);
+		return -ENETDOWN;
+	}
+
+	return port_recv_skb(port, skb);
+}
+
+static int port_status_update(struct t7xx_port *port)
+{
+	if (!(port->flags & PORT_F_RX_CHAR_NODE))
+		return 0;
+
+	if (port->chan_enable == CCCI_CHAN_ENABLE) {
+		int ret;
+
+		port->flags &= ~PORT_F_RX_ALLOW_DROP;
+		ret = port_register_device(port->name, port->major,
+					   port->minor_base + port->minor);
+		if (ret)
+			return ret;
+
+		port_proxy_broadcast_state(port, MTK_PORT_STATE_ENABLE);
+		spin_lock(&port->port_update_lock);
+		port->chn_crt_stat = CCCI_CHAN_ENABLE;
+		spin_unlock(&port->port_update_lock);
+
+		return 0;
+	}
+
+	port->flags |= PORT_F_RX_ALLOW_DROP;
+	port_unregister_device(port->major, port->minor_base + port->minor);
+	spin_lock(&port->port_update_lock);
+	port->chn_crt_stat = CCCI_CHAN_DISABLE;
+	spin_unlock(&port->port_update_lock);
+	return port_proxy_broadcast_state(port, MTK_PORT_STATE_DISABLE);
+}
+
+static int port_char_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_ENABLE;
+	spin_unlock(&port->port_update_lock);
+	if (port->chn_crt_stat != port->chan_enable)
+		return port_status_update(port);
+
+	return 0;
+}
+
+static int port_char_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_DISABLE;
+	spin_unlock(&port->port_update_lock);
+	if (port->chn_crt_stat != port->chan_enable)
+		return port_status_update(port);
+
+	return 0;
+}
+
+static void port_char_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	if (state == MD_STATE_READY)
+		port_status_update(port);
+}
+
+struct port_ops char_port_ops = {
+	.init = &port_char_init,
+	.recv_skb = &port_char_recv_skb,
+	.uninit = &port_char_uninit,
+	.enable_chl = &port_char_enable_chl,
+	.disable_chl = &port_char_disable_chl,
+	.md_state_notify = &port_char_md_state_notify,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 6d97d21d9d13..cc4a0e34962d 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -34,6 +34,7 @@
 #define TTY_PORT_MINOR_INVALID			-1
 
 static struct port_proxy *port_prox;
+static struct class *dev_class;
 
 #define for_each_proxy_port(i, p, proxy)	\
 	for (i = 0, (p) = &(proxy)->ports[i];	\
@@ -43,8 +44,32 @@ static struct port_proxy *port_prox;
 static struct t7xx_port md_ccci_ports[] = {
 	{CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, DATA_AT_CMD_Q, 0xff,
 	 0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 0, "ttyC0", WWAN_PORT_AT},
+	{CCCI_MD_LOG_TX, CCCI_MD_LOG_RX, 7, 7, 7, 7, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 2, "ttyCMdLog", WWAN_PORT_AT},
+	{CCCI_LB_IT_TX, CCCI_LB_IT_RX, 0, 0, 0xff, 0xff, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 3, "ccci_lb_it",},
+	{CCCI_MIPC_TX, CCCI_MIPC_RX, 2, 2, 0, 0, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &tty_port_ops, 1, "ttyCMIPC0",},
 	{CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
 	 PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", WWAN_PORT_MBIM},
+	{CCCI_UART1_TX, CCCI_UART1_RX, 1, 1, 1, 1, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 11, "ttyCMdMeta",},
+	{CCCI_DSS0_TX, CCCI_DSS0_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 13, "ttyCMBIMDSS0",},
+	{CCCI_DSS1_TX, CCCI_DSS1_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 14, "ttyCMBIMDSS1",},
+	{CCCI_DSS2_TX, CCCI_DSS2_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 15, "ttyCMBIMDSS2",},
+	{CCCI_DSS3_TX, CCCI_DSS3_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 16, "ttyCMBIMDSS3",},
+	{CCCI_DSS4_TX, CCCI_DSS4_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 17, "ttyCMBIMDSS4",},
+	{CCCI_DSS5_TX, CCCI_DSS5_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 18, "ttyCMBIMDSS5",},
+	{CCCI_DSS6_TX, CCCI_DSS6_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 19, "ttyCMBIMDSS6",},
+	{CCCI_DSS7_TX, CCCI_DSS7_RX, 3, 3, 3, 3, ID_CLDMA1,
+	 PORT_F_RX_CHAR_NODE, &char_port_ops, 20, "ttyCMBIMDSS7",},
 	{CCCI_CONTROL_TX, CCCI_CONTROL_RX, 0, 0, 0, 0, ID_CLDMA1,
 	 0, &ctl_port_ops, 0xff, "ccci_ctrl",},
 };
@@ -648,6 +673,20 @@ struct t7xx_port *port_get_by_name(char *port_name)
 	return NULL;
 }
 
+int port_register_device(const char *name, int major, int minor)
+{
+	struct device *dev;
+
+	dev = device_create(dev_class, NULL, MKDEV(major, minor), NULL, "%s", name);
+
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+void port_unregister_device(int major, int minor)
+{
+	device_destroy(dev_class, MKDEV(major, minor));
+}
+
 int port_proxy_broadcast_state(struct t7xx_port *port, int state)
 {
 	char msg[PORT_NETLINK_MSG_MAX_PAYLOAD];
@@ -685,9 +724,13 @@ int port_proxy_init(struct mtk_modem *md)
 {
 	int ret;
 
+	dev_class = class_create(THIS_MODULE, "ccci_node");
+	if (IS_ERR(dev_class))
+		return PTR_ERR(dev_class);
+
 	ret = proxy_alloc(md);
 	if (ret)
-		return ret;
+		goto err_proxy;
 
 	ret = port_netlink_init();
 	if (ret)
@@ -697,6 +740,8 @@ int port_proxy_init(struct mtk_modem *md)
 
 	return 0;
 
+err_proxy:
+	class_destroy(dev_class);
 err_netlink:
 	port_proxy_uninit();
 
@@ -715,6 +760,8 @@ void port_proxy_uninit(void)
 	unregister_chrdev_region(MKDEV(port_prox->major, port_prox->minor_base),
 				 TTY_IPC_MINOR_BASE);
 	port_netlink_uninit();
+
+	class_destroy(dev_class);
 }
 
 /**
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index ca3acb2e0020..8a1e4102095f 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -74,8 +74,11 @@ struct port_msg {
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
 /* port operations mapping */
+extern struct port_ops char_port_ops;
 extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
+extern struct port_ops tty_port_ops;
+extern struct tty_dev_ops tty_ops;
 
 int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool);
 void port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_tty.c b/drivers/net/wwan/t7xx/t7xx_port_tty.c
new file mode 100644
index 000000000000..13ca7e8cb123
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_tty.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include "t7xx_common.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_skb_util.h"
+#include "t7xx_tty_ops.h"
+
+#define TTY_PORT_NAME_BASE		"ttyC"
+#define TTY_PORT_NR			32
+
+static int ccci_tty_send_pkt(int tty_port_idx, const void *data, int len)
+{
+	struct ccci_header *ccci_h = NULL;
+	int actual_count, alloc_size;
+	int ret, header_len = 0;
+	struct t7xx_port *port;
+	struct sk_buff *skb;
+
+	port = port_get_by_minor(tty_port_idx + TTY_PORT_MINOR_BASE);
+	if (!port)
+		return -ENXIO;
+
+	if (port->flags & PORT_F_RAW_DATA) {
+		actual_count = len > CLDMA_TXQ_MTU ? CLDMA_TXQ_MTU : len;
+		alloc_size = actual_count;
+	} else {
+		/* get skb info */
+		header_len = sizeof(struct ccci_header);
+		actual_count = len > CCCI_MTU ? CCCI_MTU : len;
+		alloc_size = actual_count + header_len;
+	}
+
+	skb = ccci_alloc_skb_from_pool(&port->mtk_dev->pools, alloc_size, GFS_BLOCKING);
+	if (skb) {
+		if (!(port->flags & PORT_F_RAW_DATA)) {
+			ccci_h = skb_put(skb, sizeof(struct ccci_header));
+			ccci_h->data[0] = 0;
+			ccci_h->data[1] = actual_count + header_len;
+			ccci_h->status &= ~HDR_FLD_CHN;
+			ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, port->tx_ch);
+			ccci_h->reserved = 0;
+		}
+	} else {
+		return -ENOMEM;
+	}
+
+	memcpy(skb_put(skb, actual_count), data, actual_count);
+
+	/* send data */
+	port_proxy_set_seq_num(port, ccci_h);
+	ret = port_send_skb_to_md(port, skb, true);
+	if (ret) {
+		dev_err(port->dev, "failed to send skb to md, ret = %d\n", ret);
+		return ret;
+	}
+
+	/* Record the port seq_num after the data is sent to HIF.
+	 * Only bits 0-14 are used, thus negating overflow.
+	 */
+	port->seq_nums[MTK_OUT]++;
+
+	return actual_count;
+}
+
+static struct tty_ccci_ops mtk_tty_ops = {
+	.tty_num = TTY_PORT_NR,
+	.name = TTY_PORT_NAME_BASE,
+	.md_ability = 0,
+	.send_pkt = ccci_tty_send_pkt,
+};
+
+static int port_tty_init(struct t7xx_port *port)
+{
+	/* mapping the minor number to tty dev idx */
+	port->minor += TTY_PORT_MINOR_BASE;
+
+	/* init the tty driver */
+	if (!tty_ops.tty_driver_status) {
+		tty_ops.tty_driver_status = true;
+		atomic_set(&tty_ops.port_installed_num, 0);
+		tty_ops.init(&mtk_tty_ops, port);
+	}
+
+	return 0;
+}
+
+static int port_tty_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	int actual_recv_len;
+
+	/* get skb data */
+	if (!(port->flags & PORT_F_RAW_DATA))
+		skb_pull(skb, sizeof(struct ccci_header));
+
+	/* send data to tty driver. */
+	actual_recv_len = tty_ops.rx_callback(port, skb->data, skb->len);
+
+	if (actual_recv_len != skb->len) {
+		dev_err(port->dev, "ccci port[%s] recv skb fail\n", port->name);
+		skb_push(skb, sizeof(struct ccci_header));
+		return -ENOBUFS;
+	}
+
+	ccci_free_skb(&port->mtk_dev->pools, skb);
+	return 0;
+}
+
+static void port_tty_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	if (state != MD_STATE_READY || port->chan_enable != CCCI_CHAN_ENABLE)
+		return;
+
+	port->flags &= ~PORT_F_RX_ALLOW_DROP;
+	/* create a tty port */
+	tty_ops.tty_port_create(port, port->name);
+	atomic_inc(&tty_ops.port_installed_num);
+	spin_lock(&port->port_update_lock);
+	port->chn_crt_stat = CCCI_CHAN_ENABLE;
+	spin_unlock(&port->port_update_lock);
+}
+
+static void port_tty_uninit(struct t7xx_port *port)
+{
+	port->minor -= TTY_PORT_MINOR_BASE;
+
+	if (port->chn_crt_stat != CCCI_CHAN_ENABLE)
+		return;
+
+	/* destroy tty port */
+	tty_ops.tty_port_destroy(port);
+	spin_lock(&port->port_update_lock);
+	port->chn_crt_stat = CCCI_CHAN_DISABLE;
+	spin_unlock(&port->port_update_lock);
+
+	/* CCCI tty driver exit */
+	if (atomic_dec_and_test(&tty_ops.port_installed_num) && tty_ops.exit) {
+		tty_ops.exit();
+		tty_ops.tty_driver_status = false;
+	}
+}
+
+static int port_tty_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_ENABLE;
+	spin_unlock(&port->port_update_lock);
+	if (port->chn_crt_stat != port->chan_enable) {
+		port->flags &= ~PORT_F_RX_ALLOW_DROP;
+		/* create a tty port */
+		tty_ops.tty_port_create(port, port->name);
+		spin_lock(&port->port_update_lock);
+		port->chn_crt_stat = CCCI_CHAN_ENABLE;
+		spin_unlock(&port->port_update_lock);
+		atomic_inc(&tty_ops.port_installed_num);
+	}
+
+	return 0;
+}
+
+static int port_tty_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = CCCI_CHAN_DISABLE;
+	spin_unlock(&port->port_update_lock);
+	return 0;
+}
+
+struct port_ops tty_port_ops = {
+	.init = &port_tty_init,
+	.recv_skb = &port_tty_recv_skb,
+	.md_state_notify = &port_tty_md_state_notify,
+	.uninit = &port_tty_uninit,
+	.enable_chl = &port_tty_enable_chl,
+	.disable_chl = &port_tty_disable_chl,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_tty_ops.c b/drivers/net/wwan/t7xx/t7xx_tty_ops.c
new file mode 100644
index 000000000000..b9eedba177b7
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_tty_ops.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+
+#include "t7xx_port_proxy.h"
+#include "t7xx_tty_ops.h"
+
+#define GET_TTY_IDX(p)		((p)->minor - TTY_PORT_MINOR_BASE)
+
+static struct tty_ctl_block *tty_ctlb;
+static const struct tty_port_operations null_ops = {};
+
+static int ccci_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct tty_port *pport;
+	int ret = 0;
+
+	pport = tty->driver->ports[tty->index];
+	if (pport)
+		ret = tty_port_open(pport, tty, filp);
+
+	return ret;
+}
+
+static void ccci_tty_close(struct tty_struct *tty, struct file *filp)
+{
+	struct tty_port *pport;
+
+	pport = tty->driver->ports[tty->index];
+	if (pport)
+		tty_port_close(pport, tty, filp);
+}
+
+static int ccci_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
+{
+	if (!(tty_ctlb && tty_ctlb->driver == tty->driver))
+		return -EFAULT;
+
+	return tty_ctlb->ccci_ops->send_pkt(tty->index, buf, count);
+}
+
+static unsigned int ccci_tty_write_room(struct tty_struct *tty)
+{
+	return CCCI_MTU;
+}
+
+static const struct tty_operations ccci_serial_ops = {
+	.open = ccci_tty_open,
+	.close = ccci_tty_close,
+	.write = ccci_tty_write,
+	.write_room = ccci_tty_write_room,
+};
+
+static int ccci_tty_port_create(struct t7xx_port *port, char *port_name)
+{
+	struct tty_driver *tty_drv;
+	struct tty_port *pport;
+	int minor = GET_TTY_IDX(port);
+
+	tty_drv = tty_ctlb->driver;
+	tty_drv->name = port_name;
+
+	pport = devm_kzalloc(port->dev, sizeof(*pport), GFP_KERNEL);
+	if (!pport)
+		return -ENOMEM;
+
+	tty_port_init(pport);
+	pport->ops = &null_ops;
+	tty_port_link_device(pport, tty_drv, minor);
+	tty_register_device(tty_drv, minor, NULL);
+	return 0;
+}
+
+static int ccci_tty_port_destroy(struct t7xx_port *port)
+{
+	struct tty_driver *tty_drv;
+	struct tty_port *pport;
+	struct tty_struct *tty;
+	int minor = port->minor;
+
+	tty_drv = tty_ctlb->driver;
+
+	pport = tty_drv->ports[minor];
+	if (!pport) {
+		dev_err(port->dev, "Invalid tty minor:%d\n", minor);
+		return -EINVAL;
+	}
+
+	tty = tty_port_tty_get(pport);
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
+
+	tty_unregister_device(tty_drv, minor);
+	tty_port_destroy(pport);
+	tty_drv->ports[minor] = NULL;
+	return 0;
+}
+
+static int tty_ccci_init(struct tty_ccci_ops *ccci_info, struct t7xx_port *port)
+{
+	struct port_proxy *port_proxy_ptr;
+	struct tty_driver *tty_drv;
+	struct tty_ctl_block *ctlb;
+	int ret, port_nr;
+
+	ctlb = devm_kzalloc(port->dev, sizeof(*ctlb), GFP_KERNEL);
+	if (!ctlb)
+		return -ENOMEM;
+
+	ctlb->ccci_ops = devm_kzalloc(port->dev, sizeof(*ctlb->ccci_ops), GFP_KERNEL);
+	if (!ctlb->ccci_ops)
+		return -ENOMEM;
+
+	tty_ctlb = ctlb;
+	memcpy(ctlb->ccci_ops, ccci_info, sizeof(struct tty_ccci_ops));
+	port_nr = ctlb->ccci_ops->tty_num;
+
+	tty_drv = tty_alloc_driver(port_nr, 0);
+	if (IS_ERR(tty_drv))
+		return -ENOMEM;
+
+	/* init tty driver */
+	port_proxy_ptr = port->port_proxy;
+	ctlb->driver = tty_drv;
+	tty_drv->driver_name = ctlb->ccci_ops->name;
+	tty_drv->name = ctlb->ccci_ops->name;
+	tty_drv->major = port_proxy_ptr->major;
+	tty_drv->minor_start = TTY_PORT_MINOR_BASE;
+	tty_drv->type = TTY_DRIVER_TYPE_SERIAL;
+	tty_drv->subtype = SERIAL_TYPE_NORMAL;
+	tty_drv->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
+			 TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_UNNUMBERED_NODE;
+	tty_drv->init_termios = tty_std_termios;
+	tty_drv->init_termios.c_iflag = 0;
+	tty_drv->init_termios.c_oflag = 0;
+	tty_drv->init_termios.c_cflag |= CLOCAL;
+	tty_drv->init_termios.c_lflag = 0;
+	tty_set_operations(tty_drv, &ccci_serial_ops);
+
+	ret = tty_register_driver(tty_drv);
+	if (ret < 0) {
+		dev_err(port->dev, "Could not register tty driver\n");
+		tty_driver_kref_put(tty_drv);
+	}
+
+	return ret;
+}
+
+static void tty_ccci_uninit(void)
+{
+	struct tty_driver *tty_drv;
+	struct tty_ctl_block *ctlb;
+
+	ctlb = tty_ctlb;
+	if (ctlb) {
+		tty_drv = ctlb->driver;
+		tty_unregister_driver(tty_drv);
+		tty_driver_kref_put(tty_drv);
+		tty_ctlb = NULL;
+	}
+}
+
+static int tty_rx_callback(struct t7xx_port *port, void *data, int len)
+{
+	struct tty_port *pport;
+	struct tty_driver *drv;
+	int tty_id = GET_TTY_IDX(port);
+	int copied = 0;
+
+	drv = tty_ctlb->driver;
+	pport = drv->ports[tty_id];
+
+	if (!pport) {
+		dev_err(port->dev, "tty port isn't created, the packet is dropped\n");
+		return len;
+	}
+
+	/* push data to tty port buffer */
+	copied = tty_insert_flip_string(pport, data, len);
+
+	/* trigger port buffer -> line discipline buffer */
+	tty_flip_buffer_push(pport);
+	return copied;
+}
+
+struct tty_dev_ops tty_ops = {
+	.init = &tty_ccci_init,
+	.tty_port_create = &ccci_tty_port_create,
+	.tty_port_destroy = &ccci_tty_port_destroy,
+	.rx_callback = &tty_rx_callback,
+	.exit = &tty_ccci_uninit,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_tty_ops.h b/drivers/net/wwan/t7xx/t7xx_tty_ops.h
new file mode 100644
index 000000000000..a751c57eb11a
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_tty_ops.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_TTY_OPS_H__
+#define __T7XX_TTY_OPS_H__
+
+#include <linux/types.h>
+
+#include "t7xx_port_proxy.h"
+
+#define TTY_PORT_MINOR_BASE	250
+
+struct tty_ccci_ops {
+	int			tty_num;
+	unsigned char		name[16];
+	unsigned int		md_ability;
+	int			(*send_pkt)(int tty_idx, const void *data, int len);
+};
+
+struct tty_ctl_block {
+	struct tty_driver	*driver;
+	struct tty_ccci_ops	*ccci_ops;
+	unsigned int		md_sta;
+};
+
+struct tty_dev_ops {
+	/* tty port information */
+	bool			tty_driver_status;
+	atomic_t		port_installed_num;
+	int			(*init)(struct tty_ccci_ops *ccci_info, struct t7xx_port *port);
+	int			(*tty_port_create)(struct t7xx_port *port, char *port_name);
+	int			(*tty_port_destroy)(struct t7xx_port *port);
+	int			(*rx_callback)(struct t7xx_port *port, void *data, int len);
+	void			(*exit)(void);
+};
+#endif /* __T7XX_TTY_OPS_H__ */
-- 
2.17.1

