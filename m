Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16B74B94CA
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 01:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbiBQADo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 19:03:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiBQADn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 19:03:43 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332DE45AE7;
        Wed, 16 Feb 2022 16:03:25 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nKUGY-0003xS-CD; Thu, 17 Feb 2022 01:03:22 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nKUGY-000D9W-2D; Thu, 17 Feb 2022 01:03:22 +0100
Subject: Re: [PATCH v4 net-next 5/8] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071303.890169-1-kafai@fb.com>
 <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
 <20220216055142.n445wwtqmqewc57a@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b181acbe-caf8-502d-4b7b-7d96b9fc5d55@iogearbox.net>
Date:   Thu, 17 Feb 2022 01:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220216055142.n445wwtqmqewc57a@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26455/Wed Feb 16 10:22:44 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 6:51 AM, Martin KaFai Lau wrote:
> On Wed, Feb 16, 2022 at 12:30:53AM +0100, Daniel Borkmann wrote:
>> On 2/11/22 8:13 AM, Martin KaFai Lau wrote:
>>> The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
>>> as a (rcv) timestamp.  This patch is to backward compatible with the
>>> (rcv) timestamp expectation when the skb->tstamp has a mono delivery_time.
>>>
>>> If needed, the patch first saves the mono delivery_time.  Depending on
>>> the static key "netstamp_needed_key", it then resets the skb->tstamp to
>>> either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
>>> the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
>>> been changed, it will restore the earlier saved mono delivery_time.
>>>
>>> The current logic to run tc-bpf@ingress is refactored to a new
>>> bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf.
>>> The above new delivery_time save/restore logic is also done together in
>>> this function.
>>>
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>> ---
>>>    include/linux/filter.h | 28 ++++++++++++++++++++++++++++
>>>    net/sched/act_bpf.c    |  5 +----
>>>    net/sched/cls_bpf.c    |  6 +-----
>>>    3 files changed, 30 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>>> index d23e999dc032..e43e1701a80e 100644
>>> --- a/include/linux/filter.h
>>> +++ b/include/linux/filter.h
>>> @@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
>>>    	cb->data_end  = skb->data + skb_headlen(skb);
>>>    }
>>> +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog *prog,
>>> +						   struct sk_buff *skb)
>>> +{
>>> +	ktime_t tstamp, saved_mono_dtime = 0;
>>> +	int filter_res;
>>> +
>>> +	if (unlikely(skb->mono_delivery_time)) {
>>> +		saved_mono_dtime = skb->tstamp;
>>> +		skb->mono_delivery_time = 0;
>>> +		if (static_branch_unlikely(&netstamp_needed_key))
>>> +			skb->tstamp = tstamp = ktime_get_real();
>>> +		else
>>> +			skb->tstamp = tstamp = 0;
>>> +	}
>>> +
>>> +	/* It is safe to push/pull even if skb_shared() */
>>> +	__skb_push(skb, skb->mac_len);
>>> +	bpf_compute_data_pointers(skb);
>>> +	filter_res = bpf_prog_run(prog, skb);
>>> +	__skb_pull(skb, skb->mac_len);
>>> +
>>> +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
>>> +	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) == tstamp)
>>> +		skb_set_delivery_time(skb, saved_mono_dtime, true);
>>
>> So above detour is for skb->tstamp backwards compatibility so users will see real time.
>> I don't see why we special case {cls,act}_bpf-only, given this will also be the case
>> for other subsystems (e.g. netfilter) when they read access plain skb->tstamp and get
>> the egress one instead of ktime_get_real() upon deferred skb_clear_delivery_time().
>>
>> If we would generally ignore it, then the above bpf_prog_run_at_ingress() save/restore
>> detour is not needed (so patch 5/6 should be dropped). (Meaning, if we need to special
>> case {cls,act}_bpf only, we could also have gone for simpler bpf-only solution..)
> The limitation here is there is only one skb->tstamp field.  I don't see
> a bpf-only solution or not will make a difference here.

A BPF-only solution would probably just treat the skb->tstamp as (semi-)opaque,
meaning, there're no further bits on clock type needed in skb, but given the
environment is controlled by an orchestrator it can decide which tstamps to
retain or which to reset (e.g. by looking at skb->sk). (The other approach is
exposing info on clock base as done here to some degree for mono/real.)

> Regarding the netfilter (good point!), I only see it is used in nfnetlink_log.c
> and nfnetlink_queue.c.  Like the tapping cases (earlier than the bpf run-point)
> and in general other ingress cases, it cannot assume the rcv timestamp is
> always there, so they can be changed like af_packet in patch 3
> which is a straight forward change.  I can make the change in v5.
> 
> Going back to the cls_bpf at ingress.  If the concern is on code cleanliness,
> how about removing this dance for now while the current rcv tstamp usage is
> unclear at ingress.  Meaning keep the delivery_time (if any) in skb->tstamp.
> This dance could be brought in later when there was breakage and legit usecase
> reported.  The new bpf prog will have to use the __sk_buff->delivery_time_type
> regardless if it wants to use skb->tstamp as the delivery_time, so they won't
> assume delivery_time is always in skb->tstamp and it will be fine even this
> dance would be brought back in later.

Yes, imho, this is still better than the bpf_prog_run_at_ingress() workaround.
Ideally, we know when we call helpers like ktime_get_ns() that the clock will
be mono. We could track that on verifier side in the register type, and when we
end up writing to skb->tstamp, we could implicitly also set the clock base bits
in skb for the ctx rewrite telling that it's of type 'mono'. Same for reading,
we could add __sk_buff->tstamp_type which program can access (imo tstamp_type
is more generic than a __sk_buff->delivery_time_type). If someone needs
ktime_get_clocktai_ns() for sch_etf in future, it could be similar tracking
mechanism. Also setting skb->tstamp to 0 ...

> Regarding patch 6, it is unrelated.  It needs to clear the
> mono_delivery_time bit if the bpf writes 0 to the skb->tstamp.

... doesn't need to be done as code after bpf_prog_run(), but should be brought
closer to when we write to the ctx where verifier generates the relevant insns.
Imo, that's better than having this outside in bpf_prog_run() which is then
checked no matter what program was doing or even accessing tstamp.

Thanks,
Daniel
