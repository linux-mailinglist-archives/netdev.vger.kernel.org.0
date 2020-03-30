Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF19197160
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgC3Ahv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:51 -0400
Received: from correo.us.es ([193.147.175.20]:57148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgC3AhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 346FCDA72F
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2472B100A4B
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A03B100A42; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 350B7100A53;
        Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0BD3342EF42A;
        Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/26] netfilter: nf_queue: do not release refcouts until nf_reinject is done
Date:   Mon, 30 Mar 2020 02:37:01 +0200
Message-Id: <20200330003708.54017-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_queue is problematic when another NF_QUEUE invocation happens
from nf_reinject().

1. nf_queue is invoked, increments state->sk refcount.
2. skb is queued, waiting for verdict.
3. sk is closed/released.
3. verdict comes back, nf_reinject is called.
4. nf_reinject drops the reference -- refcount can now drop to 0

Instead of get_ref/release_ref pattern, we need to nest the get_ref calls:
    get_ref
       get_ref
       release_ref
     release_ref

So that when we invoke the next processing stage (another netfilter
or the okfn()), we hold at least one reference count on the
devices/socket.

After previous patch, it is now safe to put the entry even after okfn()
has potentially free'd the skb.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 96eb72908467..aadccdd117f0 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -303,12 +303,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
-	nf_queue_entry_release_refs(entry);
-
 	i = entry->hook_index;
 	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
 		kfree_skb(skb);
-		kfree(entry);
+		nf_queue_entry_free(entry);
 		return;
 	}
 
@@ -347,6 +345,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		kfree_skb(skb);
 	}
 
-	kfree(entry);
+	nf_queue_entry_free(entry);
 }
 EXPORT_SYMBOL(nf_reinject);
-- 
2.11.0

