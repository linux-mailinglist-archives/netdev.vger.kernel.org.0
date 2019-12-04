Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD931112D89
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfLDOgY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Dec 2019 09:36:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727990AbfLDOgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:36:23 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-Jj2921x7MgC48wTEzIZ-Og-1; Wed, 04 Dec 2019 09:36:20 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7F8D107ACCA;
        Wed,  4 Dec 2019 14:36:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2C4F5D6BB;
        Wed,  4 Dec 2019 14:36:17 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 2/2] net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
Date:   Wed,  4 Dec 2019 15:35:53 +0100
Message-Id: <960f8d4222f3b76555888dba4b32a8f696eeb422.1575458463.git.sd@queasysnail.net>
In-Reply-To: <cover.1575458463.git.sd@queasysnail.net>
References: <cover.1575458463.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Jj2921x7MgC48wTEzIZ-Og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_stub uses the ip6_dst_lookup function to allow other modules to
perform IPv6 lookups. However, this function skips the XFRM layer
entirely.

All users of ipv6_stub->ip6_dst_lookup use ip_route_output_flow (via the
ip_route_output_key and ip_route_output helpers) for their IPv4 lookups,
which calls xfrm_lookup_route(). This patch fixes this inconsistent
behavior by switching the stub to ip6_dst_lookup_flow, which also calls
xfrm_lookup_route().

This requires some changes in all the callers, as these two functions
take different arguments and have different return types.

Fixes: 5f81bd2e5d80 ("ipv6: export a stub for IPv6 symbols used by vxlan")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/infiniband/core/addr.c                      |  7 +++----
 drivers/infiniband/sw/rxe/rxe_net.c                 |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |  8 ++++----
 drivers/net/geneve.c                                |  4 +++-
 drivers/net/vxlan.c                                 |  8 +++-----
 include/net/ipv6_stubs.h                            |  6 ++++--
 net/core/lwt_bpf.c                                  |  4 +---
 net/ipv6/addrconf_core.c                            | 11 ++++++-----
 net/ipv6/af_inet6.c                                 |  2 +-
 net/mpls/af_mpls.c                                  |  7 +++----
 net/tipc/udp_media.c                                |  9 ++++++---
 11 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 6d7ec371e7b2..606fa6d86685 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -421,16 +421,15 @@ static int addr6_resolve(struct sockaddr *src_sock,
 				(const struct sockaddr_in6 *)dst_sock;
 	struct flowi6 fl6;
 	struct dst_entry *dst;
-	int ret;
 
 	memset(&fl6, 0, sizeof fl6);
 	fl6.daddr = dst_in->sin6_addr;
 	fl6.saddr = src_in->sin6_addr;
 	fl6.flowi6_oif = addr->bound_dev_if;
 
-	ret = ipv6_stub->ipv6_dst_lookup(addr->net, NULL, &dst, &fl6);
-	if (ret < 0)
-		return ret;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(addr->net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	if (ipv6_addr_any(&src_in->sin6_addr))
 		src_in->sin6_addr = fl6.saddr;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 5a3474f9351b..312c2fc961c0 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -117,10 +117,12 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	if (unlikely(ipv6_stub->ipv6_dst_lookup(sock_net(recv_sockets.sk6->sk),
-						recv_sockets.sk6->sk, &ndst, &fl6))) {
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(recv_sockets.sk6->sk),
+					       recv_sockets.sk6->sk, &fl6,
+					       NULL);
+	if (unlikely(IS_ERR(ndst))) {
 		pr_err_ratelimited("no route to %pI6\n", daddr);
-		goto put;
+		return NULL;
 	}
 
 	if (unlikely(ndst->error)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 6ed87534d314..c754987278a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -297,10 +297,10 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 
 	int ret;
 
-	ret = ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
-					 fl6);
-	if (ret < 0)
-		return ret;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, fl6,
+					      NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	if (!(*out_ttl))
 		*out_ttl = ip6_dst_hoplimit(dst);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 3ab24fdccd3b..5c6b7fc04ea6 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -853,7 +853,9 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		if (dst)
 			return dst;
 	}
-	if (ipv6_stub->ipv6_dst_lookup(geneve->net, gs6->sock->sk, &dst, fl6)) {
+	dst = ipv6_stub->ipv6_dst_lookup_flow(geneve->net, gs6->sock->sk, fl6,
+					      NULL);
+	if (IS_ERR(dst)) {
 		netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index bf04bc2e68c2..4c34375c2e22 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2275,7 +2275,6 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct dst_entry *ndst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!sock6)
 		return ERR_PTR(-EIO);
@@ -2298,10 +2297,9 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.fl6_dport = dport;
 	fl6.fl6_sport = sport;
 
-	err = ipv6_stub->ipv6_dst_lookup(vxlan->net,
-					 sock6->sock->sk,
-					 &ndst, &fl6);
-	if (unlikely(err < 0)) {
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, sock6->sock->sk,
+					       &fl6, NULL);
+	if (unlikely(IS_ERR(ndst))) {
 		netdev_dbg(dev, "no route to %pI6\n", daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 5c93e942c50b..3e7d2c0e79ca 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -24,8 +24,10 @@ struct ipv6_stub {
 				 const struct in6_addr *addr);
 	int (*ipv6_sock_mc_drop)(struct sock *sk, int ifindex,
 				 const struct in6_addr *addr);
-	int (*ipv6_dst_lookup)(struct net *net, struct sock *sk,
-			       struct dst_entry **dst, struct flowi6 *fl6);
+	struct dst_entry *(*ipv6_dst_lookup_flow)(struct net *net,
+						  const struct sock *sk,
+						  struct flowi6 *fl6,
+						  const struct in6_addr *final_dst);
 	int (*ipv6_route_input)(struct sk_buff *skb);
 
 	struct fib6_table *(*fib6_get_table)(struct net *net, u32 id);
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 74cfb8b5ab33..99a6de52b21d 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -230,9 +230,7 @@ static int bpf_lwt_xmit_reroute(struct sk_buff *skb)
 		fl6.daddr = iph6->daddr;
 		fl6.saddr = iph6->saddr;
 
-		err = ipv6_stub->ipv6_dst_lookup(net, skb->sk, &dst, &fl6);
-		if (unlikely(err))
-			goto err;
+		dst = ipv6_stub->ipv6_dst_lookup_flow(net, skb->sk, &fl6, NULL);
 		if (IS_ERR(dst)) {
 			err = PTR_ERR(dst);
 			goto err;
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 2fc079284ca4..ea00ce3d4117 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -129,11 +129,12 @@ int inet6addr_validator_notifier_call_chain(unsigned long val, void *v)
 }
 EXPORT_SYMBOL(inet6addr_validator_notifier_call_chain);
 
-static int eafnosupport_ipv6_dst_lookup(struct net *net, struct sock *u1,
-					struct dst_entry **u2,
-					struct flowi6 *u3)
+static struct dst_entry *eafnosupport_ipv6_dst_lookup_flow(struct net *net,
+							   const struct sock *sk,
+							   struct flowi6 *fl6,
+							   const struct in6_addr *final_dst)
 {
-	return -EAFNOSUPPORT;
+	return ERR_PTR(-EAFNOSUPPORT);
 }
 
 static int eafnosupport_ipv6_route_input(struct sk_buff *skb)
@@ -190,7 +191,7 @@ static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt)
 }
 
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
-	.ipv6_dst_lookup   = eafnosupport_ipv6_dst_lookup,
+	.ipv6_dst_lookup_flow = eafnosupport_ipv6_dst_lookup_flow,
 	.ipv6_route_input  = eafnosupport_ipv6_route_input,
 	.fib6_get_table    = eafnosupport_fib6_get_table,
 	.fib6_table_lookup = eafnosupport_fib6_table_lookup,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e84e8b1ffbc7..d727c3b41495 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -946,7 +946,7 @@ static int ipv6_route_input(struct sk_buff *skb)
 static const struct ipv6_stub ipv6_stub_impl = {
 	.ipv6_sock_mc_join = ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop = ipv6_sock_mc_drop,
-	.ipv6_dst_lookup   = ip6_dst_lookup,
+	.ipv6_dst_lookup_flow = ip6_dst_lookup_flow,
 	.ipv6_route_input  = ipv6_route_input,
 	.fib6_get_table	   = fib6_get_table,
 	.fib6_table_lookup = fib6_table_lookup,
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index c312741df2ce..4701edffb1f7 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -617,16 +617,15 @@ static struct net_device *inet6_fib_lookup_dev(struct net *net,
 	struct net_device *dev;
 	struct dst_entry *dst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!ipv6_stub)
 		return ERR_PTR(-EAFNOSUPPORT);
 
 	memset(&fl6, 0, sizeof(fl6));
 	memcpy(&fl6.daddr, addr, sizeof(struct in6_addr));
-	err = ipv6_stub->ipv6_dst_lookup(net, NULL, &dst, &fl6);
-	if (err)
-		return ERR_PTR(err);
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return ERR_CAST(dst);
 
 	dev = dst->dev;
 	dev_hold(dev);
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 86aaa4d3e781..ed113735c019 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -195,10 +195,13 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 				.saddr = src->ipv6,
 				.flowi6_proto = IPPROTO_UDP
 			};
-			err = ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk,
-							 &ndst, &fl6);
-			if (err)
+			ndst = ipv6_stub->ipv6_dst_lookup_flow(net,
+							       ub->ubsock->sk,
+							       &fl6, NULL);
+			if (IS_ERR(ndst)) {
+				err = PTR_ERR(ndst);
 				goto tx_error;
+			}
 			dst_cache_set_ip6(cache, ndst, &fl6.saddr);
 		}
 		ttl = ip6_dst_hoplimit(ndst);
-- 
2.23.0

