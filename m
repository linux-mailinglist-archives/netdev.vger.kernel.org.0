Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50D792519
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfHSNe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:34:59 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34019 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbfHSNe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 09:34:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so1692823edb.1;
        Mon, 19 Aug 2019 06:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32OUIGi/U1dQgwuFNrponO5tipQ2FR+AuoMDrF7RhyU=;
        b=SWVmKfsEFNR9rKlc8P2NdJBxZKIn5OX1vjuwtjFAVGTRmgXt4uGPFxNVNbEsGueLNj
         IWdqK/eul7J63FCCgSwfgiQYd7P9NexsIKSJ4LtVn9O7xe76H4V56KeFzXIbhtuF/U97
         hCEGl2Iv3bqLRraONNDrJtmzN8RSnj/yFPnS4NmuTVM88Uth4v3gZMvRq5dnMSc/g9vx
         P1cQNxWhVfiRhgkkLqWPY0qNpN+620RSZpY+SthVzP+sw/6H12UJMkb0AhB3e3iJLqs1
         wT/qjq6T4RFlUnQKreTGhjO1VhLWQvPVwHj/ZxVhJ3IouXT92cy1He6byOYOv0bNodYW
         ARpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32OUIGi/U1dQgwuFNrponO5tipQ2FR+AuoMDrF7RhyU=;
        b=rcQ9KE7O8TxuQNrD9vfQbgW1cWqTucMhmArkLFU/tdKs25PxtX2A8Z1LBAOwY+kZh1
         dobTGdURbGw5QkyWBxGO08mERhj1+Um+oxC7CV+Ey3ITrjm9V+d1Kfa8eyDL5XrNb+Ze
         OY81O62C9S3PJyrMLfE48epCA4ElfkHl8s1BtKRkpUzHQ7iwO2zAJVdxpcWAaN1Ga3+S
         V+Ho6HY22sReAxswblB42NJ62zwPUinsWuKBUQuc4K4XLM97iAFJUWb1iPuByRMRHKNN
         z8zFYcuamTZPSQ3lD6Qx5C3E6qKMC3t3qMelo9oefc4C7/sXzVdwJiMBJ6W5aY8dq4Bg
         p92Q==
X-Gm-Message-State: APjAAAV91oCPyAKHtFhLpNhKZgT8bH13sCZZS12p/YdcW+kQBsTGOxmS
        lUg7lP0A4o6UD3Sif/q2LXJumz6pVYKsmfa9zjI=
X-Google-Smtp-Source: APXvYqzq4e8357GZ25Mc1WJ3vew7Hn7fLH1ENXiQMgSFfohEfbNutEDbEb0e2j0hrwgL/w4RCPJ44GwfxoC+G7vq9hA=
X-Received: by 2002:a05:6402:124f:: with SMTP id l15mr25050362edw.140.1566221697811;
 Mon, 19 Aug 2019 06:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190816163157.25314-1-h.feurstein@gmail.com> <20190816163157.25314-2-h.feurstein@gmail.com>
 <20190819131736.GD8981@lunn.ch>
In-Reply-To: <20190819131736.GD8981@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 19 Aug 2019 16:34:46 +0300
Message-ID: <CA+h21hou0v0gPURO3VHe2Ur1-heXnuueN5F92iDLffArB+1d5w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: mdio: add support for passing a PTP
 system timestamp to the mii_bus driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 19 Aug 2019 at 16:17, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Aug 16, 2019 at 06:31:55PM +0200, Hubert Feurstein wrote:
> > In order to improve the synchronisation precision of phc2sys (from
> > the linuxptp project) for devices like switches which are attached
> > to the MDIO bus, it is necessary the get the system timestamps as
> > close as possible to the access which causes the PTP timestamp
> > register to be snapshotted in the switch hardware. Usually this is
> > triggered by an MDIO write access, the snapshotted timestamp is then
> > transferred by several MDIO reads.
> >
> > This patch adds the required infrastructure to solve the problem described
> > above.
> >
> > Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> > ---
> >  drivers/net/phy/mdio_bus.c | 105 +++++++++++++++++++++++++++++++++++++
> >  include/linux/mdio.h       |   7 +++
> >  include/linux/phy.h        |  25 +++++++++
> >  3 files changed, 137 insertions(+)
> >
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index bd04fe762056..167a21f267fa 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/phy.h>
> >  #include <linux/io.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/ptp_clock_kernel.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/mdio.h>
> > @@ -697,6 +698,110 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
> >  }
> >  EXPORT_SYMBOL(mdiobus_write);
> >
> > +/**
> > + * __mdiobus_write_sts - Unlocked version of the mdiobus_write_sts function
> > + * @bus: the mii_bus struct
> > + * @addr: the phy address
> > + * @regnum: register number to write
> > + * @val: value to write to @regnum
> > + * @sts: the ptp system timestamp
> > + *
> > + * Write a MDIO bus register and request the MDIO bus driver to take the
> > + * system timestamps when sts-pointer is valid. When the bus driver doesn't
> > + * support this, the timestamps are taken in this function instead.
> > + *
> > + * In order to improve the synchronisation precision of phc2sys (from
> > + * the linuxptp project) for devices like switches which are attached
> > + * to the MDIO bus, it is necessary the get the system timestamps as
> > + * close as possible to the access which causes the PTP timestamp
> > + * register to be snapshotted in the switch hardware. Usually this is
> > + * triggered by an MDIO write access, the snapshotted timestamp is then
> > + * transferred by several MDIO reads.
> > + *
> > + * Caller must hold the mdio bus lock.
> > + *
> > + * NOTE: MUST NOT be called from interrupt context.
> > + */
> > +int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
> > +                     struct ptp_system_timestamp *sts)
> > +{
> > +     int retval;
> > +
> > +     WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
> > +
> > +     if (!bus->ptp_sts_supported)
> > +             ptp_read_system_prets(sts);
>
> How expensive is ptp_read_system_prets()? My original suggestion was
> to unconditionally call it here, and then let the driver overwrite it
> if it supports finer grained time stamping. MDIO is slow, so as long
> as ptp_read_system_prets() is not too expensive, i prefer KISS.
>
>    Andrew

While that works for the pre_ts, it doesn't work for the post_ts (the
MDIO bus core will unconditionally overwrite the system timestamp from
the driver).
Unless you're suggesting to keep the pre_ts unconditional and the
post_ts under the "if" condition, which is a bit odd.
According to my tests with a scope (measuring the width between SPI
transfers with and without the ptp_read_system_*ts calls), two calls
to ktime_get_real_ts64 amount to around 750 ns on a 1200 MHz Cortex A7
core, or around 90 clock cycles.

Regards,
-Vladimir
