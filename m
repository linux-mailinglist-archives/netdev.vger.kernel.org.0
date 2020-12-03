Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000A92CD9D9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgLCPIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:08:46 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:33352
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgLCPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:08:46 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkqDD-0001P3-Rr
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 16:08:03 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Thu, 3 Dec 2020 15:07:58 -0000 (UTC)
Message-ID: <rqav0e$4m3$1@ciao.gmane.io>
References: <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io> <20201203040758.GC2333853@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03, Andrew Lunn <andrew@lunn.ch> wrote:
>> So I can avoid my local hack to macb_main.c by doing a doing a local
>> hack to macb_main.c?
>
> User space drivers were never supported in any meaningful way. The
> IOCTL call is basically there for mii-tool, and nothing much more.

I probably wouldn't call a single ioctl() to check the link status a
user-space-driver, but I guess that's what it is. If it's good enough
for the mii-tool, it's good enough for me.

> The way to avoid your local hack is to move your drivers into the
> kernel, along side all the other drivers for devices on MDIO busses.

I don't think I can justify the additional effort to devlope and
maintain a custom kern-space driver. We've already got a custom macb
driver, and writing a spearate driver in order to remove a handful of
lines from the macb driver just isn't worth it.

What has confused me all along was Florian Fainelli's post:

>> [I modified the macb driver to support fixed PHY plus mdio access]
>
> That should be unnecessary see below.
>
>> Was there some other way I should have done this with a 5.4 kernel
>> that I was unable to discover?
>
> You should be able to continue having the macb MDIO bus controller
> be registered with no PHY/MDIO devices represented in Device Tree
> such that user-space can continue to use it for ioctl() *and* you
> can point the macb node to a fixed PHY for the purpose of having
> fixed link parameters.

But to do that, I have to modify the macb driver to support a fixed
PHY plus mdio access. What would be the advantage of that modification
over the modification I've already made and tested?

Alternatively, I could write a seperate kernel driver that would "own"
the macb's mdio bus and provide some something equivalent to the
existing SIOC[SG]MIIREG ioctl() calls to access the devices on that
mdio bus.

Thanks for clearing this up for me.

BTW Andrew, we're still shipping plenty of product that running
eCos. :)

--
Grant

