Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8EF52DFBD
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245323AbiESWCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiESWCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85688C8BFA;
        Thu, 19 May 2022 15:02:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 02/11] netfilter: nf_conncount: reduce unnecessary GC
Date:   Fri, 20 May 2022 00:01:57 +0200
Message-Id: <20220519220206.722153-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>

Currently nf_conncount can trigger garbage collection (GC)
at multiple places. Each GC process takes a spin_lock_bh
to traverse the nf_conncount_list. We found that when testing
port scanning use two parallel nmap, because the number of
connection increase fast, the nf_conncount_count and its
subsequent call to __nf_conncount_add take too much time,
causing several CPU lockup. This happens when user set the
conntrack limit to +20,000, because the larger the limit,
the longer the list that GC has to traverse.

The patch mitigate the performance issue by avoiding unnecessary
GC with a timestamp. Whenever nf_conncount has done a GC,
a timestamp is updated, and beforce the next time GC is
triggered, we make sure it's more than a jiffies.
By doin this we can greatly reduce the CPU cycles and
avoid the softirq lockup.

To reproduce it in OVS,
$ ovs-appctl dpctl/ct-set-limits zone=1,limit=20000
$ ovs-appctl dpctl/ct-get-limits

At another machine, runs two nmap
$ nmap -p1- <IP>
$ nmap -p1- <IP>

Signed-off-by: William Tu <u9012063@gmail.com>
Co-authored-by: Yifeng Sun <pkusunyifeng@gmail.com>
Reported-by: Greg Rose <gvrose8192@gmail.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h |  1 +
 net/netfilter/nf_conncount.c               | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 9645b47fa7e4..e227d997fc71 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -10,6 +10,7 @@ struct nf_conncount_data;
 
 struct nf_conncount_list {
 	spinlock_t list_lock;
+	u32 last_gc;		/* jiffies at most recent gc */
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
 };
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 82f36beb2e76..5d8ed6c90b7e 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,6 +132,9 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
+	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+		goto add_new_node;
+
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_NODES)
@@ -177,6 +180,7 @@ static int __nf_conncount_add(struct net *net,
 		nf_ct_put(found_ct);
 	}
 
+add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX))
 		return -EOVERFLOW;
 
@@ -190,6 +194,7 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
+	list->last_gc = (u32)jiffies;
 	return 0;
 }
 
@@ -214,6 +219,7 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 0;
+	list->last_gc = (u32)jiffies;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
@@ -227,6 +233,10 @@ bool nf_conncount_gc_list(struct net *net,
 	unsigned int collected = 0;
 	bool ret = false;
 
+	/* don't bother if we just did GC */
+	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+		return false;
+
 	/* don't bother if other cpu is already doing GC */
 	if (!spin_trylock(&list->list_lock))
 		return false;
@@ -258,6 +268,7 @@ bool nf_conncount_gc_list(struct net *net,
 
 	if (!list->count)
 		ret = true;
+	list->last_gc = (u32)jiffies;
 	spin_unlock(&list->list_lock);
 
 	return ret;
-- 
2.30.2

