Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12115139300
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAMOCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:02:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37039 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:02:42 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ir0Ig-000461-CS; Mon, 13 Jan 2020 15:02:38 +0100
Message-ID: <02f6d17a410114ea9b3bea6e9c43d3aa4bc2dffe.camel@pengutronix.de>
Subject: Re: [PATCH] mdio_bus: Simplify reset handling and extend to non-DT
 systems
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 13 Jan 2020 15:02:36 +0100
In-Reply-To: <20200113130529.15372-1-geert+renesas@glider.be>
References: <20200113130529.15372-1-geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-01-13 at 14:05 +0100, Geert Uytterhoeven wrote:
> Convert mdiobus_register_reset() from open-coded DT-only optional reset
> handling to reset_control_get_optional_exclusive().  This not only
> simplifies the code, but also adds support for lookup-based resets on
> non-DT systems.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Only tested on systems without PHY resets, with and without
> CONFIG_RESET_CONTROLLER=y.
> 
>  drivers/net/phy/mdio_bus.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 229e480179ff1de4..8d753bb07227e561 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -59,17 +59,11 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
>  
>  static int mdiobus_register_reset(struct mdio_device *mdiodev)
>  {
> -	struct reset_control *reset = NULL;
> -
> -	if (mdiodev->dev.of_node)
> -		reset = of_reset_control_get_exclusive(mdiodev->dev.of_node,
> -						       "phy");
> -	if (IS_ERR(reset)) {
> -		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
> -			reset = NULL;
> -		else
> -			return PTR_ERR(reset);
> -	}
> +	struct reset_control *reset;
> +
> +	reset = reset_control_get_optional_exclusive(&mdiodev->dev, "phy");
> +	if (IS_ERR(reset))
> +		return PTR_ERR(reset);

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

