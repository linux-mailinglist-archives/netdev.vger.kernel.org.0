Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD962EF6D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiKRIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241520AbiKRI35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:29:57 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502AB45EED;
        Fri, 18 Nov 2022 00:29:27 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id l15so2718399qtv.4;
        Fri, 18 Nov 2022 00:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oW1s8w8JVv/wucuGCYQ/JynUk15BPhcJ2fHJb+VHmyA=;
        b=zXEj0l/2GiditxAoWDgaZJVsDvbhX90bMMH8+iEqSeUBtL0qzHLLzDVVFndcu/rbib
         w3NVomJF81XdgKi68RqRFf85CDZN2jaJDOX/kFn+fYCGU/ONqIXS534d/8XTCjI1nAFO
         yMaTAvz+FtxOsb50bYkyStypVtEkl6F3ZUdIR88bmvtno4OGGNS9Te/AYSs6uJtkTkUY
         alMVDeYWvGVfudDott7mXltmGpVoELpo18LUTrX+epspTAIdoLrC6pZ244cDDEzMXvRT
         ydQHoOsrzemgBKm0P2lmN/jsbA84+xfmeRLFd36+7lGKvZdT7CpppNUL0uVsJqMrzM6a
         MCVw==
X-Gm-Message-State: ANoB5pnBBimaMAf0sP31w3kkFFCXI29aQp5dpxvp2IOsPz3ixgNInGun
        Zs7W6zLewLuzc0rIXXL1FzFkM1Bg2fcUVQ==
X-Google-Smtp-Source: AA0mqf5pFJSnCQNCzgktDIe9BOZ+YJg6Bjp/RENK9j8HJLEgxDkMYtneY5zTAQJQ21KCMQiSf36DUg==
X-Received: by 2002:a05:622a:429a:b0:3a1:e533:23a7 with SMTP id cr26-20020a05622a429a00b003a1e53323a7mr5533205qtb.197.1668760166111;
        Fri, 18 Nov 2022 00:29:26 -0800 (PST)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id dt54-20020a05620a47b600b006fbc0da4b0csm2040195qkb.48.2022.11.18.00.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 00:29:25 -0800 (PST)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3938dc90ab0so23796727b3.4;
        Fri, 18 Nov 2022 00:29:25 -0800 (PST)
X-Received: by 2002:a05:690c:b81:b0:37e:6806:a5f9 with SMTP id
 ck1-20020a05690c0b8100b0037e6806a5f9mr5549359ywb.47.1668760164716; Fri, 18
 Nov 2022 00:29:24 -0800 (PST)
MIME-Version: 1.0
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
 <20221116123115.6b49e1b8@kernel.org> <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
 <20221116141519.0ef42fa2@kernel.org> <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
In-Reply-To: <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Nov 2022 09:29:13 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
Message-ID: <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamie,

On Fri, Nov 18, 2022 at 2:50 AM Jamie Bainbridge
<jamie.bainbridge@gmail.com> wrote:
> On Thu, 17 Nov 2022 at 08:15, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 17 Nov 2022 08:39:43 +1100 Jamie Bainbridge wrote:
> > > >         if (v6) {
> > > > #ifdef v6
> > > >                 expensive_call6();
> > > > #endif
> > > >         } else {
> > > >                 expensive_call6();
> > > >         }
> > >
> > > These should work, but I expect they cause a comparison which can't be
> > > optimised out at compile time. This is probably why the first style
> > > exists.
> > >
> > > In this SYN flood codepath optimisation doesn't matter because we're
> > > doing ratelimited logging anyway. But if we're breaking with existing
> > > style, then wouldn't the others also have to change to this style? I
> > > haven't reviewed all the other usage to tell if they're in an oft-used
> > > fastpath where such a thing might matter.
> >
> > I think the word style already implies subjectivity.
>
> You are right. Looking further, there are many other ways
> IF_ENABLED(CONFIG_IPV6) is used, including similar to the ways you
> have suggested.
>
> I don't mind Geert's original patch, but if you want a different
> style, I like your suggestion with v4 first:
>
>         if (v4) {
>                 expensive_call4();
> #ifdef v6
>         } else {
>                 expensive_call6();
> #endif
>         }

IMHO this is worse, as the #ifdef/#endif is spread across the two branches
of an if-conditional.

Hence this is usually written as:

            if (cond1) {
                    expensive_call1();
            }
    #ifdef cond2_enabled
           else {
                    expensive_call1();
            }
    #endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
