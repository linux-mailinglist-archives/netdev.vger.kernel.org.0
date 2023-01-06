Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1573A6601BE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbjAFODj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjAFODg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:03:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296161ADA7
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AWkxn9TiyaOQivLTKREQp74OcAF242cAxx4LEIi1Ndo=; b=aSClYVoCjLbmEs/Wk/nFeqtB6v
        S6pMsRXIlBs8izUGN/bPjdp6qCvoL/rYFFGO7+Ric5Ltx2yhhGUxs4hY1tsFN1hiWyEjYp2G25+T/
        PIJ31vIxEh7SxZEpE0M2iWOtUvRiyhrr22PwJ9ZtyPyrSzv2uOLFHnfCzJbooiXa4N8U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDnJl-001L3g-Nm; Fri, 06 Jan 2023 15:03:33 +0100
Date:   Fri, 6 Jan 2023 15:03:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
Message-ID: <Y7gqNfpRvOpeFPEN@lunn.ch>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ee2f626bab3481697b71c58091e7def@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 06:53:12AM +0000, Hau wrote:
> > > > rtl8168h has an application that it will connect to rtl8211fs
> > > > through mdi interface. And rtl8211fs will connect to fiber through serdes
> > interface.
> > > > In this application, rtl8168h revision id will be set to 0x2a.
> > > >
> > > > Because rtl8211fs's firmware will set link capability to 100M and
> > > > GIGA when link is from off to on. So when system suspend and wol is
> > > > enabled, rtl8168h will speed down to 100M (because rtl8211fs
> > > > advertise 100M and GIGA to rtl8168h). If the link speed between
> > rtl81211fs and fiber is GIGA.
> > > > The link speed between rtl8168h and fiber will mismatch. That will
> > > > cause wol fail.
> > > >
> > > > In this patch, if rtl8168h is in this kind of application, driver
> > > > will not speed down phy when wol is enabled.
> > > >
> > > I think the patch title is inappropriate because WoL works normally on
> > > RTL8168h in the standard setup.
> > > What you add isn't a fix but a workaround for a firmware bug in RTL8211FS.
> > > As mentioned in a previous review comment: if speed on fibre side is
> > > 1Gbps then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.
> > > Last but not least the user can still use e.g. ethtool to change the
> > > speed to 100Mbps thus breaking the link.
> > 
> > I agree with Heiner here. I assume you cannot fix the firmware?
> > 
> > So can we detect the broken firmware and correctly set
> > phydev->advertising? That will fix WoL and should prevent the user
> > from using ethtool to select a slower speed.
> > 
> It is a rtl8211fs's firmware bug. Because in this application it will support both 100M and GIGA
> fiber module, so it cannot just set phydev->advertising to 100M or GIGA. We  may need to 
> use bit-bang MDIO to detect fiber link speed and set phydev->advertising properly. But it will
> let this patch become more complicated.

You mean you will read the EEPROM in the SFP to determine what it
supports? If so, please use phylink, and the SFP driver, which will do
this for you.

     Andrew
