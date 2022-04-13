Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9110E4FEE7A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 07:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiDMF0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 01:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiDMF0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 01:26:04 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C253A4F9E2;
        Tue, 12 Apr 2022 22:23:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V9xrwJG_1649827420;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V9xrwJG_1649827420)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 13:23:40 +0800
Date:   Wed, 13 Apr 2022 13:23:39 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Message-ID: <20220413052339.GJ35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220412202613.234896-1-axboe@kernel.dk>
 <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
 <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 08:01:10PM -0600, Jens Axboe wrote:
>On 4/12/22 7:54 PM, Eric Dumazet wrote:
>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
>>>>
>>>> On 4/12/22 13:26, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> If we accept a connection directly, eg without installing a file
>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>>>>> we have a socket for recv/send that we can fully serialize access to.
>>>>>
>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
>>>>> in that case. Some of the testing I've done has shown as much as 15%
>>>>> of overhead in the lock_sock/release_sock part, with this change then
>>>>> we see none.
>>>>>
>>>>> Comments welcome!
>>>>>
>>>> How BH handlers (including TCP timers) and io_uring are going to run
>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
>>>> non multi-threaded program), we would still to use the spinlock.
>>>
>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
>>> just the mutex. And we do check for running eg the backlog on release,
>>> which I believe is done safely and similarly in other places too.
>> 
>> So lets say TCP stack receives a packet in BH handler... it proceeds
>> using many tcp sock fields.
>> 
>> Then io_uring wants to read/write stuff from another cpu, while BH
>> handler(s) is(are) not done yet,
>> and will happily read/change many of the same fields
>
>But how is that currently protected? The bh spinlock is only held
>briefly while locking the socket, and ditto on the relase. Outside of
>that, the owner field is used. At least as far as I can tell. I'm
>assuming the mutex exists solely to serialize acess to eg send/recv on
>the system call side.

Hi jens,

I personally like the idea of using iouring to improve the performance
of the socket API.

AFAIU, the bh spinlock will be held by the BH when trying to make
changes to those protected fields on the socket, and the userspace
will try to hold that spinlock before it can change the sock lock
owner field.

For example:
in tcp_v4_rcv() we have

        bh_lock_sock_nested(sk);
        tcp_segs_in(tcp_sk(sk), skb);
        ret = 0;
        if (!sock_owned_by_user(sk)) {
                ret = tcp_v4_do_rcv(sk, skb);
        } else {
                if (tcp_add_backlog(sk, skb, &drop_reason))
                        goto discard_and_relse;
        }
        bh_unlock_sock(sk);

When this is called in the BH, it will first hold the bh spinlock
and then check the owner field, tcp_v4_do_rcv() will always been
protected by the bh spinlock.

If the user thread tries to make changes to the socket, it first
call lock_sock() which will also try to hold the bh spinlock, I
think that prevent the race.

  void lock_sock_nested(struct sock *sk, int subclass)
  {
          /* The sk_lock has mutex_lock() semantics here. */
          mutex_acquire(&sk->sk_lock.dep_map, subclass, 0, _RET_IP_);

          might_sleep();
          spin_lock_bh(&sk->sk_lock.slock);
          if (sock_owned_by_user_nocheck(sk))
                  __lock_sock(sk);
          sk->sk_lock.owned = 1;
          spin_unlock_bh(&sk->sk_lock.slock);
  }

But if we remove the spinlock in the lock_sock() when sk_no_lock
is set to true. When the the bh spinlock is already held by the BH,
it seems the userspace won't respect that anymore ?

Maybe I missed something too...

>
>Hence if we can just make the owner check/set sane, then it would seem
>to be that it'd work just fine. Unless I'm still missing something here.
>
>> Writing a 1 and a 0 in a bit field to ensure mutual exclusion is not
>> going to work,
>> even with the smp_rmb() and smp_wmb() you added (adding more costs for
>> non io_uring users
>> which already pay a high lock tax)
>
>Right, that's what the set was supposed to improve :-)
>
>In all fairness, the rmb/wmb doesn't even measure compared to the
>current socket locking, so I highly doubt that any high frequency TCP
>would notice _any_ difference there. It's dwarfed by fiddling the mutex
>and spinlock already.
>
>But I agree, it may not be 100% bullet proof. May need actual bitops to
>be totally safe. Outside of that, I'm still failing to see what kind of
>mutual exclusion exists between BH handlers and a system call doing a
>send or receive on the socket.
>
>> If we want to optimize the lock_sock()/release_sock() for common cases
>> (a single user thread per TCP socket),
>> then maybe we can play games with some kind of cmpxchg() games, but
>> that would be a generic change.
>
>Sure, not disagreeing on that, but you'd supposedly still need the mutex
>to serialize send or receives on the socket for those cases.
>
>-- 
>Jens Axboe
