Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6726325CF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 02:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfFCAu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 20:50:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFCAu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 20:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h7n1AxyGqWwgMA82sxnf30fp5kiz6etE8gTnyYlS478=; b=ISsGN3VHlIW4BeWyYwhAWK8r/R
        a1Feliu42Kup+MbkSIljq1/Kw/5JEk06OeqpoVLDTNFcMKZHozRD68NcLLugpjG8tWyT0IiwmnBZ6
        G8jAA/nQ+y/1+Zsh9U/hFFHZFBxx2F/MZxS4lkxbfC7o6EQfDNhQy8rlyM3Wlwu3rQgo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXbBd-0002Tp-Jv; Mon, 03 Jun 2019 02:50:53 +0200
Date:   Mon, 3 Jun 2019 02:50:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 1/1] net: dsa: sja1105: Fix link speed not working
 at 100 Mbps and below
Message-ID: <20190603005053.GH19081@lunn.ch>
References: <20190602233137.17930-1-olteanv@gmail.com>
 <20190602233137.17930-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602233137.17930-2-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:31:37AM +0300, Vladimir Oltean wrote:
> The hardware values for link speed are held in the sja1105_speed_t enum.
> However they do not increase in the order that sja1105_get_speed_cfg was
> iterating over them (basically from SJA1105_SPEED_AUTO - 0 - to
> SJA1105_SPEED_1000MBPS - 1 - skipping the other two).
> 
> Another bug is that the code in sja1105_adjust_port_config relies on the
> fact that an invalid link speed is detected by sja1105_get_speed_cfg and
> returned as -EINVAL.  However storing this into an enum that only has
> positive members will cast it into an unsigned value, and it will miss
> the negative check.
> 
> So take the simplest approach and remove the sja1105_get_speed_cfg
> function and replace it with a simple switch-case statement.
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++++-------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 5412c3551bcc..25bb64ce0432 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -710,16 +710,6 @@ static int sja1105_speed[] = {
>  	[SJA1105_SPEED_1000MBPS] = 1000,
>  };
>  
> -static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
> -{
> -	int i;
> -
> -	for (i = SJA1105_SPEED_AUTO; i <= SJA1105_SPEED_1000MBPS; i++)
> -		if (sja1105_speed[i] == speed_mbps)
> -			return i;
> -	return -EINVAL;
> -}
> -
>  /* Set link speed and enable/disable traffic I/O in the MAC configuration
>   * for a specific port.
>   *
> @@ -742,8 +732,21 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
>  	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
>  	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
>  
> -	speed = sja1105_get_speed_cfg(speed_mbps);
> -	if (speed_mbps && speed < 0) {
> +	switch (speed_mbps) {
> +	case 0:
> +		/* No speed update requested */
> +		speed = SJA1105_SPEED_AUTO;
> +		break;
> +	case 10:
> +		speed = SJA1105_SPEED_10MBPS;
> +		break;
> +	case 100:
> +		speed = SJA1105_SPEED_100MBPS;
> +		break;
> +	case 1000:
> +		speed = SJA1105_SPEED_1000MBPS;
> +		break;
> +	default:
>  		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
>  		return -EINVAL;
>  	}

Thanks for the re-write. This looks more obviously correct. One minor
nit-pick. We have SPEED_10, SPEED_100, SPEED_1000, etc. It would be
good to use them.

With that change

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
