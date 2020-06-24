Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8F20707B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbgFXJzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389015AbgFXJzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:55:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA03C061573;
        Wed, 24 Jun 2020 02:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=88KQOG6XVKFLe8l1a2buG0sRs1RMztmoAEts+TmmAY8=; b=VUwwGOA34gLYHkj8Ep97sKRx5
        66CPiBQM5QJ8C85ptkaCtf5AwRJrasE+JPHnJCdWNYki/y0yaPL1PGKnWUqKg96vdEREKf/Iyz25h
        X4Z77rgwDNYt9GXPd/aDtDLHiPnj11bmPVNZz6Qn7uVtKwEOhlGNRBeUlMnvnkqL2SqaBtLIvKJvw
        2Mvo0ZwdUYP+wCLlSXR8HQPWafjgmeLEO39NCoSM1gEXwtYOkFzEf7jDYXFaEFegTUFDJv42CUzuT
        D6XD/VBNTBOtT1C2vEAfZ1BXdaPm5Bm7TuMvCVxOI9h0RLfaBGYixNRA0/oSRCqBYBHKeCTiWD1ZE
        tIobfFXwg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59054)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo27T-0002q1-1V; Wed, 24 Jun 2020 10:55:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo27S-0001qe-QR; Wed, 24 Jun 2020 10:55:02 +0100
Date:   Wed, 24 Jun 2020 10:55:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] net: ethernet: mvneta: Add back interface mode
 validation
Message-ID: <20200624095502.GZ1551@shell.armlinux.org.uk>
References: <20200624070045.8878-1-s.hauer@pengutronix.de>
 <20200624070045.8878-2-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624070045.8878-2-s.hauer@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 09:00:45AM +0200, Sascha Hauer wrote:
> When writing the serdes configuration register was moved to
> mvneta_config_interface() the whole code block was removed from
> mvneta_port_power_up() in the assumption that its only purpose was to
> write the serdes configuration register. As mentioned by Russell King
> its purpose was also to check for valid interface modes early so that
> later in the driver we do not have to care for unexpected interface
> modes.
> Add back the test to let the driver bail out early on unhandled
> interface modes.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Fixes: b4748553f53f ("net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy")
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index c4552f868157c..c639e3a293024 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -5009,10 +5009,18 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
>  }
>  
>  /* Power up the port */
> -static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
> +static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
>  {
>  	/* MAC Cause register should be cleared */
>  	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
> +
> +	if (phy_mode != PHY_INTERFACE_MODE_QSGMII &&
> +	    phy_mode != PHY_INTERFACE_MODE_SGMII &&
> +	    !phy_interface_mode_is_8023z(phy_mode) &&
> +	    !phy_interface_mode_is_rgmii(phy_mode))
> +		return -EINVAL;
> +
> +	return 0;
>  }
>  
>  /* Device initialization routine */
> @@ -5198,7 +5206,11 @@ static int mvneta_probe(struct platform_device *pdev)
>  	if (err < 0)
>  		goto err_netdev;
>  
> -	mvneta_port_power_up(pp, phy_mode);
> +	err = mvneta_port_power_up(pp, pp->phy_interface);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "can't power up port\n");
> +		return err;
> +	}
>  
>  	/* Armada3700 network controller does not support per-cpu
>  	 * operation, so only single NAPI should be initialized.
> @@ -5352,7 +5364,11 @@ static int mvneta_resume(struct device *device)
>  		}
>  	}
>  	mvneta_defaults_set(pp);
> -	mvneta_port_power_up(pp, pp->phy_interface);
> +	err = mvneta_port_power_up(pp, pp->phy_interface);
> +	if (err < 0) {
> +		dev_err(device, "can't power up port\n");
> +		return err;
> +	}
>  
>  	netif_device_attach(dev);
>  
> -- 
> 2.27.0

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
