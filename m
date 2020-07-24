Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65922CF49
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgGXUOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXUOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:14:36 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA33C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:35 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so5989440pgc.8
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xc9uxRUdicJvSdy2UdxgQ2yDx2z4NwGshiuViKCiNxM=;
        b=evumzRTXaFKvX3H9fFvvw4bpuuUMzUPYaDTd4wl0rOAnUg591A0n0OkCwuoYl7LtU8
         ypymYCL8TNUpYtiasxdXMTow70tLMWVQCW7UVUnPUlG5YDxvN9NteczFToHh9C5mot//
         rCKHB74aawS6KFaIK41r0lZANDPJ098OJbxKdFIxqVnZSGbvtmeEIMK3ZyfQVv/oX9MQ
         CYXUaveHvxKhl+hBmbJAXUGgWEpr5KwfSW6RQvUuQKPnlDMKPfe82NjRuGJVRDG1Ar1+
         XJCjk37guWf79PvYILKcQysl4dFMPaR3923LmfryEFEVOSVJkUBTHX7fmrzDYtPrlnnP
         A2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xc9uxRUdicJvSdy2UdxgQ2yDx2z4NwGshiuViKCiNxM=;
        b=FeL4MpTPDCuO8JdcC+55O61eVW7TbF41f4YctoGjeWul16qgDGUIlHo7gTh0Cm+LJI
         TOFRKZ50X0IV8PPui6niHsTDQQtgKIxydVzted/PH2XAU86RJjBxnF6EzSSQbJwVu18l
         C84LlmS+QSZguUiPUiODJh0X+Hq0DnCAEjBtiy3G6Y9tyC8GFvacBoQZ/I28VpczgihE
         HDzlVuVEVH1ynQhR5GAju+D2/e5hUXIM9W6i7tps013QOiHAi5BS+bj11mTjIy/CP/b9
         +L4U3TDHbs0gG8+ydUHouOVgau/W+L+Dcj4u/bkJ5p0WVUfgnFoIEZUsQMVYdMVL+VLw
         M7/g==
X-Gm-Message-State: AOAM532XHWjG8lfY7dJsg4JqyRdMlCXSTAaTgdKGEsinEYObPzeRS7Gt
        CebD22PEDADR+Lz/DpJdQyxKv8lkwIU=
X-Google-Smtp-Source: ABdhPJwZCDzw9EmMDXkH32EIAzoOjwYolbiciEaiiusSySl0I/q+67KkTla2wwF83bWNYSIHwo9kQg==
X-Received: by 2002:a05:6a00:92:: with SMTP id c18mr10191339pfj.313.1595621674879;
        Fri, 24 Jul 2020 13:14:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id ci23sm6496539pjb.29.2020.07.24.13.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 13:14:34 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, amritha.nambiar@intel.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 3/3] sock: Use dev_and_queue structure for RX queue mapping in sock
Date:   Fri, 24 Jul 2020 13:14:12 -0700
Message-Id: <20200724201412.599398-4-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724201412.599398-1-tom@herbertland.com>
References: <20200724201412.599398-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sk_rx_queue_mapping with sk_rx_dev_and_queue_mapping and
change associated function to set, get, and clear mapping.
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 10 +++--
 include/net/busy_poll.h                       |  2 +-
 include/net/sock.h                            | 38 +++++++++----------
 net/core/dev.c                                |  7 +++-
 net/core/filter.c                             |  7 ++--
 net/core/sock.c                               |  2 +-
 net/ipv4/tcp_input.c                          |  2 +-
 7 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index acf6d80a6bb7..ef8b38c0ee56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -547,11 +547,13 @@ void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi)
 	queue_work(rule->priv->tls->rx_wq, &rule->work);
 }
 
-static int mlx5e_ktls_sk_get_rxq(struct sock *sk)
+static int mlx5e_ktls_sk_get_rxq(struct sock *sk, struct net_device *dev)
 {
-	int rxq = sk_rx_queue_get(sk);
+	int ifindex, rxq;
 
-	if (unlikely(rxq == -1))
+	sk_rx_dev_and_queue_get(sk, &ifindex, &rxq);
+
+	if (unlikely(ifindex != dev->ifindex || rxq == -1))
 		rxq = 0;
 
 	return rxq;
@@ -583,7 +585,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 
-	rxq = mlx5e_ktls_sk_get_rxq(sk);
+	rxq = mlx5e_ktls_sk_get_rxq(sk, netdev);
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
 
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b001fa91c14e..f04283c54bcd 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -128,7 +128,7 @@ static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
-	sk_rx_queue_set(sk, skb);
+	sk_rx_dev_and_queue_set(sk, skb);
 }
 
 /* variant used for unconnected sockets */
diff --git a/include/net/sock.h b/include/net/sock.h
index f311425513ff..fe8b669237f3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -150,7 +150,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
  *	@skc_tx_dev_and_queue_mapping: tx ifindex/queue for this connection
- *	@skc_rx_queue_mapping: rx queue number for this connection
+ *	@skc_rx_dev_and_queue_mapping: rx ifindex/queue for this connection
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
  *		%SO_OOBINLINE settings, %SO_TIMESTAMPING settings
@@ -236,7 +236,7 @@ struct sock_common {
 	};
 	struct dev_and_queue	skc_tx_dev_and_queue_mapping;
 #ifdef CONFIG_XPS
-	unsigned short		skc_rx_queue_mapping;
+	struct dev_and_queue	skc_rx_dev_and_queue_mapping;
 #endif
 	union {
 		int		skc_incoming_cpu;
@@ -364,7 +364,7 @@ struct sock {
 #define sk_refcnt		__sk_common.skc_refcnt
 #define sk_tx_dev_and_queue_mapping	__sk_common.skc_tx_dev_and_queue_mapping
 #ifdef CONFIG_XPS
-#define sk_rx_queue_mapping	__sk_common.skc_rx_queue_mapping
+#define sk_rx_dev_and_queue_mapping	__sk_common.skc_rx_dev_and_queue_mapping
 #endif
 
 #define sk_dontcopy_begin	__sk_common.skc_dontcopy_begin
@@ -1865,34 +1865,34 @@ static inline void sk_tx_dev_and_queue_get(const struct sock *sk, int *ifindex,
 	}
 }
 
-static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
+static inline void sk_rx_dev_and_queue_set(struct sock *sk,
+					   const struct sk_buff *skb)
 {
 #ifdef CONFIG_XPS
-	if (skb_rx_queue_recorded(skb)) {
-		u16 rx_queue = skb_get_rx_queue(skb);
-
-		if (WARN_ON_ONCE(rx_queue == NO_QUEUE_MAPPING))
-			return;
-
-		sk->sk_rx_queue_mapping = rx_queue;
-	}
+	if (skb->dev && skb_rx_queue_recorded(skb))
+		__dev_and_queue_set(&sk->sk_rx_dev_and_queue_mapping, skb->dev,
+				    skb_get_rx_queue(skb));
 #endif
 }
 
-static inline void sk_rx_queue_clear(struct sock *sk)
+static inline void sk_rx_dev_and_queue_clear(struct sock *sk)
 {
 #ifdef CONFIG_XPS
-	sk->sk_rx_queue_mapping = NO_QUEUE_MAPPING;
+	__dev_and_queue_clear(&sk->sk_rx_dev_and_queue_mapping);
 #endif
 }
 
 #ifdef CONFIG_XPS
-static inline int sk_rx_queue_get(const struct sock *sk)
+static inline void sk_rx_dev_and_queue_get(const struct sock *sk,
+					   int *ifindex, int *rx_queue)
 {
-	if (sk && sk->sk_rx_queue_mapping != NO_QUEUE_MAPPING)
-		return sk->sk_rx_queue_mapping;
-
-	return -1;
+	if (sk) {
+		__dev_and_queue_get(&sk->sk_rx_dev_and_queue_mapping,
+				    ifindex, rx_queue);
+	} else {
+		*ifindex = -1;
+		*rx_queue = -1;
+	}
 }
 #endif
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 669dea31b467..10a704c79ea7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3939,9 +3939,12 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 
 	dev_maps = rcu_dereference(sb_dev->xps_rxqs_map);
 	if (dev_maps) {
-		int tci = sk_rx_queue_get(sk);
+		int tci, ifindex;
 
-		if (tci >= 0 && tci < dev->num_rx_queues)
+		sk_rx_dev_and_queue_get(sk, &ifindex, &tci);
+
+		if (dev->ifindex == ifindex &&
+		    tci >= 0 && tci < dev->num_rx_queues)
 			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
 							  tci);
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 3fa16b8c0d61..eef2b778ade6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8044,11 +8044,12 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 #ifdef CONFIG_XPS
 		*insn++ = BPF_LDX_MEM(
-			BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
+			BPF_FIELD_SIZEOF(struct sock,
+					 sk_rx_dev_and_queue_mapping.queue),
 			si->dst_reg, si->src_reg,
-			bpf_target_off(struct sock, sk_rx_queue_mapping,
+			bpf_target_off(struct sock, sk_rx_dev_and_queue_mapping.queue,
 				       sizeof_field(struct sock,
-						    sk_rx_queue_mapping),
+						    sk_rx_dev_and_queue_mapping.queue),
 				       target_size));
 		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
 				      1);
diff --git a/net/core/sock.c b/net/core/sock.c
index 92129b017074..8b44512c8b3a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3000,7 +3000,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
 
-	sk_rx_queue_clear(sk);
+	sk_rx_dev_and_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
 	 * (Documentation/RCU/rculist_nulls.txt for details)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 82906deb7874..5c7e1a7a7ed9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6746,7 +6746,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	tcp_rsk(req)->snt_isn = isn;
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	tcp_openreq_init_rwin(req, sk, dst);
-	sk_rx_queue_set(req_to_sk(req), skb);
+	sk_rx_dev_and_queue_set(req_to_sk(req), skb);
 	if (!want_cookie) {
 		tcp_reqsk_record_syn(sk, req, skb);
 		fastopen_sk = tcp_try_fastopen(sk, skb, req, &foc, dst);
-- 
2.25.1

