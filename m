Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36F65B53B
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbjABQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 11:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbjABQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 11:40:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F379CAE73;
        Mon,  2 Jan 2023 08:40:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 7/7] netfilter: ipset: Rework long task execution when adding/deleting entries
Date:   Mon,  2 Jan 2023 17:40:25 +0100
Message-Id: <20230102164025.125995-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230102164025.125995-1-pablo@netfilter.org>
References: <20230102164025.125995-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

When adding/deleting large number of elements in one step in ipset, it can
take a reasonable amount of time and can result in soft lockup errors. The
patch 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of
consecutive elements to add/delete") tried to fix it by limiting the max
elements to process at all. However it was not enough, it is still possible
that we get hung tasks. Lowering the limit is not reasonable, so the
approach in this patch is as follows: rely on the method used at resizing
sets and save the state when we reach a smaller internal batch limit,
unlock/lock and proceed from the saved state. Thus we can avoid long
continuous tasks and at the same time removed the limit to add/delete large
number of elements in one step.

The nfnl mutex is held during the whole operation which prevents one to
issue other ipset commands in parallel.

Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: syzbot+9204e7399656300bf271@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h      |  2 +-
 net/netfilter/ipset/ip_set_core.c           |  7 ++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 14 ++++++-------
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipport.c    | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 13 ++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 13 +++++++-----
 net/netfilter/ipset/ip_set_hash_net.c       | 17 +++++++--------
 net/netfilter/ipset/ip_set_hash_netiface.c  | 15 ++++++--------
 net/netfilter/ipset/ip_set_hash_netnet.c    | 23 +++++++--------------
 net/netfilter/ipset/ip_set_hash_netport.c   | 19 +++++++----------
 11 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ab934ad951a8..e8c350a3ade1 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -197,7 +197,7 @@ struct ip_set_region {
 };
 
 /* Max range where every element is added/deleted in one step */
-#define IPSET_MAX_RANGE		(1<<20)
+#define IPSET_MAX_RANGE		(1<<14)
 
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e7ba5b6dd2b7..46ebee9400da 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1698,9 +1698,10 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
 		retried = true;
-	} while (ret == -EAGAIN &&
-		 set->variant->resize &&
-		 (ret = set->variant->resize(set, retried)) == 0);
+	} while (ret == -ERANGE ||
+		 (ret == -EAGAIN &&
+		  set->variant->resize &&
+		  (ret = set->variant->resize(set, retried)) == 0));
 
 	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index e30513cefd90..c9f4e3859663 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -100,11 +100,11 @@ static int
 hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ip4 *h = set->data;
+	struct hash_ip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ip4_elem e = { 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, hosts;
+	u32 ip = 0, ip_to = 0, hosts, i = 0;
 	int ret = 0;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -149,14 +149,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
-	/* 64bit division is not allowed on 32bit */
-	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to;) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ip4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 153de3457423..a22ec1a6f6ec 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -97,11 +97,11 @@ static int
 hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipmark4 *h = set->data;
+	struct hash_ipmark4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0;
+	u32 ip, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -148,13 +148,14 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to; ip++, i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ipmark4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 2ffbd0b78a8c..e977b5a9c48d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -112,11 +112,11 @@ static int
 hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipport4 *h = set->data;
+	struct hash_ipport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -184,17 +184,18 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 334fb1ad0e86..39a01934b153 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -108,11 +108,11 @@ static int
 hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportip4 *h = set->data;
+	struct hash_ipportip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -180,17 +180,18 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipportip4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 7df94f437f60..5c6de605a9fb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -160,12 +160,12 @@ static int
 hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportnet4 *h = set->data;
+	struct hash_ipportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -253,9 +253,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
@@ -282,9 +279,15 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip2 = htonl(ip2);
 				ip2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr);
 				e.cidr = cidr - 1;
+				if (i > IPSET_MAX_RANGE) {
+					hash_ipportnet4_data_next(&h->next,
+								  &e);
+					return -ERANGE;
+				}
 				ret = adtfn(set, &e, &ext, &ext, flags);
 
 				if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 1422739d9aa2..ce0a9ce5a91f 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -136,11 +136,11 @@ static int
 hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_net4 *h = set->data;
+	struct hash_net4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,19 +188,16 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_net4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 9810f5bf63f5..031073286236 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,19 +256,16 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_netiface4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index cdfb78c6e0d3..8fbe649c9dd3 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -166,13 +166,12 @@ static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netnet4 *h = set->data;
+	struct hash_netnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -248,19 +247,6 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -273,7 +259,12 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip[0] = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		do {
+			i++;
 			e.ip[1] = htonl(ip2);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netnet4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ip2 = ip_set_range_to_cidr(ip2, ip2_to, &e.cidr[1]);
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 09cf72eb37f8..d1a0628df4ef 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -154,12 +154,11 @@ static int
 hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netport4 *h = set->data;
+	struct hash_netport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
-	u64 n = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -236,14 +235,6 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
@@ -255,8 +246,12 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &cidr);
 		e.cidr = cidr - 1;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-- 
2.30.2

