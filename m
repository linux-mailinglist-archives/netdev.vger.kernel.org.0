Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E665200A2D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbgFSNa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgFSNa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:30:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85353C06174E;
        Fri, 19 Jun 2020 06:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=azXx+i4S6hGMFy3RKW3uS2B0gRoR0Q1Z9mL5C3k3bY0=; b=Uc7SmMk5/u0wACt4N71eioHY8
        RjMnWJC2yICgwohM9JvfHLNjWjh0qB10LKq8KjSqsLn/sw/kX/rD2+WTwy8z0p+drXmr60KVn7OQv
        yPHpXeqGVRhakbNEs1i4PZPGu3zfRwyhRwJWXqmK7J3lJiUPPjZB1rKMYpocq9mXMFVfode+0L7zd
        sYzU4Oo/VxX/Q9a7jJo98OGRiPSLE4SVUZlzvNJ8FtSX34aIqF2hnTWuYSsbeLlWQWjK+J5jPu14V
        bGDujoYbyNmjFyXu0TDoKEfYQV5cQZY6kLwFK4tntgcZmi+sIPlTqU8zzc5kdB3SDwpao1qKI8OI0
        1BDlZFTlA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58832)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jmH6R-0006V0-1q; Fri, 19 Jun 2020 14:30:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jmH6O-0005gb-H4; Fri, 19 Jun 2020 14:30:40 +0100
Date:   Fri, 19 Jun 2020 14:30:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: phy: Check harder for errors in get_phy_id()
Message-ID: <20200619133040.GO1551@shell.armlinux.org.uk>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
 <20200619044759.11387-3-f.fainelli@gmail.com>
 <20200619132659.GB304147@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619132659.GB304147@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 03:26:59PM +0200, Andrew Lunn wrote:
> On Thu, Jun 18, 2020 at 09:47:59PM -0700, Florian Fainelli wrote:
> > Commit 02a6efcab675 ("net: phy: allow scanning busses with missing
> > phys") added a special condition to return -ENODEV in case -ENODEV or
> > -EIO was returned from the first read of the MII_PHYSID1 register.
> > 
> > In case the MDIO bus data line pull-up is not strong enough, the MDIO
> > bus controller will not flag this as a read error. This can happen when
> > a pluggable daughter card is not connected and weak internal pull-ups
> > are used (since that is the only option, otherwise the pins are
> > floating).
> > 
> > The second read of MII_PHYSID2 will be correctly flagged an error
> > though, but now we will return -EIO which will be treated as a hard
> > error, thus preventing MDIO bus scanning loops to continue succesfully.
> > 
> > Apply the same logic to both register reads, thus allowing the scanning
> > logic to proceed.
> 
> Hi Florian
> 
> Maybe extend the kerneldoc for this function to document the return
> values and there special meanings?

You mean like the patch I sent yesterday?

> BTW: Did you look at get_phy_c45_ids()? Is it using the correct return
> value? Given the current work being done to extend scanning to C45,
> maybe it needs reviewing for issues like this.

And the updates I sent for this yesterday? ;)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
