Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5D26258D5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiKKKwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiKKKwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:52:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B53763CCA
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668163891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2N0VO0ih909s+BIPjYFCLdILlUqF3XyAUoXIWL53+Q=;
        b=N5rX5Z+kJbkieiHd+2CIwfHfC/1KPaZN9Xd412HbfAmtKDqyjo2WSyGUDoE8v1ixiDb0gy
        Yr7GLA1u2QJOqxyu4JvVu2ntLHeV//7g2wKdw86qlhnod0It8uZVrV2t9d7Z2JIFcCtgmG
        O8qQ2naQ3s6IfexynMKaNJqovFV6e5k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-217-MxvvKi2dO_2s0V2cVxGW7w-1; Fri, 11 Nov 2022 05:51:30 -0500
X-MC-Unique: MxvvKi2dO_2s0V2cVxGW7w-1
Received: by mail-ej1-f72.google.com with SMTP id sb4-20020a1709076d8400b007ae596eac08so2881892ejc.22
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2N0VO0ih909s+BIPjYFCLdILlUqF3XyAUoXIWL53+Q=;
        b=TtoQAsTqo1ym7DVmbBIKaHd867rChTdQSb0X3FmhKJC1wW9lSAE43stDHiB83YruOU
         RwZexYK+IzpG/H13YKim7Ogy9tRVmPXGoJaZn592PjmKPpgCJqORmFxfyOREjGWIZql6
         UU5TPO6T707dgC5aLE1DjrQRfrNtiwK3qYfMl49q/S0k+B/fX/xMov85h/auamtBHJuG
         GWH+40f3pon+DKFPwWN1ouDxwGARYg2GU9GQIyN0f9O858O0W9kTkB4YRZlMNDl3xVD1
         uYw0PxtBlxjawHD45lk5xo/STx1q6nfXxssEKnS1uuzr2dV5Cl986B5RR7y7dt6ObE1V
         k6og==
X-Gm-Message-State: ANoB5pmvHJiKYIHzxf5sSkumZjJto5stB7KSmELW7x6r95R1exlHt0bM
        oLyippcVecm1C37hzrrQJwf5fX7I7MmTA5WLXJg3asleYPS3KyIjDQu9Djj9RzljeMHVgc2w7ox
        vcKMicIwHOHgS86Vs
X-Received: by 2002:a17:906:9f04:b0:7ae:ed2:5367 with SMTP id fy4-20020a1709069f0400b007ae0ed25367mr1387142ejc.521.1668163888829;
        Fri, 11 Nov 2022 02:51:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IADW34krNA0DjDIEHn/Hx0oYGFPxI8saeezjqfs17IEegMVuPVI4UcGGac/3k9cyuBc5kYQ==
X-Received: by 2002:a17:906:9f04:b0:7ae:ed2:5367 with SMTP id fy4-20020a1709069f0400b007ae0ed25367mr1387117ejc.521.1668163888551;
        Fri, 11 Nov 2022 02:51:28 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090653cc00b007adf125cde3sm786580ejo.12.2022.11.11.02.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 02:51:27 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <64461cc5-c9b5-1a0e-dc9d-ddb49fc7a5b2@redhat.com>
Date:   Fri, 11 Nov 2022 11:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        sdf@google.com
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Yonghong Song <yhs@meta.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch> <87cz9vyo40.fsf@toke.dk>
 <636d2e8c5a010_145693208c8@john.notmuch>
In-Reply-To: <636d2e8c5a010_145693208c8@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/11/2022 18.02, John Fastabend wrote:
> Toke Høiland-Jørgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>>
>>> Yonghong Song wrote:
>>>>
>>>>
>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>>> to capture statistics and information about running net devices. We use
>>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>>> information about the interface not exposed through the xdp_md structures.
>>>>> This has some down sides that we want to avoid by moving these into the
>>>>> XDP hook itself. First, placing the kprobes in a generic function in
>>>>> the kernel is after XDP so we miss redirects and such done by the
>>>>> XDP networking program. And its needless overhead because we are
>>>>> already paying the cost for calling the XDP program, calling yet
>>>>> another prog is a waste. Better to do everything in one hook from
>>>>> performance side.
>>>>>
>>>>> Of course we could one-off each one of these fields, but that would
>>>>> explode the xdp_md struct and then require writing convert_ctx_access
>>>>> writers for each field. By using BTF we avoid writing field specific
>>>>> convertion logic, BTF just knows how to read the fields, we don't
>>>>> have to add many fields to xdp_md, and I don't have to get every
>>>>> field we will use in the future correct.
>>>>>
>>>>> For reference current examples in our code base use the ifindex,
>>>>> ifname, qdisc stats, net_ns fields, among others. With this
>>>>> patch we can now do the following,
>>>>>
>>>>>           dev = ctx->rx_dev;
>>>>>           net = dev->nd_net.net;
>>>>>
>>>>> 	uid.ifindex = dev->ifindex;
>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>>>           if (net)
>>>>> 		uid.inum = net->ns.inum;
>>>>>
>>>>> to report the name, index and ns.inum which identifies an
>>>>> interface in our system.
>>>>
>>>> In
>>>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>>>> Namhyung Kim wanted to access new perf data with a helper.
>>>> I proposed a helper bpf_get_kern_ctx() which will get
>>>> the kernel ctx struct from which the actual perf data
>>>> can be retrieved. The interface looks like
>>>> 	void *bpf_get_kern_ctx(void *)
>>>> the input parameter needs to be a PTR_TO_CTX and
>>>> the verifer is able to return the corresponding kernel
>>>> ctx struct based on program type.
>>>>
>>>> The following is really hacked demonstration with
>>>> some of change coming from my bpf_rcu_read_lock()
>>>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>>>>
>>>> I modified your test to utilize the
>>>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>>>>
>>>> With this single helper, we can cover the above perf
>>>> data use case and your use case and maybe others
>>>> to avoid new UAPI changes.
>>>
>>> hmm I like the idea of just accessing the xdp_buff directly
>>> instead of adding more fields. I'm less convinced of the
>>> kfunc approach. What about a terminating field *self in the
>>> xdp_md. Then we can use existing convert_ctx_access to make
>>> it BPF inlined and no verifier changes needed.
>>>
>>> Something like this quickly typed up and not compiled, but
>>> I think shows what I'm thinking.
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 94659f6b3395..10ebd90d6677 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -6123,6 +6123,10 @@ struct xdp_md {
>>>          __u32 rx_queue_index;  /* rxq->queue_index  */
>>>   
>>>          __u32 egress_ifindex;  /* txq->dev->ifindex */
>>> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
>>> +        * BTF access. Reading this gives BTF access to xdp_buff.
>>> +        */
>>> +       __bpf_md_ptr(struct xdp_buff *, self);
>>>   };
>>
>> xdp_md is UAPI; I really don't think it's a good idea to add "unstable"
>> BTF fields like this to it, that's just going to confuse people. Tying
>> this to a kfunc for conversion is more consistent with the whole "kfunc
>> and BTF are its own thing" expectation.
> 
> hmm from my side self here would be stable. Whats behind it is not,
> but that seems fine to me.  Doing `ctx->self` feels more natural imo
> then doing a call. A bunch more work but could do btf casts maybe
> with annotations. I'm not sure its worth it though because only reason
> I can think to do this would be for this self reference from ctx.
> 
>     struct xdp_buff *xdp = __btf (struct xdp_buff *)ctx;
> 
> C++ has 'this' as well but thats confusing from C side. Could have
> a common syntax to do 'ctx->this' to get the pointer in BTF
> format.
> 
> Maybe see what Yonghong thinks.
> 
>>
>> The kfunc doesn't actually have to execute any instructions either, it
>> can just be collapsed into a type conversion to BTF inside the verifier,
>> no?
> 
> Agree either implementation can be made that same underneath its just
> a style question. I can probably do either but using the ctx keeps
> the existing machinery to go through is_valid_access and so on.
> 

What kind of access does the BPF-prog obtain with these different
proposals, e.g. read-only access to xdp_buff or also write access?

--Jesper

