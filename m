Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D4366026
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhDTT0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbhDTT0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:26:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04728C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:25:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y32so27341399pga.11
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o+yU8HQJaY94GLxvKts0LQFf5vy50wfWaxHoY8NFFYI=;
        b=Cyta8jIKlCMTSsAJ9+eDxbJSgkY8QKB9IEA8Xdsh4KW8/JVUeP5mmFqrXNlYHqUtIn
         Xm8FRZ6Ra4w9io8nfOmWZL019AjutZ/2Zgumqd2mVnU/wFTJ3sJsJIHIKbIIVzNicyxi
         54ag8OnGtkmAEbBZ5LG7kjr7GBTk+MURzAdeoyFt97mNcELK3jm74TidrnkXE+jQHFhD
         yIHJLbucMhE95icHmEfBSBnak+j/WqsAfKNAAzg/v41Oj5ICdp7ItRBFNFmuj9YQmL4b
         c11EIfLUEOIl8QTr5/0yKbZHX9FTVEIamxXIgr3yZcbGVXZVaF7rQbLLdiDXy13Z5pnN
         LwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o+yU8HQJaY94GLxvKts0LQFf5vy50wfWaxHoY8NFFYI=;
        b=VT/U3g+gqAbQDMi3JnrZUasfxJwLFOputL9FJ/11gHlWKcHnfOTCf+z850+cycDBJh
         wwyb9ypULEKWtf9FyA7xYbuoNs+qqpDPuUbGz16+iiZksWzPXQCRncIv+DUdbyQf4i6h
         51iLLvvqEIwKLHoFzwU6qoI9OJWaa1mc7kNNIVZ+Rc+u85pLQRTfGmS2uw78UjQk6e3B
         FJzwalEZrhQ174Ut2esKxSGuGX0vTxYLlyk0Uh25jiUS3c5nS7gugEDdNrOIcGfzXqDq
         hYQ0SOxKg0rOYFYYQ4sf7w7nqJeCx+FgdPwZdzzG17sEg0gBL/kDgfdjB8ehJYK4d4oR
         llPg==
X-Gm-Message-State: AOAM531+rLCtdbZasCEeGZeqTULxfaL3lxPshUdTyTKLtlHO6L/oLTQ0
        mrFqBZ+sGUlknls50Bu2NWhJ7kHqlSc7+d2Cj2c=
X-Google-Smtp-Source: ABdhPJyxvdJ8ymwH1Qw2Pa6zQatpcr3xxM/RSTvlSN+KNR7dlou9pwaNuGgod1tyJVBTyWZgOn5RjeKkUdlwAWzk49o=
X-Received: by 2002:a17:90a:f303:: with SMTP id ca3mr6629292pjb.145.1618946744481;
 Tue, 20 Apr 2021 12:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618844973.git.dcaratti@redhat.com> <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
 <CAM_iQpW3SPXJWeLf3Ck4QHZxetDuYcQJDFChUje3-4By8oGfnA@mail.gmail.com> <d16e3e5ade2a01ea4404c79abcc86b7d9868f611.camel@redhat.com>
In-Reply-To: <d16e3e5ade2a01ea4404c79abcc86b7d9868f611.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 20 Apr 2021 12:25:33 -0700
Message-ID: <CAM_iQpW5aafymtCJgFgALeHJwBz9jAZA8fBV1SHxGWmHYPZV1w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: sch_frag: fix stack OOB read while
 fragmenting IPv4 packets
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 1:59 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello Cong, thanks for looking at this!
>
> On Mon, 2021-04-19 at 11:46 -0700, Cong Wang wrote:
> > On Mon, Apr 19, 2021 at 8:24 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > > diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> > > index e1e77d3fb6c0..8c06381391d6 100644
> > > --- a/net/sched/sch_frag.c
> > > +++ b/net/sched/sch_frag.c
> > > @@ -90,16 +90,16 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
> > >         }
> > >
> > >         if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> > > -               struct dst_entry sch_frag_dst;
> > > +               struct rtable sch_frag_rt = { 0 };
> >
> > Is setting these fields 0 sufficient here? Because normally a struct table
> > is initialized by rt_dst_alloc() which sets several of them to non-zero,
> > notably, rt->rt_type and rt->rt_uncached.
> >
> > Similar for the IPv6 part, which is initialized by rt6_info_init().
>
> for what we do now in openvswitch and sch_frag, that should be
> sufficient: a similar thing is done by br_netfilter [1], apparently for
> the same "refragmentation" purposes. On a fedora host (running 5.10, but
> it shouldn't be much different than current Linux), I just dumped
> 'fake_rtable' from a bridge device:

Sounds fair. It looks like all of these cases merely use dst->dev->mtu,
so it is overkill to pass a full dst just to satisfy some callees.

Anyway, your patch should be okay as a fix for -net.

Thanks.
