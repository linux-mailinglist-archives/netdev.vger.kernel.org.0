Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DCE2BAA7C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgKTMtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 07:49:49 -0500
Received: from correo.us.es ([193.147.175.20]:37976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgKTMtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 07:49:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD44A18CE91
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 13:49:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF04DFC5E0
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 13:49:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A0515FC5EB; Fri, 20 Nov 2020 13:49:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B28DFC5F5;
        Fri, 20 Nov 2020 13:49:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Nov 2020 13:49:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 125EB4265A5A;
        Fri, 20 Nov 2020 13:49:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        fw@strlen.de, razor@blackwall.org, jeremy@azazel.net,
        tobias@waldekranz.com
Subject: [PATCH net-next,v5 3/9] net: resolve forwarding path from virtual netdevice and HW destination address
Date:   Fri, 20 Nov 2020 13:49:15 +0100
Message-Id: <20201120124921.32172-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120124921.32172-1-pablo@netfilter.org>
References: <20201120124921.32172-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds dev_fill_forward_path() which resolves the path to reach
the real netdevice from the IP forwarding side. This function takes as
input the netdevice and the destination hardware address and it walks
down the devices calling .ndo_fill_forward_path() for each device until
the real device is found.

For instance, assuming the following topology:

               IP forwarding
              /             \
           br0              eth0
           / \
       eth1  eth2
        .
        .
        .
       ethX
 ab:cd:ef:ab:cd:ef

where eth1 and eth2 are bridge ports and eth0 provides WAN connectivity.
ethX is the interface in another box which is connected to the eth1
bridge port.

For packets going through IP forwarding to br0 whose destination MAC
address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
following path:

	br0 -> eth1

.ndo_fill_forward_path for br0 looks up at the FDB for the bridge port
from the destination MAC address to get the bridge port eth1.

This information allows to create a fast path that bypasses the classic
bridge and IP forwarding paths, so packets go directly from the bridge
port eth1 to eth0 (wan interface) and vice versa.

             fast path
      .------------------------.
     /                          \
    |           IP forwarding   |
    |          /             \  \/
    |       br0               eth0
    .       / \
     -> eth1  eth2
        .
        .
        .
       ethX
 ab:cd:ef:ab:cd:ef

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: Fix possible off-by-one path stack access, per Florian Westphal.

 include/linux/netdevice.h | 27 +++++++++++++++++++++++
 net/core/dev.c            | 46 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 03433a4c929e..ef4fc0eefee0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -833,6 +833,27 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct net_device *sb_dev);
 
+enum net_device_path_type {
+	DEV_PATH_ETHERNET = 0,
+};
+
+struct net_device_path {
+	enum net_device_path_type	type;
+	const struct net_device		*dev;
+};
+
+#define NET_DEVICE_PATH_STACK_MAX	5
+
+struct net_device_path_stack {
+	int			num_paths;
+	struct net_device_path	path[NET_DEVICE_PATH_STACK_MAX];
+};
+
+struct net_device_path_ctx {
+	const struct net_device *dev;
+	const u8		*daddr;
+};
+
 enum tc_setup_type {
 	TC_SETUP_QDISC_MQPRIO,
 	TC_SETUP_CLSU32,
@@ -1279,6 +1300,8 @@ struct netdev_net_notifier {
  * struct net_device *(*ndo_get_peer_dev)(struct net_device *dev);
  *	If a device is paired with a peer device, return the peer instance.
  *	The caller must be under RCU read context.
+ * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
+ *	Get the forwarding path to reach the real device from the HW destination address
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1487,6 +1510,8 @@ struct net_device_ops {
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
 	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
+	int			(*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
+							 struct net_device_path *path);
 };
 
 /**
@@ -2824,6 +2849,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 				      unsigned short mask);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4bfdcd6b20e8..3bbc68f76902 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -846,6 +846,52 @@ int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
+static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
+{
+	int k = stack->num_paths++;
+
+	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+		return NULL;
+
+	return &stack->path[k];
+}
+
+int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+			  struct net_device_path_stack *stack)
+{
+	const struct net_device *last_dev;
+	struct net_device_path_ctx ctx = {
+		.dev	= dev,
+		.daddr	= daddr,
+	};
+	struct net_device_path *path;
+	int ret = 0;
+
+	stack->num_paths = 0;
+	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
+		last_dev = ctx.dev;
+		path = dev_fwd_path(stack);
+		if (!path)
+			return -1;
+
+		memset(path, 0, sizeof(struct net_device_path));
+		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
+		if (ret < 0)
+			return -1;
+
+		if (WARN_ON_ONCE(last_dev == ctx.dev))
+			return -1;
+	}
+	path = dev_fwd_path(stack);
+	if (!path)
+		return -1;
+	path->type = DEV_PATH_ETHERNET;
+	path->dev = ctx.dev;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dev_fill_forward_path);
+
 /**
  *	__dev_get_by_name	- find a device by its name
  *	@net: the applicable net namespace
-- 
2.20.1

