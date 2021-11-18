Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF04561A5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhKRRmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbhKRRmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:42:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33690C061574;
        Thu, 18 Nov 2021 09:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G6vwF896R9vK6ajugRYWK8Vbv0JXeNCUVwfNbElIQOw=; b=Y/9tMx1630WIhrfXHt5KMkZGcA
        p2HA1/G2tw3DqV6iiGT/K38NiFgXo32bErWNDTDqG+pGxn//SqsfpQuPDrF/Dy5ZcaIRJIK/d/9Zv
        KEg+Sp00RQZFBDOm0Pb9yxfgp9s/++q4/COmuDscuYSQkae6sPQN5ZVnRV9zely1ncf4cj0joloWc
        0yDrVGCm39jy8g1sPdvrkM544Wzz8uwhsZEIM5Iw2xYreX23CaWpHMqnobmwN2p08wWBsdHpv5hoN
        +EU3EmJjV1fRhwzOOiHE5B7axy8lDHNcOBb07NsGiCCPvbUxYEy9xeCtsnzDSdqDtc2r4Rqc9qang
        TKD6TKIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55734)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnlNa-0003CH-DS; Thu, 18 Nov 2021 17:39:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnlNZ-00047b-PW; Thu, 18 Nov 2021 17:39:21 +0000
Date:   Thu, 18 Nov 2021 17:39:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
Message-ID: <YZaPyZ6VjTWvP1Kr@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-5-kabel@kernel.org>
 <YZYXctnC168PrV18@shell.armlinux.org.uk>
 <YZaAXadMIduFZr08@lunn.ch>
 <YZaIeiOyhqyVNG8D@shell.armlinux.org.uk>
 <20211118183301.50dab085@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118183301.50dab085@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 06:33:01PM +0100, Marek Behún wrote:
> On Thu, 18 Nov 2021 17:08:10 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > I'm quite certain that as we try to develop phylink, such as adding
> > extra facilities like specifying the interface modes, we're going to
> > end up running into these kinds of problems that we can't solve, and
> > we are going to have to keep compatibility for the old ways of doing
> > stuff going for years to come - which is just going to get more and
> > more painful.
> 
> One way to move this forward would be to check compatible of the
> corresponding MAC in this new function. If it belongs to an unconverted
> driver, we can ensure the old behaviour. This would require to add a
> comment to the driver saying "if you convert this, please drop the
> exception in phylink_update_phy_modes()".

That could work when drivers pass the fwnode as the "device" node.
Some drivers don't do that, they pass a sub-node instead - such as
mvpp2. However, mvpp2 is of course up to date with all phylink
developments.

However, the same issue exists with DSA - the fwnode passed to
phylink doesn't have a compatible. I suppose we could walk up the
fwnode tree until we do find a node with a compatible property,
that may work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
