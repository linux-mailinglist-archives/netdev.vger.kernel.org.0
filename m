Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A14E299
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfFUJDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:03:24 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38242 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFUJDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z/vrGL+hnN6XNQ43GJSsHqsTwEI017tyqqk0CCrmcjg=; b=hHLAXTyTKk+f6P3ai3jU2yJL1
        TjZE8LsMp5pT6hxylcX6uRTXh+9EymIy0MYL8eRgCfX+Ha/2LQ8twWzpM3ou71le940xrTlTrYWTR
        Mnmx+WNjeCWcvSB6bHVzU8z32HthcD8oE8qhYxNlZKfYcBJ+rzbJ0KZHKjTMQMQPVxHMvlyHh2ghi
        Up+f8+gN4BbFtRCD14azsoFPdCewlgayeuMXFDSEreQJji2u9Yk7noToMCF4qfy9JrVteeOtTyvPb
        IEL8dIduaoRniyVBmi3NzCS6mBEVG/x7ZyZsEMfqf8tzPmrdQd/AZhzbmRH0LXEr3PmIGMDe+bJAb
        5/2tv8FDg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:58946)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1heFS0-00049H-3a; Fri, 21 Jun 2019 10:03:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1heFRy-00038K-2T; Fri, 21 Jun 2019 10:03:14 +0100
Date:   Fri, 21 Jun 2019 10:03:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v3 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190621090313.xuaqvmyxxrzxh5aw@shell.armlinux.org.uk>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <1561106090-8465-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561106090-8465-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 09:34:50AM +0100, Parshuram Thombare wrote:
> This patch add support for SGMII interface) and
> 2.5Gbps MAC in Cadence ethernet controller driver.

Also, I'm not sure that merely using PHY_INTERFACE_MODE_SGMII with a
speed of 2.5Gbps is really on for up-clocked SGMII.

Cisco SGMII is defined as running at a fixed 1.25Gbps with the control
word indicating whether the negotiated speed is 1G, 100M or 10M, and
the MAC and PHY expect symbols to be replicated the appropriate number
of times for the slower speeds.  Cisco SGMII as defined does not
support 2.5Gbps.

The same is true of 802.3z - this defines 1000BASE-X, but we also have
an up-clocked version which we use a separate phy interface mode for
when supporting 2.5Gbps, since it requires both ends to be configured
differently.  This appears to be the case with your 2.5Gbps up-clocked
SGMII - the MAC needs to be told to up-clock the link.

So, I'm wondering whether we need PHY_INTERFACE_MODE_2500SGMII, which
means that if the PHY automatically selects between 1G and 2.5G SGMII,
then it needs to automatically change its interface mode reported back
to the MAC - that is, providing it really _does_ use an up-clocked
2.5Gbps SGMII and doesn't actually switch to 2.5Gbps BASE-X instead.

Other PHYs (the 10G Marvell 88x3310) dynamically switch their MAC
facing interface between 10GBASE-R, 2500BASE-X and SGMII depending on
the negotiated link speed, so there is precedent for this already.

Finally, note that it is possible for a mismatched SGMII / BASE-X
link to come up and appear to work, but either end is going to be
interpreting the 16-bit control word differently, which is obviously
incorrect.

Please ensure that details such as "SGMII" vs "BASE-X" are as correct
as possible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
