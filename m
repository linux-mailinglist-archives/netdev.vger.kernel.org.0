Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A29D4871A3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346018AbiAGEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346001AbiAGEDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:03:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55160C061245;
        Thu,  6 Jan 2022 20:03:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n5gTl-0005P9-P8; Fri, 07 Jan 2022 05:03:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/5] netfilter: make function op structures const
Date:   Fri,  7 Jan 2022 05:03:24 +0100
Message-Id: <20220107040326.28038-4-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107040326.28038-1-fw@strlen.de>
References: <20220107040326.28038-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes, these structures should be const.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h            |  8 ++++----
 net/netfilter/core.c                 | 10 +++++-----
 net/netfilter/nf_conntrack_core.c    |  4 ++--
 net/netfilter/nf_conntrack_netlink.c |  4 ++--
 net/netfilter/nf_nat_core.c          |  2 +-
 net/netfilter/nfnetlink_queue.c      |  8 ++++----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e0e3f3355ab1..15e71bfff726 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -381,13 +381,13 @@ struct nf_nat_hook {
 				  enum ip_conntrack_dir dir);
 };
 
-extern struct nf_nat_hook __rcu *nf_nat_hook;
+extern const struct nf_nat_hook __rcu *nf_nat_hook;
 
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 #if IS_ENABLED(CONFIG_NF_NAT)
-	struct nf_nat_hook *nat_hook;
+	const struct nf_nat_hook *nat_hook;
 
 	rcu_read_lock();
 	nat_hook = rcu_dereference(nf_nat_hook);
@@ -464,7 +464,7 @@ struct nf_ct_hook {
 			      const struct sk_buff *);
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 };
-extern struct nf_ct_hook __rcu *nf_ct_hook;
+extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
 struct nlattr;
 
@@ -479,7 +479,7 @@ struct nfnl_ct_hook {
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
 };
-extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
+extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
 /**
  * nf_skb_duplicated - TEE target has sent a packet
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index dc806dc9fe28..354cb472f386 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -666,14 +666,14 @@ EXPORT_SYMBOL(nf_hook_slow_list);
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
-struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
+const struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nfnl_ct_hook);
 
-struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
+const struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
+const struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
 /* This does not belong here, but locally generated errors need it if connection
@@ -696,7 +696,7 @@ EXPORT_SYMBOL(nf_ct_attach);
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 
 	rcu_read_lock();
 	ct_hook = rcu_dereference(nf_ct_hook);
@@ -709,7 +709,7 @@ EXPORT_SYMBOL(nf_conntrack_destroy);
 bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 			 const struct sk_buff *skb)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 	bool ret = false;
 
 	rcu_read_lock();
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 89f1e5f0090b..cd3d07e418b5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2085,9 +2085,9 @@ static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
 				 struct nf_conn *ct,
 				 enum ip_conntrack_info ctinfo)
 {
+	const struct nf_nat_hook *nat_hook;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	struct nf_nat_hook *nat_hook;
 	unsigned int status;
 	int dataoff;
 	u16 l3num;
@@ -2769,7 +2769,7 @@ int nf_conntrack_init_start(void)
 	return ret;
 }
 
-static struct nf_ct_hook nf_conntrack_hook = {
+static const struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= destroy_conntrack,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 13e2e0390c77..01cc69ab0b4e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1819,7 +1819,7 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  const struct nlattr *attr)
 	__must_hold(RCU)
 {
-	struct nf_nat_hook *nat_hook;
+	const struct nf_nat_hook *nat_hook;
 	int err;
 
 	nat_hook = rcu_dereference(nf_nat_hook);
@@ -2921,7 +2921,7 @@ static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_tcp_seqadj_set(skb, ct, ctinfo, diff);
 }
 
-static struct nfnl_ct_hook ctnetlink_glue_hook = {
+static const struct nfnl_ct_hook ctnetlink_glue_hook = {
 	.build_size	= ctnetlink_glue_build_size,
 	.build		= ctnetlink_glue_build,
 	.parse		= ctnetlink_glue_parse,
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3dd130487b5b..2d06a66899b2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1167,7 +1167,7 @@ static struct pernet_operations nat_net_ops = {
 	.size = sizeof(struct nat_net),
 };
 
-static struct nf_nat_hook nat_hook = {
+static const struct nf_nat_hook nat_hook = {
 	.parse_nat_setup	= nfnetlink_parse_nat_setup,
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 08771f47d469..862d8a3a0911 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -225,7 +225,7 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 	int err;
 
 	if (verdict == NF_ACCEPT ||
@@ -388,7 +388,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info ctinfo = 0;
-	struct nfnl_ct_hook *nfnl_ct;
+	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
 	char *secdata = NULL;
 	u32 seclen = 0;
@@ -1103,7 +1103,7 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 	return 0;
 }
 
-static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
+static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
@@ -1170,11 +1170,11 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	const struct nfnl_ct_hook *nfnl_ct;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
 	struct nf_queue_entry *entry;
-	struct nfnl_ct_hook *nfnl_ct;
 	struct nf_conn *ct = NULL;
 	unsigned int verdict;
 	int err;
-- 
2.34.1

