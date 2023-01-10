Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C32664137
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjAJNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjAJNHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:07:21 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFE4E0F6;
        Tue, 10 Jan 2023 05:07:18 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nrrdx1JT5znVCK;
        Tue, 10 Jan 2023 21:05:41 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 10 Jan 2023 21:07:14 +0800
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
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <d6c60481-18a4-acfe-23a5-6950e2b3d5cd@huawei.com>
Date:   Tue, 10 Jan 2023 21:07:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeE-S9_Uc6Cqs=EqYZd-K6kj=Ex4sudNx7u8HMLcrereQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

> On Mon, Jan 9, 2023 at 4:20 AM Ziyang Xuan (William)
> <william.xuanziyang@huawei.com> wrote:
>>
>>> On Fri, Jan 6, 2023 at 2:55 PM <sdf@google.com> wrote:
>>>>
>>>> On 01/06, Ziyang Xuan wrote:
>>>>> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
>>>>> Main use case is for using cls_bpf on ingress hook to decapsulate
>>>>> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
>>>>
>>>> CC'd Willem since he has done bpf_skb_adjust_room changes in the past.
>>>> There might be a lot of GRO/GSO context I'm missing.
>>>>
>>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>>> ---
>>>>>   net/core/filter.c | 34 ++++++++++++++++++++++++++++++++--
>>>>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>>>
>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>> index 929358677183..73982fb4fe2e 100644
>>>>> --- a/net/core/filter.c
>>>>> +++ b/net/core/filter.c
>>>>> @@ -3495,6 +3495,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb,
>>>>> u32 off, u32 len_diff,
>>>>>   static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>>>>>                             u64 flags)
>>>>>   {
>>>>> +     union {
>>>>> +             struct iphdr *v4;
>>>>> +             struct ipv6hdr *v6;
>>>>> +             unsigned char *hdr;
>>>>> +     } ip;
>>>>> +     __be16 proto;
>>>>>       int ret;
>>>>
>>>>>       if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
>>>>> @@ -3512,10 +3518,19 @@ static int bpf_skb_net_shrink(struct sk_buff
>>>>> *skb, u32 off, u32 len_diff,
>>>>>       if (unlikely(ret < 0))
>>>>>               return ret;
>>>>
>>>>> +     ip.hdr = skb_inner_network_header(skb);
>>>>> +     if (ip.v4->version == 4)
>>>>> +             proto = htons(ETH_P_IP);
>>>>> +     else
>>>>> +             proto = htons(ETH_P_IPV6);
>>>>> +
>>>>>       ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
>>>>>       if (unlikely(ret < 0))
>>>>>               return ret;
>>>>
>>>>> +     /* Match skb->protocol to new outer l3 protocol */
>>>>> +     skb->protocol = proto;
>>>>> +
>>>>>       if (skb_is_gso(skb)) {
>>>>>               struct skb_shared_info *shinfo = skb_shinfo(skb);
>>>>
>>>>> @@ -3578,10 +3593,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
>>>>> skb, s32, len_diff,
>>>>>          u32, mode, u64, flags)
>>>>>   {
>>>>>       u32 len_cur, len_diff_abs = abs(len_diff);
>>>>> -     u32 len_min = bpf_skb_net_base_len(skb);
>>>>> -     u32 len_max = BPF_SKB_MAX_LEN;
>>>>> +     u32 len_min, len_max = BPF_SKB_MAX_LEN;
>>>>>       __be16 proto = skb->protocol;
>>>>>       bool shrink = len_diff < 0;
>>>>> +     union {
>>>>> +             struct iphdr *v4;
>>>>> +             struct ipv6hdr *v6;
>>>>> +             unsigned char *hdr;
>>>>> +     } ip;
>>>>>       u32 off;
>>>>>       int ret;
>>>>
>>>>> @@ -3594,6 +3613,9 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
>>>>> skb, s32, len_diff,
>>>>>                    proto != htons(ETH_P_IPV6)))
>>>>>               return -ENOTSUPP;
>>>>
>>>>> +     if (unlikely(shrink && !skb->encapsulation))
>>>>> +             return -ENOTSUPP;
>>>>> +
>>>
>>> This new restriction might break existing users.
>>>
>>> There is no pre-existing requirement that shrink is used solely with
>>> packets encapsulated by the protocol stack.
>>>
>>> Indeed, skb->encapsulation is likely not set on packets arriving from
>>> the wire, even if encapsulated. Referring to your comment "Main use
>>> case is for using cls_bpf on ingress hook to decapsulate"
>>>
>>> Can a combination of the existing bpf_skb_adjust_room and
>>> bpf_skb_change_proto address your problem?
>>
>> Hello Willem,
>>
>> I think combination bpf_skb_adjust_room and bpf_skb_change_proto can not
>> address my problem.
>>
>> Now, bpf_skb_adjust_room() would fail for "len_cur - len_diff_abs < len_min"
>> when decap ipip6 packet, because "len_min" should be sizeof(struct iphdr)
>> but not sizeof(struct ipv6hdr).
>>
>> We can remove skb->encapsulation restriction and parse outer and inner IP
>> header to determine ipip6 and ip6ip packets. As following:
> 
> Adding logic for network layer protocol conversion like this looks
> good to me. bpf_skb_adjust_room already has a few other metadata
> quirks.
> 
> But like those, let's make this intent explicit: define a new flag
> that requests this behavior.

Hello Willem,

I think you prefer like this:

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2644,6 +2644,11 @@ union bpf_attr {
  *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *               L2 type as Ethernet.
  *
+ *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *                Indicates the new IP header version after decapsulate the
+ *                outer IP header.
+ *
  *             A call to this helper is susceptible to change the underlying
  *             packet buffer. Therefore, at load time, all checks on pointers
  *             previously done by the verifier are invalidated and must be
@@ -5803,6 +5808,8 @@ enum {
        BPF_F_ADJ_ROOM_ENCAP_L4_UDP     = (1ULL << 4),
        BPF_F_ADJ_ROOM_NO_CSUM_RESET    = (1ULL << 5),
        BPF_F_ADJ_ROOM_ENCAP_L2_ETH     = (1ULL << 6),
+       BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
+       BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
 };

 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 43cc1fe58a2c..0bbe5e67337c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3381,13 +3381,17 @@ static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
 #define BPF_F_ADJ_ROOM_ENCAP_L3_MASK   (BPF_F_ADJ_ROOM_ENCAP_L3_IPV4 | \
                                         BPF_F_ADJ_ROOM_ENCAP_L3_IPV6)

+#define BPF_F_ADJ_ROOM_DECAP_L3_MASK   (BPF_F_ADJ_ROOM_DECAP_L3_IPV4 | \
+                                        BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
+
 #define BPF_F_ADJ_ROOM_MASK            (BPF_F_ADJ_ROOM_FIXED_GSO | \
                                         BPF_F_ADJ_ROOM_ENCAP_L3_MASK | \
                                         BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
                                         BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
                                         BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
                                         BPF_F_ADJ_ROOM_ENCAP_L2( \
-                                         BPF_ADJ_ROOM_ENCAP_L2_MASK))
+                                         BPF_ADJ_ROOM_ENCAP_L2_MASK) | \
+                                        BPF_F_ADJ_ROOM_DECAP_L3_MASK)

 static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
                            u64 flags)
@@ -3501,6 +3505,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
        int ret;

        if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
+                              BPF_F_ADJ_ROOM_DECAP_L3_MASK |
                               BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
                return -EINVAL;

@@ -3519,6 +3524,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
        if (unlikely(ret < 0))
                return ret;

+       /* Match skb->protocol to new outer l3 protocol */
+       if (skb->protocol == htons(ETH_P_IP) &&
+           flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6)
+               skb->protocol = htons(ETH_P_IPV6);
+       else if (skb->protocol == htons(ETH_P_IPV6) &&
+                flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4)
+               skb->protocol = htons(ETH_P_IP);
+
        if (skb_is_gso(skb)) {
                struct skb_shared_info *shinfo = skb_shinfo(skb);

@@ -3597,6 +3610,10 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
                     proto != htons(ETH_P_IPV6)))
                return -ENOTSUPP;

+       if (unlikely(shrink && flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4 &&
+                    flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6))
+               return -EINVAL;
+
        off = skb_mac_header_len(skb);
        switch (mode) {
        case BPF_ADJ_ROOM_NET:
@@ -3608,6 +3625,16 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
                return -ENOTSUPP;
        }

+       if (shrink) {
+               if (proto == htons(ETH_P_IP) &&
+                   flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV6) {
+                       len_min = sizeof(struct ipv6hdr);
+               } else if (proto == htons(ETH_P_IPV6) &&
+                          flags & BPF_F_ADJ_ROOM_DECAP_L3_IPV4) {
+                       len_min = sizeof(struct iphdr);
+               }
+       }
+
        len_cur = skb->len - skb_network_offset(skb);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..041361bc6ccf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2644,6 +2644,11 @@ union bpf_attr {
  *               Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
  *               L2 type as Ethernet.
  *
+ *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
+ *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
+ *                Indicates the new IP header version after decapsulate the
+ *                outer IP header.
+ *
  *             A call to this helper is susceptible to change the underlying
  *             packet buffer. Therefore, at load time, all checks on pointers
  *             previously done by the verifier are invalidated and must be
@@ -5803,6 +5808,8 @@ enum {
        BPF_F_ADJ_ROOM_ENCAP_L4_UDP     = (1ULL << 4),
        BPF_F_ADJ_ROOM_NO_CSUM_RESET    = (1ULL << 5),
        BPF_F_ADJ_ROOM_ENCAP_L2_ETH     = (1ULL << 6),
+       BPF_F_ADJ_ROOM_DECAP_L3_IPV4    = (1ULL << 7),
+       BPF_F_ADJ_ROOM_DECAP_L3_IPV6    = (1ULL << 8),
 };

 enum {

Thank you!

> 
> Let's avoid introducing a new union. Just use check (ip_hdr(skb)->version == 4).
> 
>>
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3498,6 +3498,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
>>  static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>>                               u64 flags)
>>  {
>> +       union {
>> +               struct iphdr *v4;
>> +               struct ipv6hdr *v6;
>> +               unsigned char *hdr;
>> +       } ip;
>> +       __be16 proto;
>>         int ret;
>>
>>         if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
>> @@ -3515,10 +3521,23 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>>         if (unlikely(ret < 0))
>>                 return ret;
>>
>> +       ip.hdr = skb_network_header(skb);
>> +       if (ip.v4->version == 4) {
>> +               if (ip.v4->protocol == IPPROTO_IPV6)
>> +                       proto = htons(ETH_P_IPV6);
>> +       } else {
>> +               struct ipv6_opt_hdr *opt_hdr = (struct ipv6_opt_hdr *)(skb_network_header(skb) + sizeof(struct ipv6hdr));
>> +               if (ip.v6->nexthdr == NEXTHDR_DEST && opt_hdr->nexthdr == NEXTHDR_IPV4)
>> +                       proto = htons(ETH_P_IP);
>> +       }
>> +
>>         ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
>>         if (unlikely(ret < 0))
>>                 return ret;
>>
>> +       /* Match skb->protocol to new outer l3 protocol */
>> +       skb->protocol = proto;
>> +
>>         if (skb_is_gso(skb)) {
>>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>>
>> @@ -3585,6 +3604,11 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>         u32 len_max = BPF_SKB_MAX_LEN;
>>         __be16 proto = skb->protocol;
>>         bool shrink = len_diff < 0;
>> +       union {
>> +               struct iphdr *v4;
>> +               struct ipv6hdr *v6;
>> +               unsigned char *hdr;
>> +       } ip;
>>         u32 off;
>>         int ret;
>>
>> @@ -3608,6 +3632,19 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>>                 return -ENOTSUPP;
>>         }
>>
>> +       if (shrink) {
>> +               ip.hdr = skb_network_header(skb);
>> +               if (ip.v4->version == 4) {
>> +                       if (ip.v4->protocol == IPPROTO_IPV6)
>> +                               len_min = sizeof(struct ipv6hdr);
>> +               } else {
>> +                       struct ipv6_opt_hdr *opt_hdr = (struct ipv6_opt_hdr *)(skb_network_header(skb) + sizeof(struct ipv6hdr));
>> +                       if (ip.v6->nexthdr == NEXTHDR_DEST && opt_hdr->nexthdr == NEXTHDR_IPV4) {
>> +                               len_min = sizeof(struct iphdr);
>> +                       }
>> +               }
>> +       }
>> +
>>         len_cur = skb->len - skb_network_offset(skb);
>>
>>
>> Look forward to your comments and suggestions.
>>
>> Thank you!
>>
>>>
>>>>>       off = skb_mac_header_len(skb);
>>>>>       switch (mode) {
>>>>>       case BPF_ADJ_ROOM_NET:
>>>>> @@ -3605,6 +3627,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
>>>>> skb, s32, len_diff,
>>>>>               return -ENOTSUPP;
>>>>>       }
>>>>
>>>>> +     if (shrink) {
>>>>> +             ip.hdr = skb_inner_network_header(skb);
>>>>> +             if (ip.v4->version == 4)
>>>>> +                     len_min = sizeof(struct iphdr);
>>>>> +             else
>>>>> +                     len_min = sizeof(struct ipv6hdr);
>>>>> +     }
>>>>> +
>>>>>       len_cur = skb->len - skb_network_offset(skb);
>>>>>       if ((shrink && (len_diff_abs >= len_cur ||
>>>>>                       len_cur - len_diff_abs < len_min)) ||
>>>>> --
>>>>> 2.25.1
>>>>
>>> .
>>>
> .
> 
