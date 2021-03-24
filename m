Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE5347889
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhCXMc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:32:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhCXMcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:32:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lP2gi-00CmAt-27; Wed, 24 Mar 2021 13:32:40 +0100
Date:   Wed, 24 Mar 2021 13:32:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     praneeth@ti.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Geet Modi <geet.modi@ti.com>
Subject: Re: [PATCH] net: phy: dp83867: perform soft reset and retain
 established link
Message-ID: <YFsxaBj/AvPpo13W@lunn.ch>
References: <20210324010006.32576-1-praneeth@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324010006.32576-1-praneeth@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 08:00:06PM -0500, praneeth@ti.com wrote:
> From: Praneeth Bajjuri <praneeth@ti.com>
> 
> Current logic is performing hard reset and causing the programmed
> registers to be wiped out.
> 
> as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> 8.6.26 Control Register (CTRL)
> do SW_RESTART to perform a reset not including the registers and is
> acceptable to do this if a link is already present.

I don't see any code here to determine if the like is present. What if
the cable is not plugged in?

> @@ -826,7 +826,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>  {
>  	int err;
>  
> -	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
> +	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
>  	if (err < 0)
>  		return err;

The code continues

       usleep_range(10, 20);

        /* After reset FORCE_LINK_GOOD bit is set. Although the
         * default value should be unset. Disable FORCE_LINK_GOOD
         * for the phy to work properly.
         */
        return phy_modify(phydev, MII_DP83867_PHYCTRL,
                         DP83867_PHYCR_FORCE_LINK_GOOD, 0);
}

Do you still need to clear the FORCE_LINK_GOOD bit after a restart?

   Andrew
