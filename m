Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B912262C4C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgIIJoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:44:44 -0400
Received: from correo.us.es ([193.147.175.20]:35004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbgIIJmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 328092EFEB9
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16AEDDA4FD
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05CBEDA91F; Wed,  9 Sep 2020 11:42:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B343ADA730;
        Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7308A4301DED;
        Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/13] netfilter: conntrack: remove unneeded nf_ct_put
Date:   Wed,  9 Sep 2020 11:42:13 +0200
Message-Id: <20200909094219.17732-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909094219.17732-1-pablo@netfilter.org>
References: <20200909094219.17732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can delay refcount increment until we reassign the existing entry to
the current skb.

A 0 refcount can't happen while the nf_conn object is still in the
hash table and parallel mutations are impossible because we hold the
bucket lock.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 93e77ca0efad..234b7cab37c3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -908,6 +908,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 		tstamp->start = ktime_get_real_ns();
 }
 
+/* caller must hold locks to prevent concurrent changes */
 static int __nf_ct_resolve_clash(struct sk_buff *skb,
 				 struct nf_conntrack_tuple_hash *h)
 {
@@ -921,13 +922,12 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 	if (nf_ct_is_dying(ct))
 		return NF_DROP;
 
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
-		return NF_DROP;
-
 	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
 	    nf_ct_match(ct, loser_ct)) {
 		struct net *net = nf_ct_net(ct);
 
+		nf_conntrack_get(&ct->ct_general);
+
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
 		nf_ct_add_to_dying_list(loser_ct);
 		nf_conntrack_put(&loser_ct->ct_general);
@@ -937,7 +937,6 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
-	nf_ct_put(ct);
 	return NF_DROP;
 }
 
-- 
2.20.1

