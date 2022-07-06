Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230615695C3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiGFXXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiGFXXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:23:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C7152BB1E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657149781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BOwyqfyXCGaZLm/NYG/xDFnwRI3ekzoanClZ8gigevg=;
        b=U7Gq2+l7tbmAt9JbG9/cWdDvgs2OuV14fPJaeU89+L2/3YpJZPXev65TdxHUH5vnq+3l5r
        0rPqc3GI+mqN+RGl2JEA3NfjyemKsIdBJ3o5Zm8ndpv+GFmdnqW4KxMoE+BglhgSD1P2u7
        7RWtyjmlv81TmjIOF/OhgIewFWGZW04=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-ceJ_ECKRPZuJna1BeigK6g-1; Wed, 06 Jul 2022 19:22:59 -0400
X-MC-Unique: ceJ_ECKRPZuJna1BeigK6g-1
Received: by mail-ed1-f69.google.com with SMTP id h16-20020a05640250d000b00435bab1a7b4so12659096edb.10
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 16:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BOwyqfyXCGaZLm/NYG/xDFnwRI3ekzoanClZ8gigevg=;
        b=LF/7fVor13agXRJBU5JJ3ZOGR7ccoGjEbEWKqEQ4jJW39EVSXFS+FqjfeP5IJMqVke
         6HJx9lLnW565StMr4CiMAdGmsa8TfzQzOHTUzHtN5sWQPY+vrpERCkY7TEMcLm4yHWNZ
         qNyf1Vocbl2hiXIoawwgqCSxXS+2zoLyd+IG+ddWlhlGkpD8Iq16QIrC9x3KgMciP6Hv
         Z9S8iNlByMu4tzQMeymCfLUk3lOj2pIPjX00RUm5WzGmQc+9rq57CqVtLodTZmMQhvl6
         MuzrLdhQsOQySCelaZIZ3Z4cm8aMYYsRieGLb2jhhbvXkXzehQBV8CKpbymWsdhVXFaA
         xI/A==
X-Gm-Message-State: AJIora+Bjx05+t3+w7F1Vo7Wrz6CAYOkQi3jQtkkcQUzoca8Yg3Asthu
        k4SLMZwcCHkc6LhcAZmj/rW02ReR2Y+sDJC/NmZtpBW2QLWA2/u+3dc78SISGWEzGrzJOv+RYPe
        WjRxI5zUWBdM9HvRz
X-Received: by 2002:a17:906:5512:b0:726:be2c:a2e5 with SMTP id r18-20020a170906551200b00726be2ca2e5mr41546540ejp.88.1657149777558;
        Wed, 06 Jul 2022 16:22:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uSG4zUzhePcSlYVWM8vT42gwF7wOFTx2QihYXUDSQAzcrxzkkXmexJ9eElcWCYYxoAEc9Ypw==
X-Received: by 2002:a17:906:5512:b0:726:be2c:a2e5 with SMTP id r18-20020a170906551200b00726be2ca2e5mr41546469ejp.88.1657149776719;
        Wed, 06 Jul 2022 16:22:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y21-20020a170906559500b00726dbb16b8dsm12355793ejp.65.2022.07.06.16.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 16:22:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 354274AAF97; Thu,  7 Jul 2022 01:22:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
In-Reply-To: <20220706135023.1464979-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com>
 <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com>
 <87pmij75r1.fsf@toke.dk>
 <20220706135023.1464979-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 07 Jul 2022 01:22:55 +0200
Message-ID: <87edyxaks0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Toke H??iland-J??rgensen <toke@redhat.com>
> Date: Tue, 05 Jul 2022 20:51:14 +0200
>
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>> 
>> [... snipping a bit of context here ...]
>> 
>> >> >> Yeah, I'd agree this kind of configuration is something that can be
>> >> >> added later, and also it's sort of orthogonal to the consumption of the
>> >> >> metadata itself.
>> >> >> 
>> >> >> Also, tying this configuration into the loading of an XDP program is a
>> >> >> terrible interface: these are hardware configuration options, let's just
>> >> >> put them into ethtool or 'ip link' like any other piece of device
>> >> >> configuration.
>> >> >
>> >> > I don't believe it fits there, especially Ethtool. Ethtool is for
>> >> > hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
>> >> > offload bits which is purely NFP's for now).
>> >> 
>> >> But XDP-hints is about consuming hardware features. When you're
>> >> configuring which metadata items you want, you're saying "please provide
>> >> me with these (hardware) features". So ethtool is an excellent place to
>> >> do that :)
>> >
>> > With Ethtool you configure the hardware, e.g. it won't strip VLAN
>> > tags if you disable rx-cvlan-stripping. With configuring metadata
>> > you only tell what you want to see there, don't you?
>> 
>> Ah, I think we may be getting closer to identifying the disconnect
>> between our way of thinking about this!
>> 
>> In my mind, there's no separate "configuration of the metadata" step.
>> You simply tell the hardware what features you want (say, "enable
>> timestamps and VLAN offload"), and the driver will then provide the
>> information related to these features in the metadata area
>> unconditionally. All XDP hints is about, then, is a way for the driver
>> to inform the rest of the system how that information is actually laid
>> out in the metadata area.
>> 
>> Having a separate configuration knob to tell the driver "please lay out
>> these particular bits of metadata this way" seems like a totally
>> unnecessary (and quite complicated) feature to have when we can just let
>> the driver decide and use CO-RE to consume it?
>
> Magnus (he's currently on vacation) told me it would be useful for
> AF_XDP to enable/disable particular metadata, at least from perf
> perspective. Let's say, just fetching of one "checksum ok" bit in
> the driver is faster than walking through all the descriptor words
> and driver logics (i.e. there's several hundred locs in ice which
> just parse descriptor data and build an skb or metadata from it).
> But if we would just enable/disable corresponding features through
> Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
> what if I want to have only RSS hash in the metadata (and don't
> want to spend cycles on parsing the rest), but at the same time
> still want skb path to have checksum status to not die at CPU
> checksum calculation?

Hmm, so this feels a little like a driver-specific optimisation? I.e.,
my guess is that not all drivers have a measurable overhead for pulling
out the metadata. Also, once the XDP metadata bits are in place, we can
move in the direction of building SKBs from the same source, so I'm not
sure it's a good idea to assume that the XDP metadata is separate from
what the stack consumes...

In any case, if such an optimisation does turn out to be useful, we can
add it later (backed by rigorous benchmarks, of course), so I think we
can still start with the simple case and iterate from there?

>> >> > I follow that way:
>> >> >
>> >> > 1) you pick a program you want to attach;
>> >> > 2) usually they are written for special needs and usecases;
>> >> > 3) so most likely that program will be tied with metadata/driver/etc
>> >> >    in some way;
>> >> > 4) so you want to enable Hints of a particular format primarily for
>> >> >    this program and usecase, same with threshold and everything
>> >> >    else.
>> >> >
>> >> > Pls explain how you see it, I might be wrong for sure.
>> >> 
>> >> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
>> >> access to metadata that is not currently available. Tying the lifetime
>> >> of that hardware configuration (i.e., which information to provide) to
>> >> the lifetime of an XDP program is not a good interface: for one thing,
>> >> how will it handle multiple programs? What about when XDP is not used at
>> >
>> > Multiple progs is stuff I didn't cover, but will do later (as you
>> > all say to me, "let's start with something simple" :)). Aaaand
>> > multiple XDP progs (I'm not talking about attaching progs in
>> > differeng modes) is not a kernel feature, rather a libpf feature,
>> > so I believe it should be handled there later...
>> 
>> Right, but even if we don't *implement* it straight away we still need
>> to take it into consideration in the design. And expecting libxdp to
>> arbitrate between different XDP programs' metadata formats sounds like a
>> royal PITA :)
>> 
>> >> all but you still want to configure the same features?
>> >
>> > What's the point of configuring metadata when there are no progs
>> > attached? To configure it once and not on every prog attach? I'm
>> > not saying I don't like it, just want to clarify.
>> 
>> See above: you turn on the features because you want the stack to
>> consume them.
>> 
>> > Maybe I need opinions from some more people, just to have an
>> > overview of how most of folks see it and would like to configure
>> > it. 'Cause I heard from at least one of the consumers that
>> > libpf API is a perfect place for Hints to him :)
>> 
>> Well, as a program author who wants to consume hints, you'd use
>> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
>> macros)...
>> 
>> >> In addition, in every other case where we do dynamic data access (with
>> >> CO-RE) the BPF program is a consumer that modifies itself to access the
>> >> data provided by the kernel. I get that this is harder to achieve for
>> >> AF_XDP, but then let's solve that instead of making a totally
>> >> inconsistent interface for XDP.
>> >
>> > I also see CO-RE more fitting and convenient way to use them, but
>> > didn't manage to solve two things:
>> >
>> > 1) AF_XDP programs, so what to do with them? Prepare patches for
>> >    LLVM to make it able to do CO-RE on AF_XDP program load? Or
>> >    just hardcode them for particular usecases and NICs? What about
>> >    "general-purpose" programs?
>> 
>> You provide a library to read the fields. Jesper actually already
>> implemented this, did you look at his code?
>> 
>> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction
>> 
>> It basically builds a lookup table at load-time using BTF information
>> from the kernel, keyed on BTF ID and field name, resolving them into
>> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
>> close and can be improved upon (CO-RE for userspace being one way of
>> doing that).
>
> Aaaah, sorry, I completely missed that. I thought of something
> similar as well, but then thought "variable field offsets, that
> would annihilate optimization and performance", and our Xsk team
> is super concerned about performance hits when using Hints.
>
>> 
>> >    And if hardcode, what's the point then to do Generic Hints at
>> >    all? Then all it needs is making driver building some meta in
>> >    front of frames via on-off button and that's it? Why BTF ID in
>> >    the meta then if consumers will access meta hardcoded (via CO-RE
>> >    or literally hardcoded, doesn't matter)?
>> 
>> You're quite right, we could probably implement all the access to
>> existing (fixed) metadata without using any BTF at all - just define a
>> common struct and some flags to designate which fields are set. In my
>> mind, there are a couple of reasons for going the BTF route instead:
>> 
>> - We can leverage CO-RE to get close to optimal efficiency in field
>>   access.
>> 
>> and, more importantly:
>> 
>> - It's infinitely extensible. With the infrastructure in place to make
>>   it really easy to consume metadata described by BTF, we lower the bar
>>   for future innovation in hardware offloads. Both for just adding new
>>   fixed-function stuff to hardware, but especially for fully
>>   programmable hardware.
>
> Agree :) That libxdp lookup translator fixed lots of stuff in my
> mind.

Great! Looks like we're slowly converging towards a shared
understanding, then! :)

>> > 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
>> >    generic metadata structure they won't be able to benefit from
>> >    Hints. But I guess we still need to provide kernel with meta?
>> >    Or no?
>> 
>> In the short term, I think the "generic structure" approach is fine for
>> leveraging this in the stack. Both your and Jesper's series include
>> this, and I think that's totally fine. Longer term, if it turns out to
>> be useful to have something more dynamic for the stack consumption as
>> well, we could extend it to be CO-RE based as well (most likely by
>> having the stack load a "translator" BPF program or something along
>> those lines).
>
> Oh, that translator prog sounds nice BTW!

Yeah, it's only a rough idea Jesper and I discussed at some point, but I
think it could have potential (see also point above re: making XDP hints
*the* source of metadata for the whole stack; wouldn't it be nice if
drivers didn't have to deal with the intricacies of assembling SKBs?).

-Toke

