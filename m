Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF10A3AD8D0
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFSJK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 05:10:26 -0400
Received: from mail-vs1-f46.google.com ([209.85.217.46]:35398 "EHLO
        mail-vs1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFSJKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 05:10:24 -0400
Received: by mail-vs1-f46.google.com with SMTP id j15so6306968vsf.2;
        Sat, 19 Jun 2021 02:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4po9uVd+8EhQG+1BQVzj+tYi7bOBxTAfPfI2c38dNBo=;
        b=SVdEuJKtHvHNjDJPdru1LKWX3ocfktQygc1BEAdF+4hzE/WierL69l2yniD5vf3Wmi
         psls9rmat09Mx0sqbnyzHY4LAwz0n5R1lE9w9zD+f/j49IFpD5nTL96dtvs+B2xiplZE
         W1rOCzhn+pZeAYWCRBkIbChAkzso6jHZ92mW18HMWWlGeLDsfbJJj4jVg2JMGfydLION
         ZEWP2plBEYrak2P3oYls/kUijcEMWxp9EYwsotzFwPdr5YaMfM+Jzamj1DQ3BWtsD37b
         KHJTVsaoy7XOn89YL9XJGZPkR/mLwLzPsJhf4SI7ejdyBsBL3EF7TVyT+yvo1KqtdG4/
         Q7DQ==
X-Gm-Message-State: AOAM530IglSefeuAA+51jNswU2tusoELdQilaHdVmGET9fdZhkcJUH7o
        jvQW0tniuyEgasSOWbhZ8LIknHfclBMFATzypm0=
X-Google-Smtp-Source: ABdhPJwPRDLSQD7EpiWB3zmebrBujgW1yOOldYA6bKB/FNuuC7HYtwaxaxIRej3Yw3X1q7vkVtvsEpTpcb0AVRiha58=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr10302283vsd.42.1624093693732;
 Sat, 19 Jun 2021 02:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com> <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
In-Reply-To: <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 19 Jun 2021 11:08:02 +0200
Message-ID: <CAMuHMdUSGWGMs6_wqy-CkfuKsdk=EBpEVBf3UugxCuo3qZQCKg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sat, Jun 19, 2021 at 2:35 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Add Kconfig option, module parameter and PCMCIA reset code
> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>
> 10 Mbit and 100 Mbit mode are supported by the same module.
> A module parameter switches Amiga ISA IO accessors to word
> access by changing isa_type at runtime. Additional code to
> reset the PCMCIA hardware is also added to the driver probe.
>
> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> Kazik <alex@kazik.de>.
>
> CC: netdev@vger.kernel.org
> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> Tested-by: Alex Kazik <alex@kazik.de>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

Thanks for your patch!

Note that this patch has a hard dependency on "[PATCH v5 1/2] m68k:
io_mm.h - add APNE 100 MBit support" in the series, so it must not
be applied to the netdev tree yet.

> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -143,6 +143,10 @@ config APNE
>           To compile this driver as a module, choose M here: the module
>           will be called apne.
>
> +         The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
> +         CNet Singlepoint). To activate 100 Mbit support at runtime or
> +         from the kernel command line, use the apne.100mbit module parameter.

According to the recent discussion about that, "at runtime" is not
really possible?  So that limits it to kernel command line (for the
builtin case)
or module parameter (for the modular case).

> +
>  config PCMCIA_PCNET
>         tristate "NE2000 compatible PCMCIA support"
>         depends on PCMCIA
> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
> index fe6c834..8223e15 100644
> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c
> @@ -120,6 +120,10 @@ static u32 apne_msg_enable;
>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>
> +static bool apne_100_mbit;
> +module_param_named(100_mbit, apne_100_mbit, bool, 0644);
> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
