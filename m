Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761EF45903
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfFNJmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:42:39 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34966 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfFNJmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=betYeRlAo+7Uy6kRuLjST67ELLBOv3KX9pJKj5ytJj8=; b=Ak0WcQiHBiSeNhK7TimpUvtGa
        Ca+wzD6o1EDV4FjfHmTsn93lMhzq8QSJUKuRPkZY8G7nmNBqXCjQpY+MJ+yWHiFP9a0CNVKGt+obi
        wy1WHbYSEUyhO6qtvi9Ks6OKr9V0j3IMhiBeyf6Rw84s6spFEw0Gr+ZSqa2pVtj+HpA5c6F8R/VIL
        GaP/7mmoVxrnza+t5vSrdsCKiKlMc8at6+X1L4uykCbX49xxLwM0LnAyGHgUDHXL3oaTIV571UDm0
        l2bUndYntXdK6mXmrjklpAzZhwaiRygTHhIVxZsoeo0rXfrZ3lXGTPDYDVMTTL6gkXMTYdW1MCJ0B
        9eKlYoCmw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38694)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbij9-0000Yt-Sj; Fri, 14 Jun 2019 10:42:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbij6-000276-S9; Fri, 14 Jun 2019 10:42:28 +0100
Date:   Fri, 14 Jun 2019 10:42:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH RFC 0/6] DPAA2 MAC Driver
Message-ID: <20190614094228.mg5khguayhwdu5rh@shell.armlinux.org.uk>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:55:47AM +0300, Ioana Ciornei wrote:
> After today's discussion with Russell King about what phylink exposes in
> .mac_config(): https://marc.info/?l=linux-netdev&m=156043794316709&w=2
> I am submitting for initial review the dpaa2-mac driver model.
> 
> At the moment, pause frame support is missing so inherently all the USXGMII
> modes that rely on backpressure applied by the PHY in rate adaptation between
> network side and system side don't work properly.
> 
> As next steps, the driver will have to be integrated with the SFP bus so
> commands such as 'ethtool --dump-module-eeprom' will have to work through the
> current callpath through firmware.

From what I understand having read the doc patch, would it be fair to
say that every operation that is related to the link state has to be
passed from the ETH driver to the firmware, and then from the firmware
back to the kernel to the MAC driver?

Does this mean that "ethtool --dump-module-eeprom" goes through this
process as well - eth driver into firmware, which then gets forwarded
out of the formware on the MAC side, via phylink to the SFP cage?

If that is true, what is the proposal - to forward a copy of the EEPROM
on module insertion into the firmware, so that it is stored there when
anyone requests it?  What about the diagnostic monitoring that is
real-time?

Or is the SFP cage entirely handled by firmware?

> This poses somewhat of a problem, as
> dpaa2-eth lacks any handle to the phy so it will probably need further
> modification to the API that the firmware exposes (same applies to 'ethtool
> --phy-statistics').

This again sounds like the eth driver forwards the request to firmware
which then forwards it to the mac driver for it to process.

Is that correct?

> 
> The documentation patch provides a more complete view of the software
> architecture and the current implementation.
> 
> Ioana Ciornei (4):
>   net: phy: update the autoneg state in phylink_phy_change
>   dpaa2-mac: add MC API for the DPMAC object
>   dpaa2-mac: add initial driver
>   net: documentation: add MAC/PHY proxy driver documentation
> 
> Ioana Radulescu (2):
>   dpaa2-eth: add support for new link state APIs
>   dpaa2-eth: add autoneg support
> 
>  .../freescale/dpaa2/dpmac-driver.rst               | 159 ++++++
>  .../device_drivers/freescale/dpaa2/index.rst       |   1 +
>  MAINTAINERS                                        |   8 +
>  drivers/net/ethernet/freescale/dpaa2/Kconfig       |  13 +
>  drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +
>  .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  83 +++-
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 541 +++++++++++++++++++++
>  drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   | 107 ++++
>  drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 369 ++++++++++++++
>  drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 210 ++++++++
>  drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  35 ++
>  drivers/net/ethernet/freescale/dpaa2/dpni.c        |  70 +++
>  drivers/net/ethernet/freescale/dpaa2/dpni.h        |  27 +
>  drivers/net/phy/phylink.c                          |   1 +
>  14 files changed, 1612 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h
> 
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
