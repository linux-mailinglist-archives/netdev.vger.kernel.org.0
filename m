Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF975482BAC
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiABPSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:18:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232447AbiABPSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 10:18:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n93Bdc5Jo8H/r2AjLEnJjEPpghadROP9e+QlOQhfu4g=; b=x1asSTAVrN+BxiDfnIMJOSOS8s
        85hbQrfG1eth6w4qS8gvVmfdDy8bAm5IUopwdrlQPx9KLGnF9F7qZm7Ap9lKUgUKVV2krjo7y0WSw
        tNUlPevGJz7sPy/r9HuO+yRi6F82B43x30sLdqMd56rNfGTBZ9ZVqTYqwfXj8NCSvPyQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n42cZ-000Jds-LK; Sun, 02 Jan 2022 16:18:07 +0100
Date:   Sun, 2 Jan 2022 16:18:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: No network [Was: [PATCH] net: phy: fixed_phy: Fix NULL vs
 IS_ERR() checking in __fixed_phy_register]
Message-ID: <YdHCL6KpX525KTtr@lunn.ch>
References: <20211224021500.10362-1-linmq006@gmail.com>
 <YdGBwfbALNBrEwus@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdGBwfbALNBrEwus@ravnborg.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 11:43:13AM +0100, Sam Ravnborg wrote:
> Hi Miaoqian,
> 
> On Fri, Dec 24, 2021 at 02:14:59AM +0000, Miaoqian Lin wrote:
> > The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
> > pointers, using NULL checking to fix this.i
> > 
> > Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
> > Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> This patch has the side-effect that the node <link-gpios> is now
> mandatory. As the DT file I use do not have this node there is no
> network.
> The error I see in the log is:
> 
> 	fec 2188000.ethernet: broken fixed-link specification
> 	fec: probe of 2188000.ethernet failed with error -22
> 
> Reverting this patch gave me network again.
> This is on top of 8008293888188c3923f5bd8a69370dae25ed14e5.
> 
> Note: I have issues with my mail provider, so this mail may not hit the
> mailing list.

I think the real problem is:

commit b45396afa4177f2b1ddfeff7185da733fade1dc3
Author: Miaoqian Lin <linmq006@gmail.com>
Date:   Fri Dec 24 02:14:59 2021 +0000

    net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
    
    The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
    pointers, using NULL checking to fix this.i

The phy_get_gpiod function() does in fact return an error code pointer
for one important case:

        gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
                                       "link", 0, GPIOD_IN, "mdio");
        if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
                if (PTR_ERR(gpiod) != -ENOENT)
                        pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
                               fixed_link_node);
                gpiod = NULL;
        }
        of_node_put(fixed_link_node);

        return gpiod;

So if fwnode_gpiod_get_index() returns -EPROBE_DEFFER, and error code
pointer is returned. And that error code pointer needs to be returned
up the call stack in order that the driver gets probed again later
when the GPIO driver has loaded.

Miaoqian, please could you submit a fix for this.

     Andrew
