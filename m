Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DC686C79
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjBARMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBARMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:12:01 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A14D9EED;
        Wed,  1 Feb 2023 09:12:00 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 714DA4B3;
        Wed,  1 Feb 2023 09:12:42 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.13.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 585CB3F64C;
        Wed,  1 Feb 2023 09:11:58 -0800 (PST)
Date:   Wed, 1 Feb 2023 17:11:55 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9qdWzOfiUZP2dET@FVFF77S0Q05N>
References: <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
 <20230130194823.6y3rc227bvsgele4@treble>
 <Y9jr0fP7DtA9Of1L@FVFF77S0Q05N>
 <20230131163832.z46ihurbmjcwuvck@treble>
 <Y9pInB8KvcyhAwDa@FVFF77S0Q05N>
 <20230201165727.lnywx6zyefbqbrke@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201165727.lnywx6zyefbqbrke@treble>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 08:57:27AM -0800, Josh Poimboeuf wrote:
> On Wed, Feb 01, 2023 at 11:10:20AM +0000, Mark Rutland wrote:
> > On Tue, Jan 31, 2023 at 08:38:32AM -0800, Josh Poimboeuf wrote:
> > > On Tue, Jan 31, 2023 at 10:22:09AM +0000, Mark Rutland wrote:
> > > > > Hm, it might be nice if our out-of-line static call implementation would
> > > > > automatically do a static key check as part of static_call_cond() for
> > > > > NULL-type static calls.
> > > > > 
> > > > > But the best answer is probably to just add inline static calls to
> > > > > arm64.  Is the lack of objtool the only thing blocking that?
> > > > 
> > > > The major issues were branch range limitations (and needing the linker to add
> > > > PLTs),
> > > 
> > > Does the compiler do the right thing (e.g., force PLT) if the branch
> > > target is outside the translation unit?  I'm wondering if we could for
> > > example use objtool to help enforce such rules at the call site.
> > 
> > It's the linker (rather than the compiler) that'll generate the PLT if the
> > caller and callee are out of range at link time. There are a few other issues
> > too (e.g. no guarnatee that the PLT isn't used by multiple distinct callers,
> > CMODX patching requirements), so we'd have to generate a pseudo-PLT ourselves
> > at build time with a patching-friendly code sequence. Ard had a prototype for
> > that:
> > 
> >   https://lore.kernel.org/linux-arm-kernel/20211105145917.2828911-1-ardb@kernel.org/
> > 
> > ... but that was sufficiently painful that we went with the current static key
> > approach:
> > 
> >   https://lore.kernel.org/all/20211109172408.49641-1-mark.rutland@arm.com/
> 
> Thanks for the background.
> 
> Was there a reason for putting it out-of-line rather than directly in
> _cond_resched()?

I think that's mostly a historical accident; I'm not aware of a reaason we
can't put that directly in _cond_resched(). 

Since we started from out-of-line static call trampolines, even the out-of-line
static key check looked nicer, and I think we just never considered moving the
static key check inline.

> If it were inline then it wouldn't be that much different from the
> static called version and I wonder if we could simplify by just using
> the static key for all PREEMPT_DYNAMIC configs.

That would be nice!

> > > > If we knew each call-site would only call a particular function or skip the
> > > > call, then we could do better (and would probably need something like objtool
> > > > to NOP that out at compile time), but since we don't know the callee at build
> > > > time we can't ensure we have a PLT in range when necessary.
> > > 
> > > Unfortunately most static calls have multiple destinations.
> > 
> > Sure, but here we're just enabling/disabling a call, which we could treat
> > differently, or wrap at a different level within the scheduler code. I'm happy
> > to take a look at that.
> 
> I can try to emulate what you did for PREEMPT_DYNAMIC.  I'll Cc you on
> my actual patch to come soon-ish.

I look forward to it! :)

> > > And most don't have the option of being NULL.
> > 
> > Oh, I was under the impression that all could be disabled/skipped, which is
> > what a NULL target implied.
> 
> I guess what I was trying to say is that if the target can be NULL, the
> call site has to use static_call_cond() to not break the
> !HAVE_STATIC_CALL case.  But most call sites use static_call().

Ah, sorry -- I had missed that we had distinct static_call_cond() and
static_call() helpers.

Thanks,
Mark.
