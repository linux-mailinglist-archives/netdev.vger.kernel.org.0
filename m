Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD92F9F3D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 13:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391219AbhARMOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389608AbhARMOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 07:14:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7BA206E3;
        Mon, 18 Jan 2021 12:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610972021;
        bh=ToHLKLnwwSv1Hpi4ty2s1Hi7Eis7DEIz7mg8zJuM5Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PifS3mZFYZx8f7Hqog1Z0fRbH+tyan7Xi2rOuM/tFzfxwUH6Ho7hDsboc23W7yNT+
         cuEvsMjoGTERr2+8R09/MJb6bTqHs0Liv8A4szbQLpD7QEIP4Ula0xoCmWjiPct82E
         yf2PtVvFi7M/u32X1/gT6bZujvXpM3BjsFKGVkgGv+ceJFimOrM9xwWOrzjAJnZs81
         zAq/XHYx7O6ipfWrmSyCT1QtqqnAZXsdkaSmeIGtCj9bEi8yf/Z0QgaF5dwDb4GUvr
         AiatGQQNDKPfzK5WY8PVrvrr4T6BznHsSjURaF139aKdzXHO0mFnZaJsYToGV0cNT9
         c6opsrU379d5w==
Received: by pali.im (Postfix)
        id 7EEE4889; Mon, 18 Jan 2021 13:13:38 +0100 (CET)
Date:   Mon, 18 Jan 2021 13:13:38 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210118121338.lzbit6ad2uem2gcq@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
 <20210112192233.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112192233.GE1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 12 January 2021 19:22:33 Russell King - ARM Linux admin wrote:
> On Tue, Jan 12, 2021 at 09:42:56AM +0100, Heiner Kallweit wrote:
> > On 11.01.2021 06:00, Marek Behún wrote:
> > > Some multigig SFPs from RollBall and Hilink do not expose functional
> > > MDIO access to the internal PHY of the SFP via I2C address 0x56
> > > (although there seems to be read-only clause 22 access on this address).
> > > 
> > > Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> > > Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> > > selected to 3 and the password must be filled with 0xff bytes for this
> > > PHY communication to work.
> > > 
> > > This extends the mdio-i2c driver to support this protocol by adding a
> > > special parameter to mdio_i2c_alloc function via which this RollBall
> > > protocol can be selected.
> > > 
> > I'd think that mdio-i2c.c is for generic code. When adding a
> > vendor-specific protocol, wouldn't it make sense to use a dedicated
> > source file for it?
> 
> There is nothing in the SFP MSAs about how to access an on-board PHY
> on a SFP. This is something that vendors choose to do (or in some
> cases, not do.)
> 
> mdio-i2c currently implements the access protocol for Marvell 88E1111
> PHYs which have an I2C mode. It was extended to support the DM7052
> module which has a Broadcom Clause 45 PHY and either a microcontroller
> or FPGA to convert I2C cycles to MDIO cycles - and sensibly performs
> clock stretching.

Just to note that there is also another Marvell way how to access Clause
45 registers via existing Marvell PHY Clause 22 I2C mode:

https://www.ieee802.org/3/efm/public/nov02/oam/pannell_oam_1_1102.pdf

Clause 45 registers are accessed via Clause 22 regs 13 and 14.

> There are modules that the clause 45 PHY is accessible via exactly the
> same I2C address, using exactly the same data accesses, but do not
> do the clock stretching thing, instead telling you that you must wait
> N microseconds between the bus transactions. We don't yet support
> these.
> 
> Then there is Marek's module, where the PHY is accessible via a page
> in the diagnostic address - which is another entirely reasonable
> implementation. The solution we have here is one that I've worked with
> Marek for a few months now.
> 
> I don't think we should grow lots of separate mdio-i2c-vendorfoo.c
> drivers - at least not yet. Maybe if we get lots of different access
> methods, it may make sense in the future.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
