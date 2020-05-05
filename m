Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28551C5ECF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgEERai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbgEERah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:30:37 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD13206CC;
        Tue,  5 May 2020 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588699837;
        bh=MouvZdHsdnjyis+tScVss79YLBC0aL95s0sk0aJMFZI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=fm3MM3+NNfbcyRavzlXSx/Pw2qaXkwRr1YZ96Xvb+3a7EFCTzLxkAutGjtD19No4Y
         P1BQ1Fy12LLVUAmG2vdeq2ENsdUefItrE8mD/lLpXPBi6Htx9KdI+mfTSFG/vW3YCW
         zJMV/+9ALDR30YQuZRLaUsbWPZeqWtYzxvRT3rdA=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id E1D4E3522F5F; Tue,  5 May 2020 10:30:36 -0700 (PDT)
Date:   Tue, 5 May 2020 10:30:36 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle
 change
Message-ID: <20200505173036.GE2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <67bdfac9-0d7d-0bbe-dc7a-d73979fd8ed9@gmail.com>
 <20200505170553.24056-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505170553.24056-1-sjpark@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 07:05:53PM +0200, SeongJae Park wrote:
> On Tue, 5 May 2020 09:37:42 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > 
> > 
> > On 5/5/20 9:31 AM, Eric Dumazet wrote:
> > > 
> > > 
> > > On 5/5/20 9:25 AM, Eric Dumazet wrote:
> > >>
> > >>
> > >> On 5/5/20 9:13 AM, SeongJae Park wrote:
> > >>> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > >>>
> > >>>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> > >>>>>
> > >>>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>>>>
> > >>>>>>
> > >>>>>>
> > >>>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
> > >>>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > >>>>>>>
> > >>>>>>
> [...]
> > >>
> > >> I would ask Paul opinion on this issue, because we have many objects
> > >> being freed after RCU grace periods.
> > >>
> > >> If RCU subsystem can not keep-up, I guess other workloads will also suffer.
> > >>
> > >> Sure, we can revert patches there and there trying to work around the issue,
> > >> but for objects allocated from process context, we should not have these problems.
> > >>
> > > 
> > > I wonder if simply adjusting rcu_divisor to 6 or 5 would help 
> > > 
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index d9a49cd6065a20936edbda1b334136ab597cde52..fde833bac0f9f81e8536211b4dad6e7575c1219a 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -427,7 +427,7 @@ module_param(qovld, long, 0444);
> > >  static ulong jiffies_till_first_fqs = ULONG_MAX;
> > >  static ulong jiffies_till_next_fqs = ULONG_MAX;
> > >  static bool rcu_kick_kthreads;
> > > -static int rcu_divisor = 7;
> > > +static int rcu_divisor = 6;
> > >  module_param(rcu_divisor, int, 0644);
> > >  
> > >  /* Force an exit from rcu_do_batch() after 3 milliseconds. */
> > > 
> > 
> > To be clear, you can adjust the value without building a new kernel.
> > 
> > echo 6 >/sys/module/rcutree/parameters/rcu_divisor
> 
> I tried value 6, 5, and 4, but none of those removed the problem.

Thank you for checking this!

Was your earlier discussion on long RCU readers speculation, or do you
have measurements?

							Thanx, Paul
