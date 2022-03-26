Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D584E80ED
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiCZMvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiCZMvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:51:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF4D49F80
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IiOqQVqNDorSEOcIS0u9fYArgUgRXKoO1VlYQa/w7d4=; b=XihdTeNlJPlfCZSOd1MTwWZTt0
        xcvVT0q/Io0zpxcr4a0dXplyUAuYtTXUMVt+CzfrWsjGdR9En0dlvQGJNULoEg7Z6MHVTLj8Znydc
        orQkasVEisqOeFsCGoZaDKczJZN7dzY2YGinfT3R17a4JFg0Wq28K4c+OoxahZCgZ4e4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nY5rE-00Clyb-C9; Sat, 26 Mar 2022 13:49:28 +0100
Date:   Sat, 26 Mar 2022 13:49:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <Yj8L2Jl0yyHIyW1m@lunn.ch>
References: <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326123929.GB31022@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 01:39:29PM +0100, Lukas Wunner wrote:
> On Mon, Mar 21, 2022 at 02:10:27PM +0100, Andrew Lunn wrote:
> > There are two patterns in use at the moment:
> > 
> > 1) The phy is attached in open() and detached in close(). There is no
> >    danger of the netdev disappearing at this time.
> > 
> > 2) The PHY is attached during probe, and detached during release.
> > 
> > This second case is what is being used here in the USB code. This is
> > also a common pattern for complex devices. In probe, you get all the
> > components of a complex devices, stitch them together and then
> > register the composite device. During release, you unregister the
> > composite device, and then release all the components. Since this is a
> > natural model, i think it should work.
> 
> I've gone through all drivers and noticed that some of them use a variation
> of pattern 2 which looks fishy:
> 
> On probe, they first attach the PHY, then register the netdev.
> On remove, they detach the PHY, then unregister the netdev.
> 
> Is it legal to detach the PHY from a registered (potentially running)
> netdev? It looks wrong to me.

I think the network stack guarantee that the close() method is called
before unregister completes. It is a common pattern to attach the PHY
in open() and detach it in close(). The stack itself should not be
using the PHY when it is down, the exception being IOCTL handlers
which people often get wrong.

So i don't think this is an issue.

   Andrew
