Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5EB25CBB5
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgICVAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgICVAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:00:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDwL5-00D6Xq-2q; Thu, 03 Sep 2020 23:00:11 +0200
Date:   Thu, 3 Sep 2020 23:00:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Message-ID: <20200903210011.GD3112546@lunn.ch>
References: <20200903202712.143878-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903202712.143878-1-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:27:12PM +0200, Marek Vasut wrote:
> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
> loses its register settings. The fec_enet_mii_probe() starts the PHY
> and does the necessary calls to configure the PHY via PHY framework,
> and loads the correct register settings into the PHY. Therefore,
> fec_enet_mii_probe() should be called only after the PHY has been
> reset, not before as it is now.

I think this patch is related to what Florian is currently doing with
PHY clocks.

I think a better fix for the original problem is for the SMSC PHY
driver to control the clock itself. If it clk_prepare_enables() the
clock, it knows it will not be shut off again by the FEC run time
power management.

All this phy_reset_after_clk_enable() can then go away.

    Andrew
