Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A87476F6F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhLPLFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:05:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55160 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhLPLFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:05:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41B2EB82322;
        Thu, 16 Dec 2021 11:05:01 +0000 (UTC)
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.kernel.org (Postfix) with ESMTPSA id A79D3C36AE6;
        Thu, 16 Dec 2021 11:04:56 +0000 (UTC)
Date:   Thu, 16 Dec 2021 11:10:21 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, list@opendingux.net,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/5] PM: core: Redefine pm_ptr() macro
Message-ID: <20211216111021.7b3eaada@jic23-huawei>
In-Reply-To: <20211207002102.26414-3-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
        <20211207002102.26414-3-paul@crapouillou.net>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 00:20:59 +0000
Paul Cercueil <paul@crapouillou.net> wrote:

> The pm_ptr() macro was previously conditionally defined, according to
> the value of the CONFIG_PM option. This meant that the pointed structure
> was either referenced (if CONFIG_PM was set), or never referenced (if
> CONFIG_PM was not set), causing it to be detected as unused by the
> compiler.
> 
> This worked fine, but required the __maybe_unused compiler attribute to
> be used to every symbol pointed to by a pointer wrapped with pm_ptr().
> 
> We can do better. With this change, the pm_ptr() is now defined the
> same, independently of the value of CONFIG_PM. It now uses the (?:)
> ternary operator to conditionally resolve to its argument. Since the
> condition is known at compile time, the compiler will then choose to
> discard the unused symbols, which won't need to be tagged with
> __maybe_unused anymore.
> 
> This pm_ptr() macro is usually used with pointers to dev_pm_ops
> structures created with SIMPLE_DEV_PM_OPS() or similar macros. These do
> use a __maybe_unused flag, which is now useless with this change, so it
> later can be removed. However in the meantime it causes no harm, and all
> the drivers still compile fine with the new pm_ptr() macro.
> 
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  include/linux/pm.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 1d8209c09686..b88ac7dcf2a2 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -373,11 +373,7 @@ const struct dev_pm_ops __maybe_unused name = { \
>  	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
>  }
>  
> -#ifdef CONFIG_PM
> -#define pm_ptr(_ptr) (_ptr)
> -#else
> -#define pm_ptr(_ptr) NULL
> -#endif
> +#define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
>  
>  /*
>   * PM_EVENT_ messages

