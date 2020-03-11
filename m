Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C91181777
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgCKMHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:07:01 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53078 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729215AbgCKMHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wCE9C59qwMQQJwLE+jwDwqtyX2iDMrO6Wk2xbZTZ2vw=; b=aPddCsPUU8JUifExOuLawFAKc
        INnTMzAduDIbeBMFsF6tTRKDura8mvb5KpP0bCeqJAITYEJPrmANFNgwTFMatg08ZdTrOnXuswWGx
        86PrtoTcAxvDYGPtoDEdXZpUEO21dOWoatL50xAXeTi+OYC4r44KQpqZpzTA8QFiqf81AG3z76dwy
        mlRzLCI8chIW9i9wdN0vYPCJmJTH09DuGeTcA4KVkSAhnZ1+LLuatQs8RUyATFfchdxO4JuzvRoH0
        m3dqdMM8HN9KsMCeUl1G7FmY1wdoZ4htKAJn4bCENaAysqIhVEjSfF+vemndPPr5lPL4+v4DEBwOa
        GpOLMq0hw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34984)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC08N-00036o-S6; Wed, 11 Mar 2020 12:06:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC08J-0005IV-UJ; Wed, 11 Mar 2020 12:06:43 +0000
Date:   Wed, 11 Mar 2020 12:06:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] add phylink support for PCS
Message-ID: <20200311120643.GN25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for IEEE 802.3 register set compliant PCS
for phylink.  In order to do this, we:

1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
   to a linkmode variant.
2. add a helper for clause 37 advertisements, supporting both the
   1000baseX and defacto 2500baseX variants. Note that ethtool does
   not support half duplex for either of these, and we make no effort
   to do so.
3. add accessors for modifying a MDIO device register, and use them in
   phylib, rather than duplicating the code from phylib.
4. add support for decoding the advertisement from clause 22 compatible
   register sets for clause 37 advertisements and SGMII advertisements.
5. add support for clause 45 register sets for 10GBASE-R PCS.

These have been tested on the LX2160A Clearfog-CX platform.

 drivers/net/phy/mdio_bus.c |  55 +++++++++++
 drivers/net/phy/phy-core.c |  31 ------
 drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |   4 +
 include/linux/mii.h        |  57 +++++++----
 include/linux/phy.h        |  19 ++++
 include/linux/phylink.h    |   8 ++
 include/uapi/linux/mii.h   |   5 +
 8 files changed, 366 insertions(+), 49 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
