Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5E2C0C5D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388683AbgKWNwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:1517 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbgKWNwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:40 -0500
IronPort-SDR: wYDSrpebPGEstalQqRKEKrQn+jgiALiIBjHK5+SZaRxBEGFZRU5ohT75ConRgH+Z/nXk4WH5YV
 eurYyeQ/XukQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981512"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981512"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:38 -0800
IronPort-SDR: 7ZpVixRrR/SuDpmnmoL1FlL4GbzJO4y1yzaIwZj15KOb1brYqDpLUO/2BvkVkQ3BQHps1EypGC
 ctisJb/hEV/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035664"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:36 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 16/18] net: iosm: net driver
Date:   Mon, 23 Nov 2020 19:21:21 +0530
Message-Id: <20201123135123.48892-17-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Create net device for data/IP communication.
2) Bind VLAN ID to mux IP session.
3) Implement net device operations.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 674 ++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_wwan.h |  72 ++++
 2 files changed, 746 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
new file mode 100644
index 000000000000..f14a971455bb
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -0,0 +1,674 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/if_vlan.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem_ops.h"
+
+/* Minimum number of transmit queues per WWAN root device */
+#define WWAN_MIN_TXQ (1)
+/* Minimum number of receive queues per WWAN root device */
+#define WWAN_MAX_RXQ (1)
+/* Default transmit queue for WWAN root device */
+#define WWAN_DEFAULT_TXQ (0)
+/* VLAN tag for WWAN root device */
+#define WWAN_ROOT_VLAN_TAG (0)
+
+#define IPC_MEM_MIN_MTU_SIZE (68)
+#define IPC_MEM_MAX_MTU_SIZE (1024 * 1024)
+
+#define IPC_MEM_VLAN_TO_SESSION (1)
+
+/* Required alignment for TX in bytes (32 bit/4 bytes)*/
+#define IPC_WWAN_ALIGN (4)
+
+/**
+ * struct ipc_vlan_info - This structure includes information about VLAN device.
+ * @vlan_id:	VLAN tag of the VLAN device.
+ * @ch_id:	IPC channel number for which VLAN device is created.
+ * @stats:	Contains statistics of VLAN devices.
+ */
+struct ipc_vlan_info {
+	int vlan_id;
+	int ch_id;
+	struct net_device_stats stats;
+};
+
+/**
+ * struct iosm_wwan - This structure contains information about WWAN root device
+ *		     and interface to the IPC layer.
+ * @vlan_devs:		Contains information about VLAN devices created under
+ *			WWAN root device.
+ * @netdev:		Pointer to network interface device structure.
+ * @ops_instance:	Instance pointer for Callbacks
+ * @dev:		Pointer device structure
+ * @lock:		Spinlock to be used for atomic operations of the
+ *			root device.
+ * @stats:		Contains statistics of WWAN root device
+ * @vlan_devs_nr:	Number of VLAN devices.
+ * @if_mutex:		Mutex used for add and remove vlan-id
+ * @max_devs:		Maximum supported VLAN devs
+ * @max_ip_devs:	Maximum supported IP VLAN devs
+ * @is_registered:	Registration status with netdev
+ */
+struct iosm_wwan {
+	struct ipc_vlan_info *vlan_devs;
+	struct net_device *netdev;
+	void *ops_instance;
+	struct device *dev;
+	spinlock_t lock; /* Used for atomic operations on root device */
+	struct net_device_stats stats;
+	int vlan_devs_nr;
+	struct mutex if_mutex; /* Mutex used for add and remove vlan-id */
+	int max_devs;
+	int max_ip_devs;
+	u8 is_registered : 1;
+};
+
+/* Get the array index of requested tag. */
+static int ipc_wwan_get_vlan_devs_nr(struct iosm_wwan *ipc_wwan, u16 tag)
+{
+	int i = 0;
+
+	if (!ipc_wwan->vlan_devs)
+		return -EINVAL;
+
+	for (i = 0; i < ipc_wwan->vlan_devs_nr; i++)
+		if (ipc_wwan->vlan_devs[i].vlan_id == tag)
+			return i;
+
+	return -EINVAL;
+}
+
+static int ipc_wwan_add_vlan(struct iosm_wwan *ipc_wwan, u16 vid)
+{
+	if (vid >= 512 || !ipc_wwan->vlan_devs)
+		return -EINVAL;
+
+	if (vid == WWAN_ROOT_VLAN_TAG)
+		return 0;
+
+	mutex_lock(&ipc_wwan->if_mutex);
+
+	/* get channel id */
+	ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].ch_id =
+		imem_sys_wwan_open(ipc_wwan->ops_instance, vid);
+
+	if (ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].ch_id < 0) {
+		dev_err(ipc_wwan->dev,
+			"cannot connect wwan0 & id %d to the IPC mem layer",
+			vid);
+		mutex_unlock(&ipc_wwan->if_mutex);
+		return -ENODEV;
+	}
+
+	/* save vlan id */
+	ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].vlan_id = vid;
+
+	dev_dbg(ipc_wwan->dev, "Channel id %d allocated to vlan id %d",
+		ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].ch_id,
+		ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].vlan_id);
+
+	ipc_wwan->vlan_devs_nr++;
+
+	mutex_unlock(&ipc_wwan->if_mutex);
+
+	return 0;
+}
+
+static int ipc_wwan_remove_vlan(struct iosm_wwan *ipc_wwan, u16 vid)
+{
+	int ch_nr = ipc_wwan_get_vlan_devs_nr(ipc_wwan, vid);
+	int i = 0;
+
+	if (ch_nr < 0) {
+		dev_err(ipc_wwan->dev, "vlan dev not found for vid = %d", vid);
+		return ch_nr;
+	}
+
+	if (ipc_wwan->vlan_devs[ch_nr].ch_id < 0) {
+		dev_err(ipc_wwan->dev, "invalid ch nr %d to kill", ch_nr);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ipc_wwan->if_mutex);
+
+	imem_sys_wwan_close(ipc_wwan->ops_instance, vid,
+			    ipc_wwan->vlan_devs[ch_nr].ch_id);
+
+	ipc_wwan->vlan_devs[ch_nr].ch_id = -1;
+
+	/* re-align the vlan information as we removed one tag */
+	for (i = ch_nr; i < ipc_wwan->vlan_devs_nr; i++)
+		memcpy(&ipc_wwan->vlan_devs[i], &ipc_wwan->vlan_devs[i + 1],
+		       sizeof(struct ipc_vlan_info));
+
+	ipc_wwan->vlan_devs_nr--;
+
+	mutex_unlock(&ipc_wwan->if_mutex);
+
+	return 0;
+}
+
+/* Checks the protocol and discards the Ethernet header or VLAN header
+ * accordingly.
+ */
+static int ipc_wwan_pull_header(struct sk_buff *skb, bool *is_ip)
+{
+	unsigned int header_size;
+	__be16 proto;
+
+	if (skb->protocol == htons(ETH_P_8021Q)) {
+		proto = vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
+
+		if (skb->len < VLAN_ETH_HLEN)
+			header_size = 0;
+		else
+			header_size = VLAN_ETH_HLEN;
+	} else {
+		proto = eth_hdr(skb)->h_proto;
+
+		if (skb->len < ETH_HLEN)
+			header_size = 0;
+		else
+			header_size = ETH_HLEN;
+	}
+
+	/* If a valid pointer */
+	if (header_size > 0 && is_ip) {
+		*is_ip = (proto == htons(ETH_P_IP)) ||
+			 (proto == htons(ETH_P_IPV6));
+
+		/* Discard the vlan/ethernet header. */
+		if (unlikely(!skb_pull(skb, header_size)))
+			header_size = 0;
+	}
+
+	return header_size;
+}
+
+/* Get VLAN tag from IPC SESSION ID */
+static inline u16 ipc_wwan_mux_session_to_vlan_tag(int id)
+{
+	return (u16)(id + IPC_MEM_VLAN_TO_SESSION);
+}
+
+/* Get IPC SESSION ID from VLAN tag */
+static inline int ipc_wwan_vlan_to_mux_session_id(u16 tag)
+{
+	return tag - IPC_MEM_VLAN_TO_SESSION;
+}
+
+/* Add new vlan device and open a channel */
+static int ipc_wwan_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
+				    u16 vid)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(netdev);
+
+	if (vid != IPC_WWAN_DSS_ID_4)
+		return ipc_wwan_add_vlan(ipc_wwan, vid);
+
+	return 0;
+}
+
+/* Remove vlan device and de-allocate channel */
+static int ipc_wwan_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
+				     u16 vid)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(netdev);
+
+	if (vid == WWAN_ROOT_VLAN_TAG)
+		return 0;
+
+	return ipc_wwan_remove_vlan(ipc_wwan, vid);
+}
+
+static int ipc_wwan_open(struct net_device *netdev)
+{
+	/* Octets in one ethernet addr */
+	if (netdev->addr_len < ETH_ALEN) {
+		pr_err("cannot build the Ethernet address for \"%s\"",
+		       netdev->name);
+		return -ENODEV;
+	}
+
+	/* enable tx path, DL data may follow */
+	netif_tx_start_all_queues(netdev);
+
+	return 0;
+}
+
+static int ipc_wwan_stop(struct net_device *netdev)
+{
+	pr_debug("Stop all TX Queues");
+
+	netif_tx_stop_all_queues(netdev);
+	return 0;
+}
+
+int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
+		     bool dss)
+{
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	u16 tag = 0;
+
+	if (unlikely(!ipc_wwan)) {
+		if (skb_arg)
+			dev_kfree_skb(skb_arg);
+		return -EINVAL;
+	}
+
+	skb = skb_arg;
+
+	eth = (struct ethhdr *)skb->data;
+	if (unlikely(!eth)) {
+		dev_err(ipc_wwan->dev, "ethernet header info error");
+		dev_kfree_skb(skb);
+		return -1;
+	}
+
+	/* Build the ethernet header.
+	 * for kernel version latest than 3.14.0.
+	 */
+	ether_addr_copy(eth->h_dest, ipc_wwan->netdev->dev_addr);
+	ether_addr_copy(eth->h_source, ipc_wwan->netdev->dev_addr);
+	eth->h_source[ETH_ALEN - 1] ^= 0x01; /* src is us xor 1 */
+	/* set the ethernet payload type: ipv4 or ipv6 or Dummy type
+	 * for 802.3 frames
+	 */
+	eth->h_proto = htons(ETH_P_802_3);
+	if (!dss) {
+		if ((skb->data[ETH_HLEN] & 0xF0) == 0x40)
+			eth->h_proto = htons(ETH_P_IP);
+		else if ((skb->data[ETH_HLEN] & 0xF0) == 0x60)
+			eth->h_proto = htons(ETH_P_IPV6);
+	}
+
+	skb->dev = ipc_wwan->netdev;
+	skb->protocol = eth_type_trans(skb, ipc_wwan->netdev);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	vlan_get_tag(skb, &tag);
+	/* TX stats doesn't include ETH_HLEN.
+	 * eth_type_trans() functions pulls the ethernet header.
+	 * so skb->len does not have ethernet header in it.
+	 */
+	ipc_wwan_update_stats(ipc_wwan, ipc_wwan_vlan_to_mux_session_id(tag),
+			      skb->len, false);
+
+	switch (netif_rx_ni(skb)) {
+	case NET_RX_SUCCESS:
+		break;
+	case NET_RX_DROP:
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/* Align SKB to 32bit, if not already aligned */
+static struct sk_buff *ipc_wwan_skb_align(struct iosm_wwan *ipc_wwan,
+					  struct sk_buff *skb)
+{
+	unsigned int offset = (uintptr_t)skb->data & (IPC_WWAN_ALIGN - 1);
+	struct sk_buff *new_skb;
+
+	if (offset == 0)
+		return skb;
+
+	/* Allocate new skb to copy into */
+	new_skb = dev_alloc_skb(skb->len + (IPC_WWAN_ALIGN - 1));
+	if (unlikely(!new_skb)) {
+		dev_err(ipc_wwan->dev, "failed to reallocate skb");
+		goto out;
+	}
+
+	/* Make sure newly allocated skb is aligned */
+	offset = (uintptr_t)new_skb->data & (IPC_WWAN_ALIGN - 1);
+	if (unlikely(offset != 0))
+		skb_reserve(new_skb, IPC_WWAN_ALIGN - offset);
+
+	/* Copy payload */
+	memcpy(new_skb->data, skb->data, skb->len);
+
+	skb_put(new_skb, skb->len);
+out:
+	dev_kfree_skb(skb);
+	return new_skb;
+}
+
+/* Transmit a packet (called by the kernel) */
+static int ipc_wwan_transmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(netdev);
+	bool is_ip = false;
+	int ret = -EINVAL;
+	int header_size;
+	int idx = 0;
+	u16 tag = 0;
+
+	vlan_get_tag(skb, &tag);
+
+	/* If the SKB is of WWAN root device then don't send it to device.
+	 * Free the SKB and then return.
+	 */
+	if (unlikely(tag == WWAN_ROOT_VLAN_TAG))
+		goto exit;
+
+	/* Discard the Ethernet header or VLAN Ethernet header depending
+	 * on the protocol.
+	 */
+	header_size = ipc_wwan_pull_header(skb, &is_ip);
+	if (!header_size)
+		goto exit;
+
+	/* Get the channel number corresponding to VLAN ID */
+	idx = ipc_wwan_get_vlan_devs_nr(ipc_wwan, tag);
+	if (unlikely(idx < 0 || idx >= ipc_wwan->max_devs ||
+		     ipc_wwan->vlan_devs[idx].ch_id < 0))
+		goto exit;
+
+	/* VLAN IDs from 1 to 255 are for IP data
+	 * 257 to 512 are for non-IP data
+	 */
+	if ((tag > 0 && tag < 256)) {
+		if (unlikely(!is_ip)) {
+			ret = -EXDEV;
+			goto exit;
+		}
+	} else if (tag > 256 && tag < 512) {
+		if (unlikely(is_ip)) {
+			ret = -EXDEV;
+			goto exit;
+		}
+
+		/* Align the SKB only for control packets if not aligned. */
+		skb = ipc_wwan_skb_align(ipc_wwan, skb);
+		if (!skb)
+			goto exit;
+	} else {
+		/* Unknown VLAN IDs */
+		ret = -EXDEV;
+		goto exit;
+	}
+
+	/* Send the SKB to device for transmission */
+	ret = imem_sys_wwan_transmit(ipc_wwan->ops_instance, tag,
+				     ipc_wwan->vlan_devs[idx].ch_id, skb);
+
+	/* Return code of zero is success */
+	if (ret == 0) {
+		ret = NETDEV_TX_OK;
+	} else if (ret == -2) {
+		/* Return code -2 is to enable re-enqueue of the skb.
+		 * Re-push the stripped header before returning busy.
+		 */
+		if (unlikely(!skb_push(skb, header_size))) {
+			dev_err(ipc_wwan->dev, "unable to push eth hdr");
+			ret = -EIO;
+			goto exit;
+		}
+
+		ret = NETDEV_TX_BUSY;
+	} else {
+		ret = -EIO;
+		goto exit;
+	}
+
+	return ret;
+
+exit:
+	/* Log any skb drop except for WWAN Root device */
+	if (tag != 0)
+		dev_dbg(ipc_wwan->dev, "skb dropped.VLAN ID: %d, ret: %d", tag,
+			ret);
+
+	dev_kfree_skb_any(skb);
+	return ret;
+}
+
+static int ipc_wwan_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(dev);
+	unsigned long flags = 0;
+
+	if (unlikely(new_mtu < IPC_MEM_MIN_MTU_SIZE ||
+		     new_mtu > IPC_MEM_MAX_MTU_SIZE)) {
+		dev_err(ipc_wwan->dev, "mtu %d out of range %d..%d", new_mtu,
+			IPC_MEM_MIN_MTU_SIZE, IPC_MEM_MAX_MTU_SIZE);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ipc_wwan->lock, flags);
+	dev->mtu = new_mtu;
+	spin_unlock_irqrestore(&ipc_wwan->lock, flags);
+	return 0;
+}
+
+static int ipc_wwan_change_mac_addr(struct net_device *dev, void *sock_addr)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(dev);
+	struct sockaddr *addr = sock_addr;
+	unsigned long flags = 0;
+	int result = 0;
+	u8 *sock_data;
+
+	sock_data = (u8 *)addr->sa_data;
+
+	spin_lock_irqsave(&ipc_wwan->lock, flags);
+
+	if (is_zero_ether_addr(sock_data)) {
+		dev->addr_len = 1;
+		memset(dev->dev_addr, 0, 6);
+		dev_dbg(ipc_wwan->dev, "mac addr set to zero");
+		goto exit;
+	}
+
+	result = eth_mac_addr(dev, sock_addr);
+exit:
+	spin_unlock_irqrestore(&ipc_wwan->lock, flags);
+	return result;
+}
+
+static int ipc_wwan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	if (cmd != SIOCSIFHWADDR ||
+	    !access_ok((void __user *)ifr, sizeof(struct ifreq)) ||
+	    dev->addr_len > sizeof(struct sockaddr))
+		return -EINVAL;
+
+	return ipc_wwan_change_mac_addr(dev, &ifr->ifr_hwaddr);
+}
+
+static struct net_device_stats *ipc_wwan_get_stats(struct net_device *dev)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(dev);
+
+	return &ipc_wwan->stats;
+}
+
+/* validate mac address for wwan devices */
+static int ipc_wwan_eth_validate_addr(struct net_device *netdev)
+{
+	return eth_validate_addr(netdev);
+}
+
+/* return valid TX queue for the mapped VLAN device
+ * for kernel version latest than 4.19.0
+ */
+static u16 ipc_wwan_select_queue(struct net_device *netdev, struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct iosm_wwan *ipc_wwan = netdev_priv(netdev);
+	u16 txqn = 0xFFFF;
+	u16 tag = 0;
+
+	/* get VLAN tag for the current skb
+	 * if the packet is untagged, return the default queue.
+	 */
+	if (vlan_get_tag(skb, &tag) < 0)
+		return WWAN_DEFAULT_TXQ;
+
+	/* TX Queues are allocated as following:
+	 *
+	 * if vlan ID == 0 is used for VLAN root device i.e. WWAN0.
+	 * Assign default TX Queue which is 0.
+	 *
+	 * if vlan ID >= IMEM_WWAN_CTRL_VLAN_ID_START
+	 * && <= IMEM_WWAN_CTRL_VLAN_ID_END then we use default
+	 * TX Queue which is 0.
+	 *
+	 * if vlan ID >= IMEM_WWAN_DATA_VLAN_ID_START
+	 * && <= Max IP devices then allocate separate
+	 * TX Queue to each VLAN ID.
+	 *
+	 * For any other vlan ID return invalid Tx Queue
+	 */
+	if (tag >= IMEM_WWAN_DATA_VLAN_ID_START && tag <= ipc_wwan->max_ip_devs)
+		txqn = tag;
+	else if ((tag >= IMEM_WWAN_CTRL_VLAN_ID_START &&
+		  tag <= IMEM_WWAN_CTRL_VLAN_ID_END) ||
+		 tag == WWAN_ROOT_VLAN_TAG)
+		txqn = WWAN_DEFAULT_TXQ;
+
+	dev_dbg(ipc_wwan->dev, "VLAN tag = %u, TX Queue selected %u", tag,
+		txqn);
+	return txqn;
+}
+
+static const struct net_device_ops ipc_wwandev_ops = {
+	.ndo_open = ipc_wwan_open,
+	.ndo_stop = ipc_wwan_stop,
+	.ndo_start_xmit = ipc_wwan_transmit,
+	.ndo_change_mtu = ipc_wwan_change_mtu,
+	.ndo_validate_addr = ipc_wwan_eth_validate_addr,
+	.ndo_do_ioctl = ipc_wwan_ioctl,
+	.ndo_get_stats = ipc_wwan_get_stats,
+	.ndo_vlan_rx_add_vid = ipc_wwan_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = ipc_wwan_vlan_rx_kill_vid,
+	.ndo_set_mac_address = ipc_wwan_change_mac_addr,
+	.ndo_select_queue = ipc_wwan_select_queue,
+};
+
+void ipc_wwan_update_stats(struct iosm_wwan *ipc_wwan, int id, size_t len,
+			   bool tx)
+{
+	int idx =
+		ipc_wwan_get_vlan_devs_nr(ipc_wwan,
+					  ipc_wwan_mux_session_to_vlan_tag(id));
+
+	if (unlikely(idx < 0 || idx >= ipc_wwan->max_devs)) {
+		dev_err(ipc_wwan->dev, "invalid VLAN device");
+		return;
+	}
+
+	if (tx) {
+		/* Update vlan device tx statistics */
+		ipc_wwan->vlan_devs[idx].stats.tx_packets++;
+		ipc_wwan->vlan_devs[idx].stats.tx_bytes += len;
+		/* Update root device tx statistics */
+		ipc_wwan->stats.tx_packets++;
+		ipc_wwan->stats.tx_bytes += len;
+	} else {
+		/* Update vlan device rx statistics */
+		ipc_wwan->vlan_devs[idx].stats.rx_packets++;
+		ipc_wwan->vlan_devs[idx].stats.rx_bytes += len;
+		/* Update root device rx statistics */
+		ipc_wwan->stats.rx_packets++;
+		ipc_wwan->stats.rx_bytes += len;
+	}
+}
+
+void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int id, bool on)
+{
+	u16 vid = ipc_wwan_mux_session_to_vlan_tag(id);
+
+	dev_dbg(ipc_wwan->dev, "MUX session id[%d]: %s", id,
+		on ? "Enable" : "Disable");
+	if (on)
+		netif_stop_subqueue(ipc_wwan->netdev, vid);
+	else
+		netif_wake_subqueue(ipc_wwan->netdev, vid);
+}
+
+static struct device_type wwan_type = { .name = "wwan" };
+
+struct iosm_wwan *ipc_wwan_init(void *ops_instance, struct device *dev,
+				int max_sessions)
+{
+	int max_tx_q = WWAN_MIN_TXQ + max_sessions;
+	struct iosm_wwan *ipc_wwan;
+	struct net_device *netdev;
+
+	/* allocate ethernet device */
+	netdev = alloc_etherdev_mqs(sizeof(*ipc_wwan), max_tx_q, WWAN_MAX_RXQ);
+
+	if (unlikely(!netdev || !ops_instance))
+		return NULL;
+
+	ipc_wwan = netdev_priv(netdev);
+
+	ipc_wwan->dev = dev;
+	ipc_wwan->netdev = netdev;
+	ipc_wwan->is_registered = false;
+
+	ipc_wwan->vlan_devs_nr = 0;
+	ipc_wwan->ops_instance = ops_instance;
+
+	ipc_wwan->max_devs = max_sessions + IPC_MEM_MAX_CHANNELS;
+	ipc_wwan->max_ip_devs = max_sessions;
+
+	ipc_wwan->vlan_devs = kcalloc(ipc_wwan->max_devs,
+				      sizeof(ipc_wwan->vlan_devs[0]),
+				      GFP_KERNEL);
+
+	spin_lock_init(&ipc_wwan->lock);
+	mutex_init(&ipc_wwan->if_mutex);
+
+	/* allocate random ethernet address */
+	eth_random_addr(netdev->dev_addr);
+	netdev->addr_assign_type = NET_ADDR_RANDOM;
+
+	snprintf(netdev->name, IFNAMSIZ, "%s", "wwan0");
+	netdev->netdev_ops = &ipc_wwandev_ops;
+	netdev->flags |= IFF_NOARP;
+	netdev->features |=
+		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	SET_NETDEV_DEVTYPE(netdev, &wwan_type);
+
+	if (register_netdev(netdev)) {
+		dev_err(ipc_wwan->dev, "register_netdev failed");
+		ipc_wwan_deinit(ipc_wwan);
+		return NULL;
+	}
+
+	ipc_wwan->is_registered = true;
+
+	netif_device_attach(netdev);
+
+	/* Set Max MTU for kernel version latest than 4.10.0. */
+	netdev->max_mtu = IPC_MEM_MAX_MTU_SIZE;
+
+	return ipc_wwan;
+}
+
+void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
+{
+	if (ipc_wwan->is_registered)
+		unregister_netdev(ipc_wwan->netdev);
+	kfree(ipc_wwan->vlan_devs);
+	ipc_wwan->vlan_devs = NULL;
+	free_netdev(ipc_wwan->netdev);
+}
+
+bool ipc_wwan_is_tx_stopped(struct iosm_wwan *ipc_wwan, int id)
+{
+	u16 vid = ipc_wwan_mux_session_to_vlan_tag(id);
+
+	return __netif_subqueue_stopped(ipc_wwan->netdev, vid);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.h b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
new file mode 100644
index 000000000000..3c3b1fb31ae1
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_WWAN_H
+#define IOSM_IPC_WWAN_H
+
+#define IMEM_WWAN_DATA_VLAN_ID_START 1
+#define IMEM_WWAN_CTRL_VLAN_ID_START 257
+#define IMEM_WWAN_CTRL_VLAN_ID_END 512
+
+/**
+ * ipc_wwan_init - Allocate, Init and register WWAN device
+ * @ops_instance:	Instance pointer for callback
+ * @dev:		Pointer to device structure
+ * @max_sessions:	Maximum number of sessions
+ *
+ * Returns: Pointer to instance on success else NULL
+ */
+struct iosm_wwan *ipc_wwan_init(void *ops_instance, struct device *dev,
+				int max_sessions);
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
+ * @dss:	Set to true if vlan id is greater than
+ *		IMEM_WWAN_CTRL_VLAN_ID_START else false
+ *
+ * Return: 0 on success else error code
+ */
+int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
+		     bool dss);
+
+/**
+ * ipc_wwan_update_stats - Update device statistics
+ * @ipc_wwan:	Pointer to wwan instance
+ * @id:		Ipc mux channel session id
+ * @len:	Number of bytes to update
+ * @tx:		True if statistics needs to be updated for transmit
+ *		else false
+ *
+ */
+void ipc_wwan_update_stats(struct iosm_wwan *ipc_wwan, int id, size_t len,
+			   bool tx);
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
+ * ipc_wwan_is_tx_stopped - Checks if Tx stopped for a VLAN id.
+ * @ipc_wwan:	Pointer to wwan instance
+ * @id:		Ipc mux channel session id
+ *
+ * Return: true if stopped, false otherwise
+ */
+bool ipc_wwan_is_tx_stopped(struct iosm_wwan *ipc_wwan, int id);
+
+#endif
-- 
2.12.3

