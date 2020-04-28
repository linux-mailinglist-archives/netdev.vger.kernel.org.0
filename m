Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B4D1BC3A5
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 17:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgD1P2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 11:28:43 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36947 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgD1P2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 11:28:42 -0400
Received: by mail-ot1-f68.google.com with SMTP id z17so33346334oto.4;
        Tue, 28 Apr 2020 08:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MW/OWSJ7jnlgJeVyEXGr+UHRHBwvDLhnEj4Gw0Faysc=;
        b=Nf+fnM+pZcFGWPCTcaEKC4Oz4f5HYkfJfGADgAlBXwMl8bmHeHQaAYxdmVOoYRklDi
         8lqyQHyNEXUnm1ZNKULaf4km7cvynqmmdc1E70cKhB00Vewt/MneVXnFqatRJUQaageP
         RR+aDoQwdMpq9Ic5fbyp6vXFaM4glH3IuUIDFLrQKGuY/f/pSKdB9cqox3CyVacx/vX7
         kXfeaeJ4f+37XPKeqDukP/I0Syt/nFmcgzunZIwJ3JFFklaH7aw2PvPbGV/dM6fgcHt1
         ZbaOVTGsotKeM6lfnqZ287BX325KfCXFEtndqYBXeIdJT3Hd8B7sMAdD1EWXWfCrGnYw
         5ZSg==
X-Gm-Message-State: AGi0Pua1GdWcdwFRRQo0PW+5RQPArB3I4c5EvEhenQ0lO7tAeLi2NQQj
        6gXzO1hS5rvi4TXO3ivkZnOlhgu/6H+xC8tlx7mWlW7d
X-Google-Smtp-Source: APiQypLMHJyVIXfFFO2xNpPTu7dzQmo3gqEMYjKRlGRvQ7k6o1mLs/72dhZWPi5STyFqrrxlJOrh3hq9svuLM+e9K0c=
X-Received: by 2002:a9d:564:: with SMTP id 91mr23004838otw.250.1588087721620;
 Tue, 28 Apr 2020 08:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
In-Reply-To: <20200422072137.8517-1-o.rempel@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Apr 2020 17:28:30 +0200
Message-ID: <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <kernel@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Wed, Apr 22, 2020 at 9:24 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.
>
> This PHY has an internal RX delay of 1.2ns and no delay for TX.
>
> The pad skew registers allow to set the total TX delay to max 1.38ns and
> the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> 1.2ns) and a minimal delay of 0ns.
>
> According to the RGMII v1.3 specification the delay provided by PCB traces
> should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> delay by MAC or PHY. So, we configure this PHY to the best values we can
> get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> 1.80ns (best calculated delay)
>
> The phy-modes can still be fine tuned/overwritten by *-skew-ps
> device tree properties described in:
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This is now commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode
support for the KSZ9031 PHY") in net-next/master.

> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c

> @@ -597,21 +703,33 @@ static int ksz9031_config_init(struct phy_device *phydev)
>         } while (!of_node && dev_walker);
>
>         if (of_node) {
> +               bool update = false;
> +
> +               if (phy_interface_is_rgmii(phydev)) {
> +                       result = ksz9031_config_rgmii_delay(phydev);
> +                       if (result < 0)
> +                               return result;
> +               }
> +
>                 ksz9031_of_load_skew_values(phydev, of_node,
>                                 MII_KSZ9031RN_CLK_PAD_SKEW, 5,
> -                               clk_skews, 2);
> +                               clk_skews, 2, &update);
>
>                 ksz9031_of_load_skew_values(phydev, of_node,
>                                 MII_KSZ9031RN_CONTROL_PAD_SKEW, 4,
> -                               control_skews, 2);
> +                               control_skews, 2, &update);
>
>                 ksz9031_of_load_skew_values(phydev, of_node,
>                                 MII_KSZ9031RN_RX_DATA_PAD_SKEW, 4,
> -                               rx_data_skews, 4);
> +                               rx_data_skews, 4, &update);
>
>                 ksz9031_of_load_skew_values(phydev, of_node,
>                                 MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
> -                               tx_data_skews, 4);
> +                               tx_data_skews, 4, &update);
> +
> +               if (update && phydev->interface != PHY_INTERFACE_MODE_RGMII)
> +                       phydev_warn(phydev,
> +                                   "*-skew-ps values should be used only with phy-mode = \"rgmii\"\n");

This triggers on Renesas Salvator-X(S):

    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
*-skew-ps values should be used only with phy-mode = "rgmii"

which uses:

        phy-mode = "rgmii-txid";

and:

        rxc-skew-ps = <1500>;

If I understand Documentation/devicetree/bindings/net/ethernet-controller.yaml
correctly:

      # RX and TX delays are added by the MAC when required
      - rgmii

i.e. any *-skew-ps can be specified.

      # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

i.e. *-skew-ps must not be specified.

      # RGMII with internal RX delay provided by the PHY, the MAC
      # should not add an RX delay in this case
      - rgmii-rxid

i.e. it's still OK to specify tx*-skew-ps values here...

      # RGMII with internal TX delay provided by the PHY, the MAC
      # should not add an TX delay in this case
      - rgmii-txid

... and rx*-skew-ps values here?
Is my understanding correct, and should the check be updated to take into
account rxid and txid?

BTW, the example in Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
still specifies *-skew-ps values with phy-mode = "rgmii-id", so I think
that should be updated, too.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
