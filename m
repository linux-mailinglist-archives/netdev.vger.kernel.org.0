Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657A92701A9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIRQKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:10:39 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:35920 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRQKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:10:39 -0400
Received: from relay3-d.mail.gandi.net (unknown [217.70.183.195])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 737A03A49B1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:28:49 +0000 (UTC)
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 19E446000D;
        Fri, 18 Sep 2020 15:28:26 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:28:26 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 5/8] net: mscc: ocelot: error checking when
 calling ocelot_init()
Message-ID: <20200918152826.GB9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-6-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:27+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_init() allocates memory, resets the switch and polls for a status
> register, things which can fail. Stop probing the driver in that case,
> and propagate the error result.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> Stopped leaking the 'ports' OF node in the VSC7514 driver.
> 
>  drivers/net/dsa/ocelot/felix.c             | 5 ++++-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index a1e1d3824110..f7b43f8d56ed 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -571,7 +571,10 @@ static int felix_setup(struct dsa_switch *ds)
>  	if (err)
>  		return err;
>  
> -	ocelot_init(ocelot);
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		return err;
> +
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>  		if (err) {
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 904ea299a5e8..a1cbb20a7757 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1002,7 +1002,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
>  	ocelot->vcap = vsc7514_vcap_props;
>  
> -	ocelot_init(ocelot);
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		goto out_put_ports;
> +
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>  		if (err) {
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
