Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8685F53F98B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiFGJXn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jun 2022 05:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbiFGJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:23:41 -0400
X-Greylist: delayed 514 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 02:23:39 PDT
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C7D340E2
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:23:38 -0700 (PDT)
X-Envelope-From: thomas@osterried.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 2579Eat51498908
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 7 Jun 2022 11:14:36 +0200
Received: from x-berg.in-berlin.de ([217.197.86.42] helo=smtpclient.apple)
        by x-berg.in-berlin.de with esmtpa (Exim 4.94.2)
        (envelope-from <thomas@osterried.de>)
        id 1nyVIJ-0001s8-OQ; Tue, 07 Jun 2022 11:14:35 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH net-next] ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
From:   Thomas Osterried <thomas@osterried.de>
In-Reply-To: <CANn89i+HbdWS4JU0odCbRApuCTGFAt9_NSUoCSFo-b4-z0uWCQ@mail.gmail.com>
Date:   Tue, 7 Jun 2022 11:14:34 +0200
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        LKML <linux-kernel@vger.kernel.org>, jreuter@yaina.de,
        =?utf-8?Q?Ralf_B=C3=A4chle_DL5RB?= <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E5F82D12-56D3-4040-A92B-C658772FD8DD@osterried.de>
References: <20220606162138.81505-1-duoming@zju.edu.cn>
 <CANn89i+HbdWS4JU0odCbRApuCTGFAt9_NSUoCSFo-b4-z0uWCQ@mail.gmail.com>
To:     Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Am 06.06.2022 um 19:31 schrieb Eric Dumazet <edumazet@google.com>:
> 
> On Mon, Jun 6, 2022 at 9:21 AM Duoming Zhou <duoming@zju.edu.cn> wrote:
>> 
>> The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
>> and block until it receives a packet from the remote. If the client
>> doesn`t connect to server and calls read() directly, it will not
>> receive any packets forever. As a result, the deadlock will happen.
>> 
>> The fail log caused by deadlock is shown below:
>> 
>> [  861.122612] INFO: task ax25_deadlock:148 blocked for more than 737 seconds.
>> [  861.124543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  861.127764] Call Trace:
>> [  861.129688]  <TASK>
>> [  861.130743]  __schedule+0x2f9/0xb20
>> [  861.131526]  schedule+0x49/0xb0
>> [  861.131640]  __lock_sock+0x92/0x100
>> [  861.131640]  ? destroy_sched_domains_rcu+0x20/0x20
>> [  861.131640]  lock_sock_nested+0x6e/0x70
>> [  861.131640]  ax25_sendmsg+0x46/0x420
>> [  861.134383]  ? ax25_recvmsg+0x1e0/0x1e0
>> [  861.135658]  sock_sendmsg+0x59/0x60
>> [  861.136791]  __sys_sendto+0xe9/0x150
>> [  861.137212]  ? __schedule+0x301/0xb20
>> [  861.137710]  ? __do_softirq+0x4a2/0x4fd
>> [  861.139153]  __x64_sys_sendto+0x20/0x30
>> [  861.140330]  do_syscall_64+0x3b/0x90
>> [  861.140731]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> [  861.141249] RIP: 0033:0x7fdf05ee4f64
>> [  861.141249] RSP: 002b:00007ffe95772fc0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
>> [  861.141249] RAX: ffffffffffffffda RBX: 0000565303a013f0 RCX: 00007fdf05ee4f64
>> [  861.141249] RDX: 0000000000000005 RSI: 0000565303a01678 RDI: 0000000000000005
>> [  861.141249] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> [  861.141249] R10: 0000000000000000 R11: 0000000000000246 R12: 0000565303a00cf0
>> [  861.141249] R13: 00007ffe957730e0 R14: 0000000000000000 R15: 0000000000000000
>> 
>> This patch moves the skb_recv_datagram() before lock_sock() in order
>> that other functions that need lock_sock could be executed.
>> 
> 
> 
> Why is this targeting net-next tree ?

Off-topic question for better understanding: when patches go to netdev,
when to net-next tree? Ah, found explanation it here (mentioning it
for our readers at linux-hams@):
  https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

> 1) A fix should target net tree
> 2) It should include a Fixes: tag

tnx for info. "Fix" in subject is not enough?


> Also:
> - this patch bypasses tests in ax25_recvmsg()
> - This might break applications depending on blocking read() operations.

We have discussed and verified it.

We had a deadlock problem (during concurrent read/write),
found by Thomas Habets, in
  https://marc.info/?l=linux-hams&m=159319049624305&w=2
Duoming found a second problem with current ax.25 implementation, that causes
deadlock not only for the userspace program Thomas had, but also in the kernel.

Thomas' patch did not made it to the git kernel net, because the testing bot
complained that there was no "goto out:" left, for label "out:".

Furhermore, before the test
          if (sk->sk_type == SOCK_SEQPACKET && sk->sk_state != TCP_ESTABLISHED) {
it's useful to do lock_sock(sk);

After reading through the documentation in the code above the skb_recv_datagram()
function, it should be safe to use this function without locking.
That's why we moved it to the top of ax25_recvmsg().


> I feel a real fix is going to be slightly more difficult than that.

It's interesting to see how other kernel drivers use skb_recv_datagram().
Many have copied the code of others. But in the end, there are various variants:



af_x25.c (for X.25) does it this way:

	lock_sock(sk);
if (x25->neighbour == NULL)
goto out;
..
if (sk->sk_state != TCP_ESTABLISHED)
goto out;
..
release_sock(sk);
skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
flags & MSG_DONTWAIT, &rc);
lock_sock(sk);

-> They lock for sk->sk_state tests, and then
release lock for skb_recv_datagram()



unix.c does it with a local lock in the unix socket struct:

mutex_lock(&u->iolock);
skb = skb_recv_datagram(sk, 0, 1, &err);
mutex_unlock(&u->iolock);
if (!skb)
return err;



netrom/af_netrom.c: It may have the same "deadlog hang" like af_ax25.c that Thomas observed.
-> may also be needed to fix.


rose/af_rose.c: does not use any locks (!)


vy 73,
	- Thomas  dl9sau


> 
> 
> Thank you
> 
>> Reported-by: Thomas Habets <thomas@@habets.se>
>> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>> ---
>> net/ax25/af_ax25.c | 11 ++++++-----
>> 1 file changed, 6 insertions(+), 5 deletions(-)
>> 
>> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
>> index 95393bb2760..02cd6087512 100644
>> --- a/net/ax25/af_ax25.c
>> +++ b/net/ax25/af_ax25.c
>> @@ -1665,6 +1665,11 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>>        int copied;
>>        int err = 0;
>> 
>> +       /* Now we can treat all alike */
>> +       skb = skb_recv_datagram(sk, flags, &err);
>> +       if (!skb)
>> +               goto done;
>> +
>>        lock_sock(sk);
>>        /*
>>         *      This works for seqpacket too. The receiver has ordered the
>> @@ -1675,11 +1680,6 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>>                goto out;
>>        }
>> 
>> -       /* Now we can treat all alike */
>> -       skb = skb_recv_datagram(sk, flags, &err);
>> -       if (skb == NULL)
>> -               goto out;
>> -
>>        if (!sk_to_ax25(sk)->pidincl)
>>                skb_pull(skb, 1);               /* Remove PID */
>> 
>> @@ -1725,6 +1725,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>> out:
>>        release_sock(sk);
>> 
>> +done:
>>        return err;
>> }
>> 
>> --
>> 2.17.1
>> 
> 

