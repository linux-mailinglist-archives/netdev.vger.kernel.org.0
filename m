Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108E03194E6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBKVL4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 16:11:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9177 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBKVLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:11:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60259d6d0002>; Thu, 11 Feb 2021 13:11:09 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 21:11:02 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 21:10:57 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v4 net-next  02/21] net: Introduce crc offload for tcp ddp ulp
Date:   Thu, 11 Feb 2021 23:10:25 +0200
Message-ID: <20210211211044.32701-3-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces support for CRC offload to direct data placement
ULP on the receive side. Both DDP and CRC share a common API to
initialize the offload for a TCP socket. But otherwise, both can
be executed independently.

On the receive side, CRC offload relies on a new SKB bit that
indicates that no CRC error was encountered while processing this packet.
If all packets of a ULP message have this bit set, then the CRC
verification for the message can be skipped, as hardware already checked
it.

The following patches will set and use this bit to perform NVME-TCP
CRC offload.

A subsequent series, will add NVMe-TCP transmit side CRC support.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 include/linux/netdev_features.h | 2 ++
 include/linux/netdevice.h       | 2 +-
 include/linux/skbuff.h          | 2 +-
 net/Kconfig                     | 8 ++++++++
 net/ethtool/common.c            | 1 +
 net/ipv4/tcp_input.c            | 4 ++--
 net/ipv4/tcp_ipv4.c             | 2 +-
 net/ipv4/tcp_offload.c          | 2 +-
 8 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7977371d2dd1..77fb2cb99b78 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -86,6 +86,7 @@ enum {
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
 	NETIF_F_GRO_UDP_FWD_BIT,	/* Allow UDP GRO for forwarding */
 	NETIF_F_HW_TCP_DDP_BIT,		/* TCP direct data placement offload */
+	NETIF_F_HW_TCP_DDP_CRC_RX_BIT,	/* TCP DDP CRC RX offload */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -161,6 +162,7 @@ enum {
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 #define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
 #define NETIF_F_HW_TCP_DDP	__NETIF_F(HW_TCP_DDP)
+#define NETIF_F_HW_TCP_DDP_CRC_RX	__NETIF_F(HW_TCP_DDP_CRC_RX)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bd28520e30f2..1065ddaa8e6b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1943,7 +1943,7 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
-#ifdef CONFIG_TCP_DDP
+#if IS_ENABLED(CONFIG_TCP_DDP) || IS_ENABLED(CONFIG_TCP_DDP_CRC)
 	const struct tcp_ddp_dev_ops *tcp_ddp_ops;
 #endif
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c7c88b2d0d47..0d1be25574cc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -861,7 +861,7 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
-#ifdef CONFIG_TCP_DDP
+#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
 	__u8                    ddp_crc:1;
 #endif
 
diff --git a/net/Kconfig b/net/Kconfig
index 3876861cdc90..80ed9f038968 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -465,6 +465,14 @@ config TCP_DDP
 	  NVMe-TCP/iSCSI, to request the NIC to place TCP payload data
 	  of a command response directly into kernel pages.
 
+config TCP_DDP_CRC
+	bool "TCP direct data placement CRC offload"
+	default n
+	help
+	  Direct Data Placement (DDP) CRC32C offload for TCP enables ULP, such as
+	  NVMe-TCP/iSCSI, to request the NIC to calculate/verify the data digest
+	  of commands as they go through the NIC. Thus avoiding the costly
+	  per-byte overhead.
 
 endif   # if NET
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 2878a5613e72..7ac78b0a90b0 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -70,6 +70,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 	[NETIF_F_GRO_UDP_FWD_BIT] =	 "rx-udp-gro-forwarding",
 	[NETIF_F_HW_TCP_DDP_BIT] =	 "tcp-ddp-offload",
+	[NETIF_F_HW_TCP_DDP_CRC_RX_BIT] =	 "tcp-ddp-crc-rx-offload",
 };
 
 const char
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0ae1ffca090d..cd490bd548a3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5150,7 +5150,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 		nskb->decrypted = skb->decrypted;
 #endif
-#ifdef CONFIG_TCP_DDP
+#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
 		nskb->ddp_crc = skb->ddp_crc;
 #endif
 		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
@@ -5186,7 +5186,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
 #endif
-#ifdef CONFIG_TCP_DDP
+#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
 
 				if (skb->ddp_crc != nskb->ddp_crc)
 					goto end;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 676bc1584356..8750646f8621 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1814,7 +1814,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
 #endif
-#ifdef CONFIG_TCP_DDP
+#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
 	    tail->ddp_crc != skb->ddp_crc ||
 #endif
 	    thtail->doff != th->doff ||
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 3ce196375d94..9e43a044e730 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -262,7 +262,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
-#ifdef CONFIG_TCP_DDP
+#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
 	flush |= p->ddp_crc ^ skb->ddp_crc;
 #endif
 
-- 
2.24.1

