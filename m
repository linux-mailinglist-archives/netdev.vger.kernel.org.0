Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E19145364
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfFNETy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:19:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfFNETx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 00:19:53 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8F5159BC077B7B45EA24;
        Fri, 14 Jun 2019 12:19:50 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Jun 2019
 12:19:50 +0800
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Eric Dumazet <edumazet@google.com>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
Date:   Fri, 14 Jun 2019 12:19:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>>> index 13ec7c3a9c49..fd45ed2fd985 100644
>>> --- a/net/ipv4/inet_connection_sock.c
>>> +++ b/net/ipv4/inet_connection_sock.c
>>> @@ -749,7 +749,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>>>         inet_csk_reqsk_queue_drop_and_put(sk_listener, req);
>>>  }
>>>
>>> -static void reqsk_queue_hash_req(struct request_sock *req,
>>> +static bool reqsk_queue_hash_req(struct request_sock *req,
>>>                                  unsigned long timeout)
>>>  {
>>>         req->num_retrans = 0;
>>> @@ -759,19 +759,27 @@ static void reqsk_queue_hash_req(struct request_sock *req,
>>>         timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
>>>         mod_timer(&req->rsk_timer, jiffies + timeout);
>>>
>>> -       inet_ehash_insert(req_to_sk(req), NULL);
>>> +       if (!inet_ehash_insert(req_to_sk(req), NULL)) {
>>> +               if (timer_pending(&req->rsk_timer))
>>> +                       del_timer_sync(&req->rsk_timer);
>>> +               return false;
>>> +       }
>>>         /* before letting lookups find us, make sure all req fields
>>>          * are committed to memory and refcnt initialized.
>>>          */
>>>         smp_wmb();
>>>         refcount_set(&req->rsk_refcnt, 2 + 1);
>>> +       return true;
>>>  }
>>>
>>> -void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>>> +bool inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>>>                                    unsigned long timeout)
>>>  {
>>> -       reqsk_queue_hash_req(req, timeout);
>>> +       if (!reqsk_queue_hash_req(req, timeout))
>>> +               return false;
>>> +
>>>         inet_csk_reqsk_queue_added(sk);
>>> +       return true;
>>>  }
>>>  EXPORT_SYMBOL_GPL(inet_csk_reqsk_queue_hash_add);
>>>
>>> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
>>> index c4503073248b..b6a1b5334565 100644
>>> --- a/net/ipv4/inet_hashtables.c
>>> +++ b/net/ipv4/inet_hashtables.c
>>> @@ -477,6 +477,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>>>         struct inet_ehash_bucket *head;
>>>         spinlock_t *lock;
>>>         bool ret = true;
>>> +       struct sock *reqsk = NULL;
>>>
>>>         WARN_ON_ONCE(!sk_unhashed(sk));
>>>
>>> @@ -486,6 +487,18 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>>>         lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
>>>
>>>         spin_lock(lock);
>>> +       if (!osk)
>>> +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
>>> +                                                       sk->sk_daddr, sk->sk_dport,
>>> +                                                       sk->sk_rcv_saddr, sk->sk_num,
>>> +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
>>> +       if (unlikely(reqsk)) {
>>
>> What reqsk would be a SYN_RECV socket, and not a ESTABLISH one (or a
>> TIME_WAIT ?)
> 
> It wouldn't be SYN_RECV,ESTABLISH or TIME_WAIT, just TCP_NEW_SYN_RECV.
> 
> When server receives the third handshake packet ACK, SYN_RECV sk will insert to hash with osk(!= NULL).
> The looking up here just avoid to create two or more request sk with TCP_NEW_SYN_RECV when receive syn packet.
> 


@Eric, for this issue I only want to check TCP_NEW_SYN_RECV sk, is it OK like below?
 +       if (!osk && sk->sk_state == TCP_NEW_SYN_RECV)
 +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
 +                                                       sk->sk_daddr, sk->sk_dport,
 +                                                       sk->sk_rcv_saddr, sk->sk_num,
 +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
 +       if (unlikely(reqsk)) {




>>
>>> +               ret = false;
>>> +               reqsk_free(inet_reqsk(sk));
>>> +               spin_unlock(lock);
>>> +               return ret;
>>> +       }
>>> +
>>>         if (osk) {
>>
>> This test should have be a hint here : Sometime we _expect_ to have an
>> old socket (TIMEWAIT) and remove it
> I will check TIMEWAIT sk.
>>
>>
>>>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
>>>                 ret = sk_nulls_del_node_init_rcu(osk);
>>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>>> index 38dfc308c0fb..358272394590 100644
>>> --- a/net/ipv4/tcp_input.c
>>> +++ b/net/ipv4/tcp_input.c
>>> @@ -6570,9 +6570,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>>>                 sock_put(fastopen_sk);
>>>         } else {
>>>                 tcp_rsk(req)->tfo_listener = false;
>>> -               if (!want_cookie)
>>> -                       inet_csk_reqsk_queue_hash_add(sk, req,
>>> -                               tcp_timeout_init((struct sock *)req));
>>> +               if (!want_cookie && !inet_csk_reqsk_queue_hash_add(sk, req,
>>> +                                       tcp_timeout_init((struct sock *)req)))
>>> +                       return 0;
>>> +
>>>                 af_ops->send_synack(sk, dst, &fl, req, &foc,
>>>                                     !want_cookie ? TCP_SYNACK_NORMAL :
>>>                                                    TCP_SYNACK_COOKIE);
>>> --
>>> 2.20.1
>>>
>>
>> I believe the proper fix is more complicated.
> yes, pretty complicated.
>>
>> Probably we need to move the locking in a less deeper location.


Currently, I find inet_ehash_insert is the most suitable location to do hash looking up,
because the sk's lock can be found from sk_hash, and there has already existed spin_lock code
In v1, I put the hash looking up in tcp_connect_request, there will be redundant lock to do looking up.


> 
>>
>> (Also a similar fix would be needed in IPv6)
> ok

I find IPv6 has the same call trace, so this fix seems good to IPv6?
tcp_v6_conn_request
	tcp_conn_request
		inet_csk_reqsk_queue_hash_add
			reqsk_queue_hash_req
				inet_ehash_insert
					
		

>>
>> Thanks.
>>
>> .
>>

