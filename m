Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D251105D81
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVAGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:06:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35904 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKVAGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Nv/qmMMGCEXzQPQIeeSyw0rWDJv8UDAtd8QoxE/GS5o=; b=DPV8qy38SMg2a//+FPHNfqC4s
        g/zz9/aBZuJQvIzIRRiL9OSC1/hfpxusrQq0+NOm2IbV47xewzT/L1wYI/MadK3J2k3m1+Rh6CjTX
        /mmIiIO5DZAzMBnEx8T6zsFIYtbZ1s0rGXis8nm3DLxNkx4U+7Ey/d/5fFs2bT3V8J1CjdhiLEL0l
        0f3OCOakwfRdp6hTyQJwuK8QBMkwwiIy/ag3Ab6dNsHeH1Haa9f0VkTFWyuVCfvagCWVwv2eOpTKG
        ohS00A0IiNIv+8CB3zNjUfUKwBJy/LXkqcAMIDGv4+EVhGr+RS+E94tgFer9K/w+45Yzaa6N1ReLJ
        ev0lWM9nw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38730)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXwT4-0001Vt-AI; Fri, 22 Nov 2019 00:06:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXwT1-0003Ag-Rx; Fri, 22 Nov 2019 00:06:31 +0000
Date:   Fri, 22 Nov 2019 00:06:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191122000631.GL1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <20191117164924.GI1344@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117164924.GI1344@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 04:49:24PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Oct 31, 2019 at 01:18:27AM +0200, Ioana Ciornei wrote:
> > The dpaa2-eth driver now has support for connecting to its associated PHY
> > device found through standard OF bindings. The PHY interraction is handled
> > by PHYLINK and even though, at the moment, only RGMII_* phy modes are
> > supported by the driver, this is just the first step into adding the
> > necessary changes to support the entire spectrum of capabilities.
> 
> Hi,
> 
> You mention that one of the aims here is to eventually support SFPs.
> Do you have a plan to solve the current problem with the DPAA2
> structure, where the physical network interfaces are configured at
> boot time by RCW for their operating mode?
> 
> If you want full SFP support, then you will need to dynamically
> reconfigure the network interfaces.  For example, 10G NBASE-T SFP+
> modules will dynamically switch between 10GBASE-R (XFI), 5000BASE-X,
> 2500BASE-X, and SGMII depending on the copper side link speed.  The
> PHY may also support UXSGMII but it doesn't power up that way and it
> is not known whether it is possible or how to change the interface
> mode to UXSGMII.
> 
> Then there's the whole issue of SGMII vs 1000BASE-X SFPs, and fiber
> channel SFPs that can operate at 2500BASE-X.

The last thing to be aware of WRT SFPs is that not all of those which
use SGMII send the 16-bit configuration word.  There's at least SFP
out there that I have at the moment where the PHY chip on it is not
capable of doing so, due to the way the chip vendor designed the
device - yet it expects to link to a MAC using SGMII at 1G and 100M
rates by forcing the rates on the MAC side.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
