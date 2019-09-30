Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C7EC2252
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfI3NmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:42:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbfI3NmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 09:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HM9diPGupOggaNZogOJaICPhhkDGUZeBHQIqFNQhR8Y=; b=j9AMskwcXy85O+T+7/AYyAwa8N
        0Ga/VHObyYQptEJ7D0G1EEG45cd5EEmNiEMuzTz+ydG2jwdsvhz3wqb7AI6RnWxbVST/FCVvFRZeg
        k52Of0o3mlMLIFe8Z1oytbIFt1SFjPTb7/lFd15Z3w22UhH/uB7ygK61Oj6nSUyU/q9c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEvwH-0003vJ-9h; Mon, 30 Sep 2019 15:42:09 +0200
Date:   Mon, 30 Sep 2019 15:42:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: ag71xx: fix mdio subnode support
Message-ID: <20190930134209.GB14745@lunn.ch>
References: <20190930093310.10762-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930093310.10762-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:33:10AM +0200, Oleksij Rempel wrote:
> The driver was working with fixed phy without any noticeable issues. This bug
> was uncovered by introducing dsa ar9331-switch driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 6703960c7cf5..d1101eea15c2 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -526,7 +526,7 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
>  	struct device *dev = &ag->pdev->dev;
>  	struct net_device *ndev = ag->ndev;
>  	static struct mii_bus *mii_bus;
> -	struct device_node *np;
> +	struct device_node *np, *mnp;
>  	int err;
>  
>  	np = dev->of_node;
> @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
>  		msleep(200);
>  	}
>  
> -	err = of_mdiobus_register(mii_bus, np);
> +	mnp = of_get_child_by_name(np, "mdio");
> +	err = of_mdiobus_register(mii_bus, mnp);
> +	of_node_put(mnp);
>  	if (err)
>  		goto mdio_err_put_clk;

Hi Oleksij

You need to keep backwards compatibility here. If you find an mdio
node, use it, but if not, you need to still register np.

This is also extending the driver binding, so you need to update the
binding documentation.

	Andrew
