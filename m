Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9488C11D44B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfLLRnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:43:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33734 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730074AbfLLRnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WRjH8WMeEKdXiTwyuxwoErP0BKRnxF3dutj7tVKZhjg=; b=wuvSdWKMYsTWpl0WZKBJi4R6Q
        iq4+brgwd2ur5nctj6Zm7fAZPUzraUzv4Ss6Hf0jWyaISIC/oQajEd1LAV8MCXLLukhSnXV7fHqep
        PLGG+xsvLwvJLVvkuoFCAShRLmyGjdKdRLrCRgfM7wO3nEVLExrT3KNERfaff3c8SBeAXeseE+P/8
        BfTGbvZ0fidag9PermSdVOwykMfdHuztEHbWTBgsBibnrf8C5iY4SSej+NJ7GHvrttweih1mR6IQL
        22GvL9nCUD0zvQTZ2d7XSdjV9Sg1M90rvAXo8qbpwfdwxhNwzw1ais7Ig370nEja+FzQt+F+vZGmN
        3lw/MHQQw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47934)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifSUa-0008Bz-BF; Thu, 12 Dec 2019 17:43:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifSUX-00075I-EC; Thu, 12 Dec 2019 17:43:09 +0000
Date:   Thu, 12 Dec 2019 17:43:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] improve clause 45 support in phylink
Message-ID: <20191212174309.GM25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These three patches improve the clause 45 support in phylink, fixing
some corner cases that have been noticed with the addition of SFP+
NBASE-T modules, but are actually a little more wisespread than I
initially realised.

The first issue was spotted with a NBASE-T PHY on a SFP+ module plugged
into a mvneta platform. When these PHYs are not operating in USXGMII
mode, but are in a single-lane Serdes mode, they will switch between
one of several different PHY interface modes.

If we call the MAC validate() function with the current PHY interface
mode, we will restrict the supported and advertising masks to the link
modes that the current PHY interface mode supports. For example, if we
determine that we want to start the PHY with an interface mode of
2500BASE-X, then this setup will restrict the advertisement and
supported masks to 2.5G speed link modes.

What we actually want for these PHYs is to allow them to support any
link modes that the PHY supports _and_ the MAC is also capable of
supporting. Without knowing the details of the PHY interface modes that
may be used, we can do this by using PHY_INTERFACE_MODE_NA to validate
and restrict the link modes to any that the MAC supports.

mvpp2 with the 88X3310 PHY avoids this problem, because the validate()
implementation allows all MAC supported speeds not only for
PHY_INTERFACE_MODE_NA, but also for XAUI and 10GKR modes.

The first patch addresses this; current MAC drivers should continue to
work as-is, but there will be a follow-on patch to fixup at least
mvpp2.

The second issue addresses a very similar problem that occurs when
trying to use ethtool to alter the advertisement mask - we call
the MAC validate() function with the current interface mode, the
current support and requested advertisement masks. This immediately
restricts the advertisement in the same way as the above.

This patch series addresses both issues, although the patches are not
in the above order.

Antoine - please can you check that there are no other reasons for
the mvpp2 code to be the way it was?  Thanks.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  20 ++++-
 drivers/net/phy/phylink.c                       | 106 +++++++++++++++---------
 2 files changed, 82 insertions(+), 44 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
