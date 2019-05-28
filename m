Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9B2C3A3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfE1J4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:56:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35866 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1J4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jJgqEpooTCRkYeWBd8UMaOQPg46sgmrOf8n8kaYPgGI=; b=PGt6CbDjOihlTB34b7mcsDUW0
        tB5LG5Cqoa+mpXpTuq9vX9+17C1yDKPWwGAcShrOTNWDKqPeZa8KLH7dWiUihu0hUtGVcmLWsUdQH
        1yCw3zf3sa7zq6pLXrcbcP2XqybxsIhIkXt9AkOLmC195QD87zXhvbz5yLQxENjNEv9gWmshmypOv
        8zQ2cGeC+izFW7ideFDTRD5tmApSFbQqqqC65dZ8N3QxNonwonETyTElrEF+A8usmEtUzUw38pcbs
        IAXR48q4jLlZvhzs1fAtKZ3IPI80bXnFfKKeBq8fEmGd/56zYVtXgyJoPvrBgSc0a3cEqNQWQ/jDB
        u8h7Od54Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56018)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVYqX-0004y4-Jk; Tue, 28 May 2019 10:56:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVYqV-0003Sn-PD; Tue, 28 May 2019 10:56:39 +0100
Date:   Tue, 28 May 2019 10:56:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/5] phylink/sfp updates
Message-ID: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a series of updates to phylink and sfp:

- Remove an unused net device argument from the phylink MII ioctl
  emulation code.

- add support for using interrupts when using a GPIO for link status
  tracking, rather than polling it at one second intervals.  This
  reduces the need to wakeup the CPU every second.

- add support to the MII ioctl API to read and write Clause 45 PHY
  registers.  I don't know how desirable this is for mainline, but I
  have used this facility extensively to investigate the Marvell
  88x3310 PHY.  A recent illustration of use for this was debugging
  the PHY-without-firmware problem recently reported.

- add mandatory attach/detach methods for the upstream side of sfp
  bus code, which will allow us to remove the "netdev" structure from
  the SFP layers.

- remove the "netdev" structure from the SFP upstream registration
  calls, which simplifies PHY to SFP links.

 drivers/net/phy/marvell10g.c | 101 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy.c        |  33 ++++++++++----
 drivers/net/phy/phylink.c    |  75 ++++++++++++++++++++++++--------
 drivers/net/phy/sfp-bus.c    |  14 +++---
 include/linux/sfp.h          |  12 +++--
 5 files changed, 195 insertions(+), 40 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
