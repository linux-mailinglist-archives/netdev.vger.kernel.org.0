Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA2965BD84
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbjACJ4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbjACJ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:56:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DBADE98;
        Tue,  3 Jan 2023 01:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gom6pVD/EB4Y1AfEbBpnMZQn295Vi6lxjxdUlEORAzk=; b=BwDLR7XPZwf31NU1WfFsIsS/xt
        hduiGNryFY10/WvdDnpSbf5fueeDklacoqs9m2AgwVHgl+nz/FvxLsn4IWwaa5DZ1DDSqw3lyAJ3W
        /r/yLMmut0QcKzX1ilfJrcGak5wF+TWbiBZ8JhnswzZnIkfYxwOg06bP1kowelyvbVEumf8gJsUdy
        3uIA14LH5Bx2inr7nhgt16ThjoKz/XV/YRzbQA7DknpemhVNbZ8XKFLCSffhSyv9s+wptR+F/ObZE
        jqKwaIVmra4vxSnP+kzepTJFFqBUUmqlQApr1Av7Uw6t1wvyy3hQQwQ6uEcOEIGgxyt5doghVNCbD
        2P65YJYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35906)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCe1Z-0005BD-NB; Tue, 03 Jan 2023 09:56:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCe1Y-0001xU-LI; Tue, 03 Jan 2023 09:56:00 +0000
Date:   Tue, 3 Jan 2023 09:56:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <Y7P7sJk4PZ1eLWDZ@shell.armlinux.org.uk>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
 <20221226071425.3895915-4-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226071425.3895915-4-yoshihiro.shimoda.uh@renesas.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 04:14:25PM +0900, Yoshihiro Shimoda wrote:
> Some Ethernet PHYs (like marvell10g) will decide the host interface
> mode by the media-side speed. So, the rswitch driver needs to
> initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> .init() for initializing all ports and .power_on() for initializing
> each port. So, add phy_power_{on,off} calling for it.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index ca79ee168206..2f335c95f5a8 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -1180,6 +1180,10 @@ static void rswitch_mac_link_down(struct phylink_config *config,
>  				  unsigned int mode,
>  				  phy_interface_t interface)
>  {
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +
> +	phy_power_off(rdev->serdes);
>  }
>  
>  static void rswitch_mac_link_up(struct phylink_config *config,
> @@ -1187,7 +1191,11 @@ static void rswitch_mac_link_up(struct phylink_config *config,
>  				phy_interface_t interface, int speed,
>  				int duplex, bool tx_pause, bool rx_pause)
>  {
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +
>  	/* Current hardware cannot change speed at runtime */
> +	phy_power_on(rdev->serdes);
>  }
>  
>  static const struct phylink_mac_ops rswitch_phylink_ops = {

This looks to me like it will break anyone using an in-band link,
where the link status comes from the PCS behind the series that
you're now powering down and up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
