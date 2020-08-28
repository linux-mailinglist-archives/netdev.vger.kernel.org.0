Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F38E255D99
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgH1PRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:17:05 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:12066 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbgH1PQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:16:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 4A9B15C1625
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 23:14:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/2] ipv6: add ipv6_fragment hook in ipv6_stub
Date:   Fri, 28 Aug 2020 23:14:31 +0800
Message-Id: <1598627672-10439-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
References: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZS0JJHh8ZQk9LGB1LVkpOQkNNSUxNTEhISUhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDI6Lgw*KT5NLxkBC0gpIxVL
        ShEaCQtVSlVKTkJDTUlMTUxITklLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCQkw3Bg++
X-HM-Tid: 0a7435a274dd2087kuqy4a9b15c1625
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ipv6_fragment to ipv6_stub to avoid calling netfilter when
access ip6_fragment.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: add default one eafnosupport_ipv6_fragment

 include/net/ipv6_stubs.h | 3 +++
 net/ipv6/addrconf_core.c | 8 ++++++++
 net/ipv6/af_inet6.c      | 1 +
 3 files changed, 12 insertions(+)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index d7a7f7c..8fce558 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -63,6 +63,9 @@ struct ipv6_stub {
 			       int encap_type);
 #endif
 	struct neigh_table *nd_tbl;
+
+	int (*ipv6_fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
+			     int (*output)(struct net *, struct sock *, struct sk_buff *));
 };
 extern const struct ipv6_stub *ipv6_stub __read_mostly;
 
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 9ebf3fe..c70c192 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -191,6 +191,13 @@ static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt,
 	return -EAFNOSUPPORT;
 }
 
+static int eafnosupport_ipv6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
+				      int (*output)(struct net *, struct sock *, struct sk_buff *))
+{
+	kfree_skb(skb);
+	return -EAFNOSUPPORT;
+}
+
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 	.ipv6_dst_lookup_flow = eafnosupport_ipv6_dst_lookup_flow,
 	.ipv6_route_input  = eafnosupport_ipv6_route_input,
@@ -201,6 +208,7 @@ static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt,
 	.ip6_mtu_from_fib6 = eafnosupport_ip6_mtu_from_fib6,
 	.fib6_nh_init	   = eafnosupport_fib6_nh_init,
 	.ip6_del_rt	   = eafnosupport_ip6_del_rt,
+	.ipv6_fragment	   = eafnosupport_ipv6_fragment,
 };
 EXPORT_SYMBOL_GPL(ipv6_stub);
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d9a1493..e648fbe 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1027,6 +1027,7 @@ static int ipv6_route_input(struct sk_buff *skb)
 	.xfrm6_rcv_encap = xfrm6_rcv_encap,
 #endif
 	.nd_tbl	= &nd_tbl,
+	.ipv6_fragment = ip6_fragment,
 };
 
 static const struct ipv6_bpf_stub ipv6_bpf_stub_impl = {
-- 
1.8.3.1

