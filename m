Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED7D1900D4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgCWWBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:01:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58206 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgCWWBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BURXuSWRhVL3nPARXD7h9cw3er8J3SPrDC1cjtNO7cI=; b=O+9J0NVcrxTC087+O+74d/oqY
        t9lI/ANC1Fz4znuEjSsFJhLGrltr6RbNf4EENje5yl6iaHEo94ruwoiudBKzkDgVxO5wXxuR01GQ+
        C62JSXIef4L45HI0Zf/nVwAvAxi7/1c5f5Zk3AFHmtgbWxdzdYzFssEl5vEYYw0WgdLCfeCsw6U9j
        ipmCeInLQTuT3vZb2kMhaf3lpJ+fhQuEsYCgKWQZsxWFsfWOL0e0dJN8qL2hPJ7hurm0CSd5Vh6q+
        eGRMcNxMnUjweNXgkMYHmELGDXQZ6lkq9hwPpgrUeIWfG9nmYKrK+CTdw03tmy99FCE40eKOFJGPi
        qTJrleR9g==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36324)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jGV8F-0004LJ-HR; Mon, 23 Mar 2020 22:01:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jGV8D-0000d3-Fa; Mon, 23 Mar 2020 22:01:13 +0000
Date:   Mon, 23 Mar 2020 22:01:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when
 changing speed
Message-ID: <20200323220113.GX25745@shell.armlinux.org.uk>
References: <20200323214900.14083-1-andrew@lunn.ch>
 <20200323214900.14083-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323214900.14083-3-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 10:49:00PM +0100, Andrew Lunn wrote:
> The MAC control register must not be changed unless the link is down.
> Add the necassary call into mv88e6xxx_mac_link_up. Without it, the MAC
> does not change state, the link remains at the wrong speed.
> 
> Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index dd8a5666a584..24ce17503950 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -733,6 +733,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
>  
>  	mv88e6xxx_reg_lock(chip);
>  	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
> +		/* Port's MAC control must not be changed unless the
> +		 * link is down
> +		 */
> +		err = chip->info->ops->port_set_link(chip, port,
> +						     LINK_FORCED_DOWN);
> +		if (err)
> +			goto error;
> +

The port should be down at this point, otherwise the link state is not
matching phylink's idea of the state.  Your patch merely works around
that.  I think it needs solving properly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
