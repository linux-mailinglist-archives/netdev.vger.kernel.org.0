Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5365F3FA3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiJDJaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 05:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiJDJ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 05:29:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06E9B32
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664875762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ykp8QrHtYsQs2S4pDXqZoKDJOJ31ef1hCy5o4M7urP8=;
        b=Mnwmf9wAB6XlL+y8ba3ztVFzOxnaGohWZU1rpP/1VQFqOpOYtU0F621p0z783ImK7KAf1x
        cn9CmNVuVwqNlvCvtmguUmpAs8NtD1YqpAwQbQVxrhIoXWCCkxWirrp/+pmojySCwGCZ6S
        l+Nq/jGU0TG2WR0gp9O2uRR2uNZ1J84=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-34-cQP2kQQXNcCXR6mMvxsp4g-1; Tue, 04 Oct 2022 05:29:21 -0400
X-MC-Unique: cQP2kQQXNcCXR6mMvxsp4g-1
Received: by mail-ej1-f71.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso4487876ejb.5
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 02:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ykp8QrHtYsQs2S4pDXqZoKDJOJ31ef1hCy5o4M7urP8=;
        b=cQe3cErVrfI6ETk+CcyaedeHqqJPI3HojglS07GAuO0Y0FPIl5SBB0PuZ/AEpuuf85
         iwcd8E06aW8Wa9ZdeZUfSGMwN5BQip80K+38n1hKDklRBR0mV1LDDXO+pjGM7wP90vbr
         7n6M+O02KLXvNkF39FvIeqY3vu0qUV/6xdANmFyfsOS5fscUJkWh37gBGC6kLatlKXo2
         y91VbU6w7f4JLQ6nZYZjgIth5UJERf16zJnQuN/jzVFE6fGtj4285VBlyax+NuglDlhT
         Pkb7JU03UoJKyzC0J0rvBQVTf2ocVn4YBaaZl2wYMH3ei+Q6/VWRvGfUrrWnihISO/LY
         0ZEw==
X-Gm-Message-State: ACrzQf1tR8hNKsTo54fvv3FkHnTzgoazjYT4w2Rez/Qh9Xe7P45C1sBY
        SmanGRO6JQphhd6zdBTfr+t131tebw/3uA+++l17JK9rr6FTPRE3MzmBdBcdOF74Qj4xH4Iu228
        FATzFUt09tq5L6zxp
X-Received: by 2002:a17:907:94c6:b0:787:9157:a87a with SMTP id dn6-20020a17090794c600b007879157a87amr18836612ejc.5.1664875760571;
        Tue, 04 Oct 2022 02:29:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6cThDfxYHG1OMCjFWh4ItxMOvFuQgMEeYE0kVhTCrd7yVLHYXv9BY5w4ToxgN2BkWsaSrLtA==
X-Received: by 2002:a17:907:94c6:b0:787:9157:a87a with SMTP id dn6-20020a17090794c600b007879157a87amr18836585ejc.5.1664875760199;
        Tue, 04 Oct 2022 02:29:20 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id n16-20020a05640205d000b00454546561cfsm1261361edx.82.2022.10.04.02.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 02:29:19 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
Date:   Tue, 4 Oct 2022 11:29:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
To:     sdf@google.com
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
Content-Language: en-US
In-Reply-To: <Yzt2YhbCBe8fYHWQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/10/2022 01.55, sdf@google.com wrote:
> On 09/07, Jesper Dangaard Brouer wrote:
>> This patchset expose the traditional hardware offload hints to XDP and
>> rely on BTF to expose the layout to users.
> 
>> Main idea is that the kernel and NIC drivers simply defines the struct
>> layouts they choose to use for XDP-hints. These XDP-hints structs gets
>> naturally and automatically described via BTF and implicitly exported to
>> users. NIC drivers populate and records their own BTF ID as the last
>> member in XDP metadata area (making it easily accessible by AF_XDP
>> userspace at a known negative offset from packet data start).
> 
>> Naming conventions for the structs (xdp_hints_*) is used such that
>> userspace can find and decode the BTF layout and match against the
>> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
>> what XDP-hints a driver supports.
> 
>> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
>> union named "xdp_hints_union" in every driver, which contains all
>> xdp_hints_* struct this driver can support. This makes it easier/quicker
>> to find and parse the relevant BTF types.  (Seeking input before fixing
>> up all drivers in patchset).
> 
> 
>> The main different from RFC-v1:
>>   - Drop idea of BTF "origin" (vmlinux, module or local)
>>   - Instead to use full 64-bit BTF ID that combine object+type ID
> 
>> I've taken some of Alexandr/Larysa's libbpf patches and integrated
>> those.
> 
>> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
>> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
>> required some refactoring to remove the SKB dependencies.
> 
> Hey Jesper,
> 
> I took a quick look at the series. 
Appreciate that! :-)

> Do we really need the enum with the flags?

The primary reason for using enum is that these gets exposed as BTF.
The proposal is that userspace/BTF need to obtain the flags via BTF,
such that they don't become UAPI, but something we can change later.

> We might eventually hit that "first 16 bits are reserved" issue?
> 
> Instead of exposing enum with the flags, why not solve it as follows:
> a. We define UAPI struct xdp_rx_hints with _all_ possible hints

How can we know _all_ possible hints from the beginning(?).

UAPI + central struct dictating all possible hints, will limit innovation.

> b. Each device defines much denser <device>_xdp_rx_hints struct with the
>     metadata that it supports

Thus, the NIC device is limited to what is defined in UAPI struct
xdp_rx_hints.  Again this limits innovation.

> c. The subset of fields in <device>_xdp_rx_hints should match the ones from
>     xdp_rx_hints (we essentially standardize on the field names/sizes)
> d. We expose <device>_xdp_rx_hints btf id via netlink for each device

For this proposed design you would still need more than one BTF ID or
<device>_xdp_rx_hints struct's, because not all packets contains all
hints. The most common case is HW timestamping, which some HW only
supports for PTP frames.

Plus, I don't see a need to expose anything via netlink, as we can just
use the existing BTF information from the module.  Thus, avoiding to
creating more UAPI.

> e. libbpf will query and do offset relocations for
>     xdp_rx_hints -> <device>_xdp_rx_hints at load time
> 
> Would that work? Then it seems like we can replace bitfields with the 

I used to be a fan of bitfields, until I discovered that they are bad
for performance, because compilers cannot optimize these.

> following:
> 
>    if (bpf_core_field_exists(struct xdp_rx_hints, vlan_tci)) {
>      /* use that hint */

Fairly often a VLAN will not be set in packets, so we still have to read
and check a bitfield/flag if the VLAN value is valid. (Guess it is
implicit in above code).

>    }
> 
> All we need here is for libbpf to, again, do xdp_rx_hints ->
> <device>_xdp_rx_hints translation before it evaluates 
> bpf_core_field_exists()?
> 
> Thoughts? Any downsides? Am I missing something?
> 

Well, the downside is primarily that this design limits innovation.

Each time a NIC driver want to introduce a new hardware hint, they have
to update the central UAPI xdp_rx_hints struct first.

The design in the patchset is to open for innovation.  Driver can extend
their own xdp_hints_<driver>_xxx struct(s).  They still have to land
their patches upstream, but avoid mangling a central UAPI struct. As
upstream we review driver changes and should focus on sane struct member
naming(+size) especially if this "sounds" like a hint/feature that more
driver are likely to support.  With help from BTF relocations, a new
driver can support same hint/feature if naming(+size) match (without
necessary the same offset in the struct).

> Also, about the TX side: I feel like the same can be applied there,
> the program works with xdp_tx_hints and libbpf will rewrite to
> <device>_xdp_tx_hints. xdp_tx_hints might have fields like "has_tx_vlan:1";
> those, presumably, can be relocatable by libbpf as well?
> 

Good to think ahead for TX-side, even-though I think we should focus on
landing RX-side first.

I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
common struct xdp_hints_common, without a RX/TX direction indication.
Maybe this is wrong of me, but my thinking was that most of the common
hints can be directly used as TX-side hints.  I'm hoping TX-side
xdp-hints will need to do little-to-non adjustment, before using the
hints as TX "instruction".  I'm hoping that XDP-redirect will just work
and xmit driver can use XDP-hints area.

Please correct me if I'm wrong.
The checksum fields hopefully translates to similar TX offload "actions".
The VLAN offload hint should translate directly to TX-side.

I can easily be convinced we should name it xdp_hints_rx_common from the
start, but then I will propose that xdp_hints_tx_common have the
checksum and VLAN fields+flags at same locations, such that we don't
take any performance hint for moving them to "TX-side" hints, making
XDP-redirect just work.

--Jesper

