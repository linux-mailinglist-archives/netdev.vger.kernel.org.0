Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744291B364
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfEMJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:56:57 -0400
Received: from mail.us.es ([193.147.175.20]:34204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbfEMJ4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 414204DE72E
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FE45DA705
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2EC6DDA710; Mon, 13 May 2019 11:56:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1346FDA705;
        Mon, 13 May 2019 11:56:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DAD164265A31;
        Mon, 13 May 2019 11:56:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/13] netfilter: nf_conntrack_h323: Remove deprecated config check
Date:   Mon, 13 May 2019 11:56:26 +0200
Message-Id: <20190513095630.32443-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

CONFIG_NF_CONNTRACK_IPV6 has been deprecated so replace it with a check
for IPV6 instead.

Use nf_ip6_route6() instead of v6ops->route() and keep the IS_MODULE()
in nf_ipv6_ops as mentioned by Florian so that direct calls are used
when IPV6 is builtin and indirect calls are used only when IPV6 is a
module.

Fixes: a0ae2562c6c4b2 ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_h323_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 005589c6d0f6..12de40390e97 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -748,24 +748,19 @@ static int callforward_do_filter(struct net *net,
 		}
 		break;
 	}
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6: {
-		const struct nf_ipv6_ops *v6ops;
 		struct rt6_info *rt1, *rt2;
 		struct flowi6 fl1, fl2;
 
-		v6ops = nf_get_ipv6_ops();
-		if (!v6ops)
-			return 0;
-
 		memset(&fl1, 0, sizeof(fl1));
 		fl1.daddr = src->in6;
 
 		memset(&fl2, 0, sizeof(fl2));
 		fl2.daddr = dst->in6;
-		if (!v6ops->route(net, (struct dst_entry **)&rt1,
+		if (!nf_ip6_route(net, (struct dst_entry **)&rt1,
 				  flowi6_to_flowi(&fl1), false)) {
-			if (!v6ops->route(net, (struct dst_entry **)&rt2,
+			if (!nf_ip6_route(net, (struct dst_entry **)&rt2,
 					  flowi6_to_flowi(&fl2), false)) {
 				if (ipv6_addr_equal(rt6_nexthop(rt1, &fl1.daddr),
 						    rt6_nexthop(rt2, &fl2.daddr)) &&
-- 
2.11.0

