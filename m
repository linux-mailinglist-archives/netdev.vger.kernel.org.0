Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4985612BC7E
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 05:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfL1D7A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Dec 2019 22:59:00 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:56564 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbfL1D7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 22:59:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tm4RajU_1577505534;
Received: from 30.39.184.91(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0Tm4RajU_1577505534)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Dec 2019 11:58:55 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
Date:   Sat, 28 Dec 2019 11:58:54 +0800
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E7D39FFD-AFFE-4F12-9105-B1D428ADDABB@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
 <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 28, 2019, at 08:49, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 12/27/19 12:52 AM, Cambda Zhu wrote:
>> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
>> setting tp->highest_sack to the head of the send queue was removed.
>> Of course the logic is error prone, but it is logical. Before we
>> remove the pointer to the highest sack skb and use the seq instead,
>> we need to set tp->highest_sack to NULL when there is no skb after
>> the last sack, and then replace NULL with the real skb when new skb
>> inserted into the rtx queue, because the NULL means the highest sack
>> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
>> the next ACK with sack option will increase tp->reordering unexpectedly.
>> 
>> This patch sets tp->highest_sack to the tail of the rtx queue if
>> it's NULL and new data is sent. The patch keeps the rule that the
>> highest_sack can only be maintained by sack processing, except for
>> this only case.
>> 
>> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>> ---
>> net/ipv4/tcp_output.c | 3 +++
>> 1 file changed, 3 insertions(+)
>> 
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 1f7735ca8f22..58c92a7d671c 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>> 	__skb_unlink(skb, &sk->sk_write_queue);
>> 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
>> 
>> +	if (tp->highest_sack == NULL)
>> +		tp->highest_sack = skb;
>> +
>> 	tp->packets_out += tcp_skb_pcount(skb);
>> 	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
>> 		tcp_rearm_rto(sk);
>> 
> 
> 
> This patch seems to keep something in the fast path, even for flows never experiencing
> sacks.
> 
I’ll update the patch to check tcp_is_sack(). It’s a good idea, thank you.

> Why would we always painfully maintain tp->highest_sack to the left most skb in the rtx queue ?
> 
> Given that tcp_highest_sack_seq() has an explicit check about tp->highest_sack being NULL,
> there is something I do not quite understand yet.
> 
> Why keeping this piece of code ?
> 
>    if (tp->highest_sack == NULL)
>            return tp->snd_nxt;
> 
Before we replace tp->highest_sack with tp->highest_sack_seq, the highest_sack_seq is always
gotten from the highest_sack skb. Unfortunately if the skb before tp->snd_nxt is sacked, we
have no choice but to set tp->highest_sack to a special skb or value yet, such as the send head
in the past and the NULL now.

In the past, if there’s no skb after the last sacked skb in the write queue, tp->highest_sack
will be set to NULL and tcp_highest_sack_seq() will return tp->snd_nxt, which is equal to
TCP_SKB_CB(skb_after_last_sack)->seq. And then if new data is sent, the tp->highest_sack must
be replaced by the new skb, otherwise the tcp_highest_sack_seq() will return a higher seq
and result in increasing tp->reordering when the skb which is after the last sack and before
the last sent new skb.

Now we have the same issue. If the skb_rb_last() skb is sacked, tp->highest_sack is set to NULL.
If new data is sent, tcp_highest_sack_seq() will return a higher seq than what we expect.

Here is my UGLY example:
Low								High
#1	#2	#3(last sacked)
			       ^
			       |highest_sack_seq(NULL)
#1	#2	#3(last sacked)		#4		#5	#6
								  ^
								  |highest_sack_seq(NULL)
#1	#2	#3			#4(last sacked)	#5	#6
					{	reordering	  }

> Defensive programming should be replaced by better knowledge.
> 
> Can you provide more explanations, or maybe a packetdrill test ?
> 
> Maybe some other path (in slow path this time) misses a !tp->highest_sack test.
> 
> Thanks.
I don’t know how to use a packetdrill test to reproduce this case, sorry. But I can reproduce
it via network emulator with these parameters:

Server:
rack off, metric no saving, congestion control bbr

Client:
random loss 8%, fixed rtt 20 ms, 60 Mbps bandwidth with 100 packets queue and tail drop.

Thanks.

