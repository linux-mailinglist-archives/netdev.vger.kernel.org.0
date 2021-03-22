Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30123439A9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhCVGki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhCVGkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 02:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C29EC6196B;
        Mon, 22 Mar 2021 06:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616395212;
        bh=JFVOrWIAdGWahfEP9JmbRmvN6rewFMu0HiNx1mRw+FU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxKcexQs8n01h5LOR3M1acsaNY8jljvcW38djaNbUFhpUlUclPgnSR/CiSLylP7wV
         FhrFCDU74enGLXC38FgID0tsawa+FJ/QqzArFFuAUkIFBJ0zsm1ak+hk6Ixp7f4bKi
         ZQUtHjU0GE4CQ3IJMIAh0K/G7IyyUdK2Do6siSXQ5iuj7khzkHFBiLZR9zwjru5YKd
         UcahXnNSkharx+tpEKO5A/NWbpqNakBnxoWDJLlM0FnjGKuG0nPEOI6hhnetnrbGkG
         2yn4vjmgWXGM6rYCmHYfXyg6TYDQHxSSW+sbfz0Kd91eftTpODWbm2OgieYIigOxM7
         z2A6YcoTEP3Eg==
Date:   Mon, 22 Mar 2021 08:40:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Message-ID: <YFg7yHUeYvQZt+/Z@unreal>
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org>
 <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
 <YFdO6UnWsm4DAkwc@unreal>
 <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 12:19:02PM -0500, Alex Elder wrote:
> On 3/21/21 8:49 AM, Leon Romanovsky wrote:
> > On Sun, Mar 21, 2021 at 08:21:24AM -0500, Alex Elder wrote:
> >> On 3/21/21 3:21 AM, Leon Romanovsky wrote:
> >>> On Sat, Mar 20, 2021 at 09:17:29AM -0500, Alex Elder wrote:
> >>>> There are blocks of IPA code that sanity-check various values, at
> >>>> compile time where possible.  Most of these checks can be done once
> >>>> during development but skipped for normal operation.  These checks
> >>>> permit the driver to make certain assumptions, thereby avoiding the
> >>>> need for runtime error checking.
> >>>>
> >>>> The checks are defined conditionally, but not consistently.  In
> >>>> some cases IPA_VALIDATION enables the optional checks, while in
> >>>> others IPA_VALIDATE is used.
> >>>>
> >>>> Fix this by using IPA_VALIDATION consistently.
> >>>>
> >>>> Signed-off-by: Alex Elder <elder@linaro.org>
> >>>> ---
> >>>>   drivers/net/ipa/Makefile       | 2 +-
> >>>>   drivers/net/ipa/gsi_trans.c    | 8 ++++----
> >>>>   drivers/net/ipa/ipa_cmd.c      | 4 ++--
> >>>>   drivers/net/ipa/ipa_cmd.h      | 6 +++---
> >>>>   drivers/net/ipa/ipa_endpoint.c | 6 +++---
> >>>>   drivers/net/ipa/ipa_main.c     | 6 +++---
> >>>>   drivers/net/ipa/ipa_mem.c      | 6 +++---
> >>>>   drivers/net/ipa/ipa_table.c    | 6 +++---
> >>>>   drivers/net/ipa/ipa_table.h    | 6 +++---
> >>>>   9 files changed, 25 insertions(+), 25 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> >>>> index afe5df1e6eeee..014ae36ac6004 100644
> >>>> --- a/drivers/net/ipa/Makefile
> >>>> +++ b/drivers/net/ipa/Makefile
> >>>> @@ -1,5 +1,5 @@
> >>>>   # Un-comment the next line if you want to validate configuration data
> >>>> -#ccflags-y		+=	-DIPA_VALIDATE
> >>>> +# ccflags-y		+=	-DIPA_VALIDATION
> >>>
> >>> Maybe netdev folks think differently here, but general rule that dead
> >>> code and closed code is such, is not acceptable to in Linux kernel.
> >>>
> >>> <...>
> >>
> >> What is the purpose of CONFIG_KGDB?  Or CONFIG_DEBUG_KERNEL?
> >> Would you prefer I expose this through a kconfig option?  I
> >> intentionally did not do that, because I really intended it
> >> to be only for development, so defined it in the Makefile.
> >> But I have no objection to making it configurable that way.
> > 
> > I prefer you to follow netdev/linux kernel rules of development.
> > The upstream repository and drivers/net/* folder especially are not
> > the place to put code used for the development.
> 
> How do I add support for new versions of the hardware as
> it evolves?

Exactly like all other driver developers do. You are not different here.

1. Clean your driver to have stable base without dead/debug code.
2. Send patch series per-feature/hardware enablement on top of this base.

> 
> What I started supporting (v3.5.1) was in some respects
> relatively old.  Version 4.2 is newer, and the v4.5 and
> beyond are for products that are relatively new on the
> market.

I see that it was submitted in 2018, we have many large drivers
that by far older than IPA. For example, mlx5 supports more than 5
generations of hardware and was added in 2013.

> 
> Some updates to IPA (like 4.0+ after 3.5.1, or 4.5+
> after 4.2) include substantial updates to the way the
> hardware works.  The code can't support the new hardware
> without being adapted and generalized to support both
> old and new.

It is ok.

> 
> My goal is to get upstream support for IPA for all
> Qualcomm SoCs that have it.  But the hardware design
> is evolving; Qualcomm is actively developing their
> architecture so they can support new technologies
> (e.g. cellular 5G).  Development of the driver is
> simply *necessary*.

No argue here.

> 
> The assertions I proposed and checks like this are
> intended as an *aid* to the active development I
> have been doing.

They need to be local to your development environment.
It is perfectly fine if you keep extra debug patch internally.

> 
> They may look like hacky debugging--checking errors
> that can't happen.  They aren't that at all--they're
> intended to the compiler help me develop correct code,
> given I *know* it will be evolving.

It is wrong assumption that you are alone who are reading this code.
I presented my view as a casual developer who sometimes need to change
code that is not my expertise.

The extra checks, unreachable and/or for non-existing code are very similar
to the bad comments - they make simple tasks too complex, it causes to us
wonder why they exist, maybe I broke something, e.t.c.

Unreachable code and checks sometimes serve as a hint for code deletion
and this is exactly how I spotted your driver.

> 
> But the assertions are gone, and I accept/agree that
> these specific checks "look funny."  More below.
> 
> >>>> -#ifdef IPA_VALIDATE
> >>>> +#ifdef IPA_VALIDATION
> >>>>   	if (!size || size % 8)
> >>>>   		return -EINVAL;
> >>>>   	if (count < max_alloc)
> >>>>   		return -EINVAL;
> >>>>   	if (!max_alloc)
> >>>>   		return -EINVAL;
> >>>> -#endif /* IPA_VALIDATE */
> >>>> +#endif /* IPA_VALIDATION */
> >>>
> >>> If it is possible to supply those values, the check should be always and
> >>> not only under some closed config option.
> >>
> >> These are assertions.
> >>
> >> There is no need to test them for working code.  If
> >> I run the code successfully with these tests enabled
> >> exactly once, and they are satisfied, then every time
> >> the code is run thereafter they will pass.  So I want
> >> to check them when debugging/developing only.  That
> >> way there is a mistake, it gets caught, but otherwise
> >> there's no pointless argument checking done.

Like I said below, you are not alone who are reading this code.
The kernel has three ways to handle wrong flow:
1. if ... return; -- used for runtime checks of possible but wrong input, or userspace input
2. BUILD_BUG_ON() -- used for compilation checks
3. WARN_ON*()     -- used for runtime checks of not-possible kernel flows

You are trying to use something different which is not needed.

> >>
> >> I'll explain the first check; the others have similar
> >> explanation.
> >>
> >> In the current code, the passed size is sizeof(struct)
> >> for three separate structures.
> >>   - If the structure size changes, I want to be
> >>     sure the constraint is still honored
> >>   - The code will break of someone happens
> >>     to pass a size of 0.  I don't expect that to
> >>     ever happen, but this states that requirement.
> >>
> >> This is an optimization, basically, but one that
> >> allows the assumed conditions to be optionally
> >> verified.
> > 
> > Everything above as an outcome of attempting to mix constant vs. run-time
> > checks. If "size" is constant, the use of BUILD_BIG_ON() will help not only
> > you but other developers to catch the errors too. The assumption that you alone
> > are working on this code, can or can't be correct.
> 
> Right now I am the only one doing substantive development.
> I am listed as the maintainer, and I trust anything more
> than simple fixes will await my review before being
> merged.

It is wrong assumption too. Major changes are performed all the time and
not always maintainers have say, sometimes it is because of timing, sometimes
it is because right thing to do.

> 
> > If "size" is not constant, you should check it always.
> 
> To do that I might need to make this function (and others
> like it) inline, or maybe __always_inline.  Regardless,
> I generally agree with your suggestion of defensively
> testing the argument value.  But this is an *internal
> interface*.  The only callers are inside the driver.

This is checked with WARN_ON*().

> 
> It's basically putting the burden on the caller to verify
> parameters, because often the caller already knows.
> 
> I think this is more of a philosophical argument than
> a technical one.  The check isn't *that* expensive.

My complain is lack of readability and maintainability for random kernel
developers and not performance concerns. 

> 
> >>>>   	/* By allocating a few extra entries in our pool (one less
> >>>>   	 * than the maximum number that will be requested in a
> >>>> @@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
> >>>>   	dma_addr_t addr;
> >>>>   	void *virt;
> >>>> -#ifdef IPA_VALIDATE
> >>>> +#ifdef IPA_VALIDATION
> >>>>   	if (!size || size % 8)
> >>>>   		return -EINVAL;
> >>>>   	if (count < max_alloc)
> >>>>   		return -EINVAL;
> >>>>   	if (!max_alloc)
> >>>>   		return -EINVAL;
> >>>> -#endif /* IPA_VALIDATE */
> >>>> +#endif /* IPA_VALIDATION */
> >>>
> >>> Same
> >>>
> >>> <...>
> >>>
> >>>>   {
> >>>> -#ifdef IPA_VALIDATE
> >>>> +#ifdef IPA_VALIDATION
> >>>>   	/* At one time we assumed a 64-bit build, allowing some do_div()
> >>>>   	 * calls to be replaced by simple division or modulo operations.
> >>>>   	 * We currently only perform divide and modulo operations on u32,
> >>>> @@ -768,7 +768,7 @@ static void ipa_validate_build(void)
> >>>>   	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
> >>>>   	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
> >>>>   			field_max(AGGR_GRANULARITY_FMASK));
> >>>> -#endif /* IPA_VALIDATE */
> >>>> +#endif /* IPA_VALIDATION */
> >>>
> >>> BUILD_BUG_ON()s are checked during compilation and not during runtime
> >>> like IPA_VALIDATION promised.
> >>
> >> So I should update the description.  But I'm not sure where
> >> you are referring to.  Here is the first line of the patch
> >> description:
> >>   There are blocks of IPA code that sanity-check various
> >>   values, at compile time where possible.
> > 
> > I'm suggesting to review if IPA_VALIDATION is truly needed.
> 
> *That* is a suggestion I can act on...
> 
> Right now, it's *there*.  These few patches were the beginning
> of a side task to simplify and/or get rid of it.  The first
> step is to get it so it's not fundamentally broken.  Then I
> can work on getting rid of (or at least refactor) pieces.
> 
> The code I started with did lots of checks of these things
> (including build-time checkable ones).  Many, many functions
> needlessly returned values, just so these checks could be made.
> The possibility of returning an error meant all callers had
> to check for it, and that complicated things all the way up.
> 
> So I tried to gather such things into foo_validate() functions,
> which just grouped these checks without having to clutter the
> normal code path with them.  That way called functions could
> have void return type, and calling functions would be simpler,
> and so on.
> 
> So I guess to respond again to your comment, I really would
> like to get rid of IPA_VALIDATION, or most of it.  As it is,
> many things are checked with BUILD_BUG_ON(), but they need
> not really be conditionally built.  That is a fix I intend
> to make, but haven't yet.
> 
> But the code is there, and if I am going to fix it, I need
> to do it with patches.  And I try to make my patches small
> enough to be easily reviewable.
> 
> >>> IMHO, the issue here is that this IPA code isn't release quality but
> >>> some debug drop variant and it is far from expected from submitted code.
> >>
> >> Doesn't sound very humble, IMHO.
> > 
> > Sorry about that.
> 
> I'd like to suggest a plan so I can begin to make progress,
> but do so in a way you/others think is satisfactory.
> - I would first like to fix the existing bugs, namely that
>   if IPA_VALIDATION is defined there are build errors, and
>   that IPA_VALIDATION is not consistently used.  That is
>   this 2-patch series.

The thing is that IPA_VALIDATION is not defined in the upstream kernel.
There is nothing to be fixed in netdev repository

> - I assure you that my goal is to simplify the code that
>   does this sort of checking.  So here are some specific
>   things I can implement in the coming weeks toward that:
>     - Anything that can be checked at build time, will
>       be checked with BUILD_BUG_ON().

+1

>     - Anything checked with BUILD_BUG_ON() will *not*
>       be conditional.  I.e. it won't be inside an
>       #ifdef IPA_VALIDATION block.
>     - I will review all remaining VALIDATION code (which
>       can't--or can't always--be checked at build time),
>       If it looks prudent to make it *always* be checked,
>       I will make it always be checked (not conditional
>       on IPA_VALIDATION).

+1

> The result should clearly separate checks that can be done
> at build time from those that can't.
> 
> And with what's left (especially on that third sub-bullet)
> I might have some better examples with which to argue
> for something different.  Or I might just concede that
> you were right all along.

I hope so.

Thanks
