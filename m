Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3874041C94D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346358AbhI2QD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12986 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345604AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbd2QSLzWYbT;
        Wed, 29 Sep 2021 23:57:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 165/167] net: sock: add helper sk_nocaps_add_gso()
Date:   Wed, 29 Sep 2021 23:53:32 +0800
Message-ID: <20210929155334.12454-166-shenjian15@huawei.com>
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

Add helper sk_nocaps_add_gso, to avoid declare netdev_features_t anyware.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/net/sock.h    | 9 +++++++++
 net/ipv4/tcp_ipv4.c   | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5c76b5c7ee34..f7ba322c63bd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2054,6 +2054,15 @@ static inline void sk_nocaps_add(struct sock *sk, netdev_features_t flags)
 	netdev_feature_andnot(&sk->sk_route_caps, sk->sk_route_caps, flags);
 }
 
+static inline void sk_nocaps_add_gso(struct sock *sk)
+{
+	netdev_features_t gso_flags;
+
+	netdev_feature_zero(&gso_flags);
+	netdev_feature_set_bits(NETIF_F_GSO_MASK, &gso_flags);
+	sk_nocaps_add(sk, gso_flags);
+}
+
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
 					   struct iov_iter *from, char *to,
 					   int copy, int offset)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a3720304fa81..5b42b4e8e83f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1164,7 +1164,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		if (!md5sig)
 			return -ENOMEM;
 
-		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		sk_nocaps_add_gso(sk);
 		INIT_HLIST_HEAD(&md5sig->head);
 		rcu_assign_pointer(tp->md5sig_info, md5sig);
 	}
@@ -1598,7 +1598,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 */
 		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index,
 			       key->key, key->keylen, GFP_ATOMIC);
-		sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
+		sk_nocaps_add_gso(newsk);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fdc39b4fbbfa..d6e69705d69f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1360,7 +1360,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
 	if (md5) {
-		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		sk_nocaps_add_gso(sk);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 78e01d4faf09..c7e060064686 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -977,7 +977,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 fail_toobig:
 	if (skb->sk && dst_allfrag(skb_dst(skb)))
-		sk_nocaps_add(skb->sk, NETIF_F_GSO_MASK);
+		sk_nocaps_add_gso(skb->sk);
 
 	icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 	err = -EMSGSIZE;
-- 
2.33.0

