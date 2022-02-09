Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FA4AF2DC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiBINga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiBINgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48153C061355;
        Wed,  9 Feb 2022 05:36:28 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 93968601CB;
        Wed,  9 Feb 2022 14:36:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/14] netfilter: conntrack: pptp: use single option structure
Date:   Wed,  9 Feb 2022 14:36:09 +0100
Message-Id: <20220209133616.165104-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of exposing the four hooks individually use a sinle hook ops
structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_pptp.h | 38 ++++++-------
 net/ipv4/netfilter/nf_nat_pptp.c            | 24 ++++-----
 net/netfilter/nf_conntrack_pptp.c           | 60 +++++++--------------
 3 files changed, 45 insertions(+), 77 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index a28aa289afdc..c3bdb4370938 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -300,26 +300,22 @@ union pptp_ctrl_union {
 	struct PptpSetLinkInfo		setlink;
 };
 
-extern int
-(*nf_nat_pptp_hook_outbound)(struct sk_buff *skb,
-			     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			     unsigned int protoff,
-			     struct PptpControlHeader *ctlh,
-			     union pptp_ctrl_union *pptpReq);
-
-extern int
-(*nf_nat_pptp_hook_inbound)(struct sk_buff *skb,
-			    struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			    unsigned int protoff,
-			    struct PptpControlHeader *ctlh,
-			    union pptp_ctrl_union *pptpReq);
-
-extern void
-(*nf_nat_pptp_hook_exp_gre)(struct nf_conntrack_expect *exp_orig,
-			    struct nf_conntrack_expect *exp_reply);
-
-extern void
-(*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
-			     struct nf_conntrack_expect *exp);
+struct nf_nat_pptp_hook {
+	int (*outbound)(struct sk_buff *skb,
+			struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			unsigned int protoff,
+			struct PptpControlHeader *ctlh,
+			union pptp_ctrl_union *pptpReq);
+	int (*inbound)(struct sk_buff *skb,
+		       struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+		       unsigned int protoff,
+		       struct PptpControlHeader *ctlh,
+		       union pptp_ctrl_union *pptpReq);
+	void (*exp_gre)(struct nf_conntrack_expect *exp_orig,
+			struct nf_conntrack_expect *exp_reply);
+	void (*expectfn)(struct nf_conn *ct,
+			 struct nf_conntrack_expect *exp);
+};
 
+extern const struct nf_nat_pptp_hook __rcu *nf_nat_pptp_hook;
 #endif /* _NF_CONNTRACK_PPTP_H */
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 3f248a19faa3..fab357cc8559 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -295,28 +295,24 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
+static const struct nf_nat_pptp_hook pptp_hooks = {
+	.outbound = pptp_outbound_pkt,
+	.inbound = pptp_inbound_pkt,
+	.exp_gre = pptp_exp_gre,
+	.expectfn = pptp_nat_expected,
+};
+
 static int __init nf_nat_helper_pptp_init(void)
 {
-	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
-
-	BUG_ON(nf_nat_pptp_hook_inbound != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
-
-	BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
+	WARN_ON(nf_nat_pptp_hook != NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook, &pptp_hooks);
 
-	BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
 	return 0;
 }
 
 static void __exit nf_nat_helper_pptp_fini(void)
 {
-	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook, NULL);
 	synchronize_rcu();
 }
 
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 7d5708b92138..f3fa367b455f 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -45,30 +45,8 @@ MODULE_ALIAS_NFCT_HELPER("pptp");
 
 static DEFINE_SPINLOCK(nf_pptp_lock);
 
-int
-(*nf_nat_pptp_hook_outbound)(struct sk_buff *skb,
-			     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			     unsigned int protoff, struct PptpControlHeader *ctlh,
-			     union pptp_ctrl_union *pptpReq) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_outbound);
-
-int
-(*nf_nat_pptp_hook_inbound)(struct sk_buff *skb,
-			    struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			    unsigned int protoff, struct PptpControlHeader *ctlh,
-			    union pptp_ctrl_union *pptpReq) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_inbound);
-
-void
-(*nf_nat_pptp_hook_exp_gre)(struct nf_conntrack_expect *expect_orig,
-			    struct nf_conntrack_expect *expect_reply)
-			    __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_exp_gre);
-
-void
-(*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
-			     struct nf_conntrack_expect *exp) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
+const struct nf_nat_pptp_hook *nf_nat_pptp_hook;
+EXPORT_SYMBOL_GPL(nf_nat_pptp_hook);
 
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 /* PptpControlMessageType names */
@@ -111,8 +89,8 @@ EXPORT_SYMBOL(pptp_msg_name);
 static void pptp_expectfn(struct nf_conn *ct,
 			 struct nf_conntrack_expect *exp)
 {
+	const struct nf_nat_pptp_hook *hook;
 	struct net *net = nf_ct_net(ct);
-	typeof(nf_nat_pptp_hook_expectfn) nf_nat_pptp_expectfn;
 	pr_debug("increasing timeouts\n");
 
 	/* increase timeout of GRE data channel conntrack entry */
@@ -122,9 +100,9 @@ static void pptp_expectfn(struct nf_conn *ct,
 	/* Can you see how rusty this code is, compared with the pre-2.6.11
 	 * one? That's what happened to my shiny newnat of 2002 ;( -HW */
 
-	nf_nat_pptp_expectfn = rcu_dereference(nf_nat_pptp_hook_expectfn);
-	if (nf_nat_pptp_expectfn && ct->master->status & IPS_NAT_MASK)
-		nf_nat_pptp_expectfn(ct, exp);
+	hook = rcu_dereference(nf_nat_pptp_hook);
+	if (hook && ct->master->status & IPS_NAT_MASK)
+		hook->expectfn(ct, exp);
 	else {
 		struct nf_conntrack_tuple inv_t;
 		struct nf_conntrack_expect *exp_other;
@@ -209,9 +187,9 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 {
 	struct nf_conntrack_expect *exp_orig, *exp_reply;
+	const struct nf_nat_pptp_hook *hook;
 	enum ip_conntrack_dir dir;
 	int ret = 1;
-	typeof(nf_nat_pptp_hook_exp_gre) nf_nat_pptp_exp_gre;
 
 	exp_orig = nf_ct_expect_alloc(ct);
 	if (exp_orig == NULL)
@@ -239,9 +217,9 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 			  IPPROTO_GRE, &callid, &peer_callid);
 	exp_reply->expectfn = pptp_expectfn;
 
-	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
-	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
-		nf_nat_pptp_exp_gre(exp_orig, exp_reply);
+	hook = rcu_dereference(nf_nat_pptp_hook);
+	if (hook && ct->status & IPS_NAT_MASK)
+		hook->exp_gre(exp_orig, exp_reply);
 	if (nf_ct_expect_related(exp_orig, 0) != 0)
 		goto out_put_both;
 	if (nf_ct_expect_related(exp_reply, 0) != 0)
@@ -279,9 +257,9 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		 enum ip_conntrack_info ctinfo)
 {
 	struct nf_ct_pptp_master *info = nfct_help_data(ct);
+	const struct nf_nat_pptp_hook *hook;
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
-	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
 	pr_debug("inbound control message %s\n", pptp_msg_name(msg));
@@ -383,10 +361,9 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		goto invalid;
 	}
 
-	nf_nat_pptp_inbound = rcu_dereference(nf_nat_pptp_hook_inbound);
-	if (nf_nat_pptp_inbound && ct->status & IPS_NAT_MASK)
-		return nf_nat_pptp_inbound(skb, ct, ctinfo,
-					   protoff, ctlh, pptpReq);
+	hook = rcu_dereference(nf_nat_pptp_hook);
+	if (hook && ct->status & IPS_NAT_MASK)
+		return hook->inbound(skb, ct, ctinfo, protoff, ctlh, pptpReq);
 	return NF_ACCEPT;
 
 invalid:
@@ -407,9 +384,9 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		  enum ip_conntrack_info ctinfo)
 {
 	struct nf_ct_pptp_master *info = nfct_help_data(ct);
+	const struct nf_nat_pptp_hook *hook;
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
-	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
 	pr_debug("outbound control message %s\n", pptp_msg_name(msg));
@@ -479,10 +456,9 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		goto invalid;
 	}
 
-	nf_nat_pptp_outbound = rcu_dereference(nf_nat_pptp_hook_outbound);
-	if (nf_nat_pptp_outbound && ct->status & IPS_NAT_MASK)
-		return nf_nat_pptp_outbound(skb, ct, ctinfo,
-					    protoff, ctlh, pptpReq);
+	hook = rcu_dereference(nf_nat_pptp_hook);
+	if (hook && ct->status & IPS_NAT_MASK)
+		return hook->outbound(skb, ct, ctinfo, protoff, ctlh, pptpReq);
 	return NF_ACCEPT;
 
 invalid:
-- 
2.30.2

