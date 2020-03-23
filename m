Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB96418F6F5
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCWObZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Mar 2020 10:31:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:22448 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgCWObY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:31:24 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-19-p5QFoRAvMeKRXYB7IiolKg-1; Mon, 23 Mar 2020 14:31:19 +0000
X-MC-Unique: p5QFoRAvMeKRXYB7IiolKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 23 Mar 2020 14:31:19 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 23 Mar 2020 14:31:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     Network Development <netdev@vger.kernel.org>
Subject: [PATCH net-next] Remove DST_HOST
Thread-Topic: [PATCH net-next] Remove DST_HOST
Thread-Index: AdYBH4gs8HTGreJ2SnCmnalhRsiIuQ==
Date:   Mon, 23 Mar 2020 14:31:19 +0000
Message-ID: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous changes to the IP routing code have removed all the
tests for the DS_HOST route flag.
Remove the flags and all the code that sets it.

Signed-off-by: David Laight <david.laight@aculab.com>
---
AFAICT the DST_HOST flag in route table entries hasn't been
looked at since v4.2-rc1.

A quick search failed to find the commit that removed the
tests for it from ipv6/route.c
I suspect other changes got added on top.

NB this may need rebasing.

 drivers/net/vrf.c      |  4 ++--
 include/net/dst.h      |  1 -
 include/net/ip6_fib.h  |  3 +--
 include/net/route.h    |  2 +-
 net/decnet/dn_route.c  |  4 ++--
 net/ipv4/route.c       | 13 +++++--------
 net/ipv6/route.c       |  6 ------
 net/xfrm/xfrm_policy.c |  3 +--
 8 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index b8228f5..66e00dd 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -504,7 +504,7 @@ static void vrf_rt6_release(struct net_device *dev, struct net_vrf *vrf)
 
 static int vrf_rt6_create(struct net_device *dev)
 {
-	int flags = DST_HOST | DST_NOPOLICY | DST_NOXFRM;
+	int flags = DST_NOPOLICY | DST_NOXFRM;
 	struct net_vrf *vrf = netdev_priv(dev);
 	struct net *net = dev_net(dev);
 	struct rt6_info *rt6;
@@ -739,7 +739,7 @@ static int vrf_rtable_create(struct net_device *dev)
 		return -ENOMEM;
 
 	/* create a dst for routing packets out through a VRF device */
-	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1, 1, 0);
+	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1, 1);
 	if (!rth)
 		return -ENOMEM;
 
diff --git a/include/net/dst.h b/include/net/dst.h
index fe62fe2..1442b08 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -35,7 +35,6 @@ struct dst_entry {
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 
 	unsigned short		flags;
-#define DST_HOST		0x0001
 #define DST_NOXFRM		0x0002
 #define DST_NOPOLICY		0x0004
 #define DST_NOCOUNT		0x0008
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 4b5656c..ce52e04 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -165,9 +165,8 @@ struct fib6_info {
 	u8				should_flush:1,
 					dst_nocount:1,
 					dst_nopolicy:1,
-					dst_host:1,
 					fib6_destroying:1,
-					unused:3;
+					unused:4;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
diff --git a/include/net/route.h b/include/net/route.h
index 6c51684..f80079e 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -221,7 +221,7 @@ unsigned int inet_addr_type_dev_table(struct net *net,
 void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			     unsigned int flags, u16 type,
-			     bool nopolicy, bool noxfrm, bool will_cache);
+			     bool nopolicy, bool noxfrm);
 struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt);
 
 struct in_ifaddr;
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index aea9181..ed82040 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1171,7 +1171,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 	if (dev_out->flags & IFF_LOOPBACK)
 		flags |= RTCF_LOCAL;
 
-	rt = dst_alloc(&dn_dst_ops, dev_out, 0, DST_OBSOLETE_NONE, DST_HOST);
+	rt = dst_alloc(&dn_dst_ops, dev_out, 0, DST_OBSOLETE_NONE, 0);
 	if (rt == NULL)
 		goto e_nobufs;
 
@@ -1437,7 +1437,7 @@ static int dn_route_input_slow(struct sk_buff *skb)
 	}
 
 make_route:
-	rt = dst_alloc(&dn_dst_ops, out_dev, 1, DST_OBSOLETE_NONE, DST_HOST);
+	rt = dst_alloc(&dn_dst_ops, out_dev, 1, DST_OBSOLETE_NONE, 0);
 	if (rt == NULL)
 		goto e_nobufs;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 621f834..5134ae4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1618,12 +1618,11 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			    unsigned int flags, u16 type,
-			    bool nopolicy, bool noxfrm, bool will_cache)
+			    bool nopolicy, bool noxfrm)
 {
 	struct rtable *rt;
 
 	rt = dst_alloc(&ipv4_dst_ops, dev, 1, DST_OBSOLETE_FORCE_CHK,
-		       (will_cache ? 0 : DST_HOST) |
 		       (nopolicy ? DST_NOPOLICY : 0) |
 		       (noxfrm ? DST_NOXFRM : 0));
 
@@ -1671,7 +1670,6 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 			new_rt->rt_gw6 = rt->rt_gw6;
 		INIT_LIST_HEAD(&new_rt->rt_uncached);
 
-		new_rt->dst.flags |= DST_HOST;
 		new_rt->dst.input = rt->dst.input;
 		new_rt->dst.output = rt->dst.output;
 		new_rt->dst.error = rt->dst.error;
@@ -1731,7 +1729,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		flags |= RTCF_LOCAL;
 
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false, false);
+			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1848,7 +1846,7 @@ static int __mkroute_input(struct sk_buff *skb,
 
 	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
 			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
-			   IN_DEV_CONF_GET(out_dev, NOXFRM), do_cache);
+			   IN_DEV_CONF_GET(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
 		goto cleanup;
@@ -2177,7 +2175,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false, do_cache);
+			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
 	if (!rth)
 		goto e_nobufs;
 
@@ -2401,8 +2399,7 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 add:
 	rth = rt_dst_alloc(dev_out, flags, type,
 			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
-			   IN_DEV_CONF_GET(in_dev, NOXFRM),
-			   do_cache);
+			   IN_DEV_CONF_GET(in_dev, NOXFRM));
 	if (!rth)
 		return ERR_PTR(-ENOBUFS);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e60bf8e..d5adc3b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1060,8 +1060,6 @@ static unsigned short fib6_info_dst_flags(struct fib6_info *rt)
 		flags |= DST_NOCOUNT;
 	if (rt->dst_nopolicy)
 		flags |= DST_NOPOLICY;
-	if (rt->dst_host)
-		flags |= DST_HOST;
 
 	return flags;
 }
@@ -1347,7 +1345,6 @@ static struct rt6_info *ip6_rt_cache_alloc(const struct fib6_result *res,
 
 	ip6_rt_copy_init(rt, res);
 	rt->rt6i_flags |= RTF_CACHE;
-	rt->dst.flags |= DST_HOST;
 	rt->rt6i_dst.addr = *daddr;
 	rt->rt6i_dst.plen = 128;
 
@@ -3137,7 +3134,6 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 		goto out;
 	}
 
-	rt->dst.flags |= DST_HOST;
 	rt->dst.input = ip6_input;
 	rt->dst.output  = ip6_output;
 	rt->rt6i_gateway  = fl6->daddr;
@@ -3640,8 +3636,6 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 
 	ipv6_addr_prefix(&rt->fib6_dst.addr, &cfg->fc_dst, cfg->fc_dst_len);
 	rt->fib6_dst.plen = cfg->fc_dst_len;
-	if (rt->fib6_dst.plen == 128)
-		rt->dst_host = true;
 
 #ifdef CONFIG_IPV6_SUBTREES
 	ipv6_addr_prefix(&rt->fib6_src.addr, &cfg->fc_src, cfg->fc_src_len);
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f2d1e57..6fc6153 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2610,7 +2610,6 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 		xdst->xfrm_genid = xfrm[i]->genid;
 
 		dst1->obsolete = DST_OBSOLETE_FORCE_CHK;
-		dst1->flags |= DST_HOST;
 		dst1->lastuse = now;
 
 		dst1->input = dst_discard;
@@ -2896,7 +2895,7 @@ static struct xfrm_dst *xfrm_create_dummy_bundle(struct net *net,
 	dst_copy_metrics(dst1, dst);
 
 	dst1->obsolete = DST_OBSOLETE_FORCE_CHK;
-	dst1->flags |= DST_HOST | DST_XFRM_QUEUE;
+	dst1->flags |= DST_XFRM_QUEUE;
 	dst1->lastuse = jiffies;
 
 	dst1->input = dst_discard;
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

