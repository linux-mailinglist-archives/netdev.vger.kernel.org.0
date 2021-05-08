Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665F5377367
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEHRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 13:40:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhEHRkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 13:40:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfQum-003Hth-Pp; Sat, 08 May 2021 19:38:56 +0200
Date:   Sat, 8 May 2021 19:38:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 05/28] net: dsa: qca8k: use iopoll macro
 for qca8k_busy_wait
Message-ID: <YJbMsJ/pkcLuN0tI@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 02:28:55AM +0200, Ansuel Smith wrote:
> Use iopoll macro instead of while loop.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 23 +++++++++++------------
>  drivers/net/dsa/qca8k.h |  2 ++
>  2 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 0b295da6c356..0bfb7ae4c128 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -262,21 +262,20 @@ static struct regmap_config qca8k_regmap_config = {
>  static int
>  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
>  {
> -	unsigned long timeout;
> -
> -	timeout = jiffies + msecs_to_jiffies(20);
> +	u32 val;
> +	int ret;
>  
> -	/* loop until the busy flag has cleared */
> -	do {
> -		u32 val = qca8k_read(priv, reg);
> -		int busy = val & mask;
> +	ret = read_poll_timeout(qca8k_read, val, !(val & mask),
> +				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> +				priv, reg);
>  
> -		if (!busy)
> -			break;
> -		cond_resched();
> -	} while (!time_after_eq(jiffies, timeout));
> +	/* Check if qca8k_read has failed for a different reason
> +	 * before returnting -ETIMEDOUT

returning

With that fixed

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
