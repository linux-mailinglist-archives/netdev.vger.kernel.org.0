Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75669447C00
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhKHIlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:41:19 -0500
Received: from mail-ua1-f53.google.com ([209.85.222.53]:36520 "EHLO
        mail-ua1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbhKHIlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:41:16 -0500
Received: by mail-ua1-f53.google.com with SMTP id e10so29962711uab.3;
        Mon, 08 Nov 2021 00:38:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YVKWMJNK4m12lLt0Wrn48k6keA+9Ub6Foox4AHZICvc=;
        b=4pePbNBnF70HQMZOUtFMmUjkyZ4TVDuLqHoWhiPFrmlp6h3CYjMEZgONSBtXNlUW/t
         Bi7wFxEKtX4OZJvjyV/iSoeJJQB42LfBMAnG3bApImG0UZz2scvydX+TCQ/Axh0IGsib
         gNcWtntJaZsAWcdukFMLw9/Jrxp7oNFSgkciIQXYtYx8u6fFXMul7lTV5bZcjjStELMI
         x9t1eu3a6hix31GNozlcgs4RPGk0rF9kDWi0MsIVQm0NbYbAKGczx7AnH2ccQV++yxs7
         DP4xWne3PhU0utl9FDd5l27WDu+jitIvwaJAzLt4/2148o+vCf6w1POZG+EZ6t1KYvE9
         e4Rw==
X-Gm-Message-State: AOAM5318bpP7X5RpsSq7sPmT3b+Gjp9sGFE1IJ74f/fflDll1jzPhWK0
        jXEh7WeJtQC9FEVvtjH+MDFNPVHNuCfwzg==
X-Google-Smtp-Source: ABdhPJw4g0wLfAkoknojliQnEXnkYUSGczHurwxG8+2vVR4C5s7KgiS3iBdrjibCzSja6zDhqY86MA==
X-Received: by 2002:a05:6102:e14:: with SMTP id o20mr46993124vst.26.1636360710778;
        Mon, 08 Nov 2021 00:38:30 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id 66sm3094203vsh.34.2021.11.08.00.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 00:38:30 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id q13so29973308uaq.2;
        Mon, 08 Nov 2021 00:38:30 -0800 (PST)
X-Received: by 2002:a05:6102:1354:: with SMTP id j20mr25744747vsl.41.1636360709999;
 Mon, 08 Nov 2021 00:38:29 -0800 (PST)
MIME-Version: 1.0
References: <20211104061102.30899-1-schmitzmic@gmail.com> <20211104061102.30899-4-schmitzmic@gmail.com>
In-Reply-To: <20211104061102.30899-4-schmitzmic@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Nov 2021 09:38:18 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVMG8x-s-1_a2vGw3cqP=1OfDjePL+knsLR-=zjEDzN1g@mail.gmail.com>
Message-ID: <CAMuHMdVMG8x-s-1_a2vGw3cqP=1OfDjePL+knsLR-=zjEDzN1g@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Nov 4, 2021 at 7:11 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Add module parameter, IO mode autoprobe and PCMCIA reset code
> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>
> Select core PCMCIA support modules for use by APNE driver.
>
> 10 Mbit and 100 Mbit mode are supported by the same module.
> Use the core PCMCIA cftable parser to detect 16 bit cards,
> and automatically enable 16 bit ISA IO access for those cards
> by changing isa_type at runtime. Code to reset the PCMCIA
> hardware required for 16 bit cards is also added to the driver
> probe.
>
> An optional module parameter switches Amiga ISA IO accessors
> to 8 or 16 bit access in case autoprobe fails.
>
> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> Kazik <alex@kazik.de>.
>
> CC: netdev@vger.kernel.org
> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> Tested-by: Alex Kazik <alex@kazik.de>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

> Changes from v7:
>
> - move 'select' for PCCARD and PCMCIA to 8390 Kconfig, so
>   Amiga pcmcia.c may remain built-in while core PCMCIA
>   code can be built as modules if APNE driver is a module.
> - move 16 bit mode autoprobe code from amiga/pcmcia.c to this
>   driver, to allow the core PCMCIA code we depend on to be
>   built as modules.
> - change module parameter type from bool to int to allow for
>   tri-state semantics (autoprobe, 8 bit, 16 bit).

Thanks for the update!

> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c

> @@ -119,6 +121,10 @@ static u32 apne_msg_enable;
>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>
> +static u32 apne_100_mbit = -1;

The changelog said you changed this to int, not u32...

> +module_param_named(100_mbit, apne_100_mbit, uint, 0444);
> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
> +
>  static struct net_device * __init apne_probe(void)
>  {
>         struct net_device *dev;
> @@ -140,6 +146,13 @@ static struct net_device * __init apne_probe(void)
>
>         pr_info("Looking for PCMCIA ethernet card : ");
>
> +       if (apne_100_mbit == 1)
> +               isa_type = ISA_TYPE_AG16;
> +       else if (apne_100_mbit == 0)
> +               isa_type = ISA_TYPE_AG;
> +       else
> +               pr_cont(" (autoprobing 16 bit mode) ");
> +
>         /* check if a card is inserted */
>         if (!(PCMCIA_INSERTED)) {
>                 pr_cont("NO PCMCIA card inserted\n");
> @@ -167,6 +180,14 @@ static struct net_device * __init apne_probe(void)
>
>         pr_cont("ethernet PCMCIA card inserted\n");
>
> +#if IS_ENABLED(CONFIG_PCMCIA)
> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {

apne_100_mbit is u32, hence can never be negative.

> +               pr_info("16-bit PCMCIA card detected!\n");
> +               isa_type = ISA_TYPE_AG16;
> +               apne_100_mbit = 1;
> +       }
> +#endif
> +
>         if (!init_pcmcia()) {
>                 /* XXX: shouldn't we re-enable irq here? */
>                 free_netdev(dev);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
