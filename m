Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13390226A43
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbgGTQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:32:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58860 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731814AbgGTP4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:56:42 -0400
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595260599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clYTdArRdnx8mUCi/6xsqdXNjJnzuyuPzhNso4mGT9g=;
        b=uXP6OXj4rWOPT9ZuoQGhCoFDOm9E+p7U4ur8edGLpLfoB1AlvIgmmnhesTx0TREpABsnZ/
        gLBb0J9qY41Vo7hNHPVFUoNpbyxJQ6VHTZ+u1tPAA2wRG7wc/CLS2o0FG/FTf99KnxuiaG
        s7mGpi466rjCvRjQB9KSG6vq/TkxJJR3G9cPZDgKnI/G8UHHmzzmew9jHWbqabruzHrb/9
        8uMifwVm2uSKKPJ4KJGOw4VArdJERrk+U/SxEDgVxh9jSB2sB04L5H8k9jktzIHTib08LI
        OBgN11BbPi+ORsSWRsmaLxMDGXeUiMBADGAgY20gHwMKaWTGZraixjL1xITBZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595260599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clYTdArRdnx8mUCi/6xsqdXNjJnzuyuPzhNso4mGT9g=;
        b=fx6dou1SVwHKIuhBOH55Prdh6wdRl0YmMNh7qRjwAe1n+oDXY6kyjCRQE4DEbKFGOB8+XH
        5s0q7veTTE+t/mAw==
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 14/24] netfilter: conntrack: Use sequence counter with associated spinlock
Date:   Mon, 20 Jul 2020 17:55:20 +0200
Message-Id: <20200720155530.1173732-15-a.darwish@linutronix.de>
In-Reply-To: <20200720155530.1173732-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200720155530.1173732-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sequence counter write side critical section must be protected by some
form of locking to serialize writers. A plain seqcount_t does not
contain the information of which lock must be held when entering a write
side critical section.

Use the new seqcount_spinlock_t data type, which allows to associate a
spinlock with the sequence counter. This enables lockdep to verify that
the spinlock used for writer serialization is held when the write side
critical section is entered.

If lockdep is disabled this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c    | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 90690e37a56f..ea4e2010b246 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -286,7 +286,7 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
 
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
-extern seqcount_t nf_conntrack_generation;
+extern seqcount_spinlock_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
 
 /* must be called with rcu read lock held */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 79cd9dde457b..b8c54d390f93 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
-seqcount_t nf_conntrack_generation __read_mostly;
+seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static unsigned int nf_conntrack_hash_rnd __read_mostly;
 
 static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
@@ -2598,7 +2598,8 @@ int nf_conntrack_init_start(void)
 	/* struct nf_ct_ext uses u8 to store offsets/size */
 	BUILD_BUG_ON(total_extension_size() > 255u);
 
-	seqcount_init(&nf_conntrack_generation);
+	seqcount_spinlock_init(&nf_conntrack_generation,
+			       &nf_conntrack_locks_all_lock);
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_conntrack_locks[i]);
-- 
2.20.1

