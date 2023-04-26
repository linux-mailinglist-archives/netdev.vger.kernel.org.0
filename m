Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331E16EF513
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbjDZNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbjDZNHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:07:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A032D7E;
        Wed, 26 Apr 2023 06:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DZNqjfdQOuqzJ3kVZRYTgiz2unGBFuvW0+zVW2+EbFs=; b=FTANkconCKruRK6Aa2GGuNgRy1
        7md18qyPgkpMtOjioDdwbQOBHFw55+o6q5ZnR1g+lpUGuGmryc3iQPv5j9AGnc07DWea/dIk/7i07
        V0KVOJeFgsFeAw+gjBIKJmMcIfkGXauI15NNpX751iD4xfLw+tzhrgIPW5yFp5xWnZ0U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1preSH-00BGpF-Fm; Wed, 26 Apr 2023 14:41:05 +0200
Date:   Wed, 26 Apr 2023 14:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [RFC PATCH 2/2] net: phy: dp83869: fix mii mode when rgmii strap
 cfg is used
Message-ID: <5a2bc044-5fb0-4162-a75a-24c94f8ed3f7@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-3-s-vadapalli@ti.com>
 <cbbedaab-b2bf-4a37-88ed-c1a8211920e9@lunn.ch>
 <99932a4f-4573-b80b-080b-7d9d3f57bef0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99932a4f-4573-b80b-080b-7d9d3f57bef0@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> @@ -692,8 +692,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
> >>  	/* Below init sequence for each operational mode is defined in
> >>  	 * section 9.4.8 of the datasheet.
> >>  	 */
> >> +	phy_ctrl_val = dp83869->mode;
> >> +	if (phydev->interface == PHY_INTERFACE_MODE_MII)
> >> +		phy_ctrl_val |= DP83869_OP_MODE_MII;
> > 
> > Should there be some validation here with dp83869->mode?
> > 
> > DP83869_RGMII_COPPER_ETHERNET, DP83869_RGMII_SGMII_BRIDGE etc don't
> > make sense if MII is being used. DP83869_100M_MEDIA_CONVERT and maybe
> > DP83869_RGMII_100_BASE seem to be the only valid modes with MII?
> 
> The DP83869_OP_MODE_MII macro corresponds to BIT(5) which is the RGMII_MII_SEL
> bit in the OP_MODE_DECODE register. If the RGMII_MII_SEL bit is set, MII mode is
> selected. If the bit is cleared, which is the default value, RGMII mode is
> selected. As pointed out by you, there are modes which aren't valid with MII
> mode. However, a mode which isn't valid with RGMII mode (default value of the
> RGMII_MII_SEL bit) also exists: DP83869_SGMII_COPPER_ETHERNET. For this reason,
> I believe that setting the bit when MII mode is requested shouldn't cause any
> issues.

If you say so. I was just thinking you could give the poor software
engineer a hint the hardware engineer has put on strapping resistors
which means the PHY is not going to work.

      Andrew
