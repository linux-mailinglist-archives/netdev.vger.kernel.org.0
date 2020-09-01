Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A33E2597B2
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgIAPdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731184AbgIAPdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:33:31 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F86C061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 08:33:30 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f2so1343010qkh.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vstCf+2ozyYDDsY1FDuiQNquHfG3neT8y055PmuM2O4=;
        b=DceVnRiqW7Do8b5GQpw52IG+emIOhIDWDAfKAMJ6klO+x06NGJyGGwoGY0WUwCJqih
         rVmOe/L2DJLdEahYJ7ImE+LSgY0JKIbi8KNV8vJ/vOY5QWgvAlrP0PtbBkEtCdUJfHg+
         jz2hObzZMkccKAZcyiNKyw3YQ+ydrrl1QjeRFpYVN7LniPOri8ZG1mysBLLjVXIusm51
         Xj4xzhsadjkTVUU1Xg8Gl5/RBfeinJQTmY/HrBos9SSQhPATDNms2/xdHVic/L0TsbFh
         3sy7c/fLmvu3aYxN7ULX8nNKD2uMbHdXhZQoSuD84sHUdawNw6gE7gQTaPPvQJGhJxvq
         YTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vstCf+2ozyYDDsY1FDuiQNquHfG3neT8y055PmuM2O4=;
        b=rviMlIRN2Nz5SyyQeWZ9vGCiTNtzVHEewxBu/SOxttYbfBSOPhSjw75FpRol5W0sNC
         G26w2GQKrEaMhdRlW+DQBQkEABzSTKC1lM8NJhusFW6feoO9WnwV9IrNfsfFOzQvOZwF
         gxYAMjP0Ua4exhXaj+m63ffxAVmuFBgdSluZQSAAOJgmJ7H35vLal5s3dpyvHQJHoXNY
         Zb7yGFW94bSf/CaAj8R7dxSeBFnKIP3NfRJ8CL0DaPFAf5mbYBaEIk26ivrAxO57BYFi
         ijy+NEYuJ3cEdIvktH5Rh4rQe4qeI859r8NEcuvww0BYhQASdaStPpFuxeW5lKfIZiDy
         eesQ==
X-Gm-Message-State: AOAM532ASefe6gARtfovHKw7IkFc+9iGgli0jtUymW9jMfLTp+bSXBHI
        6wgnlujmd9H/r8hwxQYc0zIE6gUgwnFAA3FN+KRukA==
X-Google-Smtp-Source: ABdhPJz+PVmfEScoiPPq02gU1Gsd9Hjmvo9kyB25QFy6BvMWTuMC4+jl1qOxPtKzGj7JtIKCdIYNrfgi9EmJw2vAcT8=
X-Received: by 2002:a05:620a:815:: with SMTP id s21mr2434910qks.0.1598974409692;
 Tue, 01 Sep 2020 08:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200901065758.1141786-1-brianvv@google.com> <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
In-Reply-To: <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 1 Sep 2020 08:33:17 -0700
Message-ID: <CAMzD94Ru9P8DQB=8OX+z2vTNVt0SwbTuXcScGzmioZ73y4zx5w@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Eric Dumazet <edumazet@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 12:56 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > The problem is exposed when the system has multiple ifaces and
> > forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
> > clean the default route on all the ifaces which is not desired.
> >
> > This patches fixes that by cleaning only the routes where the iface has
> > forwarding enabled.
> >
> > Fixes: 830218c1add1 ("net: ipv6: Fix processing of RAs in presence of VRF")
>
>
>
>
>
> > Cc: David Ahern <dsa@cumulusnetworks.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >  net/ipv6/route.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index 5e7e25e2523a..41181cd489ea 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -4283,6 +4283,7 @@ static void __rt6_purge_dflt_routers(struct net *net,
> >                                      struct fib6_table *table)
> >  {
> >         struct fib6_info *rt;
> > +       bool deleted = false;
> >
> >  restart:
> >         rcu_read_lock();
> > @@ -4291,16 +4292,19 @@ static void __rt6_purge_dflt_routers(struct net *net,
> >                 struct inet6_dev *idev = dev ? __in6_dev_get(dev) : NULL;
> >
> >                 if (rt->fib6_flags & (RTF_DEFAULT | RTF_ADDRCONF) &&
> > -                   (!idev || idev->cnf.accept_ra != 2) &&
> > +                   (!idev || (idev->cnf.forwarding == 1 &&
> > +                              idev->cnf.accept_ra != 2)) &&
> >                     fib6_info_hold_safe(rt)) {
> >                         rcu_read_unlock();
> >                         ip6_del_rt(net, rt, false);
> > +                       deleted = true;
> >                         goto restart;
> >                 }
> >         }
> >         rcu_read_unlock();
> >
> > -       table->flags &= ~RT6_TABLE_HAS_DFLT_ROUTER;
> > +       if (deleted)
> > +               table->flags &= ~RT6_TABLE_HAS_DFLT_ROUTER;
>
>
> This seems wrong : We want to keep the flag set if at least one
> candidate route has not been deleted,
> so that next time rt6_purge_dflt_routers() is called, we can call
> __rt6_purge_dflt_routers() ?

Yes, you're right. Although current implementation doesn't hurt
because if any of those candidate routes were not deleted means that
they have accept_ra == 2 which overrules the router behaviour so we
won't clean the SLAAC anyway.
