Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBFF56A12E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiGGLl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiGGLlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:41:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EEDD4F65D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657194112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hp9kplYxVeJvkCLXKH0+FwQt5V99ulIS4aLbfHs6BEI=;
        b=bJvugkng8m0VfJmz7rsUCPiy9aTZwbonyA1qtv1anzwvl1lhVzqg8357mHcvCbVnLLHl9/
        JRmRu7WQWPBvr9aAueFmZDdBiIKp2o32NDG5p8lOBcTUxJlMTOjlQOM8qkQ7ytL9SJFVBw
        /QPI9vZ1P+kJb+/F+LzdU9i0xITreYc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-5NCd8o6VPpuY_lMgwyQqQg-1; Thu, 07 Jul 2022 07:41:51 -0400
X-MC-Unique: 5NCd8o6VPpuY_lMgwyQqQg-1
Received: by mail-lf1-f69.google.com with SMTP id cf10-20020a056512280a00b0047f5a295656so6272300lfb.15
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 04:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=Hp9kplYxVeJvkCLXKH0+FwQt5V99ulIS4aLbfHs6BEI=;
        b=Q9nsSNKCbt2XYg9nMerLd0Zo+k8ET4Fb1KvNv6JFhqIjpUs9roZTQ90U7U/i7BTg/0
         0SPz9J22lE0rJ8GZaw24kVedTkxVBzscK92tHf39Te0EB9kdf7djoesBmQqA1aEx/TkJ
         mxzijRxeq/lsqDxwgGl3kPheUzAdJHW2DMnu3p/pkGmXRB0/x3YwpJO/lDpzEOIR623C
         3jX5DQVNhgpSkjisBMSIOQWCCd5RkaCQs+D97Fd6cl9knmqwP5iUKXranVbHcpCSsWP5
         Ve/GIakiscFDW2dModKnIPVJHyzBvHuRsrF7iazJqAl1lb6WFk5Px3aa/Yxq1sOmwAoA
         By2Q==
X-Gm-Message-State: AJIora+Ap1W2roKHi1yLS06t0ApcV51mQcH5lIZoVtBr12lsF/AvUJex
        ZdoOmkQJGs/9RXDw47X9Cdh4JWHqWOnr0Ef0wxvxY2M0sIICU6PfSCLNVQUP4XXwjU83nLD/R8P
        QUpsKZYVpgHvCIO0k
X-Received: by 2002:a05:6512:2815:b0:47f:634b:8e8c with SMTP id cf21-20020a056512281500b0047f634b8e8cmr30273568lfb.213.1657194109714;
        Thu, 07 Jul 2022 04:41:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tJvp1yW45Ik/b6uKDWK3rNW6z1PBOcgEu1Fiv4mR++0nJOx9+MEbwWB4l6FhGZ5EGZCX6dxg==
X-Received: by 2002:a05:6512:2815:b0:47f:634b:8e8c with SMTP id cf21-20020a056512281500b0047f634b8e8cmr30273536lfb.213.1657194109352;
        Thu, 07 Jul 2022 04:41:49 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512050400b004785b66a9a4sm3100587lfb.126.2022.07.07.04.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 04:41:48 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <29c66391-e229-0692-7072-72bd56aa8da3@redhat.com>
Date:   Thu, 7 Jul 2022 13:41:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com> <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com> <87pmij75r1.fsf@toke.dk>
 <20220706135023.1464979-1-alexandr.lobakin@intel.com>
 <87edyxaks0.fsf@toke.dk>
In-Reply-To: <87edyxaks0.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/07/2022 01.22, Toke Høiland-Jørgensen wrote:
> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> From: Toke H??iland-J??rgensen <toke@redhat.com>
>> Date: Tue, 05 Jul 2022 20:51:14 +0200
>>
>>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>>
>>> [... snipping a bit of context here ...]
>>>
>>>>>>> Yeah, I'd agree this kind of configuration is something that can be
>>>>>>> added later, and also it's sort of orthogonal to the consumption of the
>>>>>>> metadata itself.
>>>>>>>
>>>>>>> Also, tying this configuration into the loading of an XDP program is a
>>>>>>> terrible interface: these are hardware configuration options, let's just
>>>>>>> put them into ethtool or 'ip link' like any other piece of device
>>>>>>> configuration.
>>>>>>
>>>>>> I don't believe it fits there, especially Ethtool. Ethtool is for
>>>>>> hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
>>>>>> offload bits which is purely NFP's for now).
>>>>>
>>>>> But XDP-hints is about consuming hardware features. When you're
>>>>> configuring which metadata items you want, you're saying "please provide
>>>>> me with these (hardware) features". So ethtool is an excellent place to
>>>>> do that :)
>>>>
>>>> With Ethtool you configure the hardware, e.g. it won't strip VLAN
>>>> tags if you disable rx-cvlan-stripping. With configuring metadata
>>>> you only tell what you want to see there, don't you?
>>>
>>> Ah, I think we may be getting closer to identifying the disconnect
>>> between our way of thinking about this!
>>>
>>> In my mind, there's no separate "configuration of the metadata" step.
>>> You simply tell the hardware what features you want (say, "enable
>>> timestamps and VLAN offload"), and the driver will then provide the
>>> information related to these features in the metadata area
>>> unconditionally. All XDP hints is about, then, is a way for the driver
>>> to inform the rest of the system how that information is actually laid
>>> out in the metadata area.
>>>
>>> Having a separate configuration knob to tell the driver "please lay out
>>> these particular bits of metadata this way" seems like a totally
>>> unnecessary (and quite complicated) feature to have when we can just let
>>> the driver decide and use CO-RE to consume it?
>>
>> Magnus (he's currently on vacation) told me it would be useful for
>> AF_XDP to enable/disable particular metadata, at least from perf
>> perspective. 

I have recently talked to Magnus (in person at Kernel Recipes), where I
tried to convey my opinion, which is:  At least for existing hardware
hints, we need to respect the existing Linux kernel's config interfaces,
and not invent yet-another-way to configure these.
(At least for now) the kernel module defined structs in C-code is the 
source of truth, and we consume these layouts via BTF information 
provided by the kernel for our XDP-hints.


>> Let's say, just fetching of one "checksum ok" bit in
>> the driver is faster than walking through all the descriptor words
>> and driver logics (i.e. there's several hundred locs in ice which
>> just parse descriptor data and build an skb or metadata from it).
>> But if we would just enable/disable corresponding features through
>> Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
>> what if I want to have only RSS hash in the metadata (and don't
>> want to spend cycles on parsing the rest), but at the same time
>> still want skb path to have checksum status to not die at CPU
>> checksum calculation?
> 
> Hmm, so this feels a little like a driver-specific optimisation? I.e.,
> my guess is that not all drivers have a measurable overhead for pulling
> out the metadata. Also, once the XDP metadata bits are in place, we can
> move in the direction of building SKBs from the same source, so I'm not
> sure it's a good idea to assume that the XDP metadata is separate from
> what the stack consumes...

I agree.

> In any case, if such an optimisation does turn out to be useful, we can
> add it later (backed by rigorous benchmarks, of course), so I think we
> can still start with the simple case and iterate from there?

For every element in the generic hints data-structure, we already have a
per-element enable/disable facilities.  As they are already controlled
by ethtool.  Except the timestamping, which can be enabled via a sockopt.
I don't see a benefit of creating another layer (of if-statements) that
are also required to get the HW hint written to XDP-hints metadata area.



>>>>>> I follow that way:
>>>>>>
>>>>>> 1) you pick a program you want to attach;
>>>>>> 2) usually they are written for special needs and usecases;
>>>>>> 3) so most likely that program will be tied with metadata/driver/etc
>>>>>>     in some way;
>>>>>> 4) so you want to enable Hints of a particular format primarily for
>>>>>>     this program and usecase, same with threshold and everything
>>>>>>     else.
>>>>>>
>>>>>> Pls explain how you see it, I might be wrong for sure.
>>>>>
>>>>> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
>>>>> access to metadata that is not currently available. Tying the lifetime
>>>>> of that hardware configuration (i.e., which information to provide) to
>>>>> the lifetime of an XDP program is not a good interface: for one thing,
>>>>> how will it handle multiple programs? What about when XDP is not used at
>>>>
>>>> Multiple progs is stuff I didn't cover, but will do later (as you
>>>> all say to me, "let's start with something simple" :)). Aaaand
>>>> multiple XDP progs (I'm not talking about attaching progs in
>>>> differeng modes) is not a kernel feature, rather a libpf feature,
>>>> so I believe it should be handled there later...
>>>
>>> Right, but even if we don't *implement* it straight away we still need
>>> to take it into consideration in the design. And expecting libxdp to
>>> arbitrate between different XDP programs' metadata formats sounds like a
>>> royal PITA :)
>>>
>>>>> all but you still want to configure the same features?
>>>>
>>>> What's the point of configuring metadata when there are no progs
>>>> attached? To configure it once and not on every prog attach? I'm
>>>> not saying I don't like it, just want to clarify.
>>>
>>> See above: you turn on the features because you want the stack to
>>> consume them.
>>>
>>>> Maybe I need opinions from some more people, just to have an
>>>> overview of how most of folks see it and would like to configure
>>>> it. 'Cause I heard from at least one of the consumers that
>>>> libpf API is a perfect place for Hints to him :)
>>>
>>> Well, as a program author who wants to consume hints, you'd use
>>> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
>>> macros)...
>>>
>>>>> In addition, in every other case where we do dynamic data access (with
>>>>> CO-RE) the BPF program is a consumer that modifies itself to access the
>>>>> data provided by the kernel. I get that this is harder to achieve for
>>>>> AF_XDP, but then let's solve that instead of making a totally
>>>>> inconsistent interface for XDP.
>>>>
>>>> I also see CO-RE more fitting and convenient way to use them, but
>>>> didn't manage to solve two things:
>>>>
>>>> 1) AF_XDP programs, so what to do with them? Prepare patches for
>>>>     LLVM to make it able to do CO-RE on AF_XDP program load? Or
>>>>     just hardcode them for particular usecases and NICs? What about
>>>>     "general-purpose" programs?
>>>
>>> You provide a library to read the fields. Jesper actually already
>>> implemented this, did you look at his code?
>>>
>>> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction
>>>
>>> It basically builds a lookup table at load-time using BTF information
>>> from the kernel, keyed on BTF ID and field name, resolving them into
>>> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
>>> close and can be improved upon (CO-RE for userspace being one way of
>>> doing that).
>>
>> Aaaah, sorry, I completely missed that. I thought of something
>> similar as well, but then thought "variable field offsets, that
>> would annihilate optimization and performance", and our Xsk team
>> is super concerned about performance hits when using Hints.
>>
>>>
>>>>     And if hardcode, what's the point then to do Generic Hints at
>>>>     all? Then all it needs is making driver building some meta in
>>>>     front of frames via on-off button and that's it? Why BTF ID in
>>>>     the meta then if consumers will access meta hardcoded (via CO-RE
>>>>     or literally hardcoded, doesn't matter)?
>>>
>>> You're quite right, we could probably implement all the access to
>>> existing (fixed) metadata without using any BTF at all - just define a
>>> common struct and some flags to designate which fields are set. In my
>>> mind, there are a couple of reasons for going the BTF route instead:
>>>
>>> - We can leverage CO-RE to get close to optimal efficiency in field
>>>    access.
>>>
>>> and, more importantly:
>>>
>>> - It's infinitely extensible. With the infrastructure in place to make
>>>    it really easy to consume metadata described by BTF, we lower the bar
>>>    for future innovation in hardware offloads. Both for just adding new
>>>    fixed-function stuff to hardware, but especially for fully
>>>    programmable hardware.
>>
>> Agree :) That libxdp lookup translator fixed lots of stuff in my
>> mind.
> 
> Great! Looks like we're slowly converging towards a shared
> understanding, then! :)
> 
>>>> 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
>>>>     generic metadata structure they won't be able to benefit from
>>>>     Hints. But I guess we still need to provide kernel with meta?
>>>>     Or no?
>>>
>>> In the short term, I think the "generic structure" approach is fine for
>>> leveraging this in the stack. Both your and Jesper's series include
>>> this, and I think that's totally fine. Longer term, if it turns out to
>>> be useful to have something more dynamic for the stack consumption as
>>> well, we could extend it to be CO-RE based as well (most likely by
>>> having the stack load a "translator" BPF program or something along
>>> those lines).
>>
>> Oh, that translator prog sounds nice BTW!
> 
> Yeah, it's only a rough idea Jesper and I discussed at some point, but I
> think it could have potential (see also point above re: making XDP hints
> *the* source of metadata for the whole stack; wouldn't it be nice if
> drivers didn't have to deal with the intricacies of assembling SKBs?).

Yes, this is the longer term goal, but we should take this in steps.
(Thus, my patchset[0] focuses on the existing xdp_hints_common).

Eventually (pipe-dream?), I would like to add a new BPF-hook that runs
in the step converting xdp_frame to SKB (today handled in function
__xdp_build_skb_from_frame).  This "translator" BPF program should be
tied/loaded per net_device, which makes it easier to consume the driver
specific/dynamic XDP-hints layouts and BPF-code can be smaller as it
only need to CO-RE handle xdp-hints structs known for this driver.
Default BPF-prog should be provided and maintained by driver
maintainers, but can be replaced by end-users.

--Jesper

[0] 
https://lore.kernel.org/bpf/165643378969.449467.13237011812569188299.stgit@firesoul/

