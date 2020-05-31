Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18591E9A66
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgEaVAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgEaVAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 17:00:30 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411BC061A0E;
        Sun, 31 May 2020 14:00:29 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so7351211ejd.0;
        Sun, 31 May 2020 14:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=539l06f53hQ4Xnl2k60xCSVBBlVCTMlRCBAYOVC8l8A=;
        b=ZegqGqwcO5qNeH0dIwzsq5YM+/4mmrfjYyg21hV+nMf4bNefAObBhTB0JSVDD7I195
         pdjCG2rrHNbTz2UCmh4qjmyTlOwy/la8SDXM2sLEVn896qnbqnwb+HUPcQfCAeU+K4Jc
         6/n1QzyZcEaidmZ7I5Nl488n/zLytJSXr2aiFR8ytzKm7Mtqj/zlL5txpm1ZS9PLxp/+
         PbD96cq5353jC7OaWn5nq2gUtv8nxC7JA8oe9TCKPyUy9wbYCBf439u62nEtRonDR/uM
         keZJT1NDRI2jdRcfLhoFuXCOf46HgkOXiH9eM7yy3EuhDzYV4DbhPl9154r6s7HTzHWF
         7Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=539l06f53hQ4Xnl2k60xCSVBBlVCTMlRCBAYOVC8l8A=;
        b=nhp3JX0zsQXUTTN54IdPdA5NQpWf6LKljVExMSYDR9DbSwXbmNXe/g2Figx1xOMbU6
         3Dzuiek2ISaKZ0eeVaXBwQiusATl/vKD6EhYZ9zmWTXSq5BBnwtHw1KkOgaTB9vamB8/
         fjRGzOgsd1ebHar/bJ8Ojvj6Pr4bO6ulEOFTiwYVn1Q/ds/WpH9h/IWSCynNDY1awp8S
         MeTHcfTE/CGA8tZRjJzuXTD+gjgbRAj8tVT1t+6fIPpOyPY34tfgiEA6qtN1D14u3XsT
         b1KWgSTHSFobASscYzegLyVEvHF3bIivEFbH9pyC22kjRjU3/S0LJGSMpcm5ZXMSLUiD
         m2CA==
X-Gm-Message-State: AOAM530t+YX4UNvPyR5HyuoxHx8hY4Eax+p5fsJo4sVTHzVrR2JWjFwh
        +G10c5WCZ+tdLpRmVXo2YAsAzlBctVNC4PgOBE4=
X-Google-Smtp-Source: ABdhPJxYUMqW6wRO3Fnr7TD6KNWzYFwk4YyMVKj47rlRWaDPvigh5zprMrh+zv7vJNa/MaDkvrt0HmLpYrPBAQdGUEc=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr16304256eji.305.1590958827706;
 Sun, 31 May 2020 14:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200530214315.1051358-1-olteanv@gmail.com> <20200531001849.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20200531001849.GG1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 00:00:16 +0300
Message-ID: <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com>
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, zefir.kurtisi@neratec.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 May 2020 at 03:19, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sun, May 31, 2020 at 12:43:15AM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In kernel 4.19 (and probably earlier too) there are issues surrounding
> > the PHY_AN state.
> >
> > For example, if a PHY is in PHY_AN state and AN has not finished, then
> > what is supposed to happen is that the state machine gets rescheduled
> > until it is, or until the link_timeout reaches zero which triggers an
> > autoneg restart process.
> >
> > But actually the rescheduling never works if the PHY uses interrupts,
> > because the condition under which rescheduling occurs is just if
> > phy_polling_mode() is true. So basically, this whole rescheduling
> > functionality works for AN-not-yet-complete just by mistake. Let me
> > explain.
> >
> > Most of the time the AN process manages to finish by the time the
> > interrupt has triggered. One might say "that should always be the case,
> > otherwise the PHY wouldn't raise the interrupt, right?".
> > Well, some PHYs implement an .aneg_done method which allows them to tell
> > the state machine when the AN is really complete.
> > The AR8031/AR8033 driver (at803x.c) is one such example. Even when
> > copper autoneg completes, the driver still keeps the "aneg_done"
> > variable unset until in-band SGMII autoneg finishes too (there is no
> > interrupt for that). So we have the premises of a race condition.
>
> Why do we care whether SGMII autoneg has completed - is that not the
> domain of the MAC side of the link?
>
> It sounds like things are a little confused.  The PHY interrupt is
> signalling that the copper side has completed its autoneg.  If we're
> in SGMII mode, the PHY can now start the process of informing the
> MAC about the negotiation results across the SGMII link.  When the
> MAC receives those results, and sends the acknowledgement back to the
> PHY, is it not the responsibility of the MAC to then say "the link is
> now up" ?
>

Things are not at all confused on my end, Russell.
The "803x_aneg_done: SGMII link is not ok" log message had made me
aware of the existence of this piece of code for a very long while
now, but to be honest I hadn't actually read the commit message in
full detail until I replied to Heiner above. Especially this part:

    It prints a warning on failure but
    intentionally does not try to recover from this
    state. As a result, if you ever see a warning
    '803x_aneg_done: SGMII link is not ok' you will
    end up having an Ethernet link up but won't get
    any data through. This should not happen, if it
    does, please contact the module maintainer.

The author highlighted a valid issue, but then came up with a BS
solution for it. It solves no problem, and it creates a problem for
some who originally had none.
When used in poll mode, the at803x.c driver would occasionally catch
the in-band AN in a state where it wasn't yet complete, so it would
print this message once, but all was ok in the end since the state
machine would get rescheduled and the link would come up. So I
genuinely thought that the intention of the patch was to be helpful.
But according to his own words, it is just trying to throw its hands
up in the air and lay the blame on somebody else [ the gianfar
maintainer ]. So in that sense, maybe it's my 'fault' for trying to
make the link come up with 803x_aneg_done in place. Maybe I should
just respectfully revert the patch
f62265b53ef34a372b657c99e23d32e95b464316, and replace it with some
other framework. The trouble is, what to replace it with?

> That's how we deal with it elsewhere with phylink integration, which
> is what has to be done when you have to cope with PHYs that switch
> their host interface mode between SGMII, 2500BASE-X, 5GBASE-R and
> 10GBASE-R - the MAC side needs to be dynamically reconfigured depending
> on the new host-side operating mode of the PHY.  Only when the MAC
> subsequently reports that the link has been established is the whole
> link from the MAC to the media deemed to be operational.
>

This sounds to me like 'phylink has this one figured out', but I would
beg to differ.
My opinion is that it's not obvious that it would be the MAC's
responsibility to determine whether the overall link is operational
(applied in this case to in-band AN), but the system's responsibility,
and for a simple reason: it takes 2 to negotiate. The MAC PCS and the
PHY have to agree on whether they perform in-band AN or not. And
that's wild jungle right there, with some PHY drivers capable of
in-band AN keeping it enabled and some disabled (and even worse, PHY
drivers that don't enable it in Linux but enable it in U-Boot, and
since the setting is sticky, it changes the default behavior), and
phylink hasn't done anything to add some rules to it, just some
MAC-side knobs to turn for a particular MAC-PHY combination until
something works.

This is all relevant because our options for the stable trees boil
down to 2 choices:
- Revert f62265b53ef34a372b657c99e23d32e95b464316, fix an API misuse
and a bug, but lose an (admittedly ad-hoc, but still) useful way of
troubleshooting a system misconfiguration (hide the problem that Zefir
Kurtisi was seeing).
- Apply this patch which make the PHY state machine work even with
this bent interpretation of the API. It's not as if all phylib users
could migrate to phylink in stable trees, and even phylink doesn't
catch all possible configuration cases currently.

Either one is fine with me.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps u

Thanks,
-Vladimir
