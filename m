Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402F397702
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfHUKTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUKTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 06:19:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E71453086272;
        Wed, 21 Aug 2019 10:19:47 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BCD05D9D3;
        Wed, 21 Aug 2019 10:19:46 +0000 (UTC)
Date:   Wed, 21 Aug 2019 12:19:43 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation
 to mdiobus_write_sts
Message-ID: <20190821101943.GS891@localhost>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at>
 <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost>
 <20190820152306.GJ29991@lunn.ch>
 <20190820154005.GM891@localhost>
 <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
 <20190821080709.GO891@localhost>
 <CAFfN3gXtkv=YjoQixN+MdZ9vLZRPBMwg1mefuBTHFf1_QENPsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gXtkv=YjoQixN+MdZ9vLZRPBMwg1mefuBTHFf1_QENPsg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 21 Aug 2019 10:19:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:53:12AM +0200, Hubert Feurstein wrote:
> Am Mi., 21. Aug. 2019 um 10:07 Uhr schrieb Miroslav Lichvar
> > Because those reports/statistics are important in calculation of
> > maximum error. If someone had a requirement for a clock to be accurate
> > to 1.5 microseconds and the ioctl returned a delay indicating a
> > sufficient accuracy when in reality it could be worse, that would be a
> > problem.
> >
> Ok, I understand your point. But including the MDIO completion into
> delay calculation
> will indicate a much wore precision as it actually is.

That's ok. It's the same with PCIe devices. It takes about 500 ns to
read a PCI register, so we know in the worst case the offset is
accurate to 250 ns. It's probably much better, maybe to 50 ns, but we
don't really know. We don't know how much asymmetry there is in the
PCIe delay (it certainly is not zero), or how much time the NIC
actually needs to respond to the command and when exactly it reads the
clock.

> When the MDIO
> driver implements
> the PTP system timestamping as follows ...
> 
>   ptp_read_system_prets(bus->ptp_sts);
>   writel(value, mdio-reg)
>   ptp_read_system_postts(bus->ptp_sts);
> 
> ... then we catch already the error caused by interrupts which hit the
> pre/post_ts section.
> Now we only have the additional error of one MDIO clock cycle
> (~400ns). Because I expect
> the MDIO controller to shift out the MDIO frame on the next MDIO clock
> cycle.

Is this always the case?

> So if I subtract
> one MDIO clock cycle from pre_ts and add one MDIO clock cycle to
> post_ts the error indication
> would be sufficiently corrected IMHO.

If I understand it correctly, this ignores the time needed for the
frame to be received, decoded and the clock to be read.

-- 
Miroslav Lichvar
