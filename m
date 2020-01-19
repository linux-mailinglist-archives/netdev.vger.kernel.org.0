Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08210142017
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 22:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgASVGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 16:06:55 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:57395 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbgASVGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 16:06:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 7BC2B67400D7;
        Sun, 19 Jan 2020 22:06:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1579468010; x=1581282411; bh=Zl1tVs4+aH1J5s1xxsluuPXRl/TtucpGu08
        Xy5u6MY4=; b=BsrWEb1ZNQ4MavQoXz4H+JviaDSMQSanYUekbCb2fHzEyjhRK4q
        0pnqHuVZX83VvRL7kvuDF7ty3hmS1BJCykj3u75LSKKMy1/DmHYtojn5FZ82JhvG
        3pEYgQmd1DbSk1vR/t1FArilWEF2JMgRJoafEorMi40RHGn1DzRRPXHc=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun, 19 Jan 2020 22:06:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 421A967400C5;
        Sun, 19 Jan 2020 22:06:50 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 142C4215E9; Sun, 19 Jan 2020 22:06:50 +0100 (CET)
Date:   Sun, 19 Jan 2020 22:06:49 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     syzbot <syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com>
cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH 1/1] netfilter: ipset: use bitmap infrastructure completely
Message-ID: <alpine.DEB.2.20.2001192203200.18095@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bitmap allocation did not use full unsigned long sizes
when calculating the required size and that was triggered by KASAN
as slab-out-of-bounds read in several places. The patch fixes all
of them.

Reported-by: syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com
Reported-by: syzbot+827ced406c9a1d9570ed@syzkaller.appspotmail.com
Reported-by: syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com
Reported-by: syzbot+dfccdb2bdb4a12ad425e@syzkaller.appspotmail.com
Reported-by: syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com
Reported-by: syzbot+b08bd19bb37513357fd4@syzkaller.appspotmail.com
Reported-by: syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h    | 7 -------
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 6 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 6 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c  | 6 +++---
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 4d8b1eaf7708..908d38dbcb91 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -426,13 +426,6 @@ ip6addrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
 	       sizeof(*addr));
 }
 
-/* Calculate the bytes required to store the inclusive range of a-b */
-static inline int
-bitmap_bytes(u32 a, u32 b)
-{
-	return 4 * ((((b - a + 8) / 8) + 3) / 4);
-}
-
 /* How often should the gc be run by default */
 #define IPSET_GC_TIME			(3 * 60)
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 077a2cb65fcb..26ab0e9612d8 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -75,7 +75,7 @@ mtype_flush(struct ip_set *set)
 
 	if (set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
-	memset(map->members, 0, map->memsize);
+	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
 	set->ext_size = 0;
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index abe8f77d7d23..0a2196f59106 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -37,7 +37,7 @@ MODULE_ALIAS("ip_set_bitmap:ip");
 
 /* Type structure */
 struct bitmap_ip {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -220,7 +220,7 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	    u32 first_ip, u32 last_ip,
 	    u32 elements, u32 hosts, u8 netmask)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -322,7 +322,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ip;
 	if (!init_map_ip(set, map, first_ip, last_ip,
 			 elements, hosts, netmask)) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index b618713297da..739e343efaf6 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -42,7 +42,7 @@ enum {
 
 /* Type structure */
 struct bitmap_ipmac {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -299,7 +299,7 @@ static bool
 init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	       u32 first_ip, u32 last_ip, u32 elements)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -360,7 +360,7 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ipmac;
 	if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
 		kfree(map);
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 23d6095cb196..b49978dd810d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -30,7 +30,7 @@ MODULE_ALIAS("ip_set_bitmap:port");
 
 /* Type structure */
 struct bitmap_port {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u16 first_port;		/* host byte order, included in range */
 	u16 last_port;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -231,7 +231,7 @@ static bool
 init_map_port(struct ip_set *set, struct bitmap_port *map,
 	      u16 first_port, u16 last_port)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(map->elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_port = first_port;
@@ -271,7 +271,7 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		return -ENOMEM;
 
 	map->elements = elements;
-	map->memsize = bitmap_bytes(0, map->elements);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_port;
 	if (!init_map_port(set, map, first_port, last_port)) {
 		kfree(map);
-- 
2.20.1

