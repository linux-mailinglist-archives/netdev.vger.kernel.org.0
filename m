Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCCC3E2D4B
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbhHFPMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:12:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33776 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbhHFPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:12:15 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 79AFF60057;
        Fri,  6 Aug 2021 17:11:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/9] netfilter: ipset: Limit the maximal range of consecutive elements to add/delete
Date:   Fri,  6 Aug 2021 17:11:41 +0200
Message-Id: <20210806151149.6356-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The range size of consecutive elements were not limited. Thus one could
define a huge range which may result soft lockup errors due to the long
execution time. Now the range size is limited to 2^20 entries.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h       |  3 +++
 net/netfilter/ipset/ip_set_hash_ip.c         |  9 ++++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 +++
 net/netfilter/ipset/ip_set_hash_net.c        | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 +++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 +++++++++++++++-
 11 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 10279c4830ac..ada1296c87d5 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -196,6 +196,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
 
+/* Max range where every element is added/deleted in one step */
+#define IPSET_MAX_RANGE		(1<<20)
+
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
 
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index d1bef23fd4f5..dd30c03d5a23 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -132,8 +132,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -144,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
+	/* 64bit division is not allowed on 32bit */
+	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried) {
 		ip = ntohl(h->next.ip);
 		e.ip = htonl(ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 18346d18aa16..153de3457423 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -121,6 +121,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
+	if (e.mark == 0 && e.ip == 0)
+		return -IPSET_ERR_HASH_ELEM;
 
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -133,8 +135,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (e.mark == 0 && ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -143,6 +148,9 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
+	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index e1ca11196515..7303138e46be 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -173,6 +173,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index ab179e064597..334fb1ad0e86 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -180,6 +180,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 8f075b44cf64..7df94f437f60 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -253,6 +253,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index c1a11f041ac6..1422739d9aa2 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -140,7 +140,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,6 +188,15 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index ddd51c2e1cb3..9810f5bf63f5 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,6 +256,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 6532f0505e66..3d09eefe998a 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -168,7 +168,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
+	u64 n = 0, m = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -244,6 +245,19 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index ec1564a1cb5a..09cf72eb37f8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -158,7 +158,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
+	u64 n = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -235,6 +236,14 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 0e91d1e82f1c..19bcdb3141f6 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -182,7 +182,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
+	u64 n = 0, m = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -284,6 +285,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
-- 
2.20.1

