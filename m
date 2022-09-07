Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582F95B015F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiIGKLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiIGKLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:11:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C094C9D648;
        Wed,  7 Sep 2022 03:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JzTlhZoQdTgX29JObm/3zifLoY6nLpvd+jv0OT7bzL4=; b=1Sj6h/MjqhU9ZV5YQpYpYz1rRL
        gghVXCoasUgdI4s9yI2MYjF6HqYu7ALRxdNG9f2BoG8CdX/VVJoViChosaF4WGuh34Gnbg+zD/4qw
        rWA0tbkSaW8VKmDq/zfEfnRybv18Fl6hcz3KUtqc6Xu5d0REY+YsJiY2Rby6IENOUsuecIPvtRy4e
        akpwkAnqG5qAdFot3Z5KJwOfB47ypDqEcjPfXNQJDffei3C3J7KaoKvLD24ER8L56gDX/LPuVzTDE
        q3QhgUesgddcWWBPfyer/AuTyruMZNLDhldJ/mU5IOutTyXxyes1SwTb4fsxtDkk+TFSpToAABjc+
        uVmJUq7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34172)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVs1M-0005Ei-5y; Wed, 07 Sep 2022 11:11:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVs1K-0000ti-7K; Wed, 07 Sep 2022 11:10:58 +0100
Date:   Wed, 7 Sep 2022 11:10:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 5/8] net: phylink: Adjust link settings based
 on rate adaptation
Message-ID: <YxhuMjZsBb7wCBFy@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-6-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906161852.1538270-6-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:18:49PM -0400, Sean Anderson wrote:
> @@ -1015,19 +1086,45 @@ static void phylink_link_up(struct phylink *pl,
>  			    struct phylink_link_state link_state)
>  {
>  	struct net_device *ndev = pl->netdev;
> +	int speed, duplex;
> +	bool rx_pause;
> +
> +	speed = link_state.speed;
> +	duplex = link_state.duplex;
> +	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
> +
> +	switch (link_state.rate_adaptation) {
> +	case RATE_ADAPT_PAUSE:
> +		/* The PHY is doing rate adaption from the media rate (in
> +		 * the link_state) to the interface speed, and will send
> +		 * pause frames to the MAC to limit its transmission speed.
> +		 */
> +		speed = phylink_interface_max_speed(link_state.interface);
> +		duplex = DUPLEX_FULL;
> +		rx_pause = true;
> +		break;
> +
> +	case RATE_ADAPT_CRS:
> +		/* The PHY is doing rate adaption from the media rate (in
> +		 * the link_state) to the interface speed, and will cause
> +		 * collisions to the MAC to limit its transmission speed.
> +		 */
> +		speed = phylink_interface_max_speed(link_state.interface);
> +		duplex = DUPLEX_HALF;
> +		break;
> +	}
>  
>  	pl->cur_interface = link_state.interface;
> +	if (link_state.rate_adaptation == RATE_ADAPT_PAUSE)
> +		link_state.pause |= MLO_PAUSE_RX;

I specifically omitted this from my patch because I don't think we
should tell the user that "Link is Up - ... - flow control rx" if
we have rate adaption, but the media link is not using flow control.

The "Link is Up" message tells the user what was negotiated on the
media, not what is going on inside their network device, so the
fact we're using rate adaption which has turned on RX pause on the
MAC is neither here nor there.

>  
>  	if (pl->pcs && pl->pcs->ops->pcs_link_up)
>  		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> -					 pl->cur_interface,
> -					 link_state.speed, link_state.duplex);
> +					  pl->cur_interface, speed, duplex);

It seems you have one extra unnecessary space here - not sure how
that occurred as it isn't in my original patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
