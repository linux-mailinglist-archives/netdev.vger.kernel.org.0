Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDAE6CB380
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjC1B7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC1B7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:59:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8816B2689;
        Mon, 27 Mar 2023 18:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NKs+8fXhqTJfjVIS1poqWe1vyBspCLp4bXvIsT+t6sM=; b=fMsxPumtXZHfua+/Z+RkRLNzW0
        6xLg9V86MTvXecaFQ0IEt6v/BvqFZYom640FJAe+u8sY7h6yIzKGWrI6MC/IocDkmxT90kuxoZs45
        5v0AWd4oR0dsiIW3LOe6D63nbyvPPmh/Susd70Mc+PYHA/jNvCaMzgWGs+dlH6mqOkiw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgybq-008aTz-AI; Tue, 28 Mar 2023 03:58:50 +0200
Date:   Tue, 28 Mar 2023 03:58:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
References: <ZCIML310vc8/uoM4@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCIML310vc8/uoM4@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -118,6 +118,9 @@ core_write_mmd_indirect(struct mt7530_priv *priv, int prtad,
>  	struct mii_bus *bus = priv->bus;
>  	int ret;
>  
> +	if (!bus)
> +		return 0;
> +
>  	/* Write the desired MMD Devad */
>  	ret = bus->write(bus, 0, MII_MMD_CTRL, devad);
>  	if (ret < 0)
> @@ -147,11 +150,13 @@ core_write(struct mt7530_priv *priv, u32 reg, u32 val)
>  {
>  	struct mii_bus *bus = priv->bus;
>  
> -	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	if (bus)
> +		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
>  	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
>  
> -	mutex_unlock(&bus->mdio_lock);
> +	if (bus)
> +		mutex_unlock(&bus->mdio_lock);
>  }
>  
>  static void
> @@ -160,6 +165,9 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
>  	struct mii_bus *bus = priv->bus;
>  	u32 val;
>  
> +	if (!bus)
> +		return;
> +
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
>  	val = core_read_mmd_indirect(priv, reg, MDIO_MMD_VEND2);
> @@ -189,6 +197,11 @@ mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
>  	u16 page, r, lo, hi;
>  	int ret;
>  
> +	if (priv->base_addr) {
> +		iowrite32(val, priv->base_addr + reg);
> +		return 0;
> +	}
> +
>  	page = (reg >> 6) & 0x3ff;
>  	r  = (reg >> 2) & 0xf;
>  	lo = val & 0xffff;
> @@ -218,6 +231,9 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
>  	u16 page, r, lo, hi;
>  	int ret;
>  
> +	if (priv->base_addr)
> +		return ioread32(priv->base_addr + reg);
> +
>  	page = (reg >> 6) & 0x3ff;
>  	r = (reg >> 2) & 0xf;
>  

This looks pretty ugly.

A much better way to do this is to use regmap. Take a look at xrs700x
and how it has both an i2c and an mdio version.

    Andrew
