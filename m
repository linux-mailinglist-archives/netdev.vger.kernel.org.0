Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A13FFB8
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfD3S0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:26:45 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:34929 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfD3S0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:26:44 -0400
Received: by mail-it1-f193.google.com with SMTP id l140so5091510itb.0
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 11:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HakQ9LkfUgS2eaG91+T+1KuJ/RPgs+dOQkwrk87yjQo=;
        b=EBPd3BwhXQu1tI1yN/R66dU6G7rOF+BNBt0UEiB29kkcTj4iclF0pRewHCQIxMsdJC
         5F34rIdkTlWka0ofXVdZKPfSkf958l+bq/nn/mbOv40Qj1d6+zipFsV+qGlaswpKYWte
         xC/mpaHQCuJDrIxBWsFeqUqUMBJhcY9I0YqFKyqpiw9h9omM6ebhedg61EYlyBSOc64J
         uF767Op3Li/zC/7Tn3Pjrc9f6q0df6+BaHxA7OzKJ3A6Geq3e7SLCIqC5bsQayl9T6Ui
         IPeSXvGZsprbrgT5dt/whmg8L0XPiloHbAq56gexkA5m8EilaD881EcWniwDx1H8G+KT
         M15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HakQ9LkfUgS2eaG91+T+1KuJ/RPgs+dOQkwrk87yjQo=;
        b=NiQHZ+4IVwVDpKtoU1jd+CoP2T9iVrQR7f8iS8rA4IExBAizrUkIFE1vaCtw4hG+36
         4xlaWiOFJVsAuHHVCQuRE9f38n3w9OntoJTN6DjnI2T0SKTIAYtesiCyW8jfV8QIERw6
         8IsYFagT20mko4KKzUzlRSJBzOEXpRi3SxmvNLZRAhf2UTwri07eGAu0zCToXEJpUObB
         H8dv0qYKh9Q/DxapQ67H5XYJyhXeTDxXX+1HjKVV/f8mu5jjDXLhI82VVTzFBqtMm0Dp
         DjhPGWJAa55lzA5cbY9QCt7BOFUcqlqmW6u9O2/f/6z2jI6KTKH6Exrcbhbx+zbxgIlI
         2qiA==
X-Gm-Message-State: APjAAAWBMbAfX71qkY4Y2ZPnFXROutBXifYW9JWq/6r3JwZRBiicph6d
        0jCkXQJ5ocyNPC3BeVWK8L7YDrvESsw2OVi5rav7nQ==
X-Google-Smtp-Source: APXvYqxMPgJF7ukQb4fk4dGcE3D0OGDFCUJf0fYpCKUHxC0lmzmIuDKus3dQN2owkJSmePNYqP+caZwEkZCEAyrrtks=
X-Received: by 2002:a05:660c:95:: with SMTP id t21mr5011230itj.6.1556648803140;
 Tue, 30 Apr 2019 11:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190430174512.3898413-1-kafai@fb.com>
In-Reply-To: <20190430174512.3898413-1-kafai@fb.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 30 Apr 2019 11:26:32 -0700
Message-ID: <CAEA6p_AjpgPMoZ0-6BM=Ymx3D2maN5LGZ-UoeJs7bh6rBnvecQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: A few fixes on dereferencing rt->from
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <bsd@fb.com>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:45 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> It is a followup after the fix in
> commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")
>
> rt6_do_redirect():
> 1. NULL checking is needed on rt->from because a parallel
>    fib6_info delete could happen that sets rt->from to NULL.
>    (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).
>
> 2. fib6_info_hold() is not enough.  Same reason as (1).
>    Meaning, holding dst->__refcnt cannot ensure
>    rt->from is not NULL or rt->from->fib6_ref is not 0.
>
>    Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
>    is already doing, this patch chooses to extend the rcu section
>    to keep "from" dereference-able after checking for NULL.
>
> inet6_rtm_getroute():
> 1. NULL checking is also needed on rt->from for a similar reason.
>    Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.
>
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
Acked-by: Wei Wang <weiwan@google.com>

Nice fix. Thanks Martin.

>  net/ipv6/route.c | 38 ++++++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index b4899f0de0d0..73ef72c208af 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3397,11 +3397,8 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
>
>         rcu_read_lock();
>         from = rcu_dereference(rt->from);
> -       /* This fib6_info_hold() is safe here because we hold reference to rt
> -        * and rt already holds reference to fib6_info.
> -        */
> -       fib6_info_hold(from);
> -       rcu_read_unlock();
> +       if (!from)
> +               goto out;
>
>         nrt = ip6_rt_cache_alloc(from, &msg->dest, NULL);
>         if (!nrt)
> @@ -3413,10 +3410,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
>
>         nrt->rt6i_gateway = *(struct in6_addr *)neigh->primary_key;
>
> -       /* No need to remove rt from the exception table if rt is
> -        * a cached route because rt6_insert_exception() will
> -        * takes care of it
> -        */
> +       /* rt6_insert_exception() will take care of duplicated exceptions */
>         if (rt6_insert_exception(nrt, from)) {
>                 dst_release_immediate(&nrt->dst);
>                 goto out;
> @@ -3429,7 +3423,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
>         call_netevent_notifiers(NETEVENT_REDIRECT, &netevent);
>
>  out:
> -       fib6_info_release(from);
> +       rcu_read_unlock();
>         neigh_release(neigh);
>  }
>
> @@ -5028,16 +5022,20 @@ static int inet6_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
>
>         rcu_read_lock();
>         from = rcu_dereference(rt->from);
> -
> -       if (fibmatch)
> -               err = rt6_fill_node(net, skb, from, NULL, NULL, NULL, iif,
> -                                   RTM_NEWROUTE, NETLINK_CB(in_skb).portid,
> -                                   nlh->nlmsg_seq, 0);
> -       else
> -               err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
> -                                   &fl6.saddr, iif, RTM_NEWROUTE,
> -                                   NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
> -                                   0);
> +       if (from) {
> +               if (fibmatch)
> +                       err = rt6_fill_node(net, skb, from, NULL, NULL, NULL,
> +                                           iif, RTM_NEWROUTE,
> +                                           NETLINK_CB(in_skb).portid,
> +                                           nlh->nlmsg_seq, 0);
> +               else
> +                       err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
> +                                           &fl6.saddr, iif, RTM_NEWROUTE,
> +                                           NETLINK_CB(in_skb).portid,
> +                                           nlh->nlmsg_seq, 0);
> +       } else {
> +               err = -ENETUNREACH;
> +       }
>         rcu_read_unlock();
>
>         if (err < 0) {
> --
> 2.17.1
>
