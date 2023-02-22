Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5C69F747
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjBVPBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjBVPBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:01:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983A739BAA
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677078035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/NWRnnHMvtK2me1ArqMwL6SgTiL4oVHuXEGAoMYY7y4=;
        b=h6cW7Me8nbrN5/NN2mYBRXNWl5MpSI7gu39JhauvcWw6PlSwx6Hj2Nj0ilrw+eNDeed5xz
        aUn5KUZt40AhOS95TfdR6l5lJVORl3Esp3ZOq9/9VHfmP/KkUpb6tO2SOxW3JFfh5kN7o2
        HlG6uOC3MovD3EZksibgvSzKgg6FQ80=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-k5S_Nam-M3-xScHyIFMiqA-1; Wed, 22 Feb 2023 10:00:34 -0500
X-MC-Unique: k5S_Nam-M3-xScHyIFMiqA-1
Received: by mail-ed1-f72.google.com with SMTP id eg35-20020a05640228a300b004ad6e399b73so10274594edb.10
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/NWRnnHMvtK2me1ArqMwL6SgTiL4oVHuXEGAoMYY7y4=;
        b=uvZDWGvpZYP6ubcpA+lcwT2/U+WgkcWGyYyB7hckKL5+fAtu6sQGo/AB2D5K2x+rrf
         ZRD9egKWsCXmAJJFKI/ubcj4cyggcjF324vxqPgSB1w5/2kSn6//oACjilI3Z+Um7gDz
         3+hzYIckCFfBEOLyw3H/UYCeCsdDpsHwAdiJDPyUgYIAVG0WTadw8X2zBZ8mf8aHPiNf
         ewpU2dNMdFz6O4Q4k7VpCbT9qB6ge2YbaQ6HJm1IKHXpKAdu7jyNM9IkviEkAdyT6Re5
         3THtvy7HC4qvyWzST1HoL3eqcI7y7NiLuC0AosvjA4OX5yOFnoR/83kNiPBNjKd9Uxgw
         0oBA==
X-Gm-Message-State: AO0yUKUrLhi5UL7L7H9xVmFhM8jt+Qx3uBofnuCDzcxUmBcxseBILwG3
        ZbUiPuUBMsqnw7Vx1l0Ur3yDmhoAMzvCtA3TDqnBo0nZy5+m5hO8NjW89hbQPKtMUE7zl7UVubj
        nTxa9/p/vJYKPSOi5
X-Received: by 2002:a17:906:255b:b0:8af:3fcc:2b05 with SMTP id j27-20020a170906255b00b008af3fcc2b05mr15487030ejb.12.1677078032759;
        Wed, 22 Feb 2023 07:00:32 -0800 (PST)
X-Google-Smtp-Source: AK7set8SuV4PWVVAD/pGDyH2/6OQtfZrZg9ZybeJzL9rpWjnXy8B7cjl0fwAW9/sc/w/Nb58/zF71Q==
X-Received: by 2002:a17:906:255b:b0:8af:3fcc:2b05 with SMTP id j27-20020a170906255b00b008af3fcc2b05mr15487004ejb.12.1677078032394;
        Wed, 22 Feb 2023 07:00:32 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id h20-20020a1709070b1400b008b907006d5dsm6518567ejl.173.2023.02.22.07.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 07:00:31 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <59aa33b3-e174-b535-cc9f-1d934204271c@redhat.com>
Date:   Wed, 22 Feb 2023 16:00:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, yoong.siang.song@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        xdp-hints@xdp-project.net, Sasha Neftin <sasha.neftin@intel.com>
Subject: Re: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
 <fe613404-9d1c-d816-404f-9af4526a42a3@redhat.com>
 <74330cb7-bf54-6aa0-8a07-c9c557037a31@intel.com>
In-Reply-To: <74330cb7-bf54-6aa0-8a07-c9c557037a31@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/02/2023 16.39, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Thu, 16 Feb 2023 17:46:53 +0100
> 
>>
>> On 14/02/2023 14.21, Alexander Lobakin wrote:
>>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>>> Date: Fri, 10 Feb 2023 16:07:59 +0100
>>>
>>>> When function igc_rx_hash() was introduced in v4.20 via commit
>>>> 0507ef8a0372
>>>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>>>> hardware wasn't configured to provide RSS hash, thus it made sense to
>>>> not
>>>> enable net_device NETIF_F_RXHASH feature bit.
>>>
>>> [...]
>>>
>>>> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
>>>>    #define IGC_MRQC_RSS_FIELD_IPV4_UDP    0x00400000
>>>>    #define IGC_MRQC_RSS_FIELD_IPV6_UDP    0x00800000
>>>>    +/* RX-desc Write-Back format RSS Type's */
>>>> +enum igc_rss_type_num {
>>>> +    IGC_RSS_TYPE_NO_HASH        = 0,
>>>> +    IGC_RSS_TYPE_HASH_TCP_IPV4    = 1,
>>>> +    IGC_RSS_TYPE_HASH_IPV4        = 2,
>>>> +    IGC_RSS_TYPE_HASH_TCP_IPV6    = 3,
>>>> +    IGC_RSS_TYPE_HASH_IPV6_EX    = 4,
>>>> +    IGC_RSS_TYPE_HASH_IPV6        = 5,
>>>> +    IGC_RSS_TYPE_HASH_TCP_IPV6_EX    = 6,
>>>> +    IGC_RSS_TYPE_HASH_UDP_IPV4    = 7,
>>>> +    IGC_RSS_TYPE_HASH_UDP_IPV6    = 8,
>>>> +    IGC_RSS_TYPE_HASH_UDP_IPV6_EX    = 9,
>>>> +    IGC_RSS_TYPE_MAX        = 10,
>>>> +};
>>>> +#define IGC_RSS_TYPE_MAX_TABLE        16
>>>> +#define IGC_RSS_TYPE_MASK        0xF
>>>
>>> GENMASK()?
>>>
>>
>> hmm... GENMASK(3,0) looks more confusing to me. The mask we need here is
>> so simple that I prefer not to complicate this with GENMASK.
>>

Changed my mind, I'm going with GENMASK(3,0) in V3.

>>>> +
>>>> +/* igc_rss_type - Rx descriptor RSS type field */
>>>> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
>>>
>>> Why use types shorter than u32 on the stack?
>>
>> Changing to u32 in V2
>>
>>> Why this union is not const here, since there are no modifications?
>>
>> Sure
>>
>>>> +{
>>>> +    /* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
>>>> +    return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info &
>>>> IGC_RSS_TYPE_MASK;
>>>
>>> The most important I wanted to mention: doesn't this function make the
>>> CPU read the uncached field again, while you could just read it once
>>> onto the stack and then extract all such data from there?
>>
>> I really don't think this is an issues here. The igc_adv_rx_desc is only
>> 16 bytes and it should be hot in CPU cache by now.
> 
> Rx descriptors are located in the DMA coherent zone (allocated via
> dma_alloc_coherent()), I am missing something? Because I was (I am) sure
> CPU doesn't cache anything from it (and doesn't reorder reads/writes
> from/to). I thought that's the point of coherent zones -- you may talk
> to hardware without needing for syncing...
> 

That is a good point and you are (likely) right.

I do want to remind you that this is a "fixes" patch that dates back to
v5.2.  This driver is from the very beginning coded to access descriptor
this way via union igc_adv_rx_desc.  For a fixes patch, I'm not going to
code up a new and more effecient way of accessing the descriptor memory.

If you truely believe this matters for a 2.5 Gbit/s device, then someone 
(e.g you) can go through this driver and change this pattern in the code.


>>
>> To avoid the movzx I have changed this to do a u32 read instead.
>>
>>>> +}
>>>> +
>>>> +/* Packet header type identified by hardware (when BIT(11) is zero).
>>>> + * Even when UDP ports are not part of RSS hash HW still parse and
>>>> mark UDP bits
>>>> + */
>>>> +enum igc_pkt_type_bits {
>>>> +    IGC_PKT_TYPE_HDR_IPV4    =    BIT(0),
>>>> +    IGC_PKT_TYPE_HDR_IPV4_WITH_OPT=    BIT(1), /* IPv4 Hdr includes
>>>> IP options */
>>>> +    IGC_PKT_TYPE_HDR_IPV6    =    BIT(2),
>>>> +    IGC_PKT_TYPE_HDR_IPV6_WITH_EXT=    BIT(3), /* IPv6 Hdr includes
>>>> extensions */
>>>> +    IGC_PKT_TYPE_HDR_L4_TCP    =    BIT(4),
>>>> +    IGC_PKT_TYPE_HDR_L4_UDP    =    BIT(5),
>>>> +    IGC_PKT_TYPE_HDR_L4_SCTP=    BIT(6),
>>>> +    IGC_PKT_TYPE_HDR_NFS    =    BIT(7),
>>>> +    /* Above only valid when BIT(11) is zero */
>>>> +    IGC_PKT_TYPE_L2        =    BIT(11),
>>>> +    IGC_PKT_TYPE_VLAN    =    BIT(12),
>>>> +    IGC_PKT_TYPE_MASK    =    0x1FFF, /* 13-bits */
>>>
>>> Also GENMASK().
>>
>> GENMASK would make more sense here.
>>
>>>> +};
>>>> +
>>>> +/* igc_pkt_type - Rx descriptor Packet type field */
>>>> +static inline u16 igc_pkt_type(union igc_adv_rx_desc *rx_desc)
>>>
>>> Also short types and consts.
>>>
>>
>> Fixed in V2
>>
>>>> +{
>>>> +    u32 data = le32_to_cpu(rx_desc->wb.lower.lo_dword.data);
>>>> +    /* Packet type is 13-bits - as bits (16:4) in lower.lo_dword*/
>>>> +    u16 pkt_type = (data >> 4) & IGC_PKT_TYPE_MASK;
>>>
>>> Perfect candidate for FIELD_GET(). No, even for le32_get_bits().
>>

Dropping all the code and defines for "igc_pkt_type", as the code ended
up not being used.  I simply kept this around to document what was in
the programmers datasheet (to help others understand the hardware).


>> I adjusted this, but I could not find a central define for FIELD_GET
>> (but many drivers open code this).
> 
> <linux/bitfield.h>. It has FIELD_{GET,PREP}() and also builds
> {u,__le,__be}{8,16,32}_{encode,get,replace}_bits() via macro (the latter
> doesn't get indexed by Elixir, as it doesn't parse functions built via
> macros).

Thanks for the pointer to <linux/bitfield.h>, I'll be using that in V3.

>>
>>> Also my note above about excessive expensive reads.
>>>
>>>> +
>>>> +    return pkt_type;
>>>> +}
>>>> +
>>>>    /* Interrupt defines */
>>>>    #define IGC_START_ITR            648 /* ~6000 ints/sec */
>>>>    #define IGC_4K_ITR            980
>>>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>>>> b/drivers/net/ethernet/intel/igc/igc_main.c
>>>> index 8b572cd2c350..42a072509d2a 100644
>>>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>>>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>>>> @@ -1677,14 +1677,40 @@ static void igc_rx_checksum(struct igc_ring
>>>> *ring,
>>>>               le32_to_cpu(rx_desc->wb.upper.status_error));
>>>>    }
>>>>    +/* Mapping HW RSS Type to enum pkt_hash_types */
>>>> +struct igc_rss_type {
>>>> +    u8 hash_type; /* can contain enum pkt_hash_types */
>>>
>>> Why make a struct for one field? + short type note

Also fixing this in V3.

>>>> +} igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
>>>> +    [IGC_RSS_TYPE_NO_HASH].hash_type      = PKT_HASH_TYPE_L2,
>>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV4].hash_type      = PKT_HASH_TYPE_L4,
>>>> +    [IGC_RSS_TYPE_HASH_IPV4].hash_type      = PKT_HASH_TYPE_L3,
>>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV6].hash_type      = PKT_HASH_TYPE_L4,
>>>> +    [IGC_RSS_TYPE_HASH_IPV6_EX].hash_type      = PKT_HASH_TYPE_L3,
>>>> +    [IGC_RSS_TYPE_HASH_IPV6].hash_type      = PKT_HASH_TYPE_L3,
>>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV4].hash_type      = PKT_HASH_TYPE_L4,
>>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV6].hash_type      = PKT_HASH_TYPE_L4,
>>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>>>> +    [10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9
>>>> "Reserved" by HW */
>>>> +    [11].hash_type = PKT_HASH_TYPE_L2,
>>>> +    [12].hash_type = PKT_HASH_TYPE_L2,
>>>> +    [13].hash_type = PKT_HASH_TYPE_L2,
>>>> +    [14].hash_type = PKT_HASH_TYPE_L2,
>>>> +    [15].hash_type = PKT_HASH_TYPE_L2,

Changing these 10-15 to PKT_HASH_TYPE_NONE, which is zero.
The ASM generated table is smaller code size with zero padded content.

>>>
>>> Why define those empty if you could do a bound check in the code
>>> instead? E.g. `if (unlikely(bigger_than_9)) return PKT_HASH_TYPE_L2`.
>>
>> Having a branch for this is likely slower.  On godbolt I see that this
>> generates suboptimal and larger code.
> 
> But you have to verify HW output anyway, right? Or would like to rely on
> that on some weird revision it won't spit BIT(69) on you?
> 

The table is constructed such that the lookup takes care of "verifying"
the HW output.  Notice that software will bit mask the last 4 bits, thus
the number will max be 15.  No matter what hardware outputs it is safe
to do a lookup in the table.  IMHO it is a simple way to avoid an
unnecessary verification branch and still be able to handle buggy/weird
HW revs.


>>>> +};
>>>> +
>>>>    static inline void igc_rx_hash(struct igc_ring *ring,
>>>>                       union igc_adv_rx_desc *rx_desc,
>>>>                       struct sk_buff *skb)
>>>>    {
>>>> -    if (ring->netdev->features & NETIF_F_RXHASH)
>>>> -        skb_set_hash(skb,
>>>> -                 le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>>> -                 PKT_HASH_TYPE_L3);
>>>> +    if (ring->netdev->features & NETIF_F_RXHASH) {
>>>
>>>      if (!(feature & HASH))
>>>          return;
>>>
>>> and -1 indent level?
>>
>> Usually, yes, I also prefer early return style code.
>> For one I just followed the existing style.
> 
> I'd not recommend "keep the existing style" of Intel drivers -- not
> something I'd like to keep as is :D
> 
>>
>> Second, I tried to code it up, but it looks ugly in this case, as the
>> variable defines need to get moved outside the if statement.
>>
>>>> +        u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>>>> +        u8  rss_type = igc_rss_type(rx_desc);
>>>> +        enum pkt_hash_types hash_type;
>>>> +
>>>> +        hash_type = igc_rss_type_table[rss_type].hash_type;
>>>> +        skb_set_hash(skb, rss_hash, hash_type);
>>>> +    }
>>>>    }
>>>
>>> [...]

--Jesper

