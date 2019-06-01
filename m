Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F9532060
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfFASYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:23 -0400
Received: from mail.us.es ([193.147.175.20]:40054 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfFASYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20413FF132
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D5F0DA70F
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B839EDA712; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0458DDA702;
        Sat,  1 Jun 2019 20:23:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9E13E4265A31;
        Sat,  1 Jun 2019 20:23:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/15] netfilter: replace skb_make_writable with skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:39 +0200
Message-Id: <20190601182340.2662-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This converts all remaining users and then removes skb_make_writable.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h        |  5 -----
 net/netfilter/core.c             | 22 ----------------------
 net/netfilter/nf_synproxy_core.c |  2 +-
 net/netfilter/nfnetlink_queue.c  |  2 +-
 net/netfilter/xt_DSCP.c          |  8 ++++----
 5 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 996bc247ef6e..049aeb40fa35 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -336,11 +336,6 @@ int compat_nf_getsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, int *len);
 #endif
 
-/* Call this before modifying an existing packet: ensures it is
-   modifiable and linear to the point you care about (writable_len).
-   Returns true or false. */
-int skb_make_writable(struct sk_buff *skb, unsigned int writable_len);
-
 struct flowi;
 struct nf_queue_entry;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b96fd3f54705..817a9e5d16e4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -536,28 +536,6 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
-
-int skb_make_writable(struct sk_buff *skb, unsigned int writable_len)
-{
-	if (writable_len > skb->len)
-		return 0;
-
-	/* Not exclusive use of packet?  Must copy. */
-	if (!skb_cloned(skb)) {
-		if (writable_len <= skb_headlen(skb))
-			return 1;
-	} else if (skb_clone_writable(skb, writable_len))
-		return 1;
-
-	if (writable_len <= skb_headlen(skb))
-		writable_len = 0;
-	else
-		writable_len -= skb_headlen(skb);
-
-	return !!__pskb_pull_tail(skb, writable_len);
-}
-EXPORT_SYMBOL(skb_make_writable);
-
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 8ff4d22f10b2..3d58a9e93e5a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -196,7 +196,7 @@ unsigned int synproxy_tstamp_adjust(struct sk_buff *skb,
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + th->doff * 4;
 
-	if (!skb_make_writable(skb, optend))
+	if (skb_ensure_writable(skb, optend))
 		return 0;
 
 	while (optoff < optend) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 27dac47b29c2..831f57008d78 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -863,7 +863,7 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 		}
 		skb_put(e->skb, diff);
 	}
-	if (!skb_make_writable(e->skb, data_len))
+	if (skb_ensure_writable(e->skb, data_len))
 		return -ENOMEM;
 	skb_copy_to_linear_data(e->skb, data, data_len);
 	e->skb->ip_summed = CHECKSUM_NONE;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 098ed851b7a7..30d554d6c213 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -34,7 +34,7 @@ dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 
 		ipv4_change_dsfield(ip_hdr(skb),
@@ -52,7 +52,7 @@ dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
-		if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return NF_DROP;
 
 		ipv6_change_dsfield(ipv6_hdr(skb),
@@ -82,7 +82,7 @@ tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ip_hdr(skb);
 		ipv4_change_dsfield(iph, 0, nv);
@@ -102,7 +102,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ipv6_hdr(skb);
 		ipv6_change_dsfield(iph, 0, nv);
-- 
2.11.0

