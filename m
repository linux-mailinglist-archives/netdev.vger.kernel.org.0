Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D812F5EB4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbhANKZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbhANKZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:25:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFB4C061573;
        Thu, 14 Jan 2021 02:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ABEMejHZD9ftpZr7JO65Pg5rVQtvXlEBPbFOaUOhqnk=; b=LGypZ1msxVhIcQURUYXk5rEj1
        w/XmVmrW3fLBWMGUuqRk9+/brVVSFKv0Cv7HHuQ7TaGJ6p1puSBjdEyb0h0810ePQqamh9S5puaEu
        6VDlmx9HtK1xS7P4NGIs+q+xAEvUm5I/b6qiOAPLVuVTeIoT1OY8APFfWx/3cML5PiPX79SSGeJmM
        Acb9NmFBe+KHr5AZ+9fZl5JNIj1i/vqCpfvVBW7jitE6RzfbvD3wja1QEhW9TPuPJmqxHRa5u2ll5
        sSOoyLKKzpKw/3oBMks3NKWrzt1KAZrLr9SLlojOxcuax3UXQUkAUxlsfwmR9ctOuOvt4lixKeZHi
        WvKwqNEqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47820)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzzoU-0002It-0D; Thu, 14 Jan 2021 10:25:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzzoS-0008Fl-Eg; Thu, 14 Jan 2021 10:25:08 +0000
Date:   Thu, 14 Jan 2021 10:25:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Claudiu.Beznea@microchip.com
Cc:     hkallweit1@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <20210114102508.GO1551@shell.armlinux.org.uk>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 10:12:13AM +0000, Claudiu.Beznea@microchip.com wrote:
> Up to this moment we treat this backup mode as S2R mode since the memory
> was kept in self-refresh mode. Each driver was saving/restoring in/from RAM
> the content of associated registers in the suspend/resume phase.

This is exactly what suspend-to-RAM is. The system is largely powered
down with the state saved in RAM, and the RAM placed in self-refresh
mode. Some devices or parts of devices may remain powered up if needed
to be a wake-up source.

> The questions that arries this topic (Heiner, Russel, anyone involved in
> the discussion, correct me if I wrongly understood):
> 1/ is it OK to still treat this backup mode as a S2R mode or as a hibernate
> mode? Since hibernate would treat the devices (including Ethernet PHY in
> this case) as they were just powered and restore the registers content but
> taking into account that in backup mode we keep the RAM in self-refresh?

Hibernate mode is a deeper power-saving mode, where all that applies
with suspend-to-ram applies, plus the critical contents of the RAM is
stored to non-volatile media, and the RAM powered down in addition to
what would also be powered down in the suspend-to-ram case.

If you are placing the RAM in self-refresh and powering the system down,
you are in suspend-to-ram mode, not hibernate mode.

> 2/ is it OK to have these kind of reconfiguration of one device that end up
> in suspend mode with no power (in this case the Ethernet PHY) due to a
> system power cut off (in this case CPU + PMIC)?

You have nothing out of the ordinary here.  Going back years, the
Assabet/Neponest (SA1110 based platform) does this. When the CPU
enters suspend mode, a pin on the processor indicates to the external
world that has happened, and that cuts power to most of the system
including the smc91x and integrated PHY. (it doesn't use phylib.)

So there's really nothing special about your situation; from what you
have described, it's a pretty standard suspend-to-ram implementation.

As I've said, if phylib/PHY driver is not restoring the state of the
PHY on resume from suspend-to-ram, then that's an issue with phylib
and/or the phy driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
