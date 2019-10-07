Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA3CEDCE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbfJGUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:42:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40989 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbfJGUmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:42:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so3084872pga.8;
        Mon, 07 Oct 2019 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IERIuhXLgndId6gV/E/baoUdLC+H/aoGlssXaZgnKos=;
        b=iTAH3XL2C2aj+fFlEBXvAzP5lAAlLrIKdYLCTSFNYmQ1NAvjDRORgFaita4BgfJMf/
         E7MBAjDrRzJ3iqSGuNr1hLuKrJk825fuT3pYZFrSOxJlm8Ygw+sQTRigktt5ULK8qVp6
         cZGeDMFKcbl9smyLogG7ygAiYSmsloOvNdwxjphz6bQ3WJGC1WFvk8UFNERBUD09BMlN
         5d6rgETiHcnIDMC0nAfBXyIl2aeHi7xLoa6aKxC8s21BGoB8dAfP84QDHc6FpdLh/qYj
         eWa5Glijqdi12MxSYsfkNEUc51Zr8uXPbAmwH4ue1UEmfviGlvBfS1FEOmM7Shc+7qwd
         yu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IERIuhXLgndId6gV/E/baoUdLC+H/aoGlssXaZgnKos=;
        b=YF9DDEg2fFtZDPbiohZ+yue+Y5+xf0g4PXvi35UV0/SLMKgl+hbmRM23/DFoYJWysF
         U2CRdRpICIip+MgUJjwS39I0F2zovRwr9a5I1aaLu2XRebF/hQYNwyUZkYm6GmCRBRLI
         qwhoZggnko1yIx8Xe06G6bG4kRSfWOiy0vBbR8GdzaTotrTvMWgMZ9yTyb86hMnb+8uM
         4/VEKzVPcwGfYdLI7A2ZL6yi4iJkSUX9z/NZPaLXPPGGdhJ4Subo/SdnNbD7JPpDbK9j
         9zDRoabu3oTgHFoDVGSWWMgU95dQ0n53+bfO9PBPM6pCBqf4KeRIo8suxepHztn4SGxX
         2fCg==
X-Gm-Message-State: APjAAAUehS2jVR5OWNTtmKDk8fHEhaywsIhpxgjYd9JCQcgAN4eq7bxo
        kUnLAS69tieIX7PfPYlb67Q=
X-Google-Smtp-Source: APXvYqw90Zo15hw6cBzhBe4clBtJLhcwh+y23PKXoTmLPkzrRUgr30w4kJAwb5gJChAoW7oZwyK+mQ==
X-Received: by 2002:a65:6095:: with SMTP id t21mr23280569pgu.197.1570480958529;
        Mon, 07 Oct 2019 13:42:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2257])
        by smtp.gmail.com with ESMTPSA id b14sm16478578pfi.95.2019.10.07.13.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 13:42:37 -0700 (PDT)
Date:   Mon, 7 Oct 2019 13:42:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 07:20:36PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This adds support for wrapping eBPF program dispatch in chain calling
> logic. The code injection is controlled by a flag at program load time; if
> the flag is set, the BPF program will carry a flag bit that changes the
> program dispatch logic to wrap it in a chain call loop.
> 
> Ideally, it shouldn't be necessary to set the flag on program load time,
> but rather inject the calls when a chain call program is first loaded. The
> allocation logic sets the whole of struct bpf_prog to be read-only memory,
> so it can't immediately be modified, but conceivably we could just unlock
> the first page of the struct and flip the bit when a chain call program is
> first attached.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h      |    3 +++
>  include/linux/filter.h   |   34 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/bpf.h |    6 ++++++
>  kernel/bpf/core.c        |    6 ++++++
>  kernel/bpf/syscall.c     |    4 +++-
>  5 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..13e5f38cf5c6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -365,6 +365,8 @@ struct bpf_prog_stats {
>  	struct u64_stats_sync syncp;
>  };
>  
> +#define BPF_NUM_CHAIN_SLOTS 8
> +
>  struct bpf_prog_aux {
>  	atomic_t refcnt;
>  	u32 used_map_cnt;
> @@ -383,6 +385,7 @@ struct bpf_prog_aux {
>  	struct list_head ksym_lnode;
>  	const struct bpf_prog_ops *ops;
>  	struct bpf_map **used_maps;
> +	struct bpf_prog *chain_progs[BPF_NUM_CHAIN_SLOTS];
>  	struct bpf_prog *prog;
>  	struct user_struct *user;
>  	u64 load_time; /* ns since boottime */
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 2ce57645f3cd..3d1e4991e61d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -21,6 +21,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/if_vlan.h>
>  #include <linux/vmalloc.h>
> +#include <linux/nospec.h>
>  
>  #include <net/sch_generic.h>
>  
> @@ -528,6 +529,7 @@ struct bpf_prog {
>  				is_func:1,	/* program is a bpf function */
>  				kprobe_override:1, /* Do we override a kprobe? */
>  				has_callchain_buf:1, /* callchain buffer allocated? */
> +				chain_calls:1, /* should this use the chain_call wrapper */
>  				enforce_expected_attach_type:1; /* Enforce expected_attach_type checking at attach time */
>  	enum bpf_prog_type	type;		/* Type of BPF program */
>  	enum bpf_attach_type	expected_attach_type; /* For some prog types */
> @@ -551,6 +553,30 @@ struct sk_filter {
>  	struct bpf_prog	*prog;
>  };
>  
> +#define BPF_MAX_CHAIN_CALLS 32
> +static __always_inline unsigned int do_chain_calls(const struct bpf_prog *prog,
> +						   const void *ctx)
> +{
> +	int i = BPF_MAX_CHAIN_CALLS;
> +	int idx;
> +	u32 ret;
> +
> +	do {
> +		ret = (*(prog)->bpf_func)(ctx, prog->insnsi);

This breaks program stats.

> +
> +		if (ret + 1 >= BPF_NUM_CHAIN_SLOTS) {
> +			prog = prog->aux->chain_progs[0];
> +			continue;
> +		}
> +		idx = ret + 1;
> +		idx = array_index_nospec(idx, BPF_NUM_CHAIN_SLOTS);
> +
> +		prog = prog->aux->chain_progs[idx] ?: prog->aux->chain_progs[0];
> +	} while (prog && --i);
> +
> +	return ret;
> +}
> +
>  DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>  
>  #define BPF_PROG_RUN(prog, ctx)	({				\
> @@ -559,14 +585,18 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>  	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
>  		struct bpf_prog_stats *stats;			\
>  		u64 start = sched_clock();			\
> -		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
> +		ret = prog->chain_calls ?			\
> +			do_chain_calls(prog, ctx) :			\
> +			 (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\

I thought you agreed on 'no performance regressions' rule?

>  		stats = this_cpu_ptr(prog->aux->stats);		\
>  		u64_stats_update_begin(&stats->syncp);		\
>  		stats->cnt++;					\
>  		stats->nsecs += sched_clock() - start;		\
>  		u64_stats_update_end(&stats->syncp);		\
>  	} else {						\
> -		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
> +		ret = prog->chain_calls ?				\
> +			do_chain_calls(prog, ctx) :			\
> +			 (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
>  	}							\
>  	ret; })
>  
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77c6be96d676..1ce80a227be3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -288,6 +288,12 @@ enum bpf_attach_type {
>  /* The verifier internal test flag. Behavior is undefined */
>  #define BPF_F_TEST_STATE_FREQ	(1U << 3)
>  
> +/* Whether to enable chain call logic at program execution. If set, the program
> + * execution logic will check for and jump to chain call programs configured
> + * with the BPF_PROG_CHAIN_* commands to the bpf syscall.
> + */
> +#define BPF_F_CHAIN_CALLS	(1U << 4)
> +
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * two extensions:
>   *
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 66088a9e9b9e..5dfe3585bc5d 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -254,6 +254,12 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>  void __bpf_prog_free(struct bpf_prog *fp)
>  {
>  	if (fp->aux) {
> +		int i;
> +
> +		for (i = 0; i < BPF_NUM_CHAIN_SLOTS; i++)
> +			if (fp->aux->chain_progs[i])
> +				bpf_prog_put(fp->aux->chain_progs[i]);
> +
>  		free_percpu(fp->aux->stats);
>  		kfree(fp->aux);
>  	}
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 82eabd4e38ad..b8a203a05881 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1630,7 +1630,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>  	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
>  				 BPF_F_ANY_ALIGNMENT |
>  				 BPF_F_TEST_STATE_FREQ |
> -				 BPF_F_TEST_RND_HI32))
> +				 BPF_F_TEST_RND_HI32 |
> +				 BPF_F_CHAIN_CALLS))
>  		return -EINVAL;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> @@ -1665,6 +1666,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>  		return -ENOMEM;
>  
>  	prog->expected_attach_type = attr->expected_attach_type;
> +	prog->chain_calls = !!(attr->prog_flags & BPF_F_CHAIN_CALLS);
>  
>  	prog->aux->offload_requested = !!attr->prog_ifindex;
>  
> 
