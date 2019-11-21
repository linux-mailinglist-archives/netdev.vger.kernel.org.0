Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43A11048A0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKUCk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfKUCk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y4wjRpQvsAPhU0ecdnz6Kh4okkQOALRAUnYIw6eZfqg=; b=QQGLgBNXJ2zuXQWXmGy6ADebxO
        Vpc+tAldP65ZncaFN9Brw9ADK6Yh+QNIrbfl/ukIl/g/8a7Wvpq74DVqBYlaVEZH3qLaudBZZ+IJh
        mi7valFbQMCPVTTZSJW0mBCup+bJxPzoUaHBJmtP8dpcvSx12xsTdofwNcMZ3HcVfGcQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXbtP-000707-0F; Thu, 21 Nov 2019 03:08:23 +0100
Date:   Thu, 21 Nov 2019 03:08:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        David Bauer <mail@david-bauer.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Bauer <mail@david-bauer.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
Message-ID: <20191121020822.GD18325@lunn.ch>
References: <20191118181505.32298-1-marek.behun@nic.cz>
 <20191119102744.GD32742@smile.fi.intel.com>
 <alpine.DEB.2.21.1911201053330.25420@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1911201053330.25420@ramsan.of.borg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The difference with the non-optional case is that
> __devm_reset_control_get() registers a cleanup function if there's
> no error condition, even for NULL (which is futile, will send a patch).
> 
> However, more importantly, mdiobus_register_reset() calls a devm_*()
> function on "&mdiodev->dev" ("mdio_bus ee700000.ethernet-ffffffff:01"),
> which is a different device than the one being probed
> (("ee700000.ethernet"), see also the callstack below).
> In fact "&mdiodev->dev" hasn't been probed yet, leading to the WARNING
> when it is probed later.
> 
>     [<c0582de8>] (mdiobus_register_device) from [<c05810e0>] (phy_device_register+0xc/0x74)
>     [<c05810e0>] (phy_device_register) from [<c0675ef4>] (of_mdiobus_register_phy+0x144/0x17c)
>     [<c0675ef4>] (of_mdiobus_register_phy) from [<c06760f0>] (of_mdiobus_register+0x1c4/0x2d0)
>     [<c06760f0>] (of_mdiobus_register) from [<c0589f0c>] (sh_eth_drv_probe+0x778/0x8ac)
>     [<c0589f0c>] (sh_eth_drv_probe) from [<c0516ce8>] (platform_drv_probe+0x48/0x94)
> 
> Has commit 71dd6c0dff51b5f1 ("net: phy: add support for
> reset-controller") been tested with an actual reset present?
> 
> Are Ethernet drivers not (no longer) allowed to register MDIO busses?

That is not good. The devm_reset_control_get() call need replaces with
an unmanaged version, and a call to reset_control_put() added to
mdiobus_unregister_device().

David, could you look at this, it was a patch from you that added
this.

	Andrew
