Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCBEF693E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfKJOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:05:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45582 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Op93w7qJQu8PYODHVb6BHXlstrK7kbTw9l2BtSZX+6U=; b=J3vfIt93LW5aTOvOpIpdpAbza
        aMRnWyH2a4/fXLoTSdambAFzU7Pzz7CX+dqYlnnMh572+YzZJCaCPR+TjuEos6uWltW6uNLhVYqQy
        3cNckvseT1L65sd7uUM1/vJFreoiLMPohWaJXlwN6eJbzb9iHJdYQLnblu4bm9ArP1KfudZFaZd/N
        DSE+8puiFJa/JjmmD6Ip6DhdjyBlmgUNLQk+0E8VVSCXSErHvBAQFTS1UHiCPzWtk0rJWRso99lHT
        i+OhfkJ0N9aKLWzPhHfNRakIiHvJHPfvhr3jjJCfLYVvxrIwta1ayA7c1JYhsNqwUqFbgdOG4t7LY
        DE3fxfSKQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37772)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iTnqP-0007cl-Iy; Sun, 10 Nov 2019 14:05:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iTnqM-0007zG-Q2; Sun, 10 Nov 2019 14:05:30 +0000
Date:   Sun, 10 Nov 2019 14:05:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/17] Allow slow to initialise GPON modules to work
Message-ID: <20191110140530.GA25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some GPON modules take longer than the SFF MSA specified time to
initialise and respond to transactions on the I2C bus for either
both 0x50 and 0x51, or 0x51 bus addresses.  Technically these modules
are non-compliant with the SFP Multi-Source Agreement, they have
been around for some time, so are difficult to just ignore.

Most of the patch series is restructuring the code to make it more
readable, and split various things into separate functions.

We split the three state machines into three separate functions, and
re-arrange them to start probing the module as soon as a module has
been detected (without waiting for the network device.)  We try to
read the module's EEPROM, retrying quickly for the first second, and
then once every five seconds for about a minute until we have read
the EEPROM.  So that the kernel isn't entirely silent, we print a
message indicating that we're waiting for the module to respond after
the first second, or when all retries have expired.

Once the module ID has been read, we kick off a delayed work queue
which attempts to register the hwmon, retrying for up to a minute if
the monitoring parameters are unreadable; this allows us to proceed
with module initialisation independently of the hwmon state.

With high-power modules, we wait for the netdev to be attached before
switching the module power mode, and retry this in a similar way to
before until we have successfully read and written the EEPROM at 0x51.

We also move the handling of the TX_DISABLE signal entirely to the main
state machine, and avoid probing any on-board PHY while TX_FAULT is
set.

 drivers/net/phy/sfp.c | 526 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 369 insertions(+), 157 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
