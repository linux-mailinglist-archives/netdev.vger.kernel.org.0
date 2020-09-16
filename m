Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412D326CF5F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgIPXPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 19:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgIPXPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 19:15:06 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E401E22205;
        Wed, 16 Sep 2020 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600298105;
        bh=c8yswup9fEqdroo+11JlgMNYrPAHpEYaACRkVanOMxA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=K5arknn+W3p4QHaOFNFrKDrCDyTQ2SA4ZLp/RMgps4EL4VTtxYr5oUgW+2TvwKflH
         9wjNv7bl0/9ttYmXzjuQb4SNeuEzOpCb69z/eSQGzfyNkL/pCsDyH9PuFU5/Ab1Z0C
         IDySUd6ZGJDeojza4aCUuvhC1NtbJWB4/vbkvIXk=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 988913522BA0; Wed, 16 Sep 2020 16:15:05 -0700 (PDT)
Date:   Wed, 16 Sep 2020 16:15:05 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, joel@joelfernandes.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH net-next 0/7] rcu: prevent RCU_LOCKDEP_WARN() from
 swallowing  the condition
Message-ID: <20200916231505.GH29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:45:21AM -0700, Jakub Kicinski wrote:
> Hi!
> 
> So I unfolded the RFC patch into smaller chunks and fixed an issue
> in SRCU pointed out by build bot. Build bot has been quiet for
> a day but I'm not 100% sure it's scanning my tree, so let's
> give these patches some ML exposure.
> 
> The motivation here is that we run into a unused variable
> warning in networking code because RCU_LOCKDEP_WARN() makes
> its argument disappear with !LOCKDEP / !PROVE_RCU. We marked
> the variable as __maybe_unused, but that's ugly IMHO.
> 
> This set makes the relevant function declarations visible to
> the compiler and uses (0 && (condition)) to make the compiler
> remove those calls before linker realizes they are never defined.
> 
> I'm tentatively marking these for net-next, but if anyone (Paul?)
> wants to take them into their tree - even better.

I have pulled these into -rcu for review and further testing, thank you!
I of course could not resist editing the commit logs, so please check
to make sure that I did not mess anything up.  Just so you know, unless
this is urgent, it is in my v5.11 pile, that is, for the merge window
after next.

If someone else wants to take them, please feel free to add my
Acked-by to the RCU pieces.

							Thanx, Paul

> Jakub Kicinski (7):
>   sched: un-hide lockdep_tasklist_lock_is_held() for !LOCKDEP
>   rcu: un-hide lockdep maps for !LOCKDEP
>   net: un-hide lockdep_sock_is_held() for !LOCKDEP
>   net: sched: remove broken definitions and un-hide for !LOCKDEP
>   srcu: use a more appropriate lockdep helper
>   lockdep: provide dummy forward declaration of *_is_held() helpers
>   rcu: prevent RCU_LOCKDEP_WARN() from swallowing the condition
> 
>  include/linux/lockdep.h        |  6 ++++++
>  include/linux/rcupdate.h       | 11 ++++++-----
>  include/linux/rcupdate_trace.h |  4 ++--
>  include/linux/sched/task.h     |  2 --
>  include/net/sch_generic.h      | 12 ------------
>  include/net/sock.h             |  2 --
>  kernel/rcu/srcutree.c          |  2 +-
>  7 files changed, 15 insertions(+), 24 deletions(-)
> 
> -- 
> 2.26.2
> 
