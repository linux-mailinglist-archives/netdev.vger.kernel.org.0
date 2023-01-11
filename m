Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29A96651EF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjAKChm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjAKChl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:37:41 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AD411C2A;
        Tue, 10 Jan 2023 18:37:38 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NsBYF71L7zqV4s;
        Wed, 11 Jan 2023 10:32:49 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 11 Jan 2023 10:37:35 +0800
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ipip6 and ip6ip decap support for
 bpf_skb_adjust_room()
To:     Willem de Bruijn <willemb@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <haoluo@google.com>, <jolsa@kernel.org>,
        <sdf@google.com>
References: <cover.1672976410.git.william.xuanziyang@huawei.com>
 <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
 <Y7h8yrOEkPuHkNpJ@google.com>
 <CA+FuTSdZ+za55p1kKOcGby89F_ybRhAfy2cG0R+Y00yaJTbVkg@mail.gmail.com>
 <4d0e5f2b-d088-58f4-d86d-00aa444d77c0@huawei.com>
 <CA+FuTSeE-S9_Uc6Cqs=EqYZd-K6kj=Ex4sudNx7u8HMLcrereQ@mail.gmail.com>
 <d6c60481-18a4-acfe-23a5-6950e2b3d5cd@huawei.com>
 <CA+FuTSe+=Vmn+UJftVYrMuaqs90scYXnDsX77z02+KT7SZLHrQ@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <189d7027-9148-f41e-1842-773f3f8e30a2@huawei.com>
Date:   Wed, 11 Jan 2023 10:37:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSe+=Vmn+UJftVYrMuaqs90scYXnDsX77z02+KT7SZLHrQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I think you prefer like this:
> 
> Yes, this looks good to me. A few comments inline.
> 
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -2644,6 +2644,11 @@ union bpf_attr {
>>   *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
>>   *               L2 type as Ethernet.
>>   *
>> + *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
>> + *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
>> + *                Indicates the new IP header version after decapsulate the
>> + *                outer IP header.
>> + *
>>   *             A call to this helper is susceptible to change the underlying
>>   *             packet buffer. Therefore, at load time, all checks on pointers
>>   *             previously done by the verifier are invalidated and must be
>> @@ -5803,6 +5808,8 @@ enum {
>>         BPF_F_ADJ_ROOM_ENCAP_L4_UDP     = (1ULL << 4),
>>         BPF_F_ADJ_ROOM_NO_CSUM_RESET    = (1ULL << 5),
>>         BPF_F_ADJ_ROOM_ENCAP_L2_ETH     = (1ULL << 6),
>> +       BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
>> +       BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
>>  };
>>
>>  enum {
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 43cc1fe58a2c..0bbe5e67337c 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3381,13 +3381,17 @@ static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
>>  #define BPF_F_ADJ_ROOM_ENCAP_L3_MASK   (BPF_F_ADJ_ROOM_ENCAP_L3_IPV4 | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L3_IPV6)
>>
>> +#define BPF_F_ADJ_ROOM_DECAP_L3_MASK   (BPF_F_ADJ_ROOM_DECAP_L3_IPV4 | \
>> +                                        BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
>> +
>>  #define BPF_F_ADJ_ROOM_MASK            (BPF_F_ADJ_ROOM_FIXED_GSO | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L3_MASK | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
>>                                          BPF_F_ADJ_ROOM_ENCAP_L2( \
>> -                                         BPF_ADJ_ROOM_ENCAP_L2_MASK))
>> +                                         BPF_ADJ_ROOM_ENCAP_L2_MASK) | \
>> +                                        BPF_F_ADJ_ROOM_DECAP_L3_MASK)
>>
>>  static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
>>                             u64 flags)
>> @@ -3501,6 +3505,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>>         int ret;
>>
>>         if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
>> +                              BPF_F_ADJ_ROOM_DECAP_L3_MASK |
>>                                BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
>>                 return -EINVAL;
>>
>> @@ -3519,6 +3524,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>>         if (unlikely(ret < 0))
>>                 return ret;
>>
>> +       /* Match skb->protocol to new outer l3 protocol */
>> +       if (skb->protocol == htons(ETH_P_IP) &&
>> +           flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
>> +               skb->protocol = htons(ETH_P_IPV6);
>> +       else if (skb->protocol == htons(ETH_P_IPV6) &&
>> +                flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
>> +               skb->protocol = htons(ETH_P_IP);
>> +
>>         if (skb_is_gso(skb)) {
>>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>>
>> @@ -3597,6 +3610,10 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>                      proto != htons(ETH_P_IPV6)))
>>                 return -ENOTSUPP;
>>
>> +       if (unlikely(shrink && flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4 &&
>> +                    flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6))
>> +               return -EINVAL;
>> +
> 
> parentheses and can use mask:
> 
>   if (shrink && (flags & .._MASK == .._MASK)
> 
> also should fail if the flags are passed but shrink is false.

Thank you for your valuable comments!

> 
>>         off = skb_mac_header_len(skb);
>>         switch (mode) {
>>         case BPF_ADJ_ROOM_NET:
>> @@ -3608,6 +3625,16 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>                 return -ENOTSUPP;
>>         }
>>
>> +       if (shrink) {
>> +               if (proto == htons(ETH_P_IP) &&
>> +                   flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6) {
>> +                       len_min = sizeof(struct ipv6hdr);
>> +               } else if (proto == htons(ETH_P_IPV6) &&
>> +                          flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4) {
>> +                       len_min = sizeof(struct iphdr);
>> +               }
>> +       }
>> +
> 
> No need to test proto first?

Indeed, I will remove them in patch v2.

> 
>>         len_cur = skb->len - skb_network_offset(skb);
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 464ca3f01fe7..041361bc6ccf 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -2644,6 +2644,11 @@ union bpf_attr {
>>   *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
>>   *               L2 type as Ethernet.
>>   *
>> + *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
>> + *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
>> + *                Indicates the new IP header version after decapsulate the
>> + *                outer IP header.
>> + *
>>   *             A call to this helper is susceptible to change the underlying
>>   *             packet buffer. Therefore, at load time, all checks on pointers
>>   *             previously done by the verifier are invalidated and must be
>> @@ -5803,6 +5808,8 @@ enum {
>>         BPF_F_ADJ_ROOM_ENCAP_L4_UDP     = (1ULL << 4),
>>         BPF_F_ADJ_ROOM_NO_CSUM_RESET    = (1ULL << 5),
>>         BPF_F_ADJ_ROOM_ENCAP_L2_ETH     = (1ULL << 6),
>> +       BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
>> +       BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
>>  };
>>
>>  enum {
>>
> .
> 
