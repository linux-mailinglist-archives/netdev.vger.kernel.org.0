Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5B1FCD10
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQMIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 08:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQMIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 08:08:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1D3C061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 05:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vlzIlec8O4q1LJuunY0SMo4Ey4JbExtvyh1heVmRLwk=; b=Foh3YzGTzN4KytlW28as2L5Yw
        ZHDXRS5ZKcYino3U2+DGrtrUjsYP4jByHPksvI72P1QWWv0ukpSMxJA1yf+xioFvsy445H/49vo3B
        I5qqCIQKtLU7dn3Xp2YUjokkw3i6ocWWKYnI7GTZGwbAMoUFD0qJhZcPbZsIy+ZBS2JTF7h4v23sG
        3NGrxOi0hudGNJFTCDufGf+v/SaM14foIBxKC91l5ARLlHrp2dRvLRfuLOi0FnmAmet16IfB0TWF+
        9vzxhvqWKXzEZ8Kv8IjHXoaTeo1KQcPbEy7/dts+lbA0QXl062VOrAfP1wW8N3RdztK/hC7livulQ
        JJJ9CFSYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58480)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlWrS-0003jG-Q6; Wed, 17 Jun 2020 13:08:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlWrR-0003iZ-RC; Wed, 17 Jun 2020 13:08:09 +0100
Date:   Wed, 17 Jun 2020 13:08:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617120809.GS1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617115201.GA30172@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:52:01PM +0200, Helmut Grohne wrote:
> On Wed, Jun 17, 2020 at 01:40:25PM +0200, Russell King - ARM Linux admin wrote:
> > > For a fixed-link, the validation function is never called. Therefore, it
> > > cannot reject PHY_INTERFACE_MODE_RGMII. It works in practice.
> > 
> > Hmm, I'm not so sure, but then I don't know exactly what code you're
> > using.  Looking at mainline, even for a fixed link, you call
> > phylink_create().  phylink_create() will spot the fixed link, and
> > parse the description, calling the validation function.  If that
> > fails, it will generate a warning at that point:
> > 
> >   "fixed link %s duplex %dMbps not recognised"
> > 
> > It doesn't cause an operational failure, but it means that you end up
> > with a zero supported mask, which is likely not expected.
> > 
> > This is not an expected situation, so I'll modify your claim to "it
> > works but issues a warning" which still means that it's not correct.
> 
> I do see that warning. I agree with your correction of my claim. Thank
> you for your attention to detail.
> 
> So we have two good reasons for not rejecting delay configuration in the
> validation function now.
> 
> The remaining open question seems to be whether configuring a delay on a
> MAC to MAC connection should cause a failure or a only warning. Do you
> have an opinion on that?
> 
> All in-tree bindings of the driver seem to use rmii when they specify a
> phy-mode.

This brings up a problem in itself - the phy interface mode is
currently defined in terms of a MAC-to-PHY setup, not a MAC-to-MAC
setup.

With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
setup; we just don't know.  However, we don't have is access to the
PHY (if it exists) in the fixed link case to configure it for the
delay.

In the MAC-to-MAC RGMII setup, where neither MAC can insert the
necessary delay, the only way to have a RGMII conformant link is to
have the PCB traces induce the necessary delay. That errs towards
PHY_INTERFACE_MODE_RGMII for this case.

However, considering the MAC-to-PHY RGMII fixed link case, where the
PHY may not be accessible, and may be configured with the necessary
delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
be for the MAC-to-MAC RGMII with PCB-delays case.

So, I think a MAC driver should not care about the specific RGMII
mode being asked for in any case, and just accept them all.

I also think that some of this ought to be put in the documentation
as guidance for new implementations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
