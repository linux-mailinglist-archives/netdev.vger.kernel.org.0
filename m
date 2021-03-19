Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FB341468
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhCSEzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233680AbhCSEzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 00:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 621BD64F53;
        Fri, 19 Mar 2021 04:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616129713;
        bh=3KJhudPkw2fjFs3MGsB08Y0IMXhu7LIKfsovqH3NJoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jN1LtZ3rGSdpUlrwhppvQ9n/HVsLWGiyOYSSqNiq6N0rbCdqXc3Qo/Nx9nC9foox0
         uur6fhd5j5uMm/muICxjbD28CqnD1BqRms2lP/l/6FyVI5pidVkBRhHGrJfp0/unLJ
         ydwTPCmUyF1W8K1jjByY8dV8+on5csiolTujAsKeoRL+j5KPIenqqJ8rISGSIZGTaz
         x7IWlGGgR1WL2d0L8iuKYMZxCfm/rpzpOy/c7rdqXA72+jOakcaLxtCs0UwTsoi3Q/
         6soqsAfcxGLZK0YRnMlL/p5g8QdeFhcQ/t6HxTaX/4/rSq+ZdBvopWyn2XHez5je7Q
         in+ipbJqz/C3A==
Date:   Fri, 19 Mar 2021 06:55:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: ipa: introduce ipa_assert()
Message-ID: <YFQurZjWYaolHGvR@unreal>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319042923.1584593-4-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 11:29:22PM -0500, Alex Elder wrote:
> Create a new macro ipa_assert() to verify that a condition is true.
> This produces a build-time error if the condition can be evaluated
> at build time; otherwise __ipa_assert_runtime() is called (described
> below).
> 
> Another macro, ipa_assert_always() verifies that an expression
> yields true at runtime, and if it does not, reports an error
> message.
> 
> When IPA validation is enabled, __ipa_assert_runtime() becomes a
> call to ipa_assert_always(), resulting in runtime verification of
> the asserted condition.  Otherwise __ipa_assert_runtime() has no
> effect, so such ipa_assert() calls are effectively ignored.
> 
> IPA assertion errors will be reported using the IPA device if
> possible.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_assert.h | 50 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 drivers/net/ipa/ipa_assert.h
> 
> diff --git a/drivers/net/ipa/ipa_assert.h b/drivers/net/ipa/ipa_assert.h
> new file mode 100644
> index 0000000000000..7e5b9d487f69d
> --- /dev/null
> +++ b/drivers/net/ipa/ipa_assert.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2021 Linaro Ltd.
> + */
> +#ifndef _IPA_ASSERT_H_
> +#define _IPA_ASSERT_H_
> +
> +#include <linux/compiler.h>
> +#include <linux/printk.h>
> +#include <linux/device.h>
> +
> +/* Verify the expression yields true, and fail at build time if possible */
> +#define ipa_assert(dev, expr) \
> +	do { \
> +		if (__builtin_constant_p(expr)) \
> +			compiletime_assert(expr, __ipa_failure_msg(expr)); \
> +		else \
> +			__ipa_assert_runtime(dev, expr); \
> +	} while (0)
> +
> +/* Report an error if the given expression evaluates to false at runtime */
> +#define ipa_assert_always(dev, expr) \
> +	do { \
> +		if (unlikely(!(expr))) { \
> +			struct device *__dev = (dev); \
> +			\
> +			if (__dev) \
> +				dev_err(__dev, __ipa_failure_msg(expr)); \
> +			else  \
> +				pr_err(__ipa_failure_msg(expr)); \
> +		} \
> +	} while (0)

It will be much better for everyone if you don't obfuscate existing
kernel primitives and don't hide constant vs. dynamic expressions.

So any random kernel developer will be able to change the code without
investing too much time to understand this custom logic.

And constant expressions are checked with BUILD_BUG_ON().

If you still feel need to provide assertion like this, it should be done
in general code.

Thanks

> +
> +/* Constant message used when an assertion fails */
> +#define __ipa_failure_msg(expr)	"IPA assertion failed: " #expr "\n"
> +
> +#ifdef IPA_VALIDATION
> +
> +/* Only do runtime checks for "normal" assertions if validating the code */
> +#define __ipa_assert_runtime(dev, expr)	ipa_assert_always(dev, expr)
> +
> +#else /* !IPA_VALIDATION */
> +
> +/* "Normal" assertions aren't checked when validation is disabled */
> +#define __ipa_assert_runtime(dev, expr)	\
> +	do { (void)(dev); (void)(expr); } while (0)
> +
> +#endif /* !IPA_VALIDATION */
> +
> +#endif /* _IPA_ASSERT_H_ */
> -- 
> 2.27.0
> 
