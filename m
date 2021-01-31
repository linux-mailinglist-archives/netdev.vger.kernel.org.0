Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB2A309C1F
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhAaMtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhAaLhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 06:37:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4F4C061756
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 03:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7xnkQ/SLhOxUZ6EbeM7vQ65BhfxAYFaNTooCQTPQwT4=; b=vzOq2W+Y0/H314GSFYhfkCjTB
        AmHBHxNuUbYqJLaFScdcdDzBJdrGZfx1dOH8Lw5OxKd2OsoCsFm8T4QmBjhMs8ZOrgBtKipap/c9q
        12lD4H/eiw400zKY1c8N8JbZKaMtgb1O0aWyhgkKJY1OuAnPQz3cxPS7HlRQA0qmugam/er9j4x5a
        gnDbi1UXkVhtv1/SCIAKmduZD+rWoNwu07EN1v4Ej7D6vFJWECx+i/s7Two+lAbmxsdxbuoq4DgkF
        G5bgr6HF74lumuhGaoMaKxQFS/J4Q2iZSjhAn+2E6bQKN8SDr/bIKxZ6MBXLgWJFFnQTkJSyDe8rS
        hzy+ACcJA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37304)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6AeO-0002MB-53; Sun, 31 Jan 2021 11:12:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6AeM-0000y3-T2; Sun, 31 Jan 2021 11:12:14 +0000
Date:   Sun, 31 Jan 2021 11:12:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Re: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Message-ID: <20210131111214.GB1463@shell.armlinux.org.uk>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 10:51:46AM +0000, Stefan Chulski wrote:
> 
> > > Hi,
> > >
> > > Armada has options for 1G/10G ports without PHY's(for example
> > community board Macchiato single shot).
> > > This port doesn't have PHY's and cannot negotiate Flow Control support,
> > but we can for example connect two ports without PHY's and manually(by
> > ethtool) configure FC.
> > 
> > On the Macchiatobin single shot, you use the existing SFP support rather
> > than forcing them to fixed link.
> > 
> > > Current phylink return error if I do this on ports with
> > MLO_AN_FIXED(callback phylink_ethtool_set_pauseparam):
> > > if (pl->cur_link_an_mode == MLO_AN_FIXED)
> > >                 return -EOPNOTSUPP;
> > >
> > > How can we enable FC configurations for these ports? Do you have any
> > suggestions or should I post my proposal as an RFC patch?
> > 
> > If you really must use fixed-link, you specify the pause modes via firmware,
> > just as you specify the speed and duplex - you specify the link partner's flow
> > control abilities.
> 
> In this case we cannot change this by ethtool during runtime?

I discussed it with Andrew earlier last year, and his response was:

 DT configuration of pause for fixed link probably is sufficient. I don't
 remember it ever been really discussed for DSA. It was a Melanox
 discussion about limiting pause for the CPU. So I think it is safe to
 not implement ethtool -A, at least until somebody has a real use case
 for it.

So I chose not to support it - no point supporting features that people
aren't using. If you have a "real use case" then it can be added.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
