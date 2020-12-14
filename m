Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601AA2DA3D0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441295AbgLNWzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:55:42 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46509 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439348AbgLNWzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:55:24 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 6DC6620006;
        Mon, 14 Dec 2020 22:54:38 +0000 (UTC)
Date:   Mon, 14 Dec 2020 23:54:38 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: Fix a resource leak in the error
 handling path of the probe function
Message-ID: <20201214225438.GY1781038@piout.net>
References: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2020 12:48:38+0100, Christophe JAILLET wrote:
> In case of error after calling 'ocelot_init()', it must be undone by a
> corresponding 'ocelot_deinit()' call, as already done in the remove
> function.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 1e7729421a82..9cf2bc5f4289 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1267,7 +1267,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	err = mscc_ocelot_init_ports(pdev, ports);
>  	if (err)
> -		goto out_put_ports;
> +		goto out_ocelot_deinit;
>  
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
> @@ -1282,8 +1282,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	register_switchdev_notifier(&ocelot_switchdev_nb);
>  	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
>  
> +	of_node_put(ports);
> +
>  	dev_info(&pdev->dev, "Ocelot switch probed\n");
>  
> +	return 0;
> +
> +out_ocelot_deinit:
> +	ocelot_deinit(ocelot);
>  out_put_ports:
>  	of_node_put(ports);
>  	return err;
> -- 
> 2.27.0
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
