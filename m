Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8ECA6A5B4F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjB1PHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjB1PHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:07:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AD52279A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:07:13 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id u6so6435653ilk.12
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4Dg3bWuAC01of15ogbTILKEkLBQR9ApgIidWXr32/4=;
        b=J9khXvqu/uDjTBcTS9tV1+jhQ/WUlB5MfgcQfzXz/SF9QwI69SoRdtz15YiP3UKP76
         CjaL4hISpwEfrqsayn0SIyPNh+S1Desl2q/zx+EQ/pBMCQ+UTOLT0a0YAAebWbVyM6tl
         UnwtaulQ7fwCQUn/FcrhjWRlFtYVjDv8D28S9ftX0pzGdwNeZgczgYK4shKr/tOE1cNK
         tqlQVSYyW0qsASSjqeexuV+72II1b2OJnnOXQO1heBy8CF9Lq/Cl0/vVDms5ndll8aO+
         zWIUMEpNxgsPL/AlcKvP01hHCDorfIYp0IfQ5YwIZejjTz0OpfX4x45ssIEM8W7n1fJz
         xpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4Dg3bWuAC01of15ogbTILKEkLBQR9ApgIidWXr32/4=;
        b=xPFr5GCcs4/rNoXR5ggEkQ2dda9cXKudqOh0sDKPFV3tPwTxydpuk8/M1VMu7urmsx
         j7jE4O0+zEtXxet6/gjmpdV21Kn+sIy+9ybiAaPHgX0Opqd1Cdjiq9g6Tpg5HHn+smAc
         3+cs4Y7ehNQ/g8A290bDQOABDLcX4Brywa89pp3FnQB1FJ57Ll7XPltFemKJc+zdXLM9
         ICSY+9aQ7bQDV1/1wr8yKkte6fVi3N2yv9Plqvx/96yz5EnrojIVRLb90nGamnPg1ZnP
         ijSJ/yW8pji4hg0XPPt6WVHVC0GolfyiM60+kmGwoRMLzCUoXxcsbQcYvqUj/rnkE/Iy
         wItg==
X-Gm-Message-State: AO0yUKUeSrF/bfO94/REVmhxumracEobo3Dm5m1pP4r9uvZ3w46VT89H
        wb0+RsZYY9g+3j5Qftnoa21DYbmmcoQpioJH5chrNQ==
X-Google-Smtp-Source: AK7set+rNNB04xn9Wyq81m4omFdzWOLsGL0mmM2F8clm6eMtYomWN0cUrtldrK9gkrN/hMx8gYOM/eNEe2M3kl4GxU8=
X-Received: by 2002:a05:6e02:1404:b0:315:9823:130c with SMTP id
 n4-20020a056e02140400b003159823130cmr1436653ilo.2.1677596832607; Tue, 28 Feb
 2023 07:07:12 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de>
In-Reply-To: <20230228132118.978145284@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 16:07:01 +0100
Message-ID: <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
Subject: Re: [patch 0/3] net, refcount: Address dst_entry reference count
 scalability issues
To:     Thomas Gleixner <tglx@linutronix.de>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 3:33=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> Hi!
>
> Wangyang and Arjan reported a bottleneck in the networking code related t=
o
> struct dst_entry::__refcnt. Performance tanks massively when concurrency =
on
> a dst_entry increases.

We have per-cpu or per-tcp-socket dst though.

Input path is RCU and does not touch dst refcnt.

In real workloads (200Gbit NIC and above), we do not observe
contention on a dst refcnt.

So it would be nice knowing in which case you noticed some issues,
maybe there is something wrong in some layer.

>
> This happens when there are a large amount of connections to or from the
> same IP address. The memtier benchmark when run on the same host as
> memcached amplifies this massively. But even over real network connection=
s
> this issue can be observed at an obviously smaller scale (due to the
> network bandwith limitations in my setup, i.e. 1Gb).
>
> There are two factors which make this reference count a scalability issue=
:
>
>    1) False sharing
>
>       dst_entry:__refcnt is located at offset 64 of dst_entry, which puts
>       it into a seperate cacheline vs. the read mostly members located at
>       the beginning of the struct.
>
>       That prevents false sharing vs. the struct members in the first 64
>       bytes of the structure, but there is also
>
>             dst_entry::lwtstate
>
>       which is located after the reference count and in the same cache
>       line. This member is read after a reference count has been acquired=
.
>
>       The other problem is struct rtable, which embeds a struct dst_entry
>       at offset 0. struct dst_entry has a size of 112 bytes, which means
>       that the struct members of rtable which follow the dst member share
>       the same cache line as dst_entry::__refcnt. Especially
>
>           rtable::rt_genid
>
>       is also read by the contexts which have a reference count acquired
>       already.
>
>       When dst_entry:__refcnt is incremented or decremented via an atomic
>       operation these read accesses stall and contribute to the performan=
ce
>       problem.

In our kernel profiles, we never saw dst->refcnt changes being a
serious problem.

>
>    2) atomic_inc_not_zero()
>
>       A reference on dst_entry:__refcnt is acquired via
>       atomic_inc_not_zero() and released via atomic_dec_return().
>
>       atomic_inc_not_zero() is implemted via a atomic_try_cmpxchg() loop,
>       which exposes O(N^2) behaviour under contention with N concurrent
>       operations.
>
>       Lightweight instrumentation exposed an average of 8!! retry loops p=
er
>       atomic_inc_not_zero() invocation in a userspace inc()/dec() loop
>       running concurrently on 112 CPUs.

User space benchmark <> kernel space.
And we tend not using 112 cpus for kernel stack processing.

Again, concurrent dst->refcnt changes are quite unlikely.

>
>       There is nothing which can be done to make atomic_inc_not_zero() mo=
re
>       scalable.
>
> The following series addresses these issues:
>
>     1) Reorder and pad struct dst_entry to prevent the false sharing.
>
>     2) Implement and use a reference count implementation which avoids th=
e
>        atomic_inc_not_zero() problem.
>
>        It is slightly less performant in the case of the final 1 -> 0
>        transition, but the deconstruction of these objects is a low
>        frequency event. get()/put() pairs are in the hotpath and that's
>        what this implementation optimizes for.
>
>        The algorithm of this reference count is only suitable for RCU
>        managed objects. Therefore it cannot replace the refcount_t
>        algorithm, which is also based on atomic_inc_not_zero(), due to a
>        subtle race condition related to the 1 -> 0 transition and the fin=
al
>        verdict to mark the reference count dead. See details in patch 2/3=
.
>
>        It might be just my lack of imagination which declares this to be
>        impossible and I'd be happy to be proven wrong.
>
>        As a bonus the new rcuref implementation provides underflow/overfl=
ow
>        detection and mitigation while being performance wise on par with
>        open coded atomic_inc_not_zero() / atomic_dec_return() pairs even =
in
>        the non-contended case.
>
> The combination of these two changes results in performance gains in micr=
o
> benchmarks and also localhost and networked memtier benchmarks talking to
> memcached. It's hard to quantify the benchmark results as they depend
> heavily on the micro-architecture and the number of concurrent operations=
.
>
> The overall gain of both changes for localhost memtier ranges from 1.2X t=
o
> 3.2X and from +2% to %5% range for networked operations on a 1Gb connecti=
on.
>
> A micro benchmark which enforces maximized concurrency shows a gain betwe=
en
> 1.2X and 4.7X!!!

Can you elaborate on what networking benchmark you have used,
and what actual gains you got ?

In which path access to dst->lwtstate proved to be a problem ?

>
> Obviously this is focussed on a particular problem and therefore needs to
> be discussed in detail. It also requires wider testing outside of the cas=
es
> which this is focussed on.
>
> Though the false sharing issue is obvious and should be addressed
> independent of the more focussed reference count changes.
>
> The series is also available from git:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git
>
> I want to say thanks to Wangyang who analyzed the issue and provided
> the initial fix for the false sharing problem. Further thanks go to
> Arjan Peter, Marc, Will and Borislav for valuable input and providing
> test results on machines which I do not have access to.
>
> Thoughts?

Initial feeling is that we need more details on the real workload.

Is it some degenerated case with one connected UDP socket used by
multiple threads ?

To me, this looks like someone wanted to push a new piece of infra
(include/linux/rcuref.h)
and decided that dst->refcnt would be a perfect place.
Not the other way (noticing there is an issue, enquire networking
folks about it, before designing a solution)

Thanks



>
> Thanks,
>
>         tglx
> ---
>  include/linux/rcuref.h          |   89 +++++++++++
>  include/linux/types.h           |    6
>  include/net/dst.h               |   21 ++
>  include/net/sock.h              |    2
>  lib/Makefile                    |    2
>  lib/rcuref.c                    |  311 +++++++++++++++++++++++++++++++++=
+++++++
>  net/bridge/br_nf_core.c         |    2
>  net/core/dst.c                  |   26 ---
>  net/core/rtnetlink.c            |    2
>  net/ipv6/route.c                |    6
>  net/netfilter/ipvs/ip_vs_xmit.c |    4
>  11 files changed, 436 insertions(+), 35 deletions(-)
