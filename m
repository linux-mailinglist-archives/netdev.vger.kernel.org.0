Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD882795B9
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgIZA46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgIZA44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:56 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F071F2083B;
        Sat, 26 Sep 2020 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081816;
        bh=DFIDqiexvuNHOhukzCUgyi3jJ9Zxibbo4Yl+Eww7NgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0E4aKDHtedN7prfdMt9cR6/UkudSWH1b8Rj7vEcXJ6LrJq4VfZEiAlXrKqj5HMUQi
         gNM4wGKAhDK+PgPBPXwGOmL3SYmqj0PfJL0l5Of3VE7qnWQBbuF+SWvEhRs+gEP2wW
         jzS6t0P42qp4snHVITzDcbNC8Oz+rmi4Oy8u9ouY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 01/10] udp_tunnel: add the ability to share port tables
Date:   Fri, 25 Sep 2020 17:56:40 -0700
Message-Id: <20200926005649.3285089-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately recent Intel NIC designs share the UDP port table
across netdevs. So far the UDP tunnel port state was maintained
per netdev, we need to extend that to cater to Intel NICs.

Expect NICs to allocate the info structure dynamically and link
to the state from there. All the shared NICs will record port
offload information in the one instance of the table so we need
to make sure that the use count can accommodate larger numbers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/udp_tunnel.h  | 24 ++++++++++
 net/ipv4/udp_tunnel_nic.c | 96 +++++++++++++++++++++++++++++++++++----
 2 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 94bb7a882250..2ea453dac876 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -200,11 +200,27 @@ enum udp_tunnel_nic_info_flags {
 	UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN	= BIT(3),
 };
 
+struct udp_tunnel_nic;
+
+#define UDP_TUNNEL_NIC_MAX_SHARING_DEVICES	(U16_MAX / 2)
+
+struct udp_tunnel_nic_shared {
+	struct udp_tunnel_nic *udp_tunnel_nic_info;
+
+	struct list_head devices;
+};
+
+struct udp_tunnel_nic_shared_node {
+	struct net_device *dev;
+	struct list_head list;
+};
+
 /**
  * struct udp_tunnel_nic_info - driver UDP tunnel offload information
  * @set_port:	callback for adding a new port
  * @unset_port:	callback for removing a port
  * @sync_table:	callback for syncing the entire port table at once
+ * @shared:	reference to device global state (optional)
  * @flags:	device flags from enum udp_tunnel_nic_info_flags
  * @tables:	UDP port tables this device has
  * @tables.n_entries:		number of entries in this table
@@ -213,6 +229,12 @@ enum udp_tunnel_nic_info_flags {
  * Drivers are expected to provide either @set_port and @unset_port callbacks
  * or the @sync_table callback. Callbacks are invoked with rtnl lock held.
  *
+ * Devices which (misguidedly) share the UDP tunnel port table across multiple
+ * netdevs should allocate an instance of struct udp_tunnel_nic_shared and
+ * point @shared at it.
+ * There must never be more than %UDP_TUNNEL_NIC_MAX_SHARING_DEVICES devices
+ * sharing a table.
+ *
  * Known limitations:
  *  - UDP tunnel port notifications are fundamentally best-effort -
  *    it is likely the driver will both see skbs which use a UDP tunnel port,
@@ -234,6 +256,8 @@ struct udp_tunnel_nic_info {
 	/* all at once */
 	int (*sync_table)(struct net_device *dev, unsigned int table);
 
+	struct udp_tunnel_nic_shared *shared;
+
 	unsigned int flags;
 
 	struct udp_tunnel_nic_table_info {
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 69962165c0e8..0d122edc368d 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -19,8 +19,9 @@ enum udp_tunnel_nic_table_entry_flags {
 struct udp_tunnel_nic_table_entry {
 	__be16 port;
 	u8 type;
-	u8 use_cnt;
 	u8 flags;
+	u16 use_cnt;
+#define UDP_TUNNEL_NIC_USE_CNT_MAX	U16_MAX
 	u8 hw_priv;
 };
 
@@ -370,6 +371,8 @@ udp_tunnel_nic_entry_adj(struct udp_tunnel_nic *utn,
 	bool dodgy = entry->flags & UDP_TUNNEL_NIC_ENTRY_OP_FAIL;
 	unsigned int from, to;
 
+	WARN_ON(entry->use_cnt + (u32)use_cnt_adj > U16_MAX);
+
 	/* If not going from used to unused or vice versa - all done.
 	 * For dodgy entries make sure we try to sync again (queue the entry).
 	 */
@@ -675,6 +678,7 @@ static void
 udp_tunnel_nic_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
 {
 	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic_shared_node *node;
 	unsigned int i, j;
 
 	/* Freeze all the ports we are already tracking so that the replay
@@ -686,7 +690,12 @@ udp_tunnel_nic_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
 	utn->missed = 0;
 	utn->need_replay = 0;
 
-	udp_tunnel_get_rx_info(dev);
+	if (!info->shared) {
+		udp_tunnel_get_rx_info(dev);
+	} else {
+		list_for_each_entry(node, &info->shared->devices, list)
+			udp_tunnel_get_rx_info(node->dev);
+	}
 
 	for (i = 0; i < utn->n_tables; i++)
 		for (j = 0; j < info->tables[i].n_entries; j++)
@@ -742,20 +751,39 @@ udp_tunnel_nic_alloc(const struct udp_tunnel_nic_info *info,
 	return NULL;
 }
 
+static void udp_tunnel_nic_free(struct udp_tunnel_nic *utn)
+{
+	unsigned int i;
+
+	for (i = 0; i < utn->n_tables; i++)
+		kfree(utn->entries[i]);
+	kfree(utn->entries);
+	kfree(utn);
+}
+
 static int udp_tunnel_nic_register(struct net_device *dev)
 {
 	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic_shared_node *node = NULL;
 	struct udp_tunnel_nic *utn;
 	unsigned int n_tables, i;
 
 	BUILD_BUG_ON(sizeof(utn->missed) * BITS_PER_BYTE <
 		     UDP_TUNNEL_NIC_MAX_TABLES);
+	/* Expect use count of at most 2 (IPv4, IPv6) per device */
+	BUILD_BUG_ON(UDP_TUNNEL_NIC_USE_CNT_MAX <
+		     UDP_TUNNEL_NIC_MAX_SHARING_DEVICES * 2);
 
+	/* Check that the driver info is sane */
 	if (WARN_ON(!info->set_port != !info->unset_port) ||
 	    WARN_ON(!info->set_port == !info->sync_table) ||
 	    WARN_ON(!info->tables[0].n_entries))
 		return -EINVAL;
 
+	if (WARN_ON(info->shared &&
+		    info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY))
+		return -EINVAL;
+
 	n_tables = 1;
 	for (i = 1; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
 		if (!info->tables[i].n_entries)
@@ -766,9 +794,33 @@ static int udp_tunnel_nic_register(struct net_device *dev)
 			return -EINVAL;
 	}
 
-	utn = udp_tunnel_nic_alloc(info, n_tables);
-	if (!utn)
-		return -ENOMEM;
+	/* Create UDP tunnel state structures */
+	if (info->shared) {
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			return -ENOMEM;
+
+		node->dev = dev;
+	}
+
+	if (info->shared && info->shared->udp_tunnel_nic_info) {
+		utn = info->shared->udp_tunnel_nic_info;
+	} else {
+		utn = udp_tunnel_nic_alloc(info, n_tables);
+		if (!utn) {
+			kfree(node);
+			return -ENOMEM;
+		}
+	}
+
+	if (info->shared) {
+		if (!info->shared->udp_tunnel_nic_info) {
+			INIT_LIST_HEAD(&info->shared->devices);
+			info->shared->udp_tunnel_nic_info = utn;
+		}
+
+		list_add_tail(&node->list, &info->shared->devices);
+	}
 
 	utn->dev = dev;
 	dev_hold(dev);
@@ -783,7 +835,33 @@ static int udp_tunnel_nic_register(struct net_device *dev)
 static void
 udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 {
-	unsigned int i;
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+
+	/* For a shared table remove this dev from the list of sharing devices
+	 * and if there are other devices just detach.
+	 */
+	if (info->shared) {
+		struct udp_tunnel_nic_shared_node *node, *first;
+
+		list_for_each_entry(node, &info->shared->devices, list)
+			if (node->dev == dev)
+				break;
+		if (node->dev != dev)
+			return;
+
+		list_del(&node->list);
+		kfree(node);
+
+		first = list_first_entry_or_null(&info->shared->devices,
+						 typeof(*first), list);
+		if (first) {
+			udp_tunnel_drop_rx_info(dev);
+			utn->dev = first->dev;
+			goto release_dev;
+		}
+
+		info->shared->udp_tunnel_nic_info = NULL;
+	}
 
 	/* Flush before we check work, so we don't waste time adding entries
 	 * from the work which we will boot immediately.
@@ -796,10 +874,8 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 	if (utn->work_pending)
 		return;
 
-	for (i = 0; i < utn->n_tables; i++)
-		kfree(utn->entries[i]);
-	kfree(utn->entries);
-	kfree(utn);
+	udp_tunnel_nic_free(utn);
+release_dev:
 	dev->udp_tunnel_nic = NULL;
 	dev_put(dev);
 }
-- 
2.26.2

