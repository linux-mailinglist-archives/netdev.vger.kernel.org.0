Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F04CC91
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbfFTLDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:03:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45799 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfFTLDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:03:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi6so1241615plb.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 04:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dhJS+UTa7Xaxux/qzHKdqUfyfQxBKVh+dm16ec6/L3g=;
        b=nDMKsQiV/lu5RdyJ7YI6CvrChybj7OmvrtsUT3aZXAXLZ/ME3P9dJyskkiCIBxuU0h
         FFrVcXOpRlpyQF5WJhzt5zkqnTRO1bIfI4qH6ibN9xtAXPWJQfKl2+iMNQtikv7tIzoO
         wS0UXIoaRBL+1909XTGf9UfOA1+26NdokWiuoF9jkTrynjIGFpH40XJ7GKwBN5uVTomw
         uwfgTigjS2r2PJRvsWQNniNC7OGWwVbaHSWYsSAtMhhY4/UJw3nTzp1QxWNtmKS6IKpa
         KANCyS5cxJExurUeLEgcBQo7O1xQMGf3k0p73eEI2/9/m8RQFFQQfQtTu6sv7b2Tmw0B
         OUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dhJS+UTa7Xaxux/qzHKdqUfyfQxBKVh+dm16ec6/L3g=;
        b=lHDHLm3PBxUyfJ+/O0TuiqXs7QCsIE2L+w63a9DpOxhZMu4R/C2JzLQAEWqspRuzKm
         oC7WyzKkrpM9VKhpuK457TJPXbP+r1p8F46rczcL/ya06bP6T5tuagVzbgChUj/ubCdB
         nPjpNCRfViy+mHCqyJOCtOW26XFwAw5SQauHB+LIxkHRF+jOgz911eiI5DO0JUkSqA0w
         xT1gNE7znb5xQeuNQww+bP3T/MhiPpTYop2sjvjvw6rUHgpkpNV2kcS85uvEZOZO30l0
         xo/vWafr7lYuY4lCKSkVKZYppVHL6/weebaQquCY3bh68Pv+uQmBR5H6RAosvSsrfNk5
         VxBw==
X-Gm-Message-State: APjAAAWUclQ/2jMZswGleDdxkPrUD6yHXXyUNVf6vwQB5PjzFA0+UXLy
        LFQNFQML1v2/Dtkxl5oiWnX9YRtf
X-Google-Smtp-Source: APXvYqyTDLsEu9VHn9G0ZvAYtH8T89/ERghlrSBY3mMW2XR9CoTrqwkSsX1w+b2T8IEtp22w4Wt5Zg==
X-Received: by 2002:a17:902:ba82:: with SMTP id k2mr118614178pls.323.1561028629321;
        Thu, 20 Jun 2019 04:03:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u128sm5708880pfu.26.2019.06.20.04.03.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:03:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] tipc: add dst_cache support for udp media
Date:   Thu, 20 Jun 2019 19:03:41 +0800
Message-Id: <0ea2e8519f14d5c9e7bb7ba82a5be371bd4cb9ab.1561028621.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As other udp/ip tunnels do, tipc udp media should also have a
lockless dst_cache supported on its tx path.

Here we add dst_cache into udp_replicast to support dst cache
for both rmcast and rcast, and rmcast uses ub->rcast and each
rcast uses its own node in ub->rcast.list.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/udp_media.c | 72 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 1405ccc..b8962df 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -76,6 +76,7 @@ struct udp_media_addr {
 /* struct udp_replicast - container for UDP remote addresses */
 struct udp_replicast {
 	struct udp_media_addr addr;
+	struct dst_cache dst_cache;
 	struct rcu_head rcu;
 	struct list_head list;
 };
@@ -158,22 +159,27 @@ static int tipc_udp_addr2msg(char *msg, struct tipc_media_addr *a)
 /* tipc_send_msg - enqueue a send request */
 static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 			 struct udp_bearer *ub, struct udp_media_addr *src,
-			 struct udp_media_addr *dst)
+			 struct udp_media_addr *dst, struct dst_cache *cache)
 {
+	struct dst_entry *ndst = dst_cache_get(cache);
 	int ttl, err = 0;
-	struct rtable *rt;
 
 	if (dst->proto == htons(ETH_P_IP)) {
-		struct flowi4 fl = {
-			.daddr = dst->ipv4.s_addr,
-			.saddr = src->ipv4.s_addr,
-			.flowi4_mark = skb->mark,
-			.flowi4_proto = IPPROTO_UDP
-		};
-		rt = ip_route_output_key(net, &fl);
-		if (IS_ERR(rt)) {
-			err = PTR_ERR(rt);
-			goto tx_error;
+		struct rtable *rt = (struct rtable *)ndst;
+
+		if (!rt) {
+			struct flowi4 fl = {
+				.daddr = dst->ipv4.s_addr,
+				.saddr = src->ipv4.s_addr,
+				.flowi4_mark = skb->mark,
+				.flowi4_proto = IPPROTO_UDP
+			};
+			rt = ip_route_output_key(net, &fl);
+			if (IS_ERR(rt)) {
+				err = PTR_ERR(rt);
+				goto tx_error;
+			}
+			dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
 		}
 
 		ttl = ip4_dst_hoplimit(&rt->dst);
@@ -182,17 +188,19 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 				    dst->port, false, true);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		struct dst_entry *ndst;
-		struct flowi6 fl6 = {
-			.flowi6_oif = ub->ifindex,
-			.daddr = dst->ipv6,
-			.saddr = src->ipv6,
-			.flowi6_proto = IPPROTO_UDP
-		};
-		err = ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk, &ndst,
-						 &fl6);
-		if (err)
-			goto tx_error;
+		if (!ndst) {
+			struct flowi6 fl6 = {
+				.flowi6_oif = ub->ifindex,
+				.daddr = dst->ipv6,
+				.saddr = src->ipv6,
+				.flowi6_proto = IPPROTO_UDP
+			};
+			err = ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk,
+							 &ndst, &fl6);
+			if (err)
+				goto tx_error;
+			dst_cache_set_ip6(cache, ndst, &fl6.saddr);
+		}
 		ttl = ip6_dst_hoplimit(ndst);
 		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
 					   &src->ipv6, &dst->ipv6, 0, ttl, 0,
@@ -230,7 +238,8 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 	}
 
 	if (addr->broadcast != TIPC_REPLICAST_SUPPORT)
-		return tipc_udp_xmit(net, skb, ub, src, dst);
+		return tipc_udp_xmit(net, skb, ub, src, dst,
+				     &ub->rcast.dst_cache);
 
 	/* Replicast, send an skb to each configured IP address */
 	list_for_each_entry_rcu(rcast, &ub->rcast.list, list) {
@@ -242,7 +251,8 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 			goto out;
 		}
 
-		err = tipc_udp_xmit(net, _skb, ub, src, &rcast->addr);
+		err = tipc_udp_xmit(net, _skb, ub, src, &rcast->addr,
+				    &rcast->dst_cache);
 		if (err)
 			goto out;
 	}
@@ -286,6 +296,11 @@ static int tipc_udp_rcast_add(struct tipc_bearer *b,
 	if (!rcast)
 		return -ENOMEM;
 
+	if (dst_cache_init(&rcast->dst_cache, GFP_ATOMIC)) {
+		kfree(rcast);
+		return -ENOMEM;
+	}
+
 	memcpy(&rcast->addr, addr, sizeof(struct udp_media_addr));
 
 	if (ntohs(addr->proto) == ETH_P_IP)
@@ -742,6 +757,10 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	tuncfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(net, ub->ubsock, &tuncfg);
 
+	err = dst_cache_init(&ub->rcast.dst_cache, GFP_ATOMIC);
+	if (err)
+		goto err;
+
 	/**
 	 * The bcast media address port is used for all peers and the ip
 	 * is used if it's a multicast address.
@@ -756,6 +775,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 
 	return 0;
 err:
+	dst_cache_destroy(&ub->rcast.dst_cache);
 	if (ub->ubsock)
 		udp_tunnel_sock_release(ub->ubsock);
 	kfree(ub);
@@ -769,10 +789,12 @@ static void cleanup_bearer(struct work_struct *work)
 	struct udp_replicast *rcast, *tmp;
 
 	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
+		dst_cache_destroy(&rcast->dst_cache);
 		list_del_rcu(&rcast->list);
 		kfree_rcu(rcast, rcu);
 	}
 
+	dst_cache_destroy(&ub->rcast.dst_cache);
 	if (ub->ubsock)
 		udp_tunnel_sock_release(ub->ubsock);
 	synchronize_net();
-- 
2.1.0

