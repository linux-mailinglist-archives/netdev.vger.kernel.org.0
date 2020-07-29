Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C517231F50
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgG2N2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgG2N2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:28:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA7AC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9ORNiu6AUY2fE+M5i4oJ2jFQrokNliJ5sCBtL7SxZso=; b=N/so8yGNNBqNwCuNekstEglhq
        22LCjR0cL7KIeVzsrdi7mshxOw2R/JEKotwX5UW/E1ANH01TB8z24dKzirD8085SsrcYcNaHfI5yn
        /bWL5k0QP2rFqXVfClEpgCHpJ9KWQWZVKuN9XHZxJrzeeQKKrGJjxijNTCVjKBtD31UMYnzKnr75q
        EYt+1tKpqC4qqsB/tnhTnQd308edYetIL1l+/koRQQsaMQeGr5aEZBuPQwSpnE6ZLS5OSW5BalvnS
        4IDlHSb8XhmHMI2tH8R3mPPVPgJpdT7am4CeVnKKYUQBWuShsf5CScYvGnbDT8JSHWsWWl5B4R57O
        JjXC2vHPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45690)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0m8L-0005RW-3w; Wed, 29 Jul 2020 14:28:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0m8G-0005iJ-QA; Wed, 29 Jul 2020 14:28:32 +0100
Date:   Wed, 29 Jul 2020 14:28:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200729132832.GA1551@shell.armlinux.org.uk>
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

Which is more or less what I said in my email.  However, the important
question about how to select between the two, which is really what I'm
after, has not been addressed.

> (Also some MAC drivers do not defer to the PHY properly.  Sometimes
> you can work around that by de-selecting the MAC's PTP function in the
> Kconfig if possible, but otherwise you need to patch the MAC driver.)

... which really doesn't work if you have a board where only some
network interfaces have a PHY with PTP support, but all have PTP
support in the MAC.

If all MACs or the majority of MACs use a common PTP clock, it seems
to me that you would want to use the MACs rather than the PHY,
especially if the PHY doesn't offer as good a quality PTP clock as
is available from the MAC.

Randomly patching the kernel is out of the question, for arm based
systems we want one kernel that works correctly across as many
platforms as possible, and Kconfig choices to set platform specific
details are basically unacceptable, let alone patching the kernel to
make those decisions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
