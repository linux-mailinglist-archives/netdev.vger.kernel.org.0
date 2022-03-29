Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9213F4EB670
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiC2XDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240323AbiC2XDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:03:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31422765BE;
        Tue, 29 Mar 2022 16:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B795360B15;
        Tue, 29 Mar 2022 23:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AABC340ED;
        Tue, 29 Mar 2022 23:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648594899;
        bh=M4ahqdUbNWZpu1zTE+ecLAol/Y3a7KqezwczG/uULOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+mm77ouLiZBy2ItFKplfL6uqyJ3Xq6THOxS2sIVYbuj9wVH8YyV67MSW35GGgL+n
         DjwxNulZuP4nFyW7LcdSmmMeFHzN/TqK6pCvutyV2M4EIE8MzNcX3eaGT2qglgZXHy
         oEhLaFt1PeKJYmrncUzypm0/i+ue7r8DVdbHz2wMszBxDKhBKyrg1p2VBhlKUvgmZZ
         n4rSV/F5K7P71TZ7j2kglQ+l+teFX3zbYwTqZaqKVdkAE8PJJfUjRcc68QaCn4Xc/I
         kUw7reKurJkdW37dBs+0TEC3be5tWZUrKCVpY0tr1AL3hgyt4xcJoM7GkWqNQFxDpQ
         JaUkejUExDjmw==
Date:   Tue, 29 Mar 2022 16:01:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2] net, uapi: remove inclusion of arpa/inet.h
Message-ID: <20220329160137.0708b1ef@kernel.org>
In-Reply-To: <20220329223956.486608-1-ndesaulniers@google.com>
References: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
        <20220329223956.486608-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 15:39:56 -0700 Nick Desaulniers wrote:
> Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
> from Android's SDK, I encountered an error:
> 
>   HDRTEST usr/include/linux/fsi.h
> In file included from <built-in>:1:
> In file included from ./usr/include/linux/tipc_config.h:46:
> prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
> error: unknown type name 'in_addr_t'
> in_addr_t inet_addr(const char* __s);
> ^
> 
> This is because Bionic has a bug in its inclusion chain. I sent a patch
> to fix that, but looking closer at include/uapi/linux/tipc_config.h,
> there's a comment that it includes arpa/inet.h for ntohs;
> but ntohs is not defined in any UAPI header. For now, reuse the
> definitions from include/linux/byteorder/generic.h, since the various
> conversion functions do exist in UAPI headers:
> include/uapi/linux/byteorder/big_endian.h
> include/uapi/linux/byteorder/little_endian.h
> 
> Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/uapi/linux/tipc_config.h | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> index 4dfc05651c98..2c494b7ae008 100644
> --- a/include/uapi/linux/tipc_config.h
> +++ b/include/uapi/linux/tipc_config.h
> @@ -43,10 +43,6 @@
>  #include <linux/tipc.h>
>  #include <asm/byteorder.h>
>  
> -#ifndef __KERNEL__
> -#include <arpa/inet.h> /* for ntohs etc. */
> -#endif

Hm, how do we know no user space depends on this include?

If nobody screams at us we can try, but then it needs to go into -next,
and net-next is closed ATM, you'll need to repost once the merge window
is over.

>  /*
>   * Configuration
>   *
> @@ -257,6 +253,10 @@ struct tlv_desc {
>  #define TLV_SPACE(datalen) (TLV_ALIGN(TLV_LENGTH(datalen)))
>  #define TLV_DATA(tlv) ((void *)((char *)(tlv) + TLV_LENGTH(0)))
>  
> +#define __htonl(x) __cpu_to_be32(x)
> +#define __htons(x) __cpu_to_be16(x)
> +#define __ntohs(x) __be16_to_cpu(x)
> +
>  static inline int TLV_OK(const void *tlv, __u16 space)
>  {
>  	/*
> @@ -269,33 +269,33 @@ static inline int TLV_OK(const void *tlv, __u16 space)
>  	 */
>  
>  	return (space >= TLV_SPACE(0)) &&
> -		(ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
> +		(__ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);

Also why add the defines / macros? 
We could switch to __cpu_to_be16() etc. directly, it seems.
