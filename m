Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D5E45A13F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhKWLYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhKWLYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:24:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19883C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 03:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6B5ZreRL8spps0W2mRTxQmhAMNecRAY1Usm8mczHjsI=; b=MfkqOJ2Yr5gxb2yPt03USdxRAj
        M0LYnXkmmSkY+KSEmumH0KYcCMqYOY8/4aEGD5FRDvqzW6Zj0NJDqX8L+TY3je1AdGC6HJP6p9tsS
        fz50ITTjXUO4tqCtCDER+G10KEEOip+d17iz7kI23Ch+8jMbtl8QdMlvAqIocUeGYMZ0g70pSi2k6
        PfU2+sgV1PxaumpjZFl/GPK5n1Yxp5O1GIhw1Ag88rXp5RL7wyqhYRX3egQC49bG7BuP3tFGjum8P
        KvM1sfq94U98shwxspcDyS3+KJdT2RdZtODn7UpasYaSry8cmMYB869RSQpsz598uHGT6wVr9FE4K
        CWIyPucw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55810)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpTrA-0007oF-NV; Tue, 23 Nov 2021 11:21:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpTr9-0000Aa-J3; Tue, 23 Nov 2021 11:20:59 +0000
Date:   Tue, 23 Nov 2021 11:20:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Subject: Re: [PATCH net 1/2] net: phylink: Force link down and retrigger
 resolve on interface change
Message-ID: <YZzOmzAAQcLnpuPl@shell.armlinux.org.uk>
References: <20211122235154.6392-1-kabel@kernel.org>
 <20211122235154.6392-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211122235154.6392-2-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:51:53AM +0100, Marek Behún wrote:
> On PHY state change the phylink_resolve() function can read stale
> information from the MAC and report incorrect link speed and duplex to
> the kernel message log.
> 
> Example with a Marvell 88X3310 PHY connected to a SerDes port on Marvell
> 88E6393X switch:
> - PHY driver triggers state change due to PHY interface mode being
>   changed from 10gbase-r to 2500base-x due to copper change in speed
>   from 10Gbps to 2.5Gbps, but the PHY itself either hasn't yet changed
>   its interface to the host, or the interrupt about loss of SerDes link
>   hadn't arrived yet (there can be a delay of several milliseconds for
>   this), so we still think that the 10gbase-r mode is up
> - phylink_resolve()
>   - phylink_mac_pcs_get_state()
>     - this fills in speed=10g link=up
>   - interface mode is updated to 2500base-x but speed is left at 10Gbps
>   - phylink_major_config()
>     - interface is changed to 2500base-x
>   - phylink_link_up()
>     - mv88e6xxx_mac_link_up()
>       - .port_set_speed_duplex()
>         - speed is set to 10Gbps
>     - reports "Link is Up - 10Gbps/Full" to dmesg
> 
> Afterwards when the interrupt finally arrives for mv88e6xxx, another
> resolve is forced in which we get the correct speed from
> phylink_mac_pcs_get_state(), but since the interface is not being
> changed anymore, we don't call phylink_major_config() but only
> phylink_mac_config(), which does not set speed/duplex anymore.
> 
> To fix this, we need to force the link down and trigger another resolve
> on PHY interface change event.
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marek Behún <kabel@kernel.org>

I'm pretty sure someone will highlight that the author of the patch
should be the first sign-off - which doesn't match given the way
you've sent this patch. That probably needs fixing before it's
applied.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
