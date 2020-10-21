Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB98295278
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504470AbgJUSvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437233AbgJUSvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:51:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0448CC0613CE;
        Wed, 21 Oct 2020 11:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LjYiE/mQv+QoTMgP/g348j7ZhrfnJxo182I5iCtyPOw=; b=b/9SpaNTbNy+YIv33qnJfSZUk
        6MJD70qNLRCt0tTbtLp4fMD+PuQEBthKYIFW7Pp4QosBVnfM41WalX+0RsSZgKR84fcc0f7lrMlWb
        U1uTqbvWTuo4pbbq2TLQrQy+oPnRPwj3d7det39sRdY74sP11MQ/NbJ3dCxZKX+wsYLjCCHUfR/QG
        0G8vVy1VsmTiEsA8b0dBhxP5WCHbqRIt+PCkJdq+AUf3ksb7Hb2vHmmic8LKCuIpRtws+WsTTvDoC
        OLTbnCV85snal1nlmIiHWnjrI0inQUdW6jS2WpZH+bEvCmF9tQ9e+Dew/cPEwvfjjwKG+xyeLFTCI
        61SESf/7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49200)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVJCO-0000xE-Fa; Wed, 21 Oct 2020 19:51:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVJCK-0006c9-Gr; Wed, 21 Oct 2020 19:50:56 +0100
Date:   Wed, 21 Oct 2020 19:50:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mparab@cadence.com
Subject: Re: [PATCH v3] net: macb: add support for high speed interface
Message-ID: <20201021185056.GN1551@shell.armlinux.org.uk>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 07:44:05PM +0200, Parshuram Thombare wrote:
> This patch adds support for 10GBASE-R interface to the linux driver for
> Cadence's ethernet controller.
> This controller has separate MAC's and PCS'es for low and high speed paths.
> High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
> implementation. However, since it doesn't support auto negotiation, linux
> driver is modified to support 10GBASE-R insted of USXGMII. 
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
> Changes between v2 and v3:
> 1. Replace USXGMII interface by 10GBASE-R interface.
> 2. Adopted new phylink pcs_ops for high speed PCS.
> 3. Added pcs_get_state for high speed PCS.

Hi,

If you're going to support pcs_ops for the 10GBASE-R mode, can you
also convert macb to use pcs_ops for the lower speed modes as well?

The reason is that when you have pcs_ops in place, there are slight
behaviour differences in the way phylink calls the MAC functions,
and in the long run I would like to eventually retire the old ways
(so we don't have to keep compatible with old in-kernel APIs alive
for ever.)

I think all that needs to happen is a pcs_ops for the non-10GBASE-R
mode which moves macb_mac_pcs_get_state() and macb_mac_an_restart()
to it, and implements a stub pcs_config(). So it should be simple
to do.

Further comments below.

> +static int macb_usx_pcs_config(struct phylink_pcs *pcs,
> +			       unsigned int mode,
> +			       phy_interface_t interface,
> +			       const unsigned long *advertising,
> +			       bool permit_pause_to_mac)
> +{
> +	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
> +	u32 val;
> +
> +	val = gem_readl(bp, NCFGR);
> +	val = GEM_BIT(PCSSEL) | (~GEM_BIT(SGMIIEN) & val);
> +	gem_writel(bp, NCFGR, val);

This looks like it's configuring the MAC rather than the PCS - it
should probably be in mac_prepare() or mac_config().

Note that the order of calls when changing the interface mode will
be:

- mac_prepare()
- mac_config()
- pcs_config()
- pcs_an_restart() optionally
- mac_finish()

> +static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
> +			    phy_interface_t interface)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct macb *bp = netdev_priv(ndev);
> +
> +	if (interface == PHY_INTERFACE_MODE_10GBASER) {
> +		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
> +		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> +	}

What happens if phylink requests 10GBASE-R and subsequently selects
a different interface mode? You end up with the PCS still registered
and phylink will use it even when not in 10GBASE-R mode - so its
functions will also be called.

Note also that if a PCS is registered, phylink will omit to call
mac_config() unless the interface mode is being changed. If no PCS
is registered, it will call mac_config() in the old way (which
includes link up events.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
