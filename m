Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE956D4442
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjDCMUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCMUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:20:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FA8E393
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=94t84zLLN+8OLEV3aJjRwLaDsQymu//KgzF4penJZjg=; b=JjWU0OJuup1lr2CbDNdGrIqQVd
        HuzIQrDBZVIqvm0OKNOxhq2x6wrebvuX0D17BWhKLwB5nVMjsozM1VLAtJbQd/wQZQOElkNRk0KDJ
        TWj38PIbheyFG1dMmxAAV0RDIr1MjRDarB3ycTH8EImMy5SD76fwA0SAYT6CnlVluHy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjJAq-009HL6-B0; Mon, 03 Apr 2023 14:20:36 +0200
Date:   Mon, 3 Apr 2023 14:20:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: net: fec: Separate C22 and C45 transactions
Message-ID: <c020e318-350c-4688-9851-0474993261ff@lunn.ch>
References: <6a1f2f8b-003e-38f3-bd7f-75eeb0520740@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a1f2f8b-003e-38f3-bd7f-75eeb0520740@linux-m68k.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:41:46PM +1000, Greg Ungerer wrote:
> Hi Andrew,
> 
> On Mon, Jan 9, at 16:30 Andrew Lunn wrote:
> > net: fec: Separate C22 and C45 transactions
> > The fec MDIO bus driver can perform both C22 and C45 transfers.
> > Create separate functions for each and register the C45 versions using
> > the new API calls where appropriate.
> 
> Are you sure that all FEC hardware blocks MDIO bus units support C45
> transactions?

Hi Greg

My aim was to keep the existing behaviour. The old code did not have
variant specific limitations to C45, so neither does the new. Meaning,
the driver might of been broken before and it is still broken now. It
is however more likely that broken behaviour is now invoked while
scanning the bus for devices.

> From c4a2c5faf08593d0a3e14fefe996218df11d2c01 Mon Sep 17 00:00:00 2001
> From: Greg Ungerer <gerg@linux-m68k.org>
> Date: Mon, 3 Apr 2023 13:36:27 +1000
> Subject: [PATCH] net: fec: make use of MDIO C45 a quirk
> 
> Not all fec MDIO bus drivers support C45 mode. The older fec hardware
> block in many ColdFire SoCs do not appear to support this, at least
> according to most of the different ColdFire SoC reference manuals.
> The bits used to generate C45 access on the iMX parts, in the OP field
> of the MMFR register, are documented as generating non-compliant MII
> frames (it is not documented as to exactly how they are non-compliant).
> 
> Commit 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
> means the fec driver will always register c45 MDIO read and write
> methods. During probe these will always be accessed generating
> non-complant MII accesses on ColdFire based devices.
> 
> Add a quirk define, FEC_QUIRK_HAS_MDIO_C45, that can be used to
> distinguish silicon that supports MDIO C45 framing or not. Add this to
> all the existing iMX quirks, so they will be behave as they do now (*).
> 
> (*) it seems that some iMX parts may not support C45 framing either.
>     The iMX25 and iMX50 Reference Manuals contains similar wording to
>     the ColdFire Reference Manuals on this.
> 
> Fixes: 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  5 ++++
>  drivers/net/ethernet/freescale/fec_main.c | 32 ++++++++++++++---------
>  2 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 5ba1e0d71c68..9939ccafb556 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -507,6 +507,11 @@ struct bufdesc_ex {
>  /* i.MX6Q adds pm_qos support */
>  #define FEC_QUIRK_HAS_PMQOS			BIT(23)
>  
> +/* Not all FEC hardware block MDIOs support accesses in C45 mode.
> + * Older blocks in the ColdFire parts do not support it.
> + */
> +#define FEC_QUIRK_HAS_MDIO_C45		BIT(24)
> +
>  struct bufdesc_prop {
>  	int qid;
>  	/* Address of Rx and Tx buffers */
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index f3b16a6673e2..160c1b3525f5 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -100,18 +100,19 @@ struct fec_devinfo {
>  
>  static const struct fec_devinfo fec_imx25_info = {
>  	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
> -		  FEC_QUIRK_HAS_FRREG,
> +		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx27_info = {
> -	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
> +	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx28_info = {
>  	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
>  		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
>  		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII |
> -		  FEC_QUIRK_NO_HARD_RESET,
> +		  FEC_QUIRK_NO_HARD_RESET | FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx6q_info = {
> @@ -119,11 +120,12 @@ static const struct fec_devinfo fec_imx6q_info = {
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
>  		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII |
> -		  FEC_QUIRK_HAS_PMQOS,
> +		  FEC_QUIRK_HAS_PMQOS | FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_mvf600_info = {
> -	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
> +	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx6x_info = {
> @@ -132,7 +134,8 @@ static const struct fec_devinfo fec_imx6x_info = {
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
>  		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>  		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
> -		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
> +		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx6ul_info = {
> @@ -140,7 +143,8 @@ static const struct fec_devinfo fec_imx6ul_info = {
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
>  		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
> -		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
> +		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx8mq_info = {
> @@ -150,7 +154,8 @@ static const struct fec_devinfo fec_imx8mq_info = {
>  		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>  		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
>  		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
> -		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2,
> +		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2 |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_imx8qm_info = {
> @@ -160,14 +165,15 @@ static const struct fec_devinfo fec_imx8qm_info = {
>  		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>  		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
>  		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
> -		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
> +		  FEC_QUIRK_DELAYED_CLKS_SUPPORT | FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static const struct fec_devinfo fec_s32v234_info = {
>  	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
> -		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE,
> +		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
> +		  FEC_QUIRK_HAS_MDIO_C45,
>  };
>  
>  static struct platform_device_id fec_devtype[] = {
> @@ -2434,8 +2440,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	fep->mii_bus->name = "fec_enet_mii_bus";
>  	fep->mii_bus->read = fec_enet_mdio_read_c22;
>  	fep->mii_bus->write = fec_enet_mdio_write_c22;
> -	fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
> -	fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
> +	if (fep->quirks & FEC_QUIRK_HAS_MDIO_C45) {
> +		fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
> +		fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
> +	}
>  	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
>  		pdev->name, fep->dev_id + 1);
>  	fep->mii_bus->priv = fep;
> -- 
> 2.25.1
> 

This patch looks reasonable. Please formally submit it.

     Andrew
