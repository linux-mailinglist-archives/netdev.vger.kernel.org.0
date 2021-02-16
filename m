Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CFA31C713
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 09:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBPIBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 03:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhBPIBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 03:01:13 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83634C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:00:32 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v1so11849006wrd.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwmUOR+Kw6NCxE6ScNYmLgfLQH1vj/f+enu2NNGLLMs=;
        b=N7vXYPL4BaCLYo3VMtZhsEpCqS3iK0t4fmFyyQ7ipkbb2UNg3T9KiIcuKFYQ/Loe2v
         oWIHpiZq8cMlKPwUZKZytxxch0hKt9CZ+j6koti0t4HfJ0wM8NUsF+BBYyJJeJwva1wq
         2FHf7ld7kh8enq1mksdJ/sCmW/ViZbQbcNpuT8yfMnh0nGcUtpnj5eo90GPEczi8BuzH
         FvI+8dhw3ZBobJSHQIcjL1CDHyfMeUXGweHsYPwz2ep6fIb2bmdTBuY8wO4Jv+KqMLWi
         OWJK3yiB8aGEnqAuNm/ueWXFleKiOeyyME4148yKcPnPG87fTljIjCTxRsyv69USzWGX
         KY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwmUOR+Kw6NCxE6ScNYmLgfLQH1vj/f+enu2NNGLLMs=;
        b=CvaCpw48/S0VUUXYID7savfGUR0koBSfjhvCBly498KNheoKyoJhyZvlQMMPffWHPl
         Fc+C/7MRjgDqNBUApd2c6RillSbGTxConPruIRI9XcFm0fYD9tzPEi0VegznsY0V2p1a
         Xw0HPrvbeR0/gVaAkPzY6LDN+mKtZ1gMzPYDw362LOSHlTMMRZuQPFXKGnd4bfwq9URW
         fjsEuc1sFY0lOSio75ndk8h19qa2eVmf6zEU7I3fQvzljUIsjltbDe5pKOmdosMF9qO9
         RCBWnSsZt6OMB9JhlXIQviVFNToJJxnfGyJXATlg4mY3DrxDUHVyS3hR/9RDWZh9AEyt
         0Y+w==
X-Gm-Message-State: AOAM5318gJAjHgzfrnTeb+CS/XaiXpRi0mAmXZzSF1uLcKT2DngSrHuU
        bHg+Q1VPClYKdObvzgb09Bj393wqPk7lu3YPD0Vy5Q==
X-Google-Smtp-Source: ABdhPJzdMeJZUT4iadzAycjhxEhsamU20vtCbsbjXduXIEZ3tbYyX31wuP5nXfoekpa41H8nPBwdbUsK68TjZDzrpJ4=
X-Received: by 2002:adf:c785:: with SMTP id l5mr16456750wrg.234.1613462431191;
 Tue, 16 Feb 2021 00:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20210215061559.1187396-1-nathan@nathanrossi.com>
 <20210215144756.76846c9b@nic.cz> <20210215145757.GX1463@shell.armlinux.org.uk>
 <20210215161627.63c3091c@nic.cz> <20210215152944.GY1463@shell.armlinux.org.uk>
 <20210215165827.5cdb3f3f@nic.cz>
In-Reply-To: <20210215165827.5cdb3f3f@nic.cz>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Tue, 16 Feb 2021 18:00:19 +1000
Message-ID: <CA+aJhH0XQRD4ZGLeAeBCaE+Jdwf-rT-Mb1fQZ1QS0yK9UAxX7g@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Feb 2021 at 01:58, Marek Behun <marek.behun@nic.cz> wrote:
>
> On Mon, 15 Feb 2021 15:29:44 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
>
> > On Mon, Feb 15, 2021 at 04:16:27PM +0100, Marek Behun wrote:
> > > On Mon, 15 Feb 2021 14:57:57 +0000
> > > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > >
> > > > On Mon, Feb 15, 2021 at 02:47:56PM +0100, Marek Behun wrote:
> > > > > On Mon, 15 Feb 2021 06:15:59 +0000
> > > > > Nathan Rossi <nathan@nathanrossi.com> wrote:
> > > > >
> > > > > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > > > > > index 54aa942eed..5c52906b29 100644
> > > > > > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > > > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > > > > @@ -650,6 +650,13 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
> > > > > >       if (chip->info->ops->phylink_validate)
> > > > > >               chip->info->ops->phylink_validate(chip, port, mask, state);
> > > > > >
> > > > > > +     /* Advertise 2500BASEX only if 1000BASEX is not configured, this
> > > > > > +      * prevents phylink_helper_basex_speed from always overriding the
> > > > > > +      * 1000BASEX mode since auto negotiation is always enabled.
> > > > > > +      */
> > > > > > +     if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> > > > > > +             phylink_clear(mask, 2500baseX_Full);
> > > > > > +
> > > > >
> > > > > I don't quite like this. This problem should be either solved in
> > > > > phylink_helper_basex_speed() or somewhere in the mv88e6xxx code, but near
> > > > > the call to phylink_helper_basex_speed().
> > > > >
> > > > > Putting a solution to the behaviour of phylink_helper_basex_speed() it
> > > > > into the validate() method when phylink_helper_basex_speed() is called
> > > > > from a different place will complicate debugging in the future. If
> > > > > we start solving problems in this kind of way, the driver will become
> > > > > totally unreadable, IMO.
> > > >
> > > > If we can't switch between 1000base-X and 2500base-X, then we should
> > > > not be calling phylink_helper_basex_speed() - and only one of those
> > > > two capabilities should be set in the validation callback. I thought
> > > > there were DSA switches where we could program the CMODE to switch
> > > > between these two...
> > >
> > > There are. At least Peridot, Topaz and Amethyst support switching
> > > between these modes. But only on some ports.
> > >
> > > This problem happnes on Peridot X, I think.
> > >
> > > On Peridot X there are
> > > - port 0: RGMII
> > > - ports 9-10: capable of 1, 2.5 and 10G SerDes (10G via
> > >   XAUI/RXAUI, so multiple lanes)
> > > - ports 1-8: with copper PHYs
> > >   - some of these can instead be set to use the unused SerDes lanes
> > >     of ports 9-10, but only in 1000base-x mode
> > >
> > > So the problem can happen if you set port 9 or 10 to only use one
> > > SerDes lane, and use the spare lanes for the 1G ports.
> > > On these ports 2500base-x is not supported, only 1000base-x (maybe
> > > sgmii, I don't remember)
> >
> > It sounds like the modes are not reporting correctly then before calling
> > phylink_helper_basex_speed(). If the port can only be used at 1000base-X,
> > then it should not be allowing 2500base-X to be set prior to calling
> > phylink_helper_basex_speed().
> >
>
> Hmm. It doesn't seem that way. Ports 1-8 only set support for 1000baseT
> and 1000baseX. And for lower modes if state->interface is not 8023z.
>
> Nathan, what switch do you use and on which port does this happen?
>

After looking at this issue again in more depth, it seems I had
managed to confuse myself with the uplinks and their actual modes.
Specifically the fixed link uplink was being configured as a
1000base-x but should have been configured as sgmii phy-mode in the
device tree. This resolves the issues associated with auto negotiation
(not enabled for sgmii), on 88e6390 (port 9 uplink) and 88e6193x (port
0 uplink) switches.

Sorry for the noise, and any confusion. However it should be noted
that the issue mentioned in this patch might still be applicable if
fixed 1000base-x links are expected to work.

Thanks,
Nathan
