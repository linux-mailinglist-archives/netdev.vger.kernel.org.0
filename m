Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3255B3551F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFECHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:07:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfFECHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 22:07:47 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6FC6F678460A6BB1D76;
        Wed,  5 Jun 2019 10:07:44 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 5 Jun 2019
 10:07:40 +0800
Subject: Re: [PATCH net] tcp: avoid creating multiple req socks with the same
 tuples
To:     Eric Dumazet <edumazet@google.com>
References: <20190604145543.61624-1-maowenan@huawei.com>
 <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <4d406802-d8a2-2d92-90c3-d56b8a23c2b2@huawei.com>
Date:   Wed, 5 Jun 2019 10:06:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/4 23:24, Eric Dumazet wrote:
> On Tue, Jun 4, 2019 at 7:47 AM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> There is one issue about bonding mode BOND_MODE_BROADCAST, and
>> two slaves with diffierent affinity, so packets will be handled
>> by different cpu. These are two pre-conditions in this case.
>>
>> When two slaves receive the same syn packets at the same time,
>> two request sock(reqsk) will be created if below situation happens:
>> 1. syn1 arrived tcp_conn_request, create reqsk1 and have not yet called
>> inet_csk_reqsk_queue_hash_add.
>> 2. syn2 arrived tcp_v4_rcv, it goes to tcp_conn_request and create reqsk2
>> because it can't find reqsk1 in the __inet_lookup_skb.
>>
>> Then reqsk1 and reqsk2 are added to establish hash table, and two synack with different
>> seq(seq1 and seq2) are sent to client, then tcp ack arrived and will be
>> processed in tcp_v4_rcv and tcp_check_req, if __inet_lookup_skb find the reqsk2, and
>> tcp ack packet is ack_seq is seq1, it will be failed after checking:
>> TCP_SKB_CB(skb)->ack_seq != tcp_rsk(req)->snt_isn + 1)
>> and then tcp rst will be sent to client and close the connection.
>>
>> To fix this, do lookup before calling inet_csk_reqsk_queue_hash_add
>> to add reqsk2 to hash table, if it finds the existed reqsk1 with the same five tuples,
>> it removes reqsk2 and does not send synack to client.
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  net/ipv4/tcp_input.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 08a477e74cf3..c75eeb1fe098 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -6569,6 +6569,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>>                 bh_unlock_sock(fastopen_sk);
>>                 sock_put(fastopen_sk);
>>         } else {
>> +               struct sock *sk1 = req_to_sk(req);
>> +               struct sock *sk2 = NULL;
>> +               sk2 = __inet_lookup_established(sock_net(sk1), &tcp_hashinfo,
>> +                                                                       sk1->sk_daddr, sk1->sk_dport,
>> +                                                                       sk1->sk_rcv_saddr, sk1->sk_num,
>> +                                                                       inet_iif(skb),inet_sdif(skb));
>> +               if (sk2 != NULL)
>> +                       goto drop_and_release;
>> +
>>                 tcp_rsk(req)->tfo_listener = false;
>>                 if (!want_cookie)
>>                         inet_csk_reqsk_queue_hash_add(sk, req,
> 
> This issue has been discussed last year.
Can you share discussion information?

> 
> I am afraid your patch does not solve all races.
> 
> The lookup you add is lockless, so this is racy.
it's right, it has already in race region.
> 
> Really the only way to solve this is to make sure that _when_ the
> bucket lock is held,
> we do not insert a request socket if the 4-tuple is already in the
> chain (probably in inet_ehash_insert())
> 

put lookup code in spin_lock() of inet_ehash_insert(), is it ok like this?
will it affect performance?

in inet_ehash_insert():
...
        spin_lock(lock);
+       reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
+                                                       sk->sk_daddr, sk->sk_dport,
+                                                       sk->sk_rcv_saddr, sk->sk_num,
+                                                       sk_bound_dev_if, sk_bound_dev_if);
+       if (reqsk) {
+               spin_unlock(lock);
+               return ret;
+       }
+
        if (osk) {
                WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
                ret = sk_nulls_del_node_init_rcu(osk);
	}
	if (ret)
		__sk_nulls_add_node_rcu(sk, list);
	spin_unlock(lock);
...

> This needs more tricky changes than your patch.
> 
> .
> 

