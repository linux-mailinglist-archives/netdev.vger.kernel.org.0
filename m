Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A857D54E8B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfFYMOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:14:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36153 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfFYMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:14:05 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so18081606qtl.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 05:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gutEN+vHqy+rMWjZUryJaXfGglCBqxamRcnHWBPb1Rk=;
        b=ccveiNlJDvn64iSw6p9pdUhge1jzWKOOcCR2FonooZUVKvoAHdU3bFrCQI5q2PHbkr
         imHg3JYOph3AFq464dUUbMYmHeXARIGcwAwzzU1oDvGg2lEUqpv0vM/eUqJMLDiiec5W
         NbbY2YfLEuGo6X1bC98VVA4/+4oOQ08mDPVuU+peZSpnewqfySjRmXuZ9N7LirFKt37F
         z5hCTLEqrNUkkL+SEkZwmuf3hA9M79OgAv4T6Iyj+gMwdBg/yOZ/oiHJFQ6T1WT8khgq
         lNN0zfE/ZwEbhLdSRrHw+/ykfLrn4ut9x+r9NHOpZxTFKb8qpuDJjTm3dQNAKCa2lXCq
         puvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gutEN+vHqy+rMWjZUryJaXfGglCBqxamRcnHWBPb1Rk=;
        b=JNKJbF8H0cCaHPBuJF2OxzsWJgeqUWAwDjO3bMpJMKHvX4H6LIWHkn9eATgKIbMiI1
         cqHRRqOhKgzW/6yJnvZIGuPccTpwIUsGUEs6pjYFSIF1v0dH0QG3ejRCXpsaWPLBdxQA
         9srT0uACVrmfPuoTw2sos3ploXPlxvnhW1j5vhC7gepn3O5huQa947crZtfhFRIDX6Ch
         guFNy36J7ZwGJhMLq6U8xW3WWqpjv9fPEzKhriaAeGG8bqZ/2JdTTgQcHfRtDQi3vn3Z
         4MD8xivHY6iTFhEM0EitioZ5wY/TOdD6bjetK3vJQB7qjGaxKFNfMKUheO6+hJFQUqtZ
         br7A==
X-Gm-Message-State: APjAAAVSPF1rZ+dUV6F8WkY1/APvl0LOEBcrVYlEwT7Et+zzW08CnZFI
        z6SCXeNMs/7yGb6GMKPHc7eyYYU=
X-Google-Smtp-Source: APXvYqyzGKrtUyNW2S0xnH2M7tYxBUtrBcD3b80rMV4fgRlqPzsNRM6qZ3EXJk0aTyZpqdYUUkZ59g==
X-Received: by 2002:a0c:bd1f:: with SMTP id m31mr62606266qvg.54.1561464844415;
        Tue, 25 Jun 2019 05:14:04 -0700 (PDT)
Received: from localhost.localdomain ([104.238.32.30])
        by smtp.gmail.com with ESMTPSA id u19sm7655308qka.35.2019.06.25.05.14.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 05:14:03 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
Date:   Tue, 25 Jun 2019 06:33:59 -0400
Message-Id: <20190625103359.31102-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast egress packets has skb_rtable(skb)->rt_iif set to the oif.
Depending on the socket, these packets might be recirculated back as
input and raw sockets that are opened for them are bound to the VRF. But
since skb_rtable(skb) is set and its rt_iif is non-zero, inet_iif()
function returns rt_iif instead of skb_iif (the VRF netdev). Hence, the
socket lookup fails.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/net/route.h  |  1 +
 net/ipv4/ip_output.c | 25 ++++++++++++++++++++++++-
 net/ipv4/route.c     | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/net/route.h b/include/net/route.h
index 065b47754f05..55ff71ffb796 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -221,6 +221,7 @@ void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			     unsigned int flags, u16 type,
 			     bool nopolicy, bool noxfrm, bool will_cache);
+struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt);
 
 struct in_ifaddr;
 void fib_add_ifaddr(struct in_ifaddr *);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 16f9159234a2..a5e240bad3ce 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -329,6 +329,19 @@ static int ip_mc_finish_output(struct net *net, struct sock *sk,
 	return dev_loopback_xmit(net, sk, skb);
 }
 
+static void ip_mc_reset_rt_iif(struct net *net, struct rtable *rt,
+			       struct sk_buff *newskb)
+{
+	struct rtable *new_rt;
+
+	new_rt = rt_dst_clone(net->loopback_dev, rt);
+	if (new_rt) {
+		new_rt->rt_iif = 0;
+		skb_dst_drop(newskb);
+		skb_dst_set(newskb, &new_rt->dst);
+	}
+}
+
 int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct rtable *rt = skb_rtable(skb);
@@ -363,10 +376,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 #endif
 		   ) {
 			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
-			if (newskb)
+			if (newskb) {
+				/* Reset rt_iif so that inet_iif() will return
+				 * skb->dev->ifIndex which is the VRF device for
+				 * socket lookup. Setting this to VRF ifindex
+				 * causes ipi_ifindex in in_pktinfo to be
+				 * overwritten, see ipv4_pktinfo_prepare().
+				 */
+				if (netif_is_l3_slave(dev))
+					ip_mc_reset_rt_iif(net, rt, newskb);
+
 				NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING,
 					net, sk, newskb, NULL, newskb->dev,
 					ip_mc_finish_output);
+			}
 		}
 
 		/* Multicasts with ttl 0 must not go beyond the host */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6cb7cff22db9..8ea0735a6754 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1647,6 +1647,39 @@ struct rtable *rt_dst_alloc(struct net_device *dev,
 }
 EXPORT_SYMBOL(rt_dst_alloc);
 
+struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
+{
+	struct rtable *new_rt;
+
+	new_rt = dst_alloc(&ipv4_dst_ops, dev, 1, DST_OBSOLETE_FORCE_CHK,
+			   rt->dst.flags);
+
+	if (new_rt) {
+		new_rt->rt_genid = rt_genid_ipv4(dev_net(dev));
+		new_rt->rt_flags = rt->rt_flags;
+		new_rt->rt_type = rt->rt_type;
+		new_rt->rt_is_input = rt->rt_is_input;
+		new_rt->rt_iif = rt->rt_iif;
+		new_rt->rt_pmtu = rt->rt_pmtu;
+		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
+		new_rt->rt_gw_family = rt->rt_gw_family;
+		if (rt->rt_gw_family == AF_INET)
+			new_rt->rt_gw4 = rt->rt_gw4;
+		else if (rt->rt_gw_family == AF_INET6)
+			new_rt->rt_gw6 = rt->rt_gw6;
+		INIT_LIST_HEAD(&new_rt->rt_uncached);
+
+		new_rt->dst.flags |= DST_HOST;
+		new_rt->dst.input = rt->dst.input;
+		new_rt->dst.output = rt->dst.output;
+		new_rt->dst.error = rt->dst.error;
+		new_rt->dst.lastuse = jiffies;
+		new_rt->dst.lwtstate = lwtstate_get(rt->dst.lwtstate);
+	}
+	return new_rt;
+}
+EXPORT_SYMBOL(rt_dst_clone);
+
 /* called in rcu_read_lock() section */
 int ip_mc_validate_source(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 			  u8 tos, struct net_device *dev,
-- 
2.17.1

