Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23B0476F69
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhLPLEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:04:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhLPLEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:04:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA2261D49;
        Thu, 16 Dec 2021 11:04:22 +0000 (UTC)
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.kernel.org (Postfix) with ESMTPSA id BCE44C36AE4;
        Thu, 16 Dec 2021 11:04:17 +0000 (UTC)
Date:   Thu, 16 Dec 2021 11:09:36 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, list@opendingux.net,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/5] PM: core: Add new *_PM_OPS macros, deprecate old
 ones
Message-ID: <20211216110936.6ccd07d3@jic23-huawei>
In-Reply-To: <20211207002102.26414-4-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
        <20211207002102.26414-4-paul@crapouillou.net>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 00:21:00 +0000
Paul Cercueil <paul@crapouillou.net> wrote:

> This commit introduces the following macros:
> SYSTEM_SLEEP_PM_OPS()
> LATE_SYSTEM_SLEEP_PM_OPS()
> NOIRQ_SYSTEM_SLEEP_PM_OPS()
> RUNTIME_PM_OPS()
> 
> These new macros are very similar to their SET_*_PM_OPS() equivalent.
> They however differ in the fact that the callbacks they set will always
> be seen as referenced by the compiler. This means that the callback
> functions don't need to be wrapped with a #ifdef CONFIG_PM guard, or
> tagged with __maybe_unused, to prevent the compiler from complaining
> about unused static symbols. The compiler will then simply evaluate at
> compile time whether or not these symbols are dead code.
> 
> The callbacks that are only useful with CONFIG_PM_SLEEP is enabled, are
> now also wrapped with a new pm_sleep_ptr() macro, which is inspired from
> pm_ptr(). This is needed for drivers that use different callbacks for
> sleep and runtime PM, to handle the case where CONFIG_PM is set and
> CONFIG_PM_SLEEP is not.
> 
> This commit also deprecates the following macros:
> SIMPLE_DEV_PM_OPS()
> UNIVERSAL_DEV_PM_OPS()
> 
> And introduces the following macros:
> DEFINE_SIMPLE_DEV_PM_OPS()
> DEFINE_UNIVERSAL_DEV_PM_OPS()
> 
> These macros are similar to the functions they were created to replace,
> with the following differences:
> - They use the new macros introduced above, and as such always reference
>   the provided callback functions;
> - They are not tagged with __maybe_unused. They are meant to be used
>   with pm_ptr() or pm_sleep_ptr() for DEFINE_UNIVERSAL_DEV_PM_OPS() and
>   DEFINE_SIMPLE_DEV_PM_OPS() respectively.
> - They declare the symbol static, since every driver seems to do that
>   anyway; and if a non-static use-case is needed an indirection pointer
>   could be used.

There are non static usecases e.g. drivers/iio/ad7606.c
where they are shared across a couple of different modules (typically when
we have a core / i2c / spi module split for a driver or similar).
As you say, there are ways of working around that.

So I guess it's a question of what feels more natural + common kernel
way of doing things.

I'll defer to your (+ anyone else who wishes to comment) judgement.

> 
> The point of this change, is to progressively switch from a code model
> where PM callbacks are all protected behind CONFIG_PM guards, to a code
> model where the PM callbacks are always seen by the compiler, but
> discarded if not used.
> 
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Great work btw. When the holiday season gets boring I'll redo my IIO
set to use this + maybe the rest of IIO...

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  include/linux/pm.h | 74 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 50 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index b88ac7dcf2a2..fc9691cb01b4 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -300,47 +300,59 @@ struct dev_pm_ops {
>  	int (*runtime_idle)(struct device *dev);
>  };
>  
> +#define SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +	.suspend = pm_sleep_ptr(suspend_fn), \
> +	.resume = pm_sleep_ptr(resume_fn), \
> +	.freeze = pm_sleep_ptr(suspend_fn), \
> +	.thaw = pm_sleep_ptr(resume_fn), \
> +	.poweroff = pm_sleep_ptr(suspend_fn), \
> +	.restore = pm_sleep_ptr(resume_fn),
> +
> +#define LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +	.suspend_late = pm_sleep_ptr(suspend_fn), \
> +	.resume_early = pm_sleep_ptr(resume_fn), \
> +	.freeze_late = pm_sleep_ptr(suspend_fn), \
> +	.thaw_early = pm_sleep_ptr(resume_fn), \
> +	.poweroff_late = pm_sleep_ptr(suspend_fn), \
> +	.restore_early = pm_sleep_ptr(resume_fn),
> +
> +#define NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +	.suspend_noirq = pm_sleep_ptr(suspend_fn), \
> +	.resume_noirq = pm_sleep_ptr(resume_fn), \
> +	.freeze_noirq = pm_sleep_ptr(suspend_fn), \
> +	.thaw_noirq = pm_sleep_ptr(resume_fn), \
> +	.poweroff_noirq = pm_sleep_ptr(suspend_fn), \
> +	.restore_noirq = pm_sleep_ptr(resume_fn),
> +
> +#define RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
> +	.runtime_suspend = suspend_fn, \
> +	.runtime_resume = resume_fn, \
> +	.runtime_idle = idle_fn,
> +
>  #ifdef CONFIG_PM_SLEEP
>  #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> -	.suspend = suspend_fn, \
> -	.resume = resume_fn, \
> -	.freeze = suspend_fn, \
> -	.thaw = resume_fn, \
> -	.poweroff = suspend_fn, \
> -	.restore = resume_fn,
> +	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #else
>  #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #endif
>  
>  #ifdef CONFIG_PM_SLEEP
>  #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> -	.suspend_late = suspend_fn, \
> -	.resume_early = resume_fn, \
> -	.freeze_late = suspend_fn, \
> -	.thaw_early = resume_fn, \
> -	.poweroff_late = suspend_fn, \
> -	.restore_early = resume_fn,
> +	LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #else
>  #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #endif
>  
>  #ifdef CONFIG_PM_SLEEP
>  #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> -	.suspend_noirq = suspend_fn, \
> -	.resume_noirq = resume_fn, \
> -	.freeze_noirq = suspend_fn, \
> -	.thaw_noirq = resume_fn, \
> -	.poweroff_noirq = suspend_fn, \
> -	.restore_noirq = resume_fn,
> +	NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #else
>  #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #endif
>  
>  #ifdef CONFIG_PM
>  #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
> -	.runtime_suspend = suspend_fn, \
> -	.runtime_resume = resume_fn, \
> -	.runtime_idle = idle_fn,
> +	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
>  #else
>  #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
>  #endif
> @@ -349,9 +361,9 @@ struct dev_pm_ops {
>   * Use this if you want to use the same suspend and resume callbacks for suspend
>   * to RAM and hibernation.
>   */
> -#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> -const struct dev_pm_ops __maybe_unused name = { \
> -	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +#define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> +static const struct dev_pm_ops name = { \
> +	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
>  }
>  
>  /*
> @@ -367,6 +379,19 @@ const struct dev_pm_ops __maybe_unused name = { \
>   * .resume_early(), to the same routines as .runtime_suspend() and
>   * .runtime_resume(), respectively (and analogously for hibernation).
>   */
> +#define DEFINE_UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
> +static const struct dev_pm_ops name = { \
> +	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
> +}
> +
> +/* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
> +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> +const struct dev_pm_ops __maybe_unused name = { \
> +	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> +}
> +
> +/* Deprecated. Use DEFINE_UNIVERSAL_DEV_PM_OPS() instead. */
>  #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
>  const struct dev_pm_ops __maybe_unused name = { \
>  	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> @@ -374,6 +399,7 @@ const struct dev_pm_ops __maybe_unused name = { \
>  }
>  
>  #define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
> +#define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
>  
>  /*
>   * PM_EVENT_ messages

