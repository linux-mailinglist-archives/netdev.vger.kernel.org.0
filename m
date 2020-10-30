Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514412A038F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgJ3LBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:01:42 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:34798 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3LBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:01:42 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 07:01:40 EDT
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 87B3BC72B2F;
        Fri, 30 Oct 2020 11:53:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1604055185;
        bh=yh3sT3WW1+O648yQ/GFFsxCXuADwo5maBS6L9gk0uqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UMGM+5F1KnHk++YN5WiqyGXtgaVR53MJzSqm1BWYLrkMElHu+HAGLj6M5CYFPMo+r
         +mpLHP7hjSfa/20FPuzevztNDhCn2yBqazFMy+kxiYdlTjESSKzyGUZ0h9u3c7BV7e
         xpxJpD3uEf7NUhpGt8dMwIXw+R2panUm3XvmOPoM=
Date:   Fri, 30 Oct 2020 11:53:04 +0100
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, fugang.duan@nxp.com,
        cphealy@gmail.com, dkarr@vyex.com
Subject: Re: [PATCH v2] net: fec: fix MDIO probing for some FEC hardware
 blocks
Message-ID: <20201030105304.GA37786@workstation.tuxnet>
References: <20201028052232.1315167-1-gerg@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028052232.1315167-1-gerg@linux-m68k.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 03:22:32PM +1000, Greg Ungerer wrote:
> Some (apparently older) versions of the FEC hardware block do not like
> the MMFR register being cleared to avoid generation of MII events at
> initialization time. The action of clearing this register results in no
> future MII events being generated at all on the problem block. This means
> the probing of the MDIO bus will find no PHYs.
> 
> Create a quirk that can be checked at the FECs MII init time so that
> the right thing is done. The quirk is set as appropriate for the FEC
> hardware blocks that are known to need this.
> 
> Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  6 +++++
>  drivers/net/ethernet/freescale/fec_main.c | 29 +++++++++++++----------
>  2 files changed, 22 insertions(+), 13 deletions(-)
> 
> v2: use quirk for imx28 as well
> 
> Resending for consideration based on Andy's last comment that this fix
> is enough on its own for all hardware types.
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 832a2175636d..c527f4ee1d3a 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -456,6 +456,12 @@ struct bufdesc_ex {
>   */
>  #define FEC_QUIRK_HAS_FRREG		(1 << 16)
>  
> +/* Some FEC hardware blocks need the MMFR cleared at setup time to avoid
> + * the generation of an MII event. This must be avoided in the older
> + * FEC blocks where it will stop MII events being generated.
> + */
> +#define FEC_QUIRK_CLEAR_SETUP_MII	(1 << 17)
> +
>  struct bufdesc_prop {
>  	int qid;
>  	/* Address of Rx and Tx buffers */
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index fb37816a74db..65784d3e54a5 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -100,14 +100,14 @@ static const struct fec_devinfo fec_imx27_info = {
>  static const struct fec_devinfo fec_imx28_info = {
>  	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
>  		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
> -		  FEC_QUIRK_HAS_FRREG,
> +		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>  
>  static const struct fec_devinfo fec_imx6q_info = {
>  	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
> -		  FEC_QUIRK_HAS_RACC,
> +		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>  
>  static const struct fec_devinfo fec_mvf600_info = {
> @@ -119,7 +119,8 @@ static const struct fec_devinfo fec_imx6x_info = {
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
>  		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
> -		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
> +		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
> +		  FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>  
>  static const struct fec_devinfo fec_imx6ul_info = {
> @@ -127,7 +128,7 @@ static const struct fec_devinfo fec_imx6ul_info = {
>  		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>  		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
>  		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
> -		  FEC_QUIRK_HAS_COALESCE,
> +		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>  
>  static struct platform_device_id fec_devtype[] = {
> @@ -2114,15 +2115,17 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	if (suppress_preamble)
>  		fep->phy_speed |= BIT(7);
>  
> -	/* Clear MMFR to avoid to generate MII event by writing MSCR.
> -	 * MII event generation condition:
> -	 * - writing MSCR:
> -	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> -	 *	  mscr_reg_data_in[7:0] != 0
> -	 * - writing MMFR:
> -	 *	- mscr[7:0]_not_zero
> -	 */
> -	writel(0, fep->hwp + FEC_MII_DATA);
> +	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
> +		/* Clear MMFR to avoid to generate MII event by writing MSCR.
> +		 * MII event generation condition:
> +		 * - writing MSCR:
> +		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> +		 *	  mscr_reg_data_in[7:0] != 0
> +		 * - writing MMFR:
> +		 *	- mscr[7:0]_not_zero
> +		 */
> +		writel(0, fep->hwp + FEC_MII_DATA);
> +	}
>  
>  	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>  
> -- 
> 2.25.1
> 

This fixes the problem on i.MX6Q!

Tested-by: Clemens Gruber <clemens.gruber@pqgruber.com>

Best regards,
Clemens
