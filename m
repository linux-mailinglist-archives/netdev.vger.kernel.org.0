Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846BED6C28
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfJNXpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:45:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbfJNXpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 19:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cc1o6O0GLcNmuIJAd1oHLMPB851qrt/yI8fCRGWgBCo=; b=Fh0dTqlc8R4ICOnWmHzdgesJtH
        NtyKe2TmNpUZ4B+dLAsXM78IGvzhTh4/psRIvHMWoSzR43MUd0tiZ9iBC0tuMn+K3gBhWycJ+osdJ
        OS85mC/uGOZCiWbN/e/sBfEnxmrlc5GdcbH2XvWbb4209XLKV1U4EkluWzKRy6vevIaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKA1O-00078m-TP; Tue, 15 Oct 2019 01:45:02 +0200
Date:   Tue, 15 Oct 2019 01:45:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] net: lpc_eth: parse phy nodes from device tree
Message-ID: <20191014234502.GG19861@lunn.ch>
References: <20191010204530.15150-1-alexandre.belloni@bootlin.com>
 <20191010204530.15150-2-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010204530.15150-2-alexandre.belloni@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 10:45:30PM +0200, Alexandre Belloni wrote:
> When connected to a micrel phy, phy_find_first doesn't work properly
> because the first phy found is on address 0, the broadcast address but, the
> first thing the phy driver is doing is disabling this broadcast address.
> The phy is then available only on address 1 but the mdio driver doesn't
> know about it.
> 
> Instead, register the mdio bus using of_mdiobus_register and try to find
> the phy description in device tree before falling back to phy_find_first.
> 
> This ultimately also allows to describe the interrupt the phy is connected
> to.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Hi Alexandre

>  
> -	if (mdiobus_register(pldat->mii_bus))
> +	if (of_mdiobus_register(pldat->mii_bus, pldat->pdev->dev.of_node))
>  		goto err_out_unregister_bus;

It is normal to use a container node 'mdio' in the ethernet node to
contain the PHY nodes. If you don't do this, you run into issues when
you have Ethernet switches on the MDIO bus.

    Andrew
