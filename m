Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35C166734
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgBTTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:33:44 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:40906 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgBTTdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:33:44 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j4rZm-0007Og-Rv; Thu, 20 Feb 2020 19:33:35 +0000
Received: from [151.251.251.9] (helo=[192.168.14.3])
        by jain.kot-begemot.co.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j4rZj-0003iM-W6; Thu, 20 Feb 2020 19:33:34 +0000
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        virtualization@lists.linux-foundation.org
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
 <20200213045937-mutt-send-email-mst@kernel.org>
 <94fb9656-99ee-a001-e428-9d76c3620e61@gmail.com>
 <20200213105010-mutt-send-email-mst@kernel.org>
 <35510da7-08f1-4aa5-c6d6-6bffbccaee0c@cambridgegreys.com>
 <20200220025506-mutt-send-email-mst@kernel.org>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys Limited
Message-ID: <d26515b2-c0f4-195d-f754-caf7aa78ab81@cambridgegreys.com>
Date:   Thu, 20 Feb 2020 19:33:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200220025506-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/02/2020 07:58, Michael S. Tsirkin wrote:
> On Thu, Feb 13, 2020 at 04:23:24PM +0000, Anton Ivanov wrote:
>> On 13/02/2020 15:53, Michael S. Tsirkin wrote:
>>> On Thu, Feb 13, 2020 at 07:44:06AM -0800, Eric Dumazet wrote:
>>>> On 2/13/20 2:00 AM, Michael S. Tsirkin wrote:
>>>>> On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
>>>>>> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
>>>>>>> On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
>>>>>>>> On 11/02/2020 02:51, Jason Wang wrote:
>>>>>>>>> On 2020/2/11 上午12:55, Anton Ivanov wrote:
>>>>>>>>>> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
>>>>>>>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>>>>>>
>>>>>>>>>>> Some of the frames marked as GSO which arrive at
>>>>>>>>>>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
>>>>>>>>>>> fragments (data_len = 0) and length significantly shorter
>>>>>>>>>>> than the MTU (752 in my experiments).
>>>>>>>>>>>
>>>>>>>>>>> This is observed on raw sockets reading off vEth interfaces
>>>>>>>>>>> in all 4.x and 5.x kernels I tested.
>>>>>>>>>>>
>>>>>>>>>>> These frames are reported as invalid while they are in fact
>>>>>>>>>>> gso-less frames.
>>>>>>>>>>>
>>>>>>>>>>> This patch marks the vnet header as no-GSO for them instead
>>>>>>>>>>> of reporting it as invalid.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>>>>>> ---
>>>>>>>>>>>      include/linux/virtio_net.h | 8 ++++++--
>>>>>>>>>>>      1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>>>>>>>>>>> index 0d1fe9297ac6..d90d5cff1b9a 100644
>>>>>>>>>>> --- a/include/linux/virtio_net.h
>>>>>>>>>>> +++ b/include/linux/virtio_net.h
>>>>>>>>>>> @@ -112,8 +112,12 @@ static inline int
>>>>>>>>>>> virtio_net_hdr_from_skb(const struct sk_buff *skb,
>>>>>>>>>>>                  hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>>>>>>>>>>>              else if (sinfo->gso_type & SKB_GSO_TCPV6)
>>>>>>>>>>>                  hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>>>>>>>>>>> -        else
>>>>>>>>>>> -            return -EINVAL;
>>>>>>>>>>> +        else {
>>>>>>>>>>> +            if (skb->data_len == 0)
>>>>>>>>>>> +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
>>>>>>>>>>> +            else
>>>>>>>>>>> +                return -EINVAL;
>>>>>>>>>>> +        }
>>>>>>>>>>>              if (sinfo->gso_type & SKB_GSO_TCP_ECN)
>>>>>>>>>>>                  hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
>>>>>>>>>>>          } else
>>>>>>>>>>>
>>>>>>>>>> ping.
>>>>>>>>>>
>>>>>>>>> Do you mean gso_size is set but gso_type is not? Looks like a bug
>>>>>>>>> elsewhere.
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>
>>>>>>>> Yes.
>>>>>>>>
>>>>>>>> I could not trace it where it is coming from.
>>>>>>>>
>>>>>>>> I see it when doing recvmmsg on raw sockets in the UML vector network
>>>>>>>> drivers.
>>>>>>>>
>>>>>>> I think we need to find the culprit and fix it there, lots of other things
>>>>>>> can break otherwise.
>>>>>>> Just printing out skb->dev->name should do the trick, no?
>>>>>> The printk in virtio_net_hdr_from_skb says NULL.
>>>>>>
>>>>>> That is probably normal for a locally originated frame.
>>>>>>
>>>>>> I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
>>>>>>
>>>>>> A,
>>>>> OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
>>>>> when gso_type is 0?
>>>>>
>>>> Correct way to determine if a packet is a gso one is by looking at gso_size.
>>>> Then only it is legal looking at gso_type
>>>>
>>>>
>>>> static inline bool skb_is_gso(const struct sk_buff *skb)
>>>> {
>>>>       return skb_shinfo(skb)->gso_size;
>>>> }
>>>>
>>>> /* Note: Should be called only if skb_is_gso(skb) is true */
>>>> static inline bool skb_is_gso_v6(const struct sk_buff *skb)
>>>> ...
>>>>
>>>>
>>>> There is absolutely no relation between GSO and skb->data_len, skb can be linearized
>>>> for various orthogonal reasons.
>>> The reported problem is that virtio gets a packet where gso_size
>>> is !0 but gso_type is 0.
>>>
>>> It currently drops these on the assumption that it's some type
>>> of a gso packet it does not know how to handle.
>>>
>>>
>>> So you are saying if skb_is_gso we can still have gso_type set to 0,
>>> and that's an expected configuration?
>>>
>>> So the patch should just be:
>>>
>>>
>>> -        if (skb_is_gso(skb)) {
>>> +        if (skb_is_gso(skb) && sinfo->gso_type) {
>>>
>> Yes, provided that skb_is_gso(skb) and sinfo->gso_type == 0 is a valid state.
>>
>> I agree with Jason, there may be something wrong going on here and we need to find the source which creates these packets.
>>
>> A.
>
> Want to submit a patch to address this for now?

I can do that on Monday - traveling till then.

A.


>
>>> ?
>>>
>>>
>>> _______________________________________________
>>> linux-um mailing list
>>> linux-um@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-um
>> -- 
>> Anton R. Ivanov
>> Cambridgegreys Limited. Registered in England. Company Number 10273661
>> https://www.cambridgegreys.com/
>
> _______________________________________________
> linux-um mailing list
> linux-um@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-um

-- 
Anton R. Ivanov

Cambridge Greys Limited, England and Wales company No 10273661
http://www.cambridgegreys.com/

