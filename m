Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247953420FC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhCSPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhCSPcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 11:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1613A61937;
        Fri, 19 Mar 2021 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616167937;
        bh=Bjqasofa2YhV0Yx6/30uM0KbT7hlCu9DzBODXj+rzj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbIGUlK5jH663nkarqCmAI/l9izm//4/ZMn/hxMsAKjIMyJMWwGESCMjWmtuxMfDw
         MKuAlYPr48w4WQJX7Vmzv+77QyI67MCtFUcMeAVdfvhPT8h2eDaU+B49vMb4xcLZuJ
         Vzx4vK6Rb63GYpIwJ0R2dttyCSrNkQsgknzub73MP+y/KJpbc/JB7E1eLePWg5Ngqh
         lSZ8SToNbAdeuet/Vjj1nWgWLWpYwctDGJam25+REqT5DuDcCbRye1pNi+zl66GboF
         63QMTGAxhyVcxkOZnBAG7Jc3Hx1H/I1ze9YjSMTL6yqfTPaGY4Eboj9jMEF0iPfzyl
         nYOoPbynrfZ+g==
Date:   Fri, 19 Mar 2021 17:32:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: ipa: introduce ipa_assert()
Message-ID: <YFTD/TZ2tFX/X3dD@unreal>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-4-elder@linaro.org>
 <YFQurZjWYaolHGvR@unreal>
 <edb7ab60-f0e2-8fc4-ca73-9614bb547ab5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edb7ab60-f0e2-8fc4-ca73-9614bb547ab5@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 07:38:26AM -0500, Alex Elder wrote:
> On 3/18/21 11:55 PM, Leon Romanovsky wrote:
> > On Thu, Mar 18, 2021 at 11:29:22PM -0500, Alex Elder wrote:
> > > Create a new macro ipa_assert() to verify that a condition is true.
> > > This produces a build-time error if the condition can be evaluated
> > > at build time; otherwise __ipa_assert_runtime() is called (described
> > > below).
> > > 
> > > Another macro, ipa_assert_always() verifies that an expression
> > > yields true at runtime, and if it does not, reports an error
> > > message.
> > > 
> > > When IPA validation is enabled, __ipa_assert_runtime() becomes a
> > > call to ipa_assert_always(), resulting in runtime verification of
> > > the asserted condition.  Otherwise __ipa_assert_runtime() has no
> > > effect, so such ipa_assert() calls are effectively ignored.
> > > 
> > > IPA assertion errors will be reported using the IPA device if
> > > possible.
> > > 
> > > Signed-off-by: Alex Elder <elder@linaro.org>
> > > ---
> > >   drivers/net/ipa/ipa_assert.h | 50 ++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 50 insertions(+)
> > >   create mode 100644 drivers/net/ipa/ipa_assert.h
> > > 
> > > diff --git a/drivers/net/ipa/ipa_assert.h b/drivers/net/ipa/ipa_assert.h
> > > new file mode 100644
> > > index 0000000000000..7e5b9d487f69d
> > > --- /dev/null
> > > +++ b/drivers/net/ipa/ipa_assert.h
> > > @@ -0,0 +1,50 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Copyright (C) 2021 Linaro Ltd.
> > > + */
> > > +#ifndef _IPA_ASSERT_H_
> > > +#define _IPA_ASSERT_H_
> > > +
> > > +#include <linux/compiler.h>
> > > +#include <linux/printk.h>
> > > +#include <linux/device.h>
> > > +
> > > +/* Verify the expression yields true, and fail at build time if possible */
> > > +#define ipa_assert(dev, expr) \
> > > +	do { \
> > > +		if (__builtin_constant_p(expr)) \
> > > +			compiletime_assert(expr, __ipa_failure_msg(expr)); \
> > > +		else \
> > > +			__ipa_assert_runtime(dev, expr); \
> > > +	} while (0)
> > > +
> > > +/* Report an error if the given expression evaluates to false at runtime */
> > > +#define ipa_assert_always(dev, expr) \
> > > +	do { \
> > > +		if (unlikely(!(expr))) { \
> > > +			struct device *__dev = (dev); \
> > > +			\
> > > +			if (__dev) \
> > > +				dev_err(__dev, __ipa_failure_msg(expr)); \
> > > +			else  \
> > > +				pr_err(__ipa_failure_msg(expr)); \
> > > +		} \
> > > +	} while (0)
> > 
> > It will be much better for everyone if you don't obfuscate existing
> > kernel primitives and don't hide constant vs. dynamic expressions.
> 
> I don't agree with this characterization.
> 
> Yes, there is some complexity in this one source file, where
> ipa_assert() is defined.  But as a result, callers are simple
> one-line statements (similar to WARN_ON()).

It is not complexity but being explicit vs. implicit. The coding
style that has explicit flows will be always better than implicit
one. By adding your custom assert, you are hiding the flows and
makes unclear what can be evaluated at compilation and what can't.

> 
> Existing kernel primitives don't achieve these objectives:
> - Don't check things at run time under normal conditions
> - Do check things when validation is enabled
> - If you can check it at compile time, check it regardless
> If there is something that helps me do that, suggest it because
> I will be glad to use it.

Separate checks to two flows and it will be natural to achieve what you
want.

> 
> > So any random kernel developer will be able to change the code without
> > investing too much time to understand this custom logic.
> 
> There should be almost no need to change the definition of
> ipa_assert().  Even so, this custom logic is not all that
> complicated in my view; it's broken into a few macros that
> are each pretty simple.  It was actuallyl a little simpler
> before I added some things to satisfy checkpatch.pl.

Every obfuscation is simple, but together it is nightmare for the person
who does some random kernel job and needs to change such obfuscated code.

> 
> > And constant expressions are checked with BUILD_BUG_ON().
> 
> BUILD_BUG_ON() is great.  But it doesn't work for
> non-constant expressions.

Of course, be explicit and use BUILD_BUG_ON() for constants and write
the code that don't need such constructions.

Thanks
