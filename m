Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B43C6A98F2
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCCN7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCCN7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:59:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97BC125BC
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=BCO/0SLa+xx0Eq9cpMXmQOz4uqAeeAUwV/2AlUlazaw=; b=HB
        m6IHiLnJJgyGNXu1MvO3G2Kvc8W1lEhmd0z+GDB4K8HkMW9QWRU2nEcuwXVt/orN0d8/eM7y2hrCz
        GaDVgXjOsYzAlPrGDvq+5a1T/wLxbR0rErn3FZ0HbAw34jDcxwbTCBqr30BFFeKzuVV9Ymb29nmuJ
        voKJE8p/p/14VbI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pY5wo-006OCz-Qp; Fri, 03 Mar 2023 14:59:46 +0100
Date:   Fri, 3 Mar 2023 14:59:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Michael Walle <michael@walle.cc>, linux@armlinux.org.uk,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAH9UhCSMFrhX3GJ@lunn.ch>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
 <ZAH0FIrZL9Wf4gvp@lunn.ch>
 <20230303143455.224462ea@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230303143455.224462ea@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 02:34:55PM +0100, Köry Maincent wrote:
> On Fri, 3 Mar 2023 14:20:20 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > I'm not sure we are making much progress here...
> > 
> > Lets divide an conquer. As far as i can see we have the following bits
> > of work to do:
> > 
> > 1) Kernel internal plumbing to allow multiple time stampers for one
> > netdev. The PTP core probably needs to be the mux for all kAPI calls,
> > and any internal calling between components. This might mean changes
> > to all MAC drivers supporting PTP and time stampers. But i don't think
> > there is anything too controversial here, just plumbing work.
> > 
> > 2) Some method to allow user space to control which time stamper is
> > used. Either an extension of the existing IOCTL interface, or maybe
> > ethtool. Depending on how ambitious we want to be, add a netlink API
> > to eventually replace the IOCTL interface?
> 
> Isn't the patch series (with small revisions) from Richard sufficient for this
> two points?
> https://lkml.kernel.org/netdev/Y%2F0N4ZcUl8pG7awc@shell.armlinux.org.uk/

I've not looked at it. How about you make the small revisions and post
it. So long as the Marvell PHY PTP code is not merged, it should be
safe to work on these parts and not cause regressions.

> > 3) Add a device tree binding to control which time stamper is
> > used. Probably a MAC property. Also probably not too controversial.
> > 
> > 4) Some solution to the default choice if there is no DT property.
> 
> And in cases of architectures which do not support DT how do we deal with it?

x86 has ACPI. It seems like ACPI folks are happy to simply stuff DT
properties into ACPI nodes, rather than come up with a native ACPI
way. But we don't really need to support ACPI until somebody has an
ACPI board which needs to configure the time stamper.

Harder is things like USB, which mostly never has DT properties. But a
USB dongle tends to have known components, both the MAC and the PHY is
known, and so the dongle driver could make a call into the PTP core to
select which time stamper should be used. But i would suggest we solve
this problem when we actually reach it, not now.

     Andrew
