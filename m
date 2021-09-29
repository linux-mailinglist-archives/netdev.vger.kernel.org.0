Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC39941C916
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbhI2QB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:29 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27913 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345476AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWw36z4zbmtg;
        Wed, 29 Sep 2021 23:53:48 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 064/167] sock: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:51 +0800
Message-ID: <20210929155334.12454-65-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/net/sock.h               |  7 ++++---
 net/core/skmsg.c                 |  3 ++-
 net/core/sock.c                  | 17 +++++++++++------
 net/ipv4/af_inet.c               |  2 +-
 net/ipv4/tcp.c                   | 10 ++++++----
 net/ipv4/tcp_ipv4.c              |  2 +-
 net/ipv6/af_inet6.c              |  2 +-
 net/ipv6/inet6_connection_sock.c |  2 +-
 net/ipv6/tcp_ipv6.c              |  2 +-
 9 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 879980de3dcd..5c76b5c7ee34 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2050,8 +2050,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
 
 static inline void sk_nocaps_add(struct sock *sk, netdev_features_t flags)
 {
-	sk->sk_route_nocaps |= flags;
-	sk->sk_route_caps &= ~flags;
+	netdev_feature_or(&sk->sk_route_nocaps, sk->sk_route_nocaps, flags);
+	netdev_feature_andnot(&sk->sk_route_caps, sk->sk_route_caps, flags);
 }
 
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
@@ -2063,7 +2063,8 @@ static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
 		if (!csum_and_copy_from_iter_full(to, copy, &csum, from))
 			return -EFAULT;
 		skb->csum = csum_block_add(skb->csum, csum, offset);
-	} else if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY) {
+	} else if (netdev_feature_test_bit(NETIF_F_NOCACHE_COPY_BIT,
+					   sk->sk_route_caps)) {
 		if (!copy_from_iter_full_nocache(to, copy, from))
 			return -EFAULT;
 	} else if (!copy_from_iter_full(to, copy, from))
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..2ff4a64eaa62 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -379,7 +379,8 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 		copy = (buf_size > bytes) ? bytes : buf_size;
 		to = sg_virt(sge) + msg->sg.copybreak;
 		msg->sg.copybreak += copy;
-		if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY)
+		if (netdev_feature_test_bit(NETIF_F_NOCACHE_COPY_BIT,
+					    sk->sk_route_caps))
 			ret = copy_from_iter_nocache(to, copy, from);
 		else
 			ret = copy_from_iter(to, copy, from);
diff --git a/net/core/sock.c b/net/core/sock.c
index 512e629f9780..84a414606eb7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2146,15 +2146,20 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	u32 max_segs = 1;
 
 	sk_dst_set(sk, dst);
-	sk->sk_route_caps = dst->dev->features | sk->sk_route_forced_caps;
-	if (sk->sk_route_caps & NETIF_F_GSO)
-		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
-	sk->sk_route_caps &= ~sk->sk_route_nocaps;
+	netdev_feature_or(&sk->sk_route_caps, dst->dev->features,
+			  sk->sk_route_forced_caps);
+	if (netdev_feature_test_bit(NETIF_F_GSO_BIT, sk->sk_route_caps))
+		netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+					&sk->sk_route_caps);
+	netdev_feature_andnot(&sk->sk_route_caps, sk->sk_route_caps,
+			      sk->sk_route_nocaps);
 	if (sk_can_gso(sk)) {
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
-			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+			netdev_feature_clear_bits(NETIF_F_GSO_MASK,
+						  &sk->sk_route_caps);
 		} else {
-			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
+			netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
+						&sk->sk_route_caps);
 			sk->sk_gso_max_size = dst->dev->gso_max_size;
 			max_segs = max_t(u32, dst->dev->gso_max_segs, 1);
 		}
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index aeff7736f260..e3384a815537 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1295,7 +1295,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		err = PTR_ERR(rt);
 
 		/* Routing failed... */
-		sk->sk_route_caps = 0;
+		netdev_feature_zero(&sk->sk_route_caps);
 		/*
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 414c179c28e0..d573815a3186 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,7 +457,8 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_route_forced_caps = NETIF_F_GSO;
+	netdev_feature_zero(&sk->sk_route_forced_caps);
+	netdev_feature_set_bit(NETIF_F_GSO_BIT, &sk->sk_route_forced_caps);
 }
 EXPORT_SYMBOL(tcp_init_sock);
 
@@ -1106,7 +1107,7 @@ EXPORT_SYMBOL_GPL(do_tcp_sendpages);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags)
 {
-	if (!(sk->sk_route_caps & NETIF_F_SG))
+	if (!netdev_feature_test_bit(NETIF_F_SG_BIT, sk->sk_route_caps))
 		return sock_no_sendpage_locked(sk, page, offset, size, flags);
 
 	tcp_rate_check_app_limited(sk);  /* is sending application-limited? */
@@ -1166,7 +1167,7 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 		if (err) {
 			tcp_set_state(sk, TCP_CLOSE);
 			inet->inet_dport = 0;
-			sk->sk_route_caps = 0;
+			netdev_feature_zero(&sk->sk_route_caps);
 		}
 	}
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
@@ -1205,7 +1206,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			goto out_err;
 		}
 
-		zc = sk->sk_route_caps & NETIF_F_SG;
+		zc = netdev_feature_test_bit(NETIF_F_SG_BIT,
+					     sk->sk_route_caps);
 		if (!zc)
 			uarg->zerocopy = 0;
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 29a57bd159f0..a3720304fa81 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -323,7 +323,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	netdev_feature_zero(&sk->sk_route_caps);
 	inet->inet_dport = 0;
 	return err;
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b5878bb8e419..94a4e1adce7b 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -833,7 +833,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
-			sk->sk_route_caps = 0;
+			netdev_feature_zero(&sk->sk_route_caps);
 			sk->sk_err_soft = -PTR_ERR(dst);
 			return PTR_ERR(dst);
 		}
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 5a9f4d722f35..6d8314846355 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -121,7 +121,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 	dst = inet6_csk_route_socket(sk, &fl6);
 	if (IS_ERR(dst)) {
 		sk->sk_err_soft = -PTR_ERR(dst);
-		sk->sk_route_caps = 0;
+		netdev_feature_zero(&sk->sk_route_caps);
 		kfree_skb(skb);
 		return PTR_ERR(dst);
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8cf5ff2e9504..9152b6013a1d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -341,7 +341,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_set_state(sk, TCP_CLOSE);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	netdev_feature_zero(&sk->sk_route_caps);
 	return err;
 }
 
-- 
2.33.0

