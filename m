Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4432D524
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfE2Fke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:40:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50764 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfE2Fke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 01:40:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hVrKB-00049H-0e; Wed, 29 May 2019 13:40:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hVrK6-00035F-FM; Wed, 29 May 2019 13:40:26 +0800
Date:   Wed, 29 May 2019 13:40:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
Message-ID: <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 06:31:00AM -0700, Eric Dumazet wrote:
>
> This smp_store_release() is a left over of the first version of the patch, where
> there was no rcu grace period enforcement.
> 
> I do not believe there is harm letting this, but if you disagree
> please send a patch ;)

I see now that it is actually relying on the barrier/locking
semantics of call_rcu vs. rcu_read_lock.  So the smp_store_release
and READ_ONCE are simply unnecessary and could be confusing to
future readers.

---8<---
The smp_store_release call in fqdir_exit cannot protect the setting
of fqdir->dead as claimed because its memory barrier is only
guaranteed to be one-way and the barrier precedes the setting of
fqdir->dead.

IOW it doesn't provide any barriers between fq->dir and the following
hash table destruction.

In fact, the code is safe anyway because call_rcu does provide both
the memory barrier as well as a guarantee that when the destruction
work starts executing all RCU readers will see the updated value for
fqdir->dead.

Therefore this patch removes the unnecessary smp_store_release call
as well as the corresponding READ_ONCE on the read-side in order to
not confuse future readers of this code.  Comments have been added
in their places.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 2b816f1ebbb4..35e9784fab4e 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -193,10 +193,12 @@ void fqdir_exit(struct fqdir *fqdir)
 {
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
 
-	/* paired with READ_ONCE() in inet_frag_kill() :
-	 * We want to prevent rhashtable_remove_fast() calls
+	fqdir->dead = true;
+
+	/* call_rcu is supposed to provide memory barrier semantics,
+	 * separating the setting of fqdir->dead with the destruction
+	 * work.  This implicit barrier is paired with inet_frag_kill().
 	 */
-	smp_store_release(&fqdir->dead, true);
 
 	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
 	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
@@ -214,10 +216,12 @@ void inet_frag_kill(struct inet_frag_queue *fq)
 
 		fq->flags |= INET_FRAG_COMPLETE;
 		rcu_read_lock();
-		/* This READ_ONCE() is paired with smp_store_release()
-		 * in inet_frags_exit_net().
+		/* The RCU read lock provides a memory barrier
+		 * guaranteeing that if fqdir->dead is false then
+		 * the hash table destruction will not start until
+		 * after we unlock.  Paired with inet_frags_exit_net().
 		 */
-		if (!READ_ONCE(fqdir->dead)) {
+		if (!fqdir->dead) {
 			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
 					       fqdir->f->rhash_params);
 			refcount_dec(&fq->refcnt);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
