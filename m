Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1C340A06
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhCRQV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhCRQVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:21:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CADBC06174A;
        Thu, 18 Mar 2021 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LyWJyF9AcLRccJGAGBJ5odsKCObIjdkDuXB2zFkgClI=; b=aQ2VYcqIz0z6Ld0Iyl9983DBw
        2C52uB0onu8TV5PPxwSqWA4JpLR422RS0wRTjhHVUMLQYGESB1902Q29jjQL9g97OC+wrkl/sxD7T
        uDZhx5T9d/rUzlp8DmnBoURAVPSgsRpkFMIeldm9XZSbOvSUx2Erum549IWFT0ia2hk4lWn2gtSzQ
        1ncG2YJyD8wfKdRjcYm9MnRJMg2FfL2loIEQ+zW2R22k7JMIplJAb8z2suxjA+jGB1ed0d5+3XMg5
        GmzZsCsQmr0xZ/sMouwGjp8emXb/6DYPWmBJtorOpa/+vuKcTSzpBZi3IX6TgrzknwdwTLkvmcouS
        tzffBdZIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51442)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lMvOl-0003Xa-1E; Thu, 18 Mar 2021 16:21:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lMvOi-0008BC-KT; Thu, 18 Mar 2021 16:21:20 +0000
Date:   Thu, 18 Mar 2021 16:21:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Message-ID: <20210318162120.GR1463@shell.armlinux.org.uk>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
 <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 09:02:22AM -0700, Florian Fainelli wrote:
> On 3/18/2021 6:25 AM, Heiner Kallweit wrote:
> > On 18.03.2021 10:09, Wong Vee Khee wrote:
> >> When using Clause-22 to probe for PHY devices such as the Marvell
> >> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
> >> which caused the PHY framework failed to attach the Marvell PHY
> >> driver.
> >>
> >> Fixed this by adding a check of PHY ID equals to all zeroes.
> >>
> > 
> > I was wondering whether we have, and may break, use cases where a PHY,
> > for whatever reason, reports PHY ID 0, but works with the genphy
> > driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
> > the patch may break the fixed phy.
> > Having said that I think your patch is ok, but we need a change of
> > the PHY ID reported by swphy_read_reg() first.
> > At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
> > should be sufficient. This value shouldn't collide with any real world
> > PHY ID.
> 
> It most likely would not, but it could be considered an ABI breakage,
> unless we filter out what we report to user-space via SIOGCMIIREG and
> /sys/class/mdio_bus/*/*/phy_id
> 
> Ideally we would have assigned an unique PHY OUI to the fixed PHY but
> that would have required registering Linux as a vendor, and the process
> is not entirely clear to me about how to go about doing that.

Doesn't that also involve yearly fees?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
