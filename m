Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C59E5A35
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfJZLsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:24 -0400
Received: from correo.us.es ([193.147.175.20]:46410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfJZLrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 592DA8C3C62
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A4C8B8009
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FF8BB8001; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38CB9A7EC8;
        Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 052C242EE393;
        Sat, 26 Oct 2019 13:47:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/31] netfilter: ctnetlink: don't dump ct extensions of unconfirmed conntracks
Date:   Sat, 26 Oct 2019 13:47:17 +0200
Message-Id: <20191026114733.28111-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When dumping the unconfirmed lists, the cpu that is processing the ct
entry can reallocate ct->ext at any time.

Right now accessing the extensions from another CPU is ok provided
we're holding rcu read lock: extension reallocation does use rcu.

Once RCU isn't used anymore this becomes unsafe, so skip extensions for
the unconfirmed list.

Dumping the extension area for confirmed or dying conntracks is fine:
no reallocations are allowed and list iteration holds appropriate
locks that prevent ct (and this ct->ext) from getting free'd.

v2: fix compiler warnings due to misue of 'const' and missing return
    statement (kbuild robot).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 76 ++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e2d13cd18875..d8d33ef52ce0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -506,9 +506,45 @@ static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 
+/* all these functions access ct->ext. Caller must either hold a reference
+ * on ct or prevent its deletion by holding either the bucket spinlock or
+ * pcpu dying list lock.
+ */
+static int ctnetlink_dump_extinfo(struct sk_buff *skb,
+				  struct nf_conn *ct, u32 type)
+{
+	if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
+	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
+	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
+	    ctnetlink_dump_labels(skb, ct) < 0 ||
+	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
+	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
+{
+	if (ctnetlink_dump_status(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_secctx(skb, ct) < 0 ||
+	    ctnetlink_dump_id(skb, ct) < 0 ||
+	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_master(skb, ct) < 0)
+		return -1;
+
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
+	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+		return -1;
+
+	return 0;
+}
+
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
-		    struct nf_conn *ct)
+		    struct nf_conn *ct, bool extinfo)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlmsghdr *nlh;
@@ -552,23 +588,9 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 				   NF_CT_DEFAULT_ZONE_DIR) < 0)
 		goto nla_put_failure;
 
-	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
-	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
-	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
-	    ctnetlink_dump_secctx(skb, ct) < 0 ||
-	    ctnetlink_dump_labels(skb, ct) < 0 ||
-	    ctnetlink_dump_id(skb, ct) < 0 ||
-	    ctnetlink_dump_use(skb, ct) < 0 ||
-	    ctnetlink_dump_master(skb, ct) < 0 ||
-	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
-	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+	if (ctnetlink_dump_info(skb, ct) < 0)
 		goto nla_put_failure;
-
-	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
-	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
-	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+	if (extinfo && ctnetlink_dump_extinfo(skb, ct, type) < 0)
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -953,13 +975,11 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!ctnetlink_filter_match(ct, cb->data))
 				continue;
 
-			rcu_read_lock();
 			res =
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-					    ct);
-			rcu_read_unlock();
+					    ct, true);
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
@@ -1364,10 +1384,8 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 		return -ENOMEM;
 	}
 
-	rcu_read_lock();
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct);
-	rcu_read_unlock();
+				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true);
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
@@ -1429,12 +1447,18 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 					continue;
 				cb->args[1] = 0;
 			}
-			rcu_read_lock();
+
+			/* We can't dump extension info for the unconfirmed
+			 * list because unconfirmed conntracks can have
+			 * ct->ext reallocated (and thus freed).
+			 *
+			 * In the dying list case ct->ext can't be free'd
+			 * until after we drop pcpu->lock.
+			 */
 			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq,
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct);
-			rcu_read_unlock();
+						  ct, dying ? true : false);
 			if (res < 0) {
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
-- 
2.11.0

