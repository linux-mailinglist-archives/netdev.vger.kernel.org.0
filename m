Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC434250F0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbhJGKZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJGKZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 06:25:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E63C061746;
        Thu,  7 Oct 2021 03:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r0U/iTA60QYXWCrj5e6Z8Pr7LTFjUofoIHZmCxMnt3E=; b=h9NszHQMEPXZeLb93tVSXfI6eh
        MCnLEOSLRg/VHkbAn+/cvYLkMTNnK1Hcgeu7/5Xv91zUoT7UmFaydqKzuJKviPyY/Xn+9eV4cjpJX
        UTOd5SxXxxMbmfX4HmFwq8DDYkjrBYGpeURCM0YxkuJdGDAWZgVcRXhCEq8OWR81L+RQ2HSPKbChN
        gq7NQsHzUiS0XjXuPIXdJZAd7Nh1i6TwtdLMvGh3zGpjwMIi9Tr0rPw69sDhv8WI06MogvwN8pjIy
        PjiDa+SciAUqc9+BwdTuGGL1tD0w/0LQOIDNG3wXfn6b4F29iEqRITr0s6cq6Ze823Zd6v8yP1xM/
        5krYM7qg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54992)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mYQYr-0002Jx-Ii; Thu, 07 Oct 2021 11:23:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mYQYp-0001oi-AK; Thu, 07 Oct 2021 11:23:35 +0100
Date:   Thu, 7 Oct 2021 11:23:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: [RFC net-next PATCH 05/16] net: phylink: Automatically attach
 PCS devices
Message-ID: <YV7Kp2k8VvN7J0fY@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-6-sean.anderson@seco.com>
 <YVwfWiMOQH0U5bay@shell.armlinux.org.uk>
 <61147f21-6de4-d91e-c16f-fdb539e52b42@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61147f21-6de4-d91e-c16f-fdb539e52b42@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 12:42:53PM -0400, Sean Anderson wrote:
> 
> 
> On 10/5/21 5:48 AM, Russell King (Oracle) wrote:
> > On Mon, Oct 04, 2021 at 03:15:16PM -0400, Sean Anderson wrote:
> > > This adds support for automatically attaching PCS devices when creating
> > > a phylink. To do this, drivers must first register with
> > > phylink_register_pcs. After that, new phylinks will attach the PCS
> > > device specified by the "pcs" property.
> > > 
> > > At the moment there is no support for specifying the interface used to
> > > talk to the PCS. The MAC driver is expected to know how to talk to the
> > > PCS. This is not a change, but it is perhaps an area for improvement.
> > > 
> > > I believe this is mostly correct with regard to registering/
> > > unregistering. However I am not too familiar with the guts of Linux's
> > > device subsystem. It is possible (likely, even) that the current system
> > > is insufficient to prevent removing PCS devices which are still in-use.
> > > I would really appreciate any feedback, or suggestions of subsystems to
> > > use as reference. In particular: do I need to manually create device
> > > links? Should I instead add an entry to of_supplier_bindings? Do I need
> > > a call to try_module_get?
> > 
> > I think this is an area that needs to be thought about carefully.
> > Things are not trivial here.
> > 
> > The first mistake I see below is the use of device links. pl->dev is
> > the "struct device" embedded within "struct net_device". This doesn't
> > have a driver associated with it, and so using device links is likely
> > ineffectual.
> 
> So what can the device in net_device be used for?

That is used for the class device that is commonly found in
/sys/devices/$pathtothedevice/net/$interfacename

> > Even with the right device, I think careful thought is needed - we have
> > network drivers where one "struct device" contains multiple network
> > interfaces. Should the removal of a PCS from one network interface take
> > out all of them?
> 
> Well, it's more of the other way around. We need to prevent removing the
> PCS while it is still in-use.

devlinks don't do that - if the "producer" device goes away, they force
the "consumer" device to be unbound.

As I mention above, the "consumer" device, which would be the device
providing the network interface(s) could have more than one interface
and unbinding it could have drastic consequences for the platform.

> > Alternatively, could we instead use phylink to "unplug" the PCS and
> > mark the link down - would that be a better approach than trying to
> > use device links?
> 
> So here, I think the logic should be: allow phylink to "unplug" the PCS
> only when the link is down.

When a device is unbound from its driver, the driver has no say in
whether that goes ahead or not. Think about it as grabbing that USB
stick plugged into your computer and you yanking it out. None of the
software gets a look in to say "don't do that".

phylink (or any other subsystem) does not have the power to say
"I don't want XYZ to be removed".

Yes, it's harder to do that with PCS, but my point is that if one asks
the driver model to unbind the PCS driver from the PCS device, then
the driver model will do that whether the PCS driver wants to allow it
at that moment or not. It isn't something the PCS driver can prevent.

One can tell the driver model not to expose the bind/unbind attributes
for the driver, but that doesn't stop the unbind happening should the
struct device actually go away.

So, IMHO, it's better to design assuming that components will go away
at an inconvenient time and deal with it gracefully.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
