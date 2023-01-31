Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246C168391C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAaWQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjAaWQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:16:10 -0500
X-Greylist: delayed 522 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 14:16:09 PST
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9695645BE8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:16:09 -0800 (PST)
Message-ID: <c873deaf-6d63-98b1-a29a-01dd311be99a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675202846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ck7B5zBKkHCM9oUtwGTyOQHqePke66EuHA6ljEevXRw=;
        b=CenTPmdiLMg3jshXTEFCGkCdW2d1qrmfHOQiVjTZu05vjyUWy4dOowfMV4aLNkC4OX5PV6
        TTgdIpZ0s4DaznUxxmLPffhGlcTQyUXKPTTmI3ZM6P95gOjHmq30zNUrLdeDyMk0DVsm7/
        sapep+rq2RfdHhsxiCuhi4wpuvUYu8c=
Date:   Tue, 31 Jan 2023 14:07:17 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
 <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 9:30 PM, Alexei Starovoitov wrote:
>>>>> Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
>>>>> the packet calling that in bpf_dynptr_data is a heavy hammer.
>>>>>
>>>>> It feels that we need to go back to skb_header_pointer-like discussion.
>>>>> Something like:
>>>>> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
>>>>> Whether buffer is a part of dynptr or program provided is tbd.
>>>>
>>>> making it hidden within dynptr would make this approach unreliable
>>>> (memory allocations, which can fail, etc). But if we ask users to pass
>>>> it directly, then it should be relatively easy to use in practice with
>>>> some pre-allocated per-CPU buffer:
> 
> bpf_skb_pull_data() is even more unreliable, since it's a bigger allocation.
> I like preallocated approach more, so we're in agreement here.
> 
>>>>
>>>>
>>>> struct {
>>>>     __int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>>>>     __int(max_entries, 1);
>>>>     __type(key, int);
>>>>     __type(value, char[4096]);
>>>> } scratch SEC(".maps");
>>>>
>>>>
>>>> ...
>>>>
>>>>
>>>> struct dyn_ptr *dp = bpf_dynptr_from_skb(...).
>>>> void *p, *buf;
>>>> int zero = 0;
>>>>
>>>> buf = bpf_map_lookup_elem(&scratch, &zero);
>>>> if (!buf) return 0; /* can't happen */
>>>>
>>>> p = bpf_dynptr_slice(dp, off, 16, buf);
>>>> if (p == NULL) {
>>>>      /* out of range */
>>>> } else {
>>>>      /* work with p directly */
>>>> }
>>>>
>>>> /* if we wrote something to p and it was copied to buffer, write it back */
>>>> if (p == buf) {
>>>>       bpf_dynptr_write(dp, buf, 16);
>>>> }
>>>>
>>>>
>>>> We'll just need to teach verifier to make sure that buf is at least 16
>>>> byte long.
>>>
>>> A fifth __sz arg may do:
>>> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void
>>> *buffer, u32 buffer__sz);
>>
>> We'll need to make sure that buffer__sz is >= len (or preferably not
>> require extra size at all). We can check that at runtime, of course,
>> but rejecting too small buffer at verification time would be a better
>> experience.
> 
> I don't follow. Why two equivalent 'len' args ?
> Just to allow 'len' to be a variable instead of constant ?
> It's unusual for the verifier to have 'len' before 'buffer',
> but this is fixable.

Agree. One const scalar 'len' should be enough. Buffer should have the same size 
as the requesting slice.

> 
> How about adding 'rd_only vs rdwr' flag ?
> Then MEM_RDONLY for ret value of bpf_dynptr_slice can be set by the verifier
> and in run-time bpf_dynptr_slice() wouldn't need to check for skb->cloned.
> if (rd_only) return skb_header_pointer()
> if (rdwr) bpf_try_make_writable(); return skb->data + off;
> and final bpf_dynptr_write() is not needed.
> 
> But that doesn't work for xdp, since there is no pull.
> 
> It's not clear how to deal with BPF_F_RECOMPUTE_CSUM though.
> Expose __skb_postpull_rcsum/__skb_postpush_rcsum as kfuncs?
> But that defeats Andrii's goal to use dynptr as a generic wrapper.
> skb is quite special.
> 
> Maybe something like:
> void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len,
>                         void *buffer, u32 buffer__sz)
> {
>    if (skb_cloned()) {
>      skb_copy_bits(skb, offset, buffer, len);
>      return buffer;
>    }
>    return skb_header_pointer(...);
> }
> 
> When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> No need for rdonly flag, but extra copy is there in case of cloned which
> could have been avoided with extra rd_only flag.
> 
> In case of xdp it will be:
> void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len,
>                         void *buffer, u32 buffer__sz)
> {
>     ptr = bpf_xdp_pointer(xdp, offset, len);
>     if (ptr)
>        return ptr;
>     bpf_xdp_copy_buf(xdp, offset, buffer, len, false); /* copy into buf */
>     return buffer;
> }
> 
> bpf_dynptr_write will use bpf_xdp_copy_buf(,true); /* copy into xdp */

My preference would be making bpf_dynptr_slice() work similarly for skb and xdp, 
so above bpf_dynptr_slice() skb and xdp logic looks good.

Regarding, MEM_RDONLY, it probably is not relevant to xdp. For skb, not sure how 
often is the 'skb_cloned() && !skb_clone_writable()'. May be it can be left for 
later optimization?

Regarding BPF_F_RECOMPUTE_CSUM, I wonder if bpf_csum_diff() is enough to come up 
the csum. Then the missing kfunc is to update the skb->csum. Not sure how the 
csum logic will look like in xdp, probably getting csum from the xdp-hint, 
calculate csum_diff and then set it to the to-be-created skb. All this is likely 
a kfunc also, eg. a kfunc to directly allocate skb during the XDP_PASS case. The 
bpf prog will have to be written differently if it needs to deal with the csum 
but the header parsing part could at least be shared.
