Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A0E22CF48
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgGXUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXUOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:14:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA10C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m16so5160529pls.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y2WmyECnFwNJsXUFD3kdUnlcJH8cNTV61rZ5rRD+D4U=;
        b=LrhqAN01g+lurocWksDznegPIajM7BqShyoJ66PjE0QTQZLC1nd+0mq9wW2SDOx+kR
         xolfBJrlYNYZMQH/ljfnqvI88WPVu9NcJbMJFyS+CQL9niF3OPnzA56FXcDEEdTo1CSM
         zTZPZKt3lBw6c1MtpevzgRHZzHGZPuGbOz7WIcFe4rD7YXSzcWIMOPJU/XQAYRBvABCK
         P2ma8frP3IbWv6UdGV9+L5vT3MZHZ+keAQZcuiCBgNAmWbNRfY31aiViVxreYfocAeYr
         EmKzixNOgR/BnVqvlon4flgDj++8gLW+aZxuYlzZat1j7r0KPTB/uUPm/BmXEVOY68zH
         69dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2WmyECnFwNJsXUFD3kdUnlcJH8cNTV61rZ5rRD+D4U=;
        b=nDUz84PRWgK4KZPNQ6UVp5cGhaisK7BU1kaovycp91sg78v7Cma+eiKhWR12dGHACb
         Uulj5P71olWHg0UeVLQc7HfyGPc/1H+zCXGJrccPdXz8OGLUNGzOccXX+lTUeIzEpbOQ
         C6aDOamRAiwZZyocHoS34dBfSM6pYMOvpxxd9X3Kk4iXxgh2gXF5paL03dwjyjaGE8i8
         pq4HT2HSV5E2vWa6gKTefg7jnfdllXiRpG9UK9f6+Ujf7nmvTtwEvp8fgwqSe3a4+CIf
         0lAu0HCNBAbIxjCGoWF7i/H2eBSSuzxmAxWGKdvWSh+ka+5b9Y1TaB01ddENKXJ2oVEz
         hHBA==
X-Gm-Message-State: AOAM533DiBz24+ZpeH028Zw9NSLJj1a1PLldbCvZtxXPCGkb5V4C1yFU
        7QO6JrrUxwN33LF976IbvkuhN5EiRDc=
X-Google-Smtp-Source: ABdhPJzLJRTgkKC37LmJoeqnKIZy5Iu9Ev7WxQksR8cWyldmYDbbX4KM7DsgtqL1RSvjh1f9lv+3Kw==
X-Received: by 2002:a17:902:44c:: with SMTP id 70mr9416567ple.73.1595621673266;
        Fri, 24 Jul 2020 13:14:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id ci23sm6496539pjb.29.2020.07.24.13.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 13:14:32 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, amritha.nambiar@intel.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 2/3] sock: Use dev_and_queue structure for TX queue mapping in sock
Date:   Fri, 24 Jul 2020 13:14:11 -0700
Message-Id: <20200724201412.599398-3-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724201412.599398-1-tom@herbertland.com>
References: <20200724201412.599398-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sk_tx_queue_mapping with sk_tx_dev_and_queue_mapping and
change associated function to set, get, and clear mapping.
---
 drivers/net/hyperv/netvsc_drv.c |  9 +++++---
 include/net/request_sock.h      |  2 +-
 include/net/sock.h              | 38 +++++++++++++++++----------------
 net/core/dev.c                  |  8 ++++---
 net/core/sock.c                 |  8 +++----
 5 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index e0327b88732c..016b1ab20767 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -307,7 +307,7 @@ static inline int netvsc_get_tx_queue(struct net_device *ndev,
 	/* If queue index changed record the new value */
 	if (q_idx != old_idx &&
 	    sk && sk_fullsock(sk) && rcu_access_pointer(sk->sk_dst_cache))
-		sk_tx_queue_set(sk, q_idx);
+		sk_tx_dev_and_queue_set(sk, ndev, q_idx);
 
 	return q_idx;
 }
@@ -325,9 +325,12 @@ static inline int netvsc_get_tx_queue(struct net_device *ndev,
  */
 static u16 netvsc_pick_tx(struct net_device *ndev, struct sk_buff *skb)
 {
-	int q_idx = sk_tx_queue_get(skb->sk);
+	int ifindex, q_idx;
 
-	if (q_idx < 0 || skb->ooo_okay || q_idx >= ndev->real_num_tx_queues) {
+	sk_tx_dev_and_queue_get(skb->sk, &ifindex, &q_idx);
+
+	if (ifindex != ndev->ifindex || q_idx < 0 || skb->ooo_okay ||
+	    q_idx >= ndev->real_num_tx_queues) {
 		/* If forwarding a packet, we use the recorded queue when
 		 * available for better cache locality.
 		 */
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index cf8b33213bbc..a6c0636eeb58 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -95,7 +95,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 	req->rsk_ops = ops;
 	req_to_sk(req)->sk_prot = sk_listener->sk_prot;
 	sk_node_init(&req_to_sk(req)->sk_node);
-	sk_tx_queue_clear(req_to_sk(req));
+	sk_tx_dev_and_queue_clear(req_to_sk(req));
 	req->saved_syn = NULL;
 	req->num_timeout = 0;
 	req->num_retrans = 0;
diff --git a/include/net/sock.h b/include/net/sock.h
index b4919e603648..f311425513ff 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -149,7 +149,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_cookie: socket's cookie value
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
- *	@skc_tx_queue_mapping: tx queue number for this connection
+ *	@skc_tx_dev_and_queue_mapping: tx ifindex/queue for this connection
  *	@skc_rx_queue_mapping: rx queue number for this connection
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
@@ -234,7 +234,7 @@ struct sock_common {
 		struct hlist_node	skc_node;
 		struct hlist_nulls_node skc_nulls_node;
 	};
-	unsigned short		skc_tx_queue_mapping;
+	struct dev_and_queue	skc_tx_dev_and_queue_mapping;
 #ifdef CONFIG_XPS
 	unsigned short		skc_rx_queue_mapping;
 #endif
@@ -362,7 +362,7 @@ struct sock {
 #define sk_node			__sk_common.skc_node
 #define sk_nulls_node		__sk_common.skc_nulls_node
 #define sk_refcnt		__sk_common.skc_refcnt
-#define sk_tx_queue_mapping	__sk_common.skc_tx_queue_mapping
+#define sk_tx_dev_and_queue_mapping	__sk_common.skc_tx_dev_and_queue_mapping
 #ifdef CONFIG_XPS
 #define sk_rx_queue_mapping	__sk_common.skc_rx_queue_mapping
 #endif
@@ -1842,25 +1842,27 @@ static inline void __dev_and_queue_clear(struct dev_and_queue *odandq)
 	odandq->val64 = dandq.val64;
 }
 
-static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
+static inline void sk_tx_dev_and_queue_set(struct sock *sk,
+					   struct net_device *dev, int tx_queue)
 {
-	/* sk_tx_queue_mapping accept only upto a 16-bit value */
-	if (WARN_ON_ONCE((unsigned short)tx_queue >= USHRT_MAX))
-		return;
-	sk->sk_tx_queue_mapping = tx_queue;
+	__dev_and_queue_set(&sk->sk_tx_dev_and_queue_mapping, dev, tx_queue);
 }
 
-static inline void sk_tx_queue_clear(struct sock *sk)
+static inline void sk_tx_dev_and_queue_clear(struct sock *sk)
 {
-	sk->sk_tx_queue_mapping = NO_QUEUE_MAPPING;
+	__dev_and_queue_clear(&sk->sk_tx_dev_and_queue_mapping);
 }
 
-static inline int sk_tx_queue_get(const struct sock *sk)
+static inline void sk_tx_dev_and_queue_get(const struct sock *sk, int *ifindex,
+					   int *tx_queue)
 {
-	if (sk && sk->sk_tx_queue_mapping != NO_QUEUE_MAPPING)
-		return sk->sk_tx_queue_mapping;
-
-	return -1;
+	if (sk) {
+		__dev_and_queue_get(&sk->sk_tx_dev_and_queue_mapping,
+				    ifindex, tx_queue);
+	} else {
+		*ifindex = -1;
+		*tx_queue = -1;
+	}
 }
 
 static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
@@ -1989,7 +1991,7 @@ static inline void dst_negative_advice(struct sock *sk)
 
 		if (ndst != dst) {
 			rcu_assign_pointer(sk->sk_dst_cache, ndst);
-			sk_tx_queue_clear(sk);
+			sk_tx_dev_and_queue_clear(sk);
 			sk->sk_dst_pending_confirm = 0;
 		}
 	}
@@ -2000,7 +2002,7 @@ __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_dev_and_queue_clear(sk);
 	sk->sk_dst_pending_confirm = 0;
 	old_dst = rcu_dereference_protected(sk->sk_dst_cache,
 					    lockdep_sock_is_held(sk));
@@ -2013,7 +2015,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_dev_and_queue_clear(sk);
 	sk->sk_dst_pending_confirm = 0;
 	old_dst = xchg((__force struct dst_entry **)&sk->sk_dst_cache, dst);
 	dst_release(old_dst);
diff --git a/net/core/dev.c b/net/core/dev.c
index a986b07ea845..669dea31b467 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3982,11 +3982,13 @@ u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 		     struct net_device *sb_dev)
 {
 	struct sock *sk = skb->sk;
-	int queue_index = sk_tx_queue_get(sk);
+	int queue_index, ifindex;
+
+	sk_tx_dev_and_queue_get(sk, &ifindex, &queue_index);
 
 	sb_dev = sb_dev ? : dev;
 
-	if (queue_index < 0 || skb->ooo_okay ||
+	if (ifindex != dev->ifindex || queue_index < 0 || skb->ooo_okay ||
 	    queue_index >= dev->real_num_tx_queues) {
 		int new_index = get_xps_queue(dev, sb_dev, skb);
 
@@ -3996,7 +3998,7 @@ u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 		if (queue_index != new_index && sk &&
 		    sk_fullsock(sk) &&
 		    rcu_access_pointer(sk->sk_dst_cache))
-			sk_tx_queue_set(sk, new_index);
+			sk_tx_dev_and_queue_set(sk, dev, new_index);
 
 		queue_index = new_index;
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 6da54eac2b34..92129b017074 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -542,7 +542,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 	struct dst_entry *dst = __sk_dst_get(sk);
 
 	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 		sk->sk_dst_pending_confirm = 0;
 		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
 		dst_release(dst);
@@ -1680,7 +1680,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 	}
 
 	return sk;
@@ -1749,7 +1749,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 	}
 
 	return sk;
@@ -1973,7 +1973,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 */
 		sk_refcnt_debug_inc(newsk);
 		sk_set_socket(newsk, NULL);
-		sk_tx_queue_clear(newsk);
+		sk_tx_dev_and_queue_clear(newsk);
 		RCU_INIT_POINTER(newsk->sk_wq, NULL);
 
 		if (newsk->sk_prot->sockets_allocated)
-- 
2.25.1

