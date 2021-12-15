Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CA475DDE
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245000AbhLOQvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244928AbhLOQvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:51:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B81C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 08:51:11 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a25ac05000000b005c55592df4dso44389388ybi.12
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 08:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tSLoCvV83uVNWzNSIKfpbb32NYaHee7L5yjLmgJjO04=;
        b=OF3LHg69rEr1/589FxdwoGn7zU+F41Hblpa7aO0QfKR5B2atC/HFFiC92HUtQ0jApv
         XzgBGCjjBaa8ctauGw4rICaURUg3IIcgu+H04B//s1+o/HIQMg7REEh3CdaJUvIra5oW
         oZwp23um+QuLz3OmeG1TmTf2EoP2dsqaaHaD9n3pjdlEP7r070ta2fDaXOZbUl4LsvWs
         Dc48nPWYnx4+QL/P50e7+527QyT3FREMENpb6keEaXUNYEsPWMpj1lvHlpu7dYahoWRG
         UUsCAB1LMkHGMhElsY1GrZxgji3gD720XBrmWei0nhPEDf8fP6k3pBfjxVtt7u7vEOB9
         ok4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tSLoCvV83uVNWzNSIKfpbb32NYaHee7L5yjLmgJjO04=;
        b=gjGtceZM1k7J1emAdjRsK6Y3tP0WGYAv/bLsuJwWuOF57fkz7tzSW4oT4R/UfeicDU
         fLW0LAlmGbWTKepTPQg2Jmr7x6hAYm4Pa8KV92/RQpiEGk958IVbYNIktJj4XT4K6ToO
         Ym1M6DFVVwXl0kmB/nwd3T0ICm0khj//CWyoVElSCy3ZWqfRcAmQP/vpv2MrRNjezR+w
         SE1f8rFK93iAtMcpIPtvYKn3jIdxnWQkd0v3gcz5B4pC5ogzc4RodbcyCLn5bhmZ8THC
         lfmvx7Q54psTPwpnhFsfX51ZVsA2nJIUhY16RxwjenJZEB8VNV92U9RlufhLM6VFTXuh
         PuhA==
X-Gm-Message-State: AOAM530ZNWr4LUhoRIgVxfwKCLLb/IWYFoPqB0PL9xEhP1WNESqcnQqF
        Hx9yQUqjrWJTIDHW7KZaIJRlRlo=
X-Google-Smtp-Source: ABdhPJytWSFWDftlNCzb6hiGAzk4etWEeuivRs5nb1gmQf263LPVBKP9vqCdudWtGZ2KldkOUE5KSBA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:fc03:a91c:4fe0:3b78])
 (user=sdf job=sendgmr) by 2002:a25:ae51:: with SMTP id g17mr7450259ybe.738.1639587070923;
 Wed, 15 Dec 2021 08:51:10 -0800 (PST)
Date:   Wed, 15 Dec 2021 08:51:08 -0800
In-Reply-To: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
Message-Id: <Yboc/G18R1Vi1eQV@google.com>
Mime-Version: 1.0
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
From:   sdf@google.com
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15, Pavel Begunkov wrote:
> Add per socket fast path for not enabled BPF skb filtering, which sheds
> a nice chunk of send/recv overhead when affected. Testing udp with 128
> byte payload and/or zerocopy with any payload size showed 2-3%
> improvement in requests/s on the tx side using fast NICs across network,
> and around 4% for dummy device. Same goes for rx, not measured, but
> numbers should be relatable.
> In my understanding, this should affect a good share of machines, and at
> least it includes my laptops and some checked servers.

> The core of the problem is that even though there is
> cgroup_bpf_enabled_key guarding from __cgroup_bpf_run_filter_skb()
> overhead, there are cases where we have several cgroups and loading a
> BPF program to one also makes all others to go through the slow path
> even when they don't have any BPF attached. It's even worse, because
> apparently systemd or some other early init loads some BPF and so
> triggers exactly this situation for normal networking.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---

> v2: replace bitmask appoach with empty_prog_array (suggested by Martin)
> v3: add "bpf_" prefix to empty_prog_array (Martin)

>   include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
>   include/linux/bpf.h        | 13 +++++++++++++
>   kernel/bpf/cgroup.c        | 18 ++----------------
>   kernel/bpf/core.c          | 16 ++++------------
>   4 files changed, 40 insertions(+), 31 deletions(-)

> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 11820a430d6c..c6dacdbdf565 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map  
> *map, void *key, void *value);
>   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>   				     void *value, u64 flags);

> +static inline bool
> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
> +				 enum cgroup_bpf_attach_type type)
> +{
> +	struct bpf_prog_array *array =  
> rcu_access_pointer(cgrp_bpf->effective[type]);
> +
> +	return array == &bpf_empty_prog_array.hdr;
> +}
> +
> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> +({									       \
> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
> +									       \
> +	!__cgroup_bpf_prog_array_is_empty(&__cgrp->bpf, (atype));	       \
> +})
> +
>   /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by  
> cgroup_bpf_enabled. */
>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
>   ({									      \
>   	int __ret = 0;							      \
> -	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))		      \
> +	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&		      \
> +	    CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS)) 	      \

Why not add this __cgroup_bpf_run_filter_skb check to
__cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is already there
and you can use it. Maybe move the things around if you want
it to happen earlier.

>   		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
>   						    CGROUP_INET_INGRESS); \
>   									      \
> @@ -235,9 +252,10 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map  
> *map, void *key,
>   	int __ret = 0;							       \
>   	if (cgroup_bpf_enabled(CGROUP_INET_EGRESS) && sk && sk == skb->sk) { \
>   		typeof(sk) __sk = sk_to_full_sk(sk);			       \
> -		if (sk_fullsock(__sk))					       \
> +		if (sk_fullsock(__sk) &&				       \
> +		    CGROUP_BPF_TYPE_ENABLED(__sk, CGROUP_INET_EGRESS))	       \
>   			__ret = __cgroup_bpf_run_filter_skb(__sk, skb,	       \
> -						      CGROUP_INET_EGRESS); \
> +						      CGROUP_INET_EGRESS);     \
>   	}								       \
>   	__ret;								       \
>   })
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index e7a163a3146b..0d2195c6fb2a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1161,6 +1161,19 @@ struct bpf_prog_array {
>   	struct bpf_prog_array_item items[];
>   };

> +struct bpf_empty_prog_array {
> +	struct bpf_prog_array hdr;
> +	struct bpf_prog *null_prog;
> +};
> +
> +/* to avoid allocating empty bpf_prog_array for cgroups that
> + * don't have bpf program attached use one global 'bpf_empty_prog_array'
> + * It will not be modified the caller of bpf_prog_array_alloc()
> + * (since caller requested prog_cnt == 0)
> + * that pointer should be 'freed' by bpf_prog_array_free()
> + */
> +extern struct bpf_empty_prog_array bpf_empty_prog_array;
> +
>   struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
>   void bpf_prog_array_free(struct bpf_prog_array *progs);
>   int bpf_prog_array_length(struct bpf_prog_array *progs);
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 43eb3501721b..99e85f44e257 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1354,20 +1354,6 @@ int __cgroup_bpf_run_filter_sysctl(struct  
> ctl_table_header *head,
>   }

>   #ifdef CONFIG_NET
> -static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> -					     enum cgroup_bpf_attach_type attach_type)
> -{
> -	struct bpf_prog_array *prog_array;
> -	bool empty;
> -
> -	rcu_read_lock();
> -	prog_array = rcu_dereference(cgrp->bpf.effective[attach_type]);
> -	empty = bpf_prog_array_is_empty(prog_array);
> -	rcu_read_unlock();
> -
> -	return empty;
> -}
> -
>   static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int  
> max_optlen,
>   			     struct bpf_sockopt_buf *buf)
>   {
> @@ -1430,7 +1416,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock  
> *sk, int *level,
>   	 * attached to the hook so we don't waste time allocating
>   	 * memory and locking the socket.
>   	 */
> -	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_SETSOCKOPT))
> +	if (__cgroup_bpf_prog_array_is_empty(&cgrp->bpf, CGROUP_SETSOCKOPT))
>   		return 0;

>   	/* Allocate a bit more than the initial user buffer for
> @@ -1526,7 +1512,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock  
> *sk, int level,
>   	 * attached to the hook so we don't waste time allocating
>   	 * memory and locking the socket.
>   	 */
> -	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_GETSOCKOPT))
> +	if (__cgroup_bpf_prog_array_is_empty(&cgrp->bpf, CGROUP_GETSOCKOPT))
>   		return retval;

>   	ctx.optlen = max_optlen;
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 2405e39d800f..fa76d1d839ad 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1967,18 +1967,10 @@ static struct bpf_prog_dummy {
>   	},
>   };

> -/* to avoid allocating empty bpf_prog_array for cgroups that
> - * don't have bpf program attached use one global 'empty_prog_array'
> - * It will not be modified the caller of bpf_prog_array_alloc()
> - * (since caller requested prog_cnt == 0)
> - * that pointer should be 'freed' by bpf_prog_array_free()
> - */
> -static struct {
> -	struct bpf_prog_array hdr;
> -	struct bpf_prog *null_prog;
> -} empty_prog_array = {
> +struct bpf_empty_prog_array bpf_empty_prog_array = {
>   	.null_prog = NULL,
>   };
> +EXPORT_SYMBOL(bpf_empty_prog_array);

>   struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
>   {
> @@ -1988,12 +1980,12 @@ struct bpf_prog_array *bpf_prog_array_alloc(u32  
> prog_cnt, gfp_t flags)
>   			       (prog_cnt + 1),
>   			       flags);

> -	return &empty_prog_array.hdr;
> +	return &bpf_empty_prog_array.hdr;
>   }

>   void bpf_prog_array_free(struct bpf_prog_array *progs)
>   {
> -	if (!progs || progs == &empty_prog_array.hdr)
> +	if (!progs || progs == &bpf_empty_prog_array.hdr)
>   		return;
>   	kfree_rcu(progs, rcu);
>   }
> --
> 2.34.0

