Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53D862B734
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiKPKKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiKPKJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:09:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147591A825
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668593345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bR8ucPQr+trfcQUZ2thiHFpR+hoJKIGj1KLU+Vv+yTU=;
        b=WSfIpdzHu9WXnQsBAmCprcG8RybID9cXMiASkv0CRtl5tMHde7WXWiBsfsTTsamJPgM3p1
        3+9VrnNcEvEj8GIs3UMMGV6CWcFYbNm8ukqLLZPq1iLV9POr1dZsLq2f2YmGVukKgBW5Pv
        zNLu2BNpE22F/B/Nw6kMVgarIyFGqy0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-177-Vl24V0jJNxCLiYQx9xX0YA-1; Wed, 16 Nov 2022 05:09:04 -0500
X-MC-Unique: Vl24V0jJNxCLiYQx9xX0YA-1
Received: by mail-ej1-f72.google.com with SMTP id sb4-20020a1709076d8400b007ae596eac08so9696333ejc.22
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bR8ucPQr+trfcQUZ2thiHFpR+hoJKIGj1KLU+Vv+yTU=;
        b=oJGV0opxPz6N4TvN+DUdiEZzbgWikMkRiK0diqv2Bac40wkboX4/rzXB49uIeWDusk
         7km8rrk1wCVUSj9JFSCx0A8/d2Oy7d6ARxcr8R4+05dCkl4qEuD1E/BfQTmceznkRYYh
         hm85pYqVtyhxVzCjau/HMLsvtgtjEoIkw1CBXm+0N47NrbgwZF/0ZufNrKHt9I4b+eYJ
         xH7eRzusHUVnrcD4mbzg20ywhO2JHNK2DosML6Oa2Ca5V0a5PxCf7dOPWwYW/QB46jpW
         rSoZ+3PGpDLCdTqIQH3tRO526e8qlY8aCWjTDm0AF9OraIq4NjVVX5UOxWAlhDaAuMUr
         1K9A==
X-Gm-Message-State: ANoB5pl30152HuNMRhAcUk0sI4WpYysUaOHAMlN+7IYhexcKxW7JmlSL
        WssZfezQhM8mEQqoByFMNG9RLbpRmtfpfGYXtZqgp31OYzAtRFoh3CboNB9Bpll26Sb1vPeRBIL
        bGJ4QFKPGhL8yRR3o
X-Received: by 2002:aa7:db15:0:b0:468:7be6:55e7 with SMTP id t21-20020aa7db15000000b004687be655e7mr2610050eds.345.1668593341270;
        Wed, 16 Nov 2022 02:09:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6evcDa/XsqjO7cp/WFcVheyO/4f8hk7zT1v1XbfXNA2JuqUQmxM39cHHILJVlnp1v5BL3bTA==
X-Received: by 2002:aa7:db15:0:b0:468:7be6:55e7 with SMTP id t21-20020aa7db15000000b004687be655e7mr2609978eds.345.1668593340017;
        Wed, 16 Nov 2022 02:09:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id rl24-20020a170907217800b00770880dfc4fsm6666527ejb.29.2022.11.16.02.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:08:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7CED27A6DE7; Wed, 16 Nov 2022 11:08:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx
 timestamp metadata for xdp
In-Reply-To: <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com> <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
 <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Nov 2022 11:08:58 +0100
Message-ID: <878rkbjjnp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 11/15/22 10:38 PM, John Fastabend wrote:
>>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
>>>>>>> +                           struct bpf_patch *patch)
>>>>>>> +{
>>>>>>> +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
>>>>>>> +             /* return true; */
>>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
>>>>>>> +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
>>>>>>> +             /* return ktime_get_mono_fast_ns(); */
>>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_fast_ns));
>>>>>>> +     }
>>>>>>> +}
>>>>>>
>>>>>> So these look reasonable enough, but would be good to see some examples
>>>>>> of kfunc implementations that don't just BPF_CALL to a kernel function
>>>>>> (with those helper wrappers we were discussing before).
>>>>>
>>>>> Let's maybe add them if/when needed as we add more metadata support?
>>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
>>>>> examples, so it shouldn't be a problem to resurrect them back at some
>>>>> point?
>>>>
>>>> Well, the reason I asked for them is that I think having to maintain the
>>>> BPF code generation in the drivers is probably the biggest drawback of
>>>> the kfunc approach, so it would be good to be relatively sure that we
>>>> can manage that complexity (via helpers) before we commit to this :)
>>>
>>> Right, and I've added a bunch of examples in v2 rfc so we can judge
>>> whether that complexity is manageable or not :-)
>>> Do you want me to add those wrappers you've back without any real users?
>>> Because I had to remove my veth tstamp accessors due to John/Jesper
>>> objections; I can maybe bring some of this back gated by some
>>> static_branch to avoid the fastpath cost?
>> 
>> I missed the context a bit what did you mean "would be good to see some
>> examples of kfunc implementations that don't just BPF_CALL to a kernel
>> function"? In this case do you mean BPF code directly without the call?
>> 
>> Early on I thought we should just expose the rx_descriptor which would
>> be roughly the same right? (difference being code embedded in driver vs
>> a lib) Trouble I ran into is driver code using seqlock_t and mutexs
>> which wasn't as straight forward as the simpler just read it from
>> the descriptor. For example in mlx getting the ts would be easy from
>> BPF with the mlx4_cqe struct exposed
>> 
>> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
>> {
>>          u64 hi, lo;
>>          struct mlx4_ts_cqe *ts_cqe = (struct mlx4_ts_cqe *)cqe;
>> 
>>          lo = (u64)be16_to_cpu(ts_cqe->timestamp_lo);
>>          hi = ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) << 16;
>> 
>>          return hi | lo;
>> }
>> 
>> but converting that to nsec is a bit annoying,
>> 
>> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>>                              struct skb_shared_hwtstamps *hwts,
>>                              u64 timestamp)
>> {
>>          unsigned int seq;
>>          u64 nsec;
>> 
>>          do {
>>                  seq = read_seqbegin(&mdev->clock_lock);
>>                  nsec = timecounter_cyc2time(&mdev->clock, timestamp);
>>          } while (read_seqretry(&mdev->clock_lock, seq));
>> 
>>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
>>          hwts->hwtstamp = ns_to_ktime(nsec);
>> }
>> 
>> I think the nsec is what you really want.
>> 
>> With all the drivers doing slightly different ops we would have
>> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
>> at least the mlx and ice drivers it looks like we would need some
>> more BPF primitives/helpers. Looks like some more work is needed
>> on ice driver though to get rx tstamps on all packets.
>> 
>> Anyways this convinced me real devices will probably use BPF_CALL
>> and not BPF insns directly.
>
> Some of the mlx5 path looks like this:
>
> #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u64)low))
>
> static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *clock,
>                                                u64 timestamp)
> {
>          u64 time = REAL_TIME_TO_NS(timestamp >> 32, timestamp & 0xFFFFFFFF);
>
>          return ns_to_ktime(time);
> }
>
> If some hints are harder to get, then just doing a kfunc call is better.

Sure, but if we end up having a full function call for every field in
the metadata, that will end up having a significant performance impact
on the XDP data path (thinking mostly about the skb metadata case here,
which will collect several bits of metadata).

> csum may have a better chance to inline?

Yup, I agree. Including that also makes it possible to benchmark this
series against Jesper's; which I think we should definitely be doing
before merging this.

> Regardless, BPF in-lining is a well solved problem and used in many
> bpf helpers already, so there are many examples in the kernel. I don't
> think it is necessary to block this series because of missing some
> helper wrappers for inlining. The driver can always start with the
> simpler kfunc call first and optimize later if some hints from the
> drivers allow it.

Well, "solved" in the sense of "there are a few handfuls of core BPF
people who know how to do it". My concern is that we'll end up with
either the BPF devs having to maintain all these bits of BPF byte code
in all the drivers; or drivers just punting to regular function calls
because the inlining is too complicated, with sub-par performance as per
the above. I don't think we should just hand-wave this away as "solved",
but rather treat this as an integral part of the initial series.

-Toke

