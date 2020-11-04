Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B992A6611
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgKDOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:12:16 -0500
Received: from correo.us.es ([193.147.175.20]:35804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbgKDOMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFC95B60EF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD008DA792
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1D6ADA78A; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D2EADA793;
        Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:12:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E21BB42EF9E0;
        Wed,  4 Nov 2020 15:11:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/8] netfilter: ipset: Expose the initval hash parameter to userspace
Date:   Wed,  4 Nov 2020 15:11:47 +0100
Message-Id: <20201104141149.30082-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

It makes possible to reproduce exactly the same set after a save/restore.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/ipset/ip_set.h  |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 13 +++++++++----
 net/netfilter/ipset/ip_set_hash_ip.c         |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 ++-
 net/netfilter/ipset/ip_set_hash_mac.c        |  3 ++-
 net/netfilter/ipset/ip_set_hash_net.c        |  3 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  3 ++-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_netport.c    |  3 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  3 ++-
 14 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 398f7b909b7d..6397d75899bc 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -92,7 +92,7 @@ enum {
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
-	IPSET_ATTR_GC,
+	IPSET_ATTR_INITVAL,	/* was unused IPSET_ATTR_GC */
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
 	IPSET_ATTR_NETMASK,
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 4e3544442b26..5f1208ad049e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1301,9 +1301,11 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
 		goto nla_put_failure;
 #endif
-	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE &&
-	    nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize))
-		goto nla_put_failure;
+	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE) {
+		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize) ||
+		    nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
+			goto nla_put_failure;
+	}
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
 	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(elements)))
@@ -1546,7 +1548,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	h->markmask = markmask;
 #endif
-	get_random_bytes(&h->initval, sizeof(h->initval));
+	if (tb[IPSET_ATTR_INITVAL])
+		h->initval = ntohl(nla_get_be32(tb[IPSET_ATTR_INITVAL]));
+	else
+		get_random_bytes(&h->initval, sizeof(h->initval));
 	h->bucketsize = AHASH_MAX_SIZE;
 	if (tb[IPSET_ATTR_BUCKETSIZE]) {
 		h->bucketsize = nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 0495d515c498..d1bef23fd4f5 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,7 @@
 /*				2	   Comments support */
 /*				3	   Forceadd support */
 /*				4	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	5	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -283,6 +283,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 2655501f9fe3..467c59a83c0a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize, initval support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Chilinski <tomasz.chilinski@chilan.com>");
@@ -273,6 +273,7 @@ static struct ip_set_type hash_ipmac_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 5bbed85d0e47..18346d18aa16 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -22,7 +22,7 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support */
 /*				2	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
@@ -281,6 +281,7 @@ static struct ip_set_type hash_ipmark_type __read_mostly = {
 		[IPSET_ATTR_MARKMASK]	= { .type = NLA_U32 },
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index c1ac2e89e2d3..e1ca11196515 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,7 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -347,6 +347,7 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index d3f4a672986e..ab179e064597 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -26,7 +26,7 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -362,6 +362,7 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 8f7fe360736a..8f075b44cf64 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -28,7 +28,7 @@
 /*				5    Comments support added */
 /*				6    Forceadd support added */
 /*				7    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -519,6 +519,7 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 00dd7e20df3c..718814730acf 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* bucketsize support */
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize, initval support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -130,6 +130,7 @@ static struct ip_set_type hash_mac_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index d366e816b6ed..c1a11f041ac6 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -25,7 +25,7 @@
 /*				4    Comments support added */
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	7 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	7 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -360,6 +360,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 38b1d77584d4..3d74169b794c 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -27,7 +27,7 @@
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
 /*				7    interface wildcard support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -476,6 +476,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 0cc7970f36e9..6532f0505e66 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -23,7 +23,7 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
 /*				2	   skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -465,6 +465,7 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index b356d7d85e34..ec1564a1cb5a 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -27,7 +27,7 @@
 /*				5    Comments support added */
 /*				6    Forceadd support added */
 /*				7    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -466,6 +466,7 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index eeb39688f26f..0e91d1e82f1c 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -24,7 +24,7 @@
 /*				0    Comments support added */
 /*				1    Forceadd support added */
 /*				2    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	3 /* bucketsize, initval support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -564,6 +564,7 @@ static struct ip_set_type hash_netportnet_type __read_mostly = {
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
-- 
2.20.1

