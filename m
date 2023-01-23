Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACBC678121
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjAWQPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjAWQPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:15:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F516279A0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674490473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hf49zbFN3KLWLBk8hS5GvALY3WWpLu7tA32Veqwn+JY=;
        b=eDbhiEvbcAM+NWAcIRD7vN1xiGbMGHGuWtYUksCAbPZAmkZMmDe0nl2eh50Gzfy2nYoxLP
        TmNXJrqHll8m7XFnG6k1tKpBlc+1TvqiYJw/Qh0puDGXhIXAMwXcxWG9ACdkdNe9QAk4uf
        miF2pvGUJeDQatzZ7msSwXuHpj+ZSso=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-pD69ye5oPGiyXpx7q6Fqtg-1; Mon, 23 Jan 2023 11:14:24 -0500
X-MC-Unique: pD69ye5oPGiyXpx7q6Fqtg-1
Received: by mail-ed1-f72.google.com with SMTP id q20-20020a056402519400b0049e5b8c71b3so8753027edd.17
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:14:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hf49zbFN3KLWLBk8hS5GvALY3WWpLu7tA32Veqwn+JY=;
        b=BasHWixR4ab4aDbJfpztKGSn1/lEtl8tQi5uofdrPePza6mufMWKy2jmxuyt9Dm7LZ
         b7YbBWqcAxXpR7ZMGSmwiNqBuqVo9E+1f0xw+HcL2N63B/uPhd7WpiA7goeSuJTiObcd
         NBgrdyyE9jOL+H0RaVkB4WkYi6w2fi4oxcnzJjTQl2HtkhWI/k6Uo0uk5dKrDFnOtg+c
         biYWM2AwySHUcs2ycRcjUdcSPcj8gKFujf1oacr0plrE41nmxYnbgo7RPL90dVlXwLHQ
         X4ZvZsm1uoM/KTVLeSnz2eAd4P3SdcL+h1DgWT4c0UtPM2SWVRkOqDtWYgoyTYFbK0rO
         wvYg==
X-Gm-Message-State: AFqh2korWq1vmQ+70ex6w159ZWMBlBZUzfGprApWqlFheKGGWWkY9hSw
        pXQfp8soZPPaYiOqIajpkCNc6A5AOaicX4rGPPv2Tgkc6vXOMrp/0+mw5rgQ7JLjU1/sfUuakwK
        XKcBuvwYCr5Eb354j
X-Received: by 2002:a17:907:6a98:b0:855:2c8e:ad52 with SMTP id ri24-20020a1709076a9800b008552c8ead52mr17843935ejc.29.1674490463170;
        Mon, 23 Jan 2023 08:14:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv+Ny52Z+U9d4jr3eRVh9oPEFixUW8YzkJnmICr1vzlSqFUiOIA8sHYmemxRecEArKSShHS/w==
X-Received: by 2002:a17:907:6a98:b0:855:2c8e:ad52 with SMTP id ri24-20020a1709076a9800b008552c8ead52mr17843911ejc.29.1674490462981;
        Mon, 23 Jan 2023 08:14:22 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id sa14-20020a170906edae00b008639ddec882sm16028604ejb.56.2023.01.23.08.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 08:14:22 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <93665604-5420-be5d-2104-17850288b955@redhat.com>
Date:   Mon, 23 Jan 2023 17:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, David Rientjes <rientjes@google.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
To:     Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org,
        linux-mm@kvack.org
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <bfe4ff8f-0244-739d-3dfa-60101c8bf6b8@suse.cz>
Content-Language: en-US
In-Reply-To: <bfe4ff8f-0244-739d-3dfa-60101c8bf6b8@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 08.36, Vlastimil Babka wrote:
> On 1/17/23 14:40, Jesper Dangaard Brouer wrote:
>> Allow API users of kmem_cache_create to specify that they don't want
>> any slab merge or aliasing (with similar sized objects). Use this in
>> network stack and kfence_test.
>>
>> The SKB (sk_buff) kmem_cache slab is critical for network performance.
>> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
>> performance by amortising the alloc/free cost.
>>
>> For the bulk API to perform efficiently the slub fragmentation need to
>> be low. Especially for the SLUB allocator, the efficiency of bulk free
>> API depend on objects belonging to the same slab (page).
> 
> Incidentally, would you know if anyone still uses SLAB instead of SLUB
> because it would perform better for networking? IIRC in the past discussions
> networking was one of the reasons for SLAB to stay. We are looking again
> into the possibility of removing it, so it would be good to know if there
> are benchmarks where SLUB does worse so it can be looked into.
> 

I don't know of any users using SLAB for network performance reasons.
I've only been benchmarking with SLUB for a long time.
Anyone else on netdev?

Both SLUB and SLAB got the kmem_cache bulk API implemented.  This is
used today in network stack to squeeze extra performance for networking
for our SKB (sk_buff) metadata structure (that point to packet data).
Details: Networking cache upto 64 of these SKBs for RX-path NAPI-softirq
processing per CPU, which is repopulated with kmem_cache bulking API
(bulk alloc 16 and bulk free 32).

>> When running different network performance microbenchmarks, I started
>> to notice that performance was reduced (slightly) when machines had
>> longer uptimes. I believe the cause was 'skbuff_head_cache' got
>> aliased/merged into the general slub for 256 bytes sized objects (with
>> my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> So did things improve with SLAB_NEVER_MERGE?

Yes, but only the stability of the results.

The performance tests were microbenchmarks and as Christoph points out
there might be gains from more partial slabs when there are more
fragmentation.  The "overload" microbench will always do maximum
bulking, while more real workloads might be satisfied from the partial
slabs.  I would need to do a broader range of benchmarks before I can
conclude if this is always a win.

>> For SKB kmem_cache network stack have reasons for not merging, but it
>> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
>> We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.
>>

In most distro kernels configs SKB kmem_cache will already not get
merged / aliased.  I was just trying to make this consistent.

>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   include/linux/slab.h    |    2 ++
>>   mm/kfence/kfence_test.c |    7 +++----
>>   mm/slab.h               |    5 +++--
>>   mm/slab_common.c        |    8 ++++----
>>   net/core/skbuff.c       |   13 ++++++++++++-
>>   5 files changed, 24 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 45af70315a94..83a89ba7c4be 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -138,6 +138,8 @@
>>   #define SLAB_SKIP_KFENCE	0
>>   #endif
>>   
>> +#define SLAB_NEVER_MERGE	((slab_flags_t __force)0x40000000U)
> 
> I think there should be an explanation what this does and when to consider
> it. We should discourage blind use / cargo cult / copy paste from elsewhere
> resulting in excessive proliferation of the flag.

I agree.

> - very specialized internal things like kfence? ok
> - prevent a bad user of another cache corrupt my cache due to merging? no,
> use slub_debug to find and fix the root cause

Agree, and the comment could point to the slub_debug trick.

> - performance concerns? only after proper evaluation, not prematurely
>

Yes, and I would need to do more perf eval myself ;-)
I don't have time atm, thus I'll not pursue this RFC patch anytime soon.

--Jesper

