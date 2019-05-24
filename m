Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC27D28FBC
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 05:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbfEXDyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 23:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbfEXDyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 23:54:16 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9184E3082207;
        Fri, 24 May 2019 03:54:15 +0000 (UTC)
Received: from [10.72.12.217] (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B86960C18;
        Fri, 24 May 2019 03:54:02 +0000 (UTC)
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
To:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk> <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
 <20190523152927.14bf7ed1@carbon>
 <c902c0f4-947b-ba9e-7baa-628ba87a8f01@gmail.com>
 <94046143-f05d-77db-88c4-7bd62f2c98d4@redhat.com>
 <c560baa0-8a71-4ab3-7107-c831d6ef8bb8@lab.ntt.co.jp>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1035faf0-3fd2-4986-540e-b76ab53fe99b@redhat.com>
Date:   Fri, 24 May 2019 11:54:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c560baa0-8a71-4ab3-7107-c831d6ef8bb8@lab.ntt.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 24 May 2019 03:54:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/24 上午11:28, Toshiaki Makita wrote:
> On 2019/05/24 12:13, Jason Wang wrote:
>> On 2019/5/23 下午9:51, Toshiaki Makita wrote:
>>> On 19/05/23 (木) 22:29:27, Jesper Dangaard Brouer wrote:
>>>> On Thu, 23 May 2019 20:35:50 +0900
>>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:
>>>>
>>>>> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
>>>>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
>>>>>>> This improves XDP_TX performance by about 8%.
>>>>>>>
>>>>>>> Here are single core XDP_TX test results. CPU consumptions are taken
>>>>>>> from "perf report --no-child".
>>>>>>>
>>>>>>> - Before:
>>>>>>>
>>>>>>>     7.26 Mpps
>>>>>>>
>>>>>>>     _raw_spin_lock  7.83%
>>>>>>>     veth_xdp_xmit  12.23%
>>>>>>>
>>>>>>> - After:
>>>>>>>
>>>>>>>     7.84 Mpps
>>>>>>>
>>>>>>>     _raw_spin_lock  1.17%
>>>>>>>     veth_xdp_xmit   6.45%
>>>>>>>
>>>>>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>>>>>>> ---
>>>>>>>    drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>>>>>>    1 file changed, 25 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>>>>> index 52110e5..4edc75f 100644
>>>>>>> --- a/drivers/net/veth.c
>>>>>>> +++ b/drivers/net/veth.c
>>>>>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device
>>>>>>> *dev, int n,
>>>>>>>        return ret;
>>>>>>>    }
>>>>>>>    +static void veth_xdp_flush_bq(struct net_device *dev)
>>>>>>> +{
>>>>>>> +    struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>>>>>>> +    int sent, i, err = 0;
>>>>>>> +
>>>>>>> +    sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
>>>>>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
>>>>>> you're introducing an additional per-cpu bulk queue, only to avoid
>>>>>> lock
>>>>>> contention around the existing pointer ring. But the pointer ring is
>>>>>> per-rq, so if you have lock contention, this means you must have
>>>>>> multiple CPUs servicing the same rq, no?
>>>>> Yes, it's possible. Not recommended though.
>>>>>
>>>> I think the general per-cpu TX bulk queue is overkill.  There is a loop
>>>> over packets in veth_xdp_rcv(struct veth_rq *rq, budget, *status), and
>>>> the caller veth_poll() will call veth_xdp_flush(rq->dev).
>>>>
>>>> Why can't you store this "temp" bulk array in struct veth_rq ?
>>> Of course I can. But I thought tun has the same problem and we can
>>> decrease memory footprint by sharing the same storage between devices.
>>
>> For TUN and for its fast path where vhost passes a bulk of XDP frames
>> (through msg_control) to us, we probably just need a temporary bulk
>> array in tun_xdp_one() instead of a global one. I can post patch or
>> maybe you if you're interested in this.
> Of course you/I can. What I'm concerned is that could be waste of cache
> line when softirq runs veth napi handler and then tun napi handler.
>

Well, technically the bulk queue passed to TUN could be reused. I admit 
it may save cacheline in ideal case but I wonder how much we could gain 
on real workload. (Note TUN doesn't use napi handler to do XDP, it has a 
NAPI mode but it was mainly used for hardening and XDP was not 
implemented there, maybe we should fix this).

Thanks


>> Thanks
>>
>>
>>> Or if other devices want to reduce queues so that we can use XDP on
>>> many-cpu servers and introduce locks, we can use this storage for that
>>> case as well.
>>>
>>> Still do you prefer veth-specific solution?
>>>
>>>> You could even alloc/create it on the stack of veth_poll() and send it
>>>> along via a pointer to veth_xdp_rcv).
>>>>
>>> Toshiaki Makita
>>
