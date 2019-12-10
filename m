Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B669119D7A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfLJWi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:38:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbfLJWi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:38:27 -0500
Received: from paulmck-ThinkPad-P72.home (unknown [199.201.64.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B00C2077B;
        Tue, 10 Dec 2019 22:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017506;
        bh=FZWcj2uubErXZMXLQWTdtQCV61a2rTeZ4M7n9iQJZWM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CIdHPCv75hoxrLSG5mf3J7CFnStYJucNShYdzH3Ok01S2/G/jzAsvjNsIO7ao2Wzq
         mcwEx4ATmZQS2ZO8qbh+zxJjQWQXs65EDu7Y/w8n9xwr9iJ6t4pLzSkVbQf3nGA4Xm
         8qC0Vv+CoMejsHy4TZnUv3mwRXlKCNR3Cd5JeGsM=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id DF8D2352276D; Tue, 10 Dec 2019 14:38:25 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:38:25 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Ying Xue <ying.xue@windriver.com>
Cc:     linux-kernel@vger.kernel.org, jon.maloy@ericsson.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        torvalds@linux-foundation.org, mingo@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net/tipc] Replace rcu_swap_protected() with
 rcu_replace_pointer()
Message-ID: <20191210223825.GS2889@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
 <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:36:59PM +0800, Ying Xue wrote:
> On 12/10/19 11:31 AM, Paul E. McKenney wrote:
> > This commit replaces the use of rcu_swap_protected() with the more
> > intuitively appealing rcu_replace_pointer() as a step towards removing
> > rcu_swap_protected().
> > 
> > Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Jon Maloy <jon.maloy@ericsson.com>
> > Cc: Ying Xue <ying.xue@windriver.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: <netdev@vger.kernel.org>
> > Cc: <tipc-discussion@lists.sourceforge.net>
> > 
> > diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> > index 990a872..64cf831 100644
> > --- a/net/tipc/crypto.c
> > +++ b/net/tipc/crypto.c
> > @@ -258,7 +258,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
> >  	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
> >  
> >  #define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
> > -	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
> > +	rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))
> 
> (ptr) = rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))
> 
> >  
> >  #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
> >  do {									\
> > @@ -1189,7 +1189,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
> >  
> >  	/* Move passive key if any */
> >  	if (key.passive) {
> > -		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
> > +		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, &rx->lock);
> 
> tipc_aead_rcu_swap() is only called here in TIPC module. If we use
> rcu_replace_pointer() to switch pointers instead of calling
> tipc_aead_rcu_swap() macro, I think we should completely remove
> tipc_aead_rcu_swap().

Good catch, thank you!  How about the following instead?

							Thanx, Paul

------------------------------------------------------------------------

commit 4ee8e2c68b076867b7a5af82a38010fffcab611c
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Mon Dec 9 19:13:45 2019 -0800

    net/tipc: Replace rcu_swap_protected() with rcu_replace_pointer()
    
    This commit replaces the use of rcu_swap_protected() with the more
    intuitively appealing rcu_replace_pointer() as a step towards removing
    rcu_swap_protected().
    
    Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
    Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
    Reported-by: kbuild test robot <lkp@intel.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
    Cc: Jon Maloy <jon.maloy@ericsson.com>
    Cc: Ying Xue <ying.xue@windriver.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: <netdev@vger.kernel.org>
    Cc: <tipc-discussion@lists.sourceforge.net>

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 990a872..978d2db 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -257,9 +257,6 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 #define tipc_aead_rcu_ptr(rcu_ptr, lock)				\
 	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
 
-#define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
-	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
-
 #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
 do {									\
 	typeof(rcu_ptr) __tmp = rcu_dereference_protected((rcu_ptr),	\
@@ -1189,7 +1186,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 
 	/* Move passive key if any */
 	if (key.passive) {
-		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
+		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, &rx->lock);
 		x = (key.passive - key.pending + new_pending) % KEY_MAX;
 		new_passive = (x <= 0) ? x + KEY_MAX : x;
 	}
