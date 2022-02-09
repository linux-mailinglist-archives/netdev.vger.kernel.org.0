Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F6D4AF2F2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiBINgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiBINg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69E1CC0612BE;
        Wed,  9 Feb 2022 05:36:30 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DDF26601CF;
        Wed,  9 Feb 2022 14:36:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/14] netfilter: cttimeout: use option structure
Date:   Wed,  9 Feb 2022 14:36:13 +0100
Message-Id: <20220209133616.165104-12-pablo@netfilter.org>
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

Instead of two exported functions, export a single option structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h |  8 +++--
 net/netfilter/nf_conntrack_timeout.c         | 31 ++++++++------------
 net/netfilter/nfnetlink_cttimeout.c          | 11 ++++---
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index db507e4a65bb..3ea94f6f3844 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -108,8 +108,12 @@ static inline void nf_ct_destroy_timeout(struct nf_conn *ct)
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-extern struct nf_ct_timeout *(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name);
-extern void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout);
+struct nf_ct_timeout_hooks {
+	struct nf_ct_timeout *(*timeout_find_get)(struct net *net, const char *name);
+	void (*timeout_put)(struct nf_ct_timeout *timeout);
+};
+
+extern const struct nf_ct_timeout_hooks *nf_ct_timeout_hook;
 #endif
 
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index cd76ccca25e8..cec166ecba77 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -22,12 +22,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-struct nf_ct_timeout *
-(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ct_timeout_find_get_hook);
-
-void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ct_timeout_put_hook);
+const struct nf_ct_timeout_hooks *nf_ct_timeout_hook __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ct_timeout_hook);
 
 static int untimeout(struct nf_conn *ct, void *timeout)
 {
@@ -48,31 +44,30 @@ EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
 static void __nf_ct_timeout_put(struct nf_ct_timeout *timeout)
 {
-	typeof(nf_ct_timeout_put_hook) timeout_put;
+	const struct nf_ct_timeout_hooks *h = rcu_dereference(nf_ct_timeout_hook);
 
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
-	if (timeout_put)
-		timeout_put(timeout);
+	if (h)
+		h->timeout_put(timeout);
 }
 
 int nf_ct_set_timeout(struct net *net, struct nf_conn *ct,
 		      u8 l3num, u8 l4num, const char *timeout_name)
 {
-	typeof(nf_ct_timeout_find_get_hook) timeout_find_get;
+	const struct nf_ct_timeout_hooks *h;
 	struct nf_ct_timeout *timeout;
 	struct nf_conn_timeout *timeout_ext;
 	const char *errmsg = NULL;
 	int ret = 0;
 
 	rcu_read_lock();
-	timeout_find_get = rcu_dereference(nf_ct_timeout_find_get_hook);
-	if (!timeout_find_get) {
+	h = rcu_dereference(nf_ct_timeout_hook);
+	if (!h) {
 		ret = -ENOENT;
 		errmsg = "Timeout policy base is empty";
 		goto out;
 	}
 
-	timeout = timeout_find_get(net, timeout_name);
+	timeout = h->timeout_find_get(net, timeout_name);
 	if (!timeout) {
 		ret = -ENOENT;
 		pr_info_ratelimited("No such timeout policy \"%s\"\n",
@@ -119,15 +114,15 @@ EXPORT_SYMBOL_GPL(nf_ct_set_timeout);
 void nf_ct_destroy_timeout(struct nf_conn *ct)
 {
 	struct nf_conn_timeout *timeout_ext;
-	typeof(nf_ct_timeout_put_hook) timeout_put;
+	const struct nf_ct_timeout_hooks *h;
 
 	rcu_read_lock();
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
+	h = rcu_dereference(nf_ct_timeout_hook);
 
-	if (timeout_put) {
+	if (h) {
 		timeout_ext = nf_ct_timeout_find(ct);
 		if (timeout_ext) {
-			timeout_put(timeout_ext->timeout);
+			h->timeout_put(timeout_ext->timeout);
 			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
 		}
 	}
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c57673d499be..b0d8888a539b 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -605,6 +605,11 @@ static struct pernet_operations cttimeout_ops = {
 	.size   = sizeof(struct nfct_timeout_pernet),
 };
 
+static const struct nf_ct_timeout_hooks hooks = {
+	.timeout_find_get = ctnl_timeout_find_get,
+	.timeout_put = ctnl_timeout_put,
+};
+
 static int __init cttimeout_init(void)
 {
 	int ret;
@@ -619,8 +624,7 @@ static int __init cttimeout_init(void)
 			"nfnetlink.\n");
 		goto err_out;
 	}
-	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
-	RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
+	RCU_INIT_POINTER(nf_ct_timeout_hook, &hooks);
 	return 0;
 
 err_out:
@@ -633,8 +637,7 @@ static void __exit cttimeout_exit(void)
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
 	unregister_pernet_subsys(&cttimeout_ops);
-	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
-	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
+	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 	synchronize_rcu();
 }
 
-- 
2.30.2

