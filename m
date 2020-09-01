Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0544E2589D9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 09:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgIAH4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 03:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIAH4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 03:56:41 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1398BC061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 00:56:41 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c6so375007ilo.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 00:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TEWosj+T/FRGHSF9tH65GTqlEJ9j3rwP8Dj/lqmsNo8=;
        b=ILDt4bQbXAm2fNXcqA27lrOZxCdF/zXdcbjLA74g0gZSpUOh8srrDHs5dzuCQ7hpe+
         a6tLJfBYvF97GfS6EwZzZMMSavbQ1TDHuI24//IQx5nRolW+H8zunuG3uAYt51D8KTkX
         2bWTazW6q3DUO9ehNgEb3gmWhuNS34HJDqph80nZL5JImd7vgyl4PKlYRkeQ3TRFdIs4
         D7sAAdTh2pIFg9shiHyc4n9cjyGqjPX7nTPNt1EpQCSyKi46f3dW+0tH7Dv2ksNKwpBS
         7fryGzuHI8VefQ7r+EwAW1hd/jEaXwbSJZ3j4vg6hHL5edpCf0nC5fw17aMwYJtv7NXT
         Mh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TEWosj+T/FRGHSF9tH65GTqlEJ9j3rwP8Dj/lqmsNo8=;
        b=M0X/9HdWxNfQ0ulh+bTNtsjvMgxRj3XCqerA4MOVo2E3TFQHVsdBz/SPIAKrSlFgQY
         jOC5mpazGvjjeAcRaYY3U+0gUP/xknm13gOPFYkHzg0/I6eU8c7nfWbXwq76/vIybEIa
         QokVm1decGF7wdgI0fFinUbyX1Hr5zbk08cxPlASeV8X3a5zPGNuzLEed8Q6qFJGjN9F
         YbzyWUJ0XzIxBUV6wGiOjluLJK43Q/X2Tf5HKb0yh4s9jQkaT+A5vTaqB5o9TXJ/ZK0+
         vyX1ujeRrlKMtWV3ga/Zs4JdgTD5RT44V1DsibpUutZqohs31EoHH0RRZVQb5vj6tMt3
         l/kA==
X-Gm-Message-State: AOAM531eauICXVJRUYIphQYjAEGKGyNzio8YjuPO/hHaX45dSFaZBgAi
        hAbcYvzp+KwOoLG9zFBKnyWpr+fB2hBWD0A+K0yCcA==
X-Google-Smtp-Source: ABdhPJyzfgc7rPdiRryei3TV9tpT3eT551dswjAZusUJFZsBCA8Lc7j+N5wK7ANhav4txz/BTlblPGK0DUE/GbM97Wo=
X-Received: by 2002:a92:4001:: with SMTP id n1mr310227ila.69.1598947000122;
 Tue, 01 Sep 2020 00:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200901065758.1141786-1-brianvv@google.com>
In-Reply-To: <20200901065758.1141786-1-brianvv@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Sep 2020 09:56:28 +0200
Message-ID: <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Brian Vazquez <brianvv@google.com>
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

On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
>
> The problem is exposed when the system has multiple ifaces and
> forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
> clean the default route on all the ifaces which is not desired.
>
> This patches fixes that by cleaning only the routes where the iface has
> forwarding enabled.
>
> Fixes: 830218c1add1 ("net: ipv6: Fix processing of RAs in presence of VRF")





> Cc: David Ahern <dsa@cumulusnetworks.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  net/ipv6/route.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 5e7e25e2523a..41181cd489ea 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4283,6 +4283,7 @@ static void __rt6_purge_dflt_routers(struct net *net,
>                                      struct fib6_table *table)
>  {
>         struct fib6_info *rt;
> +       bool deleted = false;
>
>  restart:
>         rcu_read_lock();
> @@ -4291,16 +4292,19 @@ static void __rt6_purge_dflt_routers(struct net *net,
>                 struct inet6_dev *idev = dev ? __in6_dev_get(dev) : NULL;
>
>                 if (rt->fib6_flags & (RTF_DEFAULT | RTF_ADDRCONF) &&
> -                   (!idev || idev->cnf.accept_ra != 2) &&
> +                   (!idev || (idev->cnf.forwarding == 1 &&
> +                              idev->cnf.accept_ra != 2)) &&
>                     fib6_info_hold_safe(rt)) {
>                         rcu_read_unlock();
>                         ip6_del_rt(net, rt, false);
> +                       deleted = true;
>                         goto restart;
>                 }
>         }
>         rcu_read_unlock();
>
> -       table->flags &= ~RT6_TABLE_HAS_DFLT_ROUTER;
> +       if (deleted)
> +               table->flags &= ~RT6_TABLE_HAS_DFLT_ROUTER;


This seems wrong : We want to keep the flag set if at least one
candidate route has not been deleted,
so that next time rt6_purge_dflt_routers() is called, we can call
__rt6_purge_dflt_routers() ?
