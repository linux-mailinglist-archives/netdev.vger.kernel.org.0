Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B8D466CF8
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244131AbhLBWjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:39:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238803AbhLBWjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 17:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E2ZQufWrzofDnKHyWJaWMhk0I2dw6veQFpqqAeuR3aU=; b=H3UxwnBN0uwgzwktnlsfS7LbBo
        S2wT+IIsPCtthYIJ7YSl4gXn3dzx1s/sOUTe0yXV6K6JeDJkSXYRQs79kbZQM0/XYvAUphEXPWSuL
        HuHHHMyzoEEEcdHQH54deZqQe/I6HDZRSus1q+32pD+Wi7vSkoD+1dMs/79qnp14LptU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msugC-00FMx5-4J; Thu, 02 Dec 2021 23:35:52 +0100
Date:   Thu, 2 Dec 2021 23:35:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Arijit De <arijitde@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: How to avoid getting ndo_open() immediately after probe
Message-ID: <YalKSIlxgt1utNOk@lunn.ch>
References: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
 <83adf5a5-11a2-e778-e455-c570caca7823@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83adf5a5-11a2-e778-e455-c570caca7823@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 09:29:21PM +0100, Lino Sanfilippo wrote:
> 
> Hi,
> 
> On 02.12.21 at 19:11, Arijit De wrote:
> > Hi,
> >
> > I have handled the probe() and registered the netdev structure using register_netdev().
> > I have observed in other opensource driver(i.e. Intel e1000e driver) that ndo_open() gets called only when we try to bring up the interface (i.e. ifconfig <ip> ifconfig eth0 <ip-addr> netmask <net-mask> up).
> > But in my network driver I am getting ndo_open() call immediately after I handle the probe(). It's a wrong behavior, also my network interface is getting to UP/RUNNING state(as shown below) even without any valid ip address.
> 
> There is nothing wrong here. As soon as you register the netdevice with the kernel it is available
> for userspace and userspace is free to bring it up. This may happen immediately after registration,
> so your driver has to be prepared for this.
> Its absolutely fine to bring up a network device without any ip address assigned.

And if you are using NFS root, the kernel can actually call ndo_open()
before register_netdev() even completes.

This is a common bug i look for in new drivers, register_netdev()
pretty much has to be the last thing done inside the probe function.

       Andrew
