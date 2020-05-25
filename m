Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B611E1100
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391071AbgEYOvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390995AbgEYOvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:51:43 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28981C061A0E;
        Mon, 25 May 2020 07:51:43 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jdERu-00028q-3I; Mon, 25 May 2020 16:51:30 +0200
Date:   Mon, 25 May 2020 16:51:30 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/7] connector/cn_proc: Protect send_msg() with a
 local lock
Message-ID: <20200525145130.przpqlspg6nnylke@linutronix.de>
References: <20200524215739.551568-1-bigeasy@linutronix.de>
 <20200524215739.551568-6-bigeasy@linutronix.de>
 <20200525071819.GD329373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200525071819.GD329373@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-25 09:18:19 [+0200], Ingo Molnar wrote:
> > +static DEFINE_PER_CPU(struct local_evt, local_evt) = {
> > +	.counts = 0,
> 
> I don't think zero initializations need to be written out explicitly.
yes.

> > +	.lock = INIT_LOCAL_LOCK(lock),
> > +};
> >  
> >  static inline void send_msg(struct cn_msg *msg)
> >  {
> > -	preempt_disable();
> > +	local_lock(&local_evt.lock);
> >  
> > -	msg->seq = __this_cpu_inc_return(proc_event_counts) - 1;
> > +	msg->seq = __this_cpu_inc_return(local_evt.counts) - 1;
> 
> Naming nit: renaming this from 'proc_event_counts' to 
> 'local_evt.counts' is a step back IMO - what's an 'evt',
> did we run out of e's? ;-)
> 
> Should be something like local_event.count? (Singular.)

okay.

> Thanks,
> 
> 	Ingo

Sebastian
