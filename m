Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD81E9455
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgE3Wma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbgE3Wm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:42:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2089C03E969;
        Sat, 30 May 2020 15:42:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id mb16so5663996ejb.4;
        Sat, 30 May 2020 15:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTkyMZJJ9ZyYPOlvh7OgoZfw2ynpN+TDHzhAtl+pZxs=;
        b=Pk5DvWPgOKgwZ64FLIczDw7CV7HPhkirGIaT2l/FTQzvUDiMsb3w4IQeibeWd/sb+J
         QP68Pb0urVLjvhRc45MXg4QAzBtwq2AnOmxWLJ2jy1oncZjXadW9Hi6pDXEafKtZj4tT
         pb+7BbAMeJWTKuJRJcHo4HTmWrIbGFlAcTlaZ++DeY6oZU/EKbznj9D/4Mmycyz5DSjK
         mZlbMK/f9N1JBVhohom2Dsg7yOSCzh0fxfBsImXJ19j/HwbdLvqItzd6652Yoxnsu0/Q
         mZA69VB8s9vmCbzBBexnJG5RW22foYsROUNgj8XrbJRIg406VcdArPPwXHnBHPHQEOUV
         MkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTkyMZJJ9ZyYPOlvh7OgoZfw2ynpN+TDHzhAtl+pZxs=;
        b=lj7+obssALYhm/uKxaAEwa2Muct3EvXWaGyu82zBZImZoddIIHivlEx/4yO8eLDagA
         NMsGLhItxmbMlss469y/6Notwrt0cM+kooF/Q7QXHpa9fg3BPgHHuN3+5iIWBAjxwRw3
         t/BeO12feCn0z1uU2YdfVvx0E7xW3kEDZbJ2v8avGARbxzmPWg0YHCsd2rddRNX/w0Px
         SuNhzcLG9va7eNHpDoha/j15s24d9N4QaIwyTFGE0T+KnKeQyQ8NyMUAU/hx2BfE0tdS
         W6MVXl6OMjEyXZxWFZqkJ2jqoEpy2eF74FmXZ3pBUYYShfwD/SVMK6w4ydhmhjwSgGiE
         UYVg==
X-Gm-Message-State: AOAM530OpFZIdQ+B0yMUcExhUQaGg9QM9YGtmFnndKdldaYefL0IDA16
        +sZqphZCvTIvUYhBNhr9t4vpw/r7CsHH8QlHmFE=
X-Google-Smtp-Source: ABdhPJx/ebUfQEsaZRpbpsdXvtiuMU/Kl9dl9RM92aKAAz+M29lpYur6ozVWvsiHw2uQ3ZI5E8SYeOCOxjS2QmCi1yw=
X-Received: by 2002:a17:906:e47:: with SMTP id q7mr173598eji.279.1590878547522;
 Sat, 30 May 2020 15:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200530214315.1051358-1-olteanv@gmail.com> <fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com>
In-Reply-To: <fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 31 May 2020 01:42:16 +0300
Message-ID: <CA+h21hr+GLbuN4MxPbj=d_VcR1LQ=8Pd75H932KybHNcWPhGfA@mail.gmail.com>
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Sun, 31 May 2020 at 01:36, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 30.05.2020 23:43, Vladimir Oltean wrote:
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
> >
> That's not nice from the PHY:
> It signals "link up", and if the system asks the PHY for link details,
> then it sheepishly says "well, link is *almost* up".
>

The copper-side link is 100% up. In my opinion this is actually abuse
of the .aneg_done API. Here's what the guy who added it had to say:

commit f62265b53ef34a372b657c99e23d32e95b464316
Author: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Date:   Mon Oct 24 12:40:54 2016 +0200

    at803x: double check SGMII side autoneg

    In SGMII mode, we observed an autonegotiation issue
    after power-down-up cycles where the copper side
    reports successful link establishment but the
    SGMII side's link is down.

    This happened in a setup where the at8031 is
    connected over SGMII to a eTSEC (fsl gianfar),
    but so far could not be reproduced with other
    Ethernet device / driver combinations.

    This commit adds a wrapper function for at8031
    that in case of operating in SGMII mode double
    checks SGMII link state when generic aneg_done()
    succeeds. It prints a warning on failure but
    intentionally does not try to recover from this
    state. As a result, if you ever see a warning
    '803x_aneg_done: SGMII link is not ok' you will
    end up having an Ethernet link up but won't get
    any data through. This should not happen, if it
    does, please contact the module maintainer.

    Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

> Question would be whether the same happens with other SGMII-capable
> PHY's so that we need to cater for this scenario in phylib.
> Or whether we consider it a chip quirk. In the latter case a custom
> read_status() handler might do the trick too: if link is reported
> as up then wait until aneg is signaled as done too before reading
> further link details.
>
> And it's interesting that nobody else stumbled across this problem
> before. I mean the PHY we talk about isn't really new. Or is your
> use case so special?
>

No, my use case isn't special at all. Just using it in interrupt mode :)
Today we have the pcs_poll option in phylink (checking the in-band AN
status at PCS side and not at PHY side). But not all Ethernet drivers
have phylink. Actually I think there's no good place in phylib to do
this in-band AN status checking.

But my patch is rather minimal and makes things work in the way there
were intended at that time.

> > In practice, what really happens depends on the log level of the serial
> > console. If the log level is verbose enough that kernel messages related
> > to the Ethernet link state are printed to the console, then this gives
> > in-band AN enough time to complete, which means the link will come up
> > and everyone will be happy. But if the console is not that verbose, the
> > link will sometimes come up, and sometimes will be forced down by the
> > .aneg_done of the PHY driver (forever, since we are not rescheduling).
> >
> > The conclusion is that an extra condition needs to be explicitly added,
> > so that the state machine can be rescheduled properly. Otherwise PHY
> > devices in interrupt mode will never work properly if they have an
> > .aneg_done callback.
> >
> > In more recent kernels, the whole PHY_AN state was removed by Heiner
> > Kallweit in the "[net-next,0/5] net: phy: improve and simplify phylib
> > state machine" series here:
> >
> > https://patchwork.ozlabs.org/cover/994464/
> >
> > and the problem was just masked away instead of being addressed with a
> > punctual patch.
> >
> > Fixes: 76a423a3f8f1 ("net: phy: allow driver to implement their own aneg_done")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > I'm not sure the procedure I'm following is correct, sending this
> > directly to Greg. The patch doesn't apply on net.
> >
> >  drivers/net/phy/phy.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index cc454b8c032c..ca4fd74fd2c8 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -934,7 +934,7 @@ void phy_state_machine(struct work_struct *work)
> >       struct delayed_work *dwork = to_delayed_work(work);
> >       struct phy_device *phydev =
> >                       container_of(dwork, struct phy_device, state_queue);
> > -     bool needs_aneg = false, do_suspend = false;
> > +     bool recheck = false, needs_aneg = false, do_suspend = false;
> >       enum phy_state old_state;
> >       int err = 0;
> >       int old_link;
> > @@ -981,6 +981,8 @@ void phy_state_machine(struct work_struct *work)
> >                       phy_link_up(phydev);
> >               } else if (0 == phydev->link_timeout--)
> >                       needs_aneg = true;
> > +             else
> > +                     recheck = true;
> >               break;
> >       case PHY_NOLINK:
> >               if (!phy_polling_mode(phydev))
> > @@ -1123,7 +1125,7 @@ void phy_state_machine(struct work_struct *work)
> >        * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
> >        * between states from phy_mac_interrupt()
> >        */
> > -     if (phy_polling_mode(phydev))
> > +     if (phy_polling_mode(phydev) || recheck)
> >               queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
> >                                  PHY_STATE_TIME * HZ);
> >  }
> >
>

Thanks,
-Vladimir
