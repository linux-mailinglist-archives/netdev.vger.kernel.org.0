Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B9610468F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKTW2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:28:35 -0500
Received: from imap1.codethink.co.uk ([176.9.8.82]:37075 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTW2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 17:28:35 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iXYSW-0005ym-Qa; Wed, 20 Nov 2019 22:28:24 +0000
Message-ID: <638f6bcc2f7ecf96eda85973457a8d69b0a7640e.camel@codethink.co.uk>
Subject: Re: [Y2038] [PATCH 01/23] y2038: remove CONFIG_64BIT_TIME
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc:     linux-aio@kvack.org, Stephen Boyd <sboyd@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>
Date:   Wed, 20 Nov 2019 22:28:23 +0000
In-Reply-To: <20191108210824.1534248-1-arnd@arndb.de>
References: <20191108210236.1296047-1-arnd@arndb.de>
         <20191108210824.1534248-1-arnd@arndb.de>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-11-08 at 22:07 +0100, Arnd Bergmann wrote:
[...]
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -267,7 +267,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
>  }
>  #endif
>  
> -#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
> +#ifdef CONFIG_64BIT
>  SYSCALL_DEFINE1(adjtimex, struct __kernel_timex __user *, txc_p)
>  {
>  	struct __kernel_timex txc;		/* Local copy of parameter */
> @@ -884,7 +884,7 @@ int get_timespec64(struct timespec64 *ts,
>  	ts->tv_sec = kts.tv_sec;
>  
>  	/* Zero out the padding for 32 bit systems or in compat mode */
> -	if (IS_ENABLED(CONFIG_64BIT_TIME) && in_compat_syscall())
> +	if (in_compat_syscall())
>  		kts.tv_nsec &= 0xFFFFFFFFUL;
>  
>  	ts->tv_nsec = kts.tv_nsec;
[...]

It's not a problem with this patch, but I noticed that this condition
doesn't match what the comment says.  It looks like it was broken by:

commit 98f76206b33504b934209d16196477dfa519a807
Author: Dmitry Safonov <dima@arista.com>
Date:   Fri Oct 12 14:42:53 2018 +0100

    compat: Cleanup in_compat_syscall() callers

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

