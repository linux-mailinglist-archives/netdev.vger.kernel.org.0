Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C54AF2ED
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiBINg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiBINgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A782CC0613CA;
        Wed,  9 Feb 2022 05:36:27 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E370F601D0;
        Wed,  9 Feb 2022 14:36:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/14] netfilter: conntrack: remove extension register api
Date:   Wed,  9 Feb 2022 14:36:08 +0100
Message-Id: <20220209133616.165104-7-pablo@netfilter.org>
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

These no longer register/unregister a meaningful structure so remove it.

Cc: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_acct.h     |  1 -
 include/net/netfilter/nf_conntrack_ecache.h   | 13 ------
 include/net/netfilter/nf_conntrack_extend.h   |  9 ----
 include/net/netfilter/nf_conntrack_labels.h   |  3 --
 include/net/netfilter/nf_conntrack_seqadj.h   |  3 --
 include/net/netfilter/nf_conntrack_timeout.h  | 12 ------
 .../net/netfilter/nf_conntrack_timestamp.h    | 13 ------
 net/netfilter/nf_conntrack_acct.c             | 17 --------
 net/netfilter/nf_conntrack_core.c             | 43 -------------------
 net/netfilter/nf_conntrack_ecache.c           | 22 +---------
 net/netfilter/nf_conntrack_extend.c           | 35 +--------------
 net/netfilter/nf_conntrack_helper.c           | 15 -------
 net/netfilter/nf_conntrack_labels.c           | 18 +-------
 net/netfilter/nf_conntrack_seqadj.c           | 14 ------
 net/netfilter/nf_conntrack_timeout.c          | 17 --------
 net/netfilter/nf_conntrack_timestamp.c        | 18 --------
 net/netfilter/nf_nat_core.c                   | 13 ------
 net/netfilter/nf_synproxy_core.c              | 22 +---------
 net/sched/act_ct.c                            | 11 -----
 19 files changed, 7 insertions(+), 292 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 7f44a771530e..4b2b7f8914ea 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -78,7 +78,6 @@ static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
 
 void nf_conntrack_acct_pernet_init(struct net *net);
 
-int nf_conntrack_acct_init(void);
 void nf_conntrack_acct_fini(void);
 
 #endif /* _NF_CONNTRACK_ACCT_H */
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index d932e22edcb4..16bcff809b18 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -166,9 +166,6 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state);
 void nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
 
-int nf_conntrack_ecache_init(void);
-void nf_conntrack_ecache_fini(void);
-
 static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net)
 {
 	return net->ct.ecache_dwork_pending;
@@ -194,16 +191,6 @@ static inline void nf_conntrack_ecache_pernet_init(struct net *net)
 static inline void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
 }
-
-static inline int nf_conntrack_ecache_init(void)
-{
-	return 0;
-}
-
-static inline void nf_conntrack_ecache_fini(void)
-{
-}
-
 static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net) { return false; }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 #endif /*_NF_CONNTRACK_ECACHE_H*/
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 343f9194423a..96635ad2acc7 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -72,16 +72,7 @@ static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 #define nf_ct_ext_find(ext, id)	\
 	((id##_TYPE *)__nf_ct_ext_find((ext), (id)))
 
-/* Destroy all relationships */
-void nf_ct_ext_destroy(struct nf_conn *ct);
-
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
-struct nf_ct_ext_type {
-	enum nf_ct_ext_id id;
-};
-
-int nf_ct_extend_register(const struct nf_ct_ext_type *type);
-void nf_ct_extend_unregister(const struct nf_ct_ext_type *type);
 #endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index ba916411c4e1..3c23298e68ca 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -45,12 +45,9 @@ int nf_connlabels_replace(struct nf_conn *ct,
 
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 int nf_conntrack_labels_init(void);
-void nf_conntrack_labels_fini(void);
 int nf_connlabels_get(struct net *net, unsigned int bit);
 void nf_connlabels_put(struct net *net);
 #else
-static inline int nf_conntrack_labels_init(void) { return 0; }
-static inline void nf_conntrack_labels_fini(void) {}
 static inline int nf_connlabels_get(struct net *net, unsigned int bit) { return 0; }
 static inline void nf_connlabels_put(struct net *net) {}
 #endif
diff --git a/include/net/netfilter/nf_conntrack_seqadj.h b/include/net/netfilter/nf_conntrack_seqadj.h
index 0a10b50537ae..883c414b768e 100644
--- a/include/net/netfilter/nf_conntrack_seqadj.h
+++ b/include/net/netfilter/nf_conntrack_seqadj.h
@@ -42,7 +42,4 @@ int nf_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 		     enum ip_conntrack_info ctinfo, unsigned int protoff);
 s32 nf_ct_seq_offset(const struct nf_conn *ct, enum ip_conntrack_dir, u32 seq);
 
-int nf_conntrack_seqadj_init(void);
-void nf_conntrack_seqadj_fini(void);
-
 #endif /* _NF_CONNTRACK_SEQADJ_H */
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 659b0ea25b4d..db507e4a65bb 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -89,23 +89,11 @@ static inline unsigned int *nf_ct_timeout_lookup(const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-int nf_conntrack_timeout_init(void);
-void nf_conntrack_timeout_fini(void);
 void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout);
 int nf_ct_set_timeout(struct net *net, struct nf_conn *ct, u8 l3num, u8 l4num,
 		      const char *timeout_name);
 void nf_ct_destroy_timeout(struct nf_conn *ct);
 #else
-static inline int nf_conntrack_timeout_init(void)
-{
-        return 0;
-}
-
-static inline void nf_conntrack_timeout_fini(void)
-{
-        return;
-}
-
 static inline int nf_ct_set_timeout(struct net *net, struct nf_conn *ct,
 				    u8 l3num, u8 l4num,
 				    const char *timeout_name)
diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 820ea34b6029..57138d974a9f 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -40,21 +40,8 @@ struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
 
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 void nf_conntrack_tstamp_pernet_init(struct net *net);
-
-int nf_conntrack_tstamp_init(void);
-void nf_conntrack_tstamp_fini(void);
 #else
 static inline void nf_conntrack_tstamp_pernet_init(struct net *net) {}
-
-static inline int nf_conntrack_tstamp_init(void)
-{
-	return 0;
-}
-
-static inline void nf_conntrack_tstamp_fini(void)
-{
-	return;
-}
 #endif /* CONFIG_NF_CONNTRACK_TIMESTAMP */
 
 #endif /* _NF_CONNTRACK_TSTAMP_H */
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 4b5048ee84f2..385a5f458aba 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -22,24 +22,7 @@ static bool nf_ct_acct __read_mostly;
 module_param_named(acct, nf_ct_acct, bool, 0644);
 MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
-static const struct nf_ct_ext_type acct_extend = {
-	.id	= NF_CT_EXT_ACCT,
-};
-
 void nf_conntrack_acct_pernet_init(struct net *net)
 {
 	net->ct.sysctl_acct = nf_ct_acct;
 }
-
-int nf_conntrack_acct_init(void)
-{
-	int ret = nf_ct_extend_register(&acct_extend);
-	if (ret < 0)
-		pr_err("Unable to register extension\n");
-	return ret;
-}
-
-void nf_conntrack_acct_fini(void)
-{
-	nf_ct_extend_unregister(&acct_extend);
-}
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8f0c0c0fd329..9b7f9c966f73 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -38,7 +38,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
@@ -2477,13 +2476,7 @@ void nf_conntrack_cleanup_end(void)
 	kvfree(nf_conntrack_hash);
 
 	nf_conntrack_proto_fini();
-	nf_conntrack_seqadj_fini();
-	nf_conntrack_labels_fini();
 	nf_conntrack_helper_fini();
-	nf_conntrack_timeout_fini();
-	nf_conntrack_ecache_fini();
-	nf_conntrack_tstamp_fini();
-	nf_conntrack_acct_fini();
 	nf_conntrack_expect_fini();
 
 	kmem_cache_destroy(nf_conntrack_cachep);
@@ -2689,34 +2682,10 @@ int nf_conntrack_init_start(void)
 	if (ret < 0)
 		goto err_expect;
 
-	ret = nf_conntrack_acct_init();
-	if (ret < 0)
-		goto err_acct;
-
-	ret = nf_conntrack_tstamp_init();
-	if (ret < 0)
-		goto err_tstamp;
-
-	ret = nf_conntrack_ecache_init();
-	if (ret < 0)
-		goto err_ecache;
-
-	ret = nf_conntrack_timeout_init();
-	if (ret < 0)
-		goto err_timeout;
-
 	ret = nf_conntrack_helper_init();
 	if (ret < 0)
 		goto err_helper;
 
-	ret = nf_conntrack_labels_init();
-	if (ret < 0)
-		goto err_labels;
-
-	ret = nf_conntrack_seqadj_init();
-	if (ret < 0)
-		goto err_seqadj;
-
 	ret = nf_conntrack_proto_init();
 	if (ret < 0)
 		goto err_proto;
@@ -2734,20 +2703,8 @@ int nf_conntrack_init_start(void)
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	nf_conntrack_proto_fini();
 err_proto:
-	nf_conntrack_seqadj_fini();
-err_seqadj:
-	nf_conntrack_labels_fini();
-err_labels:
 	nf_conntrack_helper_fini();
 err_helper:
-	nf_conntrack_timeout_fini();
-err_timeout:
-	nf_conntrack_ecache_fini();
-err_ecache:
-	nf_conntrack_tstamp_fini();
-err_tstamp:
-	nf_conntrack_acct_fini();
-err_acct:
 	nf_conntrack_expect_fini();
 err_expect:
 	kmem_cache_destroy(nf_conntrack_cachep);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 9ececc9b45f9..873908054f7f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -304,10 +304,6 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
-static const struct nf_ct_ext_type event_extend = {
-	.id	= NF_CT_EXT_ECACHE,
-};
-
 void nf_conntrack_ecache_pernet_init(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
@@ -315,6 +311,8 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	net->ct.sysctl_events = nf_ct_events;
 	cnet->ct_net = &net->ct;
 	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
+
+	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
@@ -323,19 +321,3 @@ void nf_conntrack_ecache_pernet_fini(struct net *net)
 
 	cancel_delayed_work_sync(&cnet->ecache_dwork);
 }
-
-int nf_conntrack_ecache_init(void)
-{
-	int ret = nf_ct_extend_register(&event_extend);
-	if (ret < 0)
-		pr_err("Unable to register event extension\n");
-
-	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
-
-	return ret;
-}
-
-void nf_conntrack_ecache_fini(void)
-{
-	nf_ct_extend_unregister(&event_extend);
-}
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 6b772b804ee2..1296fda54ac6 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -25,8 +25,6 @@
 #include <net/netfilter/nf_conntrack_act_ct.h>
 #include <net/netfilter/nf_nat.h>
 
-static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
-static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
 static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
@@ -97,6 +95,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
 	WARN_ON(nf_ct_is_confirmed(ct));
 
+	/* struct nf_ct_ext uses u8 to store offsets/size */
+	BUILD_BUG_ON(total_extension_size() > 255u);
 
 	if (ct->ext) {
 		const struct nf_ct_ext *old = ct->ext;
@@ -127,34 +127,3 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-
-/* This MUST be called in process context. */
-int nf_ct_extend_register(const struct nf_ct_ext_type *type)
-{
-	int ret = 0;
-
-	/* struct nf_ct_ext uses u8 to store offsets/size */
-	BUILD_BUG_ON(total_extension_size() > 255u);
-
-	mutex_lock(&nf_ct_ext_type_mutex);
-	if (nf_ct_ext_types[type->id]) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	rcu_assign_pointer(nf_ct_ext_types[type->id], type);
-out:
-	mutex_unlock(&nf_ct_ext_type_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_extend_register);
-
-/* This MUST be called in process context. */
-void nf_ct_extend_unregister(const struct nf_ct_ext_type *type)
-{
-	mutex_lock(&nf_ct_ext_type_mutex);
-	RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
-	mutex_unlock(&nf_ct_ext_type_mutex);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(nf_ct_extend_unregister);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6fe94f18a4ac..a97ddb1497aa 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -550,10 +550,6 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
-static const struct nf_ct_ext_type helper_extend = {
-	.id	= NF_CT_EXT_HELPER,
-};
-
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
@@ -563,28 +559,17 @@ void nf_conntrack_helper_pernet_init(struct net *net)
 
 int nf_conntrack_helper_init(void)
 {
-	int ret;
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
 	nf_ct_helper_hash =
 		nf_ct_alloc_hashtable(&nf_ct_helper_hsize, 0);
 	if (!nf_ct_helper_hash)
 		return -ENOMEM;
 
-	ret = nf_ct_extend_register(&helper_extend);
-	if (ret < 0) {
-		pr_err("nf_ct_helper: Unable to register helper extension.\n");
-		goto out_extend;
-	}
-
 	INIT_LIST_HEAD(&nf_ct_nat_helpers);
 	return 0;
-out_extend:
-	kvfree(nf_ct_helper_hash);
-	return ret;
 }
 
 void nf_conntrack_helper_fini(void)
 {
-	nf_ct_extend_unregister(&helper_extend);
 	kvfree(nf_ct_helper_hash);
 }
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 0cd99535122b..6e70e137a0a6 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -67,6 +67,8 @@ int nf_connlabels_get(struct net *net, unsigned int bits)
 	net->ct.labels_used++;
 	spin_unlock(&nf_connlabels_lock);
 
+	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_connlabels_get);
@@ -78,19 +80,3 @@ void nf_connlabels_put(struct net *net)
 	spin_unlock(&nf_connlabels_lock);
 }
 EXPORT_SYMBOL_GPL(nf_connlabels_put);
-
-static const struct nf_ct_ext_type labels_extend = {
-	.id     = NF_CT_EXT_LABELS,
-};
-
-int nf_conntrack_labels_init(void)
-{
-	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
-
-	return nf_ct_extend_register(&labels_extend);
-}
-
-void nf_conntrack_labels_fini(void)
-{
-	nf_ct_extend_unregister(&labels_extend);
-}
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index b9629916e53d..7ab2b25b57bc 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -232,17 +232,3 @@ s32 nf_ct_seq_offset(const struct nf_conn *ct,
 		 this_way->offset_after : this_way->offset_before;
 }
 EXPORT_SYMBOL_GPL(nf_ct_seq_offset);
-
-static const struct nf_ct_ext_type nf_ct_seqadj_extend = {
-	.id	= NF_CT_EXT_SEQADJ,
-};
-
-int nf_conntrack_seqadj_init(void)
-{
-	return nf_ct_extend_register(&nf_ct_seqadj_extend);
-}
-
-void nf_conntrack_seqadj_fini(void)
-{
-	nf_ct_extend_unregister(&nf_ct_seqadj_extend);
-}
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index ac99a0083156..cd76ccca25e8 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -134,20 +134,3 @@ void nf_ct_destroy_timeout(struct nf_conn *ct)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_ct_destroy_timeout);
-
-static const struct nf_ct_ext_type timeout_extend = {
-	.id	= NF_CT_EXT_TIMEOUT,
-};
-
-int nf_conntrack_timeout_init(void)
-{
-	int ret = nf_ct_extend_register(&timeout_extend);
-	if (ret < 0)
-		pr_err("nf_ct_timeout: Unable to register timeout extension.\n");
-	return ret;
-}
-
-void nf_conntrack_timeout_fini(void)
-{
-	nf_ct_extend_unregister(&timeout_extend);
-}
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index c696ca19dcb1..9e43a0a59e73 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -19,25 +19,7 @@ static bool nf_ct_tstamp __read_mostly;
 module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
 MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
 
-static const struct nf_ct_ext_type tstamp_extend = {
-	.id	= NF_CT_EXT_TSTAMP,
-};
-
 void nf_conntrack_tstamp_pernet_init(struct net *net)
 {
 	net->ct.sysctl_tstamp = nf_ct_tstamp;
 }
-
-int nf_conntrack_tstamp_init(void)
-{
-	int ret;
-	ret = nf_ct_extend_register(&tstamp_extend);
-	if (ret < 0)
-		pr_err("Unable to register extension\n");
-	return ret;
-}
-
-void nf_conntrack_tstamp_fini(void)
-{
-	nf_ct_extend_unregister(&tstamp_extend);
-}
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8cc31d695e36..58c06ac10179 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -868,10 +868,6 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	return 0;
 }
 
-static struct nf_ct_ext_type nat_extend __read_mostly = {
-	.id		= NF_CT_EXT_NAT,
-};
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -1179,19 +1175,11 @@ static int __init nf_nat_init(void)
 	if (!nf_nat_bysource)
 		return -ENOMEM;
 
-	ret = nf_ct_extend_register(&nat_extend);
-	if (ret < 0) {
-		kvfree(nf_nat_bysource);
-		pr_err("Unable to register extension\n");
-		return ret;
-	}
-
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_nat_locks[i]);
 
 	ret = register_pernet_subsys(&nat_net_ops);
 	if (ret < 0) {
-		nf_ct_extend_unregister(&nat_extend);
 		kvfree(nf_nat_bysource);
 		return ret;
 	}
@@ -1210,7 +1198,6 @@ static void __exit nf_nat_cleanup(void)
 
 	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
 
-	nf_ct_extend_unregister(&nat_extend);
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6d328f7bb323..e479dd0561c5 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -236,10 +236,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	return 1;
 }
 
-static struct nf_ct_ext_type nf_ct_synproxy_extend __read_mostly = {
-	.id		= NF_CT_EXT_SYNPROXY,
-};
-
 #ifdef CONFIG_PROC_FS
 static void *synproxy_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
@@ -385,28 +381,12 @@ static struct pernet_operations synproxy_net_ops = {
 
 static int __init synproxy_core_init(void)
 {
-	int err;
-
-	err = nf_ct_extend_register(&nf_ct_synproxy_extend);
-	if (err < 0)
-		goto err1;
-
-	err = register_pernet_subsys(&synproxy_net_ops);
-	if (err < 0)
-		goto err2;
-
-	return 0;
-
-err2:
-	nf_ct_extend_unregister(&nf_ct_synproxy_extend);
-err1:
-	return err;
+	return register_pernet_subsys(&synproxy_net_ops);
 }
 
 static void __exit synproxy_core_exit(void)
 {
 	unregister_pernet_subsys(&synproxy_net_ops);
-	nf_ct_extend_unregister(&nf_ct_synproxy_extend);
 }
 
 module_init(synproxy_core_init);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 774e32fab5cf..7108e71ce4db 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -57,10 +57,6 @@ static const struct rhashtable_params zones_params = {
 	.automatic_shrinking = true,
 };
 
-static struct nf_ct_ext_type act_ct_extend __read_mostly = {
-	.id		= NF_CT_EXT_ACT_CT,
-};
-
 static struct flow_action_entry *
 tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
 {
@@ -1606,16 +1602,10 @@ static int __init ct_init_module(void)
 	if (err)
 		goto err_register;
 
-	err = nf_ct_extend_register(&act_ct_extend);
-	if (err)
-		goto err_register_extend;
-
 	static_branch_inc(&tcf_frag_xmit_count);
 
 	return 0;
 
-err_register_extend:
-	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 err_register:
 	tcf_ct_flow_tables_uninit();
 err_tbl_init:
@@ -1626,7 +1616,6 @@ static int __init ct_init_module(void)
 static void __exit ct_cleanup_module(void)
 {
 	static_branch_dec(&tcf_frag_xmit_count);
-	nf_ct_extend_unregister(&act_ct_extend);
 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 	tcf_ct_flow_tables_uninit();
 	destroy_workqueue(act_ct_wq);
-- 
2.30.2

