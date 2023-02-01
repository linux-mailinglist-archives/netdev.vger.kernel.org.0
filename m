Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9CF686C3A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjBAQ5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjBAQ5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:57:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FE87AE6B;
        Wed,  1 Feb 2023 08:57:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6FF0617FE;
        Wed,  1 Feb 2023 16:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90412C433D2;
        Wed,  1 Feb 2023 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675270650;
        bh=88ud5EpOU9fVi8hvERQFc6r3nXAyErWparuTT1Z9qrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITMgGWC6UUatXejr/qQoEjL0/tsX0KqlgCAA/AjKR6Z0+M/ltYdVilOC3qMq+ivfe
         OgQlQoKhXIHPgISSIBJPZ2Dig5eKCEUh/q4sV0V8D3nPl+9QXIupbjRl0B5JEpZSv0
         tePQs04RPtqFYjzGfPJfJu3uSAIzjE1k5TFPPG473njGYcbV9IGdMMz137K9uEOZXZ
         HU9Z2K2t1/5z4u9+QHVOx5qAUgxcaIBh3/Jq/WUUN1xGmgzrXd/AARzH8dBjtFhHu/
         T92B44n5ABCXwUl7Va0nmAcBldq/PF9OGOIIlNvqHB+gXuM4y7z1NzHLGbhgTWd8Kp
         bLNTzttmcVwgw==
Date:   Wed, 1 Feb 2023 08:57:27 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20230201165727.lnywx6zyefbqbrke@treble>
References: <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
 <20230130194823.6y3rc227bvsgele4@treble>
 <Y9jr0fP7DtA9Of1L@FVFF77S0Q05N>
 <20230131163832.z46ihurbmjcwuvck@treble>
 <Y9pInB8KvcyhAwDa@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9pInB8KvcyhAwDa@FVFF77S0Q05N>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 11:10:20AM +0000, Mark Rutland wrote:
> On Tue, Jan 31, 2023 at 08:38:32AM -0800, Josh Poimboeuf wrote:
> > On Tue, Jan 31, 2023 at 10:22:09AM +0000, Mark Rutland wrote:
> > > > Hm, it might be nice if our out-of-line static call implementation would
> > > > automatically do a static key check as part of static_call_cond() for
> > > > NULL-type static calls.
> > > > 
> > > > But the best answer is probably to just add inline static calls to
> > > > arm64.  Is the lack of objtool the only thing blocking that?
> > > 
> > > The major issues were branch range limitations (and needing the linker to add
> > > PLTs),
> > 
> > Does the compiler do the right thing (e.g., force PLT) if the branch
> > target is outside the translation unit?  I'm wondering if we could for
> > example use objtool to help enforce such rules at the call site.
> 
> It's the linker (rather than the compiler) that'll generate the PLT if the
> caller and callee are out of range at link time. There are a few other issues
> too (e.g. no guarnatee that the PLT isn't used by multiple distinct callers,
> CMODX patching requirements), so we'd have to generate a pseudo-PLT ourselves
> at build time with a patching-friendly code sequence. Ard had a prototype for
> that:
> 
>   https://lore.kernel.org/linux-arm-kernel/20211105145917.2828911-1-ardb@kernel.org/
> 
> ... but that was sufficiently painful that we went with the current static key
> approach:
> 
>   https://lore.kernel.org/all/20211109172408.49641-1-mark.rutland@arm.com/

Thanks for the background.

Was there a reason for putting it out-of-line rather than directly in
_cond_resched()?

If it were inline then it wouldn't be that much different from the
static called version and I wonder if we could simplify by just using
the static key for all PREEMPT_DYNAMIC configs.

> > > If we knew each call-site would only call a particular function or skip the
> > > call, then we could do better (and would probably need something like objtool
> > > to NOP that out at compile time), but since we don't know the callee at build
> > > time we can't ensure we have a PLT in range when necessary.
> > 
> > Unfortunately most static calls have multiple destinations.
> 
> Sure, but here we're just enabling/disabling a call, which we could treat
> differently, or wrap at a different level within the scheduler code. I'm happy
> to take a look at that.

I can try to emulate what you did for PREEMPT_DYNAMIC.  I'll Cc you on
my actual patch to come soon-ish.

> > And most don't have the option of being NULL.
> 
> Oh, I was under the impression that all could be disabled/skipped, which is
> what a NULL target implied.

I guess what I was trying to say is that if the target can be NULL, the
call site has to use static_call_cond() to not break the
!HAVE_STATIC_CALL case.  But most call sites use static_call().

-- 
Josh
