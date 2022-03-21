Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5B4E2743
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347764AbiCUNMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347766AbiCUNL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:11:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1EC24593
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U84eapp70vg6ZJkBFuxiAdBbl01ch9vakBCjxl+Ofqo=; b=dyjy8+mUVWCEY4YUU118FlNR53
        VOF22BUKVVWw1j99nP218y3WKlQVnsXzg2bT2YTFXScx8lKVZF2v2vY3GEvHWBlaPuBptd2w2Rpah
        TeylaL8eEIl8w7w5DrD25XS4G5guO+AcLL9Bay/l4wdFWXiwDUcOdmYTq7ZP7Wr96jrQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWHnn-00BwoF-2i; Mon, 21 Mar 2022 14:10:27 +0100
Date:   Mon, 21 Mar 2022 14:10:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <Yjh5Qz8XX1ltiRUM@lunn.ch>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321100226.GA19177@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It turns out that unregistering a net_device and then calling
> phy_disconnect() may indeed crash and is thus not permitted
> right now:
> 
> Oleksij added the following code comment with commit e532a096be0e
> ("net: usb: asix: ax88772: add phylib support"):
> 
>   /* On unplugged USB, we will get MDIO communication errors and the
>    * PHY will be set in to PHY_HALTED state.
> 
> So the USB adapter gets unplugged, access to MII registers fails with
> -ENODEV, phy_error() is called, phy_state_machine() transitions to
> PHY_HALTED and performs the following call:
> 
>   phy_state_machine()
>     phy_link_down()
>       phy_link_change()
>         netif_carrier_off()
>           linkwatch_fire_event()
> 
> Asynchronously, usbnet_disconnect() calls phy_detach() and then
> free_netdev().
> 
> A bit later, linkwatch_event() runs and tries to access the freed
> net_device, leading to the crash that Oleksij posted upthread.
> 
> The fact that linkwatch_fire_event() increments the refcount doesn't
> help because unregister_netdevice() has already run (it waits for
> the refcount to drop to 1).
> 
> My suggestion would be to amend unregister_netdevice() to set
> dev->phydev->attached_dev = NULL.  It may also be a good idea
> to WARN_ON() in free_netdev() if the refcount is not 1.
> 
> Andrew, please clarify whether you really think that the
> "unregister netdev, then detach phy" order should be supported.

There are two patterns in use at the moment:

1) The phy is attached in open() and detached in close(). There is no
   danger of the netdev disappearing at this time.

2) The PHY is attached during probe, and detached during release.

This second case is what is being used here in the USB code. This is
also a common pattern for complex devices. In probe, you get all the
components of a complex devices, stitch them together and then
register the composite device. During release, you unregister the
composite device, and then release all the components. Since this is a
natural model, i think it should work.

A WARN_ON() for refcount not 1 makes a lot of sense.

dev->phydev->attached_dev = NULL im less sure about. That is what
detach is all about. I think we need to review the code and see if the
normal path is making use of netdev, or is this problem limited to
phy_error(), which the USB code is invoking? It maybe we need to make
phy_error() more paranoid, or not even used in detach.

	    Andrew
