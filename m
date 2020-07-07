Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6332175CD
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgGGSEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:04:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgGGSEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 14:04:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsrx1-0043c4-Ks; Tue, 07 Jul 2020 20:04:15 +0200
Date:   Tue, 7 Jul 2020 20:04:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: print the right c45 id
Message-ID: <20200707180415.GC938746@lunn.ch>
References: <20200707173347.1564682-1-Shyam-sundar.S-k@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707173347.1564682-1-Shyam-sundar.S-k@amd.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 05:33:47PM +0000, Shyam Sundar S K wrote:
> If an external PHY uses the CL45 protocol, then phydev->phy_id will be
> zero. Update the debug message that prints the PHY ID to check the PHY
> mode and print the PMAPMD MMD PHY ID value for a CL45 PHY.
> 
> Also, removing the TODO note, as the CL45 support has been updated to
> do this.
> 
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 46c3c1ca38d6..5b14fc758c2f 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1024,9 +1024,9 @@ static int xgbe_phy_find_phy_device(struct xgbe_prv_data *pdata)
>  		return -ENODEV;
>  	}
>  	netif_dbg(pdata, drv, pdata->netdev, "external PHY id is %#010x\n",
> -		  phydev->phy_id);
> -
> -	/*TODO: If c45, add request_module based on one of the MMD ids? */
> +		(phy_data->phydev_mode == XGBE_MDIO_MODE_CL45)
> +		? phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD]
> +		: phydev->phy_id);

IDs are pretty low level. And for C45 devices, each sub device can
have its own ID, make it even less useful.

You get more useful information from phy_attached_info().

	Andrew
