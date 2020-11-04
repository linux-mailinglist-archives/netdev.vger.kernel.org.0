Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A812A660B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgKDOMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:12:09 -0500
Received: from correo.us.es ([193.147.175.20]:35798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgKDOMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC932B60CB
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9099BDA704
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 860FEDA792; Wed,  4 Nov 2020 15:12:02 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C16DDA84A;
        Wed,  4 Nov 2020 15:11:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:11:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4F4D442EF9E0;
        Wed,  4 Nov 2020 15:11:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/8] netfilter: ipset: Add bucketsize parameter to all hash types
Date:   Wed,  4 Nov 2020 15:11:46 +0100
Message-Id: <20201104141149.30082-6-pablo@netfilter.org>
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

The parameter defines the upper limit in any hash bucket at adding new entries
from userspace - if the limit would be exceeded, ipset doubles the hash size
and rehashes. It means the set may consume more memory but gives faster
evaluation at matching in the set.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h       |  5 +++
 include/uapi/linux/netfilter/ipset/ip_set.h  |  4 ++-
 net/netfilter/ipset/ip_set_core.c            |  2 ++
 net/netfilter/ipset/ip_set_hash_gen.h        | 38 ++++++++++++--------
 net/netfilter/ipset/ip_set_hash_ip.c         |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  5 +--
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  6 ++--
 net/netfilter/ipset/ip_set_hash_mac.c        |  5 +--
 net/netfilter/ipset/ip_set_hash_net.c        |  6 ++--
 net/netfilter/ipset/ip_set_hash_netiface.c   |  6 ++--
 net/netfilter/ipset/ip_set_hash_netnet.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_netport.c    |  6 ++--
 net/netfilter/ipset/ip_set_hash_netportnet.c |  6 ++--
 16 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ab192720e2d6..46d9a0c26c67 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -198,6 +198,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
 
+/* The max revision number supported by any set type + 1 */
+#define IPSET_REVISION_MAX	9
+
 /* The core set type structure */
 struct ip_set_type {
 	struct list_head list;
@@ -215,6 +218,8 @@ struct ip_set_type {
 	u8 family;
 	/* Type revisions */
 	u8 revision_min, revision_max;
+	/* Revision-specific supported (create) flags */
+	u8 create_flags[IPSET_REVISION_MAX+1];
 	/* Set features to control swapping */
 	u16 features;
 
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 11a72a938eb1..398f7b909b7d 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -96,7 +96,7 @@ enum {
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
 	IPSET_ATTR_NETMASK,
-	IPSET_ATTR_PROBES,
+	IPSET_ATTR_BUCKETSIZE,	/* was unused IPSET_ATTR_PROBES */
 	IPSET_ATTR_RESIZE,
 	IPSET_ATTR_SIZE,
 	/* Kernel-only */
@@ -214,6 +214,8 @@ enum ipset_cadt_flags {
 enum ipset_create_flags {
 	IPSET_CREATE_FLAG_BIT_FORCEADD = 0,
 	IPSET_CREATE_FLAG_FORCEADD = (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
+	IPSET_CREATE_FLAG_BIT_BUCKETSIZE = 1,
+	IPSET_CREATE_FLAG_BUCKETSIZE = (1 << IPSET_CREATE_FLAG_BIT_BUCKETSIZE),
 	IPSET_CREATE_FLAG_BIT_MAX = 7,
 };
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e3c00dacec5c..e76bfca2d3ef 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1109,6 +1109,8 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 		ret = -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
+	/* Set create flags depending on the type revision */
+	set->flags |= set->type->create_flags[revision];
 
 	ret = set->type->create(net, set, tb, flags);
 	if (ret != 0)
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 521e970be402..4e3544442b26 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -37,18 +37,18 @@
  */
 
 /* Number of elements to store in an initial array block */
-#define AHASH_INIT_SIZE			4
+#define AHASH_INIT_SIZE			2
 /* Max number of elements to store in an array block */
-#define AHASH_MAX_SIZE			(3 * AHASH_INIT_SIZE)
+#define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
 /* Max muber of elements in the array block when tuned */
 #define AHASH_MAX_TUNED			64
 
+#define AHASH_MAX(h)			((h)->bucketsize)
+
 /* Max number of elements can be tuned */
 #ifdef IP_SET_HASH_WITH_MULTI
-#define AHASH_MAX(h)			((h)->ahash_max)
-
 static u8
-tune_ahash_max(u8 curr, u32 multi)
+tune_bucketsize(u8 curr, u32 multi)
 {
 	u32 n;
 
@@ -61,12 +61,10 @@ tune_ahash_max(u8 curr, u32 multi)
 	 */
 	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
-
-#define TUNE_AHASH_MAX(h, multi)	\
-	((h)->ahash_max = tune_ahash_max((h)->ahash_max, multi))
+#define TUNE_BUCKETSIZE(h, multi)	\
+	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
 #else
-#define AHASH_MAX(h)			AHASH_MAX_SIZE
-#define TUNE_AHASH_MAX(h, multi)
+#define TUNE_BUCKETSIZE(h, multi)
 #endif
 
 /* A hash bucket */
@@ -321,9 +319,7 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
-#ifdef IP_SET_HASH_WITH_MULTI
-	u8 ahash_max;		/* max elements in an array block */
-#endif
+	u8 bucketsize;		/* max elements in an array block */
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
 #endif
@@ -950,7 +946,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >= n->size) {
-		TUNE_AHASH_MAX(h, multi);
+		TUNE_BUCKETSIZE(h, multi);
 		if (n->size >= AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);
@@ -1305,6 +1301,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
 		goto nla_put_failure;
 #endif
+	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE &&
+	    nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize))
+		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
 	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(elements)))
@@ -1548,7 +1547,16 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	h->markmask = markmask;
 #endif
 	get_random_bytes(&h->initval, sizeof(h->initval));
-
+	h->bucketsize = AHASH_MAX_SIZE;
+	if (tb[IPSET_ATTR_BUCKETSIZE]) {
+		h->bucketsize = nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
+		if (h->bucketsize < AHASH_INIT_SIZE)
+			h->bucketsize = AHASH_INIT_SIZE;
+		else if (h->bucketsize > AHASH_MAX_SIZE)
+			h->bucketsize = AHASH_MAX_SIZE;
+		else if (h->bucketsize % 2)
+			h->bucketsize += 1;
+	}
 	t->htable_bits = hbits;
 	t->maxelem = h->maxelem / ahash_numof_locks(hbits);
 	RCU_INIT_POINTER(h->table, t);
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 5d6d68eaf6a9..0495d515c498 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -23,7 +23,8 @@
 /*				1	   Counters support */
 /*				2	   Comments support */
 /*				3	   Forceadd support */
-#define IPSET_TYPE_REV_MAX	4	/* skbinfo support  */
+/*				4	   skbinfo support */
+#define IPSET_TYPE_REV_MAX	5	/* bucketsize support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -277,11 +278,12 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ip_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index eceb7bc4a93a..2655501f9fe3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Chilinski <tomasz.chilinski@chilan.com>");
@@ -268,11 +268,12 @@ static struct ip_set_type hash_ipmac_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ipmac_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index aba1df617d6e..5bbed85d0e47 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -21,7 +21,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support */
-#define IPSET_TYPE_REV_MAX	2	/* skbinfo support  */
+/*				2	   skbinfo support */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
@@ -274,12 +275,13 @@ static struct ip_set_type hash_ipmark_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ipmark_create,
 	.create_policy	= {
 		[IPSET_ATTR_MARKMASK]	= { .type = NLA_U32 },
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 1ff228717e29..c1ac2e89e2d3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -25,7 +25,8 @@
 /*				2    Counters support added */
 /*				3    Comments support added */
 /*				4    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
+/*				5    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -341,11 +342,12 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ipport_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index fa88afd812fa..d3f4a672986e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -25,7 +25,8 @@
 /*				2    Counters support added */
 /*				3    Comments support added */
 /*				4    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
+/*				5    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -356,11 +357,12 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ipportip_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index eef6ecfcb409..8f7fe360736a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -27,7 +27,8 @@
 /*				4    Counters support added */
 /*				5    Comments support added */
 /*				6    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
+/*				7    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -513,11 +514,12 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_ipportnet_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 0b61593165ef..00dd7e20df3c 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -125,11 +125,12 @@ static struct ip_set_type hash_mac_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_mac_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 136cf0781d3a..d366e816b6ed 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -24,7 +24,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo mapping support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -354,11 +355,12 @@ static struct ip_set_type hash_net_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_net_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..38b1d77584d4 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -26,7 +26,8 @@
 /*				4    Comments support added */
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
+/*				7    interface wildcard support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -470,11 +471,12 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_netiface_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index da4ef910b12d..0cc7970f36e9 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -22,7 +22,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
-#define IPSET_TYPE_REV_MAX	2	/* skbinfo support added */
+/*				2	   skbinfo support added */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -459,11 +460,12 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_netnet_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 34448df80fb9..b356d7d85e34 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -26,7 +26,8 @@
 /*				4    Counters support added */
 /*				5    Comments support added */
 /*				6    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
+/*				7    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -460,11 +461,12 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_netport_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 934c1712cba8..eeb39688f26f 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -23,7 +23,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				0    Comments support added */
 /*				1    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	2 /* skbinfo support added */
+/*				2    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	3 /* bucketsize support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -558,11 +559,12 @@ static struct ip_set_type hash_netportnet_type __read_mostly = {
 	.family		= NFPROTO_UNSPEC,
 	.revision_min	= IPSET_TYPE_REV_MIN,
 	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		= hash_netportnet_create,
 	.create_policy	= {
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
-		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
-- 
2.20.1

