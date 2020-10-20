Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA8B29449A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438698AbgJTVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438690AbgJTVeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:34:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B61C0613CE;
        Tue, 20 Oct 2020 14:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CL33xukGyQD+kFedH3Y6PzDp2/gvvtq/BTuy+H/0srM=; b=EKGLaCPw8o9py9uEATTS1AOcE
        3mllTzLkCFAO3IOvTYTqNn5DsEy+uHGfaWuIFHaDreXJJKBZPUw2H6Ixmc/rslU3+IlFcAJlfpzxq
        1EzH/ktt5zb73CmqcLBefOUReR9b4zDdpH/yHC+Loq2/X2s7NY1K/FQPLL7l4hdgFzfzTbdc988/i
        6X+oVpxFEGrtjRLQIToTjS1weaAU7K1B5MGMNTRBP8W4QP4B6ymDpqw8dL63QaMt3nRJ4YYIUl2ze
        RflMRIMJy0TyAwvtiWwdxO3fOcbiXTw606mAfCWHCzKxUfMZvtx0Hs+d5/TZSeqMwbZKlBO5goA4A
        LP30vz/sA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48824)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUzGg-00080f-3T; Tue, 20 Oct 2020 22:34:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUzGd-0005cW-DK; Tue, 20 Oct 2020 22:34:03 +0100
Date:   Tue, 20 Oct 2020 22:34:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Message-ID: <20201020213403.GH1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-4-chris.packham@alliedtelesis.co.nz>
 <20201020101851.GC1551@shell.armlinux.org.uk>
 <d4f6fab0-8099-7cc2-dfce-bd7a3363c131@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f6fab0-8099-7cc2-dfce-bd7a3363c131@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 09:24:04PM +0000, Chris Packham wrote:
> 
> On 20/10/20 11:18 pm, Russell King - ARM Linux admin wrote:
> > On Tue, Oct 20, 2020 at 04:45:58PM +1300, Chris Packham wrote:
> >> +void mv88e6123_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
> >> +{
> >> +	u16 *p = _p;
> >> +	u16 reg;
> >> +	int i;
> >> +
> >> +	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
> >> +		return;
> >> +
> >> +	for (i = 0; i < 26; i++) {
> >> +		mv88e6xxx_phy_read(chip, port, i, &reg);
> > Shouldn't this deal with a failed read in some way, rather than just
> > assigning the last or possibly uninitialised value to p[i] ?
> 
> mv88e6390_serdes_get_regs() and mv88e6352_serdes_get_regs() also ignore 
> the error. The generic mv88e6xxx_get_regs() memsets p[] to 0xff so if 
> the serdes_get_regs functions just left it alone we'd return 0xffff 
> which is probably better than repeating the last value although it's 
> still ambiguous because 0xffff is a valid value for plenty of these 
> registers.
> 
> Since it looks like I need to come up with an alternative to patch #1 
> I'll concentrate on that but making the serdes_get_regs() a little more 
> error tolerant is a cleanup I can easily tack on onto this series.

Yep, it looks like they all suffer the same problem. Interestingly,
mv88e6xxx_get_regs() does handle the error by avoiding writing the
register entry (so it gets left as 0xffff.)

Incidentally, that's also the value you'll get when reading from a
PHY that doesn't respond, since the MDIO data line is pulled high
when undriven.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
