Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A1F3BE063
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 02:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGGBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 21:00:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGA76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 20:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PFdO1IFb7nHREoIMKuJxQUnPYfqQhmKfdkJlDTPz+ZQ=; b=tz9WkcgcRhBbek65RGv/T9WCEu
        hNwvIC6w94JsukHcQsCPX4aTw7ceYwS6/p3qF8h3pOaKZeQl+EsRN4cd6V5fC4o8WPAEc0RtidtDd
        EMQK9dRiaOhLD1BcicR85FQYS/tMCF+1V7NyIOZDuuklSbxZu71f3lOmv3SMlns0NBuo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m0vsD-00CRuE-C5; Wed, 07 Jul 2021 02:57:09 +0200
Date:   Wed, 7 Jul 2021 02:57:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is
 enabled in shutdown
Message-ID: <YOT75ZvoB0qnsK6W@lunn.ch>
References: <20210706090209.1897027-1-pei.lee.ling@intel.com>
 <YORXMSmvqwYg7QA9@lunn.ch>
 <CO1PR11MB4771EF640CBB88E9D96693FFD51A9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771EF640CBB88E9D96693FFD51A9@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 12:36:30AM +0000, Ismail, Mohammad Athari wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, July 6, 2021 9:14 PM
> > To: Ling, Pei Lee <pei.lee.ling@intel.com>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > <linux@armlinux.org.uk>; davem@davemloft.net; Jakub Kicinski
> > <kuba@kernel.org>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Voon, Weifeng
> > <weifeng.voon@intel.com>; vee.khee.wong@linux.intel.com; Wong, Vee Khee
> > <vee.khee.wong@intel.com>; Ismail, Mohammad Athari
> > <mohammad.athari.ismail@intel.com>
> > Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is enabled
> > in shutdown
> > 
> > On Tue, Jul 06, 2021 at 05:02:09PM +0800, Ling Pei Lee wrote:
> > > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> > >
> > > PHY WOL requires WOL interrupt event to trigger the WOL signal in
> > > order to wake up the system. Hence, the PHY driver should not disable
> > > the interrupt during shutdown if PHY WOL is enabled.
> > 
> > If the device is being used to wake the system up, why is it being shutdown?
> > 
> 
> Hi Andrew,
> 

> When the platform goes to S5 state (ex: shutdown -h now), regardless
> PHY WOL is enabled or not, phy_shutdown() is called. So, for the
> platform that support WOL from S5, we need to make sure the PHY
> still can trigger WOL event. Disabling the interrupt through
> phy_disable_interrupts() in phy_shutdown() will disable WOL
> interrupt as well and cause the PHY WOL not able to trigger.

This sounds like a firmware problem. If linux is shutdown, linux is
not controlling the hardware, the firmware is. So the firmware should
probably be configuring the PHY after Linux powers off.

If Linux is suspended, then Linux is still controlling the hardware,
and it will not shutdown the PHY.

    Andrew
