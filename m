Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01052AE61
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfE0GK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:10:27 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:53804 "EHLO
        tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfE0GK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:10:27 -0400
Received: from vc1.ecl.ntt.co.jp (vc1.ecl.ntt.co.jp [129.60.86.153])
        by tama50.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4R69pSw023863;
        Mon, 27 May 2019 15:09:51 +0900
Received: from vc1.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id CEE46EA7853;
        Mon, 27 May 2019 15:09:51 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id C3A8AEA7804;
        Mon, 27 May 2019 15:09:51 +0900 (JST)
Received: from [IPv6:::1] (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id B3D0F4001A4;
        Mon, 27 May 2019 15:09:51 +0900 (JST)
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk> <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
 <20190523152927.14bf7ed1@carbon>
 <c902c0f4-947b-ba9e-7baa-628ba87a8f01@gmail.com>
 <20190524115301.7626ed44@carbon>
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <eb212474-e8a0-77f6-254f-8778529628c6@lab.ntt.co.jp>
Date:   Mon, 27 May 2019 15:08:54 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524115301.7626ed44@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CC-Mail-RelayStamp: 1
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/24 18:53, Jesper Dangaard Brouer wrote:
> On Thu, 23 May 2019 22:51:34 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> On 19/05/23 (木) 22:29:27, Jesper Dangaard Brouer wrote:
>>> On Thu, 23 May 2019 20:35:50 +0900
>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:
>>>   
>>>> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:  
>>>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
>>>>>      
>>>>>> This improves XDP_TX performance by about 8%.
>>>>>>
>>>>>> Here are single core XDP_TX test results. CPU consumptions are taken
>>>>>> from "perf report --no-child".
>>>>>>
>>>>>> - Before:
>>>>>>
>>>>>>    7.26 Mpps
>>>>>>
>>>>>>    _raw_spin_lock  7.83%
>>>>>>    veth_xdp_xmit  12.23%
>>>>>>
>>>>>> - After:
>>>>>>
>>>>>>    7.84 Mpps
>>>>>>
>>>>>>    _raw_spin_lock  1.17%
>>>>>>    veth_xdp_xmit   6.45%
>>>>>>
>>>>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>>>>>> ---
>>>>>>   drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>>>>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>>>> index 52110e5..4edc75f 100644
>>>>>> --- a/drivers/net/veth.c
>>>>>> +++ b/drivers/net/veth.c
>>>>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>>>   	return ret;
>>>>>>   }
>>>>>>   
>>>>>> +static void veth_xdp_flush_bq(struct net_device *dev)
>>>>>> +{
>>>>>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>>>>>> +	int sent, i, err = 0;
>>>>>> +
>>>>>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);  
>>>>>
>>>>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
>>>>> you're introducing an additional per-cpu bulk queue, only to avoid lock
>>>>> contention around the existing pointer ring. But the pointer ring is
>>>>> per-rq, so if you have lock contention, this means you must have
>>>>> multiple CPUs servicing the same rq, no?  
>>>>
>>>> Yes, it's possible. Not recommended though.
>>>>  
>>>
>>> I think the general per-cpu TX bulk queue is overkill.  There is a loop
>>> over packets in veth_xdp_rcv(struct veth_rq *rq, budget, *status), and
>>> the caller veth_poll() will call veth_xdp_flush(rq->dev).
>>>
>>> Why can't you store this "temp" bulk array in struct veth_rq ?  
>>
>> Of course I can. But I thought tun has the same problem and we can 
>> decrease memory footprint by sharing the same storage between devices.
>> Or if other devices want to reduce queues so that we can use XDP on 
>> many-cpu servers and introduce locks, we can use this storage for
>> that case as well.
>>
>> Still do you prefer veth-specific solution?
> 
> Yes.  Another reason is that with this shared/general per-cpu TX bulk
> queue, I can easily see bugs resulting in xdp_frames getting
> transmitted on a completely other NIC, which will be hard to debug for
> people.
> 
>>>
>>> You could even alloc/create it on the stack of veth_poll() and send
>>> it along via a pointer to veth_xdp_rcv).
> 
> IHMO it would be cleaner code wise to place the "temp" bulk array in
> struct veth_rq.  But if you worry about performance and want a hot
> cacheline for this, then you could just use the call-stack for
> veth_poll(), as I described.  It should not be too ugly code wise to do
> this I think.

Rethinking this I agree to not using global but use stack.

For performance you are right, stack should be as hot as global if other
drivers use stack as well. I was a bit concerned about stack size, but
128 bytes size is probably acceptable these days.

Wrt debugging, indeed the global solution is probably more difficult.
When we fail to flush bq, the stack solution can be tracked by something
like kmemleak but the global one cannot. Also the global solution has a
risk to send packets from unintentional devices, which leads to a
security problem. With the stack solution missing flush just causes
packet loss and memory leak.

-- 
Toshiaki Makita

