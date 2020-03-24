Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9753719034A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCXBWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:22:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgCXBWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oM1iJ3uvE/yFGZK+UAYZa9Y+gnauXsbxu9GdtLOYFEU=; b=kDZOOw2b6A1raPp/mm4yNaA5ib
        QiOr6OsvuTpi107ceOND5EW7HP2og0OfvLGViVpiuNAy0JIDsLrSCvDsUaH+djYy5cAoD4p4+NJG5
        bUh6sh5FQpdAt5ZL5ssEKetc4xw/5YhG6jNnO08xEjVVfe+ZOO27qczdo/WGPg4Q7pQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYHJ-0005Rz-R0; Tue, 24 Mar 2020 02:22:49 +0100
Date:   Tue, 24 Mar 2020 02:22:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 05/14] net: ks8851: Use dev_{get,set}_drvdata()
Message-ID: <20200324012249.GL3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-6-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-6-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:54AM +0100, Marek Vasut wrote:
> Replace spi_{get,set}_drvdata() with dev_{get,set}_drvdata(), which
> works for both SPI and platform drivers. This is done in preparation
> for unifying the KS8851 SPI and parallel bus drivers.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/micrel/ks8851.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
> index cc1137be3d8f..1c0a0364b047 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -1521,7 +1521,7 @@ static int ks8851_probe(struct spi_device *spi)
>  	ndev->ethtool_ops = &ks8851_ethtool_ops;
>  	SET_NETDEV_DEV(ndev, dev);
>  
> -	spi_set_drvdata(spi, ks);
> +	dev_set_drvdata(dev, ks);
>  
>  	netif_carrier_off(ks->netdev);
>  	ndev->if_port = IF_PORT_100BASET;
> @@ -1570,8 +1570,8 @@ static int ks8851_probe(struct spi_device *spi)
>  
>  static int ks8851_remove(struct spi_device *spi)
>  {
> -	struct ks8851_net *priv = spi_get_drvdata(spi);
>  	struct device *dev = &spi->dev;
> +	struct ks8851_net *priv = dev_get_drvdata(dev);

Reverse Christmas tree. You need to split this.

	Andrew
