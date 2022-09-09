Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6605B3A74
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIIOOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiIIOOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED4CAB405
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 07:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662732840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xk32t8ThwwHLTdGdpwN3jqOuQlPi1iyqPkh3M3TzE+U=;
        b=TOMosKMLMP+42LEJOZE1E8gYY9JWhzEqo/ublJR/1edOtUWhMPgFFgbNnAvj1cjFaNnrEH
        lIS8JRytX1iHE9wOgYcS8WbswMohtGIrMs9O3MdE5IN/LKFtsGxiOPjJIvw6Y9he4p+0/J
        /qI1dARprJf9XOLSKkYA0Lp5aylwkLs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-h-lhLuNeMYaKU0DSZfdSQQ-1; Fri, 09 Sep 2022 10:13:58 -0400
X-MC-Unique: h-lhLuNeMYaKU0DSZfdSQQ-1
Received: by mail-ed1-f69.google.com with SMTP id f18-20020a056402355200b0045115517911so1129631edd.14
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 07:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=Xk32t8ThwwHLTdGdpwN3jqOuQlPi1iyqPkh3M3TzE+U=;
        b=XZa/k8MWG9t5WvTPbgubEbEGzlWqTeX7y/+VobkXYJ2fNtaoe1DZBe6GQDV0WvDtDW
         mbWfE13lkpHXQqxp3Dfi/0F7jtPsOKiGl3oGbI+Wz9txW+gTUD9Tr7yG7T9c8H8Y1tSH
         dstH9BVtGX+wSDlydrqoneVYzS4L2cp/DVO/qE2Z5HaEHD0K03X4S2azeUjp61TDlPRs
         Y0c7u3DaBqcMmMrrEE4Q32R2wEx7M9IN7dznsDJbkDRmjAPh19a4pBTY5XByAQ5HjkBn
         3QH6xdCNkSB3ACxqdgC5+GCgmwRxK+vq7zI3KKZS6axGldxPlCYSV91bA4GENzh2Wr1L
         2VTA==
X-Gm-Message-State: ACgBeo3evxOM0gxO0lS5tEiCrcchsSZB9tJmaRTbR//gvbGAxcD73gU5
        lXhmEU7tmHJyCRKB0YYzX8X/nU8ktL5u2wC8ynQ313CdtAXb5CG74qUZFLo8XJSGYoFKb0njRhW
        LH208oDwZ+uHzaGNY
X-Received: by 2002:a17:907:2da6:b0:73d:d587:6213 with SMTP id gt38-20020a1709072da600b0073dd5876213mr10104226ejc.5.1662732835867;
        Fri, 09 Sep 2022 07:13:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4EY90EagVDvuKxXzjyal5aWEq+43WPQ4My0vxpoU99rwNuKuJYIARjTDUjajUYtM6uM0Hqsw==
X-Received: by 2002:a17:907:2da6:b0:73d:d587:6213 with SMTP id gt38-20020a1709072da600b0073dd5876213mr10104207ejc.5.1662732835573;
        Fri, 09 Sep 2022 07:13:55 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id r7-20020a056402018700b0044e96f11359sm473025edv.3.2022.09.09.07.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 07:13:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <74a68399-35b2-c0f2-92cb-236a0773837e@redhat.com>
Date:   Fri, 9 Sep 2022 16:13:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 04/18] net: create
 xdp_hints_common and set functions
Content-Language: en-US
To:     "Burakov, Anatoly" <anatoly.burakov@intel.com>, bpf@vger.kernel.org
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256552083.1434226.577215984964402996.stgit@firesoul>
 <f14c367b-fe4e-2956-b34e-8d54862a6393@intel.com>
In-Reply-To: <f14c367b-fe4e-2956-b34e-8d54862a6393@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/09/2022 12.49, Burakov, Anatoly wrote:
> On 07-Sep-22 4:45 PM, Jesper Dangaard Brouer wrote:
>> XDP-hints via BTF are about giving drivers the ability to extend the
>> common set of hardware offload hints in a flexible way.
>>
>> This patch start out with defining the common set, based on what is
>> used available in the SKB. Having this as a common struct in core
>> vmlinux makes it easier to implement xdp_frame to SKB conversion
>> routines as normal C-code, see later patches.
>>
>> Drivers can redefine the layout of the entire metadata area, but are
>> encouraged to use this common struct as the base, on which they can
>> extend on top for their extra hardware offload hints. When doing so,
>> drivers can mark the xdp_buff (and xdp_frame) with flags indicating
>> this it compatible with the common struct.
>>
>> Patch also provides XDP-hints driver helper functions for updating the
>> common struct. Helpers gets inlined and are defined for maximum
>> performance, which does require some extra care in drivers, e.g. to
>> keep track of flags to reduce data dependencies, see code DOC.
>>
>> Userspace and BPF-prog's MUST not consider the common struct UAPI.
>> The common struct (and enum flags) are only exposed via BTF, which
>> implies consumers must read and decode this BTF before using/consuming
>> data layout.
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   include/net/xdp.h |  147 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   net/core/xdp.c    |    5 ++
>>   2 files changed, 152 insertions(+)
>>
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 04c852c7a77f..ea5836ccee82 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -8,6 +8,151 @@
>>   #include <linux/skbuff.h> /* skb_shared_info */
>> +/**
>> + * struct xdp_hints_common - Common XDP-hints offloads shared with 
>> netstack
>> + * @btf_full_id: The modules BTF object + type ID for specific struct
>> + * @vlan_tci: Hardware provided VLAN tag + proto type in 
>> @xdp_hints_flags
>> + * @rx_hash32: Hardware provided RSS hash value
>> + * @xdp_hints_flags: see &enum xdp_hints_flags
>> + *
>> + * This structure contains the most commonly used hardware offloads 
>> hints
>> + * provided by NIC drivers and supported by the SKB.
>> + *
>> + * Driver are expected to extend this structure by include &struct
>> + * xdp_hints_common as part of the drivers own specific xdp_hints 
>> struct's, but
>> + * at the end-of their struct given XDP metadata area grows backwards.
>> + *
>> + * The member @btf_full_id is populated by driver modules to uniquely 
>> identify
>> + * the BTF struct.  The high 32-bits store the modules BTF object ID 
>> and the
>> + * lower 32-bit the BTF type ID within that BTF object.
>> + */
>> +struct xdp_hints_common {
>> +    union {
>> +        __wsum        csum;
>> +        struct {
>> +            __u16    csum_start;
>> +            __u16    csum_offset;
>> +        };
>> +    };
>> +    u16 rx_queue;
>> +    u16 vlan_tci;
>> +    u32 rx_hash32;
>> +    u32 xdp_hints_flags;
>> +    u64 btf_full_id; /* BTF object + type ID */
>> +} __attribute__((aligned(4))) __attribute__((packed));
> 
> I'm assuming any Tx metadata will have to go before the Rx checksum union?
> 

Nope.  The plan is that the TX metadata can reuse the same metadata area
with its own layout.  I imagine a new xdp_buff->flags bit that tell us
the layout is now TX-layout with xdp_hints_common_tx.

We could rename xdp_hints_common to xdp_hints_common_rx to anticipate
and prepare for this. But that would be getting a head of ourselves,
because someone in the community might have a smarter solution, e.g.
that could combine common RX and TX in a single struct. e.g. overlapping
csum and vlan_tci might make sense.

>> +
>> +
>> +/**
>> + * enum xdp_hints_flags - flags used by &struct xdp_hints_common
>> + *
>> + * The &enum xdp_hints_flags have reserved the first 16 bits for 
>> common flags
>> + * and drivers can introduce use their own flags bits from BIT(16). For
>> + * BPF-progs to find these flags (via BTF) drivers should define an enum
>> + * xdp_hints_flags_driver.
>> + */
>> +enum xdp_hints_flags {
>> +    HINT_FLAG_CSUM_TYPE_BIT0  = BIT(0),
>> +    HINT_FLAG_CSUM_TYPE_BIT1  = BIT(1),
>> +    HINT_FLAG_CSUM_TYPE_MASK  = 0x3,
>> +
>> +    HINT_FLAG_CSUM_LEVEL_BIT0 = BIT(2),
>> +    HINT_FLAG_CSUM_LEVEL_BIT1 = BIT(3),
>> +    HINT_FLAG_CSUM_LEVEL_MASK = 0xC,
>> +    HINT_FLAG_CSUM_LEVEL_SHIFT = 2,
>> +
>> +    HINT_FLAG_RX_HASH_TYPE_BIT0 = BIT(4),
>> +    HINT_FLAG_RX_HASH_TYPE_BIT1 = BIT(5),
>> +    HINT_FLAG_RX_HASH_TYPE_MASK = 0x30,
>> +    HINT_FLAG_RX_HASH_TYPE_SHIFT = 0x4,
>> +
>> +    HINT_FLAG_RX_QUEUE = BIT(7),
>> +
>> +    HINT_FLAG_VLAN_PRESENT            = BIT(8),
>> +    HINT_FLAG_VLAN_PROTO_ETH_P_8021Q  = BIT(9),
>> +    HINT_FLAG_VLAN_PROTO_ETH_P_8021AD = BIT(10),
>> +    /* Flags from BIT(16) can be used by drivers */
> 
> If we assumed we also have Tx section, would 16 bits be enough? For a 
> basic implementation of UDP checksumming, AF_XDP would need 3x16 more 
> bits (to store L2/L3/L4 offsets) plus probably a flag field indicating 
> presence of each. Is there any way to expand common fields in the future 
> (or is it at all intended to be expandable)?
> 

As above we could have separate flags for TX side, e.g.
xdp_hints_flags_tx.  But some of the flags might still be valid for
TX-side, so they could potentially share some.

BUT it is also important to realize that I'm saying this is not UAPI
flags being exposed (like in include/uapi/bpf.h).  The runtime value of
these enum defined flags MUST be obtained via BTF (through help of
libbpf CO-RE or in userspace by parsing BTF).

Thus, in principle the kernel is free to change these structs and enums.
In practice it will be very annoying for BPF-progs and AF_XDP userspace
code if we change the names of the struct's and somewhat annoying if
members change name.  CO-RE can deal with kernel changes and feature
detection[1] down to the avail enums e.g. via using
bpf_core_enum_value_exists().  But we should avoid too many changes as
the code becomes harder to read.

--Jesper

[1] 
https://nakryiko.com/posts/bpf-core-reference-guide/#bpf-core-enum-value-exists

