Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845E30A511
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhBAKKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:10:31 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59722 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232981AbhBAKGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:13 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5Cxu029353;
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
Subject: [PATCH v3 net-next  03/21] net: Introduce crc offload for tcp ddp ulp
Date:   Mon,  1 Feb 2021 12:04:51 +0200
Message-Id: <20210201100509.27351-4-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 6d00d62628c8..32c5ab8e2f67 100644
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
index bbf83cd01106..14286afb2a69 100644
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
index b114fc870513..4c903c1a6c90 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1811,7 +1811,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
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

