Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1051E3432D2
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCUNtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhCUNtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 09:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4DFC61944;
        Sun, 21 Mar 2021 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616334573;
        bh=2ijNdN4jnyh3jsm31okqSgYnMjGQk2B8uPqN6+qMIfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l48qSuS2Sihop17+HDbCco+NOxhgqvruJGyl+yFtaNh0OdII9VzpS6cVJpU2qBqdC
         IR9EWqdoQBP5maMXN6PmRDE2OCdgEimcJfNOajlLx58kGTPeMT46AnuEp4Ln45LA0Z
         DxuKTcZdb9BQEHc5S0NDtmaWOlR0KCRZrPbhCIlrq+qbAvi8bAGwdgPjLC4WTrHWtD
         B5Xxm4cB7HqrAhWoxIggl9sunSrl8rPW9USZvj+C9/1FydCWn7DhTNNpd8MlHGP4Ua
         QxkBUgtkM951lEnMRYPg+QLencN63RyVYnIPiNA/EKCZ98RxNcIz9iG3t1XnOg/t0/
         s4YKEB6u3uBBw==
Date:   Sun, 21 Mar 2021 15:49:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Message-ID: <YFdO6UnWsm4DAkwc@unreal>
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org>
 <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 08:21:24AM -0500, Alex Elder wrote:
> On 3/21/21 3:21 AM, Leon Romanovsky wrote:
> > On Sat, Mar 20, 2021 at 09:17:29AM -0500, Alex Elder wrote:
> > > There are blocks of IPA code that sanity-check various values, at
> > > compile time where possible.  Most of these checks can be done once
> > > during development but skipped for normal operation.  These checks
> > > permit the driver to make certain assumptions, thereby avoiding the
> > > need for runtime error checking.
> > > 
> > > The checks are defined conditionally, but not consistently.  In
> > > some cases IPA_VALIDATION enables the optional checks, while in
> > > others IPA_VALIDATE is used.
> > > 
> > > Fix this by using IPA_VALIDATION consistently.
> > > 
> > > Signed-off-by: Alex Elder <elder@linaro.org>
> > > ---
> > >   drivers/net/ipa/Makefile       | 2 +-
> > >   drivers/net/ipa/gsi_trans.c    | 8 ++++----
> > >   drivers/net/ipa/ipa_cmd.c      | 4 ++--
> > >   drivers/net/ipa/ipa_cmd.h      | 6 +++---
> > >   drivers/net/ipa/ipa_endpoint.c | 6 +++---
> > >   drivers/net/ipa/ipa_main.c     | 6 +++---
> > >   drivers/net/ipa/ipa_mem.c      | 6 +++---
> > >   drivers/net/ipa/ipa_table.c    | 6 +++---
> > >   drivers/net/ipa/ipa_table.h    | 6 +++---
> > >   9 files changed, 25 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> > > index afe5df1e6eeee..014ae36ac6004 100644
> > > --- a/drivers/net/ipa/Makefile
> > > +++ b/drivers/net/ipa/Makefile
> > > @@ -1,5 +1,5 @@
> > >   # Un-comment the next line if you want to validate configuration data
> > > -#ccflags-y		+=	-DIPA_VALIDATE
> > > +# ccflags-y		+=	-DIPA_VALIDATION
> > 
> > Maybe netdev folks think differently here, but general rule that dead
> > code and closed code is such, is not acceptable to in Linux kernel.
> > 
> > <...>
> 
> What is the purpose of CONFIG_KGDB?  Or CONFIG_DEBUG_KERNEL?
> Would you prefer I expose this through a kconfig option?  I
> intentionally did not do that, because I really intended it
> to be only for development, so defined it in the Makefile.
> But I have no objection to making it configurable that way.

I prefer you to follow netdev/linux kernel rules of development.
The upstream repository and drivers/net/* folder especially are not
the place to put code used for the development.

> 
> > > -#ifdef IPA_VALIDATE
> > > +#ifdef IPA_VALIDATION
> > >   	if (!size || size % 8)
> > >   		return -EINVAL;
> > >   	if (count < max_alloc)
> > >   		return -EINVAL;
> > >   	if (!max_alloc)
> > >   		return -EINVAL;
> > > -#endif /* IPA_VALIDATE */
> > > +#endif /* IPA_VALIDATION */
> > 
> > If it is possible to supply those values, the check should be always and
> > not only under some closed config option.
> 
> These are assertions.
> 
> There is no need to test them for working code.  If
> I run the code successfully with these tests enabled
> exactly once, and they are satisfied, then every time
> the code is run thereafter they will pass.  So I want
> to check them when debugging/developing only.  That
> way there is a mistake, it gets caught, but otherwise
> there's no pointless argument checking done.
> 
> I'll explain the first check; the others have similar
> explanation.
> 
> In the current code, the passed size is sizeof(struct)
> for three separate structures.
>   - If the structure size changes, I want to be
>     sure the constraint is still honored
>   - The code will break of someone happens
>     to pass a size of 0.  I don't expect that to
>     ever happen, but this states that requirement.
> 
> This is an optimization, basically, but one that
> allows the assumed conditions to be optionally
> verified.

Everything above as an outcome of attempting to mix constant vs. run-time
checks. If "size" is constant, the use of BUILD_BIG_ON() will help not only
you but other developers to catch the errors too. The assumption that you alone
are working on this code, can or can't be correct.

If "size" is not constant, you should check it always.

> 
> > >   	/* By allocating a few extra entries in our pool (one less
> > >   	 * than the maximum number that will be requested in a
> > > @@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
> > >   	dma_addr_t addr;
> > >   	void *virt;
> > > -#ifdef IPA_VALIDATE
> > > +#ifdef IPA_VALIDATION
> > >   	if (!size || size % 8)
> > >   		return -EINVAL;
> > >   	if (count < max_alloc)
> > >   		return -EINVAL;
> > >   	if (!max_alloc)
> > >   		return -EINVAL;
> > > -#endif /* IPA_VALIDATE */
> > > +#endif /* IPA_VALIDATION */
> > 
> > Same
> > 
> > <...>
> > 
> > >   {
> > > -#ifdef IPA_VALIDATE
> > > +#ifdef IPA_VALIDATION
> > >   	/* At one time we assumed a 64-bit build, allowing some do_div()
> > >   	 * calls to be replaced by simple division or modulo operations.
> > >   	 * We currently only perform divide and modulo operations on u32,
> > > @@ -768,7 +768,7 @@ static void ipa_validate_build(void)
> > >   	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
> > >   	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
> > >   			field_max(AGGR_GRANULARITY_FMASK));
> > > -#endif /* IPA_VALIDATE */
> > > +#endif /* IPA_VALIDATION */
> > 
> > BUILD_BUG_ON()s are checked during compilation and not during runtime
> > like IPA_VALIDATION promised.
> 
> So I should update the description.  But I'm not sure where
> you are referring to.  Here is the first line of the patch
> description:
>   There are blocks of IPA code that sanity-check various
>   values, at compile time where possible.

I'm suggesting to review if IPA_VALIDATION is truly needed.

> 
> > IMHO, the issue here is that this IPA code isn't release quality but
> > some debug drop variant and it is far from expected from submitted code.
> 
> Doesn't sound very humble, IMHO.

Sorry about that.

> 
> This code was found acceptable and merged for mainline a
> year ago.  At that time it supported IPA on the SDM845 SoC
> (IPA v3.5.1).  Had it not been merged, I would have continued
> refining the code out-of-tree until it could be merged.  But
> now, it's upstream, so anything I want to do to make it better
> must be done upstream.

The upstream just doesn't need to be your testing ground.

> 
> Since last year it has undergone considerable development,
> including adding support for the SC7180 SoC (IPA v4.2).  I
> am now in the process of getting things posted for review
> so IPA versions 4.5, 4.9, and 4.11 are supported.  With any
> luck all that will be done in this merge cycle; we'll see.
> 
> Most of what I've been doing is gradually transforming
> things to support the new hardware.  But in the process
> I'm also improving what's there so that it is better
> organized, more consistent, more understandable, and
> maintainable.
> 
> I have explained this previously, but this code was derived
> from Qualcomm "downstream" code.  Much was done toward
> getting it into the upstream kernel, including carving out
> great deal of code, and removing functionality to focus on
> just *one* target platform.
> 
> Now that it's upstream, the aim is to add back functionality,
> ideally to support all current and future Qualcomm IPA hardware,
> and eventually (this year) to support some of the features
> (hardware filtering/routing/NAT) that were removed to make
> the code simpler.
> 
> I'm doing a lot of development on this driver, yes.  But
> it doesn't mean it's broken, it means it's improving.

It is not what I said.

I said "some debug drop variant" and all those validation and custom
asserts for impossible flows are supporting my claim.

Thanks

> 
> 					-Alex
> 
> > Thanks
> > 
> 
