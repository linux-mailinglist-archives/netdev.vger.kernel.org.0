Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7787F198142
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgC3Qab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:30:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgC3Qaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 12:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rzh9ueR7rZV8bhCQEK6RCcxjt9ukPqxxiqOJSvaCw8I=; b=mcvg7vKuOo7yU+LPEx+F+bszdM
        g6XBJUJ6+WHAyGzXz+cPUuz06fumRjhrJuUR1yx6WCLiqDh17Cw899KfHjuHDXRy8fPJFlV/sDerU
        bifb2uLLvscED+USvLy+KDCkDIhAZOKmyG10/v+Ypb9i8SQ7lUVFNsr5P6+E5yqvtUxE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIxIy-00066S-VM; Mon, 30 Mar 2020 18:30:28 +0200
Date:   Mon, 30 Mar 2020 18:30:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200330163028.GE23477@lunn.ch>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 07:01:36PM +0300, Codrin Ciubotariu wrote:
> Some ethernet controllers, such as cadence's macb, have an embedded MDIO.
> For this reason, the ethernet PHY nodes are not under an MDIO bus, but
> directly under the ethernet node. Since these drivers might use
> of_mdiobus_child_is_phy(), we should fix this function by returning false
> if a fixed-link is found.

So i assume the problem occurs here:

static int macb_mdiobus_register(struct macb *bp)
{
        struct device_node *child, *np = bp->pdev->dev.of_node;

        /* Only create the PHY from the device tree if at least one PHY is
         * described. Otherwise scan the entire MDIO bus. We do this to support
         * old device tree that did not follow the best practices and did not
         * describe their network PHYs.
         */
        for_each_available_child_of_node(np, child)
                if (of_mdiobus_child_is_phy(child)) {
                        /* The loop increments the child refcount,
                         * decrement it before returning.
                         */
                        of_node_put(child);

                        return of_mdiobus_register(bp->mii_bus, np);
                }

        return mdiobus_register(bp->mii_bus);
}

I think a better solution is

        for_each_available_child_of_node(np, child)
+		if (of_phy_is_fixed_link(child)
+		   continue;
                if (of_mdiobus_child_is_phy(child)) {
                        /* The loop increments the child refcount,
                         * decrement it before returning.
                         */
                        of_node_put(child);

                        return of_mdiobus_register(bp->mii_bus, np);
                }

        return mdiobus_register(bp->mii_bus);
}

This problem is only an issue for macb, so keep the fix local to macb.

	Andrew
