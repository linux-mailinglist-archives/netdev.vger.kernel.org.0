Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F956F28A3
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 13:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjD3LnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 07:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjD3LnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 07:43:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDC819BF;
        Sun, 30 Apr 2023 04:43:22 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pt5SB-0002tz-1S;
        Sun, 30 Apr 2023 13:42:55 +0200
Date:   Sun, 30 Apr 2023 12:42:46 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     David Bauer <mail@david-bauer.net>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] mt7530: register OF node for internal MDIO bus
Message-ID: <ZE5UNq9QD1tZbHGx@makrotopia.org>
References: <20230430112834.11520-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430112834.11520-1-mail@david-bauer.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 01:28:32PM +0200, David Bauer wrote:
> The MT753x switches provide a switch-internal MDIO bus for the embedded
> PHYs.
> 
> Register a OF sub-node on the switch OF-node for this internal MDIO bus.
> This allows to configure the embedded PHYs using device-tree.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Acked-by: Daniel Golle <daniel@makrotopia.org>

I've got a similar commit in my tree for a while, yours is better
because you care to of_node_put(mnp) ;)
And yes, this will be fine also if mnp is NULL, the MDIO bus will
still be registered (just without the reference to the OF node) and
also of_node_put is fine being called for NULL.

> ---
>  drivers/net/dsa/mt7530.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index c680873819b0..7e8ea5b75c3e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2119,10 +2119,13 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
>  {
>  	struct dsa_switch *ds = priv->ds;
>  	struct device *dev = priv->dev;
> +	struct device_node *np, *mnp;
>  	struct mii_bus *bus;
>  	static int idx;
>  	int ret;
>  
> +	np = priv->dev->of_node;
> +
>  	bus = devm_mdiobus_alloc(dev);
>  	if (!bus)
>  		return -ENOMEM;
> @@ -2141,7 +2144,9 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
>  	if (priv->irq)
>  		mt7530_setup_mdio_irq(priv);
>  
> -	ret = devm_mdiobus_register(dev, bus);
> +	mnp = of_get_child_by_name(np, "mdio");
> +	ret = devm_of_mdiobus_register(dev, bus, mnp);
> +	of_node_put(mnp);
>  	if (ret) {
>  		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
>  		if (priv->irq)
> -- 
> 2.39.2
> 
