Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F295F4D07
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJEA0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJEA0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:26:08 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F556F546;
        Tue,  4 Oct 2022 17:26:03 -0700 (PDT)
Message-ID: <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664929561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jge27nDU4ZN8lOIGz+MOGrqjdwDTlwU7Uj3/L8jg2XE=;
        b=CtcySsy+Zcrkheljkyl0/cpImXFyPRAz0RQVsYfywMoG3I1isseDSpeLevNmO7KjirU7Zr
        w6wWwnolWYReMNmEQEc58ChWKfcG1Fyf/LpBsUEHH69el30hwoOTebCtrUXkhKEY7HgGv7
        5Txtkz4YuIFB4kAc7NgmgcnAZZq/dCI=
Date:   Tue, 4 Oct 2022 17:25:51 -0700
MIME-Version: 1.0
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 11:26 AM, Stanislav Fomichev wrote:
> On Tue, Oct 4, 2022 at 2:29 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 04/10/2022 01.55, sdf@google.com wrote:
>>> On 09/07, Jesper Dangaard Brouer wrote:
>>>> This patchset expose the traditional hardware offload hints to XDP and
>>>> rely on BTF to expose the layout to users.
>>>
>>>> Main idea is that the kernel and NIC drivers simply defines the struct
>>>> layouts they choose to use for XDP-hints. These XDP-hints structs gets
>>>> naturally and automatically described via BTF and implicitly exported to
>>>> users. NIC drivers populate and records their own BTF ID as the last
>>>> member in XDP metadata area (making it easily accessible by AF_XDP
>>>> userspace at a known negative offset from packet data start).
>>>
>>>> Naming conventions for the structs (xdp_hints_*) is used such that
>>>> userspace can find and decode the BTF layout and match against the
>>>> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
>>>> what XDP-hints a driver supports.
>>>
>>>> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
>>>> union named "xdp_hints_union" in every driver, which contains all
>>>> xdp_hints_* struct this driver can support. This makes it easier/quicker
>>>> to find and parse the relevant BTF types.  (Seeking input before fixing
>>>> up all drivers in patchset).
>>>
>>>
>>>> The main different from RFC-v1:
>>>>    - Drop idea of BTF "origin" (vmlinux, module or local)
>>>>    - Instead to use full 64-bit BTF ID that combine object+type ID
>>>
>>>> I've taken some of Alexandr/Larysa's libbpf patches and integrated
>>>> those.
>>>
>>>> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
>>>> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
>>>> required some refactoring to remove the SKB dependencies.
>>>
>>> Hey Jesper,
>>>
>>> I took a quick look at the series.
>> Appreciate that! :-)
>>
>>> Do we really need the enum with the flags?
>>
>> The primary reason for using enum is that these gets exposed as BTF.
>> The proposal is that userspace/BTF need to obtain the flags via BTF,
>> such that they don't become UAPI, but something we can change later.
>>
>>> We might eventually hit that "first 16 bits are reserved" issue?
>>>
>>> Instead of exposing enum with the flags, why not solve it as follows:
>>> a. We define UAPI struct xdp_rx_hints with _all_ possible hints
>>
>> How can we know _all_ possible hints from the beginning(?).
>>
>> UAPI + central struct dictating all possible hints, will limit innovation.
> 
> We don't need to know them all in advance. The same way we don't know
> them all for flags enum. That UAPI xdp_rx_hints can be extended any
> time some driver needs some new hint offload. The benefit here is that
> we have a "common registry" of all offloads and different drivers have
> an opportunity to share.
> 
> Think of it like current __sk_buff vs sk_buff. xdp_rx_hints is a fake
> uapi struct (__sk_buff) and the access to it gets translated into
> <device>_xdp_rx_hints offsets (sk_buff).
> 
>>> b. Each device defines much denser <device>_xdp_rx_hints struct with the
>>>      metadata that it supports
>>
>> Thus, the NIC device is limited to what is defined in UAPI struct
>> xdp_rx_hints.  Again this limits innovation.
> 
> I guess what I'm missing from your series is the bpf/userspace side.
> Do you have an example on the bpf side that will work for, say,
> xdp_hints_ixgbe_timestamp?

+1.  A selftest is useful.

> 
> Suppose, you pass this custom hints btf_id via xdp_md as proposed,
> what's the action on the bpf side to consume this?
> 
> If (ctx_hints_btf_id == xdp_hints_ixgbe_timestamp_btf_id /* supposedly
> populated at runtime by libbpf? */) {
>    // do something with rx_timestamp
>    // also, handle xdp_hints_ixgbe and then xdp_hints_common ?
> } else if (ctx_hints_btf_id == xdp_hints_ixgbe) {
>    // do something else
>    // plus explicitly handle xdp_hints_common here?
> } else {
>    // handle xdp_hints_common
> }
> 
> What I'd like to avoid is an xdp program targeting specific drivers.
> Where possible, we should aim towards something like "if this device
> has rx_timestamp offload -> use it without depending too much on
> specific btf_ids.

It would be my preference also if it can avoid btf_id comparison of a specific 
driver like the above and let the libbpf CO-RE to handle the 
matching/relocation.  For rx hwtimestamp, the value could be just 0 if a 
specific hw/driver cannot provide it for all packets while some other hw can.

A intentionally wild question, what does it take for the driver to return the 
hints.  Is the rx_desc and rx_queue enough?  When the xdp prog is calling a 
kfunc/bpf-helper, like 'hwtstamp = bpf_xdp_get_hwtstamp()', can the driver 
replace it with some inline bpf code (like how the inline code is generated for 
the map_lookup helper).  The xdp prog can then store the hwstamp in the meta 
area in any layout it wants.


