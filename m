Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FC957C08B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiGTXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiGTXIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59CB924096;
        Wed, 20 Jul 2022 16:08:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 06/18] netfilter: nf_conntrack: use rcu accessors where needed
Date:   Thu, 21 Jul 2022 01:07:42 +0200
Message-Id: <20220720230754.209053-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Sparse complains about direct access to the 'helper' and timeout members.
Both have __rcu annotation, so use the accessors.

xt_CT is fine, accesses occur before the structure is visible to other
cpus.  Switch to rcu accessors there as well to reduce noise.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_broadcast.c |  6 +++++-
 net/netfilter/nf_conntrack_helper.c    |  2 +-
 net/netfilter/nf_conntrack_netlink.c   |  9 +++++++--
 net/netfilter/nf_conntrack_sip.c       |  7 ++++++-
 net/netfilter/nf_conntrack_timeout.c   | 16 +++++++++++++---
 net/netfilter/nfnetlink_cthelper.c     | 10 +++++++---
 net/netfilter/xt_CT.c                  | 23 ++++++++++++++++++-----
 7 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 1ba6becc3079..9fb9b8031298 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -20,6 +20,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				enum ip_conntrack_info ctinfo,
 				unsigned int timeout)
 {
+	const struct nf_conntrack_helper *helper;
 	struct nf_conntrack_expect *exp;
 	struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt = skb_rtable(skb);
@@ -58,7 +59,10 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 		goto out;
 
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-	exp->tuple.src.u.udp.port = help->helper->tuple.src.u.udp.port;
+
+	helper = rcu_dereference(help->helper);
+	if (helper)
+		exp->tuple.src.u.udp.port = helper->tuple.src.u.udp.port;
 
 	exp->mask.src.u3.ip       = mask;
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 1e0424d37abc..e96b32221444 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -249,7 +249,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	if (tmpl != NULL) {
 		help = nfct_help(tmpl);
 		if (help != NULL) {
-			helper = help->helper;
+			helper = rcu_dereference(help->helper);
 			set_bit(IPS_HELPER_BIT, &ct->status);
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 722af5e309ba..25c2c0de78f0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2004,7 +2004,7 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	}
 
 	if (help) {
-		if (help->helper == helper) {
+		if (rcu_access_pointer(help->helper) == helper) {
 			/* update private helper data if allowed. */
 			if (helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
@@ -3412,12 +3412,17 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 
 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 {
+	struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *m_help;
 	const char *name = data;
 
 	m_help = nfct_help(exp->master);
 
-	return strcmp(m_help->helper->name, name) == 0;
+	helper = rcu_dereference(m_help->helper);
+	if (!helper)
+		return false;
+
+	return strcmp(helper->name, name) == 0;
 }
 
 static bool expect_iter_all(struct nf_conntrack_expect *exp, void *data)
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index a88b43624b27..daf06f71d31c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1229,6 +1229,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *saddr, daddr;
 	const struct nf_nat_sip_hooks *hooks;
+	struct nf_conntrack_helper *helper;
 	__be16 port;
 	u8 proto;
 	unsigned int expires = 0;
@@ -1289,10 +1290,14 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	if (sip_direct_signalling)
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
+	helper = rcu_dereference(nfct_help(ct)->helper);
+	if (!helper)
+		return NF_DROP;
+
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	exp->helper = nfct_help(ct)->helper;
+	exp->helper = helper;
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 821365ed5b2c..0cc584d3dbb1 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -29,8 +29,14 @@ static int untimeout(struct nf_conn *ct, void *timeout)
 {
 	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
 
-	if (timeout_ext && (!timeout || timeout_ext->timeout == timeout))
-		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+	if (timeout_ext) {
+		const struct nf_ct_timeout *t;
+
+		t = rcu_access_pointer(timeout_ext->timeout);
+
+		if (!timeout || t == timeout)
+			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+	}
 
 	/* We are not intended to delete this conntrack. */
 	return 0;
@@ -127,7 +133,11 @@ void nf_ct_destroy_timeout(struct nf_conn *ct)
 	if (h) {
 		timeout_ext = nf_ct_timeout_find(ct);
 		if (timeout_ext) {
-			h->timeout_put(timeout_ext->timeout);
+			struct nf_ct_timeout *t;
+
+			t = rcu_dereference(timeout_ext->timeout);
+			if (t)
+				h->timeout_put(t);
 			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
 		}
 	}
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5c622f55c9d6..97248963a7d3 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -96,11 +96,13 @@ static int
 nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 {
 	struct nf_conn_help *help = nfct_help(ct);
+	const struct nf_conntrack_helper *helper;
 
 	if (attr == NULL)
 		return -EINVAL;
 
-	if (help->helper->data_len == 0)
+	helper = rcu_dereference(help->helper);
+	if (!helper || helper->data_len == 0)
 		return -EINVAL;
 
 	nla_memcpy(help->data, attr, sizeof(help->data));
@@ -111,9 +113,11 @@ static int
 nfnl_cthelper_to_nlattr(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	const struct nf_conn_help *help = nfct_help(ct);
+	const struct nf_conntrack_helper *helper;
 
-	if (help->helper->data_len &&
-	    nla_put(skb, CTA_HELP_INFO, help->helper->data_len, &help->data))
+	helper = rcu_dereference(help->helper);
+	if (helper && helper->data_len &&
+	    nla_put(skb, CTA_HELP_INFO, helper->data_len, &help->data))
 		goto nla_put_failure;
 
 	return 0;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 267757b0392a..2be2f7a7b60f 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -96,7 +96,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOMEM;
 	}
 
-	help->helper = helper;
+	rcu_assign_pointer(help->helper, helper);
 	return 0;
 }
 
@@ -136,6 +136,21 @@ static u16 xt_ct_flags_to_dir(const struct xt_ct_target_info_v1 *info)
 	}
 }
 
+static void xt_ct_put_helper(struct nf_conn_help *help)
+{
+	struct nf_conntrack_helper *helper;
+
+	if (!help)
+		return;
+
+	/* not yet exposed to other cpus, or ruleset
+	 * already detached (post-replacement).
+	 */
+	helper = rcu_dereference_raw(help->helper);
+	if (helper)
+		nf_conntrack_helper_put(helper);
+}
+
 static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
@@ -207,8 +222,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 
 err4:
 	help = nfct_help(ct);
-	if (help)
-		nf_conntrack_helper_put(help->helper);
+	xt_ct_put_helper(help);
 err3:
 	nf_ct_tmpl_free(ct);
 err2:
@@ -270,8 +284,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 
 	if (ct) {
 		help = nfct_help(ct);
-		if (help)
-			nf_conntrack_helper_put(help->helper);
+		xt_ct_put_helper(help);
 
 		nf_ct_netns_put(par->net, par->family);
 
-- 
2.30.2

