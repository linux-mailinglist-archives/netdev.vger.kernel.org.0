Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D983C21FE
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhGIKAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhGIKAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:00:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FE6C0613DD;
        Fri,  9 Jul 2021 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IrbycDAuQ3MUvmas9RXbsQxlkhqcD9Mn93U+OHYoQbQ=; b=dHK7uFZKHgXI7RgD+Fplit5uF
        WGjmxe7ihLF5RF7Jlr49Yo9qeDvAQYwYGFs4scDveaLIg6c95mSP2tP/USQGmheDtTdPVIhnbo284
        YcXRGWCAwVtp6vg0CX+VFD7LvfJzxWJ86nUodfp9Dgk01iX7+Ixoo+7Gxujp7F2ByRKVWLy1oF/kd
        44q/z2pF6dXvaHAaAmpuELe3Tv+vQCUBLUPkEX3TgrgPZeD8eEQLujbFO54H09e17OH3owSKabjk+
        ewuA/xI3p5EVFTIm5vqzLzJbLbNPWC9LQyRo7ozWFwDF49bBQ4AMu+07gMl3S8Y6tJWEOo2xyUHfY
        lJlp5Enaw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45904)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m1nFq-0001gB-JO; Fri, 09 Jul 2021 10:57:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m1nFm-0004rK-TB; Fri, 09 Jul 2021 10:57:02 +0100
Date:   Fri, 9 Jul 2021 10:57:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Message-ID: <20210709095702.GX22278@shell.armlinux.org.uk>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
 <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
 <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 09:41:45AM -0700, Florian Fainelli wrote:
> During S4 resume (disk), I suppose that you have to involve the boot
> loader to restore the DRAM image from the storage disk, and so that does
> effectively look like a quasi cold boot from the kernel? If so, that
> should still lead to config_init() being called when the PHY is
> attached, no?

Don't forget that when resuming from S4, we effectively boot the kernel
normally, then check whether we are resuming, before we then start
loading the resume image, suspend the current kernel, shuffle the pages
around, and resume the original kernel.

What that means is that a PHY will see the effects of a normal kernel
boot before we resume the original kernel. If a PHY driver (e.g.)
disables features such as WOL and we do not restore these settings on
resume, then those settings will be reset.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
