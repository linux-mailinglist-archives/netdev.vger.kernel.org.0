Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A946A5D49
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjB1Qi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjB1Qis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:38:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9535A1;
        Tue, 28 Feb 2023 08:38:26 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677602305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGAS1nlVnYYE/Wk69Z9hKYgT1cedX3d5tVr1dmMyxJM=;
        b=Xiiami2Wj+m4eIgzQZPe9OfQskWhh4P48+x4tkgcoc+ySBBbaNzYSpmJmVxqZYmh2CYEyt
        nn1PIo329HCDS1sOh7pQzb4G0eg4ePLWxGiQdXWswYE3MOlwqpehwgBoJe+AHKDBeD6gEY
        z6vJrD30DcvXqmFmpgeSviLDjMUA5JMgGELi+nh/BKaR9tGW/91XXA5A0VGxuViDY+1iTI
        goq4m7/7C81+KVEON5JOfCyyNV9VTfGPaKf3L+HQRuKOWNOC9e21uuq3fyPUTyKuK2gmRg
        OYwwg5DAFsOcGRqya3vUyovxjFylv29lXQRN1wro+EKxwz1cDtbZSPoGj0ouxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677602305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGAS1nlVnYYE/Wk69Z9hKYgT1cedX3d5tVr1dmMyxJM=;
        b=X2Ab+vjet8s27Gutg4vBPLjLfZUrBxYKgmpRIDXbW44kagEfuEL6PiovGBv1gg1FOMuFK2
        3v+P66ZWAiXXHKAg==
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
In-Reply-To: <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
References: <20230228132118.978145284@linutronix.de>
 <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
Date:   Tue, 28 Feb 2023 17:38:25 +0100
Message-ID: <87h6v5n3su.ffs@tglx>
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

On Tue, Feb 28 2023 at 16:07, Eric Dumazet wrote:
> On Tue, Feb 28, 2023 at 3:33=E2=80=AFPM Thomas Gleixner <tglx@linutronix.=
de> wrote:
>>
>> Hi!
>>
>> Wangyang and Arjan reported a bottleneck in the networking code related =
to
>> struct dst_entry::__refcnt. Performance tanks massively when concurrency=
 on
>> a dst_entry increases.
>
> We have per-cpu or per-tcp-socket dst though.
>
> Input path is RCU and does not touch dst refcnt.
>
> In real workloads (200Gbit NIC and above), we do not observe
> contention on a dst refcnt.
>
> So it would be nice knowing in which case you noticed some issues,
> maybe there is something wrong in some layer.

Two lines further down I explained which benchmark was used, no?

>> This happens when there are a large amount of connections to or from the
>> same IP address. The memtier benchmark when run on the same host as
>> memcached amplifies this massively. But even over real network connectio=
ns
>> this issue can be observed at an obviously smaller scale (due to the
>> network bandwith limitations in my setup, i.e. 1Gb).
>>       atomic_inc_not_zero() is implemted via a atomic_try_cmpxchg() loop,
>>       which exposes O(N^2) behaviour under contention with N concurrent
>>       operations.
>>
>>       Lightweight instrumentation exposed an average of 8!! retry loops =
per
>>       atomic_inc_not_zero() invocation in a userspace inc()/dec() loop
>>       running concurrently on 112 CPUs.
>
> User space benchmark <> kernel space.

I know that. The point was to illustrate the non-scalability.

> And we tend not using 112 cpus for kernel stack processing.
>
> Again, concurrent dst->refcnt changes are quite unlikely.

So unlikely that they stand out in that particular benchmark.

>> The overall gain of both changes for localhost memtier ranges from 1.2X =
to
>> 3.2X and from +2% to %5% range for networked operations on a 1Gb connect=
ion.
>>
>> A micro benchmark which enforces maximized concurrency shows a gain betw=
een
>> 1.2X and 4.7X!!!
>
> Can you elaborate on what networking benchmark you have used,
> and what actual gains you got ?

I'm happy to repeat here that it was memtier/memcached as I explained
more than once in the cover letter.

> In which path access to dst->lwtstate proved to be a problem ?

ip_finish_output2()
   if (lwtunnel_xmit_redirect(dst->lwtstate)) <- This read

> To me, this looks like someone wanted to push a new piece of infra
> (include/linux/rcuref.h)
> and decided that dst->refcnt would be a perfect place.
>
> Not the other way (noticing there is an issue, enquire networking
> folks about it, before designing a solution)

We looked at this because the reference count operations stood out in
perf top and we analyzed it down to the false sharing _and_ the
non-scalability of atomic_inc_not_zero().

That's what made me to think about a different implementation and yes,
the case at hand, which happens to be in the network code, allowed me to
verify that it actually works and scales better.

I'm terrible sorry, that I missed to first ask network people for
permission to think. Won't happen again.

Thanks,

        tglx
