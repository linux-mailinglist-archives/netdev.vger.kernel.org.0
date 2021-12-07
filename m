Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF31846B5FE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhLGIfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:35:18 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54554 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhLGIfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:35:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CF73CE19FC;
        Tue,  7 Dec 2021 08:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4EDC341C6;
        Tue,  7 Dec 2021 08:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638865905;
        bh=YfOtKyD69TramgjXySsx9hhx8lOTg8lAmitFgGQkBQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t55SelTCavDp3Abbm7ZZeyYT4jWUhqDnyMNJsXMiGevG6OaUERDgXj7ia/W4u+s8V
         32BpKfdk4P/VfYSNP7LmTp1su1YVM3ns+GTTUR3rpKp14O9Yf+exhwhpw0madDKP03
         JNPv3X/021CVdOH9pRwmRSRvm3G97yCK0yw5ZB4KtUd+Z0pU6vS//+QwUvPFCTtG4R
         2Y8W1CvIw03MsVCWov/RxczSdUpi9hPdOrRufOKaVLQH5zoonbAhlPu6SAVNt7JU0a
         Tu/tgOOVX2bLg6hsU0e1puWurrwpyALqCfSlJk2FdVCTpM7GbZA33etlmzN7lAvh17
         7i+srqRTfysTQ==
Date:   Tue, 7 Dec 2021 10:31:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        h.assmann@pengutronix.de
Subject: Re: [PATCH v2] net: stmmac: Fix possible division by zero
Message-ID: <Ya8b7eZfZlzrFTyJ@unreal>
References: <20211203173708.7fdbed06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211206142337.28602-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206142337.28602-1-amhamza.mgc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 07:23:37PM +0500, Ameer Hamza wrote:
> In stmmac_init_tstamp_counter() routine, there is a possiblity of division
> by zero. If priv->plat->clk_ptp_rate becomes greater than 1 GHz,
> config_sub_second_increment() subroutine may calculate sec_inc as zero
> depending upon the PTP_TCR_TSCFUPDT register value, which will cause
> divide by zero exception.
> 
> Fixes: a6da2bbb0005e ("net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls")
> Addresses-Coverity: 1494557 ("Division or modulo by zero")
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> 
> ---
> Changes in v2:
> Added fix tag, bug justification, and commit author.
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index da8306f60730..f44400323407 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -863,7 +863,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
>  	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
>  					   priv->plat->clk_ptp_rate,
>  					   xmac, &sec_inc);
> -	temp = div_u64(1000000000ULL, sec_inc);
> +	temp = div_u64(1000000000ULL, (sec_inc > 0) ? sec_inc : 1);

It can be written cleanly with max(a,b):

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4e05c1d92935..e2e232bff511 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -855,7 +855,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
        stmmac_config_sub_second_increment(priv, priv->ptpaddr,
                                           priv->plat->clk_ptp_rate,
                                           xmac, &sec_inc);
-       temp = div_u64(1000000000ULL, sec_inc);
+       temp = div_u64(1000000000ULL, max(sec_inc, 1));
 
        /* Store sub second increment for later use */
        priv->sub_second_inc = sec_inc;

>  
>  	/* Store sub second increment for later use */
>  	priv->sub_second_inc = sec_inc;
> -- 
> 2.25.1
> 
