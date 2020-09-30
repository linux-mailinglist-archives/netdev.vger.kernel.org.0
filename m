Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7528227EEF2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgI3QUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50458 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731299AbgI3QUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:27 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2D032498;
        Wed, 30 Sep 2020 19:20:27 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 02/10] net: Introduce direct data placement tcp offload
Date:   Wed, 30 Sep 2020 19:20:02 +0300
Message-Id: <20200930162010.21610-3-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces direct data placement offload for TCP.
This capability is accompanied by new net_device operations that
configure
hardware contexts. There is a context per socket, and a context per DDP
opreation. Additionally, a resynchronization routine is used to assist
hardware handle TCP OOO, and continue the offload.
Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments.

Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

This, the SKB represents the data on the wire, while it is pointing
to data that is already placed in the destination buffer.
As a result, data from page frags should not be copied out to
the linear part.

As SKBs that use DDP are already very memory efficient, we modify
skb_condence to avoid copying data from fragments to the linear
part of SKBs that belong to a socket that uses DDP offload.

A follow-up patch will use this interface for DDP in NVMe-TCP.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/netdev_features.h    |  2 +
 include/linux/netdevice.h          |  5 ++
 include/net/inet_connection_sock.h |  4 ++
 include/net/tcp_ddp.h              | 90 ++++++++++++++++++++++++++++++
 net/Kconfig                        |  9 +++
 net/core/skbuff.c                  |  9 ++-
 net/ethtool/common.c               |  1 +
 7 files changed, 119 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tcp_ddp.h

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 0b17c4322b09..a0074b244372 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -84,6 +84,7 @@ enum {
 	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
+	NETIF_F_HW_TCP_DDP_BIT,		/* TCP direct data placement offload */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -157,6 +158,7 @@ enum {
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
+#define NETIF_F_HW_TCP_DDP	__NETIF_F(HW_TCP_DDP)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a431c3229cbf..b00e1663724b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -935,6 +935,7 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct tcp_ddp_dev_ops;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
@@ -1922,6 +1923,10 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
+#ifdef CONFIG_TCP_DDP
+	const struct tcp_ddp_dev_ops *tcp_ddp_ops;
+#endif
+
 	const struct header_ops *header_ops;
 
 	unsigned int		flags;
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index dc763ca9413c..503092d8860d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ulp_ops	   Pluggable ULP control hook
  * @icsk_ulp_data	   ULP private data
  * @icsk_clean_acked	   Clean acked data hook
+ * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
+ * @icsk_ulp_ddp_data	   ULP direct data placement private data
  * @icsk_listen_portaddr_node	hash to the portaddr listener hashtable
  * @icsk_ca_state:	   Congestion control state
  * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
@@ -94,6 +96,8 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
+	const struct tcp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
+	void __rcu		  *icsk_ulp_ddp_data;
 	struct hlist_node         icsk_listen_portaddr_node;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
diff --git a/include/net/tcp_ddp.h b/include/net/tcp_ddp.h
new file mode 100644
index 000000000000..4c0d9660b039
--- /dev/null
+++ b/include/net/tcp_ddp.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * tcp_ddp.h
+ *	Author:	Boris Pismenny <borisp@mellanox.com>
+ *	Copyright (C) 2020 Mellanox Technologies.
+ */
+#ifndef _TCP_DDP_H
+#define _TCP_DDP_H
+
+#include <linux/blkdev.h>
+#include <linux/netdevice.h>
+#include <net/inet_connection_sock.h>
+#include <net/sock.h>
+
+/* limits returned by the offload driver, zero means don't care */
+struct tcp_ddp_limits {
+	int	 max_ddp_sgl_len;
+};
+
+enum tcp_ddp_type {
+	TCP_DDP_NVME = 1,
+};
+
+struct tcp_ddp_config {
+	enum tcp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+struct nvme_tcp_config {
+	struct tcp_ddp_config   cfg;
+
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+};
+
+struct tcp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+struct tcp_ddp_dev_ops {
+	int (*tcp_ddp_limits)(struct net_device *netdev,
+			      struct tcp_ddp_limits *limits);
+	int (*tcp_ddp_sk_add)(struct net_device *netdev,
+			      struct sock *sk,
+			      struct tcp_ddp_config *config);
+	void (*tcp_ddp_sk_del)(struct net_device *netdev,
+			       struct sock *sk);
+	int (*tcp_ddp_setup)(struct net_device *netdev,
+			     struct sock *sk,
+			     struct tcp_ddp_io *io);
+	int (*tcp_ddp_teardown)(struct net_device *netdev,
+				struct sock *sk,
+				struct tcp_ddp_io *io,
+				void *ddp_ctx);
+	void (*tcp_ddp_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq);
+};
+
+#define TCP_DDP_RESYNC_REQ (1 << 0)
+
+/*
+ * Interface to register uppper layer Direct Data Placement (DDP) TCP offload
+ */
+struct tcp_ddp_ulp_ops {
+	/* NIC requests ulp to indicate if @seq is the start of a message */
+	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+	/* NIC driver informs the ulp that ddp teardown is done */
+	void (*ddp_teardown_done)(void *ddp_ctx);
+};
+
+struct tcp_ddp_ctx {
+	enum tcp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+static inline struct tcp_ddp_ctx *tcp_ddp_get_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (__force struct tcp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
+}
+
+#endif //_TCP_DDP_H
diff --git a/net/Kconfig b/net/Kconfig
index 3831206977a1..346e9fa7a6ec 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -460,6 +460,15 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config TCP_DDP
+	bool "TCP direct data placement offload"
+	default n
+	help
+	  Direct Data Placement (DDP) offload for TCP enables ULP, such as
+	  NVMe-TCP/iSCSI, to request the NIC to place TCP payload data
+	  of a command response directly into kernel pages.
+
+
 endif   # if NET
 
 # Used by archs to tell that they support BPF JIT compiler plus which flavour.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e0774471f56d..ad32985876da 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/tcp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6059,9 +6060,15 @@ EXPORT_SYMBOL(pskb_extract);
  */
 void skb_condense(struct sk_buff *skb)
 {
+	bool is_ddp = false;
+
+#ifdef CONFIG_TCP_DDP
+	is_ddp = skb->sk && inet_csk(skb->sk) &&
+		 inet_csk(skb->sk)->icsk_ulp_ddp_data;
+#endif
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || is_ddp)
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..a2ff7a4a6bbf 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
+	[NETIF_F_HW_TCP_DDP_BIT] =	 "tcp-ddp-offload",
 };
 
 const char
-- 
2.24.1

