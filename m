Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507EC45FF4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfFNOEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:04:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727123AbfFNOEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 10:04:10 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CD9F47202C52AF18FA28;
        Fri, 14 Jun 2019 22:04:04 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Jun 2019
 22:04:00 +0800
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Eric Dumazet <edumazet@google.com>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
 <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
 <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com>
 <52025f94-04d3-2a44-11cd-7aa66ebc7e27@huawei.com>
 <CANn89iKzfvZqZRo1pEwqW11DQk1YOPkoAR4tLbjRG9qbKOYEMw@mail.gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <7d0f5a21-717c-74ee-18ad-fc0432dfbe33@huawei.com>
Date:   Fri, 14 Jun 2019 22:03:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKzfvZqZRo1pEwqW11DQk1YOPkoAR4tLbjRG9qbKOYEMw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/14 20:27, Eric Dumazet wrote:
> On Fri, Jun 14, 2019 at 2:35 AM maowenan <maowenan@huawei.com> wrote:
>>
>>
>>
>> On 2019/6/14 12:28, Eric Dumazet wrote:
>>>
>>>
>>> On 6/13/19 9:19 PM, maowenan wrote:
>>>>
>>>>
>>>> @Eric, for this issue I only want to check TCP_NEW_SYN_RECV sk, is it OK like below?
>>>>  +       if (!osk && sk->sk_state == TCP_NEW_SYN_RECV)
>>>>  +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
>>>>  +                                                       sk->sk_daddr, sk->sk_dport,
>>>>  +                                                       sk->sk_rcv_saddr, sk->sk_num,
>>>>  +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
>>>>  +       if (unlikely(reqsk)) {
>>>>
>>>
>>> Not enough.
>>>
>>> If we have many cpus here, there is a chance another cpu has inserted a request socket, then
>>> replaced it by an ESTABLISH socket for the same 4-tuple.
>>
>> I try to get more clear about the scene you mentioned. And I have do some testing about this, it can work well
>> when I use multiple cpus.
>>
>> The ESTABLISH socket would be from tcp_check_req->tcp_v4_syn_recv_sock->tcp_create_openreq_child,
>> and for this path, inet_ehash_nolisten pass osk(NOT NULL), my patch won't call __inet_lookup_established in inet_ehash_insert().
>>
>> When TCP_NEW_SYN_RECV socket try to inset to hash table, it will pass osk with NULL, my patch will check whether reqsk existed
>> in hash table or not. If reqsk is existed, it just removes this reqsk and dose not insert to hash table. Then the synack for this
>> reqsk can't be sent to client, and there is no chance to receive the ack from client, so ESTABLISH socket can't be replaced in hash table.
>>
>> So I don't see the race when there are many cpus. Can you show me some clue?
> 
> This is a bit silly.
> You focus on some crash you got on a given system, but do not see the real bug.
> 
> 
> CPU A
> 
> SYN packet
>  lookup finds nothing.
>  Create a NEW_SYN_RECV
>  <long delay, like hardware interrupts calling some buggy driver or something>

I agree that this is a special case.
I propose one point about the sequence of synack, if two synack with two different
sequence since the time elapse 64ns, this issue disappear.

tcp_conn_request->tcp_v4_init_seq->secure_tcp_seq->seq_scale
static u32 seq_scale(u32 seq)
{
	/*
	 *	As close as possible to RFC 793, which
	 *	suggests using a 250 kHz clock.
	 *	Further reading shows this assumes 2 Mb/s networks.
	 *	For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
	 *	For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
	 *	we also need to limit the resolution so that the u32 seq
	 *	overlaps less than one time per MSL (2 minutes).
	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
	 */
	return seq + (ktime_get_real_ns() >> 6);
}

So if the long delay larger than 64ns, the seq is difference.


> 
>              CPU B
>              SYN packet
>                -> inserts a NEW_SYN_RECV  sends a SYNACK
>              ACK packet
>              -> replaces the NEW_SYN_RECV by ESTABLISH socket
> 
> CPU A resumes.
>     Basically a lookup (after taking the bucket spinlock) could either find :
>    - Nothing (typical case where there was no race)
>    -  A NEW_SYN_RECV
>    -  A ESTABLISHED socket
>   - A TIME_WAIT socket.
> 
> You can not simply fix the "NEW_SYN_RECV" state case, and possibly add
> hard crashes (instead of current situation leading to RST packets)
> 
> .
> 

