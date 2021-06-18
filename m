Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9053D3AC5C9
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhFRIPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:15:45 -0400
Received: from mail-ua1-f53.google.com ([209.85.222.53]:43525 "EHLO
        mail-ua1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhFRIPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:15:43 -0400
Received: by mail-ua1-f53.google.com with SMTP id f1so3091864uaj.10;
        Fri, 18 Jun 2021 01:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFG6ui45ec1aqERrwvUlS0SaM1oxVchZMu0Q8Ruu9ow=;
        b=WST+7EnIcLbJP51aLGyyaSYwOHB8sOnEeO9ZrlhIXF5J5U2U6RpgMXzZb8DyQHS9Ud
         hOrBzd+q7sumYwqnLB9y6paepfkeOHitK46tr6WaOaf6Au8tAQQ8DEklRO1MhUwMh8Xh
         watJp4O6CsuYSmweqvyFJI4ETWI+gxXGMd2uL5LTzL2TIsDRs9FDOH61slwWHBx7kzCe
         P1ct+woaSRl8R61TMatU0qFlWFeufx3/mf4QZR/yaRILBXPeiwwWFsxVjyxQEmvm8tAG
         Zg6Mr8SZ+doUO6FTUK30mwvn09FhIWgyDQ56uy6bCg3tlC/E4EbZ3PKP8NKFbid9lsmB
         4m3A==
X-Gm-Message-State: AOAM5335Xm1KkmVl2vquE/k83gcrNjwS2UvGgcPtzpUYnuz28Ajd+Ym7
        zy7WWtfgBdqNXpfUJUGGfII7IQa40pfMQEvrbn4=
X-Google-Smtp-Source: ABdhPJxlxJs4tGfM1myEe3dgzKSBPf8xtsDqhPT1cXgOHCA4vggy/XpbopAH19yktfLomMqcije6FqeDYK0ohAa3eg0=
X-Received: by 2002:ab0:484b:: with SMTP id c11mr10813000uad.100.1624004013827;
 Fri, 18 Jun 2021 01:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
 <1623907712-29366-3-git-send-email-schmitzmic@gmail.com> <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
 <1fa288e2-3157-68f8-32c1-ffa1c63e4f85@gmail.com> <CAMuHMdVGe1EutOVpw3-R=25xG0p2rWd65cB2mqM-imXWYjLtXw@mail.gmail.com>
 <da54e915-c142-a69b-757f-6a6419f173fa@gmail.com>
In-Reply-To: <da54e915-c142-a69b-757f-6a6419f173fa@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jun 2021 10:13:22 +0200
Message-ID: <CAMuHMdV5Yd2w+maSn-dQ=NOrVyVc8JjV38miKRc-pvnzBcKSig@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Finn Thain <fthain@linux-m68k.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, Jun 18, 2021 at 10:06 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Am 18.06.2021 um 19:16 schrieb Geert Uytterhoeven:
> >>>> +#ifdef CONFIG_APNE100MBIT
> >>>> +    if (apne_100_mbit)
> >>>> +            isa_type = ISA_TYPE_AG16;
> >>>> +#endif
> >>>> +
> >>> I think isa_type has to be assigned unconditionally otherwise it can't be
> >>> reset for 10 mbit cards. Therefore, the AMIGAHW_PRESENT(PCMCIA) logic in
> >>> arch/m68k/kernel/setup_mm.c probably should move here.
> >>
> >> Good catch! I am uncertain though as to whether replacing a 100 Mbit
> >> card by a 10 Mbit one at run time is a common use case (or even
> >> possible, given constraints of the Amiga PCMCIA interface?), but it
> >> ought to work even if rarely used.
> >
> > Given it's PCMCIA, I guess that's a possibility.
> > Furthermore, always setting isa_type means the user can recover from
> > a mistake by unloading the module, and modprobe'ing again with the
> > correct parameter.
> > For the builtin-case, that needs a s/0444/0644/ change, though.
>
> How does re-probing after a card change for a builtin driver work?
> Changing the permission bits is a minor issue.

Oh right, this driver predates the driver framework, and doesn't support
PCMCIA hotplug.  So auto-unregister on removal doesn't work.
Even using unbind/bind in sysfs won't work.

So rmmod/modprobe is the only thing that has a chance to work...

> >> The comment there says isa_type must be set as early as possible, so I'd
> >> rather leave that alone, and add an 'else' clause here.
> >>
> >> This of course raise the question whether we ought to move the entire
> >> isa_type handling into arch code instead - make it a generic
> >> amiga_pcmcia_16bit option settable via sysfs. There may be other 16 bit
> >> cards that require the same treatment, and duplicating PCMCIA mode
> >> switching all over the place could be avoided. Opinions?
> >
> > Indeed.
>
> The only downside I can see is that setting isa_type needs to be done
> ahead of modprobe, through sysfs. That might be a little error prone.
>
> > Still, can we autodetect in the driver?
>
> Guess we'll have to find out how the 16 bit cards behave if first poked
> in 8 bit mode, attempting to force a reset of the 8390 chip, and
> switching to 16 bit mode if this fails. That's normally done in
> apne_probe1() which runs after init_pcmcia(), so we can't rely on the
> result of a 8390 reset autoprobe to do the PCMCIA software reset there.
>
> The 8390 reset part does not rely on anything else in apne_probe1(), so
> that code can be lifted out of apne_probe1() and run early in
> apne_probe() (after the check for an inserted PCMCIA card). I'll try and
> prepare a patch for Alex to test that method.
>
> > I'm wondering how this is handled on PCs with PCMCIA, or if there
> > really is something special about Amiga PCMCIA hardware...
>
> What's special about Amiga PCMCIA hardware is that the card reset isn't
> connected for those 16 bit cards, so pcmcia_reset() does not work.

I was mostly thinking about the difference between 8-bit and 16-bit
accesses.

> Whether the software reset workaround hurts for 8 bit cards is something
> I don't know and cannot test. But
>
> > And I'd really like to get rid of the CONFIG_APNE100MBIT option,
> > i.e. always include the support, if possible.
>
> I can't see why that wouldn't be possible - the only downside is that we
> force MULTI_ISA=1 always for Amiga, and lose the optimizations done for
> MUTLI_ISA=0 in io_mm.h. Unless we autoprobe, we can use isa_type to
> guard against running a software reset on 8 bit cards ...

The latter sounds like a neat trick...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
