Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C15212AC9
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgGBREf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgGBREf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:04:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02315C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PgyClYHxo3bbaos+uvGMWh80u21ZZ1e/ac468pFLTJU=; b=tMRjPTO2FZmj5pO/YAS2Fev5R
        nc0RQugKrps1TBtGbpGNoq+ZOnc2DIS/3HpAAAEYCuYoOPCaG4K7d/hX/X+XEIfcuMxuYvtEqViOa
        jexSPry3ZRPUFraNCLVt9vhsCnrNk4/lC8VoRK4T0jz5+8g176kq+224hz11uKNLS0Gux7vuNdaTt
        /G2lCFVbODrigBYb62KKVOwM8X9bZsgVDvY/FcyLhTXWW0CLcSHLSr7sl1z4l++UHz3QEifBPnz0O
        d8CNrnPuCES/tr+20hizwTA2a9j0BnGHeRwvTEqB91KXyJE/VzmXxpC2KgasFHYErrpc3mlkjoSMi
        KPD23G4AA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34460)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jr2dV-00038m-LJ; Thu, 02 Jul 2020 18:04:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jr2dV-0001vn-Ap; Thu, 02 Jul 2020 18:04:33 +0100
Date:   Thu, 2 Jul 2020 18:04:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: 2500base-x capable sfp copper module?
Message-ID: <20200702170433.GO1551@shell.armlinux.org.uk>
References: <20200702182120.6d11bf70@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702182120.6d11bf70@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 06:21:20PM +0200, Marek Behún wrote:
> We are trying to find a copper SFP module capable of 2.5G speeds for
> Turris Omnia (2500base-x is max for SERDES on Omnia).
> 
> We have tried MikroTik S+RJ10, which is a 10G capable copper SFP
> module. But this module does not export access (via I2C) to its internal
> PHY (which should be Marvell 88X3310).

That seems to follow on from the S-RJ01, which uses an Atheros 803x
PHY but also doesn't allow access to it.  It seems that MikroTik
products don't offer much flexibility, and are likely designed for
use in their own products rather than general use.

> Without access to the PHY it seems that the host side of the SFP is
> configured at 10G and we are unable to change it to 2500base-x.

The problem here is that we have no idea what the module supports.
It may be possible to use the quirk stuff I added for GPON to detect
the MikroTik module, and enable the other speeds.  We would then
have to add the ability to switch not only between 1000base-X and
2500base-X, but all the other modes as well via ethtool.  And then,
lastly, you would have to manually set the interface, guessing what
speed the module would want.

That doesn't sound like a good solution.

I can only assume that Mikrotik have implemented some kind of auto-
detection - maybe they have hardware in their switches that is
capable of analysing the serdes lines from the module.

> We have another module, Rollball RTSFP-10G, which contains the same
> PHY, but this is visible on the I2C bus at address 0x56.
> For some reason I am unable to access registers of the PHY via clause
> 45 protocol. The code in drivers/net/phy/mdio-i2c.c always returns
> 0xffff when reading via clause 45.

The 88x3310 does not support I2C, it only supports MDIO.  So, for it
to appear on the I2C bus, there must be some kind of vendor specific
protocol conversion going on, most likely a small dumb MCU from what
I read in various public SFP+ datasheets.

The modules that mdio-i2c.c has been tested with so far have done the
"sensible" thing of clock-stretching the I2C bus while they access the
PHY.  This means that using the _safe_ i2c_transfer() is possible, just
as we do for Clause 22 PHYs.  I term this safe, because the bus remains
owned during the whole cycle, so there's no chance something else (e.g.
i2c tools) will get in the way and potentially disrupt the access.

However, a number of copper SFP+ datasheets (which seem to be derived
from the same source - as can be seen from the graphics and layout)
require a 1ms delay between the I2C "mdio address write" message and
the I2C "mdio read" message.  That prevents i2c_transfer() being used
for the entire access - it has to be done as two separate accesses with
a delay inbetween - which likely will make PHY accesses rather slow
when you compare that normally, a clause 45 access may take around 25
or so microseconds, possibly faster.

As I don't have any modules that require that, I only ever noted that
such modules exist, but never implemented the split-access with a delay,
especially as it would require a fair number of code changes to mdio-i2c.

Note that mdelay(1) may not be sufficient (the *delay() functions are
_not_ guaranteed to wait at least the requested delay).

> When accessing via clause 22, the registers are visible, but we are
> unable to change to 2500base-x with these registers.

There has been talk in phylib about adding support to access a clause
45 PHY register set through clause 22 cycles via the clause 45
registers contained therein - but I don't think that went anywhere.

> Do you think this is a problem of how the SFP module is
> wired/programmed?

It's likely to be due to the missing 1ms delay.

> Do you know of 2500base-x capable copper SFP module which would work?
> Maybe one based on the same Marvell PHY, but such that the clause 45
> register access works?

The only copper module that's capable of 10G, 5G, 2.5G, 1G, 100M that I
have is a Methode DM7052 which has a Broadcom PHY on it, which behaves
as I mention above (clock stretching, without the need for a delay.)

The other 2.5G capable modules I have are Avago AFBR-57R5AEZ
fibrechannel modules designed to operate up to 4300M baud, which is
more than enough bandwidth to cover 2500base-X - but obviously no PHY
being fibre modules.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
