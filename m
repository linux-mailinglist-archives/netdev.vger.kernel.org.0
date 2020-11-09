Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49202AC7FE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgKIWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:04:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:40262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgKIWEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:04:41 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcFH9-0005Zb-EN; Mon, 09 Nov 2020 23:04:35 +0100
Received: from [178.196.19.221] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcFH9-000QzE-61; Mon, 09 Nov 2020 23:04:35 +0100
Subject: Re: [PATCHv5 bpf] bpf: Move iterator functions into special init
 section
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20201109185754.377373-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9205a69f-95db-6bc3-51f8-8b6f79c5e8fd@iogearbox.net>
Date:   Mon, 9 Nov 2020 23:04:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201109185754.377373-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25983/Mon Nov  9 14:20:27 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 7:57 PM, Jiri Olsa wrote:
> With upcoming changes to pahole, that change the way how and
> which kernel functions are stored in BTF data, we need a way
> to recognize iterator functions.
> 
> Iterator functions need to be in BTF data, but have no real
> body and are currently placed in .init.text section, so they
> are freed after kernel init and are filtered out of BTF data
> because of that.
> 
> The solution is to place these functions under new section:
>    .init.bpf.preserve_type
> 
> And add 2 new symbols to mark that area:
>    __init_bpf_preserve_type_begin
>    __init_bpf_preserve_type_end
> 
> The code in pahole responsible for picking up the functions will
> be able to recognize functions from this section and add them to
> the BTF data and filter out all other .init.text functions.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Suggested-by: Yonghong Song <yhs@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
> v5 changes:
>    - use "" in __section macro due to:
>      33def8498fdde180 ("treewide: Convert macro and uses of __section(foo) to __section("foo")")
>      [Arnaldo]
> 
> v4: https://lore.kernel.org/bpf/20201106222512.52454-1-jolsa@kernel.org/
> 
>   include/asm-generic/vmlinux.lds.h | 16 +++++++++++++++-
>   include/linux/bpf.h               |  8 +++++++-
>   include/linux/init.h              |  1 +
>   3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2b3d81b1535..f91029b3443b 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -685,8 +685,21 @@
>   	.BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {			\
>   		*(.BTF_ids)						\
>   	}
> +
> +/*
> + * .init.bpf.preserve_type
> + *
> + * This section store special BPF function and marks them
> + * with begin/end symbols pair for the sake of pahole tool.
> + */
> +#define INIT_BPF_PRESERVE_TYPE						\
> +	__init_bpf_preserve_type_begin = .;                             \
> +	*(.init.bpf.preserve_type)                                      \
> +	__init_bpf_preserve_type_end = .;				\
> +	MEM_DISCARD(init.bpf.preserve_type)
>   #else
>   #define BTF
> +#define INIT_BPF_PRESERVE_TYPE
>   #endif
>   
>   /*
> @@ -741,7 +754,8 @@
>   #define INIT_TEXT							\
>   	*(.init.text .init.text.*)					\
>   	*(.text.startup)						\
> -	MEM_DISCARD(init.text*)
> +	MEM_DISCARD(init.text*)						\
> +	INIT_BPF_PRESERVE_TYPE
>   
>   #define EXIT_DATA							\
>   	*(.exit.data .exit.data.*)					\
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2b16bf48aab6..73e8ededde3e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1276,10 +1276,16 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>   int bpf_obj_get_user(const char __user *pathname, int flags);
>   
> +#ifdef CONFIG_DEBUG_INFO_BTF
> +#define BPF_INIT __init_bpf_preserve_type
> +#else
> +#define BPF_INIT __init
> +#endif
> +
>   #define BPF_ITER_FUNC_PREFIX "bpf_iter_"
>   #define DEFINE_BPF_ITER_FUNC(target, args...)			\
>   	extern int bpf_iter_ ## target(args);			\
> -	int __init bpf_iter_ ## target(args) { return 0; }
> +	int BPF_INIT bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
>   	struct bpf_map *map;
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 7b53cb3092ee..a7c71e3b5f9a 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -52,6 +52,7 @@
>   #define __initconst	__section(".init.rodata")
>   #define __exitdata	__section(".exit.data")
>   #define __exit_call	__used __section(".exitcall.exit")
> +#define __init_bpf_preserve_type __section(".init.bpf.preserve_type")

Small nit, why this detour via BPF_INIT define? Couldn't we just:

#ifdef CONFIG_DEBUG_INFO_BTF
#define __init_bpf_preserve_type   __section(".init.bpf.preserve_type")
#else
#define __init_bpf_preserve_type   __init
#endif

Also, the comment above the existing defines says '/* These are for everybody (although
not all archs will actually discard it in modules) */' ... We should probably not add
the __init_bpf_preserve_type right under this listing as-is in your patch, but instead
'separate' it by adding a small comment on top of its definition by explaining its
purpose more clearly for others.

>   /*
>    * modpost check for section mismatches during the kernel build.
> 

