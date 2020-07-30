Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B762330B9
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 13:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgG3LGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 07:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG3LGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 07:06:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F4C061794
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 04:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kYVLACyCu5tq8GYC/ZrfewrJhwW2VL5IdvavqD027eE=; b=FdJueyYon+O+q3qCluSAPc5Mg
        ZBODr/7R2VvC9cQDd43tG5djhj7PCjFecoh1SFIqSq6QVmUctbQpVwwVB+fQhyBSwAD6c3JHgJcXl
        k3Op4+3sS/X5y9shJN9nspWacYhVrKCnwtHNTGjG1qchauu0z2MgD0TkwDDXN28lROq6zJZcsNW6+
        +xdNhZn2qcJIZAb98287y/ZBhFQmiJY7OvB2BE6NYa7Q6KR0kg4JLaiMMyuPzNiXQMrhunSVfqVLl
        F17jP0xGwXC8gZXJU9nQeXXY8s1ix0yNhE/ejPNVbSCKLIbKevfpVzd82CN/V11nME4dQFEhX0DMY
        pm+Kt3Stw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46070)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k16O9-0006LI-0O; Thu, 30 Jul 2020 12:06:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k16O6-0006gt-3P; Thu, 30 Jul 2020 12:06:14 +0100
Date:   Thu, 30 Jul 2020 12:06:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20200730110613.GC1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729131932.GA23222@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 06:19:32AM -0700, Richard Cochran wrote:
> On Wed, Jul 29, 2020 at 11:58:07AM +0100, Russell King - ARM Linux admin wrote:
> > How do we deal with this situation - from what I can see from the
> > ethtool API, we have to make a choice about which to use.  How do we
> > make that choice?
> 
> Unfortunately the stack does not implement simultaneous MAC + PHY time
> stamping.  If your board has both, then you make the choice to use the
> PHY by selecting NETWORK_PHY_TIMESTAMPING at kernel compile time.
> 
> (Also some MAC drivers do not defer to the PHY properly.  Sometimes
> you can work around that by de-selecting the MAC's PTP function in the
> Kconfig if possible, but otherwise you need to patch the MAC driver.)
>  
> > Do we need a property to indicate whether we wish to use the PHY
> > or MAC PTP stamping, or something more elaborate?
> 
> To do this at run time would require quite some work, I expect.

Okay, I'm falling into horrible multicast issues with DSA switches
while trying to test.

Some of my platforms have IP_MULTICAST=y, others have IP_MULTICAST=n.
This causes some to send IGMP messages when binding to the multicast
address, others do not.

Those that do cause the DSA switch to add a static database entry
causing all traffic for that multicast address to be only directed to
the port(s) that the machine(s) with IP_MULTICAST=y kernels are
connected to, depriving all IP_MULTICAST=n machines from seeing those
packets.

Maybe, with modern networking technology, it's about time that the
kernel configuration help recommended that kernels should be built
with IP_MULTICAST=y ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
