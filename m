Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377E115FFC7
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 19:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOStj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 13:49:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOStj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 13:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qScxe2MpGrfgcjlXIdk3h7jYPlni2oy8/z2manLMPRM=; b=XUaaZYduMmgedauYbwgwoS6Dd8
        E9A6vUY8B6hrkLLqI1S7biw158+9FrsMjBnfcK122IGU1ZbsLe337mxsAbexuURQ34Dd8h3CQXddR
        whW4XyBEX7k8qcxCaennZlmEcJ2mqDN3jqXI8KApCIxpaSvo9O5F4N5qyXpZL0gLJKzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32VQ-00058z-VG; Sat, 15 Feb 2020 19:49:32 +0100
Date:   Sat, 15 Feb 2020 19:49:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/10] net: add helpers to resolve negotiated
 flow control
Message-ID: <20200215184932.GS31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zh9-0003X2-9y@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zh9-0003X2-9y@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:49:27PM +0000, Russell King wrote:
> Add a couple of helpers to resolve negotiated flow control. Two helpers
> are provided:
> 
> - linkmode_resolve_pause() which takes the link partner and local
>   advertisements, and decodes whether we should enable TX or RX pause
>   at the MAC. This is useful outside of phylib, e.g. in phylink.
> - phy_get_pause(), which returns the TX/RX enablement status for the
>   current negotiation results of the PHY.
> 
> This allows us to centralise the flow control resolution, rather than
> spreading it around.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/Makefile     |  3 ++-
>  drivers/net/phy/linkmode.c   | 44 ++++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 26 +++++++++++++++++++++
>  include/linux/linkmode.h     |  4 ++++
>  include/linux/phy.h          |  3 +++
>  5 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/phy/linkmode.c
> 
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index fe5badf13b65..d523fd5670e4 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -1,7 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for Linux PHY drivers and MDIO bus drivers
>  
> -libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o
> +libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
> +				   linkmode.o
>  mdio-bus-y			+= mdio_bus.o mdio_device.o
>  
>  ifdef CONFIG_MDIO_DEVICE
> diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
> new file mode 100644
> index 000000000000..969918795228
> --- /dev/null
> +++ b/drivers/net/phy/linkmode.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#include <linux/linkmode.h>
> +
> +/**
> + * linkmode_resolve_pause - resolve the allowable pause modes
> + * @local_adv: local advertisement in ethtool format
> + * @partner_adv: partner advertisement in ethtool format
> + * @tx_pause: pointer to bool to indicate whether transmit pause should be
> + * enabled.
> + * @rx_pause: pointer to bool to indicate whether receive pause should be
> + * enabled.
> + *
> + * Flow control is resolved according to our and the link partners
> + * advertisements using the following drawn from the 802.3 specs:
> + *  Local device  Link partner
> + *  Pause AsymDir Pause AsymDir Result
> + *    0     X       0     X     Disabled
> + *    0     1       1     0     Disabled
> + *    0     1       1     1     TX
> + *    1     0       0     X     Disabled
> + *    1     X       1     X     TX+RX
> + *    1     1       0     1     RX
> + */
> +void linkmode_resolve_pause(const unsigned long *local_adv,
> +			    const unsigned long *partner_adv,
> +			    bool *tx_pause, bool *rx_pause)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(m);
> +
> +	linkmode_and(m, local_adv, partner_adv);
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, m)) {
> +		*tx_pause = true;
> +		*rx_pause = true;
> +	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, m)) {
> +		*tx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +					      partner_adv);
> +		*rx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +					      local_adv);
> +	} else {
> +		*tx_pause = false;
> +		*rx_pause = false;
> +	}

Hi Russell

It took me a while to check this. Maybe it is the way my brain works,
but to me, it is not obviously correct. I had to expand the table, and
they try all 16 combinations.

Maybe a lookup table would be more obvious?

However, now i spent the time:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
