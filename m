Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50A72930E6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJSWD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387757AbgJSWD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:03:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60150C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 15:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1H4wvVnfWDXN7WBjONpi0Qt+uFKOrbNrXtUobCv0KOM=; b=GTjCYVvnepMyCNFNyQANNIX61
        QX9yMLG9DXMFxsg+2t/68teLXL+16oRiiS9q72z50g4NHIMWnfMmcL2fjEnZdHZTmXj16AS+YH1ro
        +Voc0grXvXDWv5lPriY6kWNRQMExmNw8XWSCBZD9uQnEPYL5KtjfHNtMuXCQrxXSth+U07Ji/3e4r
        irlMDkf8StmPL/tczYfLGz754OZrML32Qaf86WVexosc6zue1K+arnJSFGFsoaQIvK+7hK6KV00kr
        TfA5HbXs/lhp36aeG6NTJDu0T2fRxldKhP3bHBX4SzMHCOvSfmyxSheyAkiIOm0460xB8SygjAOop
        pJgwPC1sw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48404)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUdFz-0006QE-8J; Mon, 19 Oct 2020 23:03:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUdFy-0004bB-Kp; Mon, 19 Oct 2020 23:03:54 +0100
Date:   Mon, 19 Oct 2020 23:03:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019220354.GY1551@shell.armlinux.org.uk>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210852.GW1551@shell.armlinux.org.uk>
 <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 09:32:56PM +0000, Robert Hancock wrote:
> On Mon, 2020-10-19 at 22:08 +0100, Russell King - ARM Linux admin
> wrote:
> > On Mon, Oct 19, 2020 at 02:49:13PM -0600, Robert Hancock wrote:
> > > The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel
> > > 81E1111 PHY
> > 
> > You mean 88E1111 here.
> > 
> 
> Whoops, will fix in an updated version.
> 
> > > with a modified PHY ID, and by default does not have 1000BaseX
> > > auto-negotiation enabled, which is not generally desirable with
> > > Linux
> > > networking drivers. Add handling to enable 1000BaseX auto-
> > > negotiation.
> > > Also, it requires some special handling to ensure that 1000BaseT
> > > auto-
> > > negotiation is enabled properly when desired.
> > > 
> > > Based on existing handling in the AMD xgbe driver and the
> > > information in
> > > the Finisar FAQ:
> > > https://can01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.finisar.com%2Fsites%2Fdefault%2Ffiles%2Fresources%2Fan-2036_1000base-t_sfp_faqreve1.pdf&amp;data=04%7C01%7Crobert.hancock%40calian.com%7C6eda7d636fbf4a70ff2408d8747332a2%7C23b57807562f49ad92c43bb0f07a1fdf%7C0%7C0%7C637387385403382018%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=cfChA4TBw3f70alrANXPR0HHgNg3Vs%2FNeEYhzZc%2BF9A%3D&amp;reserved=0
> > 
> > There's lots of modules that have the 88E1111 PHY on, and we switch
> > it to SGMII mode if it's not already in SGMII mode if we have access
> > to it. Why is your setup different?
> 
> This is in our setup using the Xilinx axienet driver, which is stuck
> with whatever interface mode the FPGA logic is set up for at synthesis
> time. In our case since we need to support fiber modules, that means we
> are stuck with 1000BaseX mode with the copper modules as well.

Hmm, okay.

> Note that there is some more work that needs to be done for this to
> work completely, as phylink currently will only attempt to use SGMII
> with copper modules and fails out if that's not supported. I have a
> local patch that just falls back to trying 1000BaseX mode if the driver
> reports SGMII isn't supported and it seems like it might be a copper
> module, but that is a bit of a hack that may need to be handled
> differently.

I have worked on patches that implement a replacement system of
working out which interface mode to use, not only for optical
modules, but also for PHYs as well. It needs network drivers and
PHYs to advertise a bitmap of which PHY_INTERFACE_MODE_xxx each
support, and we use an ordered list of preferred modes to find the
most suitable interface mode supported by both the network driver
and the module/PHY. I never fully finished the patches though.

PHYs need to fill in this bitmap before they are bound to a
network driver, because we need to work out which interface mode
to use before we can attach the PHY.

The patches for this are in my net-queue branch on
git://git.armlinux.org.uk/~rmk/linux-arm.git/

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
