Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160691636CE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBRXDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:03:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:56932 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBRXDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:03:53 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BuA-0008E5-MW; Wed, 19 Feb 2020 00:03:50 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BuA-00072U-7Q; Wed, 19 Feb 2020 00:03:50 +0100
Subject: Re: [PATCH 03/18] bpf: Add struct bpf_ksym
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-4-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d61ff7d5-f0a7-8828-cf94-54936670f244@iogearbox.net>
Date:   Wed, 19 Feb 2020 00:03:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200216193005.144157-4-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/20 8:29 PM, Jiri Olsa wrote:
> Adding 'struct bpf_ksym' object that will carry the
> kallsym information for bpf symbol. Adding the start
> and end address to begin with. It will be used by
> bpf_prog, bpf_trampoline, bpf_dispatcher.
> 
> Using the bpf_func for program symbol start instead
> of the image start, because it will be used later for
> kallsyms program value and it makes no difference
> (compared to the image start) for sorting bpf programs.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/linux/bpf.h |  6 ++++++
>   kernel/bpf/core.c   | 26 +++++++++++---------------
>   2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index be7afccc9459..5ad8eea1cd37 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -462,6 +462,11 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
>   u64 notrace __bpf_prog_enter(void);
>   void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
>   
> +struct bpf_ksym {
> +	unsigned long		 start;
> +	unsigned long		 end;
> +};
> +
>   enum bpf_tramp_prog_type {
>   	BPF_TRAMP_FENTRY,
>   	BPF_TRAMP_FEXIT,
> @@ -643,6 +648,7 @@ struct bpf_prog_aux {
>   	u32 size_poke_tab;
>   	struct latch_tree_node ksym_tnode;
>   	struct list_head ksym_lnode;
> +	struct bpf_ksym ksym;
>   	const struct bpf_prog_ops *ops;
>   	struct bpf_map **used_maps;
>   	struct bpf_prog *prog;
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 973a20d49749..39a9e4184900 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -524,17 +524,15 @@ int bpf_jit_harden   __read_mostly;
>   long bpf_jit_limit   __read_mostly;
>   
>   static __always_inline void
> -bpf_get_prog_addr_region(const struct bpf_prog *prog,
> -			 unsigned long *symbol_start,
> -			 unsigned long *symbol_end)
> +bpf_get_prog_addr_region(const struct bpf_prog *prog)
>   {
>   	const struct bpf_binary_header *hdr = bpf_jit_binary_hdr(prog);
>   	unsigned long addr = (unsigned long)hdr;
>   
>   	WARN_ON_ONCE(!bpf_prog_ebpf_jited(prog));
>   
> -	*symbol_start = addr;
> -	*symbol_end   = addr + hdr->pages * PAGE_SIZE;
> +	prog->aux->ksym.start = (unsigned long) prog->bpf_func;

Your commit descriptions are too terse. :/ What does "because it will be used
later for kallsyms program value" mean exactly compared to how it's used today
for programs?

Is this a requirement to have them point exactly to prog->bpf_func and if so
why? My concern is that bpf_func has a random offset from hdr, so even if the
/proc/kallsyms would be readable with concrete addresses for !cap_sys_admin
users, it's still not the concrete start address being exposed there, but the
allocated range instead.

> +	prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE;
>   }
>   
