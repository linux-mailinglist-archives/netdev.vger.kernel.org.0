Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C069C4784C2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 06:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhLQF5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 00:57:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:47785 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhLQF5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 00:57:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="300462590"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="300462590"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 21:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="465011786"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 21:57:35 -0800
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6ACF4580127;
        Thu, 16 Dec 2021 21:57:32 -0800 (PST)
Date:   Fri, 17 Dec 2021 13:57:29 +0800
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
Message-ID: <20211217055729.GA14835@linux.intel.com>
References: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 01:11:40PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> This series updates xpcs and stmmac for the recent changes to phylink
> to better support split PCS and to get rid of private MAC validation
> functions.
> 
> This series is slightly more involved than other conversions as stmmac
> has already had optional proper split PCS support.
> 
> The patches:
> 
> 1) Provide a function to query the xpcs for the interface modes that
>    are supported.
> 
> 2) Populates the MAC capabilities and switches stmmac_validate() to use
>    phylink_get_linkmodes(). We do not use phylink_generic_validate() yet
>    as (a) we do not always have the supported interfaces populated, and
>    (b) the existing code does not restrict based on interface. There
>    should be no functional effect from this patch.
> 
> 3) Populates phylink's supported interfaces from the xpcs when the xpcs
>    is configured by firmware and also the firmware configured interface
>    mode. Note: this will restrict stmmac to only supporting these
>    interfaces modes - stmmac maintainers need to verify that this
>    behaviour is acceptable.
> 
> 4) stmmac_validate() tail-calls xpcs_validate(), but we don't need it to
>    now that PCS have their own validation method. Convert stmmac and
>    xpcs to use this method instead.
> 
> 5) xpcs sets the poll field of phylink_pcs to true, meaning xpcs
>    requires its status to be polled. There is no need to also set the
>    phylink_config.pcs_poll. Remove this.
> 
> 6) Switch to phylink_generic_validate(). This is probably the most
>    contravertial change in this patch set as this will cause the MAC to
>    restrict link modes based on the interface mode. From an inspection
>    of the xpcs driver, this should be safe, as XPCS only further
>    restricts the link modes to a subset of these (whether that is
>    correct or not is not an issue I am addressing here.) For
>    implementations that do not use xpcs, this is a more open question
>    and needs feedback from stmmac maintainers.
> 
> Please review and test this series. Thanks!
> 

Tested this patch series on my Intel Elkhart Lake setup with Marvell
88E1510 PHY. 

Everything works perfectly!

>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 144 ++++++----------------
>  drivers/net/pcs/pcs-xpcs.c                        |  41 +++---
>  include/linux/pcs/pcs-xpcs.h                      |   3 +-
>  3 files changed, 67 insertions(+), 121 deletions(-)
