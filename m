Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6272AA7A7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgKGTf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGTf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 14:35:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8D620723;
        Sat,  7 Nov 2020 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604777728;
        bh=AjR96+yaBayijL7Wx5/CF+M4oB4bNnVhjNMokSzY7Uk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BrPhYw+rrMLsFZlKDu2tGpqYgtcQjR7sz+Macvy6nbmXUqefoxI4ztwUCMELNqBMH
         i6hSl2n2KID7nAY0xngZfvLkMO5dpnWzUab61en/NwoK+2RYL+WlIUQDFtyc8FEZ8r
         JE6onVK4n3YxpYzp/ck2X6YCHRzGZgNcH8S8KWss=
Date:   Sat, 7 Nov 2020 11:35:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     <davem@davemloft.net>, <michal.simek@xilinx.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>
Subject: Re: [PATCH net-next] net: emaclite: Add error handling for
 of_address_ and phy read functions
Message-ID: <20201107113527.18232c34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 19:01:05 +0530 Radhey Shyam Pandey wrote:
> From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> 
> Add ret variable, conditions to check the return value and it's error
> path for of_address_to_resource() and phy_read() functions.
> 
> Addresses-Coverity: Event check_return value.
> Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Any reason not to apply this to net as a fix?

> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 0c26f5b..fc5ccd1 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -820,7 +820,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
>  static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
>  {
>  	struct mii_bus *bus;
> -	int rc;
> +	int rc, ret;
>  	struct resource res;
>  	struct device_node *np = of_get_parent(lp->phy_node);
>  	struct device_node *npp;
> @@ -834,7 +834,13 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
>  	}
>  	npp = of_get_parent(np);
>  
> -	of_address_to_resource(npp, 0, &res);
> +	ret = of_address_to_resource(npp, 0, &res);
> +	if (ret) {
> +		dev_err(dev, "%s resource error!\n",
> +			dev->of_node->full_name);
> +		of_node_put(lp->phy_node);

I'm always confused by the of_* refcounting. Why do you need to put
phy_node here, and nowhere else in this function?

> +		return ret;
> +	}

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

Does it really make much sense to validate the return value of
phy_read() but not check any errors from phy_write()s?
