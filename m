Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0736A3B3292
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhFXP3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:29:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:38217 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhFXP3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 11:29:42 -0400
IronPort-SDR: t7UdfbwSASiGnw2+CwpjXK+KcQvzcAw/21hvm7hWHBlPvI9jEJ9Gsk7kI5gJ++qlOlt1on0Ov5
 mgADSQ+nyM+Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="205665539"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="205665539"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 08:27:23 -0700
IronPort-SDR: ynKQXvHzZ7K+f9HdcO1tePRbh646k7H8JexHM39k5E5uAKouwUsF8ZOfjWNzrEvkjVhAdC8jR9
 wuQHHuo9Qdvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="557365578"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jun 2021 08:27:22 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0396C5807E2;
        Thu, 24 Jun 2021 08:27:19 -0700 (PDT)
Date:   Thu, 24 Jun 2021 23:27:17 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ling Pei Lee <pei.lee.ling@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Behun <marek.behun@nic.cz>,
        weifeng.voon@intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210624152716.GA29313@linux.intel.com>
References: <20210623130929.805559-1-pei.lee.ling@intel.com>
 <20210623200618.GO22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623200618.GO22278@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, Jun 23, 2021 at 09:06:18PM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 23, 2021 at 09:09:29PM +0800, Ling Pei Lee wrote:
> > +static void mv2110_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
> > +{
> > +	int ret = 0;
> 
> This initialiser doesn't do anything.
> 
> > +
> > +	wol->supported = WAKE_MAGIC;
> > +	wol->wolopts = 0;
> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
> > +
> > +	if (ret & MV_V2_WOL_MAGIC_PKT_EN)
> > +		wol->wolopts |= WAKE_MAGIC;
> 
> You need to check whether "ret" is a negative number - if phy_read_mmd()
> returns an error, this test could be true or false. It would be better
> to have well defined behaviour (e.g. reporting that WOL is disabled?)
> 
> > +		/* Reset the clear WOL status bit as it does not self-clear */
> > +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> > +					 MV_V2_WOL_CTRL,
> > +					 MV_V2_WOL_CLEAR_STS);
> > +
> > +		if (ret < 0)
> > +			return ret;
> > +	} else {
> > +		/* Disable magic packet matching & reset WOL status bit */
> > +		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
> > +				     MV_V2_WOL_CTRL,
> > +				     MV_V2_WOL_MAGIC_PKT_EN,
> > +				     MV_V2_WOL_CLEAR_STS);
> > +
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> > +					 MV_V2_WOL_CTRL,
> > +					 MV_V2_WOL_CLEAR_STS);
> > +
> > +		if (ret < 0)
> > +			return ret;
> 
> This phy_clear_bits_mmd() is the same as the tail end of the other part
> of the if() clause. Consider moving it after the if () { } else { }
> statement...
> 
> > +	}
> > +
> > +	return ret;
> 
> and as all paths return "ret" just do:
> 
> 	return phy_clear_bits_mmd(...
> 
> I will also need to check whether this is the same as the 88x3310, but
> I'm afraid I don't have the energy this evening - please email me a
> remind to look at this tomorrow. Thanks.
>

Shall we add this for the 88x3310 as well?

BR,
 VK 
