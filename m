Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338914CB4FA
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiCCCdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiCCCdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:33:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2337313D29
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 18:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/lEQGxdI46nMh/bOHvmr688PKLIDsxNoYda3hUYRO9U=; b=K0bRWIOWnVU5t2hWNsrSxU6e1c
        jvNZZURERjI2Q6N3k0CNV3JEi0VSe1OOxeTyNbgjHXH5VFQluzuIGmlf1qGYMfZGBC7KMb6YD0Qg0
        IB69EF/iXH9ULLp6/crmwcQW3/NxImvltvM4CI6d4FWHMapDeWcWqzvdhMFgAxieWspg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPbGH-00916T-1C; Thu, 03 Mar 2022 03:32:13 +0100
Date:   Thu, 3 Mar 2022 03:32:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Subject: Re: smsc95xx warning after a 'reboot' command
Message-ID: <YiAorTOXfE20snfz@lunn.ch>
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
 <Yh/r5hkui6MrV4W6@lunn.ch>
 <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
 <YiACuNTd9lzN6Wym@lunn.ch>
 <CAOMZO5ChowWZgryE14DoQG5ORNnKrLQAdQwt6Qsotsacneww3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ChowWZgryE14DoQG5ORNnKrLQAdQwt6Qsotsacneww3Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 09:40:54PM -0300, Fabio Estevam wrote:
> On Wed, Mar 2, 2022 at 8:50 PM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > If i'm reading this correctly, this is way to late, the device has
> > already gone. The PHY needs to be stopped while the device is still
> > connected to the USB bus.
> >
> > I could understand a trace like this with a hot unplug, but not with a
> > reboot. I would expect things to be shut down starting from the leaves
> > of the USB tree, so the smsc95xx should have a chance to perform a
> > controlled shutdown before the device is removed.
> >
> > This code got reworked recently. smsc95xx_disconnect_phy() has been
> > removed, and the phy is now disconnected in smsc95xx_unbind(). Do you
> > get the same stack trace with 5.17-rc? Or is it a different stack
> > trace?
> 
> Just tested 5.17-rc6 and I get no stack strace at all after a 'reboot' command:
> 
> [   21.953945] ci_hdrc ci_hdrc.1: remove, state 1
> [   21.958418] usb usb2: USB disconnect, device number 1
> [   21.963493] usb 2-1: USB disconnect, device number 2
> [   21.964227] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   21.968469] usb 2-1.1: USB disconnect, device number 3
> [   21.970808] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
> usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
> [   21.975619] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> [   21.975625] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> [   22.002479] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   22.009630] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> [   22.015392] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> [   22.021939] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   22.029087] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> [   22.034845] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> [   22.041743] smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
> [   22.068706] usb 2-1.4: USB disconnect, device number 4
> [   22.077327] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
> [   22.085222] ci_hdrc ci_hdrc.0: remove, state 4
> [   22.089685] usb usb1: USB disconnect, device number 1
> [   22.095284] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
> [   22.122356] imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
> [   22.129073] reboot: Restarting system
> 
> I applied a049a30fc 27c ("net: usb: Correct PHY handling of smsc95xx")
> into 5.10.102, but it did not help.

I'm not a USB expert, but to me, it looks like the smsc95xx device is
being disconnected, rather than being unloaded. So it is already gone
by the time the PHY device is disconnected.

It would be good to have somebody who understands USB net devices to
take a look at this, in particularly the order. I'm wondering if there
is a hub in the middle, and the hub is being disabled, or a regulator
for the hub etc?

    Andrew
