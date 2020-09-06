Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7A925ED58
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 10:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgIFIZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 04:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIFIZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 04:25:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F43C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 01:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l7sym+V1FvqZIRS4Im5tnv08RhRYdOon6hur10nDxiY=; b=KHTQXGSoDeRqQoBSJtvq5GtmS
        n9x7R9xDVEVGLOUhYhyPmoSAI63DbKLI6H2qCmYR/CsxamNgoo23x8FdjsaindijQdLd6mKQGCY1w
        kAsHAq77Qc3hr2an6pEB8VrLGnQX0MC0bid3tW2fLFdwABCAapXVnsARolcgUEL2LtJ5PPr9CXXkW
        gWJvrRM4G1WfUc583rPEx2QhMhqjquPYm2gLyU9x60BEVyXlmCknbniYs6XeVbuTH/PA7efry+paZ
        0CUjUFOXxYWNtzD24Ow/uYLPnVAub9fHgg/Gqzd2MH4/HHrHzCw99ZLzrseTa7cMJzG/jNGEHgAB8
        /xbPIZMUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32842)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kEpys-0001CO-TW; Sun, 06 Sep 2020 09:24:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kEpyo-0003VQ-Ld; Sun, 06 Sep 2020 09:24:54 +0100
Date:   Sun, 6 Sep 2020 09:24:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH] net: dsa: rtl8366rb: Switch to phylink
Message-ID: <20200906082454.GV1551@shell.armlinux.org.uk>
References: <20200905224828.90980-1-linus.walleij@linaro.org>
 <bd776604-0285-1dbc-1a97-51829d037a9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd776604-0285-1dbc-1a97-51829d037a9a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 06:56:45PM -0700, Florian Fainelli wrote:
> +Russell,
> 
> On 9/5/2020 3:48 PM, Linus Walleij wrote:
> > This switches the RTL8366RB over to using phylink callbacks
> > instead of .adjust_link(). This is a pretty template
> > switchover. All we adjust is the CPU port so that is why
> > the code only inspects this port.
> > 
> > We enhance by adding proper error messages, also disabling
> > the CPU port on the way down and moving dev_info() to
> > dev_dbg().
> > 
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> The part of the former adjust_link, especially the part that forces the link
> to 1Gbit/sec, full duplex and no-autonegotiation probably belongs to a
> phylink_mac_config() implementation.
> 
> Assuming that someone connects such a switch to a 10/100 Ethernet MAC and
> provides a fixed-link property in Device Tree, we should at least attempt to
> configure the CPU port interface based on those link settings, that is not
> happening today.

The CPU port has been the subject of much discussion; I thought the
conclusion was that phylink would not be used for the CPU port anymore.

The problem is, DSA has this idea that if there's nothing specified for
the CPU port, that port will be configured to the highest speed and
duplex mode possible, but that isn't compatible with phylink.  When
there's no SFP or fixed-link specifier, phylink assumes that a PHY will
be present, which is the expectation for network drivers.  Consequently,
phylink will be in "PHY" mode, but there is no PHY for a CPU link, so
phylink will never see the link come up. Moreover, phylink has no idea
what the maximum speed of the port is, so it has no parameters to call
the link_up() methods with.

I did toy with adding yet another callback for DSA that would happen
late which gave an opportunity for DSA to report that and reconfigure
phylink for a fixed-link, but Andrew's conclusion was not to use phylink
for CPU ports.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
