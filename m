Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4F11E98B
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfLMRy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:54:29 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50410 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbfLMRy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XE/M3c9A/gAbAYTlIdY7YzGXQOHhm9oUXaSNdq3BmRk=; b=y4avUNPLiMPgelU3lNYMCE02T
        dqx8Gxw4R5Q0FtP7hSjki/JEFaG5UrqSW6S380qBVVxBN7IGEYOQcLRuUAW59ibneSBTEUPsaI3KA
        EuamEasKeQ9q5OgV/j0vvZ1ov2AYn5KDq2mbLwXoMd5qme8m5QdidvKHXTJQgCYlZn7oub2gpi1U8
        xM+sUz7jd+eAVFwndOiOh+vgIkFLW9SAVMRoSY95qhNWh4DLOv6b8uuiX/Az96gHM3WZWgi/z6yZg
        ea3cCmtYxBKJ51Gd1Mw6Sugjhm62yJgwpC8qbwZUT1wvXSnr7K6EunerxqUCxomM8t+rvolSkP+Sj
        CdhzLqzlA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48394)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifp8t-0006JK-Ck; Fri, 13 Dec 2019 17:54:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifp8p-00085P-8l; Fri, 13 Dec 2019 17:54:15 +0000
Date:   Fri, 13 Dec 2019 17:54:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] improve clause 45 support in phylink
Message-ID: <20191213175415.GW25745@shell.armlinux.org.uk>
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

v2: fix patch 3 missing 1G link modes for SGMII and RGMII interface
    modes.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  22 ++++-
 drivers/net/phy/phylink.c                       | 106 +++++++++++++++---------
 2 files changed, 84 insertions(+), 44 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
