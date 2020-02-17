Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D91E1616B0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgBQPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38406 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgBQPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5j4JuUqMT93hmtsiWVXppr1iNJA7Bbq53PUZ4dpqUJI=; b=H+YG8O1C5qTaQP8R2V/PShOhA
        uI+TEeehepFLlsPbRFF8QHe2o5U9uPEpnjS9AO410LIIz99H/xAlGlZKMmopUNxJ8Be6h4gK3IUfX
        VJSjWSjW3zvxRO1xfYlNEPoM8r2JUgg2ATJbQ93te+SxOB9XaE0+wqFIwm1iQjSdq0MPOL5PIzfJ2
        jdXBHmZ3usDof20TmW3yuztR6QGcmgKEaQrIlN15otpQ2RDaUSLmDarOK04oJ1orwBGevLzYrIMXC
        S4lkXd+sEpK3h0Y9JYWRq3nTPPyhUYL5OEZ5C/PuitheMZwpaGymtvGzs3mvUduyKY8wphSgm97Be
        4jOkhnAbA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41576)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3iiU-0001hR-Bw; Mon, 17 Feb 2020 15:53:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3iiQ-0006QY-8q; Mon, 17 Feb 2020 15:53:46 +0000
Date:   Mon, 17 Feb 2020 15:53:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] phylib: add hardware resolved pause mode
 support for marvell PHYs
Message-ID: <20200217155346.GW25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Marvell PHYs provide a register that gives us the resolution results
for speed, duplex and the pause enablement status. This series adds
support for using this, and passing it through phylib via the newly
introduced phy_get_pause() interface.

In order to do this, we need to read the copper PHY results from the
correct register; now that I have access to the Marvell documentation,
this becomes much easier for the 88x3310 PHY.

I also find that the code in the marvell 1G driver does not correctly
check that the resolved state in the status register is valid prior
to using it, so there is a patch for that too; I don't deem it
important enough for it to be sent via the -net tree, which would add
additional dependency complexity for this series.

 drivers/net/phy/marvell.c    |  46 +++++++++++++-
 drivers/net/phy/marvell10g.c | 147 ++++++++++++++++++++++++++++---------------
 drivers/net/phy/phy_device.c |   6 ++
 include/linux/phy.h          |   9 +++
 4 files changed, 154 insertions(+), 54 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
