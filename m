Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283D157B2B0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiGTISC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiGTIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:17:55 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09067550B3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:17:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D5BDF20606;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Rzicao6XGkJq; Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E7F420602;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2600280004A;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:17:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:17:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D22FE318042F; Wed, 20 Jul 2022 10:17:49 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] xfrm: no need to set DST_NOPOLICY in IPv4
Date:   Wed, 20 Jul 2022 10:17:42 +0200
Message-ID: <20220720081746.1187382-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720081746.1187382-1-steffen.klassert@secunet.com>
References: <20220720081746.1187382-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

This is a cleanup patch following commit e6175a2ed1f1
("xfrm: fix "disable_policy" flag use when arriving from different devices")
which made DST_NOPOLICY no longer be used for inbound policy checks.

On outbound the flag was set, but never used.

As such, avoid setting it altogether and remove the nopolicy argument
from rt_dst_alloc().

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 drivers/net/vrf.c   |  2 +-
 include/net/route.h |  3 +--
 net/ipv4/route.c    | 24 ++++++++----------------
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 40445a12c682..5df7a0abc39d 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1077,7 +1077,7 @@ static int vrf_rtable_create(struct net_device *dev)
 		return -ENOMEM;
 
 	/* create a dst for routing packets out through a VRF device */
-	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1, 1);
+	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1);
 	if (!rth)
 		return -ENOMEM;
 
diff --git a/include/net/route.h b/include/net/route.h
index 991a3985712d..b6743ff88e30 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -244,8 +244,7 @@ void ip_rt_multicast_event(struct in_device *);
 int ip_rt_ioctl(struct net *, unsigned int cmd, struct rtentry *rt);
 void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
-			     unsigned int flags, u16 type,
-			     bool nopolicy, bool noxfrm);
+			    unsigned int flags, u16 type, bool noxfrm);
 struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt);
 
 struct in_ifaddr;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2d16bcc7d346..bd351fab46e6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1626,12 +1626,11 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			    unsigned int flags, u16 type,
-			    bool nopolicy, bool noxfrm)
+			    bool noxfrm)
 {
 	struct rtable *rt;
 
 	rt = dst_alloc(&ipv4_dst_ops, dev, 1, DST_OBSOLETE_FORCE_CHK,
-		       (nopolicy ? DST_NOPOLICY : 0) |
 		       (noxfrm ? DST_NOXFRM : 0));
 
 	if (rt) {
@@ -1726,7 +1725,6 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	unsigned int flags = RTCF_MULTICAST;
 	struct rtable *rth;
-	bool no_policy;
 	u32 itag = 0;
 	int err;
 
@@ -1737,12 +1735,11 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (our)
 		flags |= RTCF_LOCAL;
 
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   no_policy, false);
+			   false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1801,7 +1798,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache, no_policy;
+	bool do_cache;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1846,8 +1843,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	fnhe = find_exception(nhc, daddr);
@@ -1862,7 +1858,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2237,7 +2233,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
-	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2356,8 +2351,7 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	do_cache &= res->fi && !itag;
@@ -2373,8 +2367,7 @@ out:	return err;
 	}
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
-			   flags | RTCF_LOCAL, res->type,
-			   no_policy, false);
+			   flags | RTCF_LOCAL, res->type, false);
 	if (!rth)
 		goto e_nobufs;
 
@@ -2597,7 +2590,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 
 add:
 	rth = rt_dst_alloc(dev_out, flags, type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
 			   IN_DEV_ORCONF(in_dev, NOXFRM));
 	if (!rth)
 		return ERR_PTR(-ENOBUFS);
-- 
2.25.1

