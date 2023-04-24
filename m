Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516066D1598
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCaC2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCaC2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:28:45 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27140D50B;
        Thu, 30 Mar 2023 19:28:44 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pi4VG-0005Cr-3A;
        Fri, 31 Mar 2023 04:28:35 +0200
Date:   Fri, 31 Mar 2023 03:28:30 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 04/15] net: dsa: mt7530: use regmap to access
 switch register space
Message-ID: <ZCZFTtHJYl2N6q/Q@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <1763ab54a479458c4bb84342f32d4a2e379f1d26.1680180959.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1763ab54a479458c4bb84342f32d4a2e379f1d26.1680180959.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:20:57PM +0100, Daniel Golle wrote:
> Use regmap API to access the switch register space.

I missed to make use of regmap_update_bits in mt7530_rmw which is
also used in mt7530_set and mt7530_clear.

I've now made that change and re-tested, it works just as fine and
prevents some unneccesary locking overhead.
I'll post an updated patch in v2 after giving it a bit more time for
other reviewers to also take a look.

> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/dsa/mt7530.c | 91 +++++++++++++++++++++++++---------------
>  drivers/net/dsa/mt7530.h |  2 +
>  2 files changed, 60 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index d8b041d79f2b7..e27a0e551cec0 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -183,9 +183,9 @@ core_clear(struct mt7530_priv *priv, u32 reg, u32 val)
>  }
>  
>  static int
> -mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
> +mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
>  {
> -	struct mii_bus *bus = priv->bus;
> +	struct mii_bus *bus = context;
>  	u16 page, r, lo, hi;
>  	int ret;
>  
> @@ -197,24 +197,34 @@ mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
>  	/* MT7530 uses 31 as the pseudo port */
>  	ret = bus->write(bus, 0x1f, 0x1f, page);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
>  
>  	ret = bus->write(bus, 0x1f, r,  lo);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
>  
>  	ret = bus->write(bus, 0x1f, 0x10, hi);
> -err:
> +	return ret;
> +}
> +
> +static int
> +mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
> +{
> +	int ret;
> +
> +	ret = regmap_write(priv->regmap, reg, val);
> +
>  	if (ret < 0)
> -		dev_err(&bus->dev,
> +		dev_err(priv->dev,
>  			"failed to write mt7530 register\n");
> +
>  	return ret;
>  }
>  
> -static u32
> -mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
> +static int
> +mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
>  {
> -	struct mii_bus *bus = priv->bus;
> +	struct mii_bus *bus = context;
>  	u16 page, r, lo, hi;
>  	int ret;
>  
> @@ -223,17 +233,32 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
>  
>  	/* MT7530 uses 31 as the pseudo port */
>  	ret = bus->write(bus, 0x1f, 0x1f, page);
> -	if (ret < 0) {
> +	if (ret < 0)
> +		return ret;
> +
> +	lo = bus->read(bus, 0x1f, r);
> +	hi = bus->read(bus, 0x1f, 0x10);
> +
> +	*val = (hi << 16) | (lo & 0xffff);
> +
> +	return 0;
> +}
> +
> +static u32
> +mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = regmap_read(priv->regmap, reg, &val);
> +	if (ret) {
>  		WARN_ON_ONCE(1);
> -		dev_err(&bus->dev,
> +		dev_err(priv->dev,
>  			"failed to read mt7530 register\n");
>  		return 0;
>  	}
>  
> -	lo = bus->read(bus, 0x1f, r);
> -	hi = bus->read(bus, 0x1f, 0x10);
> -
> -	return (hi << 16) | (lo & 0xffff);
> +	return val;
>  }
>  
>  static void
> @@ -2896,22 +2921,6 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
>  	.pcs_an_restart = mt7530_pcs_an_restart,
>  };
>  
> -static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
> -{
> -	struct mt7530_priv *priv = context;
> -
> -	*val = mt7530_mii_read(priv, reg);
> -	return 0;
> -};
> -
> -static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
> -{
> -	struct mt7530_priv *priv = context;
> -
> -	mt7530_mii_write(priv, reg, val);
> -	return 0;
> -};
> -
>  static void
>  mt7530_mdio_regmap_lock(void *mdio_lock)
>  {
> @@ -2924,7 +2933,7 @@ mt7530_mdio_regmap_unlock(void *mdio_lock)
>  	mutex_unlock(mdio_lock);
>  }
>  
> -static const struct regmap_bus mt7531_regmap_bus = {
> +static const struct regmap_bus mt7530_regmap_bus = {
>  	.reg_write = mt7530_regmap_write,
>  	.reg_read = mt7530_regmap_read,
>  };
> @@ -2957,7 +2966,7 @@ mt7531_create_sgmii(struct mt7530_priv *priv)
>  		mt7531_pcs_config[i]->lock_arg = &priv->bus->mdio_lock;
>  
>  		regmap = devm_regmap_init(priv->dev,
> -					  &mt7531_regmap_bus, priv,
> +					  &mt7530_regmap_bus, priv->bus,
>  					  mt7531_pcs_config[i]);
>  		if (IS_ERR(regmap)) {
>  			ret = PTR_ERR(regmap);
> @@ -3128,6 +3137,7 @@ MODULE_DEVICE_TABLE(of, mt7530_of_match);
>  static int
>  mt7530_probe(struct mdio_device *mdiodev)
>  {
> +	static struct regmap_config *regmap_config;
>  	struct mt7530_priv *priv;
>  	struct device_node *dn;
>  
> @@ -3207,6 +3217,21 @@ mt7530_probe(struct mdio_device *mdiodev)
>  	mutex_init(&priv->reg_mutex);
>  	dev_set_drvdata(&mdiodev->dev, priv);
>  
> +	regmap_config = devm_kzalloc(&mdiodev->dev, sizeof(*regmap_config),
> +				     GFP_KERNEL);
> +	if (!regmap_config)
> +		return -ENOMEM;
> +
> +	regmap_config->reg_bits = 16;
> +	regmap_config->val_bits = 32;
> +	regmap_config->reg_stride = 4;
> +	regmap_config->max_register = MT7530_CREV;
> +	regmap_config->disable_locking = true;
> +	priv->regmap = devm_regmap_init(priv->dev, &mt7530_regmap_bus,
> +					priv->bus, regmap_config);
> +	if (IS_ERR(priv->regmap))
> +		return PTR_ERR(priv->regmap);
> +
>  	return dsa_register_switch(priv->ds);
>  }
>  
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index c5d29f3fc1d80..39aaca50961bd 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -754,6 +754,7 @@ struct mt753x_info {
>   * @dev:		The device pointer
>   * @ds:			The pointer to the dsa core structure
>   * @bus:		The bus used for the device and built-in PHY
> + * @regmap:		The regmap instance representing all switch registers
>   * @rstc:		The pointer to reset control used by MCM
>   * @core_pwr:		The power supplied into the core
>   * @io_pwr:		The power supplied into the I/O
> @@ -774,6 +775,7 @@ struct mt7530_priv {
>  	struct device		*dev;
>  	struct dsa_switch	*ds;
>  	struct mii_bus		*bus;
> +	struct regmap		*regmap;
>  	struct reset_control	*rstc;
>  	struct regulator	*core_pwr;
>  	struct regulator	*io_pwr;
> -- 
> 2.39.2
> 
> 
