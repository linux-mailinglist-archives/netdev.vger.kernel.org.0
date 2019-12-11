Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9716E11BC24
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfLKSqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbfLKSqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 13:46:11 -0500
Received: from paulmck-ThinkPad-P72.home (unknown [199.201.64.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A3520663;
        Wed, 11 Dec 2019 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576089969;
        bh=Rxu3mxn5istrjLGBr8ceMQOBnhaUS3GdugN8U5Q6Rl4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nUmRiHtB8Ht3AcdvCUFWUPZnA+1gNnKjEtCGlErAJ8wKdvaWMLfoova0MinBcPcOI
         58pPK1VHXHWHbzQe0wLy/aWcDJs/2+ekX4LKMPVGDfQ5S9TIerYyWLugZZUY302XKA
         n6Ns7DRy6iDJ2Bi7t7W01yz9jwC1pEVyVg0Iy6hY=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1D59F35203C6; Wed, 11 Dec 2019 10:46:09 -0800 (PST)
Date:   Wed, 11 Dec 2019 10:46:09 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Ying Xue <ying.xue@windriver.com>
Cc:     Tuong Lien Tong <tuong.t.lien@dektech.com.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tipc-discussion@lists.sourceforge.net,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        davem@davemloft.net
Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
 with rcu_replace_pointer()
Message-ID: <20191211184609.GI2889@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
 <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
 <20191210223825.GS2889@paulmck-ThinkPad-P72>
 <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
 <707801d5afc6$cac68190$605384b0$@dektech.com.au>
 <db88d33f-8e25-8859-84ec-3372a108c759@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db88d33f-8e25-8859-84ec-3372a108c759@windriver.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 12:42:00PM +0800, Ying Xue wrote:
> On 12/11/19 10:00 AM, Tuong Lien Tong wrote:
> >>  
> >>  	/* Move passive key if any */
> >>  	if (key.passive) {
> >> -		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
> >> +		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2,
> > &rx->lock);
> > The 3rd parameter should be the lockdep condition checking instead of the
> > spinlock's pointer i.e. "lockdep_is_held(&rx->lock)"?
> > That's why I'd prefer to use the 'tipc_aead_rcu_swap ()' macro, which is
> > clear & concise at least for the context here. It might be re-used later as
> > well...
> > 
> 
> Right. The 3rd parameter of rcu_replace_pointer() should be
> "lockdep_is_held(&rx->lock)" instead of "&rx->lock".

Like this?

							Thanx, Paul

------------------------------------------------------------------------

commit 575bb4ba1b22383656760feb3d122e11656ccdfd
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
    [ paulmck: Updated based on Ying Xue and Tuong Lien Tong feedback. ]
    Cc: Jon Maloy <jon.maloy@ericsson.com>
    Cc: Ying Xue <ying.xue@windriver.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: <netdev@vger.kernel.org>
    Cc: <tipc-discussion@lists.sourceforge.net>

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 990a872..c8c47fc 100644
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
+		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, lockdep_is_held(&rx->lock));
 		x = (key.passive - key.pending + new_pending) % KEY_MAX;
 		new_passive = (x <= 0) ? x + KEY_MAX : x;
 	}
