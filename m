Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0B6A5DDD
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 18:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjB1RAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 12:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjB1RAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 12:00:09 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F74149AD
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 09:00:04 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id o8so6677819ilt.13
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 09:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJNYL3/Pn6dTb34xJuoqZG6IfhAivvzXJAcexxieRHo=;
        b=KDJDMpfb7g8KD+fKdfQpfBu6Jo1KW7VTvm5nFfXdQpAOYVoV98ExO/v3e0MWPgDAsZ
         ghPep1tF5BJbw/xtD2Weklv3NaWTfVYFjg0nDR+YwLNdVXko2hJgOhkX1I+CWn4iBPGI
         zNFfL4+voL96LrvD94V2ZeojyKwcDnrcGVQCveJSgGHUQQzr1azfvrNWFwZ4/AARvMrt
         CdtBcp8o8jEgPU2wDwa+/8giwagLCr3xL49T5qw4S3LCcjBakmtS+Yb86ptzkVLniDB4
         COimYuv7DJltRObcZ39x02GaL4CG1byqGWlh/2oeuavlA6gk0Io53/eKvX2od+r2MzGc
         0/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJNYL3/Pn6dTb34xJuoqZG6IfhAivvzXJAcexxieRHo=;
        b=BHPY9MOVaSKsPslDggnXNhWFNtozRv2mgGhpJeLgxPVREY5iEYL/PwuIH407OlSKzK
         1UNZL3TeUlvG+M5BmxHyKwcl/xqaNgS3O/LMaHEi8E5xGaeDQE37XdXIzOEaI23Xdfyy
         n0VBZT2znxNlmn+J3f4jNhae58Lw/orCrytqCCFn+VwInEiUCx4Q+uy5RgRTroSQLBj1
         ka1P3ahUGF0G+r00GKid9yHO/+oXdvPdJkwHyLo3SDBj2WIAie8UNYp9/SCq6Q+9vWjx
         0ZUuizerioz2Mdi9Yc1Ja4ueFwnyff4OFr7w5rwpNOrKIcfy+DXLCjIM0ouwD9+TD0k5
         QSJw==
X-Gm-Message-State: AO0yUKWMX2Nichwdw1IjVWZGn+DGHNgDpvuLo7hRjHDNQJoVkqk4qJbf
        H3wMyukfWQFdDQcV7SEt6koQPwcAcE9HgiCSDJD+Fg==
X-Google-Smtp-Source: AK7set+nSw4xJMuMPsHhlbqbyBOX5qCocRDopPGYlOlnKT5JOSMevUFr2cf1Vmpt4UjnrOsT6LlVCPME+ZzwG/vEarw=
X-Received: by 2002:a92:300c:0:b0:317:b01:229 with SMTP id x12-20020a92300c000000b003170b010229mr1711689ile.2.1677603603855;
 Tue, 28 Feb 2023 09:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de> <CANn89iL2pYt2QA2sS4KkXrCSjprz9byE_p+Geom3MTNPMzfFDw@mail.gmail.com>
 <87h6v5n3su.ffs@tglx>
In-Reply-To: <87h6v5n3su.ffs@tglx>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 17:59:52 +0100
Message-ID: <CANn89iL_ey=S=FjkhJ+mk7gabOdVag6ENKnu9GnZkcF31qOaZA@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 5:38=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> Eric!
>
> On Tue, Feb 28 2023 at 16:07, Eric Dumazet wrote:
> > On Tue, Feb 28, 2023 at 3:33=E2=80=AFPM Thomas Gleixner <tglx@linutroni=
x.de> wrote:
> >>
> >> Hi!
> >>
> >> Wangyang and Arjan reported a bottleneck in the networking code relate=
d to
> >> struct dst_entry::__refcnt. Performance tanks massively when concurren=
cy on
> >> a dst_entry increases.
> >
> > We have per-cpu or per-tcp-socket dst though.
> >
> > Input path is RCU and does not touch dst refcnt.
> >
> > In real workloads (200Gbit NIC and above), we do not observe
> > contention on a dst refcnt.
> >
> > So it would be nice knowing in which case you noticed some issues,
> > maybe there is something wrong in some layer.
>
> Two lines further down I explained which benchmark was used, no?
>
> >> This happens when there are a large amount of connections to or from t=
he
> >> same IP address. The memtier benchmark when run on the same host as
> >> memcached amplifies this massively. But even over real network connect=
ions
> >> this issue can be observed at an obviously smaller scale (due to the
> >> network bandwith limitations in my setup, i.e. 1Gb).
> >>       atomic_inc_not_zero() is implemted via a atomic_try_cmpxchg() lo=
op,
> >>       which exposes O(N^2) behaviour under contention with N concurren=
t
> >>       operations.
> >>
> >>       Lightweight instrumentation exposed an average of 8!! retry loop=
s per
> >>       atomic_inc_not_zero() invocation in a userspace inc()/dec() loop
> >>       running concurrently on 112 CPUs.
> >
> > User space benchmark <> kernel space.
>
> I know that. The point was to illustrate the non-scalability.
>
> > And we tend not using 112 cpus for kernel stack processing.
> >
> > Again, concurrent dst->refcnt changes are quite unlikely.
>
> So unlikely that they stand out in that particular benchmark.
>
> >> The overall gain of both changes for localhost memtier ranges from 1.2=
X to
> >> 3.2X and from +2% to %5% range for networked operations on a 1Gb conne=
ction.
> >>
> >> A micro benchmark which enforces maximized concurrency shows a gain be=
tween
> >> 1.2X and 4.7X!!!
> >
> > Can you elaborate on what networking benchmark you have used,
> > and what actual gains you got ?
>
> I'm happy to repeat here that it was memtier/memcached as I explained
> more than once in the cover letter.
>
> > In which path access to dst->lwtstate proved to be a problem ?
>
> ip_finish_output2()
>    if (lwtunnel_xmit_redirect(dst->lwtstate)) <- This read

This change alone should be easy to measure, please do this ?

Oftentimes, moving a field looks sane, but the cache line access is
simply done later.
For example when refcnt is changed :)

Making dsts one cache line bigger has a performance impact.

>
> > To me, this looks like someone wanted to push a new piece of infra
> > (include/linux/rcuref.h)
> > and decided that dst->refcnt would be a perfect place.
> >
> > Not the other way (noticing there is an issue, enquire networking
> > folks about it, before designing a solution)
>
> We looked at this because the reference count operations stood out in
> perf top and we analyzed it down to the false sharing _and_ the
> non-scalability of atomic_inc_not_zero().
>

Please share your recipe and perf results.

We must have been very lucky to not see this at Google.

tcp_rr workloads show dst_mtu() costs (60k GCU in Google fleet) ,
which outperform the dst refcnt you are mentioning here.
