Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A8C4413A6
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhKAGSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:18:33 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40482 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhKAGSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:18:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UuSITEE_1635747357;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UuSITEE_1635747357)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 14:15:58 +0800
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
 <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
Date:   Mon, 1 Nov 2021 14:15:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/29 5:40, Karsten Graul wrote:
> On 27/10/2021 10:52, Tony Lu wrote:
>> From: Wen Gu <guwen@linux.alibaba.com>
>>
>> A socket_wq mismatch issue may occur because of fallback.
>>
>> When use SMC to replace TCP, applications add an epoll entry into SMC
>> socket's wq, but kernel uses clcsock's wq instead of SMC socket's wq
>> once fallback occurs, which means the application's epoll fd dosen't
>> work anymore.
> 
> I am not sure if I understand this fix completely, please explain your intentions
> for the changes in more detail.
> 
> What I see so far:
> - smc_create() swaps the sk->sk_wq of the clcsocket and the new SMC socket
>    - sets clcsocket sk->sk_wq to smcsocket->wq (why?)
>    - sets smcsocket sk->sk_wq to clcsocket->wq (why?)
> - smc_switch_to_fallback() resets the clcsock sk->sk_wq to clcsocket->wq
> - smc_accept() sets smcsocket sk->sk_wq to clcsocket->wq when it is NOT fallback
>    - but this was already done before in smc_create() ??
> - smc_poll() now always uses clcsocket->wq for the call to sock_poll_wait()
> 
> In smc_poll() the comment says that now clcsocket->wq is used for poll, whats
> the relation between socket->wq and socket->sk->sk_wq here?
> 

Thanks for your reply.

Before explaining my intentions, I thought it would be better to 
describe the issue I encountered first：

In nginx/wrk tests, when nginx uses TCP and wrk uses SMC to replace TCP, 
wrk should fall back to TCP and get correct results theoretically, But 
in fact it only got all zeros.

For example:
server: nginx -g 'daemon off;'

client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html

   Running 5s test @ http://11.200.15.93/index.html
     1 threads and 1 connections
     Thread Stats   Avg      Stdev     Max   ± Stdev
         Latency     0.00us    0.00us   0.00us    -nan%
         Req/Sec     0.00      0.00     0.00      -nan%
        0 requests in 5.00s, 0.00B read
     Requests/sec:      0.00
     Transfer/sec:       0.00B

The reason for this result is that:

1) Before fallback: wrk uses epoll_insert() to associate an epoll fd 
with a smc socket, adding eppoll_entry into smc socket->wq, allowing 
itself to be notified when events such as EPOLL_OUT/EPOLL_IN occur on 
the smc socket.

2) After fallback: smc_switch_to_fallback() set fd->private_data as 
clcsocket. wrk starts to use TCP stack and kernel calls tcp_data_ready() 
when receving data, which uses clcsocket sk->sk_wq (equal to 
clcsocket->wq). As a result, the epoll fd hold by wrk in 1) can't 
receive epoll events and wrk stops transmitting data.

So the root cause of the issue is that wrk's eppoll_entry always stay in 
smcsocket->wq, but kernel turns to wake up 
clcsocket->sk->sk_wq(clcsocket->wq) after fallback, which makes wrk's 
epoll fd unusable.

[before fallback]
    application
         ^
         |
       (poll)
         |
         v
   smc socket->wq            clcsocket->wq
(has eppoll_entry)                .
         .                         .
         .                         .
         .                         .
         .                         .
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
         ^                         ^
         |                         |
         | (data)                  |(tcp handshake in rendezvous)
         v                         v
|-------------------------------------------|
|                                           |
| sk_data_ready / sk_write_space ..         |
|                                           |
|-------------------------------------------|

[after fallback]
    application--------------------|
                         (cant poll anything)
                                   |
                                   |
                                   v
   smc socket->wq            clcsocket->wq
(has eppoll_entry)                .
         .                         .
         .                         .
         .                         .
         .                         .
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
                                   ^
                                   |
                                   |(data)
                                   v
|-------------------------------------------|
|                                           |
| sk_data_ready / sk_write_space ..         |
|                                           |
|-------------------------------------------|


This patch's main idea is that since wait queue is switched from smc 
socket->wq to clcsocket->wq after fallback, making eppoll_entry in smc 
socket->wq unusable, maybe we can try to put eppoll_entry into 
clcsocket->wq at the beginning, set smc socket sk->sk_wq to 
clcsocket->wq before fallback, and reset clcsocket sk->sk_wq to 
clcsocket->wq after fallback. So that no matter whether fallback occurs, 
the kernel always wakes up clcsocket->wq to notify applications.


Therefore, the main modifications of this patch are as follows:

1) smc_poll() always uses clcsocket->wq for the call to sock_poll_wait()

After this modification, the user application's eppoll_entry will be 
added into clcsocket->wq at the beginning instead of smc socket->wq, 
allowing application's epoll fd to receive events such as EPOLL_IN even 
when a fallback occurs.

2) Swap the sk->sk_wq of the clcsocket and the new SMC socket in 
smc_create()

Sets smcsocket sk->sk_wq to clcsocket->wq. If SMC is used and NOT 
fallback, the sk_data_ready() will wake up clcsocket->wq, and user 
application's epoll fd will receive epoll events.

Sets clcsocket sk->sk_wq to smcsocket->wq. Since clcsocket->wq is 
occupied by smcsocket sk->sk_wq, clcsocket sk->sk_wq have to use another 
wait queue (smc socket->wq) during TCP handshake in rendezvous.

3) smc_switch_to_fallback() resets the clcsocket sk->sk_wq to clcsocket->wq

Once a fallback occurs, user application will start using clcsocket. At 
this point, clcsocket sk->sk_wq should be reseted to clcsocket->wq 
because eppoll_entry is in clcsocket->wq.

4) smc_accept() sets smcsocket sk->sk_wq to clcsocket->wq when it is NOT 
fallback

The reason for doing this on the listening side is simmilar to 
smc_create(): using clcsocket->wq in concert with smc_poll() when it is 
NOT fallback. For your query 'this was already done before in 
smc_create() ? ', the new smc socket here in smc_accept() seems be 
different from the smc socket created in smc_create().

So after the fix:

[before fallback]
    application--------------------|
                                (poll)
                                   |
                                   |
                                   v
   smc socket->wq            clcsocket->wq
          .                (has eppoll_entry)
             `   .                  .
                     `  .  .   `
                 .    `    `   .
            `                      `
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
         ^                         ^
         |                         |
         |(data)                   |(tcp handshake)
         v                         v
|-------------------------------------------|
|                                           |
| sk_data_ready / sk_write_space ..         |
|                                           |
|-------------------------------------------|

[after fallback]
    application--------------------|
                                (poll)
                                   |
                                   |
                                   v
   smc socket->wq            clcsocket->wq
         .                 (has eppoll_entry)
             `   .                  .
                     `   .          .
                            `   .   .
                                    `
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
                                    ^
                                    |(data)
                                    v
|-------------------------------------------|
|                                           |
| sk_data_ready / sk_write_space ..         |
|                                           |
|-------------------------------------------|


Cheers,
Wen Gu
