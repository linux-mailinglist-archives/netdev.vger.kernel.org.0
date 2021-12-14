Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD58F473FA9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 10:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhLNJj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 04:39:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhLNJj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 04:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j+RmcVDTIeDOSJuZcBLUijsZL+mu256ZqxBjLPcGmew=; b=bMftSZdo18MuMjlDm+K0MuPhVc
        bjMBPGvfceiSJzj/Y2abt0E06Vavz3L3vfEm/bwUicQ8D/rI6TcsnsVH79kSKT38PCeP22kvbeZkZ
        gLmnYos48Cz8p0yBm8XrY6RCn8rfS1NwxFmIUF1rUpC1NqJuNwNPkanA3zvnAVOhJo8E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mx4HN-00GUcp-Bh; Tue, 14 Dec 2021 10:39:25 +0100
Date:   Tue, 14 Dec 2021 10:39:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuration
Message-ID: <YbhmTcFITSD1dOts@lunn.ch>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 07:00:37AM +0000, Ismail, Mohammad Athari wrote:
> Hi Oleksij,
> 
> "net: phy: genphy_loopback: add link speed configuration" patch causes Marvell 88E1510 PHY not able to perform PHY loopback using ethtool command (ethtool -t eth0 offline). Below is the error message: 
> 
> "Marvell 88E1510 stmmac-3:01: genphy_loopback failed: -110" 

-110 is ETIMEDOUT. So that points to the phy_read_poll_timeout().

Ah, that points to the fact the Marvell PHYs are odd. You need to
perform a software reset after changing some registers to actually
execute the change.

As a quick test, please could you try:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..b45f3ffc7c7f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2625,6 +2625,10 @@ int genphy_loopback(struct phy_device *phydev, bool enable)
 
                phy_modify(phydev, MII_BMCR, ~0, ctl);
 
+               ret = genphy_soft_reset(phydev);
+               if (ret < 0)
+                       return ret;
+
                ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
                                            val & BMSR_LSTATUS,
                                    5000, 500000, true);

If this fixes it for you, the actual fix will be more complex, Marvell
cannot use genphy_loopback, it will need its own implementation.

       Andrew
