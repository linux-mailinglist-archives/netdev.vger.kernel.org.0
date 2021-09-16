Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D156040EDA4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbhIPXAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 19:00:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhIPXAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 19:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EALWNsdUnnujqAY0lwOE0RlGuTMq4D5ZAaUqN0CyhGM=; b=Zytk3eX250urKq5ilalQ0LtFeW
        kToskegWeKNpcUM3L0vsR0lN1lzGkxigvSiIeYNA6ilQfGeVbLo4w5wfrQstijdgXl5S4ep80NB0O
        KdJAeMJFKS0O08UasR35rdyOnqNtacUFuGAVCG76d4ZH415VwQIRQo28C40r71EsuXOk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mR0Lb-006z41-ME; Fri, 17 Sep 2021 00:59:15 +0200
Date:   Fri, 17 Sep 2021 00:59:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Walter Stoll <Walter.Stoll@duagon.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [BUG] net/phy: ethtool versus phy_state_machine race condition
Message-ID: <YUPMQ1HZDBEELnz0@lunn.ch>
References: <0a11298161d641eb8bd203daeac38db1@chdua14.duagon.ads>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a11298161d641eb8bd203daeac38db1@chdua14.duagon.ads>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 01:08:21PM +0000, Walter Stoll wrote:
> Effect observed
> ---------------
> 
> During final test of one of our products, we use ethtool to set the mode of
> the ethernet port eth0 as follows:
> 
> ethtool -s eth0 speed 100 duplex full autoneg off
> 
> However, very rarely the command does not work as expected. Even though the
> command executes without error, the port is not set accordingly. As a result,
> the test fails.
> 
> We observed the effect with kernel version v5.4.138-rt62. However, we think
> that the most recent kernel exhibits the same behavior because the structure of
> the sources in question (see below) did not change. This also holds for the non
> realtime kernel.
> 
> 
> Root cause
> ----------
> 
> We found that there exists a race condition between ethtool and the PHY state-
> machine.
> 
> Execution of the ethtool command involves the phy_ethtool_ksettings_set()
> function being executed, see 
> https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L315
> 
> Here the mode is stored in the phydev structure. The phy_start_aneg() function
> then takes the mode from the phydev structure and finally stores the mode into
> the PHY.
> 
> However, the phy_ethtool_ksettings_set() function can be interrupted by the
> phy_state_machine() worker thread. If this happens just before the
> phy_start_aneg() function is called, then the new settings are overwritten by
> the current settings of the PHY. This is because the phy_state_machine()
> function reads back the PHY settings, see
> https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L918
> 
> This is exactly what happens in our case. We were able to proof this by
> inserting various dev_info() calls in the code. 

Hi Walter

This makes sense.  We have a similar problem with MAC code calling
phy_read_status() without holding the PHY lock as well. I have some
patches for that, which i need to rebase. I will see if your proposed
fixed can be added to that, or if it should be a separate series.

      Andrew
