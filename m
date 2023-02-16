Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7BB6995D3
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBPNao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjBPNan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:30:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D0E56EC9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676554188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sz//L1El2Opn1dz+ci3fGP9Fc6Go64iupeUlUG/RMd4=;
        b=ZRTocHnmxirPmjaHOol1S+IFU2Y/P6NwFGtcyaTe85ArMvOxia/JprFnBjc+u+niBZ6BFf
        V0FNCF40lVXNPR5MTq+lLrRt/YkXYLFeNWTW+hgjEt0oeu1JA8dPHolFA5xxpdcG+qlD8i
        zoFjBaH9KCtZqRn8K+Ejb5L/y/2QbSU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-kcwpW0FjNOq8-l7iQ-t1zA-1; Thu, 16 Feb 2023 08:29:46 -0500
X-MC-Unique: kcwpW0FjNOq8-l7iQ-t1zA-1
Received: by mail-ej1-f69.google.com with SMTP id vq12-20020a170907a4cc00b00896db1c78aaso1528618ejc.9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sz//L1El2Opn1dz+ci3fGP9Fc6Go64iupeUlUG/RMd4=;
        b=xvDyL1qvk2sHkNbsy09IIwDYRtgVZFWqQZLppJIJgsJOp6EyItfytLZd5o9OgK3zE8
         BIFlGWxHqh9nSLqqUA6JNJR651aQPs10xOzupjUdn9XpUgzYlMJjOU0A4MUR//00Ataz
         mPNlr/xvQMrOLZZbJEp+RAG2DmvQzELmgqtmvsC6KLAuppuZqXMXd3D14fsfylh7Ku3o
         K7jBXWp3UKe2aRqXiwvKYASRYrcu45o5NRnXVoaworA6v5pr8Y/ejAWSG68Y7e49HRyf
         xRM/l3xV/mzFJrPgGzfj28lKZUpInTmL2Wc/CItCDidSgCakvAL4jEzJ8PSeVjvLaxRi
         TeEQ==
X-Gm-Message-State: AO0yUKVCRljjbywN/qrjlifMY2BMc1GPylEuahd2VMZh82A54PgJg/TD
        Dx0GE6ZD2u94FOssgCzwQV5zBL4vVTlbe1M4OYI4CwTv2ppQaesqRK0r7E6YsX5d0lrj/YLqo70
        TyQVd+/E+8Jf6DetD
X-Received: by 2002:a17:906:4750:b0:878:42af:aa76 with SMTP id j16-20020a170906475000b0087842afaa76mr6836253ejs.54.1676554185658;
        Thu, 16 Feb 2023 05:29:45 -0800 (PST)
X-Google-Smtp-Source: AK7set/WfnsQWHXHhLv72NFdkNfTntbKlY/vDmqk3nHG/xh7pKFkqClgitPqxQd+pnKHF5dU3t9vKg==
X-Received: by 2002:a17:906:4750:b0:878:42af:aa76 with SMTP id j16-20020a170906475000b0087842afaa76mr6836226ejs.54.1676554185350;
        Thu, 16 Feb 2023 05:29:45 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id gz17-20020a170907a05100b00882f9130eb3sm794276ejc.223.2023.02.16.05.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 05:29:44 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <88e5c6b2-8acc-6585-100d-7b62320e5555@redhat.com>
Date:   Thu, 16 Feb 2023 14:29:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        martin.lau@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, ast@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        yoong.siang.song@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
In-Reply-To: <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 16.00, Paul Menzel wrote:
> 
> Thank you very much for your patch.

Thanks for your review :-)

> Am 10.02.23 um 16:07 schrieb Jesper Dangaard Brouer:
>> When function igc_rx_hash() was introduced in v4.20 via commit 
>> 0507ef8a0372
>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>> hardware wasn't configured to provide RSS hash, thus it made sense to not
>> enable net_device NETIF_F_RXHASH feature bit.
>>
>> The NIC hardware was configured to enable RSS hash info in v5.2 via 
>> commit
>> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
>> forgot to set the NETIF_F_RXHASH feature bit.
>>
>> The original implementation of igc_rx_hash() didn't extract the associated
>> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
>> this patch are about extracting the RSS Type from the hardware and mapping
>> this to enum pkt_hash_types. This were based on Foxville i225 software 
>> user
> 
> s/This were/This was/

Fixed for V2

>> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 
>> 03).
>>
>> For UDP it's worth noting that RSS (type) hashing have been disabled both for
>> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
>> because hardware RSS doesn't handle fragmented pkts well when enabled 
>> (can cause out-of-order). This result in PKT_HASH_TYPE_L3 for UDP packets, and
> 
> result*s*

Fixed for V2

> 
>> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
>> the effect that netstack will do a software based hash calc calling into
>> flow_dissect, but only when code calls skb_get_hash(), which doesn't
>> necessary happen for local delivery.
> 
> Excuse my ignorance, but is that bug visible in practice by users 
> (performance?) or is that fix needed for future work?
> 
>> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc.h      |   52 
>> +++++++++++++++++++++++++++++
>>   drivers/net/ethernet/intel/igc/igc_main.c |   35 +++++++++++++++++---
>>   2 files changed, 83 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc.h 
>> b/drivers/net/ethernet/intel/igc/igc.h
>> index df3e26c0cf01..a112eeb59525 100644
>> --- a/drivers/net/ethernet/intel/igc/igc.h
>> +++ b/drivers/net/ethernet/intel/igc/igc.h
>> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
>>   #define IGC_MRQC_RSS_FIELD_IPV4_UDP    0x00400000
>>   #define IGC_MRQC_RSS_FIELD_IPV6_UDP    0x00800000
>> +/* RX-desc Write-Back format RSS Type's */
>> +enum igc_rss_type_num {
>> +    IGC_RSS_TYPE_NO_HASH        = 0,
>> +    IGC_RSS_TYPE_HASH_TCP_IPV4    = 1,
>> +    IGC_RSS_TYPE_HASH_IPV4        = 2,
>> +    IGC_RSS_TYPE_HASH_TCP_IPV6    = 3,
>> +    IGC_RSS_TYPE_HASH_IPV6_EX    = 4,
>> +    IGC_RSS_TYPE_HASH_IPV6        = 5,
>> +    IGC_RSS_TYPE_HASH_TCP_IPV6_EX    = 6,
>> +    IGC_RSS_TYPE_HASH_UDP_IPV4    = 7,
>> +    IGC_RSS_TYPE_HASH_UDP_IPV6    = 8,
>> +    IGC_RSS_TYPE_HASH_UDP_IPV6_EX    = 9,
>> +    IGC_RSS_TYPE_MAX        = 10,
>> +};
>> +#define IGC_RSS_TYPE_MAX_TABLE        16
>> +#define IGC_RSS_TYPE_MASK        0xF
>> +
>> +/* igc_rss_type - Rx descriptor RSS type field */
>> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
>> +{
>> +    /* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
>> +    return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info & IGC_RSS_TYPE_MASK;
>> +}
> 
> Is it necessary to specficy the length of the return value, or could it 
> be `unsigned int`. Using “native” types is normally more performant [1]. 
> `scripts/bloat-o-meter` might help to verify that.
> 

Thanks for the link[1].
Alex/Olek also pointed this out.

The Agner's instruction latency tables[2] do indicate the latency is
slightly higher for r8 and r16 (and m8/m16).  And we likely need to look 
at the zero-extend variants movzx.

I think we should investigate this with "tool" godbolt.org as
scripts/bloat-o-meter will only tell us about code size.
I will experiment a bit and report back :-)

[2] https://www.agner.org/optimize/instruction_tables.pdf

> […]
> 
>>   static inline void igc_rx_hash(struct igc_ring *ring,
>>                      union igc_adv_rx_desc *rx_desc,
>>                      struct sk_buff *skb)
>>   {
>> -    if (ring->netdev->features & NETIF_F_RXHASH)
>> -        skb_set_hash(skb,
>> -                 le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>> -                 PKT_HASH_TYPE_L3);
>> +    if (ring->netdev->features & NETIF_F_RXHASH) {
>> +        u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>> +        u8  rss_type = igc_rss_type(rx_desc);
> 
> Amongst others, also here.

Do notice I expect compiler to optimize this, such that is doesn't place 
this variable on the stack.

>> +        enum pkt_hash_types hash_type;
>> +
>> +        hash_type = igc_rss_type_table[rss_type].hash_type;
>> +        skb_set_hash(skb, rss_hash, hash_type);
>> +    }
>>   }
>>   static void igc_rx_vlan(struct igc_ring *rx_ring,
>> @@ -6501,6 +6527,7 @@ static int igc_probe(struct pci_dev *pdev,
>>       netdev->features |= NETIF_F_TSO;
>>       netdev->features |= NETIF_F_TSO6;
>>       netdev->features |= NETIF_F_TSO_ECN;
>> +    netdev->features |= NETIF_F_RXHASH;
>>       netdev->features |= NETIF_F_RXCSUM;
>>       netdev->features |= NETIF_F_HW_CSUM;
>>       netdev->features |= NETIF_F_SCTP_CRC;
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1]: https://notabs.org/coding/smallIntsBigPenalty.htm
> 

