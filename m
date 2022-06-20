Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B265551919
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbiFTMjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242407AbiFTMjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:39:43 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524ACA1A6;
        Mon, 20 Jun 2022 05:39:42 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3Ggo-0003VL-Sd; Mon, 20 Jun 2022 14:39:34 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3Ggo-000V6U-Lu; Mon, 20 Jun 2022 14:39:34 +0200
Subject: Re: [PATCH bpf-next v2] libbpf: Include linux/log2.h to use
 is_power_of_2()
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <1655713404-7133-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8e5291b7-bd89-6fea-bfb7-954cacdb8523@iogearbox.net>
Date:   Mon, 20 Jun 2022 14:39:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1655713404-7133-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26578/Mon Jun 20 10:06:11 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/22 10:23 AM, Tiezhu Yang wrote:
> is_power_of_2() is already defined in tools/include/linux/log2.h [1],
> so no need to define it again in tools/lib/bpf/libbpf_internal.h, so
> just include linux/log2.h directly.
> 
> [1] https://lore.kernel.org/bpf/20220619171248.GC3362@bug/
> 
> Suggested-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   tools/lib/bpf/libbpf.c          | 2 +-
>   tools/lib/bpf/libbpf_internal.h | 6 +-----
>   tools/lib/bpf/linker.c          | 2 +-
>   3 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 49e359c..5252e51 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5131,7 +5131,7 @@ static size_t adjust_ringbuf_sz(size_t sz)
>   	 * a power-of-2 multiple of kernel's page size. If user diligently
>   	 * satisified these conditions, pass the size through.
>   	 */
> -	if ((sz % page_sz) == 0 && is_pow_of_2(sz / page_sz))
> +	if ((sz % page_sz) == 0 && is_power_of_2(sz / page_sz))
>   		return sz;
>   
>   	/* Otherwise find closest (page_sz * power_of_2) product bigger than
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index a1ad145..021946a 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -13,6 +13,7 @@
>   #include <limits.h>
>   #include <errno.h>
>   #include <linux/err.h>
> +#include <linux/log2.h>
>   #include <fcntl.h>
>   #include <unistd.h>
>   #include "libbpf_legacy.h"
> @@ -582,9 +583,4 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
>   					   const char *usdt_provider, const char *usdt_name,
>   					   __u64 usdt_cookie);
>   
> -static inline bool is_pow_of_2(size_t x)
> -{
> -	return x && (x & (x - 1)) == 0;
> -}

I don't think this is worth the extra pain and I would just leave above as-is, because then
we would also need a `LGPL-2.1 OR BSD-2-Clause` compatible reimplementation of linux/log2.h
header inside the standalone repo https://github.com/libbpf/libbpf/tree/master/include/linux
in order to build libbpf there once this get imported to it.

>   #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 4ac02c2..b2edb5f 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -719,7 +719,7 @@ static int linker_sanity_check_elf(struct src_obj *obj)
>   			return -EINVAL;
>   		}
>   
> -		if (sec->shdr->sh_addralign && !is_pow_of_2(sec->shdr->sh_addralign))
> +		if (sec->shdr->sh_addralign && !is_power_of_2(sec->shdr->sh_addralign))
>   			return -EINVAL;
>   		if (sec->shdr->sh_addralign != sec->data->d_align)
>   			return -EINVAL;
> 

