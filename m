Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B18B3AC4C0
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhFRHSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:18:43 -0400
Received: from mail-ua1-f50.google.com ([209.85.222.50]:43715 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhFRHSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:18:42 -0400
Received: by mail-ua1-f50.google.com with SMTP id f1so3042012uaj.10;
        Fri, 18 Jun 2021 00:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1qjp3LSqiWe30R+Xguwq2AymeWV15Ne0QLP1Md9aAA=;
        b=eydW0LtYkqWWYeVc3e4QIxbtIud7g6MjyixJUeZ0eYBWNs+Suh9mgK4D/ieBPZz1qy
         KAFbTUDWTLrl/YGOTbaqxEgpUnVLnAzYlBxSI3PvXQ+isug1Zdf6UZ9TzJec9O8+A9sk
         7exOKNeWnxYO37LIiU/X4zXu4Cq7vvU3yXsh8qz+mBAbtwTqx9QvWWunC0msoMZx1l5C
         1q9gHfqrr6UnmoxIe9R1pGCwfWc9+TyObXpnXCR8z3ara2R92YOvj94cTi/4hluPI2Ka
         XScWFrx6OmTPVtgFrf4+VcVwxEoqgqPLIStA/qgF2/e+3k+RLHQTk0AvExAdc3eMhEAV
         1n1Q==
X-Gm-Message-State: AOAM531wkjhX+87ULbUBOWMtpl0w/r/6BAfYYZSAALzpbXOkUqXRrrq8
        Osv78kvnoZuaeueH0pRjMwrSDvMzJVU/DUJJ/No=
X-Google-Smtp-Source: ABdhPJxG7V8iKYTWute1ru1376/EX/H8waoz1J/qmrsYwZZxFCqjGi6H8s6qBjbQtv6x2Wk1/JRq2irv2Zl0u43wIIA=
X-Received: by 2002:ab0:647:: with SMTP id f65mr10459435uaf.4.1624000593113;
 Fri, 18 Jun 2021 00:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
 <1623907712-29366-3-git-send-email-schmitzmic@gmail.com> <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
 <1fa288e2-3157-68f8-32c1-ffa1c63e4f85@gmail.com>
In-Reply-To: <1fa288e2-3157-68f8-32c1-ffa1c63e4f85@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jun 2021 09:16:21 +0200
Message-ID: <CAMuHMdVGe1EutOVpw3-R=25xG0p2rWd65cB2mqM-imXWYjLtXw@mail.gmail.com>
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

On Thu, Jun 17, 2021 at 9:33 PM Michael Schmitz <schmitzmic@gmail.com> wrote:
> On 17/06/21 6:51 pm, Finn Thain wrote:
> > On Thu, 17 Jun 2021, Michael Schmitz wrote:
> >> Add Kconfig option, module parameter and PCMCIA reset code
> >> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
> >>
> >> 10 Mbit and 100 Mbit mode are supported by the same module.
> >> A module parameter switches Amiga ISA IO accessors to word
> >> access by changing isa_type at runtime. Additional code to
> >> reset the PCMCIA hardware is also added to the driver probe.
> >>
> >> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> >> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> >> Kazik <alex@kazik.de>.
> >>
> >> CC: netdev@vger.kernel.org
> >> Tested-by: Alex Kazik <alex@kazik.de>
> >> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> >> --- a/drivers/net/ethernet/8390/apne.c
> >> +++ b/drivers/net/ethernet/8390/apne.c
> >> @@ -120,6 +120,12 @@ static u32 apne_msg_enable;
> >>   module_param_named(msg_enable, apne_msg_enable, uint, 0444);
> >>   MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
> >>
> >> +#ifdef CONFIG_APNE100MBIT
> >> +static bool apne_100_mbit;
> >> +module_param_named(apne_100_mbit_msg, apne_100_mbit, bool, 0444);
> >> +MODULE_PARM_DESC(apne_100_mbit_msg, "Enable 100 Mbit support");
> >> +#endif
> >> +
> >>   struct net_device * __init apne_probe(int unit)
> >>   {
> >>      struct net_device *dev;
> >> @@ -139,6 +145,11 @@ struct net_device * __init apne_probe(int unit)
> >>      if ( !(AMIGAHW_PRESENT(PCMCIA)) )
> >>              return ERR_PTR(-ENODEV);
> >>
> >> +#ifdef CONFIG_APNE100MBIT
> >> +    if (apne_100_mbit)
> >> +            isa_type = ISA_TYPE_AG16;
> >> +#endif
> >> +
> > I think isa_type has to be assigned unconditionally otherwise it can't be
> > reset for 10 mbit cards. Therefore, the AMIGAHW_PRESENT(PCMCIA) logic in
> > arch/m68k/kernel/setup_mm.c probably should move here.
>
> Good catch! I am uncertain though as to whether replacing a 100 Mbit
> card by a 10 Mbit one at run time is a common use case (or even
> possible, given constraints of the Amiga PCMCIA interface?), but it
> ought to work even if rarely used.

Given it's PCMCIA, I guess that's a possibility.
Furthermore, always setting isa_type means the user can recover from
a mistake by unloading the module, and modprobe'ing again with the
correct parameter.
For the builtin-case, that needs a s/0444/0644/ change, though.

> The comment there says isa_type must be set as early as possible, so I'd
> rather leave that alone, and add an 'else' clause here.
>
> This of course raise the question whether we ought to move the entire
> isa_type handling into arch code instead - make it a generic
> amiga_pcmcia_16bit option settable via sysfs. There may be other 16 bit
> cards that require the same treatment, and duplicating PCMCIA mode
> switching all over the place could be avoided. Opinions?

Indeed.

Still, can we autodetect in the driver?

I'm wondering how this is handled on PCs with PCMCIA, or if there
really is something special about Amiga PCMCIA hardware...

And I'd really like to get rid of the CONFIG_APNE100MBIT option,
i.e. always include the support, if possible.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
