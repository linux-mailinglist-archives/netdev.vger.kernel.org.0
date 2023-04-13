Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F86E133E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDMRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDMRMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:12:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC5061AE;
        Thu, 13 Apr 2023 10:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qZBjjkpWuKi1r0GBA2teojwiJm6bWg0+K2xH5fvzenU=; b=4mPkFZoNCGiDrwJvFDwjpg020K
        sbwVLAxix8spjDnErbM3fxI3+zf72nYwNH7YiQm90vOgYk+olbX99j3o6f26GS719IfEwpBzytqNu
        vWmFParimT/reuQ2eZbUpio6UHGhxEDjpdefSvTO/LPTtnkEHyx7KX1JNSwYV4xHHSuw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pn0Un-00ADHW-OD; Thu, 13 Apr 2023 19:12:29 +0200
Date:   Thu, 13 Apr 2023 19:12:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 0/3] staging: octeon: Convert to use phylink
Message-ID: <6774ce75-196c-4b55-b159-bd39ee72542e@lunn.ch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <b70d9361-c689-4837-bc9d-8e800cda380c@lunn.ch>
 <ZDgvSoT/vdJeI0FS@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgvSoT/vdJeI0FS@lenoch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > However testing revealed some glitches:
> > > 1. driver previously returned -EPROBE_DEFER when no phy was attached.
> > > Phylink stack does not seem to do so, which end up with:
> > > 
> > > Marvell PHY driver as a module:
> > > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Generic PHY] (irq=POLL)
> > > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > > octeon_ethernet 11800a0000000.pip eth2: PHY [8001180000001800:01] driver [Generic PHY] (irq=POLL)
> > > octeon_ethernet 11800a0000000.pip eth2: configuring for phy/sgmii link mode
> > > octeon_ethernet 11800a0000000.pip eth0: switched to inband/sgmii link mode
> > > octeon_ethernet 11800a0000000.pip eth0: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
> > > octeon_ethernet 11800a0000000.pip eth3: PHY [8001180000001800:02] driver [Marvell 88E1340S] (irq=25)
> > > octeon_ethernet 11800a0000000.pip eth3: configuring for phy/sgmii link mode
> > > octeon_ethernet 11800a0000000.pip eth4: PHY [8001180000001800:03] driver [Marvell 88E1340S] (irq=25)
> > > octeon_ethernet 11800a0000000.pip eth4: configuring for phy/sgmii link mode
> > > octeon_ethernet 11800a0000000.pip eth1: Link is Up - 100Mbps/Full - flow control off
> > > 
> > > Marvell PHY driver built-in:
> > > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Marvell 88E1340S] (irq=25)
> > > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > > libphy: Marvell 88E1101: Error -16 in registering driver
> > > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > > libphy: Marvell 88E1101: Error -16 in registering driver
> > 
> > This is very odd. But it could be a side effect of the
> > compatible. Please try with it removed.
> 
> That does not make any difference.

Then i have no idea. I would suggest you add a WARN_ON() in
phy_driver_register() so we get a backtrace. That might give a clue
why it is getting registered multiple times.

	 Andrew
