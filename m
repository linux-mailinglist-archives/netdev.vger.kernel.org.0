Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F923600D0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 06:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhDOEK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 00:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhDOEK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 00:10:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3B3C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 21:10:32 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p12so15995257pgj.10
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 21:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRykuM4ctxSO8K4c1oAY5JzT+QlM31Znd8X5ip1PmTQ=;
        b=Ti1aZ2VYS6o5RVfnaRNgGo1EoAnZYwnKBpcorbQugb/PWC/fJXkgk7tdnJ2ov6jvZa
         icx5G7W6TeaUX1qzrCA+Xan70TYqqHmhJCyQbwnaZTNrQ0mUn7XppcqNPamLqqkkYhq2
         BsBnoan4m1sBWsxn1i2HvAE5VhAxILVbT1D2MoSWIkUmWTAwECy4an0msKL1QHfCRA6t
         wl+JElQbl4Ln9zjWi38/NIFacmyCt8XSLW6OSHKWQUgQ1sMdpbjjATHedpmqSoGgp5ec
         mkEd2X8Xl9tzvMtLquA1Hz5Qn0jjI9P5i7T/A/P8l2OODMDLZgOYU2WOb4KUC0RZoxJj
         D0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRykuM4ctxSO8K4c1oAY5JzT+QlM31Znd8X5ip1PmTQ=;
        b=X+GjOJD1jN+7FR31SUlTyNis4VubTIRlD344zXc42Q+e3LcmX/G7ArTZTDkBxrU1H0
         TTFb9evWgtD0h9UX+GgiiycGiWzRPw0z24vpg9W2USIvbk1zQVTL50rxYIDlERK7Y4CW
         pNeQP3PEnjTqBxzZqy3pkaP85uVONIovJpPIR5PcBknIHtH4Q+s+33bVunIP5PQoeqx4
         euQZzdp3RfbE2KuZLzjsmTmZSZLoV+L76asE8LW7dq8bDm6LQBuundff/aPJsCBQ+PEi
         nNZo1Nl3b/fiYv/2U47ILo9gNJEX9I12utOFKWG2uJwfQ9hkjtWzMoPNYqTYANbJEYPq
         PQGg==
X-Gm-Message-State: AOAM530n+EgH2ZiJ8y78dMiP2HxijjMFacgMxDWZw7pi3eQD4pOWcddh
        iBv/1hSguGKFk0LcyBY09X6XcCBS2rVyTgDajGw=
X-Google-Smtp-Source: ABdhPJwfmN9gq2CrqJ735Ilrnx6b8LpPOvvkRl+MEpDF1PUdSGLrVdj3psVF+xm+KsD9PmkjCaLwMemL51xc9Jxvo04=
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id
 x20-20020a62fb140000b029022ee189c6b1mr1565313pfm.31.1618459832377; Wed, 14
 Apr 2021 21:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210414211411.16355-1-sishuai@purdue.edu>
In-Reply-To: <20210414211411.16355-1-sishuai@purdue.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Apr 2021 21:10:21 -0700
Message-ID: <CAM_iQpWVs5mKOCh+QxmQt8_iM700qeoa1cSGn+9FAfDyC+HX1A@mail.gmail.com>
Subject: Re: [PATCH] net: fix a concurrency bug in l2tp_tunnel_register()
To:     Sishuai Gong <sishuai@purdue.edu>
Cc:     jchapman@katalix.com, tparkin@katalix.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 2:14 PM Sishuai Gong <sishuai@purdue.edu> wrote:
>
> l2tp_tunnel_register() registers a tunnel without fully
> initializing its attribute. This can allow another kernel thread
> running l2tp_xmit_core() to access the uninitialized data and
> then cause a kernel NULL pointer dereference error, as shown below.
>
> Thread 1    Thread 2
> //l2tp_tunnel_register()
> list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>             //pppol2tp_connect()
>             tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
>             // Fetch the new tunnel
>             ...
>             //l2tp_xmit_core()
>             struct sock *sk = tunnel->sock;
>             ...
>             bh_lock_sock(sk);
>             //Bug happens
> tunnel->sock = sk;
>
> Fix this bug by initializing tunnel->sock before adding the
> tunnel into l2tp_tunnel_list.
>
> Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
> Reported-by: Sishuai Gong <sishuai@purdue.edu>
> ---
>  net/l2tp/l2tp_core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 203890e378cb..d61c9879076e 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1478,6 +1478,10 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>         tunnel->l2tp_net = net;
>         pn = l2tp_pernet(net);
>
> +       sk = sock->sk;
> +       sock_hold(sk);
> +       tunnel->sock = sk;
> +

I think you have to put this sock refcnt on the -EEXIST path
after moving it up.

Thanks.
