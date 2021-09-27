Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7199641952A
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhI0NgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:36:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:47212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbhI0NgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 09:36:24 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mUqmH-0004tz-Hv; Mon, 27 Sep 2021 15:34:41 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mUqmH-0001qc-9p; Mon, 27 Sep 2021 15:34:41 +0200
Subject: Re: [PATCH bpf-next 4/4] bpf: export bpf_jit_current
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210924095542.33697-1-lmb@cloudflare.com>
 <20210924095542.33697-5-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a076398b-f1da-c939-3c71-ac157ad96939@iogearbox.net>
Date:   Mon, 27 Sep 2021 15:34:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210924095542.33697-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26305/Mon Sep 27 11:04:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/21 11:55 AM, Lorenz Bauer wrote:
> Expose bpf_jit_current as a read only value via sysctl.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>   include/linux/filter.h     | 1 +
>   kernel/bpf/core.c          | 3 +--
>   net/core/sysctl_net_core.c | 7 +++++++
>   3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index ef03ff34234d..b2143ad5ce00 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1052,6 +1052,7 @@ extern int bpf_jit_harden;
>   extern int bpf_jit_kallsyms;
>   extern long bpf_jit_limit;
>   extern long bpf_jit_limit_max;
> +extern atomic_long_t bpf_jit_current;
>   
>   typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
>   
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index e844a2a4c99a..93f95e9ee8be 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -525,6 +525,7 @@ int bpf_jit_kallsyms __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_DEFAULT_ON);
>   int bpf_jit_harden   __read_mostly;
>   long bpf_jit_limit   __read_mostly;
>   long bpf_jit_limit_max __read_mostly;
> +atomic_long_t bpf_jit_current __read_mostly;
>   
>   static void
>   bpf_prog_ksym_set_addr(struct bpf_prog *prog)
> @@ -800,8 +801,6 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>   	return slot;
>   }
>   
> -static atomic_long_t bpf_jit_current;
> -
>   /* Can be overridden by an arch's JIT compiler if it has a custom,
>    * dedicated BPF backend memory area, or if neither of the two
>    * below apply.
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 5f88526ad61c..674aac163b84 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -421,6 +421,13 @@ static struct ctl_table net_core_table[] = {
>   		.extra1		= &long_one,
>   		.extra2		= &bpf_jit_limit_max,
>   	},
> +	{
> +		.procname	= "bpf_jit_current",
> +		.data		= &bpf_jit_current,
> +		.maxlen		= sizeof(long),
> +		.mode		= 0400,
> +		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,

Overall series looks good to me. The only nit I would have is that the above could (in theory)
be subject to atomic_long_t vs long type confusion. I would rather prefer to have a small handler
which properly reads out the atomic_long_t and then passes it onwards as a temporary/plain long
to user space.

Thanks,
Daniel

> +	},
>   #endif
>   	{
>   		.procname	= "netdev_tstamp_prequeue",
> 

