Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE8835144
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFDUm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:42:58 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:39685 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:42:57 -0400
Received: by mail-ed1-f48.google.com with SMTP id m10so2363925edv.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFdygTzjWLk4VqffeYEauLIPPpPlQuC+TR+K4Y9DXEg=;
        b=BJv4/t9tQoAbpbJhZ5UoMa6em1+ZKbvA2orO2mExToUOykvo25H8pHY6qL0q00j/36
         z9WWLRObNHQ6PNpfOZSu9dumEJGve6c7bDVVsAkdpa0P/jUk1a/b/Dz7XXg4/BXEZuLC
         5cnULZUXSUsDIupjxQ2vpWSlXAGbHdqnFkXWEeVI18jxg6ljTVbNxe+1w8LV0tvT3tzo
         m0SyAiFKUBmN1wEG10WUT7n44SD7R156bOFe8D9Mx3o+APs3GMTeaAN3QkZle9C5bunb
         y/uKtkDF4ChbcChjO9Mm3/HTfi6Mvb2ET/qzdwic13qehaLnoKISMfQTchUnLXWq2k/l
         5F6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFdygTzjWLk4VqffeYEauLIPPpPlQuC+TR+K4Y9DXEg=;
        b=tUqcvfl1hf+Lkb3znk63VQVcg5ATbgZWecXSS0cnm8matFAFQyn20L+va3ZCrPWcr4
         w7xmFcdGCuWkpysdTKLoRqimz6bEf/fEYe/rtmWFa9TMKN0hbWoFHVH9suKTTGBPlRvV
         HM1xtmokUfDOSu6MOGZmUzL2A+ZeVjJ9WMkMYk4siFZUEmxqgn4RBQLvJjk0WbC6RCG5
         BYDjUXn/vsXBUovUquHqRfLt9IGj0rHbIIz8C8EO9tVtRGas46QgPaY8oQ5bcaf6sVrP
         RZhFX5vqinewxf4D7bL//HqPPtI5wikpn1OK3yGgcPidQ/u0rIcFgyXWsZjK53A16ZbY
         Ua5w==
X-Gm-Message-State: APjAAAUMnxUrlIj4nsnUO1bk2rZwwK8NgxK3dyiAqdcHrKr060d1SO/s
        /X5KFz1DBPMhTpqcijmR1S/0EzPaYZ49qn+T8hw=
X-Google-Smtp-Source: APXvYqy0kghSGhuD7V3Vj7MUbLteL2XBR31ERAvrQ+uqHrlMTPqWAU038UF7jTB80rntfC+gouq2CZYxXR8LeakAG/U=
X-Received: by 2002:a50:ba1b:: with SMTP id g27mr18373206edc.18.1559680975919;
 Tue, 04 Jun 2019 13:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com> <20190604200713.GV19627@lunn.ch>
In-Reply-To: <20190604200713.GV19627@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 4 Jun 2019 23:42:45 +0300
Message-ID: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 23:07, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
> > Hi,
> >
> > I've been wondering what is the correct approach to cut the Ethernet link
> > when the user requests it to be administratively down (aka ip link set dev
> > eth0 down).
> > Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.
> > This leaves an Ethernet link between the PHY and its link partner.
> > The Freescale gianfar driver (authored by Andy Fleming who also authored the
> > phylib) does a phy_disconnect here. It may seem a bit overkill, but of the
> > extra things it does, it calls phy_suspend where most PHY drivers set the
> > BMCR_PDOWN bit. Only this achieves the intended purpose of also cutting the
> > link partner's link on 'ip link set dev eth0 down'.
>
> Hi Vladimir
>
> Heiner knows the state machine better than i. But when we transition
> to PHY_HALTED, as part of phy_stop(), it should do a phy_suspend().
>
>    Andrew

Hi Andrew, Florian,

Thanks for giving me the PHY_HALTED hint!
Indeed it looks like I conflated two things - the Ehernet port that
uses phy_disconnect also happens to be connected to a PHY that has
phy_suspend implemented. Whereas the one that only does phy_stop is
connected to a PHY that doesn't have that... I thought that in absence
of .suspend, the PHY library automatically calls genphy_suspend. Oh
well, looks like it doesn't. So of course, phy_stop calls phy_suspend
too.
But now the second question: between a phy_connect and a phy_start,
shouldn't the PHY be suspended too? Experimentally it looks like it
still isn't.
By the way, Florian, yes, PHY drivers that use WOL still set
BMCR_ISOLATE, which cuts the MII-side, so that's ok. However that's
not the case here - no WOL.

Regards,
-Vladimir
