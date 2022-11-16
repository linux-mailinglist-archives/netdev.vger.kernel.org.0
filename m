Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43DD62B423
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiKPHrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiKPHrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:47:46 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16106D113;
        Tue, 15 Nov 2022 23:47:45 -0800 (PST)
Message-ID: <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668584863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ed1cg6SvB5gikz9nKb2NT1RQypbDjDrNtRQGfRyCBkA=;
        b=hwp6jDQMl5G3j8+T+IvdCqSTd926glT68BV4yjsPRXAUSq8QRGOdoP14Sy6p35T6pR5UEi
        UmpdmyYtBCKyPNktWOOhjCxxRVpBrMeF1cXyxasG7oXnNsTd0CECUdojPJeXca3vwjoTnl
        7pbMkvK0H4cQ3ZV6EW2YdfUevs/EEJE=
Date:   Tue, 15 Nov 2022 23:47:38 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
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
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com> <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <6374854883b22_5d64b208e3@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 10:38 PM, John Fastabend wrote:
>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
>>>>>> +                           struct bpf_patch *patch)
>>>>>> +{
>>>>>> +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
>>>>>> +             /* return true; */
>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
>>>>>> +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
>>>>>> +             /* return ktime_get_mono_fast_ns(); */
>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_fast_ns));
>>>>>> +     }
>>>>>> +}
>>>>>
>>>>> So these look reasonable enough, but would be good to see some examples
>>>>> of kfunc implementations that don't just BPF_CALL to a kernel function
>>>>> (with those helper wrappers we were discussing before).
>>>>
>>>> Let's maybe add them if/when needed as we add more metadata support?
>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
>>>> examples, so it shouldn't be a problem to resurrect them back at some
>>>> point?
>>>
>>> Well, the reason I asked for them is that I think having to maintain the
>>> BPF code generation in the drivers is probably the biggest drawback of
>>> the kfunc approach, so it would be good to be relatively sure that we
>>> can manage that complexity (via helpers) before we commit to this :)
>>
>> Right, and I've added a bunch of examples in v2 rfc so we can judge
>> whether that complexity is manageable or not :-)
>> Do you want me to add those wrappers you've back without any real users?
>> Because I had to remove my veth tstamp accessors due to John/Jesper
>> objections; I can maybe bring some of this back gated by some
>> static_branch to avoid the fastpath cost?
> 
> I missed the context a bit what did you mean "would be good to see some
> examples of kfunc implementations that don't just BPF_CALL to a kernel
> function"? In this case do you mean BPF code directly without the call?
> 
> Early on I thought we should just expose the rx_descriptor which would
> be roughly the same right? (difference being code embedded in driver vs
> a lib) Trouble I ran into is driver code using seqlock_t and mutexs
> which wasn't as straight forward as the simpler just read it from
> the descriptor. For example in mlx getting the ts would be easy from
> BPF with the mlx4_cqe struct exposed
> 
> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> {
>          u64 hi, lo;
>          struct mlx4_ts_cqe *ts_cqe = (struct mlx4_ts_cqe *)cqe;
> 
>          lo = (u64)be16_to_cpu(ts_cqe->timestamp_lo);
>          hi = ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) << 16;
> 
>          return hi | lo;
> }
> 
> but converting that to nsec is a bit annoying,
> 
> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>                              struct skb_shared_hwtstamps *hwts,
>                              u64 timestamp)
> {
>          unsigned int seq;
>          u64 nsec;
> 
>          do {
>                  seq = read_seqbegin(&mdev->clock_lock);
>                  nsec = timecounter_cyc2time(&mdev->clock, timestamp);
>          } while (read_seqretry(&mdev->clock_lock, seq));
> 
>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
>          hwts->hwtstamp = ns_to_ktime(nsec);
> }
> 
> I think the nsec is what you really want.
> 
> With all the drivers doing slightly different ops we would have
> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
> at least the mlx and ice drivers it looks like we would need some
> more BPF primitives/helpers. Looks like some more work is needed
> on ice driver though to get rx tstamps on all packets.
> 
> Anyways this convinced me real devices will probably use BPF_CALL
> and not BPF insns directly.

Some of the mlx5 path looks like this:

#define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u64)low))

static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *clock,
                                               u64 timestamp)
{
         u64 time = REAL_TIME_TO_NS(timestamp >> 32, timestamp & 0xFFFFFFFF);

         return ns_to_ktime(time);
}

If some hints are harder to get, then just doing a kfunc call is better.

csum may have a better chance to inline?

Regardless, BPF in-lining is a well solved problem and used in many bpf helpers 
already, so there are many examples in the kernel.  I don't think it is 
necessary to block this series because of missing some helper wrappers for 
inlining.  The driver can always start with the simpler kfunc call first and 
optimize later if some hints from the drivers allow it.
