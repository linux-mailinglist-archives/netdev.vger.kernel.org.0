Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02015C3C8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgBMPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:44:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43643 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgBMPoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:44:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id u12so2942616pgb.10
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PtnJAjzh7uqew0zNNLE9zyJ6OhNOss0AZTQl+TfTd/Y=;
        b=BC9xuuXPOg+0HI+XQUJ1gesfGIHzwpFCiwG4bPl5frKuc9SKlWPqy+1QBSJqvuyfKo
         zAc9puAbANuhaLhdzS6DZHr7uDiMgvTtfvjJ3H/b6czwTvKdWGBRafMN+xrsaehRQw5E
         YE743nJ9vwnqOsReRGhIqJy6Vnx13SXUAyh3PmrGx+LSWhXL9qi+AVB5TqDLGQeJPZwV
         YrIbhN7abwCw9N9QatTQm3fVmFTOuC5SSo/cWdCenCI1PyMV3pBUQK24apcjU24qWm4P
         b0yKNw+ibivfcqNv6W+UvY4YDJQAohzKXdLv7jtveCIK5C9wc9s5lrKvVyoiwf7EXNkF
         dsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PtnJAjzh7uqew0zNNLE9zyJ6OhNOss0AZTQl+TfTd/Y=;
        b=NlKhlPu8b84/R+W6eaRADqo6HkoIsqnd1W9jmy3D1byq8AUx9gnvp36A7PiESxztH8
         o4WH27VXdpJ8/UDe8nMEIPm3UguYfpGZgWH+d0rBx3zx+A6R/2AsgmqlOjR/Kila5ms7
         OVhvWAPV+6wMrqWIq2pe6/7ZMQDXqw3mnmVnsEszt6v7T58cLo84wwML8RFWyhQiyL2A
         4Gpa+P2Gij4wVcmUvFfT/V5kLGwZMbVb4oJmdBJBEERTB5QB0NKrfMCot6eej8i2o7yM
         s8UIBDcwgxwj0mbLKEB2GEXTaAQyS84bQcWfIpl9xN+saVMJ7ixBV+ke3xbSh6g+TClm
         F7BA==
X-Gm-Message-State: APjAAAU6XRtZc+JjOe+7LAtnfonKlPY94K6+uhF7KsHrVQsaTXCDgt/l
        oWOKFu8y7buC5VbLrQ619pY=
X-Google-Smtp-Source: APXvYqx9/s0ULmzrD5iCc+gB2s+WOp89Vh5k0Y41cUHGk5Ox3G0Q4jhV5kQoSEmErcYJ2dVuJnSXxQ==
X-Received: by 2002:a63:ca04:: with SMTP id n4mr14990408pgi.110.1581608650773;
        Thu, 13 Feb 2020 07:44:10 -0800 (PST)
Received: from [192.168.84.170] (8.100.247.35.bc.googleusercontent.com. [35.247.100.8])
        by smtp.gmail.com with ESMTPSA id b25sm3552541pfo.38.2020.02.13.07.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:44:10 -0800 (PST)
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
 <20200213045937-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <94fb9656-99ee-a001-e428-9d76c3620e61@gmail.com>
Date:   Thu, 13 Feb 2020 07:44:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213045937-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/20 2:00 AM, Michael S. Tsirkin wrote:
> On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
>>
>>
>> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
>>> On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
>>>> On 11/02/2020 02:51, Jason Wang wrote:
>>>>>
>>>>> On 2020/2/11 上午12:55, Anton Ivanov wrote:
>>>>>>
>>>>>>
>>>>>> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
>>>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>>
>>>>>>> Some of the frames marked as GSO which arrive at
>>>>>>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
>>>>>>> fragments (data_len = 0) and length significantly shorter
>>>>>>> than the MTU (752 in my experiments).
>>>>>>>
>>>>>>> This is observed on raw sockets reading off vEth interfaces
>>>>>>> in all 4.x and 5.x kernels I tested.
>>>>>>>
>>>>>>> These frames are reported as invalid while they are in fact
>>>>>>> gso-less frames.
>>>>>>>
>>>>>>> This patch marks the vnet header as no-GSO for them instead
>>>>>>> of reporting it as invalid.
>>>>>>>
>>>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>> ---
>>>>>>>    include/linux/virtio_net.h | 8 ++++++--
>>>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>>>>>>> index 0d1fe9297ac6..d90d5cff1b9a 100644
>>>>>>> --- a/include/linux/virtio_net.h
>>>>>>> +++ b/include/linux/virtio_net.h
>>>>>>> @@ -112,8 +112,12 @@ static inline int
>>>>>>> virtio_net_hdr_from_skb(const struct sk_buff *skb,
>>>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>>>>>>>            else if (sinfo->gso_type & SKB_GSO_TCPV6)
>>>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>>>>>>> -        else
>>>>>>> -            return -EINVAL;
>>>>>>> +        else {
>>>>>>> +            if (skb->data_len == 0)
>>>>>>> +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
>>>>>>> +            else
>>>>>>> +                return -EINVAL;
>>>>>>> +        }
>>>>>>>            if (sinfo->gso_type & SKB_GSO_TCP_ECN)
>>>>>>>                hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
>>>>>>>        } else
>>>>>>>
>>>>>>
>>>>>> ping.
>>>>>>
>>>>>
>>>>> Do you mean gso_size is set but gso_type is not? Looks like a bug
>>>>> elsewhere.
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>> Yes.
>>>>
>>>> I could not trace it where it is coming from.
>>>>
>>>> I see it when doing recvmmsg on raw sockets in the UML vector network
>>>> drivers.
>>>>
>>>
>>> I think we need to find the culprit and fix it there, lots of other things
>>> can break otherwise.
>>> Just printing out skb->dev->name should do the trick, no?
>>
>> The printk in virtio_net_hdr_from_skb says NULL.
>>
>> That is probably normal for a locally originated frame.
>>
>> I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
>>
>> A,
> 
> OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
> when gso_type is 0?
>

Correct way to determine if a packet is a gso one is by looking at gso_size.
Then only it is legal looking at gso_type


static inline bool skb_is_gso(const struct sk_buff *skb)
{
    return skb_shinfo(skb)->gso_size;
}

/* Note: Should be called only if skb_is_gso(skb) is true */
static inline bool skb_is_gso_v6(const struct sk_buff *skb)
...


There is absolutely no relation between GSO and skb->data_len, skb can be linearized
for various orthogonal reasons.


