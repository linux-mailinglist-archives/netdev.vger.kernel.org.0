Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16330A506
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhBAKJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:09:30 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59723 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232959AbhBAKIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:08:18 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:13 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5Cxt029353;
        Mon, 1 Feb 2021 12:05:13 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v3 net-next  02/21] net: Introduce direct data placement tcp offload
Date:   Mon,  1 Feb 2021 12:04:50 +0200
Message-Id: <20210201100509.27351-3-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces direct data placement offload for TCP.
This capability is accompanied by new net_device operations that
configure hardware contexts. There is a context per socket, and a context per DDP
opreation. Additionally, a resynchronization routine is used to assist
hardware handle TCP OOO, and continue the offload.
Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments.

Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

The SKB passed to the network stack from the driver
represents data as it is on the wire, while it is pointing
directly to data in destination buffers.
As a result, data from page frags should not be copied out to
the linear part. To avoid needless copies, such as when using
skb_condense, we mark the skb->ddp_crc bit. This bit will be
used to indicate both ddp and crc offload (next patch in series).

A follow-up patch will use this interface for DDP in NVMe-TCP.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/netdev_features.h    |   2 +
 include/linux/netdevice.h          |   5 ++
 include/linux/skbuff.h             |   4 +
 include/net/inet_connection_sock.h |   4 +
 include/net/tcp_ddp.h              | 136 +++++++++++++++++++++++++++++
 net/Kconfig                        |   9 ++
 net/core/skbuff.c                  |   8 +-
 net/ethtool/common.c               |   1 +
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 11 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tcp_ddp.h

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index c06d6aaba9df..7977371d2dd1 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -85,6 +85,7 @@ enum {
 
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
 	NETIF_F_GRO_UDP_FWD_BIT,	/* Allow UDP GRO for forwarding */
+	NETIF_F_HW_TCP_DDP_BIT,		/* TCP direct data placement offload */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -159,6 +160,7 @@ enum {
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 #define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
+#define NETIF_F_HW_TCP_DDP	__NETIF_F(HW_TCP_DDP)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9e7ada07ea1..bd28520e30f2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -941,6 +941,7 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct tcp_ddp_dev_ops;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
@@ -1942,6 +1943,10 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
+#ifdef CONFIG_TCP_DDP
+	const struct tcp_ddp_dev_ops *tcp_ddp_ops;
+#endif
+
 	const struct header_ops *header_ops;
 
 	unsigned char		operstate;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..6d00d62628c8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -684,6 +684,7 @@ typedef unsigned char *sk_buff_data_t;
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
+ *	@ddp_crc: DDP or CRC offloaded
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -860,6 +861,9 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
+#ifdef CONFIG_TCP_DDP
+	__u8                    ddp_crc:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c11f80f328f1..f9eb28f14d43 100644
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
@@ -96,6 +98,8 @@ struct inet_connection_sock {
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
index 000000000000..31e5b1a16d0f
--- /dev/null
+++ b/include/net/tcp_ddp.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * tcp_ddp.h
+ *	Author:	Boris Pismenny <borisp@mellanox.com>
+ *	Copyright (C) 2021 Mellanox Technologies.
+ */
+#ifndef _TCP_DDP_H
+#define _TCP_DDP_H
+
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
+/**
+ * struct tcp_ddp_config - Generic tcp ddp configuration: tcp ddp IO queue
+ * config implementations must use this as the first member.
+ * Add new instances of tcp_ddp_config below (nvme-tcp, etc.).
+ */
+struct tcp_ddp_config {
+	enum tcp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+ *
+ * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
+ * @cpda:       controller pdu data alignmend (dwords, 0's based)
+ * @dgst:       digest types enabled.
+ *              The netdev will offload crc if ddp_crc is supported.
+ * @queue_size: number of nvme-tcp IO queue elements
+ * @queue_id:   queue identifier
+ * @cpu_io:     cpu core running the IO thread for this queue
+ */
+struct nvme_tcp_ddp_config {
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
+/**
+ * struct tcp_ddp_io - tcp ddp configuration for an IO request.
+ *
+ * @command_id:  identifier on the wire associated with these buffers
+ * @nents:       number of entries in the sg_table
+ * @sg_table:    describing the buffers for this IO request
+ * @first_sgl:   first SGL in sg_table
+ */
+struct tcp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+/* struct tcp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
+ *
+ * @tcp_ddp_limits:    limit the number of scatter gather entries per IO.
+ *                     the device driver can use this to limit the resources allocated per queue.
+ * @tcp_ddp_sk_add:    add offload for the queue represennted by the socket+config pair.
+ *                     this function is used to configure either copy, crc or both offloads.
+ * @tcp_ddp_sk_del:    remove offload from the socket, and release any device related resources.
+ * @tcp_ddp_setup:     request copy offload for buffers associated with a command_id in tcp_ddp_io.
+ * @tcp_ddp_teardown:  release offload resources association between buffers and command_id in
+ *                     tcp_ddp_io.
+ * @tcp_ddp_resync:    respond to the driver's resync_request. Called only if resync is successful.
+ */
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
+#define TCP_DDP_RESYNC_REQ BIT(0)
+
+/**
+ * struct tcp_ddp_ulp_ops - Interface to register uppper layer Direct Data Placement (DDP) TCP offload
+ */
+struct tcp_ddp_ulp_ops {
+	/* NIC requests ulp to indicate if @seq is the start of a message */
+	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
+	void (*ddp_teardown_done)(void *ddp_ctx);
+};
+
+/**
+ * struct tcp_ddp_ctx - Generic tcp ddp context: device driver per queue contexts must
+ * use this as the first member.
+ */
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
+static inline void tcp_ddp_set_ctx(struct sock *sk, void *ctx)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
+}
+
+#endif //_TCP_DDP_H
diff --git a/net/Kconfig b/net/Kconfig
index f4c32d982af6..3876861cdc90 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -457,6 +457,15 @@ config ETHTOOL_NETLINK
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
index 2af12f7e170c..ef3f2714994d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/tcp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6185,9 +6186,14 @@ EXPORT_SYMBOL(pskb_extract);
  */
 void skb_condense(struct sk_buff *skb)
 {
+	bool is_ddp = false;
+
+#ifdef CONFIG_TCP_DDP
+	is_ddp = skb->ddp_crc;
+#endif
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || is_ddp)
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 181220101a6e..bbf83cd01106 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -69,6 +69,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 	[NETIF_F_GRO_UDP_FWD_BIT] =	 "rx-udp-gro-forwarding",
+	[NETIF_F_HW_TCP_DDP_BIT] =	 "tcp-ddp-offload",
 };
 
 const char
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a8f8f9815953..0ae1ffca090d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
 #ifdef CONFIG_TLS_DEVICE
 		nskb->decrypted = skb->decrypted;
+#endif
+#ifdef CONFIG_TCP_DDP
+		nskb->ddp_crc = skb->ddp_crc;
 #endif
 		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
 		if (list)
@@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
+#endif
+#ifdef CONFIG_TCP_DDP
+
+				if (skb->ddp_crc != nskb->ddp_crc)
+					goto end;
 #endif
 			}
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 777306b5bc22..b114fc870513 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1810,6 +1810,9 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
+#endif
+#ifdef CONFIG_TCP_DDP
+	    tail->ddp_crc != skb->ddp_crc ||
 #endif
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index e09147ac9a99..3ce196375d94 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -262,6 +262,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
+#ifdef CONFIG_TCP_DDP
+	flush |= p->ddp_crc ^ skb->ddp_crc;
+#endif
 
 	if (flush || skb_gro_receive(p, skb)) {
 		mss = 1;
-- 
2.24.1

