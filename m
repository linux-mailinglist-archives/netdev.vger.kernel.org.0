Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C93FCB0D
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhHaPxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:53:45 -0400
Received: from mail-ua1-f46.google.com ([209.85.222.46]:43855 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhHaPxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 11:53:44 -0400
Received: by mail-ua1-f46.google.com with SMTP id j31so9966918uad.10;
        Tue, 31 Aug 2021 08:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyyNaiX06etLnuNq/mXRKAgNChcX2AcfaUJe3PP+qpI=;
        b=tE1VarOetGLYK/R7lWP0VSnb/0FzjpchW/1UE6ofvPMOe+Nyu0OCiDB3Nn5wNYI3bS
         PATTAVgSqQ1VW4OuscDTz4FsTRQawynmCCUmpcbJOewgIqvnpMqL0qP/BLW3Yn1l3p3Y
         350mdxyJAG2vNkiz8AtvDNQsB6TZMl6XLS3MOH5ohHzPiHIO67GYDh7NjpFUVSWhgRTC
         1fndJAjXG/qWoEbzhwO/Z51gM39scQvFYvqlcvycIFGyYLRGCQ9HKW77bEmDVodH5S2W
         sB1aAElM2kOAcBVNdupL4vQ4rzX98/2wt5AzLA3J6cwe0YsO3clq8R+8YKALrfjQUBbP
         3T2A==
X-Gm-Message-State: AOAM532rZiKBtar1i/ocfYooG5CcAS2uktb1kB2PCV0VAfL25d+Ff7B3
        gOFMSCpKxSoLVeaUDXxrKdZysAN1+8IZSHsPSWv2jAsqYks=
X-Google-Smtp-Source: ABdhPJzfSvD38bKQSVGP7weuPwlhZvtod2MqSJ/211USKWBCvKxPb26J3DXN79FfDcKoNfjr9XCRn9L3ak/yyhKqfPc=
X-Received: by 2002:a9f:35aa:: with SMTP id t39mr19076089uad.89.1630425168579;
 Tue, 31 Aug 2021 08:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <72bc8926dcfc471ce385494f2c8c23398f8761d2.1630415944.git.geert+renesas@glider.be>
 <CACPK8XfyYpWTmaASuG7Jkyp06fRrg_zXvg93JB7igZgVDWjumw@mail.gmail.com>
In-Reply-To: <CACPK8XfyYpWTmaASuG7Jkyp06fRrg_zXvg93JB7igZgVDWjumw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 31 Aug 2021 17:52:37 +0200
Message-ID: <CAMuHMdUvXKaw0OytAhRWxYL2GKpU6pCOSKgUkj7O-NAGM4PuKg@mail.gmail.com>
Subject: Re: [PATCH] net: NET_VENDOR_LITEX should depend on LITEX
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Stafford Horne <shorne@gmail.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

On Tue, Aug 31, 2021 at 3:37 PM Joel Stanley <joel@jms.id.au> wrote:
> On Tue, 31 Aug 2021 at 13:21, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > LiteX Ethernet devices are only present on LiteX SoCs.  Hence add a
> > dependency on LITEX, to prevent asking the user about drivers for these
> > devices when configuring a kernel without LiteX SoC Builder support.
>
> nak.
>
> They can be present on any soc that uses them. We have an example in
> mainline already; microwatt uses liteeth but is not a litex soc.

But liiteeth.c uses <linux/litex.h>?
And https://github.com/enjoy-digital/litex can be used with a microwatt
CPU core?

The idea behind the LITEX config symbol was to gate off any driver
using LiteX interfaces.

> > Fixes: ee7da21ac4c3be1f ("net: Add driver for LiteX's LiteETH network interface")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

> > --- a/drivers/net/ethernet/litex/Kconfig
> > +++ b/drivers/net/ethernet/litex/Kconfig
> > @@ -5,6 +5,7 @@
> >  config NET_VENDOR_LITEX
> >         bool "LiteX devices"
> >         default y
> > +       depends on LITEX || COMPILE_TEST
> >         help
> >           If you have a network (Ethernet) card belonging to this class, say Y.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
