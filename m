Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF90D51F83
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfFYAM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:59 -0400
Received: from mail.us.es ([193.147.175.20]:38014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbfFYAM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5B42C04AC
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5F7ADA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB82FDA708; Tue, 25 Jun 2019 02:12:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9151DA702;
        Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A07744265A2F;
        Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 23/26] netfilter: fix nf_conntrack_bridge/ipv6 link error
Date:   Tue, 25 Jun 2019 02:12:30 +0200
Message-Id: <20190625001233.22057-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_IPV6 is disabled, the bridge netfilter code
produces a link error:

ERROR: "br_ip6_fragment" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!
ERROR: "nf_ct_frag6_gather" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!

The problem is that it assumes that whenever IPV6 is not a loadable
module, we can call the functions direction. This is clearly
not true when IPV6 is disabled.

There are two other functions defined like this in linux/netfilter_ipv6.h,
so change them all the same way.

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 22e6398bc482..7beb681e1ce5 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -75,8 +75,10 @@ static inline int nf_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 		return 1;
 
 	return v6_ops->chk_addr(net, addr, dev, strict);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return ipv6_chk_addr(net, addr, dev, strict);
+#else
+	return 1;
 #endif
 }
 
@@ -113,8 +115,10 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 		return 1;
 
 	return v6_ops->br_defrag(net, skb, user);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return nf_ct_frag6_gather(net, skb, user);
+#else
+	return 1;
 #endif
 }
 
@@ -138,8 +142,10 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 		return 1;
 
 	return v6_ops->br_fragment(net, sk, skb, data, output);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return br_ip6_fragment(net, sk, skb, data, output);
+#else
+	return 1;
 #endif
 }
 
@@ -154,8 +160,10 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 		return -EHOSTUNREACH;
 
 	return v6_ops->route_me_harder(net, skb);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return ip6_route_me_harder(net, skb);
+#else
+	return -EHOSTUNREACH;
 #endif
 }
 
-- 
2.11.0

