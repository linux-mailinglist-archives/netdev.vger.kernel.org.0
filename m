Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACD62B8971
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgKSBVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:21:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgKSBVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:21:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfYdG-007q29-67; Thu, 19 Nov 2020 02:21:06 +0100
Date:   Thu, 19 Nov 2020 02:21:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 10/11] net: dsa: microchip: ksz8795: dynamic allocate
 memory for flush_dyn_mac_table
Message-ID: <20201119012106.GN1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-11-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-11-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:56PM +0100, Michael Grzeschik wrote:
> To get the driver working with other chips using different port counts
> the dyn_mac_table should be flushed depending on the amount of physical
> ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---
> v1: - based on "[PATCH v4 05/11] net: dsa: microchip: ksz8795: dynamica allocate memory for flush_dyn_mac_table"
>     - lore: https://lore.kernel.org/netdev/20200803054442.20089-6-m.grzeschik@pengutronix.de/
> ---
>  drivers/net/dsa/microchip/ksz8795.c     | 8 ++++++--
>  drivers/net/dsa/microchip/ksz8795_reg.h | 2 --
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 9ea5ec61513023f..418f71e5b90761c 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -750,11 +750,14 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
>  
>  static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
>  {
> -	u8 learn[TOTAL_PORT_NUM];
>  	int first, index, cnt;
>  	struct ksz_port *p;
> +	u8 *learn = kzalloc(dev->port_cnt, GFP_KERNEL);

Using DSA_MAX_PORTS makes things simpler.

      Andrew
