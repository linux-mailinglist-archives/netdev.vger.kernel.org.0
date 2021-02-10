Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B38316491
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBJLEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhBJLCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:02:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93511C061786;
        Wed, 10 Feb 2021 03:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dxGLKzUoElrl+nJzx5pPiJMsCC9IQ3Av/N7o9w/5Wbk=; b=nu5w8im4bFs67sfrSbKMT0CLZ
        b1IWVQagzhHlXg72qekkHDZnkwvzE9xi8wwtmkCc5cRni8gy1Hlo+QBSG6wmy7vd5X+vVEqKfoaq+
        0cbDvD1B1Lb7ruc7Kw53ThxjFSeTxuN6ZusgPtyZA8LQZtljPs9D8YDCgDliH9ilYD87X4qXWtLPx
        8qMJP8XrUlSDMb/PE/3AE/89MH7L7Am5SNRSsTegmGafvrXzK8JhxZSSad6DlF505912ftKIADnwg
        D8hlwSfswmvEYBKHHDfYHBdjsBFn7Y0jfIHPTMnSUxVh5aT8B6512jewi+ozmJVtF8zL3HVZYdBX9
        emVLwOPRA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41570)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9nFm-0004YR-AK; Wed, 10 Feb 2021 11:01:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9nFl-00050F-4P; Wed, 10 Feb 2021 11:01:49 +0000
Date:   Wed, 10 Feb 2021 11:01:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
Message-ID: <20210210110148.GT1463@shell.armlinux.org.uk>
References: <20210209163852.17037-1-michael@walle.cc>
 <YCM8JiO4FfKx5ECo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCM8JiO4FfKx5ECo@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:51:34AM +0100, Andrew Lunn wrote:
> This is a general comment, not a problem specific to this patch.
> 
> There is some interesting race conditions here. The marvell driver
> first checks the fibre page and gets the status of the fiber port. As
> you can see from the hunk above, it clears out pause, duplex, speed,
> sets port to PORT_FIBRE, and then reads the PHY registers to set these
> values. If link is not detected on the fibre, it swaps page and does
> it all again, but for the copper port. So once per second,
> phydev->port is going to flip flop PORT_FIBER->PORT_TP, if copper has
> link.
> 
> Now, the read_status() call into the driver should be performed while
> holding the phydev->lock. So to the PHY state machine, this flip/flop
> does not matter, it is atomic with respect to the lock. But
> phy_ethtool_ksettings_get() is not talking the lock. It could see
> speed, duplex, and port while they have _UNKNOWN values, or port is
> part way through a flip flop. I think we need to take the lock here.
> phy_ethtool_ksettings_set() should also probably take the lock.

phy_ethtool_ksettings_get() needs to take the lock, otherwise it could
read the phy_device members in the middle of an update. This is likely
a long-standing phylib bug.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
