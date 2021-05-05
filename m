Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEF37330B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhEEA0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:26:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhEEA0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:26:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5MB-002Yp7-BO; Wed, 05 May 2021 02:25:39 +0200
Date:   Wed, 5 May 2021 02:25:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 04/20] net: dsa: qca8k: handle
 qca8k_set_page errors
Message-ID: <YJHmAxsyh08CnPHA@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
>  qca8k_set_page(struct mii_bus *bus, u16 page)
>  {
>  	if (page == qca8k_current_page)
> -		return;
> +		return 0;
>  
> -	if (bus->write(bus, 0x18, 0, page) < 0)
> +	if (bus->write(bus, 0x18, 0, page) < 0) {
>  		dev_err_ratelimited(&bus->dev,
>  				    "failed to set qca8k page\n");
> +		return -EBUSY;

EBUSY is a bit odd. bus->write() should return an error code. Please
return that.

> @@ -161,14 +169,19 @@ static void
>  qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
>  {
>  	u16 r1, r2, page;
> +	int ret;
>  
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
> -	qca8k_set_page(priv->bus, page);
> +	ret = qca8k_set_page(priv->bus, page);
> +	if (ret < 0)
> +		goto exit;
> +
>  	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
>  
> +exit:
>  	mutex_unlock(&priv->bus->mdio_lock);

Maybe make this function also return the error? 

>  }
