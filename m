Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76CA666B71
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbjALHPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbjALHPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:15:22 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA800630A;
        Wed, 11 Jan 2023 23:15:10 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Nswkg5LFgz16MQq;
        Thu, 12 Jan 2023 15:13:31 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 12 Jan 2023 15:15:06 +0800
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add ipip6 and ip6ip decap support
 for bpf_skb_adjust_room()
To:     Willem de Bruijn <willemb@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
References: <cover.1673423199.git.william.xuanziyang@huawei.com>
 <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
 <CA+FuTSfGDdXTGZsjK+NhZmzirawh+09HF4v-5Cr1+4boxfqnXQ@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <1b4c45a3-ffe3-e652-1241-91db0fd9873c@huawei.com>
Date:   Thu, 12 Jan 2023 15:15:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfGDdXTGZsjK+NhZmzirawh+09HF4v-5Cr1+4boxfqnXQ@mail.gmail.com>
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

> On Wed, Jan 11, 2023 at 3:01 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
>> Main use case is for using cls_bpf on ingress hook to decapsulate
>> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
>>
>> Add two new flags BPF_F_ADJ_ROOM_DECAP_L3_IPV{4,6} to indicate the
>> new IP header version after decapsulating the outer IP header.
>>
>> Suggested-by: Willem de Bruijn <willemb@google.com>
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  include/uapi/linux/bpf.h       |  8 ++++++++
>>  net/core/filter.c              | 26 +++++++++++++++++++++++++-
>>  tools/include/uapi/linux/bpf.h |  8 ++++++++
>>  3 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 464ca3f01fe7..dde1c2ea1c84 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -2644,6 +2644,12 @@ union bpf_attr {
>>   *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
>>   *               L2 type as Ethernet.
>>   *
>> + *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
>> + *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
>> + *                Indicate the new IP header version after decapsulating the
>> + *                outer IP header. Mainly used in scenarios that the inner and
>> + *                outer IP versions are different.
>> + *
> 
> Nit (only since I have another comment below)
> 
> Indicate -> Set
Sorry, I think "Indicate" maybe more suitable. Because the new IP header is original inner
IP header, it's not be changed. The flags assist the kernel to better complete specific tasks.
I think "Set" has a meaning of change.

> [Mainly used .. that] -> [Used when]
This looks good to me. Thanks!

> 
>>         if (skb_is_gso(skb)) {
>>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>>
>> @@ -3596,6 +3609,10 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>         if (unlikely(proto != htons(ETH_P_IP) &&
>>                      proto != htons(ETH_P_IPV6)))
>>                 return -ENOTSUPP;
>> +       if (unlikely((shrink && ((flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) ==
>> +                     BPF_F_ADJ_ROOM_DECAP_L3_MASK)) || (!shrink &&
>> +                     flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK)))
>> +               return -EINVAL;
>>
>>         off = skb_mac_header_len(skb);
>>         switch (mode) {
>> @@ -3608,6 +3625,13 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>                 return -ENOTSUPP;
>>         }
>>
>> +       if (shrink) {
>> +               if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
>> +                       len_min = sizeof(struct ipv6hdr);
>> +               else if (flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
>> +                       len_min = sizeof(struct iphdr);
>> +       }
>> +
> 
> How about combining this branch with the above:
> 
>   if (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
>     if (!shrink)
>       return -EINVAL;
> 
>     switch (flags & BPF_F_ADJ_ROOM_DECAP_L3_MASK) {
>       case BPF_F_ADJ_ROOM_DECAP_L3_IPV4:
>         len_min = sizeof(struct iphdr);
>         break;
>       case BPF_F_ADJ_ROOM_DECAP_L3_IPV6:
>         len_min = sizeof(struct ipv6hdr);
>         break;
>       default:
>         return -EINVAL;
>     }
> This looks good to me. Thanks!

> 
