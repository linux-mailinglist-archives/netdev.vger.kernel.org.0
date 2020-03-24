Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B967C190327
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgCXBG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:06:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgCXBG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VX533EIGBmZegscsXAPRQsltrJ+MIYGcmOmCfrpeFSw=; b=0kUS0bZNMDJ4bj8R4L3mhAtEFK
        a8YVAzXp4KIW6mxU0qmXCS1gMXgoSCHf6LEG+zt82YTLXDYIODCDZZnL43z2JBSqXuzKf4T4wRQOJ
        sjpZwpbfYFEl+H9gQ98snliANUk1jF4b+luXW9k1GHqmOzZ4fJXHgn7LeqaKtXxQvvCY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGY1O-0005HQ-2v; Tue, 24 Mar 2020 02:06:22 +0100
Date:   Tue, 24 Mar 2020 02:06:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 03/14] net: ks8851: Pass device pointer into
 ks8851_init_mac()
Message-ID: <20200324010622.GH3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-4-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-4-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:52AM +0100, Marek Vasut wrote:
> Since the driver probe function already has a struct device *dev pointer,
> pass it as a parameter to ks8851_init_mac() to avoid fishing it out via
> ks->spidev. This is the only reference to spidev in the function, so get
> rid of it. This is done in preparation for unifying the KS8851 SPI and
> parallel drivers.
> 
> No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/micrel/ks8851.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
> index 8f4d7c0af723..601a74d750b2 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -409,6 +409,7 @@ static void ks8851_read_mac_addr(struct net_device *dev)
>  /**
>   * ks8851_init_mac - initialise the mac address
>   * @ks: The device structure
> + * @ddev: The device structure pointer
>   *
>   * Get or create the initial mac address for the device and then set that
>   * into the station address register. A mac address supplied in the device
> @@ -416,12 +417,12 @@ static void ks8851_read_mac_addr(struct net_device *dev)
>   * we try that. If no valid mac address is found we use eth_random_addr()
>   * to create a new one.
>   */
> -static void ks8851_init_mac(struct ks8851_net *ks)
> +static void ks8851_init_mac(struct ks8851_net *ks, struct device *ddev)
>  {
>  	struct net_device *dev = ks->netdev;
>  	const u8 *mac_addr;
>  
> -	mac_addr = of_get_mac_address(ks->spidev->dev.of_node);
> +	mac_addr = of_get_mac_address(ddev->of_node);


Hi Marek

The name ddev is a bit odd. Looking at the code, i see why. dev is
normally a struct net_device, which this function already has.

You could avoid this oddness by directly passing of_node.

    Andrew
