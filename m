Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B02F3A1F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436812AbhALTXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436791AbhALTXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:23:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6292FC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bwv8rcg73lMNKkJCmApjYr4bJR5F5Cs8gC2rMjoEoPw=; b=UD1Ti2XGe/on2lKNlNDU6aShg
        mORepwTNapedrd+zHwvYt8WuTqbk2NnUc6N5W9B5wtkl13psC1p4xpTWRRul0f5iT1xQiGw+FDP3v
        BKXGCSwgMqejqE0sW17tjwRjK5xxRPVgkSVR7CSkZs0s032Hs5H55uZj4hBCRRerIlIA8e63NRfPs
        R1h0ntcWc/E3ANZlepp9NPYXeSNLILpnMAn/YUVxKi7wB54qHBfyLarcCIG4bYK6Abx7LyK+I9DoG
        WEXqTkByZtUqMvEMeuifOJB7pnpqY9wu45+8gTSdaW83PGI9AW0y+igwQ50f8dcxQSkqz/uRapNav
        q99oBhdZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47134)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzPFT-0000HJ-5Y; Tue, 12 Jan 2021 19:22:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzPFR-0006XH-Uv; Tue, 12 Jan 2021 19:22:33 +0000
Date:   Tue, 12 Jan 2021 19:22:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210112192233.GE1551@shell.armlinux.org.uk>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:42:56AM +0100, Heiner Kallweit wrote:
> On 11.01.2021 06:00, Marek Behún wrote:
> > Some multigig SFPs from RollBall and Hilink do not expose functional
> > MDIO access to the internal PHY of the SFP via I2C address 0x56
> > (although there seems to be read-only clause 22 access on this address).
> > 
> > Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> > Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> > selected to 3 and the password must be filled with 0xff bytes for this
> > PHY communication to work.
> > 
> > This extends the mdio-i2c driver to support this protocol by adding a
> > special parameter to mdio_i2c_alloc function via which this RollBall
> > protocol can be selected.
> > 
> I'd think that mdio-i2c.c is for generic code. When adding a
> vendor-specific protocol, wouldn't it make sense to use a dedicated
> source file for it?

There is nothing in the SFP MSAs about how to access an on-board PHY
on a SFP. This is something that vendors choose to do (or in some
cases, not do.)

mdio-i2c currently implements the access protocol for Marvell 88E1111
PHYs which have an I2C mode. It was extended to support the DM7052
module which has a Broadcom Clause 45 PHY and either a microcontroller
or FPGA to convert I2C cycles to MDIO cycles - and sensibly performs
clock stretching.

There are modules that the clause 45 PHY is accessible via exactly the
same I2C address, using exactly the same data accesses, but do not
do the clock stretching thing, instead telling you that you must wait
N microseconds between the bus transactions. We don't yet support
these.

Then there is Marek's module, where the PHY is accessible via a page
in the diagnostic address - which is another entirely reasonable
implementation. The solution we have here is one that I've worked with
Marek for a few months now.

I don't think we should grow lots of separate mdio-i2c-vendorfoo.c
drivers - at least not yet. Maybe if we get lots of different access
methods, it may make sense in the future.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
