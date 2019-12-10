Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE7118EBA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfLJRPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:15:42 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54616 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbfLJRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZUnw0X5A+uHhgnIeNvGvg+7YdV/Pbp4+1cZs5PGOvZg=; b=TGJwzClYEKlH4qGJ2lqu8/0ln
        sXCGDFMyMqHqBYDZyT1Wma1hI+1OKHSB70mT+SsOka8Ua56qhFv0Mr98iOR6scOL9CoCuq54NtRpS
        Q/kAA4nvO2MmL9ANQbxqF7M2aR4UviCFE7u1Q1pjY9tvlZLr0CFavR/Fgi74QQXezm3xZ7zuYoYy3
        xu6rbJJzy/e+Gfidunzia9EzbZy8XgAuzP1B1b/80qdZqN3jGzKHcKSjxBgptISKFmebT3YMc/lQL
        VGW4cFx9JRGPRVa2SJwphlw+c1wov7hPwAJG4MD7CvCV6voWoMX5v9lrkm46Hui5xrx5J2Ul6FYOM
        tw4SI7zxg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47016)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iej6o-0002nb-2g; Tue, 10 Dec 2019 17:15:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iej6n-0004oj-02; Tue, 10 Dec 2019 17:15:37 +0000
Date:   Tue, 10 Dec 2019 17:15:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: phylib's new dynamic feature detection seems too early
Message-ID: <20191210171536.GW25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Back in dcdecdcfe1fc ("net: phy: switch drivers to use dynamic feature
detection"), Heiner switched a bunch of PHYs over to using his
wonderful new idea of reading the PHY capabilities from the registers.
However, this is flawed.

The features are read from the PHY shortly after the PHY driver is
bound to the device, while the PHY is in its default pin-strapped
defined mode. PHYs such as the 88E1111 set their capabilities according
to the pin-strapped host interface mode.

If the 88E1111 is pin-strapped for a 1000base-X host interface, then it
indicates that it is not capable of 100M or 10M modes - which is
entirely sensible.

However, the SFP support will switch the PHY into SGMII mode, where the
PHY will support 100M and 10M modes. Indeed, reading the PHY registers
using mii-diag after initialisation reports that the PHY supports these
speeds.

This switch happens in the Marvell PHY driver when the config_init()
method is called, via phy_init_hw() and phy_attach_direct() - which
is where the MAC driver configures the PHY for its requested interface
mode.

Therefore, the features dynamically read from the PHY are entirely
meaningless, until the PHY interface mode has been properly set.

This means that SFP modules, such as Champion One 1000SFPT and a
multitude of others which default to a 1000base-X interface end up
only advertising 1000baseT despite being switched to SGMII mode and
actually supporting 100M and 10M speeds - and that can't be changed
via ethtool as the support mask doesn't allow the other speeds.

Thoughts how to get around this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
