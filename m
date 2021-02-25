Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F243251B9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBYOso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBYOsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:48:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536B364EDC;
        Thu, 25 Feb 2021 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614264479;
        bh=/2vcARxK+F+PKwT0mAKkIgjxoroFvRxTYhSagJDwMD4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jGJNtsAabsUKxgu4HOfIB64tFy96XZWP4VmzlKG6r3k50qzcj2uUX6jG2YN++UQqb
         6TtqGGkzK4BKMfEYCHeZXkPfbVUgiyFtIPchBLWXNmZUdaeweX4zphO30E8DVnR7+Y
         DKq2KMlNRlOcdzFGD1lrn2TQp4/hIqkNjxIbmhNEpNqBHK8CXp8KpU9gH3hozQm4K+
         OZExJxXI7Q8Xatk+uUfxTzrqmNaNllBL1cLp/fJYZi/kma4FKWPxSDzDrTYoQnzSv8
         YzYoB1psmxfqslH6T5cR6xg1Ng0fRuBam6/PnaQxH/pKJc/iHHoQt7Il6Lh5ZBo9xG
         HL4MBh3VoSo0A==
Received: by mail-oi1-f181.google.com with SMTP id l64so6268439oig.9;
        Thu, 25 Feb 2021 06:47:59 -0800 (PST)
X-Gm-Message-State: AOAM533lqhEnjx8nhFZlLpRJq8mm2PFRmGcnuh2k3spOp1gdtU6UbXcu
        k22shFliZlG9sE9EtQOpxRDg3IQQl1Qc7C+/C6k=
X-Google-Smtp-Source: ABdhPJy8p6fbkfpm/hZb4keZJmYpXCtCtsowEZBAP4ucsdt62IJuNs1LF4TEYAJj8+Q+DCBtuuUn1q3F6m+N7BfkBlQ=
X-Received: by 2002:aca:4fd3:: with SMTP id d202mr2045568oib.11.1614264478399;
 Thu, 25 Feb 2021 06:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20210225143910.3964364-1-arnd@kernel.org> <20210225143910.3964364-2-arnd@kernel.org>
 <20210225144341.xgm65mqxuijoxplv@skbuf>
In-Reply-To: <20210225144341.xgm65mqxuijoxplv@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 15:47:41 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
Message-ID: <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 3:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When the ocelot driver code is in a library, the dsa tag
> > code cannot be built-in:
> >
> > ld.lld: error: undefined symbol: ocelot_can_inject
> > >>> referenced by tag_ocelot_8021q.c
> > >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> >
> > ld.lld: error: undefined symbol: ocelot_port_inject_frame
> > >>> referenced by tag_ocelot_8021q.c
> > >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> >
> > Building the tag support only really makes sense for compile-testing
> > when the driver is available, so add a Kconfig dependency that prevents
> > the broken configuration while allowing COMPILE_TEST alternative when
> > MSCC_OCELOT_SWITCH_LIB is disabled entirely.  This case is handled
> > through the #ifdef check in include/soc/mscc/ocelot.h.
> >
> > Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  net/dsa/Kconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> > index 3589224c8da9..58b8fc82cd3c 100644
> > --- a/net/dsa/Kconfig
> > +++ b/net/dsa/Kconfig
> > @@ -118,6 +118,8 @@ config NET_DSA_TAG_OCELOT
> >
> >  config NET_DSA_TAG_OCELOT_8021Q
> >       tristate "Tag driver for Ocelot family of switches, using VLAN"
> > +     depends on MSCC_OCELOT_SWITCH_LIB || \
> > +               (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
> >       select NET_DSA_TAG_8021Q
> >       help
> >         Say Y or M if you want to enable support for tagging frames with a
> > --
> > 2.29.2
> >
>
> Why isn't this code in include/soc/mscc/ocelot.h enough?
>
> #if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)
>
> bool ocelot_can_inject(struct ocelot *ocelot, int grp);
> void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
>                               u32 rew_op, struct sk_buff *skb);
> int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
> void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
>
> #else
>
> static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
> {
>         return false;
> }

That code is in include/soc/mscc/ocelot.h, it is what causes the
problem with CONFIG_MSCC_OCELOT_SWITCH_LIB=m
and NET_DSA_TAG_OCELOT_8021Q=y, as I tried to explain.

         Arnd
