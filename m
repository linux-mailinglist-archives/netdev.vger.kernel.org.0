Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60636470790
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244592AbhLJRqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:46:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47984 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244537AbhLJRqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:46:55 -0500
Date:   Fri, 10 Dec 2021 18:43:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639158198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BdFa2JqpwhE1mXlGPXx0yDHvonQGo/CXZcNv1TtbcMA=;
        b=eOMxhEwpfuF5nkgWOV7jjVg+vpEh2CtqnLHE3T2lbuR00GFU2vyi9zetzlkZtC+sQG0vah
        XzJjfN+iULN4Mm2//cGY5nSDgc5ETJLcVxAdJ+qGBBNeB2Mq7Bl9vEgN/1h68TxhSayAbh
        g0OeYJFVVWdTt0kq+i5XBXVv5G7ffcWuwcyALCFrfJp3VAn9nqsqVHgokTx/8q7/Xbdk3g
        bLykfk0eU+zvzaM/WpmS4n5zQJsjoWSYQ4/0w0R0lIrlDXrkTefeKUIsjp+Yba9sJUitIW
        AlTIFR343IEROh3KUuJEC5D3QzIfaJsucnz3yHbtjKFKKpIekxY8GiWfe/PAaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639158198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BdFa2JqpwhE1mXlGPXx0yDHvonQGo/CXZcNv1TtbcMA=;
        b=i8n4WkwuebQYXcwrjV1UsY9oZ8veJulZguPW0YyNryaEP7b3C1+s+GQVxaa4/fxwoRsLCr
        zaQw1tf8vJCrziDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbORtbuORp7HJGUl@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
 <YbOEaSQW+LtWjuzI@linutronix.de>
 <CANn89i+zyeMJVhNmEEhwE0oaRvD-m0ZR9w1+ScsvpWZEuP9G5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANn89i+zyeMJVhNmEEhwE0oaRvD-m0ZR9w1+ScsvpWZEuP9G5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-10 08:52:55 [-0800], Eric Dumazet wrote:
>=20
> Problem is that if you have a qdisc, qdisc_dequeue() will not know that t=
he
> packet queued by high prio thread needs to shortcut all prior packets and
> be sent right away.

That is correct.

> Because of that, it seems just better that a high prio thread returns
> immediately and let the dirty work (dequeue packets and send them to devi=
ces)
> be done by other threads ?

Ah okay. Lets say you have a task sending a packet every 100ms. And you
want that packet to leave the NIC asap. This is your task with
SCHED_FIFO 70 priority. IMPORTANT otherwise.
Lets say you have a ssh session on the same NIC running at SCHED_OTHER.
Nothing important obviously.

The NIC is idle, ssh sends a keep-alive, 80 bytes, one skb.=20
    SCHED_OTHER, SSH, CPU0                                    FIFO 70, IMPO=
RTANT, CPU1
  __dev_xmit_skb()
    -> spin_lock(root_lock);
    -> qdisc_run_begin()
      -> __test_and_set_bit(__QDISC_STATE2_RUNNING);
    -> sch_direct_xmit()
        *PREEMPT* (by something else)
                                                            __dev_xmit_skb()
                                                            -> spin_lock(ro=
ot_lock);
                                                           <--- PI-boost
      -> spin_unlock(root_lock);  =20
         *PREEMPT* again     ---> PI boost ends after unlock
                                                            -> qdisc_run_be=
gin()
                                                              -> __test_and=
_set_bit(__QDISC_STATE2_RUNNING) (nope);
                                                             -> dev_qdisc_e=
nqueue()
                                                             -> qdisc_run_b=
egin() returns false
                                                            -> spin_unlock(=
root_lock);

at this point, we don't return to the SSH thread, instead other RT tasks
are running. That means that the SSH thread, which owns the qdisc and
the NIC, remains preempted and the NIC idle.

300ms pass by, the IMPORTANT thread queued two additional packets.
Now, a few usecs later, all SCHED_FIFO tasks go idle on CPU0, and the
SSH thread can continue with dev_hard_start_xmit() and send its packet,=20
    -> dev_hard_start_xmit()
    __qdisc_run() (yes, and the three additional packets)
    =E2=80=A6

By always acquiring the busy-lock, in the previous scenario, the task
with the high-priority allows the low-priority task to run until
qdisc_run_end() at which point it releases the qdisc so the
high-priority task can actually send packets.

One side note: This scenario requires two CPUs (one for low priority
task that gets preempted and owns the qdisc, and one one for high
priority task that wants to sends packets).
With one CPU only the local_bh_disable() invocation would ensure that
low-priority thread left the bh-disable section entirely.

> > > Thanks!
> > >
> > > Paolo
> >

Sebastian
