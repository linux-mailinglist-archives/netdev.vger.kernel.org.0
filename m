Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3B62D78A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiKQJzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbiKQJzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:55:35 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728B07722A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:54:34 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c15so1269233ybf.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HyoUw94ARsW64l9YyYF+xfNzz2Ak/16n1BQc51W4ue0=;
        b=GIdcIA8RPWJDIkSoYRjqlA1IMG7wgMkHD0+K6dXWd/Sb6I3EPIAfSI6Qf1g9jwqs5p
         kjN9r+m+YKa4jpm01QTGeEB2WxW/MqoDnyVDH4O8I40o29HFkAgrc+sHNCrp5VnAgzJt
         diE4fYnJduvzhBIziIl6c7WuE9VsqoG/Cj25mZ2VYsToyl39Zs3h+u1fGwksiJB29Fzs
         Gy3r5cugUQOvCa9YtvreWbcSUKP6Y/AcXHk3splpgQx+7DcG3G3u4YymEPeSz/0y52uN
         A5wCScqjtu6GD9j5k+0xAD9uZlof84UwUFg6moF7sN5WYwyJBkvUg09wIfN1Envu5YRI
         v3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HyoUw94ARsW64l9YyYF+xfNzz2Ak/16n1BQc51W4ue0=;
        b=KU85mOuyM1ATYi4kQbVG4FAFQHsQq+GX3tQrHpEPEIYePBdfqW6lUF5qYsGeOOkZed
         yWQBk3uEJW0TeHNswmJimspJTZDZXW74Im00TC//5wRw5x4oFytI1oUuWJNaIiHvt0s/
         WWpcStb/iIhoY67qx2zHPS8aJs+yhuJ0QP+zOx4hLx6Jyr9Hpfhd+sjUDLuiakUAdW21
         JqIgoES8kqVFaUSj/ySp9KWKcELIJCMfBuJPsUUQorlSjv7FWCayQFO7+eo0UDao93s8
         xGfvtutOD59ffBo08baHJeAWR7FuQkwpMNwO98XKkQRat6ybrws30DYAttIsBFb3WoAB
         XlOw==
X-Gm-Message-State: ANoB5pkogy07NrGaPxIVWqPihIzjZw5rOKYVwMxhxZj7IUsITQlJW2Gu
        pn2n91Aojfuh2L3+epfOExn9guKiTRyIMxkvYrKh9w==
X-Google-Smtp-Source: AA0mqf4B46y0yq1SpkC8rjBA3sp2jzaqUjAlq2hJTc75fNxEh2aDMkqXRiQQKo8gOyjZ9tryEq9HeLZHbJDJy8oG840=
X-Received: by 2002:a25:6641:0:b0:6ca:b03:7111 with SMTP id
 z1-20020a256641000000b006ca0b037111mr1327707ybm.598.1668678873428; Thu, 17
 Nov 2022 01:54:33 -0800 (PST)
MIME-Version: 1.0
References: <20221114191619.124659-1-jakub@cloudflare.com> <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com> <871qq13oex.fsf@cloudflare.com>
In-Reply-To: <871qq13oex.fsf@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 01:54:22 -0800
Message-ID: <CANn89iLD25rKsK9YoNexwh+fX4KOZcEjP_JC5w3DSn8y-UvFSg@mail.gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Nov 17, 2022 at 1:45 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Nov 17, 2022 at 01:07 AM -08, Eric Dumazet wrote:
> > On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >>
> >> Hello:
> >>
> >> This patch was applied to netdev/net.git (master)
> >> by David S. Miller <davem@davemloft.net>:
> >>
> >> On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
> >> > sk->sk_user_data has multiple users, which are not compatible with each
> >> > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> >> >
> >> > l2tp currently fails to grab the lock when modifying the underlying tunnel
> >> > socket fields. Fix it by adding appropriate locking.
> >> >
> >> > We err on the side of safety and grab the sk_callback_lock also inside the
> >> > sk_destruct callback overridden by l2tp, even though there should be no
> >> > refs allowing access to the sock at the time when sk_destruct gets called.
> >> >
> >> > [...]
> >>
> >> Here is the summary with links:
> >>   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
> >>     https://git.kernel.org/netdev/net/c/b68777d54fac
> >>
> >>
> >
> > I guess this patch has not been tested with LOCKDEP, right ?
> >
> > sk_callback_lock always needs _bh safety.
> >
> > I will send something like:
> >
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
> > 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> > *tunnel, struct net *net,
> >         }
> >
> >         sk = sock->sk;
> > -       write_lock(&sk->sk_callback_lock);
> > +       write_lock_bh(&sk->sk_callback_lock);
> >
> >         ret = l2tp_validate_socket(sk, net, tunnel->encap);
> >         if (ret < 0)
> > @@ -1522,7 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> > *tunnel, struct net *net,
> >         if (tunnel->fd >= 0)
> >                 sockfd_put(sock);
> >
> > -       write_unlock(&sk->sk_callback_lock);
> > +       write_unlock_bh(&sk->sk_callback_lock);
> >         return 0;
> >
> >  err_sock:
> > @@ -1531,7 +1531,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> > *tunnel, struct net *net,
> >         else
> >                 sockfd_put(sock);
> >
> > -       write_unlock(&sk->sk_callback_lock);
> > +       write_unlock_bh(&sk->sk_callback_lock);
> >  err:
> >         return ret;
> >  }
>
> Hmm, weird. I double checked - I have PROVE_LOCKING enabled.
> Didn't see any lockdep reports when running selftests/net/l2tp.sh.
>
> I my defense - I thought _bh was not needed because
> l2tp_tunnel_register() gets called only in the process context. I mean,
> it's triggered by Netlink sendmsg, but that gets processed in-line
> AFAIU:
>
> netlink_sendmsg
>   netlink_unicast
>     ->netlink_rcv
>       genl_rcv
>         genl_rcv_msg
>           genl_family_rcv_msg
>             genl_family_rcv_msg_doit
>               ->doit
>                 l2tp_nl_cmd_tunnel_create
>                   l2tp_tunnel_register

Three different syzbot reports will help to better understand the
issue, sorry it is 2am for me, I am not sure in which time zone you
are in ...
