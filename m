Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFC39FD37
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhFHRIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:08:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:45969 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233523AbhFHRIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 13:08:19 -0400
IronPort-SDR: w3rMFRBH78dpaQKzHASJFkVblQN0XUwsV3/wbeZo69CVgN3uSNOoWw6Plf6DqFv2iVpFKSyP5B
 HEtVN+5A2XaQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="204855386"
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="204855386"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 10:05:56 -0700
IronPort-SDR: hPNQtg/89IeI3XXbjbE7xOk/ehlnD45MEgCLGaTzJpv7cHQNcLLybQa2dUhpSKgcTlo6/+JOX7
 /5cP8P+YOvCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="482035619"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2021 10:05:53 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V4 15/16] net: iosm: net driver
Date:   Tue,  8 Jun 2021 22:34:48 +0530
Message-Id: <20210608170449.28031-16-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210608170449.28031-1-m.chetan.kumar@intel.com>
References: <20210608170449.28031-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Create net device & implement net operations for data/IP communication.
2) Bind IP Link to mux IP session for simultaneous IP traffic.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v4:
* Adapt to wwan subsystem rtnet_link ops.
* Fix stats and RCU bugs in RX.
v3:
* Clean-up DSS channel implementation.
* Aligned ipc_ prefix for function name to be consistent across file.
v2:
* Removed Ethernet header & VLAN tag handling from wwan net driver.
* Implement rtnet_link interface for IP traffic handling.
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 350 ++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_wwan.h |  55 ++++
 2 files changed, 405 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
new file mode 100644
index 000000000000..80306b37c2b5
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -0,0 +1,350 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <linux/if_link.h>
+#include <linux/rtnetlink.h>
+#include <linux/wwan.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem_ops.h"
+#include "iosm_ipc_wwan.h"
+
+#define IOSM_IP_TYPE_MASK 0xF0
+#define IOSM_IP_TYPE_IPV4 0x40
+#define IOSM_IP_TYPE_IPV6 0x60
+
+#define IOSM_IF_ID_PAYLOAD 2
+
+/**
+ * struct iosm_netdev_priv - netdev private data
+ * @if_id:	Interface id for device.
+ * @ch_id:	IPC channel number for which interface device is created.
+ * @ipc_wwan:	Pointer to iosm_wwan struct
+ */
+struct iosm_netdev_priv {
+	struct iosm_wwan *ipc_wwan;
+	struct net_device *netdev;
+	int if_id;
+	int ch_id;
+};
+
+/**
+ * struct iosm_wwan - This structure contains information about WWAN root device
+ *		      and interface to the IPC layer.
+ * @ipc_imem:		Pointer to imem data-struct
+ * @sub_netlist:	List of active netdevs
+ * @dev:		Pointer device structure
+ * @if_mutex:		Mutex used for add and remove interface id
+ */
+struct iosm_wwan {
+	struct iosm_imem *ipc_imem;
+	struct iosm_netdev_priv __rcu *sub_netlist[IP_MUX_SESSION_END + 1];
+	struct device *dev;
+	struct mutex if_mutex; /* Mutex used for add and remove interface id */
+};
+
+/* Bring-up the wwan net link */
+static int ipc_wwan_link_open(struct net_device *netdev)
+{
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
+	int if_id = priv->if_id;
+	int ret;
+
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
+
+	mutex_lock(&ipc_wwan->if_mutex);
+
+	/* get channel id */
+	priv->ch_id = ipc_imem_sys_wwan_open(ipc_wwan->ipc_imem, if_id);
+
+	if (priv->ch_id < 0) {
+		dev_err(ipc_wwan->dev,
+			"cannot connect wwan0 & id %d to the IPC mem layer",
+			if_id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* enable tx path, DL data may follow */
+	netif_start_queue(netdev);
+
+	dev_dbg(ipc_wwan->dev, "Channel id %d allocated to if_id %d",
+		priv->ch_id, priv->if_id);
+
+	ret = 0;
+out:
+	mutex_unlock(&ipc_wwan->if_mutex);
+	return ret;
+}
+
+/* Bring-down the wwan net link */
+static int ipc_wwan_link_stop(struct net_device *netdev)
+{
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+
+	netif_stop_queue(netdev);
+
+	mutex_lock(&priv->ipc_wwan->if_mutex);
+	ipc_imem_sys_wwan_close(priv->ipc_wwan->ipc_imem, priv->if_id,
+				priv->ch_id);
+	priv->ch_id = -1;
+	mutex_unlock(&priv->ipc_wwan->if_mutex);
+
+	return 0;
+}
+
+/* Transmit a packet */
+static int ipc_wwan_link_transmit(struct sk_buff *skb,
+				  struct net_device *netdev)
+{
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
+	int if_id = priv->if_id;
+	int ret;
+
+	/* Interface IDs from 1 to 8 are for IP data
+	 * & from 257 to 261 are for non-IP data
+	 */
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
+
+	/* Send the SKB to device for transmission */
+	ret = ipc_imem_sys_wwan_transmit(ipc_wwan->ipc_imem,
+					 if_id, priv->ch_id, skb);
+
+	/* Return code of zero is success */
+	if (ret == 0) {
+		ret = NETDEV_TX_OK;
+	} else if (ret == -EBUSY) {
+		ret = NETDEV_TX_BUSY;
+		dev_err(ipc_wwan->dev, "unable to push packets");
+	} else {
+		goto exit;
+	}
+
+	return ret;
+
+exit:
+	/* Log any skb drop */
+	if (if_id)
+		dev_dbg(ipc_wwan->dev, "skb dropped. IF_ID: %d, ret: %d", if_id,
+			ret);
+
+	dev_kfree_skb_any(skb);
+	return ret;
+}
+
+/* Ops structure for wwan net link */
+static const struct net_device_ops ipc_inm_ops = {
+	.ndo_open = ipc_wwan_link_open,
+	.ndo_stop = ipc_wwan_link_stop,
+	.ndo_start_xmit = ipc_wwan_link_transmit,
+};
+
+/* Setup function for creating new net link */
+static void ipc_wwan_setup(struct net_device *iosm_dev)
+{
+	iosm_dev->header_ops = NULL;
+	iosm_dev->hard_header_len = 0;
+	iosm_dev->priv_flags |= IFF_NO_QUEUE;
+
+	iosm_dev->type = ARPHRD_NONE;
+	iosm_dev->min_mtu = ETH_MIN_MTU;
+	iosm_dev->max_mtu = ETH_MAX_MTU;
+
+	iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
+
+	iosm_dev->netdev_ops = &ipc_inm_ops;
+}
+
+/* Create new wwan net link */
+static int ipc_wwan_newlink(void *ctxt, struct net_device *dev,
+			    u32 if_id, struct netlink_ext_ack *extack)
+{
+	struct iosm_wwan *ipc_wwan = ctxt;
+	struct iosm_netdev_priv *priv;
+	int err;
+
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
+
+	priv = netdev_priv(dev);
+	priv->if_id = if_id;
+	priv->netdev = dev;
+	priv->ipc_wwan = ipc_wwan;
+
+	mutex_lock(&ipc_wwan->if_mutex);
+	if (rcu_access_pointer(ipc_wwan->sub_netlist[if_id])) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
+	err = register_netdevice(dev);
+	if (err)
+		goto out_unlock;
+
+	rcu_assign_pointer(ipc_wwan->sub_netlist[if_id], priv);
+	mutex_unlock(&ipc_wwan->if_mutex);
+
+	netif_device_attach(dev);
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&ipc_wwan->if_mutex);
+	return err;
+}
+
+static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
+			     struct list_head *head)
+{
+	struct iosm_wwan *ipc_wwan = ctxt;
+	struct iosm_netdev_priv *priv = netdev_priv(dev);
+	int if_id = priv->if_id;
+
+	if (WARN_ON(if_id < IP_MUX_SESSION_START ||
+		    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist)))
+		return;
+
+	mutex_lock(&ipc_wwan->if_mutex);
+
+	if (WARN_ON(rcu_access_pointer(ipc_wwan->sub_netlist[if_id]) != priv))
+		goto unlock;
+
+	RCU_INIT_POINTER(ipc_wwan->sub_netlist[if_id], NULL);
+	/* unregistering includes synchronize_net() */
+	unregister_netdevice(dev);
+
+unlock:
+	mutex_unlock(&ipc_wwan->if_mutex);
+}
+
+static const struct wwan_ops iosm_wwan_ops = {
+	.priv_size = sizeof(struct iosm_netdev_priv),
+	.setup = ipc_wwan_setup,
+	.newlink = ipc_wwan_newlink,
+	.dellink = ipc_wwan_dellink,
+};
+
+int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
+		     bool dss, int if_id)
+{
+	struct sk_buff *skb = skb_arg;
+	struct net_device_stats *stats;
+	struct iosm_netdev_priv *priv;
+	int ret;
+
+	if ((skb->data[0] & IOSM_IP_TYPE_MASK) == IOSM_IP_TYPE_IPV4)
+		skb->protocol = htons(ETH_P_IP);
+	else if ((skb->data[0] & IOSM_IP_TYPE_MASK) ==
+		 IOSM_IP_TYPE_IPV6)
+		skb->protocol = htons(ETH_P_IPV6);
+
+	skb->pkt_type = PACKET_HOST;
+
+	if (if_id < (IP_MUX_SESSION_START - 1) ||
+	    if_id > (IP_MUX_SESSION_END - 1)) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	rcu_read_lock();
+	priv = rcu_dereference(ipc_wwan->sub_netlist[if_id]);
+	if (!priv) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	skb->dev = priv->netdev;
+	stats = &priv->netdev->stats;
+	stats->rx_packets++;
+	stats->rx_bytes += skb->len;
+
+	ret = netif_rx(skb);
+	skb = NULL;
+unlock:
+	rcu_read_unlock();
+free:
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int if_id, bool on)
+{
+	struct net_device *netdev;
+	struct iosm_netdev_priv *priv;
+	bool is_tx_blk;
+
+	rcu_read_lock();
+	priv = rcu_dereference(ipc_wwan->sub_netlist[if_id]);
+	if (!priv) {
+		rcu_read_unlock();
+		return;
+	}
+
+	netdev = priv->netdev;
+
+	is_tx_blk = netif_queue_stopped(netdev);
+
+	if (on)
+		dev_dbg(ipc_wwan->dev, "session id[%d]: flowctrl enable",
+			if_id);
+
+	if (on && !is_tx_blk)
+		netif_stop_queue(netdev);
+	else if (!on && is_tx_blk)
+		netif_wake_queue(netdev);
+	rcu_read_unlock();
+}
+
+struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
+{
+	struct iosm_wwan *ipc_wwan;
+
+	ipc_wwan = kzalloc(sizeof(*ipc_wwan), GFP_KERNEL);
+	if (!ipc_wwan)
+		return NULL;
+
+	ipc_wwan->dev = dev;
+	ipc_wwan->ipc_imem = ipc_imem;
+
+	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan)) {
+		kfree(ipc_wwan);
+		return NULL;
+	}
+
+	mutex_init(&ipc_wwan->if_mutex);
+
+	return ipc_wwan;
+}
+
+void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
+{
+	int if_id;
+
+	wwan_unregister_ops(ipc_wwan->dev);
+
+	for (if_id = 0; if_id < ARRAY_SIZE(ipc_wwan->sub_netlist); if_id++) {
+		struct iosm_netdev_priv *priv;
+
+		priv = rcu_access_pointer(ipc_wwan->sub_netlist[if_id]);
+		if (!priv)
+			continue;
+
+		rtnl_lock();
+		ipc_wwan_dellink(ipc_wwan, priv->netdev, NULL);
+		rtnl_unlock();
+	}
+
+	mutex_destroy(&ipc_wwan->if_mutex);
+
+	kfree(ipc_wwan);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.h b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
new file mode 100644
index 000000000000..4925f22dff0a
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_WWAN_H
+#define IOSM_IPC_WWAN_H
+
+/**
+ * ipc_wwan_init - Allocate, Init and register WWAN device
+ * @ipc_imem:		Pointer to imem data-struct
+ * @dev:		Pointer to device structure
+ *
+ * Returns: Pointer to instance on success else NULL
+ */
+struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev);
+
+/**
+ * ipc_wwan_deinit - Unregister and free WWAN device, clear pointer
+ * @ipc_wwan:	Pointer to wwan instance data
+ */
+void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan);
+
+/**
+ * ipc_wwan_receive - Receive a downlink packet from CP.
+ * @ipc_wwan:	Pointer to wwan instance
+ * @skb_arg:	Pointer to struct sk_buff
+ * @dss:	Set to true if interafce id is from 257 to 261,
+ *		else false
+ * @if_id:	Interface ID
+ *
+ * Return: 0 on success and failure value on error
+ */
+int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
+		     bool dss, int if_id);
+
+/**
+ * ipc_wwan_tx_flowctrl - Enable/Disable TX flow control
+ * @ipc_wwan:	Pointer to wwan instance
+ * @id:		Ipc mux channel session id
+ * @on:		if true then flow ctrl would be enabled else disable
+ *
+ */
+void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int id, bool on);
+
+/**
+ * ipc_wwan_is_tx_stopped - Checks if Tx stopped for a Interface id.
+ * @ipc_wwan:	Pointer to wwan instance
+ * @id:		Ipc mux channel session id
+ *
+ * Return: true if stopped, false otherwise
+ */
+bool ipc_wwan_is_tx_stopped(struct iosm_wwan *ipc_wwan, int id);
+
+#endif
-- 
2.25.1

