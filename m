Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF35681AC2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbjA3Tsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjA3Ts3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:48:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EF72DE69;
        Mon, 30 Jan 2023 11:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B87EB8168A;
        Mon, 30 Jan 2023 19:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D00C433D2;
        Mon, 30 Jan 2023 19:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675108105;
        bh=wGv8sCcgO6nt+OXIB6jBJsAXkbfr6IKEvPeBfyQ78EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5MDjYEACiFey5Qm6YKt6DRhuFh8Q0STasW5zJummRj/RJbXsvo3RGQUbZXDKWCmR
         VgCA42DCeIdk8PMCA3pZDiA123yfvw+nrqlcHEO0lhZpQPMMqnKcjJW05pAZfvvEbF
         h+E/BLT08CiJpbedmZA6w/o3zWpxyviK1RR9YP2ll/i8DiUsDHvSUSsAFdOOm3bUbz
         vfH+aiYrxsqi2tYtKptwnQQWB4ZiqfxwtHZkDke+Dc2B4Osx8PGFab5zVosZTvfN/d
         pL/7xvw8p1IqqMdS6nlvlrUDzZgdCTtjUpci9ciB5c88uQM6Wj2cKoMqqxUjy2mqZo
         90twlMDFKwedQ==
Date:   Mon, 30 Jan 2023 11:48:23 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20230130194823.6y3rc227bvsgele4@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 06:36:32PM +0000, Mark Rutland wrote:
> On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> > On Fri, Jan 27, 2023 at 02:11:31PM -0800, Josh Poimboeuf wrote:
> > > @@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
> > >  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
> > >  int __sched dynamic_cond_resched(void)
> > >  {
> > > -	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
> > > +	if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
> > > +		klp_sched_try_switch();
> > >  		return 0;
> > > +	}
> > >  	return __cond_resched();
> > >  }
> > >  EXPORT_SYMBOL(dynamic_cond_resched);
> > 
> > I would make the klp_sched_try_switch() not depend on
> > sk_dynamic_cond_resched, because __cond_resched() is not a guaranteed
> > pass through __schedule().
> > 
> > But you'll probably want to check with Mark here, this all might
> > generate crap code on arm64.
> 
> IIUC here klp_sched_try_switch() is a static call, so on arm64 this'll generate
> at least a load, a conditional branch, and an indirect branch. That's not
> ideal, but I'd have to benchmark it to find out whether it's a significant
> overhead relative to the baseline of PREEMPT_DYNAMIC.
> 
> For arm64 it'd be a bit nicer to have another static key check, and a call to
> __klp_sched_try_switch(). That way the static key check gets turned into a NOP
> in the common case, and the call to __klp_sched_try_switch() can be a direct
> call (potentially a tail-call if we made it return 0).

Hm, it might be nice if our out-of-line static call implementation would
automatically do a static key check as part of static_call_cond() for
NULL-type static calls.

But the best answer is probably to just add inline static calls to
arm64.  Is the lack of objtool the only thing blocking that?

Objtool is now modular, so all the controversial CFG reverse engineering
is now optional, so it shouldn't be too hard to just enable objtool for
static call inlines.

-- 
Josh
