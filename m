Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF002A66F4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgKDO7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:59:49 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:9105 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgKDO7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604501984;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=s61oapLehqdNJ1HvZECuYdtixsoj5BMSG14Qxs8/3wQ=;
        b=c3osscKyCq14J7YjssG4mq04HtWkP/OYeJU4n40zFWLyr8IFh9v0UOXlltcSypBDyB
        BhAgx+xnd+eojFmn6ocKngoBf9k6HxtPYavkAd0Y7IYPkZ7C+qR5wT0C1L24vZZHRqWw
        qIrHFipsZlMITSTpQxgLbTF0+D9xAZxH2Qy1+E6XuqYA+/2wsu1tyNyNxwh+hnLilHhC
        eJmuhe8AJaRu3DLy7OBKHAeimzXKMJtwStgJ36xUZuBbZ5UMb6G3wpOFvhGlN5h07J2D
        tU1kO/WiGcVl2RfCTtuMykAJR3B1SO8b6Inzuf7ya/gnSI553Go/PAdbeT8jVL1sq/w3
        NFOw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVNiO8lopw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.3.0 DYNA|AUTH)
        with ESMTPSA id L010bewA4ExVJrK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 4 Nov 2020 15:59:31 +0100 (CET)
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Vincent Mailhol <mailhol.vincent@wanadoo.fr>
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
Date:   Wed, 4 Nov 2020 15:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On 04.11.20 09:16, Eric Dumazet wrote:
> On Wed, Nov 4, 2020 at 2:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue,  3 Nov 2020 23:06:14 +0100 Marc Kleine-Budde wrote:
>>> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>>
>>> If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
>>> not always, the case), the 'WARN_ON(in_irq)' in
>>> net/core/skbuff.c#skb_release_head_state() might be triggered, under network
>>> congestion circumstances, together with the potential risk of a NULL pointer
>>> dereference.
>>>
>>> The root cause of this issue is the call to kfree_skb() instead of
>>> dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().
>>>
>>> This patch prevents the skb to be freed within the call to netif_rx() by
>>> incrementing its reference count with skb_get(). The skb is finally freed by
>>> one of the in-irq-context safe functions: dev_consume_skb_any() or
>>> dev_kfree_skb_any(). The "any" version is used because some drivers might call
>>> can_get_echo_skb() in a normal context.
>>>
>>> The reason for this issue to occur is that initially, in the core network
>>> stack, loopback skb were not supposed to be received in hardware IRQ context.
>>> The CAN stack is an exeption.
>>>
>>> This bug was previously reported back in 2017 in [1] but the proposed patch
>>> never got accepted.
>>>
>>> While [1] directly modifies net/core/dev.c, we try to propose here a
>>> smoother modification local to CAN network stack (the assumption
>>> behind is that only CAN devices are affected by this issue).
>>>
>>> [1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com
>>>
>>> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>> Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
>>> Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>
>> Hm... Why do we receive a skb with a socket attached?
>>
>> At a quick glance this is some loopback, so shouldn't we skb_orphan()
>> in the xmit function instead?
> 
> Yes this would work, this seems the safest way, loopback_xmit() is a
> good template for this.
> 
>>
>> Otherwise we should probably fix this in enqueue_to_backlog().
> 
> This is dangerous.
> 
> If we drop packets under flood because the per-cpu backlog is full,
> we might also be in _big_ trouble if the per-cpu
> softnet_data.completion_queue is filling,
> since we do not have a limit on this list.
> 
> What could happen is that when the memory is finally exhausted and no
> more skb can be fed
> to netif_rx(), a big latency spike would happen when
> softnet_data.completion_queue
> can finally be purged in one shot.
> 
> So skb_orphan(skb) in CAN before calling netif_rx() is better IMO.
> 

Unfortunately you missed the answer from Vincent, why skb_orphan() does 
not work here:

https://lore.kernel.org/linux-can/CAMZ6RqJyZTcqZcq6jEzm5LLM_MMe=dYDbwvv=Y+dBR0drWuFmw@mail.gmail.com/

Best regards,
Oliver

>>
>>> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
>>> index b70ded3760f2..73cfcd7e9517 100644
>>> --- a/drivers/net/can/dev.c
>>> +++ b/drivers/net/can/dev.c
>>> @@ -538,7 +538,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
>>>        if (!skb)
>>>                return 0;
>>>
>>> -     netif_rx(skb);
>>> +     skb_get(skb);
>>> +     if (netif_rx(skb) == NET_RX_SUCCESS)
>>> +             dev_consume_skb_any(skb);
>>> +     else
>>> +             dev_kfree_skb_any(skb);
>>>
>>>        return len;
>>>   }
>>
