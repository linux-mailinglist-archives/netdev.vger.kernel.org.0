Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7A4E80FA
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiCZNGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiCZNGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 09:06:09 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1054C52E21
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 06:04:31 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 2B0283000034F;
        Sat, 26 Mar 2022 14:04:30 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 1D7DF2E6C12; Sat, 26 Mar 2022 14:04:30 +0100 (CET)
Date:   Sat, 26 Mar 2022 14:04:30 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220326130430.GD31022@wunner.de>
References: <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de>
 <Yj8L2Jl0yyHIyW1m@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj8L2Jl0yyHIyW1m@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 01:49:28PM +0100, Andrew Lunn wrote:
> On Sat, Mar 26, 2022 at 01:39:29PM +0100, Lukas Wunner wrote:
> > On Mon, Mar 21, 2022 at 02:10:27PM +0100, Andrew Lunn wrote:
> > > There are two patterns in use at the moment:
> > > 
> > > 1) The phy is attached in open() and detached in close(). There is no
> > >    danger of the netdev disappearing at this time.
> > > 
> > > 2) The PHY is attached during probe, and detached during release.
> > > 
> > > This second case is what is being used here in the USB code. This is
> > > also a common pattern for complex devices. In probe, you get all the
> > > components of a complex devices, stitch them together and then
> > > register the composite device. During release, you unregister the
> > > composite device, and then release all the components. Since this is a
> > > natural model, i think it should work.
> > 
> > I've gone through all drivers and noticed that some of them use a variation
> > of pattern 2 which looks fishy:
> > 
> > On probe, they first attach the PHY, then register the netdev.
> > On remove, they detach the PHY, then unregister the netdev.
> > 
> > Is it legal to detach the PHY from a registered (potentially running)
> > netdev? It looks wrong to me.
> 
> I think the network stack guarantee that the close() method is called
> before unregister completes. It is a common pattern to attach the PHY
> in open() and detach it in close(). The stack itself should not be
> using the PHY when it is down, the exception being IOCTL handlers
> which people often get wrong.

But the PHY is detached from a *running* netdev *before* that netdev
is unregistered (and closed).  Is that really legal?

Thanks,

Lukas
