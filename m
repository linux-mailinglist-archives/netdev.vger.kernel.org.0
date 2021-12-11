Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4D47142F
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhLKOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLKOQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 09:16:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEF6C061714;
        Sat, 11 Dec 2021 06:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e0anjkaxdNpVxEb5moHXvrH7yl2NTFZ61IqrH8qKTDY=; b=Mh8xcA7DyDvxNmeiQA+l94WXGf
        vCspSXYiunAGFM72nem7R64bjx28jVCw8FQ22HarPTPBKZoCLxYztfeTTOCEPS7qbl3KRKOGly0GM
        s/DZK9emVxtwRJOgQc+YzCmV0cQeGrFcJL94vIjzIL9v3eIMeOrCfxSQceHkc9Wzg3tV3cLaTz+6/
        1v1qNLr1PzgnZHElMHBgZLhdGI73xP6jUd/Q3CGkJXp3ShPHJ8pHq57HRiSGXAvmb61gTHZ1/Tcky
        WG7MaNIJjut0T7EAyjXJwjq8v3K5p0VQ+L5lFiJTYdHJfYb/Epd+9Q+wPwNAmL/C6b3VMPz49Oknh
        nASWleHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mw3AK-00025G-Of; Sat, 11 Dec 2021 14:15:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mw3AI-0000kg-2f; Sat, 11 Dec 2021 14:15:54 +0000
Date:   Sat, 11 Dec 2021 14:15:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     philippe.schenker@toradex.com, andrew@lunn.ch,
        qiangqing.zhang@nxp.com, davem@davemloft.net, festevam@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: perform a PHY reset on resume
Message-ID: <YbSymkxlslW2DqLW@shell.armlinux.org.uk>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
 <20211211130146.357794-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211130146.357794-1-francesco.dolcini@toradex.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 02:01:46PM +0100, Francesco Dolcini wrote:
> Perform a PHY reset in phy_init_hw() to ensure that the PHY is working
> after resume. This is required if the PHY was powered down in suspend
> like it is done by the freescale FEC driver in fec_suspend().
> 
> Link: https://lore.kernel.org/netdev/20211206101326.1022527-1-philippe.schenker@toradex.com/
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> ---
> 
> Philippe: what about something like that? Only compile tested, but I see no reason for this not solving the issue.
> 
> Any delay required on the reset can be specified using reset-assert-us/reset-deassert-us.
> 
> ---
>  drivers/net/phy/phy_device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 74d8e1dc125f..7eab0c054adf 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1158,7 +1158,8 @@ int phy_init_hw(struct phy_device *phydev)
>  {
>  	int ret = 0;
>  
> -	/* Deassert the reset signal */
> +	/* phy reset required if the phy was powered down during suspend */
> +	phy_device_reset(phydev, 1);
>  	phy_device_reset(phydev, 0);
>  
>  	if (!phydev->drv)

I don't particularly like this - this impacts everyone who is using
phylib at this point, whereas no reset was happening if the reset was
already deasserted here.

In the opening remarks to this series, it is stated:

  If a hardware-design is able to control power to the Ethernet PHY and
  relying on software to do a reset, the PHY does no longer work after
  resuming from suspend, given the PHY does need a hardware-reset.

This requirement is conditional on the hardware design, it isn't a
universal requirement and won't apply everywhere. I think it needs to
be described in firmware that this action is required. That said...

Please check the datasheet on the PHY regarding application of power and
reset. You may find that the PHY datasheet requires the reset to be held
active from power up until the clock input is stable - this could mean
you need some other arrangement to assert the PHY reset signal after
re-applying power sooner than would happen by the proposed point in the
kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
