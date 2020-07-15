Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84F2214C2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGOS4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgGOS4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:56:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA37C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 11:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/SSHnZg91H7jMA6mqU4gHGofRZ5/+Ew4PIvFSdPWxv0=; b=WEMIRJYHo5PtYb1jGH0wlPBGz
        m9W+YGFs3E/Gzqdqzf4bgNvcWv/UloVKbnxK2oefoLeYz11wt6hUAb98lMacplF97uxrVtQkFbKHn
        PvUAa2h2rwIRy/bUfAaEnGuYOqhupLs4Np/iMb51wjC6O+JxS3OC4ejY7SkVLCbH5RoC+pYqZFqUm
        yajG+Bmk36eYq9+Ie877frkvzY4EKw4I+F6R71uQPpnr5lu+ZfewV0xetn+IobkcdhwKvEdmi3+BY
        bCni54kdcBnFl8q5LXFf7J6qu+Uci62iu8HSc/qCYf5BmWou9F0eHwAJGPkolbJqKYdV84l3l55og
        Hnjy7wxdA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39924)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jvmZo-00071Y-8X; Wed, 15 Jul 2020 19:56:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jvmZn-00005o-Ng; Wed, 15 Jul 2020 19:56:19 +0100
Date:   Wed, 15 Jul 2020 19:56:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200715185619.GJ1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200715183843.GA1256692@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715183843.GA1256692@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 08:38:43PM +0200, Andrew Lunn wrote:
> > Getting the Kconfig for this correct has been a struggle - particularly
> > the combination where PTP support is modular.  It's rather odd to have
> > the Marvell PTP support asked before the Marvell PHY support.  I
> > couldn't work out any other reasonable way to ensure that we always
> > have a valid configuration, without leading to stupidities such as
> > having the PTP and Marvell PTP support modular, but non-functional
> > because Marvell PHY is built-in.
> 
> Hi Russell
> 
> How much object code is this adding? All the other PHYs which support
> PTP just make it part of the PHY driver, not a standalone module. That
> i guess simplifies the conditions. 

Taking an arm64 build, the PHY driver is 16k and the PTP driver comes
in just under 8k.

> Looking at DSDT, it lists
> 
>         case MAD_88E1340S:
>         case MAD_88E1340:
>         case MAD_88E1340M:
>         case MAD_SWG65G : 
> 	case MAD_88E151x:
> 
> as being MAD_PHY_PTP_TAI_CAPABLE;
> 
> and
> 
> 	case MAD_88E1548
>         case MAD_88E1680:
>         case MAD_88E1680M:
> 
> as MAD_PHY_1STEP_PTP_CAPABLE;
> 
> So maybe we can wire this up to a few more PHYs to 'lower' the
> overhead a bit?

That's interesting, the 1548 information (covering 1543 and 1545 as
well) I have doesn't mention anything about PTP.

> > It seems that the Marvell PHY PTP is very similar to that found in
> > their DSA chips, which suggests maybe we should share the code, but
> > different access methods would be required.
> 
> That makes the Kconfig even more complex :-(

We already have that complexity due to the fact that we are interacting
with two subsystems.  The 88e6xxx Kconfig entry has:

config NET_DSA_MV88E6XXX_PTP
        bool "PTP support for Marvell 88E6xxx"
        default n
        depends on NET_DSA_MV88E6XXX_GLOBAL2
        depends on PTP_1588_CLOCK
        imply NETWORK_PHY_TIMESTAMPING

and I've been wondering what that means when PTP_1588_CLOCK=m while
NET_DSA_MV88E6XXX_GLOBAL2=y and NET_DSA_MV88E6XXX=y.  If this is
selectable, then it seems to be misleading the user - you can't have
the PTP subsystem modular, and have PTP drivers built-in to the
kernel.

Yes, we have the inteligence to be able to make the various PTP calls
be basically no-ops, but it's not nice.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
