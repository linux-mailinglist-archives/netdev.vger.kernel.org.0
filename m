Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C324B6643B9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbjAJOxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238768AbjAJOxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:53:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B80F5F56
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673362374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ZR2hH/Og2tvA2Z2IH1AQ+s93oJzoUdJTRBIrVY65Ns=;
        b=e/vOx7SUVzqeO6nAPrrBOJceQGyfdSC/AD9qBaiBwleKK/je4YC4m1bW10PyEQ9DmMBi7v
        eiIxwRQYi3WqwFtHbsRAuhkHgnNjAkcoYop9/TiLvYECTF4wMq+ZlQIZ09eCQhn0qNeilX
        GK6kHP6XJBVTC1gA+qzq1O1bzhBnHpw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-217-Uyi6jHqUONi2lCF5FHE0Ig-1; Tue, 10 Jan 2023 09:52:52 -0500
X-MC-Unique: Uyi6jHqUONi2lCF5FHE0Ig-1
Received: by mail-ej1-f71.google.com with SMTP id dr5-20020a170907720500b00808d17c4f27so7858338ejc.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:52:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZR2hH/Og2tvA2Z2IH1AQ+s93oJzoUdJTRBIrVY65Ns=;
        b=M2OcK0Jc0/kMLwbXnxUlcYHIoNIjGJE5JKSceay5znvxCbMy/HjwqlE8Hi57KAdEF4
         qZW0Pih8sL2ByCCgbYu+yi/X/IEYgxvZyndf5htJsBvf2j92/SuwRIlC5M9tqTZh6efk
         PeDkfWzPECBdip3eBz7iQi1lkC0//qZDklBczQ5NCoABRnBTPC046UEINsgwY3pg12rz
         z9fETAdzIsslIn7TqAl6ktr1GSvD4KilrgB0qOjGTcM1uypnOPsZRDCZSFqLnHredGU1
         7EOL1ZpNYjNTU2Oyo+CsefUPhQRn5kFtLIF8M+jHKGmXP/QDS+x0bQUqplhaKDv4e36s
         Pnxw==
X-Gm-Message-State: AFqh2ko0g6HXxT0rU2651MdSAw4Q5MrH9tLU2WHDZijPjQImEd8VUCc5
        ODDe50+tL9UHQ50OKYdv7X5uw0/dgt7aVYpIsIoqWm9JAtmKbmHXxW2eTHDbotVQToTO4AhJS4Y
        YEr8if6airR1ip07O
X-Received: by 2002:a17:906:99d0:b0:84d:43e4:479b with SMTP id s16-20020a17090699d000b0084d43e4479bmr8258866ejn.36.1673362370397;
        Tue, 10 Jan 2023 06:52:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvpk9DH71wrB/jCg88UIDlL5Y3koA2eYKcPpFDPRgzxtSAilEpClJoQM/+BrQJvd3X/3naIJQ==
X-Received: by 2002:a17:906:99d0:b0:84d:43e4:479b with SMTP id s16-20020a17090699d000b0084d43e4479bmr8258849ejn.36.1673362370121;
        Tue, 10 Jan 2023 06:52:50 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906210a00b007c0f2d051f4sm5016237ejt.203.2023.01.10.06.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 06:52:49 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <adf92243-689e-6013-293f-5464af317594@redhat.com>
Date:   Tue, 10 Jan 2023 15:52:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use kmem_cache_free_bulk
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
 <167293336786.249536.14237439594457105125.stgit@firesoul>
 <20230106143310.699197bd@kernel.org>
 <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
 <20230109113409.2d5fab44@kernel.org>
 <fa307736d5448733f08a5a700bc9c647b383a553.camel@gmail.com>
In-Reply-To: <fa307736d5448733f08a5a700bc9c647b383a553.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/01/2023 23.10, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 11:34 -0800, Jakub Kicinski wrote:
>> On Mon, 9 Jan 2023 13:24:54 +0100 Jesper Dangaard Brouer wrote:
>>>> Also the lack of perf numbers is a bit of a red flag.
>>>>   
>>>
>>> I have run performance tests, but as I tried to explain in the
>>> cover letter, for the qdisc use-case this code path is only activated
>>> when we have overflow at enqueue.  Thus, this doesn't translate directly
>>> into a performance numbers, as TX-qdisc is 100% full caused by hardware
>>> device being backed up, and this patch makes us use less time on freeing
>>> memory.
>>
>> I guess it's quite subjective, so it'd be good to get a third opinion.
>> To me that reads like a premature optimization. Saeed asked for perf
>> numbers, too.
>>
>> Does anyone on the list want to cast the tie-break vote?
> 
> I'd say there is some value to be gained by this. Basically it means
> less overhead for dropping packets if we picked a backed up Tx path.
> 

Thanks.

I have microbenchmarks[1] of kmem_cache bulking, which I use to assess 
what is the (best-case) expected gain of using the bulk APIs.

The module 'slab_bulk_test01' results at bulk 16 element:

  kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
  kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)

Thus, best-case expected gain is: 45 cycles(tsc) 12.627 ns.
  - With usual microbenchmarks caveats
  - Notice this is both bulk alloc and free

[1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm

>>> I have been using pktgen script ./pktgen_bench_xmit_mode_queue_xmit.sh
>>> which can inject packets at the qdisc layer (invoking __dev_queue_xmit).
>>> And then used perf-record to see overhead of SLUB (__slab_free is top#4)
>>> is reduced.
>>
>> Right, pktgen wasting time while still delivering line rate is not of
>> practical importance.
> 

I better explain how I cause the push-back without hitting 10Gbit/s line
rate (as we/Linux cannot allocated SKBs fast enough for this).

I'm testing this on a 10Gbit/s interface (driver ixgbe). The challenge 
is that I need to overload the qdisc enqueue layer as that is triggering 
the call to kfree_skb_list().

Linux with SKBs and qdisc injecting with pktgen is limited to producing 
packets at (measured) 2,205,588 pps with a single TX-queue (and scaling 
up 1,951,771 pps per queue or 512 ns per pkt). Reminder 10Gbit/s at 64 
bytes packets is 14.8 Mpps (or 67.2 ns per pkt).

The trick to trigger the qdisc push-back way earlier is Ethernet
flow-control (which is on by default).

I was a bit surprised to see, but using pktgen_bench_xmit_mode_queue_xmit.sh
on my testlab the remote host was pushing back a lot, resulting in only
256Kpps being actually sent on wire. Monitored with ethtool stats script[2].


[2] 
https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_stats.pl

> I suspect there are probably more real world use cases out there.
> Although to test it you would probably have to have a congested network
> to really be able to show much of a benefit.
> 
> With the pktgen I would be interested in seeing the Qdisc dropped
> numbers for with vs without this patch. I would consider something like
> that comparable to us doing an XDP_DROP test since all we are talking
> about is a synthetic benchmark.

The pktgen script output how many packets it have transmitted, but from
above we know that this most of these packets are actually getting
dropped as only 256Kpps are reaching the wire.

Result line from pktgen script: count 100000000 (60byte,0frags)
  - Unpatched kernel: 2396594pps 1150Mb/sec (1150365120bps) errors: 1417469
  - Patched kernel  : 2479970pps 1190Mb/sec (1190385600bps) errors: 1422753

Difference:
  * +83376 pps faster (2479970-2396594)
  * -14 nanosec faster (1/2479970-1/2396594)*10^9

The patched kernel is faster. Around the expected gain from using the
kmem_cache bulking API (slightly more actually).

More raw data and notes for this email avail in [3]:

  [3] 
https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org


>>
>>>> kfree_skb_list_bulk() ?
>>>
>>> Hmm, IMHO not really worth changing the function name.  The
>>> kfree_skb_list() is called in more places, (than qdisc enqueue-overflow
>>> case), which automatically benefits if we keep the function name
>>> kfree_skb_list().
>>
>> To be clear - I was suggesting a simple
>>    s/kfree_skb_defer_local/kfree_skb_list_bulk/
>> on the patch, just renaming the static helper.
>>

Okay, I get it now. But I disagree with same argument as Alex makes below.

>> IMO now that we have multiple freeing optimizations using "defer" for
>> the TCP scheme and "bulk" for your prior slab bulk optimizations would
>> improve clarity.
> 
> Rather than defer_local would it maybe make more sense to look at
> naming it something like "kfree_skb_add_bulk"? Basically we are
> building onto the list of buffers to free so I figure something like an
> "add" or "append" would make sense.
> 

I agree with Alex, that we are building up buffers to be freed *later*,
thus we should somehow reflect that in the naming.

--Jesper

