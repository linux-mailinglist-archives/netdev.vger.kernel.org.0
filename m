Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6278336F62D
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhD3HLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 03:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhD3HK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 03:10:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D142DC06174A;
        Fri, 30 Apr 2021 00:10:07 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619766604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rwIZOjCYX5oRPn4FmgjCsgx7+wpws2WOW8zLM96m2WY=;
        b=vK3tq8tH1zI+sfd2pUcQ9ftMswswwvQSm54zXKX8VciEJdFvOkiGyDgGaUDUijPdn8HVLY
        IGlbdtikeH3V6gPpAyjpJyLaR3lPCaC5YGFle5Xdst2N9Iw2lmJ9SqydeYvU8I8sMYhjNo
        +4qpo+FEduuy96unXbXcb6ZPOnZDUeYTdLotkh+IST6IkyeGrfCZt1/IlgidZB6++AEL2X
        kA206uzJHxeI4CXMpmvHDNVQNjWk6pYvkAu61WK4hKJAbgR8BB0iOqRScBoQvBrjUgt4RG
        wV+nESY2z9vMQ1afYgtFqHsJUNTkt2xwkif3GpXdBfI4/DBEXc9IKwr26iFspg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619766604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rwIZOjCYX5oRPn4FmgjCsgx7+wpws2WOW8zLM96m2WY=;
        b=h30y68qstuv/q4zDZFQoQ9gewIxs/Kjkiu9V2uJT5nFguBfUijUUdQINd1Emp3eUJdANYk
        w++bgcbY3aAlB8Cg==
To:     Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to houskeeping CPUs
In-Reply-To: <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
References: <20200625223443.2684-1-nitesh@redhat.com> <20200625223443.2684-2-nitesh@redhat.com> <3e9ce666-c9cd-391b-52b6-3471fe2be2e6@arm.com> <20210127121939.GA54725@fuller.cnet> <87r1m5can2.fsf@nanos.tec.linutronix.de> <20210128165903.GB38339@fuller.cnet> <87h7n0de5a.fsf@nanos.tec.linutronix.de> <20210204181546.GA30113@fuller.cnet> <cfa138e9-38e3-e566-8903-1d64024c917b@redhat.com> <20210204190647.GA32868@fuller.cnet> <d8884413-84b4-b204-85c5-810342807d21@redhat.com> <87y2g26tnt.fsf@nanos.tec.linutronix.de> <d0aed683-87ae-91a2-d093-de3f5d8a8251@redhat.com> <7780ae60-efbd-2902-caaa-0249a1f277d9@redhat.com> <07c04bc7-27f0-9c07-9f9e-2d1a450714ef@redhat.com> <20210406102207.0000485c@intel.com> <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com> <20210414091100.000033cf@intel.com> <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com> <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
Date:   Fri, 30 Apr 2021 09:10:04 +0200
Message-ID: <87czucfdtf.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh,

On Thu, Apr 29 2021 at 17:44, Nitesh Lal wrote:

First of all: Nice analysis, well done!

> So to understand further what the problem was with the older kernel based
> on Jesse's description and whether it is still there I did some more
> digging. Following are some of the findings (kindly correct me if
> there is a gap in my understanding):
>
> Part-1: Why there was a problem with the older kernel?
> ------
> With a kernel built on top of the tag v4.0.0 (with Jesse's patch reverted
> and irqbalance disabled), if we observe the/proc/irq for ixgbe device IRQs
> then there are two things to note:
>
> # No separate effective affinity (Since it has been introduced as a part =
of
>   the 2017 IRQ re-work)
>   $ ls /proc/irq/86/
>     affinity_hint  node  p2p1  smp_affinity  smp_affinity_list  spurious
>
> # Multiple CPUs are set in the smp_affinity_list and the first CPU is CPU=
0:
>
>   $ proc/irq/60/p2p1-TxRx-0
>     0,2,4,6,8,10,12,14,16,18,20,22
>
>   $ /proc/irq/61/p2p1-TxRx-1
>     0,2,4,6,8,10,12,14,16,18,20,22
>
>   $ /proc/irq/62/p2p1-TxRx-2
>     0,2,4,6,8,10,12,14,16,18,20,22
>      ...
>
>
> Now,  if we read the commit message from Thomas's patch that was part of
> this IRQ re-work:
> fdba46ff:  x86/apic: Get rid of multi CPU affinity
> "
> ..
> 2) Experiments have shown that the benefit of multi CPU affinity is close
>    to zero and in some tests even worse than setting the affinity to a si=
ngle
>    CPU.
>
> The reason for this is that the delivery targets the APIC with the lowest
> ID first and only if that APIC is busy (servicing an interrupt, i.e. ISR =
is
> not empty) it hands it over to the next APIC. In the conducted tests the
> vast majority of interrupts ends up on the APIC with the lowest ID anyway,
> so there is no natural spreading of the interrupts possible.=E2=80=9D
> "
>
> I think this explains why even if we have multiple CPUs in the SMP affini=
ty
> mask the interrupts may only land on CPU0.

There are two issues in the pre rework vector management:

  1) The allocation logic itself which preferred lower numbered CPUs and
     did not try to spread out the vectors accross CPUs. This was pretty
     much true for any APIC addressing mode.

  2) The multi CPU affinity support if supported by the APIC
     mode. That's restricted to logical APIC addressing mode. That is
     available for non X2APIC up to 8 CPUs and with X2APIC it requires
     to be in cluster mode.
=20=20=20=20=20
     All other addressing modes had a single CPU target selected under
     the hood which due to #1 was ending up on CPU0 most of the time at
     least up to the point where it still had vectors available.

     Also logical addressing mode with multiple target CPUs was subject
     to #1 and due to the delivery logic the lowest numbered CPU (APIC)
     was where most interrupts ended up.

Thanks,

        tglx
