Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E117455639
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244173AbhKRIEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:04:44 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:35735 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244119AbhKRIEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:04:42 -0500
Received: by mail-ua1-f52.google.com with SMTP id l24so11857166uak.2;
        Thu, 18 Nov 2021 00:01:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmFOilwnxUZVPTqShriY8qbMwRioLWhqep7gwdQi2bk=;
        b=DOmJ4iBziyrHEkBlcQlG23KrZRBZIin6rDTwSj6NV5m7WkwdODGf7NUhCLf2v+BdFO
         6v/8YCo9GGWUsqoOzknvr4dnC2Jc7fyKGqZ6wM0m0L5jY+6AC/kT29/XMVZqABhLKGKT
         +6hp4vUFljuo/mmobP7p/CjgzSVVtFSG05qOfty4u2ncnExC7Rz5xIoDsePKbNS2LLy+
         mpt7sohzA7MkiFjrrh1iGjXGbpTyovu1n/kQUc92Te1zQSq5/KGOVizY53wQn6mRoKVL
         SpQpvIi+ZgGRmIlNJ/MV6toQS6oHFgmikWFjYVc9gpXhg7OBSD8cspA+YgeEShB9h35m
         dpFg==
X-Gm-Message-State: AOAM531uWsiDUe4yXmBe8bccv5nigSyd/6gV4liEarN9URgHjtutP6CV
        ujCleTiP8dVPMkrCbczHR18TyZUb4T9kFA==
X-Google-Smtp-Source: ABdhPJzYQoaa+1X2Z1PKfrhj35niM0ffT986K/dynW+AnTgMhTfz90otrB7OZzXXBwtzPiI7xlR5Eg==
X-Received: by 2002:ab0:224c:: with SMTP id z12mr33499515uan.41.1637222501316;
        Thu, 18 Nov 2021 00:01:41 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id b8sm1241853vsl.19.2021.11.18.00.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 00:01:41 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id j14so2008672uan.10;
        Thu, 18 Nov 2021 00:01:40 -0800 (PST)
X-Received: by 2002:a9f:2431:: with SMTP id 46mr33574622uaq.114.1637222500752;
 Thu, 18 Nov 2021 00:01:40 -0800 (PST)
MIME-Version: 1.0
References: <20211114234005.335-1-schmitzmic@gmail.com> <20211114234005.335-4-schmitzmic@gmail.com>
 <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com> <ceacbd6b-8151-fc94-58c4-3a24d3308705@gmail.com>
In-Reply-To: <ceacbd6b-8151-fc94-58c4-3a24d3308705@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 18 Nov 2021 09:01:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV5EJB-5F057sAdhAK-jFgyXT9j0UA8trKf+Lsj89K0wQ@mail.gmail.com>
Message-ID: <CAMuHMdV5EJB-5F057sAdhAK-jFgyXT9j0UA8trKf+Lsj89K0wQ@mail.gmail.com>
Subject: Re: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Nov 18, 2021 at 5:58 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> On 18/11/21 03:42, Geert Uytterhoeven wrote:
> > On Mon, Nov 15, 2021 at 12:40 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> >> Add module parameter, IO mode autoprobe and PCMCIA reset code
> >> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
> >>
> >> 10 Mbit and 100 Mbit mode are supported by the same module.
> >> Use the core PCMCIA cftable parser to detect 16 bit cards,
> >> and automatically enable 16 bit ISA IO access for those cards
> >> by changing isa_type at runtime. The user must select PCCARD
> >> and PCMCIA in the kernel config to make the necessary support
> >> modules available
> >>
> >> Code to reset the PCMCIA hardware required for 16 bit cards is
> >> also added to the driver probe.
> >>
> >> An optional module parameter switches Amiga ISA IO accessors
> >> to 8 or 16 bit access in case autoprobe fails.
> >>
> >> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> >> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> >> Kazik <alex@kazik.de>.
> >>
> >> CC: netdev@vger.kernel.org
> >> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> >> Tested-by: Alex Kazik <alex@kazik.de>
> >> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

> >> --- a/drivers/net/ethernet/8390/apne.c
> >> +++ b/drivers/net/ethernet/8390/apne.c
> >> @@ -119,6 +119,48 @@ static u32 apne_msg_enable;
> >>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
> >>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
> >>
> >> +static int apne_100_mbit = -1;
> >> +module_param_named(100_mbit, apne_100_mbit, int, 0444);
> >> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
> >> +
> >> +#if IS_ENABLED(CONFIG_PCMCIA)
> >
> > What if CONFIG_PCMIA=m, and CONFIG_APNE=y?
>
> Fails to build (undefined reference to `pcmcia_parse_tuple').
>
> That's what 'select PCMCIA' was avoiding before, but got vetoed. I can
> add a dependency on PCMCIA in the APNE Kconfig entry which does force
> APNE the same as what's selected for PCMCIA, but that means we can't
> build APNE without PCMCIA anymore. Is there a way to express 'constrain
> build type if PCMCIA is enabled, else leave choice to user' ??

#if IS_REACHABLE(CONFIG_PCMIA)

> >> @@ -140,6 +182,13 @@ static struct net_device * __init apne_probe(void)
> >>
> >>         pr_info("Looking for PCMCIA ethernet card : ");
> >>
> >> +       if (apne_100_mbit == 1)
> >> +               isa_type = ISA_TYPE_AG16;
> >> +       else if (apne_100_mbit == 0)
> >> +               isa_type = ISA_TYPE_AG;
> >> +       else
> >> +               pr_cont(" (autoprobing 16 bit mode) ");
> >> +
> >>         /* check if a card is inserted */
> >>         if (!(PCMCIA_INSERTED)) {
> >>                 pr_cont("NO PCMCIA card inserted\n");
> >> @@ -167,6 +216,14 @@ static struct net_device * __init apne_probe(void)
> >>
> >>         pr_cont("ethernet PCMCIA card inserted\n");
> >>
> >> +#if IS_ENABLED(CONFIG_PCMCIA)
> >> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
> >> +               pr_info("16-bit PCMCIA card detected!\n");
> >> +               isa_type = ISA_TYPE_AG16;
> >> +               apne_100_mbit = 1;
> >> +       }
> >
> > I think you should reset apne_100_mbit to zero if apne_100_mbit < 0
> > && !pcmcia_is_16bit(), so rmmod + switching card + modprobe
> > has a chance to work.
>
> Good catch - though when switching to another card using this same
> driver, the module parameter can be used again to select IO mode or
> force autoprobe.

The autoprobe won't work if the new card is 8-bit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
