Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC22443D9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392491AbfFMQc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:32:59 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44134 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbfFMIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J7X7uJi1JYKIwnbThJAOinat2g1jgpldkmszoNhWNj4=; b=loDuZPwJcezFEx/l0714xtWaG
        UIs7h8Qcm6dbuQdxI7pykqHnzqXpXpmhsHkLUVXAL74F2mHb9kT/wcD0dGBQsy7mVppqCj8tfJLd1
        CicHAjCh4B9r7V5rUGtBCmtwvtul68Yp5g1LGB2JdXxuK7kB0w6u1InM1yflO/mg7kFvm2meCmxyf
        Zs9jt+E+U4FBuySUm1p+tRYAy8aIraomB7ozBaScPiFRwKq0HhIElbDoXusLug3Bdjq+gHVLu0WoX
        NuzEQlqMw5RnuOz+vogCE7h619FO5F9mrnyfczJcgbsU52YgckktQ+LkwjJu0ADOVxmPBHYKUn1p3
        wTiqDOBcg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52994)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbKs0-0001db-3n; Thu, 13 Jun 2019 09:14:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbKrw-00014t-PI; Thu, 13 Jun 2019 09:14:00 +0100
Date:   Thu, 13 Jun 2019 09:14:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Message-ID: <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> The phy_state field of phylink should carry only valid information
> especially when this can be passed to the .mac_config callback.
> Update the an_enabled field with the autoneg state in the
> phylink_phy_change function.

an_enabled is meaningless to mac_config for PHY mode.  Why do you think
this is necessary?

> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5d0af041b8f9..dd1feb7b5472 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -688,6 +688,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
>  		pl->phy_state.pause |= MLO_PAUSE_ASYM;
>  	pl->phy_state.interface = phydev->interface;
>  	pl->phy_state.link = up;
> +	pl->phy_state.an_enabled = phydev->autoneg;
>  	mutex_unlock(&pl->state_mutex);
>  
>  	phylink_run_resolve(pl);
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
