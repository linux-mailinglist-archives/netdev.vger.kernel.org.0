Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDFD37336F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 03:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhEEBFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 21:05:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhEEBFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 21:05:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5y4-002ZBh-04; Wed, 05 May 2021 03:04:48 +0200
Date:   Wed, 5 May 2021 03:04:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 15/20] net: dsa: qca8k: dsa: qca8k:
 protect MASTER busy_wait with mdio mutex
Message-ID: <YJHvL+7/X/P4MDgt@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-15-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-15-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:09AM +0200, Ansuel Smith wrote:
> MDIO_MASTER operation have a dedicated busy wait that is not protected
> by the mdio mutex. This can cause situation where the MASTER operation
> is done and a normal operation is executed between the MASTER read/write
> and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
> address this issue by binding the lock for the whole MASTER operation
> and not only the mdio read/write common operation.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 69 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index b21835d719b5..27234dd4c74a 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -633,9 +633,33 @@ qca8k_port_to_phy(int port)
>  	return port - 1;
>  }
>  
> +static int
> +qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
> +{
> +	unsigned long timeout;
> +	u16 r1, r2, page;
> +
> +	qca8k_split_addr(reg, &r1, &r2, &page);
> +
> +	timeout = jiffies + msecs_to_jiffies(20);
> +
> +	/* loop until the busy flag has cleared */
> +	do {
> +		u32 val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
> +		int busy = val & mask;
> +
> +		if (!busy)
> +			break;
> +		cond_resched();
> +	} while (!time_after_eq(jiffies, timeout));

include/linux/iopoll.h


> +
> +	return time_after_eq(jiffies, timeout);
> +}
> +
>  static int
>  qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
>  {
> +	u16 r1, r2, page;
>  	u32 phy, val;
>  	int ret;
>  
> @@ -651,12 +675,22 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
>  	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
>  	      QCA8K_MDIO_MASTER_DATA(data);
>  
> -	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
> +	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
> +
> +	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	ret = qca8k_set_page(priv->bus, page);
>  	if (ret)
> -		return ret;
> +		goto exit;
>  
> -	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
> -			      QCA8K_MDIO_MASTER_BUSY);
> +	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
> +
> +	if (qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
> +				 QCA8K_MDIO_MASTER_BUSY))
> +		ret = -ETIMEDOUT;

qca8k_mdio_busy_wait() should be returning -EIMEDOUT.

       Andrew
