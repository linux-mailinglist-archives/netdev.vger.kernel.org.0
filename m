Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33FD2FA51C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393053AbhARPsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393532AbhARPqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:46:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830EC061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Alz5HVfDbgVQ3SkX0jIibgbKC04RLZ9B3dYzF7HAxdI=; b=D7CrXatt2VXAO9PNq1mQjpEAW
        NTQ+0B2chioxGTdjW2TdUdVkCLdXqtZ+xl8mcZufoZF4Nv7XiZdpZbYp3llHTqISVkkAM0ShcEROX
        /iWMrO/oR32qXSwv3j6KEfZ7KKFPwqxrjzkrbW9cNvNXNzL+gW8QYFR89ptRTKhf9Ou+xdC3Pt0Wd
        Ny84//2sotHuODCmTcOTfFXCZR3sYuvljO0RdZa0NEdZ55a0ruCObZfxhPt+ZytWunW0B7m9/VZdV
        ljCyinKwTTaJwz5gRQbU3fk05MCzLIzBzdpSSzPMhDOabdLGOqZBMDkXDiFkELJFdQ5hEwt/NDGKO
        JWtSJKrWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49598)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l1WiM-0006d2-8S; Mon, 18 Jan 2021 15:45:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l1WiL-00047Z-2b; Mon, 18 Jan 2021 15:45:09 +0000
Date:   Mon, 18 Jan 2021 15:45:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210118154508.GE1551@shell.armlinux.org.uk>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
 <20210112192233.GE1551@shell.armlinux.org.uk>
 <20210118121338.lzbit6ad2uem2gcq@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210118121338.lzbit6ad2uem2gcq@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 01:13:38PM +0100, Pali Rohár wrote:
> On Tuesday 12 January 2021 19:22:33 Russell King - ARM Linux admin wrote:
> > On Tue, Jan 12, 2021 at 09:42:56AM +0100, Heiner Kallweit wrote:
> > > On 11.01.2021 06:00, Marek Behún wrote:
> > > > Some multigig SFPs from RollBall and Hilink do not expose functional
> > > > MDIO access to the internal PHY of the SFP via I2C address 0x56
> > > > (although there seems to be read-only clause 22 access on this address).
> > > > 
> > > > Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> > > > Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> > > > selected to 3 and the password must be filled with 0xff bytes for this
> > > > PHY communication to work.
> > > > 
> > > > This extends the mdio-i2c driver to support this protocol by adding a
> > > > special parameter to mdio_i2c_alloc function via which this RollBall
> > > > protocol can be selected.
> > > > 
> > > I'd think that mdio-i2c.c is for generic code. When adding a
> > > vendor-specific protocol, wouldn't it make sense to use a dedicated
> > > source file for it?
> > 
> > There is nothing in the SFP MSAs about how to access an on-board PHY
> > on a SFP. This is something that vendors choose to do (or in some
> > cases, not do.)
> > 
> > mdio-i2c currently implements the access protocol for Marvell 88E1111
> > PHYs which have an I2C mode. It was extended to support the DM7052
> > module which has a Broadcom Clause 45 PHY and either a microcontroller
> > or FPGA to convert I2C cycles to MDIO cycles - and sensibly performs
> > clock stretching.
> 
> Just to note that there is also another Marvell way how to access Clause
> 45 registers via existing Marvell PHY Clause 22 I2C mode:
> 
> https://www.ieee802.org/3/efm/public/nov02/oam/pannell_oam_1_1102.pdf
> 
> Clause 45 registers are accessed via Clause 22 regs 13 and 14.

Only if the Clause 45 PHY supports the Clause 22 interface. Not all do.

However, which access method really only depends on the SFP module,
and how they interface the PHY to the I2C bus. As I've previously
mentioned, using a wrong access method will be misinterpreted by
the SFP.

Even if the PHY supports both Clause 22 and Clause 45 accesses,
if the I2C-to-MDIO layer in the SFP only supports Clause 45, then
Clause 22 accesses will not work. As I've previously said, a
Clause 45 read access is indistinguishable from a Clause 22 write
access on the I2C bus.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
