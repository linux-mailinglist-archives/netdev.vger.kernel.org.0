Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC738C3A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfFGOKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:10:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35370 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfFGOKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 10:10:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hZFZB-0006Q2-3B; Fri, 07 Jun 2019 22:10:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hZFYz-000796-Cp; Fri, 07 Jun 2019 22:09:49 +0800
Date:   Fri, 7 Jun 2019 22:09:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: inet: frags: Turn fqdir->dead into an int for old Alphas
Message-ID: <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 09:04:55AM -0700, Linus Torvalds wrote:
>
> In fact, the alpha port was always subtly buggy exactly because of the
> "byte write turns into a read-and-masked-write", even if I don't think
> anybody ever noticed (we did fix cases where people _did_ notice,
> though, and we might still have some cases where we use 'int' for
> booleans because of alpha issues.).

This is in fact a real bug in the code in question that no amount
of READ_ONCE/WRITE_ONCE would have caught.  The field fqdir->dead is
declared as boolean so writing to it is not atomic (on old Alphas).

I don't think it currently matters because padding would ensure
that it is in fact 64 bits long.  However, should someone add another
char/bool/bitfield in this struct in future it could become an issue.

So let's fix it.

---8<--
The field fqdir->dead is meant to be written (and read) atomically.
As old Alpha CPUs can't write a single byte atomically, we need at
least an int for it to work.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index e91b79ad4e4a..8c458fba74ad 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -14,7 +14,9 @@ struct fqdir {
 	int			max_dist;
 	struct inet_frags	*f;
 	struct net		*net;
-	bool			dead;
+
+	/* We can't use boolean because this needs atomic writes. */
+	int			dead;
 
 	struct rhashtable       rhashtable ____cacheline_aligned_in_smp;
 
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 35e9784fab4e..05aa7c145817 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -193,7 +193,7 @@ void fqdir_exit(struct fqdir *fqdir)
 {
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
 
-	fqdir->dead = true;
+	fqdir->dead = 1;
 
 	/* call_rcu is supposed to provide memory barrier semantics,
 	 * separating the setting of fqdir->dead with the destruction
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
