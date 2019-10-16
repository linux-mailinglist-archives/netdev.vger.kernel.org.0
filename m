Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED151D907C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392906AbfJPMMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:12:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfJPMMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 08:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LqCWfNLeIi/lU1VYcedAQODf4QQxGIAREfNdlGzSHew=; b=Ur7ReQofDILOMURmgfTUs0ScfS
        z4vEDKGLC33wWTQgeHTIwMV3JdPbpSHhIH0o3kb6KDthCVjs/b1Gp9mxADwejzMpYhpDWmdVRqQF9
        7vjb66LCaLqRunlt7At/tQ3MXtwIuzm87UwG9R8Mb6tbXW2N3MQ9jJrWySIo6eIYir14=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKiA4-0007FJ-Cm; Wed, 16 Oct 2019 14:12:16 +0200
Date:   Wed, 16 Oct 2019 14:12:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 1/4] net: ag71xx: port to phylink
Message-ID: <20191016121216.GD4780@lunn.ch>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014061549.3669-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 08:15:46AM +0200, Oleksij Rempel wrote:
> The port to phylink was done as close as possible to initial
> functionality.
> Theoretically this HW can support flow control, practically seems to be not
> enough to just enable it. So, more work should be done.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Hi Oleksij

Please include Russell King in Cc: in future.

> -static void ag71xx_phy_link_adjust(struct net_device *ndev)
> +static void ag71xx_mac_validate(struct phylink_config *config,
> +			    unsigned long *supported,
> +			    struct phylink_link_state *state)
>  {
> -	struct ag71xx *ag = netdev_priv(ndev);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> +	    state->interface != PHY_INTERFACE_MODE_MII) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
> +	phylink_set(mask, MII);
> +
> +	/* flow control is not supported */
>  
> -	ag71xx_link_adjust(ag, true);
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseX_Full);

Can the MAC/PHY dynamically switch between MII and GMII? Maybe you
should only add 1G support when interface is GMII?

> @@ -1239,6 +1255,13 @@ static int ag71xx_open(struct net_device *ndev)
>  	unsigned int max_frame_len;
>  	int ret;
>  
> +	ret = phylink_of_phy_connect(ag->phylink, ag->pdev->dev.of_node, 0);
> +	if (ret) {
> +		netif_info(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
> +			   ret);

netif_info seems wrong. _err()?

	   Andrew

