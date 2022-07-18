Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C87D57870C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiGRQMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiGRQM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:12:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDF52A712;
        Mon, 18 Jul 2022 09:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XY4k5D+BI4A4Rp2rDBAAFXYg7CTuWKRmrEv98B2USq0=; b=CnZwObVGeHuGa6upd8+YoqEV7m
        f1SKsYVOZ9yeOQIpkZfhP7LonTY7RcJKgcQS8xU28jrolJzlTu8gFD6K+QPCAUapBEy28Fz2AojZC
        gqoQ/Rm8hliqIReYgaxPOHzveaBdFcppHOQqr97fdryd7OZvQfZdssq5HFeX5tHu9VLlxCHsZCJ6A
        8mLpaN/0x0F2gwEB2T4HUS3HM9akXgDAPk6OcbrxfBD6goCdKqbWly+S9ss+2DX4QaCMeQqRnHATq
        X93TPelFSCl7Lq62bF5Fi5XBgb2yZOQJUYz8bXUiH1G1CjyBFaV3SMhAxgb+m1AyIij9gTmqX3+PW
        0Y6PMaqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33418)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDTM8-0001oE-QX; Mon, 18 Jul 2022 17:12:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDTM7-00025z-Fu; Mon, 18 Jul 2022 17:12:23 +0100
Date:   Mon, 18 Jul 2022 17:12:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtWGZ4ZJ6rmLmlWk@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-11-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
> If the phy is configured to use pause-based rate adaptation, ensure that
> the link is full duplex with pause frame reception enabled. Note that these
> settings may be overridden by ethtool.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v3:
> - New
> 
>  drivers/net/phy/phylink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 7fa21941878e..7f65413aa778 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
>  	pl->phy_state.speed = phy_interface_speed(phydev->interface,
>  						  phydev->speed);
>  	pl->phy_state.duplex = phydev->duplex;
> +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
> +		pl->phy_state.duplex = DUPLEX_FULL;
> +		rx_pause = true;
> +	}

I really don't like this - as I've pointed out in my previous email, the
reporting in the kernel message log for "Link is Up" will be incorrect
if you force the phy_state here like this. If the media side link has
been negotiated to be half duplex, we should state that in the "Link is
Up" message.

It's only the PCS and MAC that care about this, so this should be dealt
with when calling into the PCS and MAC's link_up() method.

The problem we have are the legacy drivers (of which mv88e6xxx and
mtk_eth_soc are the only two I'm aware of) that make use of the
state->speed and state->duplex when configuring stuff. We could've been
down to just mv88e6xxx had the DSA and mv88e6xxx patches been sorted
out, but sadly that's now going to be some time off due to reviewer
failure.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
