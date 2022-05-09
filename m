Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73B75201BD
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbiEIP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiEIP64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:58:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15EC45525
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N/xQBa+OupZrdoZfDhtw9UOlembeCinAABLP6ZVJlVM=; b=bF1K+Bd9/mPr9cgTaY4P40VZXW
        BCSIonJ335LPRXw6cyoUHCBam6Z1P7Ry2ydiSzd0U64XuYRAn3WyG/zZlq/BL+78Ie2UUeD8tgFoH
        MJMzrVKbjbqEi4nuuQJeKo5Vu3VzBNW4zzR3eVCgZAaJXoTCYOQkZRHdrzqfYeJNK8hdSji01R2yl
        L3IxeFat0KF5ckkBUTnMG2+clM8kxWwYbSP0ZEfdML9V4y6VIFX/4S+rwrESZJU+VyTcY8acRfST8
        LbZ5fyc+phEBt2JUvNjQj2vy8LsGSNo12uHfD5ExzyNgMP1S79dfagPXRlZ7DmvD+ARh+41WjIbVA
        H6uOMI7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60646)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1no5ir-0003Ib-Es; Mon, 09 May 2022 16:54:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1no5iq-0005E8-7W; Mon, 09 May 2022 16:54:56 +0100
Date:   Mon, 9 May 2022 16:54:56 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509122938.14651-1-josua@solid-run.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
> Dear Maintainers,
> 
> I am working on a new device based on the LX2160A platform, that exposes
> 16 sfp connectors, each with its own led controlled by gpios intended
> to show link status.
> This patch intends to illustrate in code what we want to achieve,
> so that I can better ask you all:
> How can this work with the generic led framework, and how was it meant to work?
> 
> The paragraphs below are a discussion of paths I have explored without success.
> Please let me know if you have any opinions and ideas.
> 
> Describing in device-tree that an led node belongs to a particular network
> device (dpmac) however seems impossible. Instead the standard appears to work
> through triggers, where in device-tree one only annotates that the led should
> show a trigger "netdev" or "phy". Both of these make no sense when multiple
> network interfaces exist - raising the first question:
> How can device-tree indicate that an individual led should show the events of
> a particular network interface?
> 
> We have found that there is a way in sysfs to echo the name of the network
> device to the api of the led driver, and it will start showing link status.
> However this has to be done at runtime by the user.
> But network interface names are unstable. They depend on probe order and
> can be changed at will. Further they can be moved to different namespaces,
> which will allow e.g. two instances of "eth0" to coexist.
> On the Layerscape platform in particular these devices are created dynamically
> by the networkign coprocessor, which supports complex functions such as
> creating one network interface that spans multiple ports.
> It seems to me that the netdev trigger therefore can not properly reflect
> the relation between an LED (which is hard-wired to an sfp cage), and the
> link state reported by e.g. a phy inside an sfp module.
> 
> There exists also a phy trigger for leds.
> When invoking the phy_attach or phy_connect functions from the generic phy
> framework to connect an instance of net_device with an instance of phy_device,
> a trigger providing the link and speed events is registered.
> You may notice that again leds are tied to existence of a particular logical
> network interface, which may or may not exist, and may span multiple
> physical interfaces in case of layerscape.
> This is a dead end though, simply because the dpaa2 driver does not even use
> objects of phy_device, so this registering of triggers never happens.
> 
> In addition the dpmac nodes in device-tree don't really have a phy modeled.
> One end are the serdes which are managed by the networking coprocessor.
> The other end has removable sfp modules, which may or may not contain a phy.
> 
> The serdes are modeled as phy in device-tree though, perhaps the dpaa2 driver
> could be extended to instantiate phy_device objects for the serdes?
> However I feel like this would especially not solve when mutliple physical
> ports are used as one logical interface.
> 
> It seems to me that there should be a way to explicitly link gpio-driven LEDs to
> either specific phy nodes, or specific sfp connectors - and have them receive
> link events from the respective phy, fully independent even from whether there
> is a logical network interface.
> 
> If you got here, thank you very much for reading!
> Ay comments?

You really don't need any of this.

We already have the "netdev" trigger - you just need to assign the LED
to the appropriate netdev link.

I do this on the SolidSense platform with the two LEDs when using it as
my internet gateway on the boat - one LED gives wlan status, the other
LED gives wwan status, both of them green for link and red for tx/rx
activity.

Exactly the same can be done with SFPs if the net device is exclusive
to the SFP socket. Doing it this way also tells you that the netdev
link is up, not just that a SFP has decided to deassert the RXLOS
signals, which on some SFPs is tied inactive.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
