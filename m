Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516063C9C7B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbhGOKQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:16:11 -0400
Received: from mail-ua1-f44.google.com ([209.85.222.44]:33696 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhGOKQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:16:11 -0400
Received: by mail-ua1-f44.google.com with SMTP id d2so1885379uan.0;
        Thu, 15 Jul 2021 03:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lcif0yz8JBr6bwa2elod9t8kKI0nlrH00RAHFCfz0BE=;
        b=gGgFUxnwC2xfbB20RxUGeA8kzXkj8Z9fubwUCYcKg7wyiikpG+VgrajSRokfsA/AF7
         WWoquWYsLaY8l2naD9WGlTm7kBmw43HkFqgCXUkFoxqT1GsXGpfrLiekq7MxwwhtrEXG
         6aU9WWBYWaExsbGnjcKmLy47XsulSgLtkLIPPkYLSRIIGer/ed8rq70mdz5egk+kubGI
         MZLDMEjBxyY16xHzqMSO19hnfe1g4hcQ/jA9sjGKJVdR9vn8t+sK0bcycgtN8deWUn3k
         R+kWe8Jh6ZA9IOqHv9GnAyDtVh56ImJkYrlGbxsUCSo7D3bFATg7EpAbY+wNZ9+jaDnM
         k58w==
X-Gm-Message-State: AOAM5309HisalL1N2VIkl7q89A8ZvorPFFkX1QexKNHxnXaTF9SAO1O/
        iiUpHyvIfgghoZ6mlWgizGUEYr4+qkqW2pmv8zU=
X-Google-Smtp-Source: ABdhPJzubR0K4eHr0Avp0U/8JLj1I/Lrjf1aGFk66v9rzBTATJ75Aico6rlye0I8oLYdxo1n6ONVjyof80+MmNei2Oo=
X-Received: by 2002:ab0:5a2e:: with SMTP id l43mr5655079uad.4.1626343997843;
 Thu, 15 Jul 2021 03:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com> <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Jul 2021 12:13:06 +0200
Message-ID: <CAMuHMdW-NeDqiNDzQzzqnmQB2qL0Bc1-m+NQu9v8bK+_+7HxWQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
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

On Wed, Jul 14, 2021 at 4:54 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Add Gigabit Ethernet driver support.
>
> The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> access controller (DMAC).
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h

> @@ -986,6 +1068,7 @@ struct ravb_ptp {
>  enum ravb_chip_id {
>         RCAR_GEN2,
>         RCAR_GEN3,
> +       RZ_G2L,
>  };

Instead of adding another chip type, it may be better to replace
the chip type by a structure with feature bits, values, and function
pointers (see examples below).

BTW given the ravb driver is based on the sh_eth driver ("Ethernet
AVB includes an Gigabit Ethernet controller (E-MAC) that is basically
compatible with SuperH Gigabit Ethernet E-MAC"), and seeing the amount
of changes, I'm wondering if rgeth is closer to sh_eth? ;-)

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c

> @@ -247,8 +288,12 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>         int ring_size;
>         int i;
>
> -       if (priv->rx_ring[q]) {
> -               ravb_ring_free_ex(ndev, q);
> +       if (priv->chip_id == RZ_G2L) {
> +               if (priv->rgeth_rx_ring[q])
> +                       rgeth_ring_free_ex(ndev, q);
> +       } else {
> +               if (priv->rx_ring[q])
> +                       ravb_ring_free_ex(ndev, q);
>         }

Could be called through a function pointer instead.

> @@ -356,7 +434,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  static int ravb_ring_init(struct net_device *ndev, int q)
>  {
>         struct ravb_private *priv = netdev_priv(ndev);
> -       size_t skb_sz = RX_BUF_SZ;
> +       size_t skb_sz = (priv->chip_id == RZ_G2L) ? RGETH_RCV_BUFF_MAX : RX_BUF_SZ;

Could use a value in the structure.

> @@ -730,7 +1054,7 @@ static void ravb_emac_interrupt_unlocked(struct net_device *ndev)
>         ecsr = ravb_read(ndev, ECSR);
>         ravb_write(ndev, ecsr, ECSR);   /* clear interrupt */
>
> -       if (ecsr & ECSR_MPD)
> +       if (priv->chip_id != RZ_G2L && (ecsr & ECSR_MPD))

Could use a feature bit.

> @@ -2104,11 +2578,19 @@ static int ravb_probe(struct platform_device *pdev)
>         priv = netdev_priv(ndev);
>         priv->chip_id = chip_id;
>
> -       ndev->features = NETIF_F_RXCSUM;
> -       ndev->hw_features = NETIF_F_RXCSUM;
> -
> -       pm_runtime_enable(&pdev->dev);
> -       pm_runtime_get_sync(&pdev->dev);
> +       if (chip_id == RZ_G2L) {
> +               ndev->hw_features |= (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
> +               priv->rstc = devm_reset_control_get(&pdev->dev, NULL);

R-Car Gen2 and Gen3 describe a reset in DT, too.
Does it hurt to always use the reset?

> +               if (IS_ERR(priv->rstc)) {
> +                       dev_err(&pdev->dev, "failed to get cpg reset\n");

dev_err_probe(), to avoid printing an error on -EPROBE_DEFER.

> +                       free_netdev(ndev);
> +                       return PTR_ERR(priv->rstc);
> +               }
> +               reset_control_deassert(priv->rstc);
> +       } else {
> +               ndev->features = NETIF_F_RXCSUM;
> +               ndev->hw_features = NETIF_F_RXCSUM;
> +       }


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
