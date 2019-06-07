Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8943982E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfFGWFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:05:39 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51447 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfFGWFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:05:38 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so5007407itl.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJ7ThG+EXRqei+O2h1TvXGUERm/gbXkUO+6emmRo8eg=;
        b=PtXIGp5W9sXgpaiGBJBwJqhE4Fk1bqHfeN8VTSeIYmfktAmB9A8YU2dZY0RrLaPvp4
         OdPTKgVnbIuE5M2Gi2qTe3i/VBrON/zCEr+SdUmrGXs4UYF5w36D1ZVlw8awZ9luHzLb
         vvx3tyUSGmGxJSETNDrq7dipR0qkEpDItxYMYbSNySGQ8wWnxHFFwDIdDXRFyk2lj5ho
         trubTc+US4Qq+aHj/MtUXu9Y++fVyGK3BZPUlvurYfttmIWHOh85JynEI3laSEIFmuz/
         0LiUwnYJsGmcF2jUOAfInxsCjq/16fdk0I3R5WzG2rIb0lWX2w7kVILHRO9g+lj58x+8
         Ml6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJ7ThG+EXRqei+O2h1TvXGUERm/gbXkUO+6emmRo8eg=;
        b=WrremyjOKHNG51oPAP0ZelMLPQ6hTjRfKUts/2oc1lJLMJ25GCuK1WK5SpUdOU8SWF
         II5OdqfDZdBBCJs4GnumG8MCkrmR7q9JWpBm+M7fMfgfJSIljkopZCCmOdQFZaqv+Loh
         J6zkAXuAaVvmByNPTs8Yo7lzzmNWJ8HoSwZ+5eFOiuGo6QMS5UCw5beZE/lv5F0Bt9CW
         FKqhPOQGnUdRp6oTGRtwRQFD59s2AyGEQmcTB5mjisygQ3NHOcxiLoeXYoPQZb9iFbou
         lESex0JxB3Aej8abaLlXT5TlQ2zn3kzb8BBUna03e3zK+uDyuU0yrZHs+LfPdLDJvsb+
         5YvA==
X-Gm-Message-State: APjAAAVmGbJDFwB1JJH+gJWCDmcya8sm5Ev9PYLoWuADasSLZn3KS51p
        AVQ3mptvU+JlsBEx/C3gzP/6BcWpBBHYGdKvOzX2kw==
X-Google-Smtp-Source: APXvYqxRAmfj0eWnq3enSE4tsIND3LrJmrPlJp4SVmaEA9LP5opmy/+Eu1/GWA1Jx8ipFqmFodd5INpv1vGTRtekddw=
X-Received: by 2002:a02:394c:: with SMTP id w12mr5236608jae.126.1559945137579;
 Fri, 07 Jun 2019 15:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190607150941.11371-1-dsahern@kernel.org> <20190607150941.11371-8-dsahern@kernel.org>
In-Reply-To: <20190607150941.11371-8-dsahern@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 7 Jun 2019 15:05:26 -0700
Message-ID: <CAEA6p_BcqXPKtshmsrpZMCrwz1TNzz0Wtoccu61gHuUg74Tx+Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 07/20] ipv6: Handle all fib6_nh in a nexthop
 in exception handling
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, Martin KaFai Lau <kafai@fb.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 8:09 AM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add a hook in rt6_flush_exceptions, rt6_remove_exception_rt,
> rt6_update_exception_stamp_rt, and rt6_age_exceptions to handle
> nexthop struct in a fib6_info.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv6/route.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 106 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index bdbd3f1f417a..883997c591d7 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1746,9 +1746,22 @@ static void fib6_nh_flush_exceptions(struct fib6_nh *nh, struct fib6_info *from)
>         spin_unlock_bh(&rt6_exception_lock);
>  }
>
> +static int rt6_nh_flush_exceptions(struct fib6_nh *nh, void *arg)
> +{
> +       struct fib6_info *f6i = arg;
> +
> +       fib6_nh_flush_exceptions(nh, f6i);
> +
> +       return 0;
> +}
> +
>  void rt6_flush_exceptions(struct fib6_info *f6i)
>  {
> -       fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
> +       if (f6i->nh)
> +               nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_flush_exceptions,
> +                                        f6i);
> +       else
> +               fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
>  }
>
>  /* Find cached rt in the hash table inside passed in rt
> @@ -1835,6 +1848,24 @@ static int fib6_nh_remove_exception(const struct fib6_nh *nh, int plen,
>         return err;
>  }
>
> +struct fib6_nh_excptn_arg {
> +       struct rt6_info *rt;
> +       int             plen;
> +       bool            found;
> +};
> +
> +static int rt6_nh_remove_exception_rt(struct fib6_nh *nh, void *_arg)
> +{
> +       struct fib6_nh_excptn_arg *arg = _arg;
> +       int err;
> +
> +       err = fib6_nh_remove_exception(nh, arg->plen, arg->rt);
> +       if (err == 0)
> +               arg->found = true;
> +
> +       return 0;
> +}
> +
Hi David,
Why not return 1 here to break the loop when
fib6_nh_remove_exception() successfully removed the rt?

>  static int rt6_remove_exception_rt(struct rt6_info *rt)
>  {
>         struct fib6_info *from;
> @@ -1843,6 +1874,17 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
>         if (!from || !(rt->rt6i_flags & RTF_CACHE))
>                 return -EINVAL;
>
> +       if (from->nh) {
> +               struct fib6_nh_excptn_arg arg = {
> +                       .rt = rt,
> +                       .plen = from->fib6_src.plen
> +               };
> +
> +               nexthop_for_each_fib6_nh(from->nh, rt6_nh_remove_exception_rt,
> +                                        &arg);
> +               return arg.found ? 0 : -ENOENT;
> +       }
> +
>         return fib6_nh_remove_exception(from->fib6_nh,
>                                         from->fib6_src.plen, rt);
>  }
> @@ -1873,9 +1915,33 @@ static void fib6_nh_update_exception(const struct fib6_nh *nh, int plen,
>                 rt6_ex->stamp = jiffies;
>  }
>
> +struct fib6_nh_match_arg {
> +       const struct net_device *dev;
> +       const struct in6_addr   *gw;
> +       struct fib6_nh          *match;
> +};
> +
> +/* determine if fib6_nh has given device and gateway */
> +static int fib6_nh_find_match(struct fib6_nh *nh, void *_arg)
> +{
> +       struct fib6_nh_match_arg *arg = _arg;
> +
> +       if (arg->dev != nh->fib_nh_dev ||
> +           (arg->gw && !nh->fib_nh_gw_family) ||
> +           (!arg->gw && nh->fib_nh_gw_family) ||
> +           (arg->gw && !ipv6_addr_equal(arg->gw, &nh->fib_nh_gw6)))
> +               return 0;
> +
> +       arg->match = nh;
> +
> +       /* found a match, break the loop */
> +       return 1;
> +}
> +
>  static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
>  {
>         struct fib6_info *from;
> +       struct fib6_nh *fib6_nh;
>
>         rcu_read_lock();
>
> @@ -1883,7 +1949,21 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
>         if (!from || !(rt->rt6i_flags & RTF_CACHE))
>                 goto unlock;
>
> -       fib6_nh_update_exception(from->fib6_nh, from->fib6_src.plen, rt);
> +       if (from->nh) {
> +               struct fib6_nh_match_arg arg = {
> +                       .dev = rt->dst.dev,
> +                       .gw = &rt->rt6i_gateway,
> +               };
> +
> +               nexthop_for_each_fib6_nh(from->nh, fib6_nh_find_match, &arg);
> +
> +               if (!arg.match)
> +                       return;
> +               fib6_nh = arg.match;
> +       } else {
> +               fib6_nh = from->fib6_nh;
> +       }
> +       fib6_nh_update_exception(fib6_nh, from->fib6_src.plen, rt);
>  unlock:
>         rcu_read_unlock();
>  }
> @@ -2045,11 +2125,34 @@ static void fib6_nh_age_exceptions(const struct fib6_nh *nh,
>         rcu_read_unlock_bh();
>  }
>
> +struct fib6_nh_age_excptn_arg {
> +       struct fib6_gc_args     *gc_args;
> +       unsigned long           now;
> +};
> +
> +static int rt6_nh_age_exceptions(struct fib6_nh *nh, void *_arg)
> +{
> +       struct fib6_nh_age_excptn_arg *arg = _arg;
> +
> +       fib6_nh_age_exceptions(nh, arg->gc_args, arg->now);
> +       return 0;
> +}
> +
>  void rt6_age_exceptions(struct fib6_info *f6i,
>                         struct fib6_gc_args *gc_args,
>                         unsigned long now)
>  {
> -       fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
> +       if (f6i->nh) {
> +               struct fib6_nh_age_excptn_arg arg = {
> +                       .gc_args = gc_args,
> +                       .now = now
> +               };
> +
> +               nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_age_exceptions,
> +                                        &arg);
> +       } else {
> +               fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
> +       }
>  }
>
>  /* must be called with rcu lock held */
> --
> 2.11.0
>
