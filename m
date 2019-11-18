Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA9100E3D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKRVtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:31 -0500
Received: from correo.us.es ([193.147.175.20]:45694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKRVta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C487EB461
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C0EEB7FF9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 61A60FB362; Mon, 18 Nov 2019 22:49:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D0AED1DBB;
        Mon, 18 Nov 2019 22:49:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6D2C442EE38F;
        Mon, 18 Nov 2019 22:49:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/18] netfilter: ipset: Add wildcard support to net,iface
Date:   Mon, 18 Nov 2019 22:48:57 +0100
Message-Id: <20191118214914.142794-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

The net,iface equal functions currently compares the full interface
names. In several cases, wildcard (or prefix) matching is useful. For
example, when converting a large iptables rule-set to make use of ipset,
I was able to significantly reduce the number of set elements by making
use of wildcard matching.

Wildcard matching is enabled by adding "wildcard" when adding an element
to a set. Internally, this causes the IPSET_FLAG_IFACE_WILDCARD-flag to
be set.  When this flag is set, only the initial part of the interface
name is used for comparison.

Wildcard matching is done per element and not per set, as there are many
cases where mixing wildcard and non-wildcard elements are useful. This
means that is up to the user to handle (avoid) overlapping interface
names.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_hash_netiface.c  | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index eea166c52c36..11a72a938eb1 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -205,6 +205,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_IFACE_WILDCARD = 7,
+	IPSET_FLAG_IFACE_WILDCARD = (1 << IPSET_FLAG_BIT_IFACE_WILDCARD),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 1a04e0929738..be5e95a0d876 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -25,7 +25,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -57,6 +58,7 @@ struct hash_netiface4_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
 
@@ -71,7 +73,9 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) == 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
+		strcmp(ip1->iface, ip2->iface) == 0);
 }
 
 static int
@@ -103,7 +107,8 @@ static bool
 hash_netiface4_data_list(struct sk_buff *skb,
 			 const struct hash_netiface4_elem *data)
 {
-	u32 flags = data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags = (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
@@ -229,6 +234,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard = 1;
 	}
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
@@ -280,6 +287,7 @@ struct hash_netiface6_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
 
@@ -294,7 +302,9 @@ hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) == 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
+		strcmp(ip1->iface, ip2->iface) == 0);
 }
 
 static int
@@ -326,7 +336,8 @@ static bool
 hash_netiface6_data_list(struct sk_buff *skb,
 			 const struct hash_netiface6_elem *data)
 {
-	u32 flags = data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags = (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
@@ -440,6 +451,8 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard = 1;
 	}
 
 	ret = adtfn(set, &e, &ext, &ext, flags);
-- 
2.11.0

