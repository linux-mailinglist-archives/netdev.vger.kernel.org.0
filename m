Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA851FB5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfFYAOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:22 -0400
Received: from mail.us.es ([193.147.175.20]:38020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbfFYAMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7362C04B7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8E77DA709
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE6B6DA706; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4975DA701;
        Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 77F554265A2F;
        Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/26] netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
Date:   Tue, 25 Jun 2019 02:12:22 +0200
Message-Id: <20190625001233.22057-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

This is a prerequisite for the infrastructure module NETFILTER_SYNPROXY.
The new module is needed to avoid duplicated code for the SYNPROXY
nftables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h | 36 ++++++++++++++++++++++++++++++++++++
 net/ipv6/netfilter.c           |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3a3dc4b1f0e7..35b12525ee45 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -8,6 +8,7 @@
 #define __LINUX_IP6_NETFILTER_H
 
 #include <uapi/linux/netfilter_ipv6.h>
+#include <net/tcp.h>
 
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
@@ -35,6 +36,10 @@ struct nf_ipv6_ops {
 		       struct in6_addr *saddr);
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
+	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
+				    const struct tcphdr *th, u16 *mssp);
+	int (*cookie_v6_check)(const struct ipv6hdr *iph,
+			       const struct tcphdr *th, __u32 cookie);
 #endif
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
@@ -154,6 +159,37 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 #endif
 }
 
+static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
+					       const struct tcphdr *th,
+					       u16 *mssp)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (v6_ops)
+		return v6_ops->cookie_init_sequence(iph, th, mssp);
+
+	return 0;
+#else
+	return __cookie_v6_init_sequence(iph, th, mssp);
+#endif
+}
+
+static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
+				     const struct tcphdr *th, __u32 cookie)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (v6_ops)
+		return v6_ops->cookie_v6_check(iph, th, cookie);
+
+	return 0;
+#else
+	return __cookie_v6_check(iph, th, cookie);
+#endif
+}
+
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 86048dce301b..dffb10fdc3e8 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -234,6 +234,8 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+	.cookie_init_sequence	= __cookie_v6_init_sequence,
+	.cookie_v6_check	= __cookie_v6_check,
 #endif
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
-- 
2.11.0

