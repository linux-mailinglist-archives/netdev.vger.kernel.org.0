Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C714A83F1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350566AbiBCMlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:41:15 -0500
Received: from mail.toke.dk ([45.145.95.12]:60029 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbiBCMlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:41:15 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1643892073; bh=zr/1jJJt+Aahk+VsboUVd75mq76qnpf+aAXAJsfCyh8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JsEdTy78l9T8WVG5JOODe0KJdItQyCmk7SloiR4DiH03gEvE8jiHzr4od6Islk56S
         22cs3BdcTjXI+smtRP+n+o7bZ+VmOAsWSejcIey/6kCDg064NJFa3iHFbOeqEhTGPX
         QHm314i2KLChaU+CVpIrDer/roHKkEzL/VPh/KbMke4rJHK+7/FtpLh5bTiCMPwsV5
         nTzh73xwkM3ZW4BMys5L6b0aYudp1cwQdVcMq6nA7RXuUX7Z1x8cLQkTSd2yAC2SRN
         3JsTdJwazW6yHNkMYU45TB/0knlpoq9SoG2Cv88I8dKiHqG5RKRNcA7jHj7g26IAPq
         TZy+0MYj2EDhA==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in
 netif_rx_internal().
In-Reply-To: <YfvH9YpKTIU4EByk@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk> <YfvH9YpKTIU4EByk@linutronix.de>
Date:   Thu, 03 Feb 2022 13:41:13 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87leysazrq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> On 2022-02-03 13:00:06 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Here is the code in larger context:
>> >
>> > #ifdef CONFIG_RPS
>> >     if (static_branch_unlikely(&rps_needed)) {
>> >         struct rps_dev_flow voidflow, *rflow =3D &voidflow;
>> >         int cpu;
>> >
>> >         preempt_disable();
>> >         rcu_read_lock();
>> >
>> >         cpu =3D get_rps_cpu(skb->dev, skb, &rflow);
>> >         if (cpu < 0)
>> >             cpu =3D smp_processor_id();
>> >
>> >         ret =3D enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>> >
>> >         rcu_read_unlock();
>> >         preempt_enable();
>> >     } else
>> > #endif
>> >
>> > This code needs the preempt_disable().
>>=20
>> This is mostly so that the CPU ID stays the same throughout that section
>> of code, though, right? So wouldn't it work to replace the
>> preempt_disable() with a migrate_disable()? That should keep _RT happy,
>> no?
>
> It would but as mentioned previously: BH is disabled and
> smp_processor_id() is stable.

Ah, right, because of the change in loopback to use netif_rx_ni()? But
that bit of the analysis only comes later in your series, so at the very
least you should be explaining this in the commit message here. Or you
could potentially squash patches 1 and 2 and do both changes at once,
since it's changing two bits of the same function and both need the same
analysis...

However, if we're going with Eric's suggestion of an internal
__netif_rx() for loopback that *doesn't* do local_bh_disable() then this
code would end up being called without BH disable, so we'd need the
migrate_disable() anyway, no?

-Toke
