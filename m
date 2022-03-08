Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F494D196C
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346876AbiCHNn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244061AbiCHNnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:43:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607A0630A;
        Tue,  8 Mar 2022 05:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8pkICFhiQrDMR5XEgxN0JP/tBSupmgqyH9KAmeTxGhc=; b=P7zkpwUPfx+xcaFbChLscMHDY5
        uPlaT9EMJ20vfU48hKN0tg6p61J3YzJjIpXv3fw0dpFG6HY4qTv540lZzpU6inifzsV8KN9z4pKea
        6WJ8Wpx83f1oxFut+KcMxsVp3GjQSJrpSECGka/OrSTBYSupSVsmeSuzy2328cROcu8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRa6u-009noG-43; Tue, 08 Mar 2022 14:42:44 +0100
Date:   Tue, 8 Mar 2022 14:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, caihuoqing@baidu.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Message-ID: <YiddVEBJvM81u1jJ@lunn.ch>
References: <20220308111005.4953-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308111005.4953-1-niejianglei2021@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 07:10:05PM +0800, Jianglei Nie wrote:
> If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
> the "bus". But bus->name is still used in the next line, which will lead
> to a use after free.
> 
> We can fix it by putting the bus->name in a local variable and then use
> the name in the error message without referring to bus to avoid the uaf.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
> index 9acf589b1178..33fd63d227ef 100644
> --- a/drivers/net/ethernet/arc/emac_mdio.c
> +++ b/drivers/net/ethernet/arc/emac_mdio.c
> @@ -134,6 +134,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
>  	struct device_node *np = priv->dev->of_node;
>  	struct mii_bus *bus;
>  	int error;
> +	const char *name = "Synopsys MII Bus";

Netdev uses reverse christmass tree, meaning you need to sort
variables longest to shortest.

I'm also wondering about the lifetime of name. name itself is a stack
variable, so it will disappear as soon as the function exits. The
string itself is in the rodata section. But is a copy made onto the
stack, or does bus->name point to the rodata?

       Andrew

>  	bus = mdiobus_alloc();
>  	if (!bus)
> @@ -142,7 +143,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
>  	priv->bus = bus;
>  	bus->priv = priv;
>  	bus->parent = priv->dev;
> -	bus->name = "Synopsys MII Bus";
> +	bus->name = name;
>  	bus->read = &arc_mdio_read;
>  	bus->write = &arc_mdio_write;
>  	bus->reset = &arc_mdio_reset;
> @@ -167,7 +168,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
>  	if (error) {
>  		mdiobus_free(bus);
>  		return dev_err_probe(priv->dev, error,
> -				     "cannot register MDIO bus %s\n", bus->name);
> +				     "cannot register MDIO bus %s\n", name);
>  	}
>  
>  	return 0;
> -- 
> 2.25.1
> 
