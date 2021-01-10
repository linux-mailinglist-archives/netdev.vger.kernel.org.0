Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663092F0668
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 11:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbhAJKYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 05:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbhAJKYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 05:24:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C13C06179F
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RPORXYCMnXB05Z00Pe39JVYqyf2W16awM9oGZ8APQ4s=; b=g1f1pFg+VaftJDdiYg7vOltgl
        nI+cf+h4euqJfsH+9wtoAMvrblIIixyCAtplitf78wWVqonUHUGo7RNk37FNys2nPX8C5oUPfUw1m
        J9sZI2SyxofDG7sPXH94J5wlO5Brw+Qz8WVxaUhPaQ7vRFPbZdaxd7/JF4XONImVnpO49aH33J4WJ
        zTzWw5lIajMUlVyAfhQ3AV4bOsoH06oFZFuGq8tsdNyWErZXMCPvbWNTYtsIxf59M1f1sIOLTslYV
        h2VyrRzS8KURiT6lXlu67ualmBQHu0CErGg9ztcodU9/e0SMZerLOzs6vHOrRdqmt5LWvpiD5qU7Z
        li3mlJ3Aw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46106)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyXsO-0005kV-5R; Sun, 10 Jan 2021 10:23:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyXsM-00047V-Np; Sun, 10 Jan 2021 10:23:10 +0000
Date:   Sun, 10 Jan 2021 10:23:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, torii.ken1@fujitsu.com
Subject: Re: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <20210110102310.GD1551@shell.armlinux.org.uk>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110085221.5881-1-ashiduka@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:52:21PM +0900, Yuusuke Ashizuka wrote:
> RTL9000AA/AN as 100BASE-T1 is following:
> - 100 Mbps
> - Full duplex
> - Link Status Change Interrupt
> 
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>

Not a review comment on your patch, but, we really need to do
something with the way phylib handles configuration changes - we
have the current situation where config_aneg() _will_ get called
for PHYs like this that do not support autonegotiation if userspace
attempts to enable autoneg - there is nothing in
phy_ethtool_ksettings_set() that prevents this.

Returning an error from config_aneg() achieves nothing, and
resetting the settings in config_init() also does nothing to avoid
autonegotiation being enabled.

I think we need phy_ethtool_ksettings_set() to check whether
ETHTOOL_LINK_MODE_Autoneg_BIT is set in phydev->supported before
allowing the AUTONEG_ENABLE case.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
