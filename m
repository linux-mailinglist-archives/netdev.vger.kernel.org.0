Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFF44627
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404231AbfFMQtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:49:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33792 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727570AbfFMEWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 00:22:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3FDF257335E87EE0923;
        Thu, 13 Jun 2019 12:21:57 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Jun 2019
 12:21:53 +0800
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Eric Dumazet <edumazet@google.com>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
Date:   Thu, 13 Jun 2019 12:21:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/13 0:30, Eric Dumazet wrote:
> On Tue, Jun 11, 2019 at 8:49 PM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> There is one issue about bonding mode BOND_MODE_BROADCAST, and
>> two slaves with diffierent affinity, so packets will be handled
>> by different cpu. These are two pre-conditions in this case.
>>
>> When two slaves receive the same syn packets at the same time,
>> two request sock(reqsk) will be created if below situation happens:
>> 1. syn1 arrived tcp_conn_request, create reqsk1 and have not yet called
>> inet_csk_reqsk_queue_hash_add.
>> 2. syn2 arrived tcp_v4_rcv, it goes to tcp_conn_request and create
>> reqsk2
>> because it can't find reqsk1 in the __inet_lookup_skb.
>>
>> Then reqsk1 and reqsk2 are added to establish hash table, and two synack
>> with different
>> seq(seq1 and seq2) are sent to client, then tcp ack arrived and will be
>> processed in tcp_v4_rcv and tcp_check_req, if __inet_lookup_skb find the
>> reqsk2, and
>> tcp ack packet is ack_seq is seq1, it will be failed after checking:
>> TCP_SKB_CB(skb)->ack_seq != tcp_rsk(req)->snt_isn + 1)
>> and then tcp rst will be sent to client and close the connection.
>>
>> To fix this, call __inet_lookup_established() before __sk_nulls_add_node_rcu()
>> in inet_ehash_insert(). If there is existed reqsk with same tuples in
>> established hash table, directly to remove current reqsk2, and does not send
>> synack to client.
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  v2: move __inet_lookup_established from tcp_conn_request() to inet_ehash_insert()
>>  as Eric suggested.
>> ---
>>  include/net/inet_connection_sock.h |  2 +-
>>  net/ipv4/inet_connection_sock.c    | 16 ++++++++++++----
>>  net/ipv4/inet_hashtables.c         | 13 +++++++++++++
>>  net/ipv4/tcp_input.c               |  7 ++++---
>>  4 files changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
>> index c57d53e7e02c..2d3538e333cb 100644
>> --- a/include/net/inet_connection_sock.h
>> +++ b/include/net/inet_connection_sock.h
>> @@ -263,7 +263,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
>>  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>>                                       struct request_sock *req,
>>                                       struct sock *child);
>> -void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>> +bool inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>>                                    unsigned long timeout);
>>  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>>                                          struct request_sock *req,
>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>> index 13ec7c3a9c49..fd45ed2fd985 100644
>> --- a/net/ipv4/inet_connection_sock.c
>> +++ b/net/ipv4/inet_connection_sock.c
>> @@ -749,7 +749,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>>         inet_csk_reqsk_queue_drop_and_put(sk_listener, req);
>>  }
>>
>> -static void reqsk_queue_hash_req(struct request_sock *req,
>> +static bool reqsk_queue_hash_req(struct request_sock *req,
>>                                  unsigned long timeout)
>>  {
>>         req->num_retrans = 0;
>> @@ -759,19 +759,27 @@ static void reqsk_queue_hash_req(struct request_sock *req,
>>         timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
>>         mod_timer(&req->rsk_timer, jiffies + timeout);
>>
>> -       inet_ehash_insert(req_to_sk(req), NULL);
>> +       if (!inet_ehash_insert(req_to_sk(req), NULL)) {
>> +               if (timer_pending(&req->rsk_timer))
>> +                       del_timer_sync(&req->rsk_timer);
>> +               return false;
>> +       }
>>         /* before letting lookups find us, make sure all req fields
>>          * are committed to memory and refcnt initialized.
>>          */
>>         smp_wmb();
>>         refcount_set(&req->rsk_refcnt, 2 + 1);
>> +       return true;
>>  }
>>
>> -void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>> +bool inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>>                                    unsigned long timeout)
>>  {
>> -       reqsk_queue_hash_req(req, timeout);
>> +       if (!reqsk_queue_hash_req(req, timeout))
>> +               return false;
>> +
>>         inet_csk_reqsk_queue_added(sk);
>> +       return true;
>>  }
>>  EXPORT_SYMBOL_GPL(inet_csk_reqsk_queue_hash_add);
>>
>> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
>> index c4503073248b..b6a1b5334565 100644
>> --- a/net/ipv4/inet_hashtables.c
>> +++ b/net/ipv4/inet_hashtables.c
>> @@ -477,6 +477,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>>         struct inet_ehash_bucket *head;
>>         spinlock_t *lock;
>>         bool ret = true;
>> +       struct sock *reqsk = NULL;
>>
>>         WARN_ON_ONCE(!sk_unhashed(sk));
>>
>> @@ -486,6 +487,18 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>>         lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
>>
>>         spin_lock(lock);
>> +       if (!osk)
>> +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
>> +                                                       sk->sk_daddr, sk->sk_dport,
>> +                                                       sk->sk_rcv_saddr, sk->sk_num,
>> +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
>> +       if (unlikely(reqsk)) {
> 
> What reqsk would be a SYN_RECV socket, and not a ESTABLISH one (or a
> TIME_WAIT ?)

It wouldn't be SYN_RECV,ESTABLISH or TIME_WAIT, just TCP_NEW_SYN_RECV.

When server receives the third handshake packet ACK, SYN_RECV sk will insert to hash with osk(!= NULL).
The looking up here just avoid to create two or more request sk with TCP_NEW_SYN_RECV when receive syn packet.

> 
>> +               ret = false;
>> +               reqsk_free(inet_reqsk(sk));
>> +               spin_unlock(lock);
>> +               return ret;
>> +       }
>> +
>>         if (osk) {
> 
> This test should have be a hint here : Sometime we _expect_ to have an
> old socket (TIMEWAIT) and remove it
I will check TIMEWAIT sk.
> 
> 
>>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
>>                 ret = sk_nulls_del_node_init_rcu(osk);
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 38dfc308c0fb..358272394590 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -6570,9 +6570,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>>                 sock_put(fastopen_sk);
>>         } else {
>>                 tcp_rsk(req)->tfo_listener = false;
>> -               if (!want_cookie)
>> -                       inet_csk_reqsk_queue_hash_add(sk, req,
>> -                               tcp_timeout_init((struct sock *)req));
>> +               if (!want_cookie && !inet_csk_reqsk_queue_hash_add(sk, req,
>> +                                       tcp_timeout_init((struct sock *)req)))
>> +                       return 0;
>> +
>>                 af_ops->send_synack(sk, dst, &fl, req, &foc,
>>                                     !want_cookie ? TCP_SYNACK_NORMAL :
>>                                                    TCP_SYNACK_COOKIE);
>> --
>> 2.20.1
>>
> 
> I believe the proper fix is more complicated.
yes, pretty complicated.
> 
> Probably we need to move the locking in a less deeper location.

> 
> (Also a similar fix would be needed in IPv6)
ok
> 
> Thanks.
> 
> .
> 

