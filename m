Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4821848CA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCMOHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:07:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60168 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCMOHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I2rYj07tX855QAdcSOk0Rje4H8eVvnH6CuKQg93fcXA=; b=rvhd8ewsG0OOZPKTQ+geFM1nL
        nw6R7pwgzFvdh9nAi2ouV7wzwvQYWaAus5FPAWj+kOeCABusjRkVEoQq0DYlZPtFsHYT2xU6gtP4K
        0ngsMnMcb60GeFGCar1+wc02VEB1aNX8aQQrovzUXVmTAYW4h6DtiaxZ8NnMmiYB/tgj1WYCySpzF
        3ml+4iug9nEoQq5/BsaZ9nhm40ABY8/oLEhUsP0uHi3+/UDg6+OwNU/3O5RHQ0OmPSNNmBqP2X3VY
        S2C8Q1j2XNkcDqlRrDiCMCO3O6L2XJ+Oy6tu1PaWx7ENl01V3z0m41GbhlWaXNpgBeaLLloctKGn7
        cQud0B2VA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35918)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jCkyL-0000fn-2f; Fri, 13 Mar 2020 14:07:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jCkyJ-0007NZ-Hq; Fri, 13 Mar 2020 14:07:31 +0000
Date:   Fri, 13 Mar 2020 14:07:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: xpcs: Return error upon RX/TX
 fault
Message-ID: <20200313140731.GD25745@shell.armlinux.org.uk>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
 <7918fdf6bbe6505a64e54ae360c59c905aa3fe1d.1584106347.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7918fdf6bbe6505a64e54ae360c59c905aa3fe1d.1584106347.git.Jose.Abreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 02:39:41PM +0100, Jose Abreu wrote:
> RX/TX fault status results in link errors. Return error upon these cases
> so that XPCS can be correctly resumed.

Are you sure about this?  I'm sure that I read in IEEE 802.3 that
a loss of link results in a receive fault being indicated in
status register 2.

See 49.2.14.1 describing "PCS_status" and the descriptions of MDIO
registers 3.1.2 and 3.8.10.  Basically, the link status (3.1.2) is a
latched-low version of PCS_status, and 3.8.10 is an inverted version
of this, independently latched-high.

Returning -EFAULT seems to mean that we'll soft-reset the PHY, and
reconfigure it every time we attempt to read the status whenever the
link is down.

> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> ---
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/phy/mdio-xpcs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
> index a4cbeecc6d42..23516397b982 100644
> --- a/drivers/net/phy/mdio-xpcs.c
> +++ b/drivers/net/phy/mdio-xpcs.c
> @@ -190,10 +190,14 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
>  	if (ret < 0)
>  		return ret;
>  
> -	if (ret & MDIO_STAT2_RXFAULT)
> +	if (ret & MDIO_STAT2_RXFAULT) {
>  		xpcs_warn(xpcs, state, "Receiver fault detected!\n");
> -	if (ret & MDIO_STAT2_TXFAULT)
> +		return -EFAULT;
> +	}
> +	if (ret & MDIO_STAT2_TXFAULT) {
>  		xpcs_warn(xpcs, state, "Transmitter fault detected!\n");
> +		return -EFAULT;
> +	}
>  
>  	ret = xpcs_read_vendor(xpcs, MDIO_MMD_PCS, DW_VR_XS_PCS_DIG_STS);
>  	if (ret < 0)
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
