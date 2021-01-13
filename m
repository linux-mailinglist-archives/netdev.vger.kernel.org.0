Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC55B2F5800
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbhANCM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbhAMWDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 17:03:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D8C061786;
        Wed, 13 Jan 2021 14:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kMt4tzXEyZzNXhXDNDNa+WkVrGDE2C6DCq5UGtjS/iQ=; b=YXAqIZQGaO1AOo8MZzQcCJsgp
        ouAu5eJjxcdwrFYx1YhPECe9PgwA8C0rEpK42ipF6niA/LqorO+VqqY/bghd+vYakyZbg1XfepjCH
        9pkonuU2FpADC1KzPO6c8lYUR2RNUPggCqhmkymYWXdun7KIdGaPWi9ZlU2FNhc/Pso8aDLOTF8dG
        JetyoyF8i3NiE0pU+2gBY7SWrJtsugy9QTN8/O9vGvzkrG6oMo38BiwJe0/kxdQoDZh0d4+YKZtWH
        ZCjjrgZ2+xv7BRDPhr1Yuvi6BkCGEVci11mXwd/FUNI39SWOgPiQ7HMhdvA5NWtQbjG2m5jicjocE
        V3oqNkStQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47610)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzoCT-0001j4-GN; Wed, 13 Jan 2021 22:01:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzoCR-0007fa-RQ; Wed, 13 Jan 2021 22:01:07 +0000
Date:   Wed, 13 Jan 2021 22:01:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Claudiu.Beznea@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <20210113220107.GN1551@shell.armlinux.org.uk>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:34:53PM +0100, Heiner Kallweit wrote:
> On 13.01.2021 13:36, Claudiu.Beznea@microchip.com wrote:
> > On 13.01.2021 13:09, Heiner Kallweit wrote:
> >> On 13.01.2021 10:29, Claudiu.Beznea@microchip.com wrote:
> >>> It could enter in this mode based on request for standby or suspend-to-mem:
> >>> echo mem > /sys/power/state
> >>> echo standby > /sys/power/state

This is a standard way to enter S2R - I've used it many times in the
past on platforms that support it.

> I'm not a Linux PM expert, to me it seems your use case is somewhere in the
> middle between s2r and hibernation. I *think* the assumption with s2r is
> that one component shouldn't simply cut the power to another component,
> and the kernel has no idea about it.

When entering S2R, power can (and probably will) be cut to all system
components, certainly all components that do not support wakeup. If
the system doesn't support WoL, then that will include the ethernet
PHY.

When resuming, the responsibility is of the kernel and each driver's
.resume function to ensure that the hardware state is restored. Only
each device driver that knows the device itself can restore the state
of that device. In the case of an ethernet PHY, that is phylib and
its associated PHY driver.

One has to be a tad careful with phylib and PHYs compared to their
MAC devices in terms of the resume order - it has not been unheard
of over the years for a MAC device to be resumed before its connected
PHY has been.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
