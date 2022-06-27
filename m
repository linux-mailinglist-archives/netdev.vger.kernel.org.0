Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F8B55DE3A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiF0UEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241066AbiF0UEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:04:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF11CFD9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:04:19 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p7so17152854ybm.7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5ArcqYBTaxDGs/5OLd2oMUOC2ZpqTyatswM4thn5gU=;
        b=RPM1Da+o8zIonvUkm5Y1fXk1vVkZMKgrr16purejZ9M6UHOoRgJWrkpj0IdxJwgbeN
         GUtAGNGBrqlRqEU0j1Pe+lvTu9PF+L5sb1x1p0GYEEwBmUqqTkHrZOhmVOnSFRGhu+nI
         LZggcBP17inpcFYYB7aoZn3IctBH5PfpWrlAnRlQVNrUjIAFSlDegYfC03J5AnWVyVzU
         oGfzgXJm1d+mELTuaCK4Hd8/2i4Dj2sbgXTexCc6HShesUBI7tzm4SRpAl1W7jQSTH2u
         eBk/i4aV/Vg/YIGUG1WYyzskJLIPlHgsdkg5c7iqI0Hp3NUckHWpri+hIt0p+Tjcip1s
         ltMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5ArcqYBTaxDGs/5OLd2oMUOC2ZpqTyatswM4thn5gU=;
        b=7pYotm/WveUpt7oUWyp08V1dSI1RG+766fGvAddSgjyS+ANSrKo7IsuqFP2sNS1RiH
         esPuPFjgt8gl3Q4ANXRLrDrVnapKfpxtehrCyN+sEd484rMOJXThcL02xxZNbsFs+2Fc
         FO0CSFmA40rSEoXGgngo5ZJuDXdIVJOI8WP0AyLch6BhSDM2hSFQM+rcgRVtWGf3Fr38
         5TXntmwbxr9echlYZFfPxbcY6OHHH08Isqp76TlNhA0VAbL+Cys69mhvxM32MKe7j2Zt
         yMej6uDb18/85XF98MxwjlnQej9dlCP8H8ZtupGFpi+NjK1DZjID69RW3wnYoV+s5sZt
         T1PQ==
X-Gm-Message-State: AJIora/H1erUu7Xz5qiwbGenMHhts+9kpW9ANmSJcI6RTbIupG+qfe5w
        4YqOxwVFbsx7NNYR1u1Wu+80r6ZvjAJcmB2DpAZ6Mw==
X-Google-Smtp-Source: AGRyM1v4qkTKlFp6V95ewXcsdJbrr3BDNjSxpt+w+ysG1ABzGlFusWU+Oqf8bJvjxUJZkekd1D0vymPNosnFAD95wpo=
X-Received: by 2002:a25:31c1:0:b0:66c:a63d:eaf0 with SMTP id
 x184-20020a2531c1000000b0066ca63deaf0mr9879355ybx.55.1656360258755; Mon, 27
 Jun 2022 13:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJsk7g0LcH17u=JbLy5dwYi0QVg84b3c5eLf-zUTK5b8g@mail.gmail.com>
 <20220627195949.12000-1-kuniyu@amazon.com>
In-Reply-To: <20220627195949.12000-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 22:04:07 +0200
Message-ID: <CANn89i+LFrwW_oYBHdCoFf1Z+v+LMJ=AzQyh+EYyHmcRBStZfw@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:00 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Mon, 27 Jun 2022 21:36:18 +0200
> > On Mon, Jun 27, 2022 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Mon, 27 Jun 2022 21:06:14 +0200
> > > > On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > > > > > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > From:   Jakub Kicinski <kuba@kernel.org>
> > > > > > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > > > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > > > > > >
> > > > > > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > > > > > table and can use it directly.
> > > > > > > > >
> > > > > > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > > > > >
> > > > > > > > > I am not quite certain the savings of a single entry table justivies
> > > > > > > > > the complexity.  But the looks correct.
> > > > > > > >
> > > > > > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > > > > > Could you add more details to explain the motivation?
> > > > > > >
> > > > > > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > > > > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > > > > > memory on a host with thousands of netns, but it can be waste if we do not
> > > > > > > have its protocol family's sockets.
> > > > > >
> > > > > > For the record, I doubt we will accept such a patch (per net-ns
> > > > > > TCP/UDP hash tables)
> > > > >
> > > > > Is it because it's risky?
> > > >
> > > > Because it will be very expensive. TCP hash tables are quite big.
> > >
> > > Yes, so I'm wondering if changing the size by sysctl makes sense.  If we
> > > have per-netns hash tables, each table should have smaller amount of
> > > sockets and smaller size should be enough, I think.
> >
> > How can a sysctl be safely used if two different threads call "unshare
> > -n" at the same time ?
>
> I think two unshare are safe. Each of them reads its parent netns's sysctl
> knob.  Even when the parent is the same, they can read the same value.

How can one thread create a netns with a TCP ehash table with 1024 buckets,
and a second one create a netns with a TCP ehash table with 1 million
buckets at the same time,
if they share the same sysctl ???

>
> But I think we need READ_ONCE()/WRITE_ONCE() in such a sysctl.

Like all sysctls really.

  While
> creating a child netns, another one can change the value and there can be
> a data-race.  So we have to use custome handler and pass write/read handler
> as conv of do_proc_douintvec(), like do_proc_douintvec_conv_lockless().
>
> If there are some sysctls missing READ_ONCE/WRITE_ONCE(), I will add
> more general one, proc_douintvec_lockless().

Seriously, all sysctls can be set while being read. That is not something new.

>
>
> > > > [    4.917080] tcp_listen_portaddr_hash hash table entries: 65536
> > > > (order: 8, 1048576 bytes, vmalloc)
> > > > [    4.917260] TCP established hash table entries: 524288 (order: 10,
> > > > 4194304 bytes, vmalloc hugepage)
> > > > [    4.917760] TCP bind hash table entries: 65536 (order: 8, 1048576
> > > > bytes, vmalloc)
> > > > [    4.917881] TCP: Hash tables configured (established 524288 bind 65536)
> > > >
> > > >
> > > >
> > > > > IIRC, you said we need per netns table for TCP in the future.
> > > >
> > > > Which ones exactly ? I guess you misunderstood.
> > >
> > > I think this.
> > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=04c494e68a13
> >
> > "might" is very different than "will"
> >
> > I would rather use the list of time_wait, instead of adding huge
> > memory costs for hosts with hundreds of netns.
>
> Sorry, my bad.
> I would give it a try only for TIME_WAIT.
