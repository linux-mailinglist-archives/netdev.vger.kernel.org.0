Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E092D12EB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbfJIPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbfJIPhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 11:37:06 -0400
Received: from paulmck-ThinkPad-P72 (mobile-166-137-176-109.mycingular.net [166.137.176.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304D9218AC;
        Wed,  9 Oct 2019 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570635425;
        bh=edf3a7Xyb4Ic5cpCpe6yHS1CA/n0vMcGLXMOlQSiBDg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=UsVnXzAIzR9JpLCn6O++S2Alq32z1XzoL7CfrtrT9iC2Bo0HNdbEOUmEWiXGhZKgx
         vjuRbLjOI8qbqYcp1pQ0CB6If1Fac/28dbE+e+Ue4pYPQwx/LyYIhkw4YIJkL6+Phr
         UKrIppp5CAM5RiV5D4NOZtnRaAveBHLwVySAldQg=
Date:   Wed, 9 Oct 2019 08:36:59 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 8/9] net/netfilter: Replace
 rcu_swap_protected() with rcu_replace()
Message-ID: <20191009153659.GA30521@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
 <20191003014310.13262-8-paulmck@kernel.org>
 <20191008141611.usmxb5vzoxc36wqw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008141611.usmxb5vzoxc36wqw@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 04:16:11PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 02, 2019 at 06:43:09PM -0700, paulmck@kernel.org wrote:
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> > 
> > This commit replaces the use of rcu_swap_protected() with the more
> > intuitively appealing rcu_replace() as a step towards removing
> > rcu_swap_protected().
> > 
> > Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: <netfilter-devel@vger.kernel.org>
> > Cc: <coreteam@netfilter.org>
> > Cc: <netdev@vger.kernel.org>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thank you!

							Thanx, Paul

> > ---
> >  net/netfilter/nf_tables_api.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index d481f9b..8499baf 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1461,8 +1461,9 @@ static void nft_chain_stats_replace(struct nft_trans *trans)
> >  	if (!nft_trans_chain_stats(trans))
> >  		return;
> >  
> > -	rcu_swap_protected(chain->stats, nft_trans_chain_stats(trans),
> > -			   lockdep_commit_lock_is_held(trans->ctx.net));
> > +	nft_trans_chain_stats(trans) =
> > +		rcu_replace(chain->stats, nft_trans_chain_stats(trans),
> > +			    lockdep_commit_lock_is_held(trans->ctx.net));
> >  
> >  	if (!nft_trans_chain_stats(trans))
> >  		static_branch_inc(&nft_counters_enabled);
> > -- 
> > 2.9.5
> > 
