Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEF86A6485
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCABA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCABAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:00:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79040305D5;
        Tue, 28 Feb 2023 17:00:23 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677632421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QglOkU+E40E4UoiB7Zs498/lMpTKRPGJQgFIki4BCCo=;
        b=PBPfB+48DvulpVDbyIInwg3wIldmV7E9BlDIgdujSDHHctA4OKN/PUGbI06Gk4KCt7cWaX
        okwpsJ8jXYL4YVybmk5HAxnSp3nwj1dF41yxe6PNsZa5Jwt2/HBartIWchIX0TkInNBEAp
        d/Vx+djV+WyTOArYXA+TzRQjbM/3oemOGOc3DxzN1eqCamzlZbTAukE1Jv9ac1cFECdgjT
        FmWfWmiX+R/wU61fnBBJ+C2rjFZvUpbCXwWTG61vj6b4S0LvDsiJruC+SlY63X67knKaAr
        uQaPytU9Wsm3RWSCJJoV6ekb71pUcaltwx2PL7xRvQekrXzpnjIJEXnPV9sERg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677632421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QglOkU+E40E4UoiB7Zs498/lMpTKRPGJQgFIki4BCCo=;
        b=GXeWbiV4Ml/iNVWyFWXspw+O3ShAjB8DwEXwZ4ipKvapeO0XimccoMbHKfdy617rtIKlmY
        gNFG6F26nK16zaAw==
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [patch 0/3] net, refcount: Address dst_entry reference count
 scalability issues
In-Reply-To: <CANn89iL_ey=S=FjkhJ+mk7gabOdVag6ENKnu9GnZkcF31qOaZA@mail.gmail.com>
References: <20230228132118.978145284@linutronix.de>
 <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
 <87h6v5n3su.ffs@tglx>
 <CANn89iL_ey=S=FjkhJ+mk7gabOdVag6ENKnu9GnZkcF31qOaZA@mail.gmail.com>
Date:   Wed, 01 Mar 2023 02:00:20 +0100
Message-ID: <871qm9mgkb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric!

On Tue, Feb 28 2023 at 17:59, Eric Dumazet wrote:
> On Tue, Feb 28, 2023 at 5:38=E2=80=AFPM Thomas Gleixner <tglx@linutronix.=
de> wrote:
>> >>       Lightweight instrumentation exposed an average of 8!! retry loo=
ps per
>> >>       atomic_inc_not_zero() invocation in a userspace inc()/dec() loop
>> >>       running concurrently on 112 CPUs.
>> >
>> > User space benchmark <> kernel space.
>>
>> I know that. The point was to illustrate the non-scalability.
>> >
>> > And we tend not using 112 cpus for kernel stack processing.

Just to be more clear. Scalability of atomic_inc_not_zero() tanks
already with a small number of concurrent operations. As explained in
the cover letter and in the changelogs. The worst case:

  It exposes O(N^2) behaviour under contention with N concurrent
  operations.

The actual impact depends on the micro-architecture. But O(N^2) is bad
by definition, right? It tanks way before 112 CPUs significantly.

>> > In which path access to dst->lwtstate proved to be a problem ?
>>
>> ip_finish_output2()
>>    if (lwtunnel_xmit_redirect(dst->lwtstate)) <- This read
>
> This change alone should be easy to measure, please do this ?

Moving lwtstate out also moves rtable::rt_genid out into the next
cacheline. So it's not that easy to measure the impact of moving
lwtstate alone.

We measured the impact of changing struct dst_entry seperately as you
can see from the changelog of the actual patch [1/3]:

  "The resulting improvement depends on the micro-architecture and the numb=
er
   of CPUs. It ranges from +20% to +120% with a localhost memtier/memcached
   benchmark."

It was very intentional _not_ to provide a single benchmark output to
boast about the improvement simply because the outcome differs
massively depending on the micro-architecture.

Here are 3 different contemporary machines to compare the impact of the
padding/reorder of dst_entry and the refcount.

memcached/memtier 1:100
                                A                       B                  =
     C

atomic_t baseline		10702			 6156			 11993
atomic_t + padding		12505   =3D 1.16x		13994  =3D 2.27x		 24997  =3D 2.08x=
=20
rcuref_t + padding		22888   =3D 2.13x		22080  =3D 3.58x		 25048  =3D 2.08x

atomic_t baseline		10702			 6156			 11993
rcuref_t			11843   =3D 1.10x		 9590  =3D 1.55x		 15434	=3D 1.28x=20=20

atomic_t + padding baseline	12505			13994			 24997
rcuref_t + padding		22888   =3D 1.83x		22080  =3D 1.57x		 25048  =3D 1.01x

See?

I surely could have picked the most prominent of each and made a bug
fuzz about it, but if you read the changelogs caerefully, I provided
range numbers which make this clear.

Here are perf top numbers from machine A with a cutoff at 1.00%:

  Baseline:

     14.24% [kernel] [k] __dev_queue_xmit
      7.12% [kernel] [k] ipv4_dst_check
      5.13% [kernel] [k] ip_finish_output2
      4.95% [kernel] [k] dst_release
      4.27% [kernel] [k] ip_rcv_finish_core.constprop.0

     35.71% SUBTOTAL

      3.86% [kernel] [k] ip_skb_dst_mtu
      3.85% [kernel] [k] ipv4_mtu
      3.58% [kernel] [k] raw_local_deliver
      2.44% [kernel] [k] tcp_v4_rcv
      1.45% [kernel] [k] tcp_ack
      1.32% [kernel] [k] skb_release_data
      1.23% [kernel] [k] _raw_spin_lock_irqsave

     53.44% TOTAL
=20=20=20=20=20=20=20=20=20
  Padding:=20=20=20=20
=20=20=20=20=20
     24.21% [kernel] [k] __dev_queue_xmit
      7.75% [kernel] [k] dst_release

     31.96% SUBTOTAL

      1.96% [kernel] [k] tcp_v4_rcv
      1.88% [kernel] [k] tcp_current_mss
      1.87% [kernel] [k] __sk_dst_check
      1.84% [kernel] [k] tcp_ack_update_rtt
      1.83% [kernel] [k] _raw_spin_lock_irqsave
      1.83% [kernel] [k] skb_release_data
      1.83% [kernel] [k] ip_rcv_finish_core.constprop.0
      1.70% [kernel] [k] __tcp_ack_snd_check
      1.67% [kernel] [k] tcp_v4_do_rcv
      1.39% [kernel] [k] tcp_ack
      1.20% [kernel] [k] __fget_light.part.0
      1.00% [kernel] [k] _raw_spin_lock_bh

     51.96% TOTAL
=20=20=20=20=20=20=20=20=20
  Padding + rcuref:
=20=20=20=20=20
      9.23% [kernel] [k] __dev_queue_xmit
      8.81% [kernel] [k] rcuref_put
      2.22% [kernel] [k] tcp_ack
      1.86% [kernel] [k] ip_rcv_finish_core.constprop.0

     18.04% SUBTOTAL

      1.86% [kernel] [k] tcp_v4_rcv
      1.72% [kernel] [k] tcp_current_mss
      1.69% [kernel] [k] skb_release_data
      1.58% [kernel] [k] tcp_ack_update_rtt
      1.56% [kernel] [k] __sk_dst_check
      1.50% [kernel] [k] _raw_spin_lock_irqsave
      1.40% [kernel] [k] __tcp_ack_snd_check
      1.40% [kernel] [k] tcp_v4_do_rcv
      1.39% [kernel] [k] __fget_light.part.0
      1.23% [kernel] [k] tcp_sendmsg_locked
      1.19% [kernel] [k] _raw_spin_lock_bh
      1.17% [kernel] [k] tcp_recvmsg_locked
      1.15% [kernel] [k] ipv4_mtu
      1.14% [kernel] [k] __inet_lookup_established
      1.10% [kernel] [k] ip_skb_dst_mtu
      1.02% [kernel] [k] tcp_rcv_established
      1.02% [kernel] [k] tcp_poll

     45.24% TOTAL

All the outstanding numbers above each SUBTOTAL are related to the
refcnt issues.

As you can see from the above numbers of the three example machines, the
relevant perf output would be totally different, but still correlated to
both the false sharing and the refcount performance.

> Oftentimes, moving a field looks sane, but the cache line access is
> simply done later.
> For example when refcnt is changed :)

Sorry, I can't decode what you are trying to tell me here.

> Making dsts one cache line bigger has a performance impact.

Sure. I'm not claiming that this is completely free. Whether it really
matters is a different story and that's why we are debating this, right?

>> We looked at this because the reference count operations stood out in
>> perf top and we analyzed it down to the false sharing _and_ the
>> non-scalability of atomic_inc_not_zero().
>>
>
> Please share your recipe and perf results.

Sorry for being not explicit enough about this, but I was under the
impression that explicitely mentioning memcached and memtier would be
enough of a hint for people famiiar with this matter.

Run memcached with -t $N and memtier_benchmark with -t $M and
--ratio=3D1:100 on the same machine. localhost connections obviously
amplify the problem,

Start with the defaults for $N and $M and increase them. Depending on
your machine this will tank at some point. But even in reasonably small
$N, $M scenarios the refcount operations and the resulting false sharing
fallout becomes visible in perf top. At some point it becomes the
dominating issue while the machine still has capacity...

> We must have been very lucky to not see this at Google.

There _is_ a world outside of Google? :)

Seriously. The point is that even if you @google cannot obverse this as
a major issue and it just gives your usecase a minimal 0.X gain, it
still is contributing to the overall performance, no?

I have surely better things to do than pushing the next newfangled
infrastrucure just because.

Thanks,

        tglx
