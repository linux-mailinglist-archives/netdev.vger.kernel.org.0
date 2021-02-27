Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D8326AD6
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhB0Ayo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:54:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhB0Aym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 19:54:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFnrl-008gSc-0W; Sat, 27 Feb 2021 01:53:53 +0100
Date:   Sat, 27 Feb 2021 01:53:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net] net: phy: fix save wrong speed and duplex problem if
 autoneg is on
Message-ID: <YDmYIb0O5DZkL+X3@lunn.ch>
References: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 03:44:42PM +0800, Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> If phy uses generic driver and autoneg is on, enter command
> "ethtool -s eth0 speed 50" will not change phy speed actually, but
> command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
> has been set to 50 and no update later.
> 
> And duplex setting has same problem too.
> 
> However, if autoneg is on, phy only changes speed and duplex according to
> phydev->advertising, but not phydev->speed and phydev->duplex. So in this
> case, phydev->speed and phydev->duplex don't need to be set in function
> phy_ethtool_ksettings_set() if autoneg is on.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

I'm not sure, but i think this happens after

commit 51e2a3846eab18711f4eb59cd0a4c33054e2980a
Author: Trent Piepho <tpiepho@freescale.com>
Date:   Wed Sep 24 10:55:46 2008 +0000

    PHY: Avoid unnecessary aneg restarts
    
    The PHY's aneg is configured and restarted whenever the link is brought up,
    e.g. when DHCP is started after the kernel has booted.  This can take the
    link down for several seconds while auto-negotiation is redone.
    
    If the advertised features haven't changed, then it shouldn't be necessary
    to bring down the link and start auto-negotiation over again.
    
    genphy_config_advert() is enhanced to return 0 when the advertised features
    haven't been changed and >0 when they have been.
    
    genphy_config_aneg() then uses this information to not call
    genphy_restart_aneg() if there has been no change.

Before then, i think autoneg was unconditionally restarted, and so the
speed would get overwritten when autoneg completed. After this patch,
since autoneg is not being changed when only speed is set, autoneg is
not triggered.

	Andrew
