Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16149391C53
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhEZPsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbhEZPsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:48:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026C7C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FQ3+qLJeDs/yhLVDx0p9Cm5eCT5k0xUV+GC0JxJ+LPo=; b=TwdKnwRPn1DH7N8z4rBBLB8VK
        cSCFInNRrgQFGHGbA/7z9lmF8umljbE17g3UQ81aQLvm0fvCPDyNTXo2726sZunQu5dW5XUTBY2g1
        HCD7hnRD3QoA7BlxdVOzjFtX/I5XzMuFFr+YNNX/2gJE4HRCqTNMDObmvJ9nYnCo9sowfQdpuJByf
        7SkdI4bRqX+6WRk9+oh+2E1nUEcLWGVunkm3F5fN+3rB5aPqrUwRO32bNsixsMl/zvkWp6uNMyAX+
        eUJXceUfc4m7vvdv9MMXRLz67uMxtfIyWmmXh0YLvPd5Es/WVe4QnnnUXL68iHgh/gNEU0j4qKK0V
        jTD8CJ8/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44384)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llvk1-0005sw-Qh; Wed, 26 May 2021 16:46:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llvk1-0002wa-J5; Wed, 26 May 2021 16:46:41 +0100
Date:   Wed, 26 May 2021 16:46:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 13/14] net: dsa: sja1105: expose the
 SGMII PCS as an mdio_device
Message-ID: <20210526154641.GJ30436@shell.armlinux.org.uk>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-14-vladimir.oltean@nxp.com>
 <20210526152911.GH30436@shell.armlinux.org.uk>
 <20210526154102.dlp2clwqncadna2v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526154102.dlp2clwqncadna2v@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:41:02PM +0300, Vladimir Oltean wrote:
> On Wed, May 26, 2021 at 04:29:11PM +0100, Russell King (Oracle) wrote:
> > On Wed, May 26, 2021 at 04:55:34PM +0300, Vladimir Oltean wrote:
> > > Since we touch all PCS accessors again, now it is a good time to check
> > > for error codes from the hardware access as well. We can't propagate the
> > > errors very far due to phylink returning void for mac_config and
> > > mac_link_up, but at least we print them to the console.
> > 
> > phylink doesn't have much option on what it could do if we error out at
> > those points - I suppose we could print a non-specific error and then
> > lock-out the interface in a similar way that phylib does, but to me that
> > seems really unfriendly if you're remotely accessing a box and the error
> > is intermittent.
> 
> I would like to have intermittent errors at this level logged, because
> to me they would be quite unexpected and I would like to have some rope
> to pull while debugging - an error code, something.
> 
> If there's an error of any sort, the interface won't be fully
> initialized anyway, so not functional.
> 
> The reason why I added error checking in this patch is because I was
> working on the MDIO bus accessors and I wanted to make sure that the
> errors returned there are propagated somewhere.

Yes, makes sense there, but doesn't make sense if one is using the MMIO
accessors and have no errors to check...

My argument is - if you print an error at the lower levels, you can be
more specific about what failed. If you do it in phylink, you can only
say "oh, the blah_config() call failed" - which isn't particularly
useful.

Yes, we do this for some of the newly introduced methods, e.g. the
pcs_config() method - and there all we can say is:

                if (err < 0)
                        phylink_err(pl, "pcs_config failed: %pe\n",
                                    ERR_PTR(err));

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
