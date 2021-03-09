Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA977332D56
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCIRdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhCIRc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:32:58 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8899AC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 09:32:58 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id c131so14778711ybf.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 09:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC6GSB0uid26yRhPck2cvVLewHW5/W5pfsGZ0mx0qJg=;
        b=a9IZV448IuDtvvuFPP1qVAio9cXYpLARi7lyW+S4reK+bI1OxU/Am9wi16v4AcJMVM
         utH6e0uV34IoEFBIOiQIgmutB6BkNzYgfQ4OtTxorON5pgy7td4OiU3Qbb/MT3dakLy7
         JIucSpG+D/11ICb9puq4bwkCwjslsb7Q5kUbbtKK1j5zFezxrLCTzU24n/t8ESiM3gvm
         5uVsJCwNuKrpKg1bNtQnP5KUvJ8OfB6To9xubthAnwjTRgl1XNWBtGbouaRdymJ6w5B4
         AuCicuAnv9blnqN00wYnp23ypDFykft55Cy4RTKOwEHqqJ+0b6K8wvBqiy7/b7Etbc8a
         xxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC6GSB0uid26yRhPck2cvVLewHW5/W5pfsGZ0mx0qJg=;
        b=p9qRqzXDjAJoZDaijs0h340VQO9IhFB1snDtGHt9vSl71+QBzlYOwGv+843tKFeV9D
         3XMEir9kpIkLJ9lmfXSjQlgWZMGkatqbC8Kq70YM3/pmgyHBFCD8/mfA/4tDi3kWDq7x
         5l+MWcEg1g6pkgpMvQT9+z66EGmc2Yd1/YGLVW+axH4LYbgCmxGjY2bVvaod4NYPoNJW
         8cbXAm3li6JAJevvqwFZxNe61KRfelFoLLmbVhAMtVbsS8kniQRn4+54O1YgJdY/9MRx
         CxVF+IPTeVCyJcrkztOCR5Kva5tVZjLNKu/lE73Xfr8CrZLNCpM/sqyJxTFsCK18IJQl
         /MJg==
X-Gm-Message-State: AOAM530zw9NvY3fireRpRttYUAh3sPL78DQrkLo3wSPr7kwPkDJpfZZv
        FpmgfRmu8PcStK8hmdjs7pGa9WlD8ltMuqg1vyYRgA==
X-Google-Smtp-Source: ABdhPJwHiV95n3FEBk1aXtSLPl643W9UqaemHjqNg+fL0Nm3QWdTE/3S1a84VE8r1kqtf8oRrHmhTb8d6cDa/mkpDzw=
X-Received: by 2002:a25:2d59:: with SMTP id s25mr43733317ybe.187.1615311177509;
 Tue, 09 Mar 2021 09:32:57 -0800 (PST)
MIME-Version: 1.0
References: <20210308192113.2721435-1-weiwan@google.com> <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
 <YEcukkO7bsKYVqEZ@shredder.lan>
In-Reply-To: <YEcukkO7bsKYVqEZ@shredder.lan>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 9 Mar 2021 09:32:47 -0800
Message-ID: <CAEA6p_C8TRWsMCvs2x7nW9TYUwEyBrL46Li3oB-HjNwUDjNcwQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix suspecious RCU usage warning
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 12:15 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Mar 08, 2021 at 07:47:31PM -0700, David Ahern wrote:
> > [ cc Ido and Petr ]
> >
> > On 3/8/21 12:21 PM, Wei Wang wrote:
> > > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > > index 7bc057aee40b..48956b144689 100644
> > > --- a/include/net/nexthop.h
> > > +++ b/include/net/nexthop.h
> > > @@ -410,31 +410,39 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
> > >  int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
> > >                    struct netlink_ext_ack *extack);
> > >
> > > -static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
> > > +static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh,
> > > +                                         bool bh_disabled)
> >
> > Hi Wei: I would prefer not to have a second argument to nexthop_fib6_nh
> > for 1 code path, and a control path at that.
> >
> > >  {
> > >     struct nh_info *nhi;
> > >
> > >     if (nh->is_group) {
> > >             struct nh_group *nh_grp;
> > >
> > > -           nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> > > +           if (bh_disabled)
> > > +                   nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
> > > +           else
> > > +                   nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> > >             nh = nexthop_mpath_select(nh_grp, 0);
> > >             if (!nh)
> > >                     return NULL;
> > >     }
> > >
> > > -   nhi = rcu_dereference_rtnl(nh->nh_info);
> > > +   if (bh_disabled)
> > > +           nhi = rcu_dereference_bh_rtnl(nh->nh_info);
> > > +   else
> > > +           nhi = rcu_dereference_rtnl(nh->nh_info);
> > >     if (nhi->family == AF_INET6)
> > >             return &nhi->fib6_nh;
> > >
> > >     return NULL;
> > >  }
> > >
> >
> > I am wary of duplicating code, but this helper is simple enough that it
> > should be ok with proper documentation.
> >
> > Ido/Petr: I think your resilient hashing patch set touches this helper.
> > How ugly does it get to have a second version?
>
> It actually doesn't touch this helper. Looks fine to me:


Thanks David and Ido.
To clarify, David, you suggest we add a separate function instead of
adding an extra parameter, right?

>
>
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index ba94868a21d5..6df9c12546fd 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -496,6 +496,26 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
>         return NULL;
>  }
>
> +static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
> +{
> +       struct nh_info *nhi;
> +
> +       if (nh->is_group) {
> +               struct nh_group *nh_grp;
> +
> +               nh_grp = rcu_dereference_bh(nh->nh_grp);
> +               nh = nexthop_mpath_select(nh_grp, 0);
> +               if (!nh)
> +                       return NULL;
> +       }
> +
> +       nhi = rcu_dereference_bh(nh->nh_info);
> +       if (nhi->family == AF_INET6)
> +               return &nhi->fib6_nh;
> +
> +       return NULL;
> +}
> +
>  static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
>  {
>         struct fib6_nh *fib6_nh;
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index ef9d022e693f..679699e953f1 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2486,7 +2486,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
>         const struct net_device *dev;
>
>         if (rt->nh)
> -               fib6_nh = nexthop_fib6_nh(rt->nh);
> +               fib6_nh = nexthop_fib6_nh_bh(rt->nh);
>
>         seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
