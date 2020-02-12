Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0270215A594
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBLKDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:03:40 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:44996 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgBLKDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:03:40 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j1orl-0003s6-Kq; Wed, 12 Feb 2020 10:03:33 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j1orj-0008KU-Ct; Wed, 12 Feb 2020 10:03:33 +0000
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <8e730fe1-3129-de8d-bcb6-d5e10695238a@cambridgegreys.com>
Date:   Wed, 12 Feb 2020 10:03:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211053502-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
>> On 11/02/2020 02:51, Jason Wang wrote:
>>>
>>> On 2020/2/11 上午12:55, Anton Ivanov wrote:
>>>>
>>>>
>>>> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>
>>>>> Some of the frames marked as GSO which arrive at
>>>>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
>>>>> fragments (data_len = 0) and length significantly shorter
>>>>> than the MTU (752 in my experiments).
>>>>>
>>>>> This is observed on raw sockets reading off vEth interfaces
>>>>> in all 4.x and 5.x kernels I tested.
>>>>>
>>>>> These frames are reported as invalid while they are in fact
>>>>> gso-less frames.
>>>>>
>>>>> This patch marks the vnet header as no-GSO for them instead
>>>>> of reporting it as invalid.
>>>>>
>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>> ---
>>>>>    include/linux/virtio_net.h | 8 ++++++--
>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>>>>> index 0d1fe9297ac6..d90d5cff1b9a 100644
>>>>> --- a/include/linux/virtio_net.h
>>>>> +++ b/include/linux/virtio_net.h
>>>>> @@ -112,8 +112,12 @@ static inline int
>>>>> virtio_net_hdr_from_skb(const struct sk_buff *skb,
>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>>>>>            else if (sinfo->gso_type & SKB_GSO_TCPV6)
>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>>>>> -        else
>>>>> -            return -EINVAL;
>>>>> +        else {
>>>>> +            if (skb->data_len == 0)
>>>>> +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
>>>>> +            else
>>>>> +                return -EINVAL;
>>>>> +        }
>>>>>            if (sinfo->gso_type & SKB_GSO_TCP_ECN)
>>>>>                hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
>>>>>        } else
>>>>>
>>>>
>>>> ping.
>>>>
>>>
>>> Do you mean gso_size is set but gso_type is not? Looks like a bug
>>> elsewhere.
>>>
>>> Thanks
>>>
>>>
>> Yes.
>>
>> I could not trace it where it is coming from.
>>
>> I see it when doing recvmmsg on raw sockets in the UML vector network
>> drivers.
>>
> 
> I think we need to find the culprit and fix it there, lots of other things
> can break otherwise.
> Just printing out skb->dev->name should do the trick, no?

I will rebuild my rig and retest (it's been a while since I worked on this bug).

In theory, it should be veth - the test is over a vEth pair and all frames are locally originated by iperf.

In practice - I will retest and post the results sometimes later today.

Brgds,

 >
> 
> 
>> -- 
>> Anton R. Ivanov
>> Cambridgegreys Limited. Registered in England. Company Number 10273661
>> https://www.cambridgegreys.com/
> 
> 
> _______________________________________________
> linux-um mailing list
> linux-um@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-um
> 

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
