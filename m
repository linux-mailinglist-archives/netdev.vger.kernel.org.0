Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7A393943
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhE0X26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235259AbhE0X2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:28:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A2F6113D;
        Thu, 27 May 2021 23:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622158041;
        bh=zcHsePC6AkgNxATGRTIJ99il9CzZuFG/Bfucquog96A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z5Tn/1a2O/eJMtpWLpZ1ZYn15MM8OM9whWG4qJquD82RqXGSBP4mibdBMRxTSnOCP
         QSVG/8xqOW/srsU1rNLGIORyQ2YFU7fcy0fBl9qPnKe1+tjgzsQKZF0xFTOqsJWxDn
         tO3PdP0XWsjb78C49AbybZ+dpREWNr90m6tDGdKmiWEyurs8XFYGoQojU8kYjIOSQ0
         PgSIgOm2ZnmmI+91R+kZLOC5Bm9DaCIKaDMh4d1FkDnvBPNOK8O725qBU4opoyd2u4
         rcKhHB5s1G7Sj0cUaDquPWVKfzef0X25bN3+1rTh8WZ82kLIzb2ZsRE3SD9nrLnh5A
         bo4WBsDxxdHGQ==
Date:   Thu, 27 May 2021 16:27:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH net-next,v2,1/2] once: implement DO_ONCE_LITE for
 non-fast-path "do once" functionality
Message-ID: <20210527162720.2dbeac6f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210526231336.2772011-2-tannerlove.kernel@gmail.com>
References: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
        <20210526231336.2772011-2-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 19:13:35 -0400 Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> Certain uses of "do once" functionality reside outside of fast path,
> and so do not require jump label patching via static keys, making
> existing DO_ONCE undesirable in such cases.
> 
> Replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?
> 
> [ i386 build warnings ]
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  fs/xfs/xfs_message.h      | 13 +++----------
>  include/asm-generic/bug.h | 37 +++++++------------------------------
>  include/linux/once_lite.h | 24 ++++++++++++++++++++++++
>  include/linux/printk.h    | 23 +++--------------------
>  kernel/trace/trace.h      | 13 +++----------

You need to cast a wider net for the CC list here. This is not all
networking code. You should also probably CC LKML on general changes
like this.

>  #define xfs_printk_once(func, dev, fmt, ...)			\
> -({								\
> -	static bool __section(".data.once") __print_once;	\
> -	bool __ret_print_once = !__print_once; 			\
> -								\
> -	if (!__print_once) {					\
> -		__print_once = true;				\
> -		func(dev, fmt, ##__VA_ARGS__);			\
> -	}							\
> -	unlikely(__ret_print_once);				\
> -})
> +	DO_ONCE_LITE(func, dev, fmt, ##__VA_ARGS__)

>  #ifdef CONFIG_PRINTK
>  #define printk_once(fmt, ...)					\
> -({								\
> -	static bool __section(".data.once") __print_once;	\
> -	bool __ret_print_once = !__print_once;			\
> -								\
> -	if (!__print_once) {					\
> -		__print_once = true;				\
> -		printk(fmt, ##__VA_ARGS__);			\
> -	}							\
> -	unlikely(__ret_print_once);				\
> -})
> +	DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
>  #define printk_deferred_once(fmt, ...)				\
> -({								\
> -	static bool __section(".data.once") __print_once;	\
> -	bool __ret_print_once = !__print_once;			\
> -								\
> -	if (!__print_once) {					\
> -		__print_once = true;				\
> -		printk_deferred(fmt, ##__VA_ARGS__);		\
> -	}							\
> -	unlikely(__ret_print_once);				\
> -})
> +	DO_ONCE_LITE(printk_deferred, fmt, ##__VA_ARGS__)

These are not equivalent to your new macro below. They used to return
if the print was done or not, now they'll always return true. You need
to double check this doesn't break anything and add a note about it in
the commit message.

> +#define DO_ONCE_LITE_IF(condition, func, ...)				\
> +	({								\
> +		static bool __section(".data.once") __already_done;	\
> +		bool __ret_do_once = !!(condition);			\
> +									\
> +		if (unlikely(__ret_do_once && !__already_done)) {	\
> +			__already_done = true;				\
> +			func(__VA_ARGS__);				\
> +		}							\
> +		unlikely(__ret_do_once);				\
> +	})
> +
