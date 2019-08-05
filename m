Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAEA81730
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 12:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfHEKg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 06:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfHEKg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 06:36:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C2F33084025;
        Mon,  5 Aug 2019 10:36:55 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C22760603;
        Mon,  5 Aug 2019 10:36:53 +0000 (UTC)
Date:   Mon, 5 Aug 2019 12:36:52 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] net: dsa: mv88e6xxx: ptp: improve phc2sys precision for
 mv88e6xxx switch in combination with imx6-fec
Message-ID: <20190805103652.GA16411@localhost>
References: <20190802163248.11152-1-h.feurstein@gmail.com>
 <CA+h21hr835sdvtgVOA2M9SWeCXDOrDG1S3FnNgJd_9NP2X_TaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr835sdvtgVOA2M9SWeCXDOrDG1S3FnNgJd_9NP2X_TaQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 05 Aug 2019 10:36:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:54:49PM +0300, Vladimir Oltean wrote:
> - Along the lines of the above, I wonder how badly would the
> maintainers shout at the proposal of adding a struct
> ptp_system_timestamp pointer and its associated lock in struct device.
> That way at least you don't have to change the API, like you did with
> mdiobus_write_nested_ptp. Relatively speaking, this is the least
> amount of intrusion (although, again, far from beautiful).

That would make sense to me, if there are other drivers that could use
it.

> I also added Miroslav Lichvar, who originally created the
> PTP_SYS_OFFSET_EXTENDED ioctl, maybe he can share some ideas on how it
> is best served.

The idea behind that ioctl was to allow drivers to take the system
timestamps as close to the reading of the HW clock as possible,
excluding delays (and jitter) due to other operations that are
necessary to get that timestamp. In the ethernet drivers that was a
single PCI read. If in this case it's a "write" operation that
triggers the reading of the HW clock, then I think the patch is
using is the ptp_read_system_*ts() calls correctly.

> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -1814,11 +1814,25 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >
> >         reinit_completion(&fep->mdio_done);
> >
> > -       /* start a write op */
> > -       writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> > -               FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> > -               FEC_MMFR_TA | FEC_MMFR_DATA(value),
> > -               fep->hwp + FEC_MII_DATA);
> > +       if (bus->ptp_sts) {
> > +               unsigned long flags = 0;
> > +               local_irq_save(flags);
> > +               __iowmb();
> > +               /* >Take the timestamp *after* the memory barrier */
> > +               ptp_read_system_prets(bus->ptp_sts);
> > +               writel_relaxed(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> > +                       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> > +                       FEC_MMFR_TA | FEC_MMFR_DATA(value),
> > +                       fep->hwp + FEC_MII_DATA);
> > +               ptp_read_system_postts(bus->ptp_sts);
> > +               local_irq_restore(flags);
> > +       } else {
> > +               /* start a write op */
> > +               writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> > +                       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> > +                       FEC_MMFR_TA | FEC_MMFR_DATA(value),
> > +                       fep->hwp + FEC_MII_DATA);
> > +       }

-- 
Miroslav Lichvar
