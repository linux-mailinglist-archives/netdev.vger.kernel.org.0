Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0434C36C83E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhD0PFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:05:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:59814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhD0PFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 11:05:17 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbPGJ-000DeM-Tf; Tue, 27 Apr 2021 17:04:31 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbPGJ-000Nub-K3; Tue, 27 Apr 2021 17:04:31 +0200
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
Date:   Tue, 27 Apr 2021 17:04:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210423150600.498490-3-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
[...]
>   tools/lib/bpf/libbpf.h   |  92 ++++++++
>   tools/lib/bpf/libbpf.map |   5 +
>   tools/lib/bpf/netlink.c  | 478 ++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 574 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bec4e6a6e31d..1c717c07b66e 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -775,6 +775,98 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> 
> +enum bpf_tc_attach_point {
> +	BPF_TC_INGRESS,
> +	BPF_TC_EGRESS,
> +	BPF_TC_CUSTOM_PARENT,
> +	_BPF_TC_PARENT_MAX,

I don't think we need to expose _BPF_TC_PARENT_MAX as part of the API, I would drop
the latter.

> +};
> +
> +/* The opts structure is also used to return the created filters attributes
> + * (e.g. in case the user left them unset). Some of the options that were left
> + * out default to a reasonable value, documented below.
> + *
> + *	protocol - ETH_P_ALL
> + *	chain index - 0
> + *	class_id - 0 (can be set by bpf program using skb->tc_classid)
> + *	bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
> + *	bpf_flags_gen - 0
> + *
> + *	The user must fulfill documented requirements for each function.

Not sure if this is overly relevant as part of the bpf_tc_opts in here. For the
2nd part, I would probably just mention that libbpf internally attaches the bpf
programs with direct action mode. The hw offload may be future todo, and the other
bits are little used anyway; mentioning them here, what value does it have to
libbpf users? I'd rather just drop the 2nd part and/or simplify this paragraph
just stating that the progs are attached in direct action mode.

> + */
> +struct bpf_tc_opts {
> +	size_t sz;
> +	__u32 handle;
> +	__u32 parent;
> +	__u16 priority;
> +	__u32 prog_id;
> +	bool replace;
> +	size_t :0;
> +};
> +
> +#define bpf_tc_opts__last_field replace
> +
> +struct bpf_tc_ctx;
> +
> +struct bpf_tc_ctx_opts {
> +	size_t sz;
> +};
> +
> +#define bpf_tc_ctx_opts__last_field sz
> +
> +/* Requirements */
> +/*
> + * @ifindex: Must be > 0.
> + * @parent: Must be one of the enum constants < _BPF_TC_PARENT_MAX
> + * @opts: Can be NULL, currently no options are supported.
> + */

Up to Andrii, but we don't have such API doc in general inside libbpf.h, I
would drop it for the time being to be consistent with the rest (same for
others below).

> +LIBBPF_API struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex,

nit: in user space s/__u32 ifindex/int ifindex/

> +					      enum bpf_tc_attach_point parent,
> +					      struct bpf_tc_ctx_opts *opts);

Should we enforce opts being NULL or non-NULL here, or drop the arg from here
for now altogether? (And if later versions of the functions show up this could
be mapped to the right one?)

> +/*
> + * @ctx: Can be NULL, if not, must point to a valid object.
> + *	 If the qdisc was attached during ctx_init, it will be deleted if no
> + *	 filters are attached to it.
> + *	 When ctx == NULL, this is a no-op.
> + */
> +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
> +/*
> + * @ctx: Cannot be NULL.
> + * @fd: Must be >= 0.
> + * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
> + *	  optionally set. All fields except replace  will be set as per created
> + *        filter's attributes. parent must only be set when attach_point of ctx is
> + *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
> + *
> + * Fills the following fields in opts:
> + *	handle
> + *	parent
> + *	priority
> + *	prog_id
> + */
> +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
> +			     struct bpf_tc_opts *opts);
> +/*
> + * @ctx: Cannot be NULL.
> + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> + *	  must be set.
> + */
> +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
> +			     const struct bpf_tc_opts *opts);

One thing that I find a bit odd from this API is that BPF_TC_INGRESS / BPF_TC_EGRESS
needs to be set each time via bpf_tc_ctx_init(). So whenever a specific program would
be attached to both we need to 're-init' in between just to change from hook a to b,
whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a different opts->parent
without going this detour (unless the clsact wasn't loaded there in the first place).

Could we add a BPF_TC_UNSPEC to enum bpf_tc_attach_point, which the user would pass to
bpf_tc_ctx_init(), so that opts.direction = BPF_TC_INGRESS with subsequent bpf_tc_attach()
can be called, and same opts.direction = BPF_TC_EGRESS with bpf_tc_attach() for different
fd. The only thing we cared about in bpf_tc_ctx_init() resp. the ctx was that qdisc was
ready.

> +/*
> + * @ctx: Cannot be NULL.
> + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> + *	  must be set.
> + *
> + * Fills the following fields in opts:
> + *	handle
> + *	parent
> + *	priority
> + *	prog_id
> + */
> +LIBBPF_API int bpf_tc_query(struct bpf_tc_ctx *ctx,
> +			    struct bpf_tc_opts *opts);
> +
>   #ifdef __cplusplus
>   } /* extern "C" */
>   #endif
