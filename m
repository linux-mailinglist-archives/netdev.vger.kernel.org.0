Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D7377381
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhEHSAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:00:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:00:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfREN-003I32-6W; Sat, 08 May 2021 19:59:11 +0200
Date:   Sat, 8 May 2021 19:59:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 10/28] net: dsa: qca8k: handle error with
 qca8k_rmw operation
Message-ID: <YJbRb4th0ComGjF8@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static void
> +static int
>  qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
>  {
> -	qca8k_rmw(priv, reg, 0, val);
> +	int ret;
> +
> +	ret = qca8k_rmw(priv, reg, 0, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

This is wrong. Look at qca8k_rmw():

static u32
qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
{
	u16 r1, r2, page;
	u32 ret;

	qca8k_split_addr(reg, &r1, &r2, &page);

	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);

	qca8k_set_page(priv->bus, page);
	ret = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
	ret &= ~mask;
	ret |= val;
	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);

	mutex_unlock(&priv->bus->mdio_lock);

	return ret;
}

First off, it returns a u32. So you cannot actually represent negative
error numbers.

Also, since it is returning what is now contained in the register,
that value might actually look like an error code.

I had a quick look at all the places qca8k_rmw() is called. As far as
i could see, the return value is never used. I suggest you double
check that, and then change this function. Make it return a negative
error code, or 0 on success. You can then simplify the code using the
return value.

       Andrew
