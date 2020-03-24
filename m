Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178CB190611
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCXHIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:08:04 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:34049 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgCXHIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 03:08:04 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id E61A530004525;
        Tue, 24 Mar 2020 08:08:01 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BEE8FA2372; Tue, 24 Mar 2020 08:08:01 +0100 (CET)
Date:   Tue, 24 Mar 2020 08:08:01 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 03/14] net: ks8851: Pass device pointer into
 ks8851_init_mac()
Message-ID: <20200324070801.uybzsgip46vqktk6@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-4-marex@denx.de>
 <20200324010622.GH3819@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324010622.GH3819@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 02:06:22AM +0100, Andrew Lunn wrote:
> On Tue, Mar 24, 2020 at 12:42:52AM +0100, Marek Vasut wrote:
> > Since the driver probe function already has a struct device *dev pointer,
> > pass it as a parameter to ks8851_init_mac() to avoid fishing it out via
> > ks->spidev. This is the only reference to spidev in the function, so get
> > rid of it. This is done in preparation for unifying the KS8851 SPI and
> > parallel drivers.
[...]
> > -static void ks8851_init_mac(struct ks8851_net *ks)
> > +static void ks8851_init_mac(struct ks8851_net *ks, struct device *ddev)
> >  {
> >  	struct net_device *dev = ks->netdev;
> >  	const u8 *mac_addr;
> >  
> > -	mac_addr = of_get_mac_address(ks->spidev->dev.of_node);
> > +	mac_addr = of_get_mac_address(ddev->of_node);
> 
> The name ddev is a bit odd. Looking at the code, i see why. dev is
> normally a struct net_device, which this function already has.
> 
> You could avoid this oddness by directly passing of_node.

Actually after adding the invocation of of_get_mac_address() with
commit 566bd54b067d ("net: ks8851: Support DT-provided MAC address")
I've had regrets that I should have used device_get_mac_address()
instead since it's platform-agnostic, hence would work with ACPI
as well as DT-based systems.

device_get_mac_address() needs a struct device, so I'd prefer
using that instead of passing an of_node.

I agree that "ddev" is somewhat odd.  Some drivers name it "device"
or "pdev" (which however collides with the naming of platform_devices).
Another idea would be to move the handy ndev_to_dev() static inline
from apm/xgene/xgene_enet_main.h to include/linux/netdevice.h and
use that with "struct net_device *dev", which we already have in
ks8851_init_mac().

Thanks,

Lukas
