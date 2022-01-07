Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA42148787C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbiAGNra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:47:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:41869 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238943AbiAGNrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641563245; x=1673099245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S6EB7K/mWQGJ4edWsfLqzaPrJ4f9R1H4mn7kwvidIW0=;
  b=YRzwauuXxfhE4s/PeIHjLRCdqvRhZPGpNTPtRQV2gqJS4ddVcNRNHyTL
   yOkGiM9lhOVdd8uzaE9ppf/W07Ba5b3HjYEDyNYEth6BDTS3E6XBN40uC
   xioOiRXqFjz/nuARWme4TSo8RPtASY4AtO6JozIgCfZUwqXZSYMm4PnDJ
   T53fdBTuEhD9vHgOvqEgVvTH0p/ezw6D7zAzcRa8N9uBN3kdfsRBkxZ23
   qzL0pWcyfiqk6sKp77cMAsg2jCto9I4JWsY17EqufxcknqktYIaw+2ylZ
   BJO2JBue73pZKS3LQA04BBDbfFibgNEE/LWQ5MXDtUNMk1w5uEuz2NR7O
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="242665027"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="242665027"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 05:47:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="513800161"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2022 05:47:23 -0800
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id D5238580806;
        Fri,  7 Jan 2022 05:47:20 -0800 (PST)
Date:   Fri, 7 Jan 2022 21:47:17 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [PATCH CFT net-next 0/6] net: stmmac/xpcs: modernise PCS support
Message-ID: <20220107134717.GA10144@linux.intel.com>
References: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
 <20211217055729.GA14835@linux.intel.com>
 <YdhCts9ZPMyzO8oX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdhCts9ZPMyzO8oX@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 01:40:06PM +0000, Russell King (Oracle) wrote:
> On Fri, Dec 17, 2021 at 01:57:29PM +0800, Wong Vee Khee wrote:
> > On Thu, Dec 16, 2021 at 01:11:40PM +0000, Russell King (Oracle) wrote:
> > > Hi,
> > > 
> > > This series updates xpcs and stmmac for the recent changes to phylink
> > > to better support split PCS and to get rid of private MAC validation
> > > functions.
> > > 
> > > This series is slightly more involved than other conversions as stmmac
> > > has already had optional proper split PCS support.
> > > 
> > > The patches:
> > > 
> > > 1) Provide a function to query the xpcs for the interface modes that
> > >    are supported.
> > > 
> > > 2) Populates the MAC capabilities and switches stmmac_validate() to use
> > >    phylink_get_linkmodes(). We do not use phylink_generic_validate() yet
> > >    as (a) we do not always have the supported interfaces populated, and
> > >    (b) the existing code does not restrict based on interface. There
> > >    should be no functional effect from this patch.
> > > 
> > > 3) Populates phylink's supported interfaces from the xpcs when the xpcs
> > >    is configured by firmware and also the firmware configured interface
> > >    mode. Note: this will restrict stmmac to only supporting these
> > >    interfaces modes - stmmac maintainers need to verify that this
> > >    behaviour is acceptable.
> > > 
> > > 4) stmmac_validate() tail-calls xpcs_validate(), but we don't need it to
> > >    now that PCS have their own validation method. Convert stmmac and
> > >    xpcs to use this method instead.
> > > 
> > > 5) xpcs sets the poll field of phylink_pcs to true, meaning xpcs
> > >    requires its status to be polled. There is no need to also set the
> > >    phylink_config.pcs_poll. Remove this.
> > > 
> > > 6) Switch to phylink_generic_validate(). This is probably the most
> > >    contravertial change in this patch set as this will cause the MAC to
> > >    restrict link modes based on the interface mode. From an inspection
> > >    of the xpcs driver, this should be safe, as XPCS only further
> > >    restricts the link modes to a subset of these (whether that is
> > >    correct or not is not an issue I am addressing here.) For
> > >    implementations that do not use xpcs, this is a more open question
> > >    and needs feedback from stmmac maintainers.
> > > 
> > > Please review and test this series. Thanks!
> > > 
> > 
> > Tested this patch series on my Intel Elkhart Lake setup with Marvell
> > 88E1510 PHY. 
> > 
> > Everything works perfectly!
> 
> Can I take that as a tested-by please?
> 

Sure.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL

> It would be good to get some feedback from other stmmac users, since I
> believe stmmac is used in multiple different configurations.
> 
> Thanks!
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
