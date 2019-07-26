Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBF7618E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfGZJLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:11:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3173 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfGZJLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 05:11:09 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6AA88FF0175CD0D1D039;
        Fri, 26 Jul 2019 17:11:06 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 26 Jul 2019
 17:11:01 +0800
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190724091715.137033-1-maowenan@huawei.com>
 <2e09f4d1-8a47-27e9-60f9-63d3b19a98ec@gmail.com>
 <13ffa2fe-d064-9786-bc52-e4281d26ed1d@huawei.com>
 <44f0ba0d-fd19-d44b-9c5c-686e2f8ef988@gmail.com>
 <9a8d6a5a-9a9d-9cb5-caa9-5c12ba04a43c@huawei.com>
 <510109e3-101f-517c-22b4-921432f04fe5@gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <69faf3d1-ee37-8fc5-fedf-25284e45d6bb@huawei.com>
Date:   Fri, 26 Jul 2019 17:10:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <510109e3-101f-517c-22b4-921432f04fe5@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 14:19, Eric Dumazet wrote:
> 
> 
> On 7/25/19 6:29 AM, maowenan wrote:
>>
> 
>>>>>> Syzkaller reproducer():
>>>>>> r0 = socket$packet(0x11, 0x3, 0x300)
>>>>>> r1 = socket$inet_tcp(0x2, 0x1, 0x0)
>>>>>> bind$inet(r1, &(0x7f0000000300)={0x2, 0x4e21, @multicast1}, 0x10)
>>>>>> connect$inet(r1, &(0x7f0000000140)={0x2, 0x1000004e21, @loopback}, 0x10)
>>>>>> recvmmsg(r1, &(0x7f0000001e40)=[{{0x0, 0x0, &(0x7f0000000100)=[{&(0x7f00000005c0)=""/88, 0x58}], 0x1}}], 0x1, 0x40000000, 0x0)
>>>>>> sendto$inet(r1, &(0x7f0000000000)="e2f7ad5b661c761edf", 0x9, 0x8080, 0x0, 0x0)
>>>>>> r2 = fcntl$dupfd(r1, 0x0, r0)
>>>>>> connect$unix(r2, &(0x7f00000001c0)=@file={0x0, './file0\x00'}, 0x6e)
>>>>>>
>>>
>>> It does call tcp_disconnect(), by one of the connect() call.
>>
>> yes, __inet_stream_connect will call tcp_disconnect when sa_family == AF_UNSPEC, in c repro if it
>> passes sa_family with AF_INET it won't call disconnect, and then sk_send_head won't be NULL when tcp_connect.
>>
> 
> 
> Look again at the Syzkaller reproducer()
> 
> It definitely uses tcp_disconnect()
> 
> Do not be fooled by connect$unix(), this is a connect() call really, with AF_UNSPEC

Right, in syzkaller reproducer, it calls connect() with AF_UNSPEC, actually I can reproduce the issue only with C repro(https://syzkaller.appspot.com/text?tag=ReproC&x=14db474f800000).
syscall procedure in C:
__NR_socket
__NR_bind
__NR_sendto  (flag=0x20000000,MSG_FASTOPEN, it will call __inet_stream_connect with sa_family = AF_INET, sk->sk_send_head = NULL)
__NR_write
__NR_connect (call __inet_stream_connect with sa_family = AF_UNSPEC, it will call tcp_disconnect and set sk->sk_send_head = NULL)
__NR_connect (call __inet_stream_connect with sa_family = AF_INET, if sk->sk_send_head != NULL UAF happen)

I debug why tcp_disconnect has already set sk->sk_send_head = NULL, but it is NOT NULL after next __NR_connect.
I find that some packets send out before second __NR_connect(with AF_INET), so the sk_send_head is modified by: tcp_sendmsg->skb_entail->tcp_add_write_queue_tail
static inline void tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb)
{
	__tcp_add_write_queue_tail(sk, skb);

	/* Queue it, remembering where we must start sending. */
	if (sk->sk_send_head == NULL) {
		sk->sk_send_head = skb;  //here, sk->sk_send_head is changed.

		if (tcp_sk(sk)->highest_sack == NULL)
			tcp_sk(sk)->highest_sack = skb;
	}
}




> 
> 



