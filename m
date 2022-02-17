Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB74BA524
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiBQPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:52:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiBQPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:52:37 -0500
X-Greylist: delayed 613 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 07:52:22 PST
Received: from relay4.hostedemail.com (relay4.hostedemail.com [64.99.140.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13E5F43
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:52:20 -0800 (PST)
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AFCB2042F;
        Thu, 17 Feb 2022 15:42:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id AF56320032;
        Thu, 17 Feb 2022 15:42:05 +0000 (UTC)
Message-ID: <1f6cabc8b183056546571b391770e1eea8524fd3.camel@perches.com>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
From:   Joe Perches <joe@perches.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 17 Feb 2022 07:42:04 -0800
In-Reply-To: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF56320032
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Stat-Signature: nz9e5z1u3yz1f5rpbt3m7jkkokhucyw8
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19KaPmP/R/KoYWstS8VZiTyOYA8oslrR+Y=
X-HE-Tag: 1645112525-592173
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-17 at 13:19 +0100, Christophe Leroy wrote:
> All functions defined as static inline in net/checksum.h are
> meant to be inlined for performance reason.
> 
> But since commit ac7c3e4ff401 ("compiler: enable
> CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
> uninline functions when it wants.
> 
> Fair enough in the general case, but for tiny performance critical
> checksum helpers that's counter-productive.

Thanks.  Trivial style notes:

> diff --git a/include/net/checksum.h b/include/net/checksum.h
[]
> @@ -22,7 +22,7 @@
>  #include <asm/checksum.h>
>  
>  #ifndef _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
> -static inline
> +static __always_inline
>  __wsum csum_and_copy_from_user (const void __user *src, void *dst,
>  				      int len)
>  {

__wsum might be better placed on the previous line.

[]

> @@ -45,7 +45,7 @@ static __inline__ __wsum csum_and_copy_to_user
>  #endif
>  
>  #ifndef _HAVE_ARCH_CSUM_AND_COPY
> -static inline __wsum
> +static __always_inline __wsum
>  csum_partial_copy_nocheck(const void *src, void *dst, int len)

To be consistent with the location of the __wsum return value
when splitting the function definitions across multiple lines.

(like the below)

> @@ -88,42 +88,43 @@ static inline __wsum csum_shift(__wsum sum, int offset)
>  	return sum;
>  }
>  
> -static inline __wsum
> +static __always_inline __wsum
>  csum_block_add(__wsum csum, __wsum csum2, int offset)
>  {
>  	return csum_add(csum, csum_shift(csum2, offset));
>  }
>  
> -static inline __wsum
> +static __always_inline __wsum
>  csum_block_add_ext(__wsum csum, __wsum csum2, int offset, int len)
>  {
>  	return csum_block_add(csum, csum2, offset);
>  }
>  
> -static inline __wsum
> +static __always_inline __wsum
>  csum_block_sub(__wsum csum, __wsum csum2, int offset)
>  {
>  	return csum_block_add(csum, ~csum2, offset);
>  }
>  
> -static inline __wsum csum_unfold(__sum16 n)
> +static __always_inline __wsum csum_unfold(__sum16 n)
>  {
>  	return (__force __wsum)n;
>  }
>  

[]

> -static inline __wsum csum_partial_ext(const void *buff, int len, __wsum sum)
> +static __always_inline
> +__wsum csum_partial_ext(const void *buff, int len, __wsum sum)
>  {
>  	return csum_partial(buff, len, sum);
>  }

And this __wsum could be moved too.

> @@ -150,15 +151,15 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
[]
> -static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
> +static __always_inline __wsum remcsum_adjust(void *ptr, __wsum csum,
>  				    int start, int offset)
>  {
>  	__sum16 *psum = (__sum16 *)(ptr + offset);

And this one could be split like the above

static __always_inline __wsum
remcsum_adjust(void *ptr, __wsum csum, int start, int offset)


