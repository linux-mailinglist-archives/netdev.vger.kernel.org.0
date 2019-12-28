Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D475012BC87
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 05:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfL1E0M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Dec 2019 23:26:12 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:40595 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbfL1E0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 23:26:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tm4zEcW_1577507167;
Received: from 30.39.184.91(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0Tm4zEcW_1577507167)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Dec 2019 12:26:08 +0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <bdb42c0b-2d84-9a49-3ac4-34109ff4224a@gmail.com>
Date:   Sat, 28 Dec 2019 12:26:07 +0800
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <55BD3A1D-746E-4B04-96D6-BDF2D3D92736@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
 <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
 <bdb42c0b-2d84-9a49-3ac4-34109ff4224a@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 28, 2019, at 11:28, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 12/27/19 4:49 PM, Eric Dumazet wrote:
>> 
>> 
>> On 12/27/19 12:52 AM, Cambda Zhu wrote:
>>> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
>>> setting tp->highest_sack to the head of the send queue was removed.
>>> Of course the logic is error prone, but it is logical. Before we
>>> remove the pointer to the highest sack skb and use the seq instead,
>>> we need to set tp->highest_sack to NULL when there is no skb after
>>> the last sack, and then replace NULL with the real skb when new skb
>>> inserted into the rtx queue, because the NULL means the highest sack
>>> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
>>> the next ACK with sack option will increase tp->reordering unexpectedly.
>>> 
>>> This patch sets tp->highest_sack to the tail of the rtx queue if
>>> it's NULL and new data is sent. The patch keeps the rule that the
>>> highest_sack can only be maintained by sack processing, except for
>>> this only case.
>>> 
>>> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
>>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>>> ---
>>> net/ipv4/tcp_output.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>> 
>>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>> index 1f7735ca8f22..58c92a7d671c 100644
>>> --- a/net/ipv4/tcp_output.c
>>> +++ b/net/ipv4/tcp_output.c
>>> @@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>>> 	__skb_unlink(skb, &sk->sk_write_queue);
>>> 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
>>> 
>>> +	if (tp->highest_sack == NULL)
>>> +		tp->highest_sack = skb;
>>> +
>>> 	tp->packets_out += tcp_skb_pcount(skb);
>>> 	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
>>> 		tcp_rearm_rto(sk);
>>> 
>> 
>> 
>> This patch seems to keep something in the fast path, even for flows never experiencing
>> sacks.
>> 
>> Why would we always painfully maintain tp->highest_sack to the left most skb in the rtx queue ?
>> 
>> Given that tcp_highest_sack_seq() has an explicit check about tp->highest_sack being NULL,
>> there is something I do not quite understand yet.
>> 
>> Why keeping this piece of code ?
>> 
>>    if (tp->highest_sack == NULL)
>>            return tp->snd_nxt;
>> 
>> Defensive programming should be replaced by better knowledge.
>> 
>> Can you provide more explanations, or maybe a packetdrill test ?
>> 
>> Maybe some other path (in slow path this time) misses a !tp->highest_sack test.
>> 
>> Thanks.
>> 
> 
> Or maybe the real bug has been latent for years.
> 
> (added in commit 6859d49475d4 "[TCP]: Abstract tp->highest_sack accessing & point to next skb" )
> 
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index e460ea7f767ba627972a63a974cae80357808366..32781fb5cf3a7aa1158c98cb87754b59dc922b1f 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1843,12 +1843,9 @@ static inline void tcp_push_pending_frames(struct sock *sk)
>  */
> static inline u32 tcp_highest_sack_seq(struct tcp_sock *tp)
> {
> -       if (!tp->sacked_out)
> +       if (!tp->sacked_out || !tp->highest_sack)
>                return tp->snd_una;
> 
> -       if (tp->highest_sack == NULL)
> -               return tp->snd_nxt;
> -
>        return TCP_SKB_CB(tp->highest_sack)->seq;
> }

The key is that we use skb but not seq to save the highest sack yet. I think it should be done in
a better way. If we replace the next skb with the last sacked skb or seq after it, we need to change
all of the sack processing about highest sack, which is worth to do in my opinion.

Thanks.

