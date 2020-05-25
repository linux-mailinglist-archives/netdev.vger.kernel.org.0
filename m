Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A921E1775
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389415AbgEYVyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:54:35 -0400
Received: from correo.us.es ([193.147.175.20]:47392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgEYVyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 17:54:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04EDCFB38E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF10ADA702
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BCDEBDA705; Mon, 25 May 2020 23:54:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4E48DA707;
        Mon, 25 May 2020 23:54:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 774CB42EE38E;
        Mon, 25 May 2020 23:54:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/5] netfilter: conntrack: make conntrack userspace helpers work again
Date:   Mon, 25 May 2020 23:54:19 +0200
Message-Id: <20200525215420.2290-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal says:

"Problem is that after the helper hook was merged back into the confirm
one, the queueing itself occurs from the confirm hook, i.e. we queue
from the last netfilter callback in the hook-list.

Therefore, on return, the packet bypasses the confirm action and the
connection is never committed to the main conntrack table.

To fix this there are several ways:
1. revert the 'Fixes' commit and have a extra helper hook again.
   Works, but has the drawback of adding another indirect call for
   everyone.

2. Special case this: split the hooks only when userspace helper
   gets added, so queueing occurs at a lower priority again,
   and normal enqueue reinject would eventually call the last hook.

3. Extend the existing nf_queue ct update hook to allow a forced
   confirmation (plus run the seqadj code).

This goes for 3)."

Fixes: 827318feb69cb ("netfilter: conntrack: remove helper hook again")
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 78 ++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1d57b95d3481..08e0c19f6b39 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2016,22 +2016,18 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 	nf_conntrack_get(skb_nfct(nskb));
 }
 
-static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
+				 struct nf_conn *ct)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
 	unsigned int status;
-	struct nf_conn *ct;
 	int dataoff;
 	u16 l3num;
 	u8 l4num;
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct))
-		return 0;
-
 	l3num = nf_ct_l3num(ct);
 
 	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
@@ -2088,6 +2084,76 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+/* This packet is coming from userspace via nf_queue, complete the packet
+ * processing after the helper invocation in nf_confirm().
+ */
+static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
+			       enum ip_conntrack_info ctinfo)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int protoff;
+
+	help = nfct_help(ct);
+	if (!help)
+		return 0;
+
+	helper = rcu_dereference(help->helper);
+	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
+		return 0;
+
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6: {
+		__be16 frag_off;
+		u8 pnum;
+
+		pnum = ipv6_hdr(skb)->nexthdr;
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return 0;
+		break;
+	}
+#endif
+	default:
+		return 0;
+	}
+
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return -1;
+		}
+	}
+
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb) == NF_DROP ? - 1 : 0;
+}
+
+static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return 0;
+
+	if (!nf_ct_is_confirmed(ct)) {
+		err = __nf_conntrack_update(net, skb, ct);
+		if (err < 0)
+			return err;
+	}
+
+	return nf_confirm_cthelper(skb, ct, ctinfo);
+}
+
 static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 				       const struct sk_buff *skb)
 {
-- 
2.20.1

