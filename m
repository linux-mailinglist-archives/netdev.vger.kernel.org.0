Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1656CD866
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjC2LYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjC2LYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE78211C
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680089037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBfCtmhIXZ3a7WDYA0EreShUJi3K2H0A83JbG6BaoFc=;
        b=Y+aFarLofMKBThRfJ9rYHAnUZBa0YV9S315QnIJ2iVI+sA5Bla4Z93Gxn9OEG0HHCWF5Mm
        Zob0ME9JUFDIvikt3NBAMg+dX5NN3WerHxomhbk6Rvd93YjMLRvLNp9dG2YXDDWVCb/KF9
        7/IWl8g4z+6yvaPNYCxVUBDYc5hrwgo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-k0Qg4ii0ORGx5zh3KstCwQ-1; Wed, 29 Mar 2023 07:23:56 -0400
X-MC-Unique: k0Qg4ii0ORGx5zh3KstCwQ-1
Received: by mail-ed1-f70.google.com with SMTP id j21-20020a508a95000000b004fd82403c91so21741931edj.3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680089035;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBfCtmhIXZ3a7WDYA0EreShUJi3K2H0A83JbG6BaoFc=;
        b=DQkQcd/Y94gaV4lqvBQBhA9Qn9aEi45kFebc/SvMZ+mAI4P5eZxFQlhq9VJZF2PCgc
         JRj0W4dTsP0ooDMFRrMTlq34t5iDEVpzVhuDSDpe5cgt50HolMBSEHTsltfpbj0mjKAv
         D5T/M7cirP9XkIGvpWB7VYKmMjVD8q7ZgG4uZON5AMYDT12TPE6c1lcZZKWUUz5PREAT
         rbvXxrGj4Mixed3iYtBZFXzZzOc3jhBMIvRw7zWunOpUaJEk6m+fcEIR4nKAkEZLDQA/
         KFKTGCW9ObHxCwioRFiabcV38zF5CJXJFZOlOg4SVyGw/aRwz65GmxhI98gtwEer2gYK
         l1JQ==
X-Gm-Message-State: AAQBX9fmjTuzkipW4vg85VcJT1psFLA7u4eQDsawTGHJ1SqDb3rJzyf1
        bVEY5lCZRkaX7Hfa7PVgFRknCobpPpfpXvBRjpaWBk82NnJpxSu8MgLBFRv5OJW628yygR8iVpd
        uHK2ZT3MgUH1ZvNmg
X-Received: by 2002:a17:906:6a8d:b0:933:9918:665d with SMTP id p13-20020a1709066a8d00b009339918665dmr2011842ejr.11.1680089035229;
        Wed, 29 Mar 2023 04:23:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350YaTN4ppSuFlgQgVBfE/TA14eBU09XWE3FSbcEvEqIX/dEGQYgsIgn4Eu3KvYEPg65tQscF3w==
X-Received: by 2002:a17:906:6a8d:b0:933:9918:665d with SMTP id p13-20020a1709066a8d00b009339918665dmr2011814ejr.11.1680089034885;
        Wed, 29 Mar 2023 04:23:54 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090630c900b008bc8ad41646sm16183091ejb.157.2023.03.29.04.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 04:23:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <811724e2-cdd6-15fe-b176-9dfcdbd98bad@redhat.com>
Date:   Wed, 29 Mar 2023 13:23:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf RFC 1/4] xdp: rss hash types representation
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
 <168003455815.3027256.7575362149566382055.stgit@firesoul>
 <ZCNjHAY81gS02FVW@google.com>
In-Reply-To: <ZCNjHAY81gS02FVW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/03/2023 23.58, Stanislav Fomichev wrote:
> On 03/28, Jesper Dangaard Brouer wrote:
>> The RSS hash type specifies what portion of packet data NIC hardware used
>> when calculating RSS hash value. The RSS types are focused on Internet
>> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
>> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
>> primarily TCP vs UDP, but some hardware supports SCTP.
> 
>> Hardware RSS types are differently encoded for each hardware NIC. Most
>> hardware represent RSS hash type as a number. Determining L3 vs L4 often
>> requires a mapping table as there often isn't a pattern or sorting
>> according to ISO layer.
> 
>> The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
>> be seen as a number that is ordered according by ISO layer, and can be bit
>> masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
>> for extending later while keeping these properties. This maps and unifies
>> difference to hardware specific hashes.
> 
> Looks good overall. Any reason we're making this specific layout?

One important goal is to have a simple/fast way to determining L3 vs L4,
because a L4 hash can be used for flow handling (e.g. load-balancing).

We below layout you can:

  if (rss_type & XDP_RSS_TYPE_L4_MASK)
	bool hw_hash_do_LB = true;

Or using it as a number:

  if (rss_type > XDP_RSS_TYPE_L4)
	bool hw_hash_do_LB = true;

I'm very open to changes to my "specific" layout.  I am in doubt if
using it as a number is the right approach and worth the trouble.

> Why not simply the following?
> 
> enum {
>      XDP_RSS_TYPE_NONE = 0,
>      XDP_RSS_TYPE_IPV4 = BIT(0),
>      XDP_RSS_TYPE_IPV6 = BIT(1),
>      /* IPv6 with extension header. */
>      /* let's note ^^^ it in the UAPI? */
>      XDP_RSS_TYPE_IPV6_EX = BIT(2),
>      XDP_RSS_TYPE_UDP = BIT(3),
>      XDP_RSS_TYPE_TCP = BIT(4),
>      XDP_RSS_TYPE_SCTP = BIT(5),

We know these bits for UDP, TCP, SCTP (and IPSEC) are exclusive, they
cannot be set at the same time, e.g. as a packet cannot both be UDP and
TCP.  Thus, using these bits as a number make sense to me, and is more
compact.

This BIT() approach also have the issue of extending it later (forward
compatibility).  As mentioned a common task will be to check if
hash-type is a L4 type.  See mlx5 [patch 4/4] needed to extend with
IPSEC. Notice how my XDP_RSS_TYPE_L4_MASK covers all the bits that this
can be extended with new L4 types, such that existing progs will still
work checking for L4 check.  It can of-cause be solved in the same way
for this BIT() approach by reserving some bits upfront in a mask.

> }
> 
> And then using XDP_RSS_TYPE_IPV4|XDP_RSS_TYPE_UDP vs 
> XDP_RSS_TYPE_IPV6|XXX ?

Do notice, that I already does some level of or'ing ("|") in this
proposal.  The main difference is that I hide this from the driver, and
kind of pre-combine the valid combination (enum's) drivers can select
from. I do get the point, and I think I will come up with a combined
solution based on your input.


The RSS hashing types and combinations comes from M$ standards:
  [1] 
https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ipv4-hash-type-combinations


>> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() to return
>> this RSS hash type on success.
> 
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   include/net/xdp.h |   51 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   net/core/xdp.c    |    4 +++-
>>   2 files changed, 54 insertions(+), 1 deletion(-)
> 
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 5393b3ebe56e..63f462f5ea7f 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -8,6 +8,7 @@
> 
>>   #include <linux/skbuff.h> /* skb_shared_info */
>>   #include <uapi/linux/netdev.h>
>> +#include <linux/bitfield.h>
> 
>>   /**
>>    * DOC: XDP RX-queue information
>> @@ -396,6 +397,56 @@ XDP_METADATA_KFUNC_xxx
>>   MAX_XDP_METADATA_KFUNC,
>>   };
> 
>> +/* For partitioning of xdp_rss_hash_type */
>> +#define RSS_L3        GENMASK(2,0) /* 3-bits = values between 1-7 */
>> +#define L4_BIT        BIT(3)       /* 1-bit - L4 indication */
>> +#define RSS_L4_IPV4    GENMASK(6,4) /* 3-bits */
>> +#define RSS_L4_IPV6    GENMASK(9,7) /* 3-bits */
>> +#define RSS_L4        GENMASK(9,3) /* = 7-bits - covering L4 
>> IPV4+IPV6 */
>> +#define L4_IPV6_EX_BIT    BIT(9)       /* 1-bit - L4 IPv6 with 
>> Extension hdr */
>> +                     /* 11-bits in total */
>> +
>> +/* The XDP RSS hash type (xdp_rss_hash_type) can both be seen as a number that
>> + * is ordered according by ISO layer, and can be bit masked to separate IPv4 and
>> + * IPv6 types for L4 protocols. Room is available for extending later while
>> + * keeping above properties, as this need to cover NIC hardware RSS types.
>> + */
>> +enum xdp_rss_hash_type {
>> +    XDP_RSS_TYPE_NONE            = 0,
>> +    XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
>> +
>> +    XDP_RSS_TYPE_L3_MASK         = RSS_L3,
>> +    XDP_RSS_TYPE_L3_IPV4         = FIELD_PREP_CONST(RSS_L3, 1),
>> +    XDP_RSS_TYPE_L3_IPV6         = FIELD_PREP_CONST(RSS_L3, 2),
>> +    XDP_RSS_TYPE_L3_IPV6_EX      = FIELD_PREP_CONST(RSS_L3, 4),
>> +
>> +    XDP_RSS_TYPE_L4_MASK         = RSS_L4,
>> +    XDP_RSS_TYPE_L4_SHIFT        = __bf_shf(RSS_L4),
>> +    XDP_RSS_TYPE_L4_MASK_EX      = RSS_L4 | L4_IPV6_EX_BIT,
>> +
>> +    XDP_RSS_TYPE_L4_IPV4_MASK    = RSS_L4_IPV4,
>> +    XDP_RSS_TYPE_L4_BIT          = L4_BIT,
>> +    XDP_RSS_TYPE_L4_IPV4_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 1),
>> +    XDP_RSS_TYPE_L4_IPV4_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 2),
>> +    XDP_RSS_TYPE_L4_IPV4_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 3),
>> +
>> +    XDP_RSS_TYPE_L4_IPV6_MASK    = RSS_L4_IPV6,
>> +    XDP_RSS_TYPE_L4_IPV6_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 1),
>> +    XDP_RSS_TYPE_L4_IPV6_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 2),
>> +    XDP_RSS_TYPE_L4_IPV6_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 3),
>> +
>> +    XDP_RSS_TYPE_L4_IPV6_EX_MASK = L4_IPV6_EX_BIT,
>> +    XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP|L4_IPV6_EX_BIT,
>> +    XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP|L4_IPV6_EX_BIT,
>> +    XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP|L4_IPV6_EX_BIT,
>> +};
>> +#undef RSS_L3
>> +#undef L4_BIT
>> +#undef RSS_L4_IPV4
>> +#undef RSS_L4_IPV6
>> +#undef RSS_L4
>> +#undef L4_IPV6_EX_BIT
>> +
>>   #ifdef CONFIG_NET
>>   u32 bpf_xdp_metadata_kfunc_id(int id);
>>   bool bpf_dev_bound_kfunc_id(u32 btf_id);
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 7133017bcd74..81d41df30695 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -721,12 +721,14 @@ __bpf_kfunc int 
>> bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>>    * @hash: Return value pointer.
>>    *
>>    * Return:
>> - * * Returns 0 on success or ``-errno`` on error.
>> + * * Returns (positive) RSS hash **type** on success or ``-errno`` on 
>> error.
>> + * * ``enum xdp_rss_hash_type`` : RSS hash type
>>    * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
>>    * * ``-ENODATA``    : means no RX-hash available for this frame
>>    */
>>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, 
>> u32 *hash)
>>   {
>> +    BTF_TYPE_EMIT(enum xdp_rss_hash_type);
>>       return -EOPNOTSUPP;
>>   }
> 
> 
> 

