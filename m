Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D2520EDC1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgF3Fpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgF3Fpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:45:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05BBC061755;
        Mon, 29 Jun 2020 22:45:54 -0700 (PDT)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593495951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L61pJxSRU8yRIzK3/wT0+4/FnQuZFh6diO59e1nBA5s=;
        b=LDZL++k3mOdrAF/jnnRatPo7GE9cI70dYZEFt7L6l4Ji722izYdkGbzQtspXxEN03yzLmU
        DTiW6tr/S0yD/I4PAJCP7SRvmwoBxi491buWfD+PioCAW1wt1TDhCXiDm5bMP/R7JIw3uI
        0BGV5ZNzDL7XxgCvgKzWBQx8XXptBZF22TpJEz3RDfdOUzSRRzCsRRU73QvD59ZuGNZerS
        rwz2IiCQAKHRIvKpogdSo/ipOUWD4KUeY0FEGclfrXtDaYOvjqeHWHLb7TaAFiY7hsQ25g
        ZtutgPIKxHuc/r+vIITUcd9OfAz/UPPv1z3rn9NcRzL15fNFPH+UYUYq4bMEUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593495951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L61pJxSRU8yRIzK3/wT0+4/FnQuZFh6diO59e1nBA5s=;
        b=NDVk0WmvCuwmFWcSHotlDQy5Ka6dQn/tGUwE1nRJ/z7agWpbBW0MViNDPMbPeGheqNAetz
        tybLDJ8koYa4F6CQ==
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
Subject: [PATCH v3 11/20] netfilter: nft_set_rbtree: Use sequence counter with associated rwlock
Date:   Tue, 30 Jun 2020 07:44:43 +0200
Message-Id: <20200630054452.3675847-12-a.darwish@linutronix.de>
In-Reply-To: <20200630054452.3675847-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200630054452.3675847-1-a.darwish@linutronix.de>
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

Use the new seqcount_rwlock_t data type, which allows to associate a
rwlock with the sequence counter. This enables lockdep to verify that
the rwlock used for writer serialization is held when the write side
critical section is entered.

If lockdep is disabled this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 net/netfilter/nft_set_rbtree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 62f416bc0579..9f58261ee4c7 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -18,7 +18,7 @@
 struct nft_rbtree {
 	struct rb_root		root;
 	rwlock_t		lock;
-	seqcount_t		count;
+	seqcount_rwlock_t	count;
 	struct delayed_work	gc_work;
 };
 
@@ -516,7 +516,7 @@ static int nft_rbtree_init(const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	rwlock_init(&priv->lock);
-	seqcount_init(&priv->count);
+	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rbtree_gc);
-- 
2.20.1

