Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B32400568
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 20:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350495AbhICS7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 14:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbhICS7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 14:59:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C374C061575;
        Fri,  3 Sep 2021 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rhoMpaz0xowX46wxPAfe4wFu/SzLsMfcH3aSjenZa3I=; b=ZVlmlPOWj/yOVsOmuHvNvqRce
        qg0ahkp8aX18oUCVZM5GK724VmaLBAb+9AfGFqdtFWaiFJ7gKpAbP5imaiVKX7vA9Bjhy6xCAbp2V
        FygY5w4D5gO1z2qHd3iWAvJHqlZu1jHJv9HUyVPEh2f4KcsntIFhF14hYP8mdkw80sofT78HxDDMT
        HmXik5mRk2CetFFZ4PyAjnsXVXQHhZ6Ly0wSjcCfsHJIxK7ROxi0lURjrdcq4dR2JL4WW045dnYyK
        K7YKpMHdC4zNoufvZtqX7QAa5EI0o+Fv7hgUck3EBj9qap3JmxGUyIoDulygaXg08AVaUdrBhpHTL
        3jIARJpYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48180)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mMEOp-0003Rl-7F; Fri, 03 Sep 2021 19:58:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mMEOo-0000ja-TN; Fri, 03 Sep 2021 19:58:50 +0100
Date:   Fri, 3 Sep 2021 19:58:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210903185850.GY22278@shell.armlinux.org.uk>
References: <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
 <YTJZj/Js+nmDTG0y@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTJZj/Js+nmDTG0y@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:21:19PM +0200, Andrew Lunn wrote:
> Hi Russell
> 
> Do you have
> 
> auto brdsl
> 
> in your /etc/network/interfaces?
> 
> Looking at /lib/udev/bridge-network-interface it seems it will only do
> hotplug of interfaces if auto is set on the bridge interface. Without
> auto, it only does coldplug. So late appearing switch ports won't get
> added.

I think you're looking at this:

[ "$BRIDGE_HOTPLUG" = "no" ] && exit 0

?

Just before that is:

[ -f /etc/default/bridge-utils ] && . /etc/default/bridge-utils

and /etc/default/bridge-utils sets BRIDGE_HOTPLUG, which is by
default:

# Shoud we add the ports of a bridge to the bridge when they are
# hotplugged?
BRIDGE_HOTPLUG=no

and... none of this seems documented. Not in
/usr/share/doc/bridge-utils/README.Debian and not in the
bridge-utils-interfaces(5) man page. This is all a bit rubbish,
really.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
