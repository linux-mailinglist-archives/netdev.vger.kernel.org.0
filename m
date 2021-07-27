Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6FB3D81A2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhG0VUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234113AbhG0VT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 17:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5BA60FA0;
        Tue, 27 Jul 2021 21:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627420740;
        bh=WmBPx1Yv944WSgHzak0rUdbiFwHmXA9AEErppz095mw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Yhxrd8TFAkXrlR9r4ZRtp1p0sOIsB3ZuHtZ7oYU4pXZvEaqyymH79DJSjO7iRK0si
         GSkXTTyUofgJqP034jp+1ZTvpxMOzmU1ZGhjE0qTg4I6idDUP9ThURBnvBclsuNBhC
         u1tZ6C5YrfZBbxqk5ahpRO+VLSzVj3IEDOAgpOob/SggphKjlTaaTST/9JYGw9qJid
         8957SpfZCeNiETD/zLB4cNWxzBDrGN9HQH+PNdMkwgJzIdpYFU/NFrV7mI6t8oFQsi
         iwRWwF/foCBjtefKMixR8I7lM2u4IUX+zsUkg8iCrC0hdyyEJdWn/XDDKg0i/Pt6xD
         FkiBVpBB37WQw==
Subject: Re: [PATCH 31/64] fortify: Explicitly disable Clang support
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-32-keescook@chromium.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <da989ffc-da64-33a2-581e-6920eb7ebd2d@kernel.org>
Date:   Tue, 27 Jul 2021 14:18:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727205855.411487-32-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/2021 1:58 PM, Kees Cook wrote:
> Clang has never correctly compiled the FORTIFY_SOURCE defenses due to
> a couple bugs:
> 
> 	Eliding inlines with matching __builtin_* names
> 	https://bugs.llvm.org/show_bug.cgi?id=50322
> 
> 	Incorrect __builtin_constant_p() of some globals
> 	https://bugs.llvm.org/show_bug.cgi?id=41459
> 
> In the process of making improvements to the FORTIFY_SOURCE defenses, the
> first (silent) bug (coincidentally) becomes worked around, but exposes
> the latter which breaks the build. As such, Clang must not be used with
> CONFIG_FORTIFY_SOURCE until at least latter bug is fixed (in Clang 13),
> and the fortify routines have been rearranged.
> 
> Update the Kconfig to reflect the reality of the current situation.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   security/Kconfig | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 0ced7fd33e4d..8f0e675e70a4 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -191,6 +191,9 @@ config HARDENED_USERCOPY_PAGESPAN
>   config FORTIFY_SOURCE
>   	bool "Harden common str/mem functions against buffer overflows"
>   	depends on ARCH_HAS_FORTIFY_SOURCE
> +	# https://bugs.llvm.org/show_bug.cgi?id=50322
> +	# https://bugs.llvm.org/show_bug.cgi?id=41459
> +	depends on !CONFIG_CC_IS_CLANG

Should be !CC_IS_CLANG, Kconfig is hard :)

>   	help
>   	  Detect overflows of buffers in common string and memory functions
>   	  where the compiler can determine and validate the buffer sizes.
> 

Cheers,
Nathan
