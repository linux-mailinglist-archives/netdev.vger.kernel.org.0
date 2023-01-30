Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05335681968
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbjA3Sht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjA3Shb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:37:31 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D96B7AAF;
        Mon, 30 Jan 2023 10:36:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDC211FB;
        Mon, 30 Jan 2023 10:37:23 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.12.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBF2C3F71E;
        Mon, 30 Jan 2023 10:36:39 -0800 (PST)
Date:   Mon, 30 Jan 2023 18:36:32 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 27, 2023 at 02:11:31PM -0800, Josh Poimboeuf wrote:
> > @@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
> >  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
> >  int __sched dynamic_cond_resched(void)
> >  {
> > -	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
> > +	if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
> > +		klp_sched_try_switch();
> >  		return 0;
> > +	}
> >  	return __cond_resched();
> >  }
> >  EXPORT_SYMBOL(dynamic_cond_resched);
> 
> I would make the klp_sched_try_switch() not depend on
> sk_dynamic_cond_resched, because __cond_resched() is not a guaranteed
> pass through __schedule().
> 
> But you'll probably want to check with Mark here, this all might
> generate crap code on arm64.

IIUC here klp_sched_try_switch() is a static call, so on arm64 this'll generate
at least a load, a conditional branch, and an indirect branch. That's not
ideal, but I'd have to benchmark it to find out whether it's a significant
overhead relative to the baseline of PREEMPT_DYNAMIC.

For arm64 it'd be a bit nicer to have another static key check, and a call to
__klp_sched_try_switch(). That way the static key check gets turned into a NOP
in the common case, and the call to __klp_sched_try_switch() can be a direct
call (potentially a tail-call if we made it return 0).

Thanks,
Mark.
