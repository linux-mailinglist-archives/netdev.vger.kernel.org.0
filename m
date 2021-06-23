Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACCA3B214A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWTjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:39:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWTjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 15:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=T13J8AAOzye0vPE72zOkmKwgCqb3X8Y2nKlK460R0cY=; b=l4RlYytU80yLAKSl4Xth6DXqf0
        BmquKFSwgp7FHexz1xEs42MFaZDR7EFJin0KXyMgWtuFumuVvBbjJAiTkC6JAmrbMfFEdml5XNu8v
        16qklndSkA1nzTKlhrYx6jhQk9vtS7dIJRn+GFIut7ZrfiZnRRzOHU918mhAh8bWEwDw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw8fl-00AsjI-68; Wed, 23 Jun 2021 21:36:29 +0200
Date:   Wed, 23 Jun 2021 21:36:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Message-ID: <YNONPZAfmdyBMoL5@lunn.ch>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com>
 <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 10:06:44AM +0000, Voon, Weifeng wrote:
> > > From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> > >
> > > After PHY received a magic packet, the PHY WOL event will be triggered
> > > then PHY WOL event interrupt will be disarmed.
> > > Ethtool settings will remain with WOL enabled after a S3/S4 suspend
> > > resume cycle as expected. Hence,the driver should reconfigure the PHY
> > > settings to reenable/disable WOL depending on the ethtool WOL settings
> > > in the resume flow.
> > 
> > Please could you explain this a bit more? I'm wondering if you have a
> > PHY driver bug. PHY WOL should remain enabled until it is explicitly
> > disabled.
> > 
> > 	Andrew
> 
> Let's take Marvell 1510 as example. 
> 
> As explained in driver/net/phy/marvell.c
> 1773 >------->-------/* If WOL event happened once, the LED[2] interrupt pin
> 1774 >------->------- * will not be cleared unless we reading the interrupt status
> 1775 >------->------- * register. 
> 
> The WOL event will not able trigger again if the driver does not clear
> the interrupt status.
> Are we expecting PHY driver will automatically clears the interrupt
> status rather than trigger from the MAC driver?

So you are saying the interrupt it getting discarded? I would of
though it is this interrupt which brings to system out of suspend, and
it should trigger the usual action, i.e. call the interrupt
handler. That should then clear the interrupt.

	 Andrew
