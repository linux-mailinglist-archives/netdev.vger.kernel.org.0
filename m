Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A061848B1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCMOBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:01:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60078 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMOBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ebofW7P9NSpXupWM6c+gZTgOsDoM48+wVkeltb0bhIs=; b=fQ7PD+60iZ5/eyMc+OUZU3lKf
        feSyRiIOA7uTL3RbpCIs+/fbfFc221rr+Izn1Eve4nvtS2Om/DLVORadykSRvdG3PDCDanWaFSThS
        lPVsQlMlwJNFg6UlANfjdd9As78frbcuSWZ6UQmZ8APPGLta+MT+tSCqQnC+Rc+g/tiC0yyaH5HPT
        5HivwFJ3rljFWXpVGEF9oYER2ii61kdzKsH5RYDQwU7vG1cbPxSrRDmkuAxtzX42E0FOIOZYjc1JR
        EhSSB4hlGtZ1yNHTZ8yq0Jy7KfQOntnb4RSEgEueJQy8xAh1SE4+dk6JgLcoUVCJ9c1bj1goyjnnh
        pLC79TSOQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60008)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jCksR-0000di-TN; Fri, 13 Mar 2020 14:01:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jCksM-0007NR-FD; Fri, 13 Mar 2020 14:01:22 +0000
Date:   Fri, 13 Mar 2020 14:01:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: phy: xpcs: Clear latched value of
 RX/TX fault
Message-ID: <20200313140122.GC25745@shell.armlinux.org.uk>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
 <50f3dd2ab58fecfea1156aaf8dbfa99d0c7b36be.1584106347.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50f3dd2ab58fecfea1156aaf8dbfa99d0c7b36be.1584106347.git.Jose.Abreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 02:39:40PM +0100, Jose Abreu wrote:
> When reading RX/TX fault register we may have latched values from Link
> down. Clear the latched value first and then read it again to make sure
> no old errors are flagged and that new errors are caught.

The purpose of the latched link down is so that software can respond
to a momentary loss of link with a possible change in the negotiation
results.  That is why IEEE 802.3 wants a link loss to be a latched
event.

Double-reading the status register loses that information, and hides
it from phylink.  A change in negotiation, which can occur very
quickly on fiber links) can go unnoticed if the latching is not
propagated up through phylink.

If the negotiation parameters have changed, and pcs_get_state() does
not report that the link has failed, then mac_link_up() will _not_ be
called with the new link parameters, and the MAC will continue using
the old ones.  Therefore, it is very important that any link-down
event is reported to phylink.

Phylink currently doesn't respond to a link-down event reported via
PCS by re-checking after processing the link loss, but it could do,
which would improve it's behaviour in that scenario.  I would prefer
this resolution, rather than your proposed double-reading of the
status register to "lose" the link-down event.

I do have some patches that make that easier, but they're delayed
behind the mass of patches that I still have outstanding - and trying
to get progress on getting phylink patches merged has been glacial,
and fraught with problems this time around.

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
>  drivers/net/phy/mdio-xpcs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
> index 973f588146f7..a4cbeecc6d42 100644
> --- a/drivers/net/phy/mdio-xpcs.c
> +++ b/drivers/net/phy/mdio-xpcs.c
> @@ -185,6 +185,7 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
>  		return -EFAULT;
>  	}
>  
> +	xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT2);
>  	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT2);
>  	if (ret < 0)
>  		return ret;
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
