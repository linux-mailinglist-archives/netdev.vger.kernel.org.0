Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1373188805
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQOtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:49:16 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40840 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgCQOtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Xl4T25ycDwl5XZ4au/sHdE6nMKUuW2y1rPQgDK9Hm1k=; b=xlIQxRziiYYxsGY6b7Q5bUo5+
        llsYFvSucBlyg+N0Kl3C/mOXlwG0hNEV3losLjpeKwWSZ8sUffcVZb1lyiGXLLDKe/S6OWgklsdS8
        U+EWlyskYqdXf2pdeyX8TKMetAE9VBYa5UGVyE4LWBEGX5CyAHibzRP1rnAmnXROiuoJtP21DtQ45
        /dhx4CxAPxPNcZojqJdbDzLGUOLIfFRD88NnLkVCgrWensuq/XDjNezUlc+ryqzm9EfBtfppX4W1X
        aVexWB2wu90VP+/mvzycNzOeTiVgKWyd34yQDKAA8qiJye7RFhXRNXnhvUA4dZTgrrGPgccmTfCWP
        xMDp/jqmA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33546)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEDWm-0007gf-PC; Tue, 17 Mar 2020 14:49:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEDWk-0002t7-Jo; Tue, 17 Mar 2020 14:49:06 +0000
Date:   Tue, 17 Mar 2020 14:49:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] net: add phylink support for PCS
Message-ID: <20200317144906.GO25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for IEEE 802.3 register set compliant PCS
for phylink.  In order to do this, we:

1. convert BUG_ON() in existing accessors to WARN_ON_ONCE() and return
   an error.
2. add accessors for modifying a MDIO device register, and use them in
   phylib, rather than duplicating the code from phylib.
3. add support for decoding the advertisement from clause 22 compatible
   register sets for clause 37 advertisements and SGMII advertisements.
4. add support for clause 45 register sets for 10GBASE-R PCS.

These have been tested on the LX2160A Clearfog-CX platform.

v2: eliminate use of BUG_ON() in the accessors.

 drivers/net/phy/mdio_bus.c |  68 ++++++++++++-
 drivers/net/phy/phy-core.c |  31 ------
 drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |   4 +
 include/linux/phy.h        |  19 ++++
 include/linux/phylink.h    |   8 ++
 include/uapi/linux/mii.h   |   5 +
 7 files changed, 336 insertions(+), 35 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
