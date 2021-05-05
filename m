Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65AF37333E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEEAhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:37:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhEEAhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:37:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5WR-002Yub-CZ; Wed, 05 May 2021 02:36:15 +0200
Date:   Wed, 5 May 2021 02:36:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 05/20] net: dsa: qca8k: handle error with
 qca8k_read operation
Message-ID: <YJHof4mwG7xYRc8f@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:28:59AM +0200, Ansuel Smith wrote:
> qca8k_read can fail. Rework any user to handle error values and
> correctly return.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 90 +++++++++++++++++++++++++++++++----------
>  1 file changed, 69 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 411b42d38819..cde68ed6856b 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -146,12 +146,13 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
>  static u32
>  qca8k_read(struct qca8k_priv *priv, u32 reg)
>  {
> +	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	u32 val;
>  
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
> -	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
>  	val = qca8k_set_page(priv->bus, page);
>  	if (val < 0)
> @@ -160,8 +161,7 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
>  	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
>  
>  exit:
> -	mutex_unlock(&priv->bus->mdio_lock);
> -
> +	mutex_unlock(&bus->mdio_lock);
>  	return val;

This change does not have anything to do with the commit message.

>  }
>  
> @@ -226,8 +226,13 @@ static int
>  qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> +	int ret;
>  
> -	*val = qca8k_read(priv, reg);
> +	ret = qca8k_read(priv, reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	*val = ret;
>  
>  	return 0;
>  }
> @@ -280,15 +285,17 @@ static int
>  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
>  {
>  	unsigned long timeout;
> +	u32 val;
>  
>  	timeout = jiffies + msecs_to_jiffies(20);
>  
>  	/* loop until the busy flag has cleared */
>  	do {
> -		u32 val = qca8k_read(priv, reg);
> -		int busy = val & mask;
> +		val = qca8k_read(priv, reg);
> +		if (val < 0)
> +			continue;
>  
> -		if (!busy)
> +		if (!(val & mask))
>  			break;
>  		cond_resched();

Maybe there is a patch doing this already, but it would be good to
make use of include/linux/iopoll.h

>  qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
>  {
> -	int ret;
> +	int ret, ret_read;
>  
>  	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
>  	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
> -	if (ret >= 0)
> -		qca8k_fdb_read(priv, fdb);
> +	if (ret >= 0) {
> +		ret_read = qca8k_fdb_read(priv, fdb);
> +		if (ret_read < 0)
> +			return ret_read;
> +	}
>  
>  	return ret;
>  }

This is oddly structured. Why not:

qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
{
	int ret;

	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);

	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
	if (ret < 0)
		return ret;

	return qca8k_fdb_read(priv, fdb);
}

	Andrew
