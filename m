Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230801FD4C0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgFQSnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:43:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgFQSnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:43:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jld26-0010lA-I1; Wed, 17 Jun 2020 20:43:34 +0200
Date:   Wed, 17 Jun 2020 20:43:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v1] net: phy: smsc: fix printing too many logs
Message-ID: <20200617184334.GA240559@lunn.ch>
References: <20200617153340.17371-1-zhengdejin5@gmail.com>
 <20200617161925.GE205574@lunn.ch>
 <20200617175039.GA18631@nuc8i5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617175039.GA18631@nuc8i5>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 01:50:39AM +0800, Dejin Zheng wrote:
> On Wed, Jun 17, 2020 at 06:19:25PM +0200, Andrew Lunn wrote:
> > On Wed, Jun 17, 2020 at 11:33:40PM +0800, Dejin Zheng wrote:
> > > Commit 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout()
> > > to simplify the code") will print a lot of logs as follows when Ethernet
> > > cable is not connected:
> > > 
> > > [    4.473105] SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110
> > > 
> > > So fix it by read_poll_timeout().
> > 
> > Do you have a more detailed explanation of what is going on here?
> > 
> > After a lot of thought, i think i can see how this happens. But the
> > commit message should really spell out why this is the correct fix.
> >
> Hi Andrew:
> 
> Kevin report a bug for me in link[1], I check the Commit 7ae7ad2f11ef47
> ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code") and
> found it change the original behavior in smsc driver. It does not has
> any error message whether it is timeout or phy_read fails, but this Commit
> will changed it and will print some error messages by
> phy_read_poll_timeout() when it is timeout or phy_read fails. so use the
> read_poll_timeout() to replace phy_read_poll_timeout() to fix this
> issue. the read_poll_timeout() does not print any log when it goes
> wrong.
> 
> the original codes is that:
> 
> 	/* Wait max 640 ms to detect energy */
> 	for (i = 0; i < 64; i++) {
> 	        /* Sleep to allow link test pulses to be sent */
> 	        msleep(10);
> 	        rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> 	        if (rc < 0)
> 	                return rc;
> 	        if (rc & MII_LAN83C185_ENERGYON)
> 	                break;
> 	}
> 
> Commit 7ae7ad2f11ef47 modify it as this:
> 
> 	phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS,
> 	                      rc & MII_LAN83C185_ENERGYON, 10000,
> 	                      640000, true);
> 	if (rc < 0)
> 	        return rc;
> 
> the phy_read_poll_timeout() will print a error log by phydev_err()
> when timeout or rc < 0. read_poll_timeout() just return timeout
> error and does not print any error log.
> 
> #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
>                                 timeout_us, sleep_before_read) \
> ({ \
>         int __ret = read_poll_timeout(phy_read, val, (cond) || val < 0, \
>                 sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
>         if (val <  0) \
>                 __ret = val; \
>         if (__ret) \
>                 phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
>         __ret; \
> })
> 
> So use read_poll_timeout Use read_poll_timeout() to be consistent with the
> original code.

You have explained what the change does. But not why it is
needed. What exactly is happening. To me, the key thing is
understanding why we get -110, and why it is not an actual error we
should be reporting as an error. That is what needs explaining.

And once that is understood, i think we might be looking at a
different solution.

       Andrew
