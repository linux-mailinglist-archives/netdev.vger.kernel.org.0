Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE8443A93
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhKCAvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:51:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhKCAvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wTFL8pY/W5Ahb3rFJh/TyoCP20ECF5bOXb8LXpxR4as=; b=ylTqxp7WFU60eR/EYU5es9nNgz
        PY3BPj7hl0NJp6z0u4g0l0cWFyeHiRmMjw1UhmXOePy/sayofDBK6aoeposJkZchXcH6ZhriqUroY
        mp0R/x2Mho+3XtHijH+e6JxTw8D5yQ4II6020eX0cw/517hMK/Mh1e9lBklhnt91HUHY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mi4Rv-00CSC2-Ac; Wed, 03 Nov 2021 01:48:19 +0100
Date:   Wed, 3 Nov 2021 01:48:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cyril Novikov <cnovikov@lynx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v2 net] ixgbe: set X550 MDIO speed before talking to PHY
Message-ID: <YYHcUxOA5jvrRtEs@lunn.ch>
References: <896681e4-fcd7-3187-8e59-75ce0896ebd3@lynx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <896681e4-fcd7-3187-8e59-75ce0896ebd3@lynx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 06:39:36PM -0700, Cyril Novikov wrote:
> The MDIO bus speed must be initialized before talking to the PHY the first
> time in order to avoid talking to it using a speed that the PHY doesn't
> support.
> 
> This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
> Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb network
> plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which combined
> with the 10Gb network results in a 24MHz MDIO speed, which is apparently
> too fast for the connected PHY. PHY register reads over MDIO bus return
> garbage, leading to initialization failure.
> 
> Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using
> the following setup:
> 
> * Use an Atom C3000 family system with at least one X552 LAN on the SoC
> * Disable PXE or other BIOS network initialization if possible
>   (the interface must not be initialized before Linux boots)
> * Connect a live 10Gb Ethernet cable to an X550 port
> * Power cycle (not reset, doesn't always work) the system and boot Linux
> * Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -17
> 
> Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
> Fixes: e84db7272798 ("ixgbe: Introduce function to control MDIO speed")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
