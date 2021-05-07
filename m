Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589143762A9
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 11:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhEGJQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 05:16:43 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3858 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhEGJPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 05:15:54 -0400
Received: from dggeml701-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fc4Ng73b2z5y9B;
        Fri,  7 May 2021 17:08:03 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml701-chm.china.huawei.com (10.3.17.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 7 May 2021 17:11:20 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 7 May 2021
 17:11:20 +0800
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>,
        'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     'Daniel Borkmann' <daniel@iogearbox.net>,
        'bpf' <bpf@vger.kernel.org>,
        'Alexei Starovoitov' <ast@kernel.org>,
        'Andrii Nakryiko' <andrii@kernel.org>,
        'Martin KaFai Lau' <kafai@fb.com>,
        'Song Liu' <songliubraving@fb.com>,
        'Yonghong Song' <yhs@fb.com>,
        'John Fastabend' <john.fastabend@gmail.com>,
        'KP Singh' <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Network Development' <netdev@vger.kernel.org>,
        'linux-kernel' <linux-kernel@vger.kernel.org>
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
 <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
 <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com>
 <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com>
 <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
 <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
 <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
 <007001d7431a$96281960$c2784c20$@samsung.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5824b2ab-46a2-a70c-0ac9-8c5eb0a9665a@huawei.com>
Date:   Fri, 7 May 2021 17:11:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <007001d7431a$96281960$c2784c20$@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/7 16:25, Dongseok Yi wrote:
> On Thu, May 06, 2021 at 09:53:45PM -0400, Willem de Bruijn wrote:
>> On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>
>>> On 2021/5/7 9:25, Willem de Bruijn wrote:
>>>>>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
>>>>>>> data_len could be 8 if server sent a small size packet and it is GROed
>>>>>>> to head_skb.
>>>>>>>
>>>>>>> Please let me know if I am missing something.
>>>>>>
>>>>>> This is my understanding of the data path. This is a forwarding path
>>>>>> for TCP traffic.
>>>>>>
>>>>>> GRO is enabled and will coalesce multiple segments into a single large
>>>>>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
>>>>>> + 20.
>>>>>>
>>>>>> Somewhere between GRO and GSO you have a BPF program that converts the
>>>>>> IPv6 address to IPv4.
>>>>>
>>>>> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
>>>>> GSO.
>>>>>
>>>>>>
>>>>>> There is no concept of head_skb at the time of this BPF program. It is
>>>>>> a single SKB, with an skb linear part and multiple data items in the
>>>>>> frags (no frag_list).
>>>>>
>>>>> Sorry for the confusion. head_skb what I mentioned was a skb linear
>>>>> part. I'm considering a single SKB with frags too.
>>>>>
>>>>>>
>>>>>> When entering the GSO stack, this single skb now has a payload length
>>>>>> < MSS. So it would just make a valid TCP packet on its own?
>>>>>>
>>>>>> skb_gro_len is only relevant inside the GRO stack. It internally casts
>>>>>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
>>>>>> reused for other purposes later by other layers of the datapath. It is
>>>>>> not safe to read this inside bpf_skb_proto_6_to_4.
>>>>>
>>>>> The condition what I made uses skb->data_len not skb_gro_len. Does
>>>>> skb->data_len have a different meaning on each layer? As I know,
>>>>> data_len indicates the amount of frags or frag_list. skb->data_len
>>>>> should be > 20 in the sample case because the payload size of the skb
>>>>> linear part is the same with mss.
>>>>
>>>> Ah, got it.
>>>>
>>>> data_len is the length of the skb minus the length in the skb linear
>>>> section (as seen in skb_headlen).
>>>>
>>>> So this gso skb consists of two segments, the first one entirely
>>>> linear, the payload of the second is in skb_shinfo(skb)->frags[0].
>>>>
>>>> It is not guaranteed that gso skbs built from two individual skbs end
>>>> up looking like that. Only protocol headers in the linear segment and
>>>> the payload of both in frags is common.
>>>>
>>>>> We can modify netif_needs_gso as another option to hit
>>>>> skb_needs_linearize in validate_xmit_skb. But I think we should compare
>>>>> skb->gso_size and skb->data_len too to check if mss exceed a payload
>>>>> size.
>>>>
>>>> The rest of the stack does not build such gso packets with payload len
>>>> < mss, so we should not have to add workarounds in the gso hot path
>>>> for this.
>>>>
>>>> Also no need to linearize this skb. I think that if the bpf program
>>>> would just clear the gso type, the packet would be sent correctly.
>>>> Unless I'm missing something.
>>>
>>> Does the checksum/len field in ip and tcp/udp header need adjusting
>>> before clearing gso type as the packet has became bigger?
>>
>> gro takes care of this. see for instance inet_gro_complete for updates
>> to the ip header.
> 
> I think clearing the gso type will get an error at tcp4_gso_segment
> because netif_needs_gso returns true in validate_xmit_skb.

So the bpf_skb_proto_6_to_4() is called after validate_xmit_skb() and
before tcp4_gso_segment()?
If Yes, clearing the gso type here does not seem to help.

> 
>>
>>> Also, instead of testing skb->data_len, may test the skb->len?
>>>
>>> skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
>>
>> Yes. Essentially doing the same calculation as the gso code that is
>> causing the packet to be dropped.
> 
> BPF program is usually out of control. Can we take a general approach?
> The below 2 cases has no issue when mss upgrading.
> 1) skb->data_len > mss + 20
> 2) skb->data_len < mss && skb->data_len > 20
> The corner case is when
> 3) skb->data_len > mss && skb->data_len < mss + 20

As my understanding:

Usually skb_headlen(skb) >= (mac header + ip/ipv6 header + udp/tcp header),
other than that, there is no other guarantee as long as:
skb->len = skb_headlen(skb) + skb->data_len

So the cases should be:
1. skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
2. skb->len - (mac header + ip/ipv6 header + udp/tcp header) <= mss + len_diff

The corner case is case 2.

> 
> But to cover #3 case, we should check the condition Yunsheng Lin said.
> What if we do mss upgrading for both #1 and #2 cases only?
> 
> +               unsigned short off_len = skb->data_len > shinfo->gso_size ?
> +                       shinfo->gso_size : 0;
> [...]
>                 /* Due to IPv4 header, MSS can be upgraded. */
> -               skb_increase_gso_size(shinfo, len_diff);
> +               if (skb->data_len - off_len > len_diff)
> +                       skb_increase_gso_size(shinfo, len_diff);
> 
>>
>>>>
>>>> But I don't mean to argue that it should do that in production.
>>>> Instead, not playing mss games would solve this and stay close to the
>>>> original datapath if no bpf program had been present. Including
>>>> maintaining the GSO invariant of sending out the same chain of packets
>>>> as received (bar the IPv6 to IPv4 change).
>>>>
>>>> This could be achieved by adding support for the flag
>>>> BPF_F_ADJ_ROOM_FIXED_GSO in the flags field of bpf_skb_change_proto.
>>>> And similar to bpf_skb_net_shrink:
>>>>
>>>>                 /* Due to header shrink, MSS can be upgraded. */
>>>>                 if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
>>>>                         skb_increase_gso_size(shinfo, len_diff);
>>>>
>>>> The other case, from IPv4 to IPv6 is more difficult to address, as not
>>>> reducing the MSS will result in packets exceeding MTU. That calls for
>>>> workarounds like MSS clamping. Anyway, that is out of scope here.
>>>>
>>>>
>>>>
>>>>>>
>>>>>>
>>>>>>>>
>>>>>>>> One simple solution if this packet no longer needs to be segmented
>>>>>>>> might be to reset the gso_type completely.
>>>>>>>
>>>>>>> I am not sure gso_type can be cleared even when GSO is needed.
>>>>>>>
>>>>>>>>
>>>>>>>> In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
>>>>>>>> converting from IPv6 to IPv4, fixed gso will end up building packets
>>>>>>>> that are slightly below the MTU. That opportunity cost is negligible
>>>>>>>> (especially with TSO). Unfortunately, I see that that flag is
>>>>>>>> available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
>>>>>>>>
>>>>>>>>
>>>>>>>>>>> would increse the gso_size to 1392. tcp_gso_segment will get an error
>>>>>>>>>>> with 1380 <= 1392.
>>>>>>>>>>>
>>>>>>>>>>> Check for the size of GROed payload if it is really bigger than target
>>>>>>>>>>> mss when increase mss.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
>>>>>>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
>>>>>>>>>>> ---
>>>>>>>>>>>   net/core/filter.c | 4 +++-
>>>>>>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>>>>>>> index 9323d34..3f79e3c 100644
>>>>>>>>>>> --- a/net/core/filter.c
>>>>>>>>>>> +++ b/net/core/filter.c
>>>>>>>>>>> @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
>>>>>>>>>>>             }
>>>>>>>>>>>
>>>>>>>>>>>             /* Due to IPv4 header, MSS can be upgraded. */
>>>>>>>>>>> -           skb_increase_gso_size(shinfo, len_diff);
>>>>>>>>>>> +           if (skb->data_len > len_diff)
>>>>>>>>>>
>>>>>>>>>> Could you elaborate some more on what this has to do with data_len specifically
>>>>>>>>>> here? I'm not sure I follow exactly your above commit description. Are you saying
>>>>>>>>>> that you're hitting in tcp_gso_segment():
>>>>>>>>>>
>>>>>>>>>>          [...]
>>>>>>>>>>          mss = skb_shinfo(skb)->gso_size;
>>>>>>>>>>          if (unlikely(skb->len <= mss))
>>>>>>>>>>                  goto out;
>>>>>>>>>>          [...]
>>>>>>>>>
>>>>>>>>> Yes, right
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Please provide more context on the bug, thanks!
>>>>>>>>>
>>>>>>>>> tcp_gso_segment():
>>>>>>>>>         [...]
>>>>>>>>>         __skb_pull(skb, thlen);
>>>>>>>>>
>>>>>>>>>         mss = skb_shinfo(skb)->gso_size;
>>>>>>>>>         if (unlikely(skb->len <= mss))
>>>>>>>>>         [...]
>>>>>>>>>
>>>>>>>>> skb->len will have total GROed TCP payload size after __skb_pull.
>>>>>>>>> skb->len <= mss will not be happened in a normal GROed situation. But
>>>>>>>>> bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
>>>>>>>>> hit an error condition.
>>>>>>>>>
>>>>>>>>> We should ensure the following condition.
>>>>>>>>> total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
>>>>>>>>>
>>>>>>>>> Due to
>>>>>>>>> total GROed TCP payload = the original mss + skb->data_len
>>>>>>>>> IPv6 size - IPv4 size = len_diff
>>>>>>>>>
>>>>>>>>> Finally, we can get the condition.
>>>>>>>>> skb->data_len > len_diff
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> +                   skb_increase_gso_size(shinfo, len_diff);
>>>>>>>>>>> +
>>>>>>>>>>>             /* Header must be checked, and gso_segs recomputed. */
>>>>>>>>>>>             shinfo->gso_type |= SKB_GSO_DODGY;
>>>>>>>>>>>             shinfo->gso_segs = 0;
>>>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>
>>>>>
>>>>
>>>> .
>>>>
>>>
> 
> 
> .
> 

