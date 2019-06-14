Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A58458CD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFNJfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:35:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18605 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfFNJfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 05:35:09 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 975DA7D693A28A8183BE;
        Fri, 14 Jun 2019 17:35:03 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Jun 2019
 17:35:01 +0800
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
 <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
 <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <52025f94-04d3-2a44-11cd-7aa66ebc7e27@huawei.com>
Date:   Fri, 14 Jun 2019 17:35:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/14 12:28, Eric Dumazet wrote:
> 
> 
> On 6/13/19 9:19 PM, maowenan wrote:
>>
>>
>> @Eric, for this issue I only want to check TCP_NEW_SYN_RECV sk, is it OK like below?
>>  +       if (!osk && sk->sk_state == TCP_NEW_SYN_RECV)
>>  +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
>>  +                                                       sk->sk_daddr, sk->sk_dport,
>>  +                                                       sk->sk_rcv_saddr, sk->sk_num,
>>  +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
>>  +       if (unlikely(reqsk)) {
>>
> 
> Not enough.
> 
> If we have many cpus here, there is a chance another cpu has inserted a request socket, then
> replaced it by an ESTABLISH socket for the same 4-tuple.

I try to get more clear about the scene you mentioned. And I have do some testing about this, it can work well
when I use multiple cpus.

The ESTABLISH socket would be from tcp_check_req->tcp_v4_syn_recv_sock->tcp_create_openreq_child,
and for this path, inet_ehash_nolisten pass osk(NOT NULL), my patch won't call __inet_lookup_established in inet_ehash_insert().

When TCP_NEW_SYN_RECV socket try to inset to hash table, it will pass osk with NULL, my patch will check whether reqsk existed
in hash table or not. If reqsk is existed, it just removes this reqsk and dose not insert to hash table. Then the synack for this
reqsk can't be sent to client, and there is no chance to receive the ack from client, so ESTABLISH socket can't be replaced in hash table.

So I don't see the race when there are many cpus. Can you show me some clue?

thank you.
> 
> We need to take the per bucket spinlock much sooner.
> 
> And this is fine, all what matters is that we do no longer grab the listener spinlock.
> 
> 

