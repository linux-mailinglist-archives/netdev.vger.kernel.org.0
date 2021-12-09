Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6E46DF5F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbhLIAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:25:24 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:15482 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbhLIAZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1639009312; x=1670545312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2CMQQwpaopL/QR91Ql7V7wxFbW/DinxEIM0seiMu5Js=;
  b=AthLZON/xxuq0ORLm5gvoqm3lT0yHj5u1wTqP1hbQ+OgJuhRCR6YDGoD
   aXJB2wO4aWFSb89iTShqaKmRprFDO8144MmTrTpHFH2IMyJSgDnIiRQl3
   V+aoYCLObMeT2yTPMDVcYBXI+RxIeOloAZ5meFBL0YRwQMp3hyg7PXrYP
   E=;
X-IronPort-AV: E=Sophos;i="5.88,190,1635206400"; 
   d="scan'208";a="47197496"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-8ac79c09.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 09 Dec 2021 00:21:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-8ac79c09.us-east-1.amazon.com (Postfix) with ESMTPS id F01758143C;
        Thu,  9 Dec 2021 00:21:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 00:21:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 00:21:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] tcp: Remove sock_owned_by_user() test in tcp_child_process().
Date:   Thu, 9 Dec 2021 09:21:42 +0900
Message-ID: <20211209002142.36995-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iL+YWbQDCTQU-D1nU4EePv07EyHvMPjFPkpH1ELyzg5MA@mail.gmail.com>
References: <CANn89iL+YWbQDCTQU-D1nU4EePv07EyHvMPjFPkpH1ELyzg5MA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D03UWC001.ant.amazon.com (10.43.162.136) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Dec 2021 10:30:49 -0800
> On Tue, Dec 7, 2021 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>>
>> While creating a child socket, before v2.3.41, we used to call
>> bh_lock_sock() later than now; it was called just before
>> tcp_rcv_state_process().  The full socket was put into an accept queue
>> and exposed to other CPUs before bh_lock_sock() so that process context
>> might have acquired the lock by then.  Thus, we had to check if any
>> process context was accessing the socket before tcp_rcv_state_process().
>>
>> We can see this code in tcp_v4_do_rcv() of v2.3.14. [0]
>>
>>         if (sk->state == TCP_LISTEN) {
>>                 struct sock *nsk;
>>
>>                 nsk = tcp_v4_hnd_req(sk, skb);
>>                 ...
>>                 if (nsk != sk) {
>>                         bh_lock_sock(nsk);
>>                         if (nsk->lock.users != 0) {
>>                                 ...
>>                                 sk_add_backlog(nsk, skb);
>>                                 bh_unlock_sock(nsk);
>>                                 return 0;
>>                         }
>>                         ...
>>                 }
>>         }
>>
>>         if (tcp_rcv_state_process(sk, skb, skb->h.th, skb->len))
>>                 goto reset;
>>
>> However, in 2.3.15, this lock.users test was replaced with BUG_TRAP() by
>> mistake. [1]
>>
>>                 if (nsk != sk) {
>>                         ...
>>                         BUG_TRAP(nsk->lock.users == 0);
>>                         ...
>>                         ret = tcp_rcv_state_process(nsk, skb, skb->h.th, skb->len);
>>                         ...
>>                         bh_unlock_sock(nsk);
>>                         ...
>>                         return 0;
>>                 }
>>
>> Fortunately, the test was back in 2.3.41. [2]  Then, related code was
>> packed into tcp_child_process() with comments, which remains until now.
>>
>> What is interesting in v2.3.41 is that the bh_lock_sock() was moved to
>> tcp_create_openreq_child() and placed just after sock_lock_init().
>> Thus, the lock is never acquired until tcp_rcv_state_process() by process
>> contexts.  The bh_lock_sock() is now in sk_clone_lock() and the rule does
>> not change.
>>
>> As of now, alas, it is not possible to reach the commented path by the
>> change.  Let's remove the remnant of the old days.
>>
>> [0]: https://cdn.kernel.org/pub/linux/kernel/v2.3/linux-2.3.14.tar.gz
>> [1]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.15.gz
>> [2]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.41.gz
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> I do not think this patch qualifies as a stable candidate.
> 
> At best this is a cleanup.
> 
> At worst this could add a bug.
> 
> I would advise adding a WARN_ON_ONCE() there for at least one release
> so that syzbot can validate for you if this is dead code or not.

Thanks for review.
I will add a WARN_ON_ONCE() and respin for net-next.

> 
> TCP_SYN_RECV is not TCP_NEW_SYN_RECV

Right, TCP_SYN_RECV is not the case.
"While creating a child socket," was a bit misleading.
I will clarify that is for TCP_NEW_SYN_RECV case and SYN cookie case.


> 
> Thanks.
> 
>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>> ---
>>  net/ipv4/tcp_minisocks.c | 18 ++++++------------
>>  1 file changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
>> index 7c2d3ac2363a..b4a1f8728093 100644
>> --- a/net/ipv4/tcp_minisocks.c
>> +++ b/net/ipv4/tcp_minisocks.c
>> @@ -833,18 +833,12 @@ int tcp_child_process(struct sock *parent, struct sock *child,
>>         sk_mark_napi_id_set(child, skb);
>>
>>         tcp_segs_in(tcp_sk(child), skb);
>> -       if (!sock_owned_by_user(child)) {
>> -               ret = tcp_rcv_state_process(child, skb);
>> -               /* Wakeup parent, send SIGIO */
>> -               if (state == TCP_SYN_RECV && child->sk_state != state)
>> -                       parent->sk_data_ready(parent);
>> -       } else {
>> -               /* Alas, it is possible again, because we do lookup
>> -                * in main socket hash table and lock on listening
>> -                * socket does not protect us more.
>> -                */
>> -               __sk_add_backlog(child, skb);
>> -       }
>> +
>> +       ret = tcp_rcv_state_process(child, skb);
>> +
>> +       /* Wakeup parent, send SIGIO */
>> +       if (state == TCP_SYN_RECV && child->sk_state != state)
>> +               parent->sk_data_ready(parent);
>>
>>         bh_unlock_sock(child);
>>         sock_put(child);
>> --
>> 2.30.2
>>
