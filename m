Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA48891DD
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 15:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHKNhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 09:37:15 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60978 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfHKNhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 09:37:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hLAgx8JYnhMOKraiq5vnyTU065BiPtmobxh1PiL6lCo=; b=DsY8cgoP3Zr8v7CIYT2P+2Uba
        oCX8MUifxMincmBKGu20CPWHXdUnTdU6vTJNtdzn/K0vciZDziYcJlVcIuUKWNKaRC2jo5lDI9Yn6
        fSABhtvHVoOtEYt5HMmMgmJufO8LjuFn6XCj940GKSBMaPj7hsffHVY5EntlZv5nBgKOqwoPsIQQZ
        676Bsxhld2FDdyvOPGkKD3GdT5FViw4yHT5rrvxxiY8K3k0rC96UhwV1Zszj1+QD2PMVQsAogX5n9
        ZPhgy33C5e+rTm6g0OhYC26oC1TqCaGW6ky9GfSC2J+RC17+t3T35jX5iMM0sFB/hztHzqH/feD63
        3kXeDIi5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55318)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hwo21-0005Sr-4x; Sun, 11 Aug 2019 14:37:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hwo1z-0005cR-Ky; Sun, 11 Aug 2019 14:37:07 +0100
Date:   Sun, 11 Aug 2019 14:37:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [BUG] fec mdio times out under system stress
Message-ID: <20190811133707.GC13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio,

When I woke up this morning, I found that one of the Hummingboards
had gone offline (as in, lost network link) during the night.
Investigating, I find that the system had gone into OOM, and at
that time, triggered an unrelated:

[4111697.698776] fec 2188000.ethernet eth0: MDIO read timeout
[4111697.712996] MII_DATA: 0x6006796d
[4111697.729415] MII_SPEED: 0x0000001a
[4111697.745232] IEVENT: 0x00000000
[4111697.745242] IMASK: 0x0a8000aa
[4111698.002233] Atheros 8035 ethernet 2188000.ethernet-1:00: PHY state change RUNNING -> HALTED
[4111698.009882] fec 2188000.ethernet eth0: Link is Down

This is on a dual-core iMX6.

It looks like the read actually completed (since MII_DATA contains
the register data) but we somehow lost the interrupt (or maybe
received the interrupt after wait_for_completion_timeout() timed
out.)

From what I can see, the OOM events happened on CPU1, CPU1 was
allocated the FEC interrupt, and the PHY polling that suffered the
MDIO timeout was on CPU0.

Given that IEVENT is zero, it seems that CPU1 had read serviced the
interrupt, but it is not clear how far through processing that it
was - it may be that fec_enet_interrupt() had been delayed by the
OOM condition.

This seems rather fragile - as the system slowing down due to OOM
triggers the network to completely collapse by phylib taking the
PHY offline, making the system inaccessible except through the
console.

In my case, even serial console wasn't operational (except for
magic sysrq).  Not sure what agetty was playing at... so the only
way I could recover any information from the system was to connect
the HDMI and plug in a USB keyboard.

Any thoughts on how FEC MDIO accesses could be made more robust?

Maybe phylib should retry a number of times - but with read-sensitive
registers, if the read has already completed successfully, and its
just a problem with the FEC MDIO hardware, that could cause issues.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
