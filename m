Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E40682A55
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjAaKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjAaKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:22:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19FC01E5F8;
        Tue, 31 Jan 2023 02:22:15 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFD102F4;
        Tue, 31 Jan 2023 02:22:56 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.12.254])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C65F63F64C;
        Tue, 31 Jan 2023 02:22:12 -0800 (PST)
Date:   Tue, 31 Jan 2023 10:22:09 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9jr0fP7DtA9Of1L@FVFF77S0Q05N>
References: <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
 <20230130194823.6y3rc227bvsgele4@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130194823.6y3rc227bvsgele4@treble>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:48:23AM -0800, Josh Poimboeuf wrote:
> On Mon, Jan 30, 2023 at 06:36:32PM +0000, Mark Rutland wrote:
> > On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> > > On Fri, Jan 27, 2023 at 02:11:31PM -0800, Josh Poimboeuf wrote:
> > > > @@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
> > > >  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
> > > >  int __sched dynamic_cond_resched(void)
> > > >  {
> > > > -	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
> > > > +	if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
> > > > +		klp_sched_try_switch();
> > > >  		return 0;
> > > > +	}
> > > >  	return __cond_resched();
> > > >  }
> > > >  EXPORT_SYMBOL(dynamic_cond_resched);
> > > 
> > > I would make the klp_sched_try_switch() not depend on
> > > sk_dynamic_cond_resched, because __cond_resched() is not a guaranteed
> > > pass through __schedule().
> > > 
> > > But you'll probably want to check with Mark here, this all might
> > > generate crap code on arm64.
> > 
> > IIUC here klp_sched_try_switch() is a static call, so on arm64 this'll generate
> > at least a load, a conditional branch, and an indirect branch. That's not
> > ideal, but I'd have to benchmark it to find out whether it's a significant
> > overhead relative to the baseline of PREEMPT_DYNAMIC.
> > 
> > For arm64 it'd be a bit nicer to have another static key check, and a call to
> > __klp_sched_try_switch(). That way the static key check gets turned into a NOP
> > in the common case, and the call to __klp_sched_try_switch() can be a direct
> > call (potentially a tail-call if we made it return 0).
> 
> Hm, it might be nice if our out-of-line static call implementation would
> automatically do a static key check as part of static_call_cond() for
> NULL-type static calls.
> 
> But the best answer is probably to just add inline static calls to
> arm64.  Is the lack of objtool the only thing blocking that?

The major issues were branch range limitations (and needing the linker to add
PLTs), and painful instruction patching requirements (e.g. the architecture's
"CMODX" rules for Concurrent MODification and eXecution of instructions). We
went with the static key scheme above because that was what our assembled code
generation would devolve to anyway.

If we knew each call-site would only call a particular function or skip the
call, then we could do better (and would probably need something like objtool
to NOP that out at compile time), but since we don't know the callee at build
time we can't ensure we have a PLT in range when necessary.

> Objtool is now modular, so all the controversial CFG reverse engineering
> is now optional, so it shouldn't be too hard to just enable objtool for
> static call inlines.

Funnily enough, I spent some time yesterday looking at enabling a trivial
objtool for arm64 as I wanted some basic ELF rewriting functionality (to
manipulate the mcount_loc table). So I'll likely be looking at that soon
regardless of static calls. :)

Thanks,
Mark.
