Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F85E463BA2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhK3QZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbhK3QZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:25:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12F3C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rWNnMiJCsMsBfjBD6NUJPJdWzkzppOxkrZgfdQslB14=; b=UjHFrEjQ1vhWZ+AApVY2YZ07mM
        Y0ip17iGKA0clFuF3jbIxuWdV43hwwa7mwTgpgPilJAhWQjJ9hau3mUOiu7fQnWKLme0U5f2OJIIF
        DEwcgZmBo9mA/0vBkGSrPXvt59ayGw8/PaxRTJs49KlfpbY6qzjeNCR+K/aFBRBtFY3A2EOlNF7ug
        lp7d5QNNn0JFKWvFWVESAKmHba5I5kfoDR+G3Oe0FL6ZupIrqmxKUpuqYYvFx0mRiSyv6HYIyEgcj
        T5ivFI8SAYavZrC2uH496seqkh/hv3gN7RTNbwfj5dRMiPgpcacypU08tk14UfCqj4JtIJ11ErYTE
        RHr5m95A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55992)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ms5tb-00079B-7C; Tue, 30 Nov 2021 16:22:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ms5ta-0007BS-Og; Tue, 30 Nov 2021 16:22:18 +0000
Date:   Tue, 30 Nov 2021 16:22:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <YaZPutgAUbd4eUqN@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
 <20211129195823.11766-7-kabel@kernel.org>
 <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
 <20211130011812.08baccdc@thinkpad>
 <20211130170911.6355db44@thinkpad>
 <YaZONv7fmRWK+qCb@shell.armlinux.org.uk>
 <20211130171859.6deeb17d@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211130171859.6deeb17d@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 05:18:59PM +0100, Marek Behún wrote:
> On Tue, 30 Nov 2021 16:15:50 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Tue, Nov 30, 2021 at 05:09:11PM +0100, Marek Behún wrote:
> > > Seems that BMSR_ANEGCAPABLE is set even if AN is disabled in BMCR.  
> > 
> > Hmm, that behaviour goes against 22.2.4.2.10:
> > 
> > A PHY shall return a value of zero in bit 1.5 if Auto-Negotiation is
> > disabled by clearing bit 0.12. A PHY shall also return a value of zero
> > in bit 1.5 if it lacks the ability to perform Auto-Negotiation.
> > 
> > > I was under the impression that
> > >   state->an_complete
> > > should only be set to true if AN is enabled.  
> > 
> > Yes - however as you've stated, the PHY doesn't follow 802.3 behaviour
> > so I guess we should make the emulation appear compliant by fixing it
> > like this.
> 
> OK, I will use BMCR_ANENABLE and add a comment explaining that we can't
> use BMSR_ANEGCAPABLE because the PHY violates standard. Would that be
> okay?

Yes, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
