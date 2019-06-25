Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8951FCA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbfFYAO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:56 -0400
Received: from mail.us.es ([193.147.175.20]:38010 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbfFYAMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37994C04B5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 266DEDA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B129DA708; Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AEDCDA701;
        Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D653E4265A2F;
        Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/26] netfilter: ipset: merge uadd and udel functions
Date:   Tue, 25 Jun 2019 02:12:10 +0200
Message-Id: <20190625001233.22057-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

Both functions are using exactly the same code, except the command value
passed to call_ad function.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 71 +++++++++++----------------------------
 1 file changed, 20 insertions(+), 51 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index faddcf398b73..2ad609900b22 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1561,10 +1561,12 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 	return ret;
 }
 
-static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_ad(struct net *net, struct sock *ctnl,
+		     struct sk_buff *skb,
+		     enum ipset_adt adt,
+		     const struct nlmsghdr *nlh,
+		     const struct nlattr * const attr[],
+		     struct netlink_ext_ack *extack)
 {
 	struct ip_set_net *inst = ip_set_pernet(net);
 	struct ip_set *set;
@@ -1593,7 +1595,7 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	if (attr[IPSET_ATTR_DATA]) {
 		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
-		ret = call_ad(ctnl, skb, set, tb, IPSET_ADD, flags,
+		ret = call_ad(ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
 	} else {
 		int nla_rem;
@@ -1603,7 +1605,7 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			    !flag_nested(nla) ||
 			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
-			ret = call_ad(ctnl, skb, set, tb, IPSET_ADD,
+			ret = call_ad(ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
 			if (ret < 0)
 				return ret;
@@ -1612,55 +1614,22 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	return ret;
 }
 
-static int ip_set_udel(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
+static int ip_set_uadd(struct net *net, struct sock *ctnl,
+		       struct sk_buff *skb, const struct nlmsghdr *nlh,
 		       const struct nlattr * const attr[],
 		       struct netlink_ext_ack *extack)
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
-	struct ip_set *set;
-	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
-	const struct nlattr *nla;
-	u32 flags = flag_exist(nlh);
-	bool use_lineno;
-	int ret = 0;
-
-	if (unlikely(protocol_min_failed(attr) ||
-		     !attr[IPSET_ATTR_SETNAME] ||
-		     !((attr[IPSET_ATTR_DATA] != NULL) ^
-		       (attr[IPSET_ATTR_ADT] != NULL)) ||
-		     (attr[IPSET_ATTR_DATA] &&
-		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
-		     (attr[IPSET_ATTR_ADT] &&
-		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
-		       !attr[IPSET_ATTR_LINENO]))))
-		return -IPSET_ERR_PROTOCOL;
-
-	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (!set)
-		return -ENOENT;
-
-	use_lineno = !!attr[IPSET_ATTR_LINENO];
-	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
-			return -IPSET_ERR_PROTOCOL;
-		ret = call_ad(ctnl, skb, set, tb, IPSET_DEL, flags,
-			      use_lineno);
-	} else {
-		int nla_rem;
+	return ip_set_ad(net, ctnl, skb,
+			 IPSET_ADD, nlh, attr, extack);
+}
 
-		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
-			if (nla_type(nla) != IPSET_ATTR_DATA ||
-			    !flag_nested(nla) ||
-			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
-				return -IPSET_ERR_PROTOCOL;
-			ret = call_ad(ctnl, skb, set, tb, IPSET_DEL,
-				      flags, use_lineno);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return ret;
+static int ip_set_udel(struct net *net, struct sock *ctnl,
+		       struct sk_buff *skb, const struct nlmsghdr *nlh,
+		       const struct nlattr * const attr[],
+		       struct netlink_ext_ack *extack)
+{
+	return ip_set_ad(net, ctnl, skb,
+			 IPSET_DEL, nlh, attr, extack);
 }
 
 static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-- 
2.11.0

