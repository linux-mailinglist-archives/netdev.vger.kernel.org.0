Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51EB262C4D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgIIJoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:44:46 -0400
Received: from correo.us.es ([193.147.175.20]:34976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgIIJme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E16C2EFEB3
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C9F3DA915
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 41390DA90E; Wed,  9 Sep 2020 11:42:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB8F3DA856;
        Wed,  9 Sep 2020 11:42:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C06D34301DE1;
        Wed,  9 Sep 2020 11:42:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/13] netfilter: conntrack: add clash resolution stat counter
Date:   Wed,  9 Sep 2020 11:42:12 +0200
Message-Id: <20200909094219.17732-7-pablo@netfilter.org>
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

There is a misconception about what "insert_failed" means.

We increment this even when a clash got resolved, so it might not indicate
a problem.

Add a dedicated counter for clash resolution and only increment
insert_failed if a clash cannot be resolved.

For the old /proc interface, export this in place of an older stat
that got removed a while back.
For ctnetlink, export this with a new attribute.

Also correct an outdated comment that implies we add a duplicate tuple --
we only add the (unique) reply direction.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h      | 1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 1 +
 net/netfilter/nf_conntrack_core.c                  | 9 +++++----
 net/netfilter/nf_conntrack_netlink.c               | 4 +++-
 net/netfilter/nf_conntrack_standalone.c            | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 96b90d7e361f..0c7d8d1e945d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -10,6 +10,7 @@ struct ip_conntrack_stat {
 	unsigned int invalid;
 	unsigned int insert;
 	unsigned int insert_failed;
+	unsigned int clash_resolve;
 	unsigned int drop;
 	unsigned int early_drop;
 	unsigned int error;
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 3e471558da82..d8484be72fdc 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -256,6 +256,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_EARLY_DROP,
 	CTA_STATS_ERROR,
 	CTA_STATS_SEARCH_RESTART,
+	CTA_STATS_CLASH_RESOLVE,
 	__CTA_STATS_MAX,
 };
 #define CTA_STATS_MAX (__CTA_STATS_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a111bcf1b93c..93e77ca0efad 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -859,7 +859,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 out:
 	nf_conntrack_double_unlock(hash, reply_hash);
-	NF_CT_STAT_INC(net, insert_failed);
 	local_bh_enable();
 	return -EEXIST;
 }
@@ -934,7 +933,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		nf_conntrack_put(&loser_ct->ct_general);
 		nf_ct_set(skb, ct, ctinfo);
 
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC(net, clash_resolve);
 		return NF_ACCEPT;
 	}
 
@@ -998,6 +997,8 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 
 	hlist_nulls_add_head_rcu(&loser_ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
 				 &nf_conntrack_hash[repl_idx]);
+
+	NF_CT_STAT_INC(net, clash_resolve);
 	return NF_ACCEPT;
 }
 
@@ -1027,10 +1028,10 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
  *
  * Failing that, the new, unconfirmed conntrack is still added to the table
  * provided that the collision only occurs in the ORIGINAL direction.
- * The new entry will be added after the existing one in the hash list,
+ * The new entry will be added only in the non-clashing REPLY direction,
  * so packets in the ORIGINAL direction will continue to match the existing
  * entry.  The new entry will also have a fixed timeout so it expires --
- * due to the collision, it will not see bidirectional traffic.
+ * due to the collision, it will only see reply traffic.
  *
  * Returns NF_DROP if the clash could not be resolved.
  */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c64f23a8f373..89d99f6dfd0a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2516,7 +2516,9 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 	    nla_put_be32(skb, CTA_STATS_EARLY_DROP, htonl(st->early_drop)) ||
 	    nla_put_be32(skb, CTA_STATS_ERROR, htonl(st->error)) ||
 	    nla_put_be32(skb, CTA_STATS_SEARCH_RESTART,
-				htonl(st->search_restart)))
+				htonl(st->search_restart)) ||
+	    nla_put_be32(skb, CTA_STATS_CLASH_RESOLVE,
+				htonl(st->clash_resolve)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b673a03624d2..0ff39740797d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -435,7 +435,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
 			"%08x %08x %08x %08x %08x  %08x %08x %08x %08x\n",
 		   nr_conntracks,
-		   0,
+		   st->clash_resolve, /* was: searched */
 		   st->found,
 		   0,
 		   st->invalid,
-- 
2.20.1

