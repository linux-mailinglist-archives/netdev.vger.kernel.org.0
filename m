Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE101635FE
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgBRWV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:21:28 -0500
Received: from correo.us.es ([193.147.175.20]:57500 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbgBRWVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B895F303D0F
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6D8ADA3A8
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9BFD7DA3A3; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB2BEDA3C3;
        Tue, 18 Feb 2020 23:21:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8B82A42EE38E;
        Tue, 18 Feb 2020 23:21:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/9] netfilter: conntrack: remove two args from resolve_clash
Date:   Tue, 18 Feb 2020 23:20:56 +0100
Message-Id: <20200218222101.635808-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ctinfo is whats taken from the skb, i.e.
ct = nf_ct_get(skb, &ctinfo).

We do not pass 'ct' and instead re-fetch it from the skb.
Just do the same for both netns and ctinfo.

Also add a comment on what clash resolution is supposed to do.
While at it, one indent level can be removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 69 +++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d1305423640f..5e332b01f3c0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -894,31 +894,64 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	}
 }
 
-/* Resolve race on insertion if this protocol allows this. */
+/**
+ * nf_ct_resolve_clash - attempt to handle clash without packet drop
+ *
+ * @skb: skb that causes the clash
+ * @h: tuplehash of the clashing entry already in table
+ *
+ * A conntrack entry can be inserted to the connection tracking table
+ * if there is no existing entry with an identical tuple.
+ *
+ * If there is one, @skb (and the assocated, unconfirmed conntrack) has
+ * to be dropped.  In case @skb is retransmitted, next conntrack lookup
+ * will find the already-existing entry.
+ *
+ * The major problem with such packet drop is the extra delay added by
+ * the packet loss -- it will take some time for a retransmit to occur
+ * (or the sender to time out when waiting for a reply).
+ *
+ * This function attempts to handle the situation without packet drop.
+ *
+ * If @skb has no NAT transformation or if the colliding entries are
+ * exactly the same, only the to-be-confirmed conntrack entry is discarded
+ * and @skb is associated with the conntrack entry already in the table.
+ *
+ * Returns NF_DROP if the clash could not be resolved.
+ */
 static __cold noinline int
-nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
-		    enum ip_conntrack_info ctinfo,
-		    struct nf_conntrack_tuple_hash *h)
+nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h)
 {
 	/* This is the conntrack entry already in hashes that won race. */
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 	const struct nf_conntrack_l4proto *l4proto;
-	enum ip_conntrack_info oldinfo;
-	struct nf_conn *loser_ct = nf_ct_get(skb, &oldinfo);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *loser_ct;
+	struct net *net;
+
+	loser_ct = nf_ct_get(skb, &ctinfo);
 
 	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
-	if (l4proto->allow_clash &&
-	    !nf_ct_is_dying(ct) &&
-	    atomic_inc_not_zero(&ct->ct_general.use)) {
-		if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
-		    nf_ct_match(ct, loser_ct)) {
-			nf_ct_acct_merge(ct, ctinfo, loser_ct);
-			nf_conntrack_put(&loser_ct->ct_general);
-			nf_ct_set(skb, ct, oldinfo);
-			return NF_ACCEPT;
-		}
-		nf_ct_put(ct);
+	if (!l4proto->allow_clash)
+		goto drop;
+
+	if (nf_ct_is_dying(ct))
+		goto drop;
+
+	if (!atomic_inc_not_zero(&ct->ct_general.use))
+		goto drop;
+
+	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
+	    nf_ct_match(ct, loser_ct)) {
+		nf_ct_acct_merge(ct, ctinfo, loser_ct);
+		nf_conntrack_put(&loser_ct->ct_general);
+		nf_ct_set(skb, ct, ctinfo);
+		return NF_ACCEPT;
 	}
+
+	nf_ct_put(ct);
+drop:
+	net = nf_ct_net(loser_ct);
 	NF_CT_STAT_INC(net, drop);
 	return NF_DROP;
 }
@@ -1036,7 +1069,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 out:
 	nf_ct_add_to_dying_list(ct);
-	ret = nf_ct_resolve_clash(net, skb, ctinfo, h);
+	ret = nf_ct_resolve_clash(skb, h);
 dying:
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert_failed);
-- 
2.11.0

