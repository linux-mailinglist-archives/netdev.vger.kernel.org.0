Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D24458DD2D
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiHIR20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245356AbiHIR2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:28:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ED825589
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=y+1UCISKyQ7hLfnGHGM8w7hju83+xg62hbOA1JiH6MM=; b=dG
        wEdNvawZ37ljMbo1mkMLQTg2flr9X0jGAE9Cc//RR5ySC9biB02kkXsdt6b0DaLiAYH0KkVSFqGou
        roD5PcZMQZWjQpWaG0No7Y1lslIn/g5tViBNzAihEZALm5FquJgfe9l2sFsjg2Jx/ZA5k2gr1yG9X
        IT0wlrDr4cwo1jY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLT1h-00Crcr-1E; Tue, 09 Aug 2022 19:28:21 +0200
Date:   Tue, 9 Aug 2022 19:28:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvKZNcVfYdLw7bkm@lunn.ch>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220809124119.29922-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 02:41:19PM +0200, Csókás Bence wrote:
> On link state change, the controller gets reset,
> causing PPS to drop out. So we restart it if needed.
> 
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 27 ++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index ca5d49361fdf..c264b1dd5286 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -954,6 +954,7 @@ fec_restart(struct net_device *ndev)
>  	u32 temp_mac[2];
>  	u32 rcntl = OPT_FRAME_SIZE | 0x04;
>  	u32 ecntl = 0x2; /* ETHEREN */
> +	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };

Is it safe to hard code this? What if the user configured
PTP_CLK_REQ_EXTTS or PTP_CLK_REQ_PEROUT?

>  	/* Whack a reset.  We should wait for this.
>  	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
> @@ -1119,6 +1120,13 @@ fec_restart(struct net_device *ndev)
>  	if (fep->bufdesc_ex)
>  		fec_ptp_start_cyclecounter(ndev);
>  
> +	/* Restart PPS if needed */
> +	if (fep->pps_enable) {
> +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
> +		fep->pps_enable = 0;

If reset causes PPS to stop, maybe it would be better to do this
unconditionally?

	fep->pps_enable = 0;
	fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);

> +	if (fep->bufdesc_ex)
> +		ecntl |= (1 << 4);

Please replace (1 << 4) with a #define to make it clear what this is doing.

> +
>  	/* We have to keep ENET enabled to have MII interrupt stay working */
>  	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
>  		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
> -		writel(2, fep->hwp + FEC_ECNTRL);
> +		ecntl |= 0x2;
>  		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
>  	}
> +
> +	writel(ecntl, fep->hwp + FEC_ECNTRL);
> +
> +	if (fep->bufdesc_ex)
> +		fec_ptp_start_cyclecounter(ndev);
> +
> +	/* Restart PPS if needed */
> +	if (fep->pps_enable) {
> +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
> +		fep->pps_enable = 0;
> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
> +	}

So you re-start PPS in stop()? Should it keep outputting when the
interface is down?

Also, if it is always outputting, don't you need to stop it in
fec_drv_remove(). You probably don't want to still going after the
driver is unloaded.

       Andrew
