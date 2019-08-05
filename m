Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686C582423
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfHERkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:40:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfHERky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 13:40:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ebRdmkjcxT+QZN99eIo6Wyjsn+ls17In3FnqQq3wMpY=; b=rbn2dLOEPu5Rlz2tmKntmy6/+n
        ZO0gYBXAWtviaY9T44hoiJQfbq9p73NshciENUou+p0F06s1qBQnBJ/XraRllkuve0GzkcucnbOrf
        ofdlG6MdIKmKHax7ocilJx2/rjCJKVU0nv7s6TP2FU9aIcMD0MTdsXHQjwyiQo6sooW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hugyZ-0000IM-7I; Mon, 05 Aug 2019 19:40:51 +0200
Date:   Mon, 5 Aug 2019 19:40:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
Message-ID: <20190805174051.GW24275@lunn.ch>
References: <20190805082642.12873-1-hubert.feurstein@vahle.at>
 <20190805135838.GF24275@lunn.ch>
 <CAFfN3gVFjb0uaF_NSHSOZN2knNn7nK3ZKRnvZDSN9A=+1qa-+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gVFjb0uaF_NSHSOZN2knNn7nK3ZKRnvZDSN9A=+1qa-+A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv88e6xxx_mdiobus_write_nested(struct mv88e6xxx_chip
> *chip, int addr, u32 regnum, u16 val)
> +{
> +       int err;
> +
> +       BUG_ON(in_interrupt());
> +
> +       mutex_lock_nested(&chip->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +       ptp_read_system_prets(chip->ptp_sts);
> +       err = __mdiobus_write(chip->bus, addr, regnum, val);
> +       ptp_read_system_postts(chip->ptp_sts);
> +       mutex_unlock(&chip->bus->mdio_lock);
> +
> +       return err;
> +}
> +
> static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
>                                      int dev, int reg, u16 data)
> {
>        int ret;
> 
> -       ret = mdiobus_write_nested_ptp(chip->bus, dev, reg, data,
> chip->ptp_sts);
> +       ret = mv88e6xxx_mdiobus_write_nested(chip, dev, reg, data);
>        if (ret < 0)
>                return ret;
> 
> The result was:
> Min:  -8052
> Max:  9988
> StdDev: 2490.17
> Count: 3592
> 
> It got improved, but you still have the unpredictable latencies caused by the
> mdio_done-completion (=> wait_for_completion_timeout) in imx_fec.

O.K. So lets think about a more generic solution we can use inside the
mdio bus driver. I don't know if adding an sts pointer to struct
device will be accepted. But adding one to struct mii_bus should be
O.K. It can be assigned to once the mdio_lock is taken, to avoid race
conditions. Add mdio_ptp_read_system_prets(bus) and
mdio_ptp_read_system_postts(bus) which the bus driver can use.

We also need a fallback in case the bus driver does not use them, so
something like:

mdiobus_write_sts(...)
{
        int retval;

        BUG_ON(in_interrupt());

        mutex_lock(&bus->mdio_lock);
	bus->sts = sts;
	sts->post_ts = 0;

	ktime_get_real_ts64(&sts->pre_ts);

        retval = __mdiobus_write(bus, addr, regnum, val);

	if (!sts->post_ts)
	   ktime_get_real_ts64(sts->post_ts)

	bus->sts = NULL;
        mutex_unlock(&bus->mdio_lock);

        return retval;
}

So at worse case, we get the time around the whole write operation,
but the MDIO bus driver can overwrite the pre_ts and set post_ts,
using mdio_ptp_read_system_prets(bus) and
mdio_ptp_read_system_postts(bus).

A similar scheme could be implemented to SPI devices, if the SPI
maintainer would accepted a sts pointer in the SPI bus driver
structure.

	Andrew
