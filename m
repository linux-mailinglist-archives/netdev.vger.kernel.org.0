Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2821936927D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhDWMxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:53:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhDWMxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:53:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZvJ3-000eY8-KB; Fri, 23 Apr 2021 14:53:13 +0200
Date:   Fri, 23 Apr 2021 14:53:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] drivers: net: dsa: qca8k: protect MASTER busy_wait
 with mdio mutex
Message-ID: <YILDOX6vhNNTkvun@lunn.ch>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423014741.11858-14-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 03:47:39AM +0200, Ansuel Smith wrote:
> MDIO_MASTER operation have a dedicated busy wait that is not protected
> by the mdio mutex. This can cause situation where the MASTER operation
> is done and a normal operation is executed between the MASTER read/write
> and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
> address this issue by binding the lock for the whole MASTER operation
> and not only the mdio read/write common operation.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 59 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 88a0234f1a7b..d2f5e0b1c721 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -609,9 +609,33 @@ qca8k_port_to_phy(int port)
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
> +
> +	return time_after_eq(jiffies, timeout);

You should really be returning -ETIMEDOUT here on error.

    Andrew
