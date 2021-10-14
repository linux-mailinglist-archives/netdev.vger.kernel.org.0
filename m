Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03C42D909
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhJNMNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhJNMNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43213C061760;
        Thu, 14 Oct 2021 05:11:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maza8-0002mw-Qz; Thu, 14 Oct 2021 14:11:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 7/9] netfilter: core: do not rebuild bpf program on dying netns
Date:   Thu, 14 Oct 2021 14:10:44 +0200
Message-Id: <20211014121046.29329-9-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can save a few cycles on netns destruction.
When a hook is removed we can just skip building a new
program with the remaining hooks, those will be removed too
in the immediate future.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 56d82822cab7..9a19d4f1673b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -251,6 +251,7 @@ EXPORT_SYMBOL_GPL(nf_hook_entries_insert_raw);
  *
  * @old -- current hook blob at @pp
  * @pp -- location of hook blob
+ * @recompile -- false if bpf prog should not be replaced
  *
  * Hook unregistration must always succeed, so to-be-removed hooks
  * are replaced by a dummy one that will just move to next hook.
@@ -263,7 +264,8 @@ EXPORT_SYMBOL_GPL(nf_hook_entries_insert_raw);
  * Returns address to free, or NULL.
  */
 static void *__nf_hook_entries_try_shrink(struct nf_hook_entries *old,
-					  struct nf_hook_entries __rcu **pp)
+					  struct nf_hook_entries __rcu **pp,
+					  bool recompile)
 {
 	unsigned int i, j, skip = 0, hook_entries;
 	struct bpf_prog *hook_bpf_prog = NULL;
@@ -311,10 +313,12 @@ static void *__nf_hook_entries_try_shrink(struct nf_hook_entries *old,
 	hooks_validate(new);
 
 #if IS_ENABLED(CONFIG_NF_HOOK_BPF)
-	/* if this fails fallback prog calls nf_hook_slow. */
-	hook_bpf_prog = nf_hook_bpf_create(new);
-	if (hook_bpf_prog)
-		new->hook_prog = hook_bpf_prog;
+	if (recompile) {
+		/* if this fails fallback prog calls nf_hook_slow. */
+		hook_bpf_prog = nf_hook_bpf_create(new);
+		if (hook_bpf_prog)
+			new->hook_prog = hook_bpf_prog;
+	}
 #endif
 out_assign:
 	nf_hook_bpf_change_prog(BPF_DISPATCHER_PTR(nf_hook_base),
@@ -540,7 +544,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		WARN_ONCE(1, "hook not found, pf %d num %d", pf, reg->hooknum);
 	}
 
-	p = __nf_hook_entries_try_shrink(p, pp);
+	p = __nf_hook_entries_try_shrink(p, pp, check_net(net));
 	mutex_unlock(&nf_hook_mutex);
 	if (!p)
 		return;
@@ -571,7 +575,7 @@ void nf_hook_entries_delete_raw(struct nf_hook_entries __rcu **pp,
 
 	p = rcu_dereference_raw(*pp);
 	if (nf_remove_net_hook(p, reg)) {
-		p = __nf_hook_entries_try_shrink(p, pp);
+		p = __nf_hook_entries_try_shrink(p, pp, false);
 		nf_hook_entries_free(p);
 	}
 }
-- 
2.32.0

