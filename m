Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10012344D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfLQSE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:04:27 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49765 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfLQSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 13:04:27 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8DA8560005;
        Tue, 17 Dec 2019 18:04:24 +0000 (UTC)
Date:   Tue, 17 Dec 2019 19:04:23 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        maxime.chevallier@bootlin.com, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: cycle comphy to power it down
Message-ID: <20191217180423.GI3160@kwain>
References: <E1ihF4S-0000gt-1B@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1ihF4S-0000gt-1B@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Dec 17, 2019 at 03:47:36PM +0000, Russell King wrote:
> Presently, at boot time, the comphys are enabled. For firmware
> compatibility reasons, the comphy driver does not power down the
> comphys at boot. Consequently, the ethernet comphys are left active
> until the network interfaces are brought through an up/down cycle.
> 
> If the port is never used, the port wastes power needlessly. Arrange
> for the ethernet comphys to be cycled by the mvpp2 driver as if the
> interface went through an up/down cycle during driver probe, thereby
> powering them down.
> 
> This saves:
>   270mW per 10G SFP+ port on the Macchiatobin Single Shot (eth0/eth1)
>   370mW per 10G PHY port on the Macchiatobin Double Shot (eth0/eth1)
>   160mW on the SFP port on either Macchiatobin flavour (eth3)
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index c17b6cafef07..88a475606f19 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5546,6 +5546,16 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  		port->phylink = NULL;
>  	}
>  
> +	/* Cycle the comphy to power it down, saving 270mW per port -
> +	 * don't worry about an error powering it up. When the comphy
> +	 * driver does this, we can remove this code.
> +	 */
> +	if (port->comphy) {
> +		err = mvpp22_comphy_init(port);
> +		if (err == 0)
> +			phy_power_off(port->comphy);
> +	}
> +
>  	err = register_netdev(dev);
>  	if (err < 0) {
>  		dev_err(&pdev->dev, "failed to register netdev\n");
> -- 
> 2.20.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
