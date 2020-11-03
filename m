Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B52A4B0A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgKCQUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:20:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgKCQUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:20:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZz2r-0053Ht-9O; Tue, 03 Nov 2020 17:20:29 +0100
Date:   Tue, 3 Nov 2020 17:20:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Shravya Kumbham <shravya.kumbham@xilinx.com>
Subject: Re: [PATCH net-next] net: emaclite: Add error handling for
 of_address_ and phy read functions
Message-ID: <20201103162029.GK1042051@lunn.ch>
References: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 07:01:05PM +0530, Radhey Shyam Pandey wrote:
> From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> 
> Add ret variable, conditions to check the return value and it's error
> path for of_address_to_resource() and phy_read() functions.
> 
> Addresses-Coverity: Event check_return value.

Hi Radhey

This is well out of scope of a Coverity fix, but looking at the patch
i noticed some bad things.

> @@ -923,7 +929,7 @@ static int xemaclite_open(struct net_device *dev)
>  	xemaclite_disable_interrupts(lp);
>  
>  	if (lp->phy_node) {
> -		u32 bmcr;
> +		int bmcr;
>  
>  		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
>  					     xemaclite_adjust_link, 0,
> @@ -945,6 +951,13 @@ static int xemaclite_open(struct net_device *dev)
>  
>  		/* Restart auto negotiation */
>  		bmcr = phy_read(lp->phy_dev, MII_BMCR);
> +		if (bmcr < 0) {
> +			dev_err(&lp->ndev->dev, "phy_read failed\n");
> +			phy_disconnect(lp->phy_dev);
> +			lp->phy_dev = NULL;
> +
> +			return bmcr;
> +		}
>  		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
>  		phy_write(lp->phy_dev, MII_BMCR, bmcr);

A MAC driver should not be touching the PHY. The call to
phy_set_max_speed() should prevent the PHY from advertising 1G speeds,
so there is no need to poke the advertise registers. And phy_start()
will start auto-get if it is enabled.

It would be nice if this code got cleaned up.

   Andrew
