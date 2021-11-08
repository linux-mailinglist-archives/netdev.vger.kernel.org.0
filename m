Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FDB449B64
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhKHSIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhKHSIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:08:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B5CC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 10:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7FpR/GGFFDOW4oBICeEB7SBWS8OIbOza06YRVybqTvE=; b=1mv+3+aY8sQeLP3NE/G9G1IOze
        8s71gmyZra1/oReHWWH9rXGbStxrYc5p62SZ5oWn36qIAhhSIcJJ3+IC9v6og1W5odPb8HSi7XyRq
        WmSM+v8AZa9wJ9oRd/woYUtwOPpDT4U1swPdTPh9hyMY8E8qxrRVSfKMogpvjpbI+wtmMGyqJf39a
        vY6dL165DewpjG21qt7HFiZS46vXEO7n5du++ybXO5GzXBaMk0abFJYyJfRbi9RC5af1D8GIX5u1J
        ZEoY5FA3gPqRz3ujJfUIpB/jKaiDN0It9yeuuPUhPc0IpaCxIISzZaKRmAzRx9iK0HDGTVT6ZzAEz
        XwE75/1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55540)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mk91x-00010G-6Z; Mon, 08 Nov 2021 18:06:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mk91v-0002zP-Vn; Mon, 08 Nov 2021 18:06:03 +0000
Date:   Mon, 8 Nov 2021 18:06:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Bastian Germann <bage@linutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <YYlnCx+S34B1b5Xy@shell.armlinux.org.uk>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
 <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
 <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
 <YYlk8Rv85h0Ia/LT@lunn.ch>
 <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:01:23PM +0100, Heiner Kallweit wrote:
> On 08.11.2021 18:57, Andrew Lunn wrote:
> >> It is BCM53125. Currently, you can set "mdix auto|off|on" which does
> >> not take any effect.  The chip will do what is its default depending
> >> on copper autonegotiation.
> >>
> >> I am adding support for setting "mdix auto|off". I want the thing to error on "mdix on".
> >> Where would I add that check?
> > 
> > /* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
> >  * the driver is required to renegotiate link
> >  */
> > #define ETH_TP_MDI_INVALID	0x00 /* status: unknown; control: unsupported */
> > #define ETH_TP_MDI		0x01 /* status: MDI;     control: force MDI */
> > #define ETH_TP_MDI_X		0x02 /* status: MDI-X;   control: force MDI-X */
> > #define ETH_TP_MDI_AUTO		0x03 /*                  control: auto-select */
> > 
> > So there are three valid settings. And you are saying you only want to
> > implement two of them? If the hardware can do all three, you should
> > implement all three.
> > 
> 
> If we would like to support PHY's that don't support all MDI modes then
> supposedly this would require to add ETHTOOL_LINK_MODE bits for the
> MDI modes. Then we could use the generic mechanism to check the bits in
> the "supported" bitmap.

We'll have to add more stuff to phylink to avoid MACs masking these
bits... ETHTOOL_LINK_MODE seems to be becoming a disorganised dumping
ground for random stuff. :(

Also, what would these bits in the advertising bitmap mean?

Finally, how do we handle the lack of these bits for existing PHYs
that already implement MDI modes?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
