Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8792A44989A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbhKHPnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhKHPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:43:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6267FC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 07:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2QP6Ha8RZ+lbjKXqDkS00oLYDpjhE91weZSgwC9c458=; b=R88nF8F01bOdHjMmIXhCPOYLMW
        ANkEF6y5twiZWfKlPR+HZ8ycFDkA5ad/Ii3GAo8PfpPlRcgxEaXPXNBiCFUXKzrMok4Pb6ifdc1Lw
        QQ/WvpEcyyGHHG5WAxShtiejd8X/kwkv/IcnOMmbxjkqK093patEm5R1Z7UEvvB2qSXgGzioWBStn
        lmkkNq8/etycGWrN5km1/8KnEiMHIjQa2XJB5WCaWfwqXEvV1TQAa8kF3xHMvwlwYs3H9saUpNPBX
        niryeHLxDdKFAaKvQ78pXv2e3ziJ6e1gWPDTuOvVaWf4sOCD3gsdSVlZAEbTg1RFlJNF+qEB53r5t
        tGTBmG7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55538)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mk6lG-0000tO-0M; Mon, 08 Nov 2021 15:40:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mk6lE-0002vF-Gb; Mon, 08 Nov 2021 15:40:40 +0000
Date:   Mon, 8 Nov 2021 15:40:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     bage@linutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <YYlE+JeDwmRsaiec@shell.armlinux.org.uk>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
 <20211108160653.3d6127df@mitra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108160653.3d6127df@mitra>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 04:06:53PM +0100, Benedikt Spranger wrote:
> On Mon, 8 Nov 2021 14:25:48 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Mon, Nov 08, 2021 at 03:18:34PM +0100, bage@linutronix.de wrote:
> > > From: Bastian Germann <bage@linutronix.de>
> > > 
> > > Take the return of phy_start_aneg into account so that ethtool will
> > > handle negotiation errors and not silently accept invalid input.
> > 
> > I don't think this description is accurate. If we get to call
> > phy_start_aneg() with invalid input, then something has already
> > gone wrong.
> The MDI/MDIX/auto-MDIX settings are not checked before calling
> phy_start_aneg(). If the PHY supports forcing MDI and auto-MDIX, but
> not forcing MDIX _phy_start_aneg() returns a failure, which is silently
> ignored.

That would be very bad if it were to happen.

ksettings_set() would be called. If phy_is_started() returns true, we
trigger the state machine after forcing PHY_UP state. The state machine
calls phy_start_aneg() and gets an error, calling phy_error(), and
the state machine is forced into PHY_HALTED mode with a kernel warning
and stack trace.

That is not nice behaviour for a user.

> Just to be clear: The PHY driver should check the settings and return
> an error before calling phy_ethtool_ksettings_set() ?

The PHY driver doesn't get an opportunity to validate the settings
prior to calling phy_ethtool_ksettings_set() - because the PHY driver
never calls this function. The MAC driver does. However, the MAC driver
doesn't know what the PHY will accept.

This clearly needs to be fixed in phylib.

As a result of your explanation, I now believe your patch to be
fundamentally incorrect given the current state, and it should not be
applied.

We should not accept a call to phy_ethtool_ksettings_set(), modify some
state (setting phydev->advertising/autoneg/master_slave_set/mdix_ctrl/
speed/duplex) and then return an error to the user indicating that the
call failed because we didn't like some parameter - e.g. the mdix_ctrl
value that we've writtent o phydev->mdix_ctrl.

Userspace validation should always happen _prior_ to accepting any
state from userland. If there's an issue with it, the call should fail
without modifying any state.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
