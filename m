Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3199293FD8
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436790AbgJTPpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436778AbgJTPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:45:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED39C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 08:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VwCOlZxmYHNmAaSDbehVDPMIx+3Ci/hYIXqD9j+vv3Q=; b=kuuot+24WiSaqJ4immXbFx97b
        P2yc7rOP/BdQwvXwEHbYNEBQQOdIx83PvKVXLUSYhcW7FdEMj4qKv2Sw1DTcot7BoA24gTo2pvxyo
        Y6dxUIMkyfI+0rhJMpmPBbiOZ+pd33LZGu8aU9iysctHYUoTTy7i5m63UJFKfz7uPxQqgtdTHp9ko
        VUaitVjb1vf0Z+G5mIrv2MMBNwYYbpTyJrfy8mn9XubwJTGp2DbJcP4fOpoKVsJBqtagaB6StAIJH
        C1zKSG3bFqOAeIz+V4Zaw0njHiILFsu4KBgbT44CaTKqzUualQX2vRTO1cwMbOo2h1LzIATRhTzcB
        J7K2GTsCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48718)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUtp5-0007i8-8I; Tue, 20 Oct 2020 16:45:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUtp5-0005Ou-1g; Tue, 20 Oct 2020 16:45:15 +0100
Date:   Tue, 20 Oct 2020 16:45:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: russell's net-queue question
Message-ID: <20201020154514.GE1551@shell.armlinux.org.uk>
References: <20201020171539.27c33230@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201020171539.27c33230@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 05:15:39PM +0200, Marek Behún wrote:
> Russell,
> 
> I think the following commits in your net-queue should be still made better:
> 
> 7f79709b7a15 ("net: phy: pass supported PHY interface types to phylib")
> eba49a289d09 ("net: phy: marvell10g: select host interface configuration")
> 
> http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=eba49a289d0959eab3dfbc0320334eb5a855ca68
> http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=eba49a289d0959eab3dfbc0320334eb5a855ca68
> 
> The first one adds filling of the phydev->host_interfaces bitmap into
> the phylink_sfp_connect_phy function. It should also fill this bitmap
> in functions phylink_connect_phy and phylink_of_phy_connect (direct
> copy of pl->config->supported_interfaces).

First, the whole way interfaces are handled is really not good, even
with the addition of the interfaces bitmap. However, it tries to solve
at least some of the issues.

Secondly, what should we fill this in with?

Do we fill it with the firmware specified phy-mode setting? Or all the
capabilities of the network driver's interface? What if the network
driver supports RGMII/SGMII/10GBASE-R/etc but not all of these are
wired?

We really don't want the PHY changing what was configured via hardware
when it's "built in", because it's ambiguous in a very many situations
which mode should be selected. If we take the view that the firmware
specified phy-mode should only be specified, then the 88X3310 will
switch to MACTYPE=6 instead of 4 on the Macchiatobin, which is the rate
adaption mode - and this will lead to lost packets (it's a plain
88X3310 without the MACSEC, so the PHY is not capable of generating
flow control packets to pace the host.)

> The reason is that phy devices may want to know what interfaces are
> supported by host even if no SFP is used (Marvell 88X3310 is an exmaple
> of this).

If a SFP is not being used, then the connectivity is described via DT
and the hardware configuration of the PHY (which we rely on for the
88X3310.) I don't see much of a solution to that for the 88X3310.
If DT describes the interface mode as 10gbase-r, then that ambiguously
could refer to MACTYPE=4,5,6 - the driver can't know.

So, I don't think there is a simple answer here.

> The second patch (adding mactype selection to marvell10g) can get rid
> of the rate matching code, and also
> should update the mv3310_update_interface code accordignly.
> 
> Should I sent you these patches updated or should I create new patches
> on top of yours?

These are experimental, and for the reasons I mention above, they
need careful thought.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
