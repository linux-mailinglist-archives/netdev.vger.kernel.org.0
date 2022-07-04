Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55DA565CA3
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiGDRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 13:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiGDROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 13:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 811B4E0BE
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 10:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656954855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=90xhSQDtM76aihPHt68+M5RcBuaIA4lDfnCcukO+uC4=;
        b=P88ciLVk9JIVRA4R+rLAAilS2rSjpffQOscgxdVDfyjaj0gEKmCz9k2XehPz2cAWpJ4NkD
        IOmIPbMmAl7I9ay73zXuf3YalPnnlXMFzPzQEJcM/ITqGpG003crfDV+d5EX0Gke6nRd4+
        Oa3FyoTwuZVh1ZW8/wusvao9HtMpNAw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-pqyBYaPBMUmFzbG3sNDWcQ-1; Mon, 04 Jul 2022 13:14:07 -0400
X-MC-Unique: pqyBYaPBMUmFzbG3sNDWcQ-1
Received: by mail-ed1-f72.google.com with SMTP id w5-20020a056402268500b0043980311a5fso7066920edd.3
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 10:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=90xhSQDtM76aihPHt68+M5RcBuaIA4lDfnCcukO+uC4=;
        b=GmTze7qeER6yfm+w2EBpbzCXiQRBxOyNkr00K7laengpcynIXMWT9AuP/V0xjzY+wO
         MlVaXwpIaKOMEQQJpUA7uwi8sA/i9Yf1hm22iRKn7zL8Mm2zYwsSZLviNGku467OgFGV
         GfdY2JLiO5twwLs1Hox6UbL+WNTUP/c5F86ZudVzDhc+er6zCz8yiI3E/B+LAjM92724
         ZeOqRzGbfuNzONOgdnFQCpbj9eQ88KIJHFFGkUa9i0polFG/RazI8X6bR9hY9lhqQFgt
         WtX6FnRC+8x9Ag+eeFa65QlQ39QkmDJyfVphQNykPS5nyEo/M6egUoh+BmZGJ4FQKDa0
         wFJw==
X-Gm-Message-State: AJIora9mOAQtOvjdC9F5gBLAczzYlOtgKEBzzcgfPVmFZ8h2woNRMcmQ
        OVeL1+KsJqM9cCn/ecQWtRpXLrFjJTPG90HHAB9838QpnnmqHPI3Elzfu4JsJMobTt719fn3ric
        1VjgYLWNPZmMrcXEG
X-Received: by 2002:a17:906:8479:b0:72a:5610:f151 with SMTP id hx25-20020a170906847900b0072a5610f151mr24224552ejc.125.1656954845686;
        Mon, 04 Jul 2022 10:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uef8hLBR0Q8A/DXYG20gzUAR43ekM2eDQ/JQ9p555cPa3vQ0ljoKeKV71ISz2WBRNK3kOVWw==
X-Received: by 2002:a17:906:8479:b0:72a:5610:f151 with SMTP id hx25-20020a170906847900b0072a5610f151mr24224508ejc.125.1656954845270;
        Mon, 04 Jul 2022 10:14:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id by27-20020a0564021b1b00b004356112a8a2sm21023202edb.15.2022.07.04.10.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 10:14:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 14DE2477A3F; Mon,  4 Jul 2022 19:14:04 +0200 (CEST)
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
In-Reply-To: <20220704154440.7567-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 04 Jul 2022 19:14:04 +0200
Message-ID: <87a69o94wz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Toke H??iland-J??rgensen <toke@redhat.com>
> Date: Wed, 29 Jun 2022 15:43:05 +0200
>
>> John Fastabend <john.fastabend@gmail.com> writes:
>> 
>> > Alexander Lobakin wrote:
>> >> This RFC is to give the whole picture. It will most likely be split
>> >> onto several series, maybe even merge cycles. See the "table of
>> >> contents" below.
>> >
>> > Even for RFC its a bit much. Probably improve the summary
>> > message here as well I'm still not clear on the overall
>> > architecture so not sure I want to dig into patches.
>> 
>> +1 on this, and piggybacking on your comment to chime in on the general
>> architecture.
>> 
>> >> Now, a NIC driver, or even a SmartNIC itself, can put those params
>> >> there in a well-defined format. The format is fixed, but can be of
>> >> several different types represented by structures, which definitions
>> >> are available to the kernel, BPF programs and the userland.
>> >
>> > I don't think in general the format needs to be fixed.
>> 
>> No, that's the whole point of BTF: it's not supposed to be UAPI, we'll
>> use CO-RE to enable dynamic formats...
>> 
>> [...]
>> 
>> >> It is fixed due to it being almost a UAPI, and the exact format can
>> >> be determined by reading the last 10 bytes of metadata. They contain
>> >> a 2-byte magic ID to not confuse it with a non-compatible meta and
>> >> a 8-byte combined BTF ID + type ID: the ID of the BTF where this
>> >> structure is defined and the ID of that definition inside that BTF.
>> >> Users can obtain BTF IDs by structure types using helpers available
>> >> in the kernel, BPF (written by the CO-RE/verifier) and the userland
>> >> (libbpf -> kernel call) and then rely on those ID when reading data
>> >> to make sure whether they support it and what to do with it.
>> >> Why separate magic and ID? The idea is to make different formats
>> >> always contain the basic/"generic" structure embedded at the end.
>> >> This way we can still benefit in purely generic consumers (like
>> >> cpumap) while providing some "extra" data to those who support it.
>> >
>> > I don't follow this. If you have a struct in your driver name it
>> > something obvious, ice_xdp_metadata. If I understand things
>> > correctly just dump the BTF for the driver, extract the
>> > struct and done you can use CO-RE reads. For the 'fixed' case
>> > this looks easy. And I don't think you even need a patch for this.
>> 
>> ...however as we've discussed previously, we do need a bit of
>> infrastructure around this. In particular, we need to embed the embed
>> the BTF ID into the metadata itself so BPF can do runtime disambiguation
>> between different formats (and add the right CO-RE primitives to make
>> this easy). This is for two reasons:
>> 
>> - The metadata might be different per-packet (e.g., PTP packets with
>>   timestamps interleaved with bulk data without them)
>> 
>> - With redirects we may end up processing packets from different devices
>>   in a single XDP program (in devmap or cpumap, or on a veth) so we need
>>   to be able to disambiguate at runtime.
>> 
>> So I think the part of the design that puts the BTF ID into the end of
>> the metadata struct is sound; however, the actual format doesn't have to
>> be fixed, we can use CO-RE to pick out the bits that a given BPF program
>> needs; we just need a convention for how drivers report which format(s)
>> they support. Which we should also agree on (and add core infrastructure
>> around) so each driver doesn't go around inventing their own
>> conventions.
>> 
>> >> The enablement of this feature is controlled on attaching/replacing
>> >> XDP program on an interface with two new parameters: that combined
>> >> BTF+type ID and metadata threshold.
>> >> The threshold specifies the minimum frame size which a driver (or
>> >> NIC) should start composing metadata from. It is introduced instead
>> >> of just false/true flag due to that often it's not worth it to spend
>> >> cycles to fetch all that data for such small frames: let's say, it
>> >> can be even faster to just calculate checksums for them on CPU
>> >> rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
>> >> 15 Mpps on 64 byte frames with enabled metadata, threshold can help
>> >> mitigate that.
>> >
>> > I would put this in the bonus category. Can you do the simple thing
>> > above without these extra bits and then add them later. Just
>> > pick some overly conservative threshold to start with.
>> 
>> Yeah, I'd agree this kind of configuration is something that can be
>> added later, and also it's sort of orthogonal to the consumption of the
>> metadata itself.
>> 
>> Also, tying this configuration into the loading of an XDP program is a
>> terrible interface: these are hardware configuration options, let's just
>> put them into ethtool or 'ip link' like any other piece of device
>> configuration.
>
> I don't believe it fits there, especially Ethtool. Ethtool is for
> hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
> offload bits which is purely NFP's for now).

But XDP-hints is about consuming hardware features. When you're
configuring which metadata items you want, you're saying "please provide
me with these (hardware) features". So ethtool is an excellent place to
do that :)

> I follow that way:
>
> 1) you pick a program you want to attach;
> 2) usually they are written for special needs and usecases;
> 3) so most likely that program will be tied with metadata/driver/etc
>    in some way;
> 4) so you want to enable Hints of a particular format primarily for
>    this program and usecase, same with threshold and everything
>    else.
>
> Pls explain how you see it, I might be wrong for sure.

As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
access to metadata that is not currently available. Tying the lifetime
of that hardware configuration (i.e., which information to provide) to
the lifetime of an XDP program is not a good interface: for one thing,
how will it handle multiple programs? What about when XDP is not used at
all but you still want to configure the same features?

In addition, in every other case where we do dynamic data access (with
CO-RE) the BPF program is a consumer that modifies itself to access the
data provided by the kernel. I get that this is harder to achieve for
AF_XDP, but then let's solve that instead of making a totally
inconsistent interface for XDP.

I'm as excited as you about the prospect of having totally programmable
hardware where you can just specify any arbitrary metadata format and
it'll provide that for you. But that is an orthogonal feature: let's
start with creating a dynamic interface for consuming the (static)
hardware features we already have, and then later we can have a separate
interface for configuring more dynamic hardware features. XDP-hints is
about adding this consumption feature in a way that's sufficiently
dynamic that we can do the other (programmable hardware) thing on top
later...

-Toke

