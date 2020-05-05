Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165ED1C5EB5
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbgEERWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:22:53 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:58391 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729654AbgEERWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:22:53 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mbj3e-1j0Y4W17pW-00dJht; Tue, 05 May 2020 19:22:38 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Martin Varghese <martin.varghese@nokia.com>,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] net: bareudp: avoid uninitialized variable warning
Date:   Tue,  5 May 2020 19:22:14 +0200
Message-Id: <20200505172232.1034560-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ScX50QBtpxPFHX9a2scBFJp+o7DWKydLzKgA2Q+e/2ogsI4SAtl
 djmLGBbV1D639qDn9G714rq7fyC/8ZEqIclZmJSc+0InIrXToStgetKi8SWqcaCJl6UgCxk
 KCKiquoiRbungr5pwrYYeZK3S+kzCczSOVZTD2dDycjCJBn3CKegMADSogr0LGqf1piMOxI
 9KtIuXpxh9hB+89TBJ9Iw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1wtMQ+rWzW8=:mcwGonjEhrQw1MIe99lyBE
 y7Vk4eNKd/OkxLAPihR3aSI6irPA6m+nAbmzjAF8KzukyUcL6/dQSyVYPjYMnSdfMzZuTYMuD
 dogqprIJM9wYZaDaeo0sBIovtgnufZUsARXBy+F0k/ItxXxyLmrd14KENnK/XqaaGAtKiG8ro
 WCtaHARroay8i0jPdMDFiGQxEuQn+HhYUZai1p3eHRrwq4CHCyuE6KnzM3fYQHRzZCVjgYtU+
 YZN2iyxRUo/09I9W8OjwTLTjoW/3M72e3vl3NmELnVH3bj29NOf152I7Z4sTPiz+Y5Qnzn0Zv
 1xBSAVN7lHzH1HoFD7YtUUhjzlCTZ5teDCVFyOKxSSwEf9r5hJWjMg8ykB9tDzxWXIVF1J6tN
 TIDmIXFjJpjFoIy1iUre65uP3SEtGE7s8g0aPsUCwdnlb03rtK/btdf/6pRvKqf+BoK4lDCVM
 NL2wR6NLPfufYROr3v0SrPpzhtd2o9JBxxMiC+VAxpjZ3opkxN4BlWecd6pNY0A1Vm0RrLfC+
 OS5Ac9EyS7lh0OZ0h3Fj14uUivWsvzn5UPFRJBZ3cB5GlZONZnXhcm5ESM0bNsqEQxd/IXeXj
 146zB4dj8K+pN4KaD9ALradcG7O6Qu6/lkHrhk9O12E0vReIYLy8WjwegmTgOJoKsIC6gmgR4
 DIu6Hm783J/VS5VaGP9v/LmhS+uIR1NwFIJAdbGivO5z7vule8RNeDfOeFgNT+O+ZUKGbGEvi
 ciM+qk7DLO4K1ZTe4us/9Ln8Fo1VqkWP/nSo82HfsqkZZ87l3MTY7XeOSRPHg02knmSVha65O
 ucJ4keWx+EJ1s1bYRQwOSm12P4rQSfoUa+AedHAoC3UxAaEvC0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang points out that building without IPv6 would lead to returning
an uninitialized variable if a packet with family!=AF_INET is
passed into bareudp_udp_encap_recv():

drivers/net/bareudp.c:139:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (family == AF_INET)
            ^~~~~~~~~~~~~~~~~
drivers/net/bareudp.c:146:15: note: uninitialized use occurs here
        if (unlikely(err)) {
                     ^~~
include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
 # define unlikely(x)    __builtin_expect(!!(x), 0)
                                            ^
drivers/net/bareudp.c:139:2: note: remove the 'if' if its condition is always true
        if (family == AF_INET)
        ^~~~~~~~~~~~~~~~~~~~~~

This cannot happen in practice, so change the condition in a way that
gcc sees the IPv4 case as unconditionally true here.
For consistency, change all the similar constructs in this file the
same way, using "if(IS_ENABLED())" instead of #if IS_ENABLED()".

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/bareudp.c    | 18 ++++--------------
 include/net/udp_tunnel.h |  2 --
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index cc0703c3d57f..efd1a1d1f35e 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -136,25 +136,21 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
 
-	if (family == AF_INET)
+	if (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
-#if IS_ENABLED(CONFIG_IPV6)
 	else
 		err = IP6_ECN_decapsulate(oiph, skb);
-#endif
 
 	if (unlikely(err)) {
 		if (log_ecn_error) {
-			if  (family == AF_INET)
+			if  (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
 				net_info_ratelimited("non-ECT from %pI4 "
 						     "with TOS=%#x\n",
 						     &((struct iphdr *)oiph)->saddr,
 						     ((struct iphdr *)oiph)->tos);
-#if IS_ENABLED(CONFIG_IPV6)
 			else
 				net_info_ratelimited("non-ECT from %pI6\n",
 						     &((struct ipv6hdr *)oiph)->saddr);
-#endif
 		}
 		if (err > 1) {
 			++bareudp->dev->stats.rx_frame_errors;
@@ -350,7 +346,6 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
 static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			     struct bareudp_dev *bareudp,
 			     const struct ip_tunnel_info *info)
@@ -411,7 +406,6 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	dst_release(dst);
 	return err;
 }
-#endif
 
 static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -435,11 +429,9 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	rcu_read_lock();
-#if IS_ENABLED(CONFIG_IPV6)
-	if (info->mode & IP_TUNNEL_INFO_IPV6)
+	if (IS_ENABLED(CONFIG_IPV6) && info->mode & IP_TUNNEL_INFO_IPV6)
 		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
 	else
-#endif
 		err = bareudp_xmit_skb(skb, dev, bareudp, info);
 
 	rcu_read_unlock();
@@ -467,7 +459,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-	if (ip_tunnel_info_af(info) == AF_INET) {
+	if (!IS_ENABLED(CONFIG_IPV6) || ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		__be32 saddr;
 
@@ -478,7 +470,6 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 
 		ip_rt_put(rt);
 		info->key.u.ipv4.src = saddr;
-#if IS_ENABLED(CONFIG_IPV6)
 	} else if (ip_tunnel_info_af(info) == AF_INET6) {
 		struct dst_entry *dst;
 		struct in6_addr saddr;
@@ -492,7 +483,6 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 
 		dst_release(dst);
 		info->key.u.ipv6.src = saddr;
-#endif
 	} else {
 		return -EINVAL;
 	}
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 4b1f95e08307..e7312ceb2794 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -143,14 +143,12 @@ void udp_tunnel_xmit_skb(struct rtable *rt, struct sock *sk, struct sk_buff *skb
 			 __be16 df, __be16 src_port, __be16 dst_port,
 			 bool xnet, bool nocheck);
 
-#if IS_ENABLED(CONFIG_IPV6)
 int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
 			 struct sk_buff *skb,
 			 struct net_device *dev, struct in6_addr *saddr,
 			 struct in6_addr *daddr,
 			 __u8 prio, __u8 ttl, __be32 label,
 			 __be16 src_port, __be16 dst_port, bool nocheck);
-#endif
 
 void udp_tunnel_sock_release(struct socket *sock);
 
-- 
2.26.0

