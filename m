Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB0826F8E5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgIRJEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:04:15 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38021 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgIRJEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 05:04:14 -0400
Received: by mail-ot1-f67.google.com with SMTP id y5so4748721otg.5;
        Fri, 18 Sep 2020 02:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbUyg3pwnmxhvAaCD6PCL+qYrsMttHAaaWRKhDG5T68=;
        b=uAOIJJQz1dn9ic37IQOaQiQzp51lNyUYpOLGTYdnM9XJKj+nKyfgLDJB1Gm3W7uSLO
         KG8u8/Wr40SCT7CD/xi/zHcjQhOb10SIihTFfpZKDu2V5IAGuIXpE14jqB0tS+pX5Qzw
         qyh90Z0M+IBvSiWL63+E5jDDSaYLcBNwqJ/dA7KcgzMyOgGQWOy78UsqF8+bH3MH5Gji
         Xmb+v24swixRjMzIf1SxW7LQ4FQJ2L0jT/3Cw6lxZ4kksHWwBg7HQwCabclv7tgVaEhZ
         7MuB/KMe3Ij4wYrgMNqP229oUjohRJBs0KdyVR8ET2K9C3GcLhhFx/LqIvCAHqbkLPPr
         YQFg==
X-Gm-Message-State: AOAM530Mr7JbL3ZGHTgj5kAX+zNZJ+sCNCqnJXvoI8O5sB/Pffn5BRAB
        4+PAfbOf1EjcxB9oin0046LqgHvJXIB/RUnndPI=
X-Google-Smtp-Source: ABdhPJyGdJI0FyOn41YC2WoL2riEjhmCGQfFPKCsWbzOPXUXLsiSpeV5/4ZSuAQVcG/fpFn5TzdIpI3Mc4uXYZysqKw=
X-Received: by 2002:a05:6830:1008:: with SMTP id a8mr20644042otp.107.1600419853345;
 Fri, 18 Sep 2020 02:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200917135707.12563-1-geert+renesas@glider.be>
 <20200917135707.12563-6-geert+renesas@glider.be> <29970fbf-9779-d182-5df9-4f563f377311@ti.com>
In-Reply-To: <29970fbf-9779-d182-5df9-4f563f377311@ti.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Sep 2020 11:04:02 +0200
Message-ID: <CAMuHMdU+C9_mKJHtpevohkMkbHyur0gaVq1PvXnmY7cMHrSmWQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 5/5] ravb: Add support for explicit internal
 clock delay configuration
To:     Dan Murphy <dmurphy@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Thu, Sep 17, 2020 at 8:50 PM Dan Murphy <dmurphy@ti.com> wrote:
> On 9/17/20 8:57 AM, Geert Uytterhoeven wrote:
> > Some EtherAVB variants support internal clock delay configuration, which
> > can add larger delays than the delays that are typically supported by
> > the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> > properties).
> >
> > Historically, the EtherAVB driver configured these delays based on the
> > "rgmii-*id" PHY mode.  This caused issues with PHY drivers that
> > implement PHY internal delays properly[1].  Hence a backwards-compatible
> > workaround was added by masking the PHY mode[2].
> >
> > Add proper support for explicit configuration of the MAC internal clock
> > delays using the new "[rt]x-internal-delay-ps" properties.
> > Fall back to the old handling if none of these properties is present.
> >
> > [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for
> >      the KSZ9031 PHY")
> > [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
> >      delays twice").
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> > @@ -1989,20 +1986,41 @@ static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
> >   };
> >
> >   /* Set tx and rx clock internal delay modes */
> > -static void ravb_parse_delay_mode(struct net_device *ndev)
> > +static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
> >   {
> >       struct ravb_private *priv = netdev_priv(ndev);
> > +     bool explicit_delay = false;
> > +     u32 delay;
> > +
> > +     if (!of_property_read_u32(np, "rx-internal-delay-ps", &delay)) {
> > +             /* Valid values are 0 and 1800, according to DT bindings */
> > +             priv->rxcidm = !!delay;
> > +             explicit_delay = true;
> > +     }
> > +     if (!of_property_read_u32(np, "tx-internal-delay-ps", &delay)) {
> > +             /* Valid values are 0 and 2000, according to DT bindings */
> > +             priv->txcidm = !!delay;
> > +             explicit_delay = true;
> > +     }
> There are helper functions for this
>
> s32 phy_get_internal_delay(struct phy_device *phydev, struct device
> *dev, const int *delay_values, int size, bool is_rx)

That helper operates on the PHY device, not on the MAC device.
Cfr. what I stated in the cover letter:

    This can be considered the MAC counterpart of commit 9150069bf5fc0e86
    ("dt-bindings: net: Add tx and rx internal delays"), which applies to
    the PHY.  Note that unlike commit 92252eec913b2dd5 ("net: phy: Add a
    helper to return the index for of the internal delay"), no helpers are
    provided to parse the DT properties, as so far there is a single user
    only, which supports only zero or a single fixed value.  Of course such
    helpers can be added later, when the need arises, or when deemed useful
    otherwise.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
