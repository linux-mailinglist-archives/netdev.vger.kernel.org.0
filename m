Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BDD3E4552
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhHIMHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:07:06 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:37470 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhHIMHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 08:07:00 -0400
Received: by mail-ua1-f41.google.com with SMTP id 67so6889326uaq.4;
        Mon, 09 Aug 2021 05:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdIFyUpYOmARtbdZwtri8h0Sw2cLxyVaWTJ/k1Vbtto=;
        b=Iizz70hccW5JxKqLqyNkk1STfrgW3E7I63kAVQZIo4ROz6B/8bVDSelg/eIkhKNn8E
         jDVH/eiLevOGDcZ4YKYgv9CXCX9AuDpAUZkl10WMcGiYi4gOQRw8tXE5gwyt+ILrVJyw
         bEt4Opz6JIuNisX22PjGR6OPNmMR6gwRa3YT4TobOow9a/9fiqviJFGVfIA9gGqhlOTz
         vxmKsBJfbwx3CC+p8YX+Akeso72i7+k/lAM7xt9Vc4xN0J2qUmJFhgtP0fw2b7UkTWsj
         /39gLa3OnN5JDxblQie0vSaeCqZTneTwy355v+Fg+VjAFNnXnGlY5UHpwS31kOduvgYJ
         mHfw==
X-Gm-Message-State: AOAM533UmPWVCzsH4S1OrWh/kcIVZQwpPhgPZb/3ERftcfTdVEEnxLpk
        /y4yivPYqJRb7x/CNPTgAz3h0CqeJliweiifZ3U=
X-Google-Smtp-Source: ABdhPJzBjr9L/a/cJN4lt6cJw4cNlR1lJHDRbtmJgzlVTgNnjLG9tozWGcTvQaVgjF0HAOrpkA3PCyvZDLMwp0sJ5FM=
X-Received: by 2002:ab0:60c9:: with SMTP id g9mr15368667uam.100.1628510799843;
 Mon, 09 Aug 2021 05:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com> <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Aug 2021 14:06:28 +0200
Message-ID: <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver data
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Mon, Aug 2, 2021 at 12:27 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP. With a few changes in the driver we
> can support both IPs.
>
> Currently a runtime decision based on the chip type is used to distinguish
> the HW differences between the SoC families.
>
> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2 and
> RZ/G2L it is 2. For cases like this it is better to select the number of
> TX descriptors by using a structure with a value, rather than a runtime
> decision based on the chip type.
>
> This patch adds the num_tx_desc variable to struct ravb_hw_info and also
> replaces the driver data chip type with struct ravb_hw_info by moving chip
> type to it.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>         RCAR_GEN3,
>  };
>
> +struct ravb_hw_info {
> +       enum ravb_chip_id chip_id;
> +       int num_tx_desc;

Why not "unsigned int"? ...
This comment applies to a few more subsequent patches.

> +};
> +
>  struct ravb_private {
>         struct net_device *ndev;
>         struct platform_device *pdev;
> @@ -1040,6 +1045,8 @@ struct ravb_private {
>         unsigned txcidm:1;              /* TX Clock Internal Delay Mode */
>         unsigned rgmii_override:1;      /* Deprecated rgmii-*id behavior */
>         int num_tx_desc;                /* TX descriptors per packet */

... oh, here's the original culprit.

> +
> +       const struct ravb_hw_info *info;
>  };
>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
