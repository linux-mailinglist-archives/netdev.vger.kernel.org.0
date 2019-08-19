Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9B9248B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfHSNRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:17:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbfHSNRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 09:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t0XkevwjTJ9RP2/my1dFM8HES1/oX+7ad8jFlZ4adgM=; b=3LgLTLxFNfpOG3Y5hYlz7akQsD
        KTxMzW/T7B9ii7ynlPFYiwsCaqZRSv4dDJtVjlnrFk+uWSxw1nuEBjlHHy6hfbCgw+ZkcuTS6PkYE
        KtbmaQtcdN/dr9TAgRIhxpEAYPSGecuzOOPaEGy4K4nN0Dkkj3wDN5wUFDr6LqWYtArM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzhXU-0005wf-He; Mon, 19 Aug 2019 15:17:36 +0200
Date:   Mon, 19 Aug 2019 15:17:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/3] net: mdio: add support for passing a PTP
 system timestamp to the mii_bus driver
Message-ID: <20190819131736.GD8981@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-2-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816163157.25314-2-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 06:31:55PM +0200, Hubert Feurstein wrote:
> In order to improve the synchronisation precision of phc2sys (from
> the linuxptp project) for devices like switches which are attached
> to the MDIO bus, it is necessary the get the system timestamps as
> close as possible to the access which causes the PTP timestamp
> register to be snapshotted in the switch hardware. Usually this is
> triggered by an MDIO write access, the snapshotted timestamp is then
> transferred by several MDIO reads.
> 
> This patch adds the required infrastructure to solve the problem described
> above.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
>  drivers/net/phy/mdio_bus.c | 105 +++++++++++++++++++++++++++++++++++++
>  include/linux/mdio.h       |   7 +++
>  include/linux/phy.h        |  25 +++++++++
>  3 files changed, 137 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index bd04fe762056..167a21f267fa 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -34,6 +34,7 @@
>  #include <linux/phy.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> +#include <linux/ptp_clock_kernel.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/mdio.h>
> @@ -697,6 +698,110 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
>  }
>  EXPORT_SYMBOL(mdiobus_write);
>  
> +/**
> + * __mdiobus_write_sts - Unlocked version of the mdiobus_write_sts function
> + * @bus: the mii_bus struct
> + * @addr: the phy address
> + * @regnum: register number to write
> + * @val: value to write to @regnum
> + * @sts: the ptp system timestamp
> + *
> + * Write a MDIO bus register and request the MDIO bus driver to take the
> + * system timestamps when sts-pointer is valid. When the bus driver doesn't
> + * support this, the timestamps are taken in this function instead.
> + *
> + * In order to improve the synchronisation precision of phc2sys (from
> + * the linuxptp project) for devices like switches which are attached
> + * to the MDIO bus, it is necessary the get the system timestamps as
> + * close as possible to the access which causes the PTP timestamp
> + * register to be snapshotted in the switch hardware. Usually this is
> + * triggered by an MDIO write access, the snapshotted timestamp is then
> + * transferred by several MDIO reads.
> + *
> + * Caller must hold the mdio bus lock.
> + *
> + * NOTE: MUST NOT be called from interrupt context.
> + */
> +int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
> +			struct ptp_system_timestamp *sts)
> +{
> +	int retval;
> +
> +	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
> +
> +	if (!bus->ptp_sts_supported)
> +		ptp_read_system_prets(sts);

How expensive is ptp_read_system_prets()? My original suggestion was
to unconditionally call it here, and then let the driver overwrite it
if it supports finer grained time stamping. MDIO is slow, so as long
as ptp_read_system_prets() is not too expensive, i prefer KISS.

   Andrew
