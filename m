Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2D6E7101
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjDSCL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 22:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDSCL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 22:11:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F6683C9;
        Tue, 18 Apr 2023 19:11:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24736790966so2262563a91.2;
        Tue, 18 Apr 2023 19:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681870316; x=1684462316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKzEYBMYX7WZqDuli+nPLqpoJWMnxCy7Q/NycVBMtMc=;
        b=XvLxPooCYkT+5oVTrf/6xIeEEoHWqqCs8UmA3KtUcmcevGM4OVFB+vKlxS7dZaMECc
         cXuh8a3M9U24T6D5J9jBqcyrvgHjioUQDZLaGv12VytzQIHKsuO4mfbCkJfNy8pxNX8s
         H+L0wugTAzVw0U6/NmTb8EMGfo0LMiaP3XRoQFbeL2GFqTgvYbnUOPEeJn66LrVaNG5J
         byzjFXEAOckKLIdzFytL8ifmuHa8TKTrFUUO/IjztVrIwwXQ5F55SwBHN2VNuBeZWWDP
         7B0DGAEHpd91BfjLWzmgQMx3wsVN8K0bNQ+N2cPVAVsAEmvqqihr2lVKhImxtWhTn+F5
         Jnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870316; x=1684462316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKzEYBMYX7WZqDuli+nPLqpoJWMnxCy7Q/NycVBMtMc=;
        b=PDnvufksKY54neX78DugRVk4tXhmFatQDKRj9npfKRCDRtNUiV8YfFw4lA3+tbLY1v
         nBBU/2t41hVPNJtxLTCoKXpx3jW7Cm7zwrXwmBcm5wtUlJrRPYCBzOeNT+wnc/92VKuU
         ycUR81nvg71k8KzGE416qhRdM3LkwXBcUbgVOo+we+oNBG4XdGcj6n5vp9os97taSMWb
         gfLdIEfWccLl7kiat5MnUjHair9LO3mOA/Y/2dkM8miK9kJNvBHf+oWhxcabeg2YSzLM
         JpEiVZ2gjwnP1VEboDQjHCuDXlkq9zBIC7fN1PIcobhtjIWOiZmA26d+kyovtcqCVKmv
         +AFw==
X-Gm-Message-State: AAQBX9cRcyN1B88gjvWoSOndngjJf31Uhqja2xdhSwp1jKn4wGUu7Izg
        ImqjwVmp2V7RtmuDtnC9nG4J1i7nN0Y=
X-Google-Smtp-Source: AKy350aRRthAZA0vGhv3/Cr2qQzcrqdY1wRe60w2AEtcUdMzrjaf3DvuxtNvC3ByoOGK8l/jdH7HAw==
X-Received: by 2002:a17:90a:d395:b0:247:53b4:ec52 with SMTP id q21-20020a17090ad39500b0024753b4ec52mr1294663pju.8.1681870315567;
        Tue, 18 Apr 2023 19:11:55 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:4d31])
        by smtp.gmail.com with ESMTPSA id nm20-20020a17090b19d400b00249604258b1sm236422pjb.38.2023.04.18.19.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 19:11:55 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:11:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 2/6] bpf: minimal support for programs hooked
 into netfilter framework
Message-ID: <20230419021152.sjq4gttphzzy6b5f@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418131038.18054-3-fw@strlen.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 03:10:34PM +0200, Florian Westphal wrote:
> This adds minimal support for BPF_PROG_TYPE_NETFILTER bpf programs
> that will be invoked via the NF_HOOK() points in the ip stack.
> 
> Invocation incurs an indirect call.  This is not a necessity: Its
> possible to add 'DEFINE_BPF_DISPATCHER(nf_progs)' and handle the
> program invocation with the same method already done for xdp progs.
> 
> This isn't done here to keep the size of this chunk down.
> 
> Verifier restricts verdicts to either DROP or ACCEPT.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/bpf_types.h           |  4 ++
>  include/net/netfilter/nf_bpf_link.h |  5 +++
>  kernel/bpf/btf.c                    |  6 +++
>  kernel/bpf/verifier.c               |  3 ++
>  net/core/filter.c                   |  1 +
>  net/netfilter/nf_bpf_link.c         | 70 ++++++++++++++++++++++++++++-
>  6 files changed, 88 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index d4ee3ccd3753..39a999abb0ce 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -79,6 +79,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
>  #endif
>  BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
>  	      void *, void *)
> +#ifdef CONFIG_NETFILTER
> +BPF_PROG_TYPE(BPF_PROG_TYPE_NETFILTER, netfilter,
> +	      struct bpf_nf_ctx, struct bpf_nf_ctx)
> +#endif
>  
>  BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> diff --git a/include/net/netfilter/nf_bpf_link.h b/include/net/netfilter/nf_bpf_link.h
> index eeaeaf3d15de..6c984b0ea838 100644
> --- a/include/net/netfilter/nf_bpf_link.h
> +++ b/include/net/netfilter/nf_bpf_link.h
> @@ -1,5 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  
> +struct bpf_nf_ctx {
> +	const struct nf_hook_state *state;
> +	struct sk_buff *skb;
> +};
> +
>  #if IS_ENABLED(CONFIG_NETFILTER_BPF_LINK)
>  int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  #else
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 027f9f8a3551..3556bb68e3ec 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -25,6 +25,9 @@
>  #include <linux/bsearch.h>
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
> +
> +#include <net/netfilter/nf_bpf_link.h>
> +
>  #include <net/sock.h>
>  #include "../tools/lib/bpf/relo_core.h"
>  
> @@ -212,6 +215,7 @@ enum btf_kfunc_hook {
>  	BTF_KFUNC_HOOK_SK_SKB,
>  	BTF_KFUNC_HOOK_SOCKET_FILTER,
>  	BTF_KFUNC_HOOK_LWT,
> +	BTF_KFUNC_HOOK_NETFILTER,
>  	BTF_KFUNC_HOOK_MAX,
>  };
>  
> @@ -7800,6 +7804,8 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
>  	case BPF_PROG_TYPE_LWT_XMIT:
>  	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
>  		return BTF_KFUNC_HOOK_LWT;
> +	case BPF_PROG_TYPE_NETFILTER:
> +		return BTF_KFUNC_HOOK_NETFILTER;
>  	default:
>  		return BTF_KFUNC_HOOK_MAX;
>  	}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1e05355facdc..fc7281d39e46 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13816,6 +13816,9 @@ static int check_return_code(struct bpf_verifier_env *env)
>  		}
>  		break;
>  
> +	case BPF_PROG_TYPE_NETFILTER:
> +		range = tnum_range(NF_DROP, NF_ACCEPT);
> +		break;
>  	case BPF_PROG_TYPE_EXT:
>  		/* freplace program can return anything as its return value
>  		 * depends on the to-be-replaced kernel func or bpf program.
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 44fb997434ad..d9ce04ca22ce 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -11717,6 +11717,7 @@ static int __init bpf_kfunc_init(void)
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_NETFILTER, &bpf_kfunc_set_skb);
>  	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &bpf_kfunc_set_xdp);
>  }
>  late_initcall(bpf_kfunc_init);
> diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
> index 0f937c6bee6d..2d12c978e4e7 100644
> --- a/net/netfilter/nf_bpf_link.c
> +++ b/net/netfilter/nf_bpf_link.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/bpf.h>
> +#include <linux/filter.h>
>  #include <linux/netfilter.h>
>  
>  #include <net/netfilter/nf_bpf_link.h>
> @@ -7,7 +8,13 @@
>  
>  static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb, const struct nf_hook_state *s)
>  {
> -	return NF_ACCEPT;
> +	const struct bpf_prog *prog = bpf_prog;
> +	struct bpf_nf_ctx ctx = {
> +		.state = s,
> +		.skb = skb,
> +	};
> +
> +	return bpf_prog_run(prog, &ctx);
>  }
>  
>  struct bpf_nf_link {
> @@ -158,3 +165,64 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  
>  	return bpf_link_settle(&link_primer);
>  }
> +
> +const struct bpf_prog_ops netfilter_prog_ops = {
> +};
> +
> +static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
> +{
> +	struct btf *btf;
> +	s32 type_id;
> +
> +	btf = bpf_get_btf_vmlinux();
> +	if (IS_ERR_OR_NULL(btf))
> +		return false;
> +
> +	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
> +	if (WARN_ON_ONCE(type_id < 0))
> +		return false;
> +
> +	info->btf = btf;
> +	info->btf_id = type_id;
> +	info->reg_type = PTR_TO_BTF_ID | PTR_TRUSTED;
> +	return true;

This can be improved. Instead of run-time search use pre-processed
btf_tracing_ids[] approach.
Add sk_buff and nf_hook_state to BTF_TRACING_TYPE_xxx
and take btf ids from array.

It can be a follow up,
but since you're respinning anyway please add a selftest for ctx->skb, ctx->state.
The patch 6 only validates the return codes.

> +}
> +
> +static bool nf_is_valid_access(int off, int size, enum bpf_access_type type,
> +			       const struct bpf_prog *prog,
> +			       struct bpf_insn_access_aux *info)
> +{
> +	if (off < 0 || off >= sizeof(struct bpf_nf_ctx))
> +		return false;
> +
> +	if (type == BPF_WRITE)
> +		return false;
> +
> +	switch (off) {
> +	case bpf_ctx_range(struct bpf_nf_ctx, skb):
> +		if (size != sizeof_field(struct bpf_nf_ctx, skb))
> +			return false;
> +
> +		return nf_ptr_to_btf_id(info, "sk_buff");
> +	case bpf_ctx_range(struct bpf_nf_ctx, state):
> +		if (size != sizeof_field(struct bpf_nf_ctx, state))
> +			return false;
> +
> +		return nf_ptr_to_btf_id(info, "nf_hook_state");
> +	default:
> +		return false;
> +	}
> +
> +	return false;
> +}
> +
> +static const struct bpf_func_proto *
> +bpf_nf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	return bpf_base_func_proto(func_id);

As a next step we probably need to generalize tc_cls_act_func_proto
to take trusted ptr_to_btf skb instead of ctx.
netfilter progs should be able to use bpf_skb_load_bytes and friends.
