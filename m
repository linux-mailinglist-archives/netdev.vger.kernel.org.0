Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4B959AF31
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 19:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiHTRgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 13:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiHTRgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 13:36:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6752812;
        Sat, 20 Aug 2022 10:36:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oPSOB-0007Ea-1e; Sat, 20 Aug 2022 19:36:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller@googlegroups.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, john.p.donnelly@oracle.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH nf] netfilter: ebtables: reject blobs that don't provide all entry points
Date:   Sat, 20 Aug 2022 19:35:55 +0200
Message-Id: <20220820173555.131326-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason ebtables reject blobs that provide entry points that are
not supported by the table.

What it should instead reject is the opposite, i.e. rulesets that
DO NOT provide an entry point that is supported by the table.

t->valid_hooks is the bitmask of hooks (input, forward ...) that will
see packets.  So, providing an entry point that is not support is
harmless (never called/used), but the reverse is NOT, this will cause
crash because the ebtables traverser doesn't expect a NULL blob for
a location its receiving packets for.

Instead of fixing all the individual checks, do what iptables is doing and
reject all blobs that doesn't provide the expected hooks.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Harshit, can you check if this also silences your reproducer?

 Thanks!

 include/linux/netfilter_bridge/ebtables.h | 4 ----
 net/bridge/netfilter/ebtable_broute.c     | 8 --------
 net/bridge/netfilter/ebtable_filter.c     | 8 --------
 net/bridge/netfilter/ebtable_nat.c        | 8 --------
 net/bridge/netfilter/ebtables.c           | 8 +-------
 5 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index a13296d6c7ce..fd533552a062 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -94,10 +94,6 @@ struct ebt_table {
 	struct ebt_replace_kernel *table;
 	unsigned int valid_hooks;
 	rwlock_t lock;
-	/* e.g. could be the table explicitly only allows certain
-	 * matches, targets, ... 0 == let it in */
-	int (*check)(const struct ebt_table_info *info,
-	   unsigned int valid_hooks);
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
 	struct nf_hook_ops *ops;
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 1a11064f9990..8f19253024b0 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)&initial_chain,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~(1 << NF_BR_BROUTING))
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table broute_table = {
 	.name		= "broute",
 	.table		= &initial_table,
 	.valid_hooks	= 1 << NF_BR_BROUTING,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index cb949436bc0e..278f324e6752 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~FILTER_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_filter = {
 	.name		= "filter",
 	.table		= &initial_table,
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 5ee0531ae506..9066f7f376d5 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~NAT_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_nat = {
 	.name		= "nat",
 	.table		= &initial_table,
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f2dbefb61ce8..9a0ae59cdc50 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1040,8 +1040,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	/* the table doesn't like it */
-	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
+	if (repl->valid_hooks != t->valid_hooks)
 		goto free_unlock;
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
@@ -1231,11 +1230,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	if (ret != 0)
 		goto free_chainstack;
 
-	if (table->check && table->check(newinfo, table->valid_hooks)) {
-		ret = -EINVAL;
-		goto free_chainstack;
-	}
-
 	table->private = newinfo;
 	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
-- 
2.37.2

