Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6862CCD9
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKPVj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPVj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:39:57 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F29926FB;
        Wed, 16 Nov 2022 13:39:56 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-141ca09c2fbso153fac.6;
        Wed, 16 Nov 2022 13:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdkJqVop4q3J0CGCyK+J6NJIGxrPvhJmwkz+Dg+EfiI=;
        b=CmdDPJAJIRMmEt1tcojYpWcro06DdegbdYOVn/7lcCT0qLEOhlEvg+7o+hn9a8ml3E
         UnpObArnqOC4yLSEhSF1m19GjgraHbzuzEHAbjWUnC/Kvqrb13K4QBdbs/mHEw0m59DU
         KBBTREmBC9cxrhw5UfRuBNHjqoqNwYUj0jQPZ2rWWdB1qHwcu5Nj45EFiUFRJC3s1iBL
         ZJUILNHuQ4Ibe4kxa/VRJGxWwPkBvCzkgTvHuC2Swh6d1UUkaQPVcub82ITY0sV5YLYF
         di8wsy3/nzs1P4mnSzhQ6W9SWR54sBGpXkVhPyqcveSbH0y2sKyxA4006BykJEuFDxtq
         496Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdkJqVop4q3J0CGCyK+J6NJIGxrPvhJmwkz+Dg+EfiI=;
        b=i+a5/k0VxOk70PZTYpDC4ASwi5FpvyYWainDYRMQSEkbB/T/82BkdaBkB3gvzZW8xx
         K4+v0P6RA07/LyNWujA7GCkKwiY7jqb/MQGwziaHtCHoZ/zJxk8sR9W9mfNVwQKfGCnD
         Jp4YGvvC5j8NWLnUB8vIouDdF7k7rABnTUnq6KK4h+UkMI+dd54dXPBq5Is/meYWt4o5
         9WtXkUfOhpBHcb8x5pWKe8fP6TC3p/paua1ikknBlXjklLxspz+5wt6lgTRYfiWKiqHx
         w+FSg5R8Y7cxEpBicxn5cSYoVQeTGlh+zl5muDb2cE6Um9hLMfJUjCC/IOUsU11W6v6z
         lFWQ==
X-Gm-Message-State: ANoB5pkNYzCyIP1SGNFcihzcYTMCmkG+07ghewGYbvjr8zBKBvnKXhVJ
        HCjxxvaiCafiYqVVe6jnhFK3PyfimDQqb9FpDFg=
X-Google-Smtp-Source: AA0mqf4zd0/xENSX0QBk22bSKVg5KhdCJKy8Aoy8Smk2BCl2rYAHKcpnp9jwxoqt8/EDGEzPWiPNSE31gpRg5AScFY4=
X-Received: by 2002:a05:6871:4219:b0:13b:9676:8aba with SMTP id
 li25-20020a056871421900b0013b96768abamr2776077oab.88.1668634794942; Wed, 16
 Nov 2022 13:39:54 -0800 (PST)
MIME-Version: 1.0
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
 <20221116123115.6b49e1b8@kernel.org>
In-Reply-To: <20221116123115.6b49e1b8@kernel.org>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Thu, 17 Nov 2022 08:39:43 +1100
Message-ID: <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 at 07:31, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Nov 2022 11:12:16 +0100 Geert Uytterhoeven wrote:
> > If CONFIG_IPV6=3Dn:
> >
> >     net/ipv4/tcp_input.c: In function =E2=80=98tcp_syn_flood_action=E2=
=80=99:
> >     include/net/sock.h:387:37: error: =E2=80=98const struct sock_common=
=E2=80=99 has no member named =E2=80=98skc_v6_rcv_saddr=E2=80=99; did you m=
ean =E2=80=98skc_rcv_saddr=E2=80=99?
> >       387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
> >         |                                     ^~~~~~~~~~~~~~~~
> >     include/linux/printk.h:429:19: note: in definition of macro =E2=80=
=98printk_index_wrap=E2=80=99
> >       429 |   _p_func(_fmt, ##__VA_ARGS__);    \
> >         |                   ^~~~~~~~~~~
> >     include/linux/printk.h:530:2: note: in expansion of macro =E2=80=98=
printk=E2=80=99
> >       530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> >         |  ^~~~~~
> >     include/linux/net.h:272:3: note: in expansion of macro =E2=80=98pr_=
info=E2=80=99
> >       272 |   function(__VA_ARGS__);    \
> >         |   ^~~~~~~~
> >     include/linux/net.h:288:2: note: in expansion of macro =E2=80=98net=
_ratelimited_function=E2=80=99
> >       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> >         |  ^~~~~~~~~~~~~~~~~~~~~~~~
> >     include/linux/net.h:288:43: note: in expansion of macro =E2=80=98sk=
_v6_rcv_saddr=E2=80=99
> >       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> >         |                                           ^~~~~~~~~~~
> >     net/ipv4/tcp_input.c:6847:4: note: in expansion of macro =E2=80=98n=
et_info_ratelimited=E2=80=99
> >      6847 |    net_info_ratelimited("%s: Possible SYN flooding on port =
[%pI6c]:%u. %s.\n",
> >         |    ^~~~~~~~~~~~~~~~~~~~
> >
> > Fix this by using "#if" instead of "if", like is done for all other
> > checks for CONFIG_IPV6.
> >
> > Fixes: d9282e48c6088105 ("tcp: Add listening address to SYN flood messa=
ge")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Sorry for the late reaction, this now conflicts with bf36267e3ad3df8
>
> I was gonna hand edit but perhaps we can do better with the ifdef
> formation.
>
> Instead of
>
> #ifdef v6
>         if (v6) {
>                 expensive_call6();
>         } else    //  d k
> #endif            //  o i
>         {         //  o e
>                 expensive_call4();
>         }

I actually started off using this way in my v1. I did that
intentionally because that pattern already exists in other places,
discussed at:

 https://lore.kernel.org/netdev/CAAvyFNg1F8ixrgy0YeL-TT5xLmk8N7dD=3DZMLQ6Vx=
sjHb_PU9bg@mail.gmail.com/

or just see:

 grep -C1 -ERHn "IS_ENABLED\(CONFIG_IPV6\)" net | grep -C1 "family =3D=3D A=
F_INET6"

Geert's patch adheres to existing style, which seems the better option?

> Can we go with:
>
> #ifdef v6
>         if (v6)
>                 expensive_call6();
>         else
> #endif
>                 expensive_call4();

This is a nested if, so it really should have braces to prevent
dangling else, both now and in the future.

> or
>
>         if (v4) {
>                 expensive_call4();
> #ifdef v6
>         } else {
>                 expensive_call6();
> #endif
>         }
> or
>
>         if (v6) {
> #ifdef v6
>                 expensive_call6();
> #endif
>         } else {
>                 expensive_call6();
>         }

These should work, but I expect they cause a comparison which can't be
optimised out at compile time. This is probably why the first style
exists.

In this SYN flood codepath optimisation doesn't matter because we're
doing ratelimited logging anyway. But if we're breaking with existing
style, then wouldn't the others also have to change to this style? I
haven't reviewed all the other usage to tell if they're in an oft-used
fastpath where such a thing might matter.

It seems Geert's patch style is the best way.

Jamie
