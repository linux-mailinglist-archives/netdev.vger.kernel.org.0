Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5327236CABB
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhD0SBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:01:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhD0SBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619546420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CKrgALHVEgN6fGE15CxFWB5GcyFBxoUmnjcuKmaLHE0=;
        b=J51UlXfaeWQcuZB5u/16wUCY/GyqVOYbUSwh3191HhTIuU1psEbaPmwXymWLhk7xH7PuaF
        IJOwYat/FOWLiAnDhjHMj+x51ol4HCB06nhf4qhKhGZIjhEIm5SqSBYMtSCdEn40QG6/EL
        58JyFjUFpRD9QnwQJlbEB5hTANpFo0U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-rkeaZFyFMICxMWv47Hgq_A-1; Tue, 27 Apr 2021 14:00:18 -0400
X-MC-Unique: rkeaZFyFMICxMWv47Hgq_A-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso25553582edb.23
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 11:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CKrgALHVEgN6fGE15CxFWB5GcyFBxoUmnjcuKmaLHE0=;
        b=ZG7pAKLvR1uDEAwtgBb6D7L4ieviZ+b2oSS0V2tUgW3T1OhGa25YvpF/PN1v+8fKWg
         JNextOwwg2AzY00XBEWtcY+4M2372beHb6M16WIYZMd74HmeEHffUbjLRg+hCWiheSOe
         Pk4O0Rc0ppeukmzjbMfCfNI3/CLsc2HgiuMZ3rUPVZtlrmaKK6n4N+qbyUkRD7EGXS6I
         Vlb5DV0GZu6YoxVc7xMIDd7XgD+moKwlICgQUe7+JEexnnOHtMsFFSzDYTqZEAmKMVg2
         dR3/ega6krsKZGurZ+r4T6qS3oOW/dRv99HPBQbSHZecFRuWWgHfGIeUDKy71UJgSIeE
         pK4Q==
X-Gm-Message-State: AOAM531YF03/bzf6s3xru8oh2tDM8njZycSz74i3kfmco5g09Z/aqFGu
        19Vp0yP24XLwcrpVdHsz9Iq+2CK5Vl7zDbQ7o3ZETMj7WMtrECZsRzKKf4P/8q3o1Lmod9RNaXZ
        alniespDAWOh/iagf
X-Received: by 2002:a17:906:fa18:: with SMTP id lo24mr24423743ejb.125.1619546416466;
        Tue, 27 Apr 2021 11:00:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5XjcnUui/mbb5+o9DehwY79r16Nweo03ctwk0YzOtas7cEKznjeo1TSrS6P8rOWZX60FoYQ==
X-Received: by 2002:a17:906:fa18:: with SMTP id lo24mr24423716ejb.125.1619546416039;
        Tue, 27 Apr 2021 11:00:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t15sm2806595edr.55.2021.04.27.11.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 11:00:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B372B180615; Tue, 27 Apr 2021 20:00:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
In-Reply-To: <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 27 Apr 2021 20:00:14 +0200
Message-ID: <87lf93a9qp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
> [...]
>>   tools/lib/bpf/libbpf.h   |  92 ++++++++
>>   tools/lib/bpf/libbpf.map |   5 +
>>   tools/lib/bpf/netlink.c  | 478 ++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 574 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index bec4e6a6e31d..1c717c07b66e 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -775,6 +775,98 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>> 
>> +enum bpf_tc_attach_point {
>> +	BPF_TC_INGRESS,
>> +	BPF_TC_EGRESS,
>> +	BPF_TC_CUSTOM_PARENT,
>> +	_BPF_TC_PARENT_MAX,
>
> I don't think we need to expose _BPF_TC_PARENT_MAX as part of the API, I would drop
> the latter.
>
>> +};
>> +
>> +/* The opts structure is also used to return the created filters attributes
>> + * (e.g. in case the user left them unset). Some of the options that were left
>> + * out default to a reasonable value, documented below.
>> + *
>> + *	protocol - ETH_P_ALL
>> + *	chain index - 0
>> + *	class_id - 0 (can be set by bpf program using skb->tc_classid)
>> + *	bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
>> + *	bpf_flags_gen - 0
>> + *
>> + *	The user must fulfill documented requirements for each function.
>
> Not sure if this is overly relevant as part of the bpf_tc_opts in here. For the
> 2nd part, I would probably just mention that libbpf internally attaches the bpf
> programs with direct action mode. The hw offload may be future todo, and the other
> bits are little used anyway; mentioning them here, what value does it have to
> libbpf users? I'd rather just drop the 2nd part and/or simplify this paragraph
> just stating that the progs are attached in direct action mode.

The idea was that this would be for the benefit of people familiar with
TC concepts. Maybe simplify it to "Programs are attached in direct
action mode with a protocol value of 'all', and all other parameters
that the 'tc' binary supports will be set to 0"?

>> + */
>> +struct bpf_tc_opts {
>> +	size_t sz;
>> +	__u32 handle;
>> +	__u32 parent;
>> +	__u16 priority;
>> +	__u32 prog_id;
>> +	bool replace;
>> +	size_t :0;
>> +};
>> +
>> +#define bpf_tc_opts__last_field replace
>> +
>> +struct bpf_tc_ctx;
>> +
>> +struct bpf_tc_ctx_opts {
>> +	size_t sz;
>> +};
>> +
>> +#define bpf_tc_ctx_opts__last_field sz
>> +
>> +/* Requirements */
>> +/*
>> + * @ifindex: Must be > 0.
>> + * @parent: Must be one of the enum constants < _BPF_TC_PARENT_MAX
>> + * @opts: Can be NULL, currently no options are supported.
>> + */
>
> Up to Andrii, but we don't have such API doc in general inside libbpf.h, I
> would drop it for the time being to be consistent with the rest (same for
> others below).
>
>> +LIBBPF_API struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex,
>
> nit: in user space s/__u32 ifindex/int ifindex/
>
>> +					      enum bpf_tc_attach_point parent,
>> +					      struct bpf_tc_ctx_opts *opts);
>
> Should we enforce opts being NULL or non-NULL here, or drop the arg from here
> for now altogether? (And if later versions of the functions show up this could
> be mapped to the right one?)

Hmm, extending later is easier if there's already an opts parameter. But
it could be declared 'void *' and enforced as always 0 for now?

>> +/*
>> + * @ctx: Can be NULL, if not, must point to a valid object.
>> + *	 If the qdisc was attached during ctx_init, it will be deleted if no
>> + *	 filters are attached to it.
>> + *	 When ctx == NULL, this is a no-op.
>> + */
>> +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
>> +/*
>> + * @ctx: Cannot be NULL.
>> + * @fd: Must be >= 0.
>> + * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
>> + *	  optionally set. All fields except replace  will be set as per created
>> + *        filter's attributes. parent must only be set when attach_point of ctx is
>> + *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
>> + *
>> + * Fills the following fields in opts:
>> + *	handle
>> + *	parent
>> + *	priority
>> + *	prog_id
>> + */
>> +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
>> +			     struct bpf_tc_opts *opts);
>> +/*
>> + * @ctx: Cannot be NULL.
>> + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
>> + *	  must be set.
>> + */
>> +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
>> +			     const struct bpf_tc_opts *opts);
>
> One thing that I find a bit odd from this API is that BPF_TC_INGRESS / BPF_TC_EGRESS
> needs to be set each time via bpf_tc_ctx_init(). So whenever a specific program would
> be attached to both we need to 're-init' in between just to change from hook a to b,
> whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a different opts->parent
> without going this detour (unless the clsact wasn't loaded there in the first place).
>
> Could we add a BPF_TC_UNSPEC to enum bpf_tc_attach_point, which the user would pass to
> bpf_tc_ctx_init(), so that opts.direction = BPF_TC_INGRESS with subsequent bpf_tc_attach()
> can be called, and same opts.direction = BPF_TC_EGRESS with bpf_tc_attach() for different
> fd. The only thing we cared about in bpf_tc_ctx_init() resp. the ctx was that qdisc was
> ready.

This sounds workable - no objections from me :)

-Toke

