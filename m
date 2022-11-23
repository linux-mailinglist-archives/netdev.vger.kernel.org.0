Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E9C635FA7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiKWNbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiKWNat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:30:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8154F8C7AE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XATNKwsK7P4099QjfNthxYrziF00WZy9uRXZWFnsFQs=; b=Yi1iGMR1XxH3VLSM3xpar6r9gp
        1Ce68AcgQhR3F3TxN5yDj80lLJLjDEVGz66G7+9DHWllYSIdBRULS9TqH2ivsvOoZuyy5N5gb2uQ4
        Un9yh3q3xA394bd40TwpPWriQaTC4lGoxFLXBv/Dt31P2TnhHjLfdrtbd/WKF5DvG5aMcaB1rEDxt
        a4YjfakEAygdDEje8G1IEEqhxRPRIgYCoZFpZqomQstDZB6q02h+8yBJ5cWxsBZ6mclr3uGGWb//m
        Vle/pCiOujHd4DyC8XgLeUKjrMhA5N3KVgmiulperAO9538K+IEsILfqBo1Dk4MV8g+O9WPqL0CuW
        6KexbGew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35406)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxpXH-0002uA-6F; Wed, 23 Nov 2022 13:11:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxpX9-0004K8-Ui; Wed, 23 Nov 2022 13:11:23 +0000
Date:   Wed, 23 Nov 2022 13:11:23 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 12:08:11PM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 22, 2022 at 09:36:59PM +0200, Vladimir Oltean wrote:
> > I think we're in agreement, but please let's wait until tomorrow, I need
> > to take a break for today.
> 
> I think we do have a sort of agreement... but lets give this a go. The
> following should be sufficient for copper SFP modules using the 88E1111
> PHY. However, I haven't build-tested this patch yet.
> 
> Reading through the documentation has brought up some worms in this
> area. :(
> 
> It may be worth printing the fiber page BMCR and extsr at various
> strategic points in this driver and reporting back if things don't
> seem to be working right for your modules. In the mean time, I'll try
> to see how the modules in the Honeycomb appear to be setup at power-up
> and after the driver has configured the PHY... assuming I left both
> MicroUSBs connected and the board has a network connection via the
> main ethernet jack.

Unfortunately, I don't have a SFP with an 88e1111 plugged in, only the
bcm84881, so I can't test my patch remotely. However, it builds fine
when the appropriate TIMEOUT definition is added.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
