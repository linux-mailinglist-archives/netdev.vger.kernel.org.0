Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9582044CB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgFVXxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730227AbgFVXxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:53:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E8C061573;
        Mon, 22 Jun 2020 16:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mz/A+hFfuf24LVGItLsLfUEgCItsEK6JiOXYHwMwFLQ=; b=VnLhWmtjHgbFCQ6Yr0nSQfHPy
        TSbERVRaAM8pnpmgV7XlFpnLWt/E9Qq6dXeNOkp0zXJab0YenjSNZRFGanOc8RglhvdxAnuxVQGNo
        /kWpdFWWPkSj+XWD7JaIIwK171gc5VYUH8VKQtkXJ6grVq457ol0PvS4xfcukZ/5xb6ycFitF2AFo
        IFBq2Ntw0w+RJ1njeQSRCrl44goxjpO5KrGxaKgJPDmBwjgq17mAm40qqtetacSOSfTqEMPg8yFJg
        a0i3VbQvStMgEnKcJfyjwzNdhkHQznIQgtmQNRNZ5FIQcOnLAK2Veb0uhu6HikuPCSjPzpLXE8fhD
        JqtWS9cjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58994)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnWG3-00013A-4g; Tue, 23 Jun 2020 00:53:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnWFw-0000UE-KX; Tue, 23 Jun 2020 00:53:40 +0100
Date:   Tue, 23 Jun 2020 00:53:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] net: ethernet: mvneta: Fix Serdes configuration for
 SoCs without comphy
Message-ID: <20200622235340.GQ1551@shell.armlinux.org.uk>
References: <20200616083140.8498-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616083140.8498-1-s.hauer@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 10:31:39AM +0200, Sascha Hauer wrote:
> The MVNETA_SERDES_CFG register is only available on older SoCs like the
> Armada XP. On newer SoCs like the Armada 38x the fields are moved to
> comphy. This patch moves the writes to this register next to the comphy
> initialization, so that depending on the SoC either comphy or
> MVNETA_SERDES_CFG is configured.
> With this we no longer write to the MVNETA_SERDES_CFG on SoCs where it
> doesn't exist.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 80 +++++++++++++++------------
>  1 file changed, 44 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 51889770958d8..9933eb4577d43 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -106,6 +106,7 @@
>  #define      MVNETA_TX_IN_PRGRS                  BIT(1)
>  #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
>  #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
> +/* Only exists on Armada XP and Armada 370 */
>  #define MVNETA_SERDES_CFG			 0x24A0
>  #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
>  #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
> @@ -3514,26 +3515,55 @@ static int mvneta_setup_txqs(struct mvneta_port *pp)
>  	return 0;
>  }
>  
> -static int mvneta_comphy_init(struct mvneta_port *pp)
> +static int mvneta_comphy_init(struct mvneta_port *pp, phy_interface_t interface)
>  {
>  	int ret;
>  
> -	if (!pp->comphy)
> -		return 0;
> -
> -	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
> -			       pp->phy_interface);
> +	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET, interface);
>  	if (ret)
>  		return ret;
>  
>  	return phy_power_on(pp->comphy);
>  }
>  
> +static int mvneta_config_interface(struct mvneta_port *pp,
> +				   phy_interface_t interface)
> +{
> +	int ret = 0;
> +
> +	if (pp->comphy) {
> +		if (interface == PHY_INTERFACE_MODE_SGMII ||
> +		    interface == PHY_INTERFACE_MODE_1000BASEX ||
> +		    interface == PHY_INTERFACE_MODE_2500BASEX) {
> +			ret = mvneta_comphy_init(pp, interface);
> +		}
> +	} else {
> +		switch (interface) {
> +		case PHY_INTERFACE_MODE_QSGMII:
> +			mvreg_write(pp, MVNETA_SERDES_CFG,
> +				    MVNETA_QSGMII_SERDES_PROTO);
> +			break;
> +
> +		case PHY_INTERFACE_MODE_SGMII:
> +		case PHY_INTERFACE_MODE_1000BASEX:
> +			mvreg_write(pp, MVNETA_SERDES_CFG,
> +				    MVNETA_SGMII_SERDES_PROTO);
> +			break;
> +		default:
> +			return -EINVAL;

I've just noticed that you made changes to the patch I sent, such as
adding this default case that errors out, and by doing so, you have
caused a regression by causing a WARN_ON() splat.

It was not accidental that my patch had "break;" here instead of an
error return, and I left the interface mode checking in
mvneta_port_power_up() that you also removed.

mvneta supports RGMII, and since RGMII doesn't use the serdes, there
is no need to write to MVNETA_SGMII_SERDES_PROTO, and so we want to
ignore those, not return -EINVAL.

Since the interface type was already validated both by phylink when
the interface is brought up, and also by the driver at probe time
through mvneta_port_power_up(), which performs early validation of
the mode given in DT this was not a problem... there is no need to
consider anything but the RGMII case in the "default" case here.

So, please fix this... at minimum fixing this switch() statement not
to error out in the RGMII cases.  However, I think actually following
what was in my patch (which was there for good reason) rather than
randomly changing it would have been better.

This will have made the kernel on the SolidRun Clearfog platform
trigger the WARN_ON()s for the dedicated gigabit port, which uses
RGMII, and doesn't have a comphy specified in DT... and having
waited for the compile to finish and the resulting kernel to boot...

WARNING: CPU: 0 PID: 268 at drivers/net/ethernet/marvell/mvneta.c:3512 mvneta_start_dev+0x220/0x23c

Thanks.

> +		}
> +	}
> +
> +	pp->phy_interface = interface;
> +
> +	return ret;
> +}
> +
>  static void mvneta_start_dev(struct mvneta_port *pp)
>  {
>  	int cpu;
>  
> -	WARN_ON(mvneta_comphy_init(pp));
> +	WARN_ON(mvneta_config_interface(pp, pp->phy_interface));
>  
>  	mvneta_max_rx_size_set(pp, pp->pkt_size);
>  	mvneta_txq_max_tx_size_set(pp, pp->pkt_size);
> @@ -3907,14 +3937,10 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
>  	if (state->speed == SPEED_2500)
>  		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
>  
> -	if (pp->comphy && pp->phy_interface != state->interface &&
> -	    (state->interface == PHY_INTERFACE_MODE_SGMII ||
> -	     state->interface == PHY_INTERFACE_MODE_1000BASEX ||
> -	     state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
> -		pp->phy_interface = state->interface;
> -
> -		WARN_ON(phy_power_off(pp->comphy));
> -		WARN_ON(mvneta_comphy_init(pp));
> +	if (pp->phy_interface != state->interface) {
> +		if (pp->comphy)
> +			WARN_ON(phy_power_off(pp->comphy));
> +		WARN_ON(mvneta_config_interface(pp, state->interface));
>  	}
>  
>  	if (new_ctrl0 != gmac_ctrl0)
> @@ -4958,20 +4984,10 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
>  }
>  
>  /* Power up the port */
> -static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
> +static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
>  {
>  	/* MAC Cause register should be cleared */
>  	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
> -
> -	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
> -		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_QSGMII_SERDES_PROTO);
> -	else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
> -		 phy_interface_mode_is_8023z(phy_mode))
> -		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
> -	else if (!phy_interface_mode_is_rgmii(phy_mode))
> -		return -EINVAL;
> -
> -	return 0;
>  }
>  
>  /* Device initialization routine */
> @@ -5157,11 +5173,7 @@ static int mvneta_probe(struct platform_device *pdev)
>  	if (err < 0)
>  		goto err_netdev;
>  
> -	err = mvneta_port_power_up(pp, phy_mode);
> -	if (err < 0) {
> -		dev_err(&pdev->dev, "can't power up port\n");
> -		goto err_netdev;
> -	}
> +	mvneta_port_power_up(pp, phy_mode);
>  
>  	/* Armada3700 network controller does not support per-cpu
>  	 * operation, so only single NAPI should be initialized.
> @@ -5315,11 +5327,7 @@ static int mvneta_resume(struct device *device)
>  		}
>  	}
>  	mvneta_defaults_set(pp);
> -	err = mvneta_port_power_up(pp, pp->phy_interface);
> -	if (err < 0) {
> -		dev_err(device, "can't power up port\n");
> -		return err;
> -	}
> +	mvneta_port_power_up(pp, pp->phy_interface);
>  
>  	netif_device_attach(dev);
>  
> -- 
> 2.27.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
