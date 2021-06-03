Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C839239A46E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhFCPXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:23:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhFCPXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 11:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EJB3hERcvzlO0j/mnSaDiQbavL2iDvOE10Gk1LUZnk4=; b=IO4bu8yB+TLOCkMBc+1Kp0Mcof
        mPUjXWSctTkzUlh+JNFJedIgqI0CbzXfbBVYYJ3ygV+VVM1wR66Z+Kq/oGANJR18A+vSm1XCOqzHK
        7kS8LJDk/Cd/QxYoXgVrt655xE3dhGjBInrTRMSGTC2CJARdjQScEsrVqjiCRCoKf46g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lopA0-007dpV-2K; Thu, 03 Jun 2021 17:21:28 +0200
Date:   Thu, 3 Jun 2021 17:21:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLjzeMpRDIUV9OAI@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 03:10:31PM +0000, Liang Xu wrote:
> On 3/6/2021 5:17 pm, Russell King (Oracle) wrote:
> >
> > > +static int gpy_config_init(struct phy_device *phydev)
> > > +{
> > > + int ret, fw_ver;
> > > +
> > > + /* Show GPY PHY FW version in dmesg */
> > > + fw_ver = phy_read(phydev, PHY_FWV);
> > > + if (fw_ver < 0)
> > > + return fw_ver;
> > > +
> > > + phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
> > > + (fw_ver & PHY_FWV_REL_MASK) ? "release" : "test");
> >
> > Does this need to print the firmware version each time config_init()
> > is called? Is it likely to change beyond? Would it be more sensible
> > to print it in the probe() method?
> 
> The firmware version can change in device with different firmware 
> loading mechanism.
> 
> I moved the print to probe and tested a few devices, found in some cases 
> it did not print the active version number.

That actually sounds like a real problem. If it is still in the
bootloader when the driver is probed, the driver should not be writing
any configuration registers until the real image is running. So it
sounds like you need a probe function which checks if the PHY has
finished booting, and if not, wait for the real firmware to start
running.

	Andrew
