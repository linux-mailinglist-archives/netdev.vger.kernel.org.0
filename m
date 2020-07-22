Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A49229A63
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732753AbgGVOlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:41:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgGVOlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 10:41:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyFvd-006LX1-7F; Wed, 22 Jul 2020 16:41:05 +0200
Date:   Wed, 22 Jul 2020 16:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc, colin.king@canonical.com
Subject: Re: [PATCH net-next] net: phy: fix check in get_phy_c45_ids
Message-ID: <20200722144105.GB1339445@lunn.ch>
References: <20200720172654.1193241-1-olteanv@gmail.com>
 <20200722115209.7dpr5wlqxvhwju2y@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722115209.7dpr5wlqxvhwju2y@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 02:52:09PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 20, 2020 at 08:26:54PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > After the patch below, the iteration through the available MMDs is
> > completely short-circuited, and devs_in_pkg remains set to the initial
> > value of zero.
> > 
> > Due to devs_in_pkg being zero, the rest of get_phy_c45_ids() is
> > short-circuited too: the following loop never reaches below this point
> > either (it executes "continue" for every device in package, failing to
> > retrieve PHY ID for any of them):
> > 
> > 	/* Now probe Device Identifiers for each device present. */
> > 	for (i = 1; i < num_ids; i++) {
> > 		if (!(devs_in_pkg & (1 << i)))
> > 			continue;
> > 
> > So c45_ids->device_ids remains populated with zeroes. This causes an
> > Aquantia AQR412 PHY (same as any C45 PHY would, in fact) to be probed by
> > the Generic PHY driver.
> > 
> > The issue seems to be a case of submitting partially committed work (and
> > therefore testing something other than was submitted).
> > 
> > The intention of the patch was to delay exiting the loop until one more
> > condition is reached (the devs_in_pkg read from hardware is either 0, OR
> > mostly f's). So fix the patch to reflect that.
> > 
> > Tested with traffic on a LS1028A-QDS, the PHY is now probed correctly
> > using the Aquantia driver. The devs_in_pkg bit field is set to
> > 0xe000009a, and the MMDs that are present have the following IDs:
> > 
> > [    5.600772] libphy: get_phy_c45_ids: device_ids[1]=0x3a1b662
> > [    5.618781] libphy: get_phy_c45_ids: device_ids[3]=0x3a1b662
> > [    5.630797] libphy: get_phy_c45_ids: device_ids[4]=0x3a1b662
> > [    5.654535] libphy: get_phy_c45_ids: device_ids[7]=0x3a1b662
> > [    5.791723] libphy: get_phy_c45_ids: device_ids[29]=0x3a1b662
> > [    5.804050] libphy: get_phy_c45_ids: device_ids[30]=0x3a1b662
> > [    5.816375] libphy: get_phy_c45_ids: device_ids[31]=0x0
> > 
> > [    7.690237] mscc_felix 0000:00:00.5: PHY [0.5:00] driver [Aquantia AQR412] (irq=POLL)
> > [    7.704739] mscc_felix 0000:00:00.5: PHY [0.5:01] driver [Aquantia AQR412] (irq=POLL)
> > [    7.718918] mscc_felix 0000:00:00.5: PHY [0.5:02] driver [Aquantia AQR412] (irq=POLL)
> > [    7.733044] mscc_felix 0000:00:00.5: PHY [0.5:03] driver [Aquantia AQR412] (irq=POLL)
> > 
> > Fixes: bba238ed037c ("net: phy: continue searching for C45 MMDs even if first returned ffff:ffff")
> > Reported-by: Colin King <colin.king@canonical.com>
> > Reported-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> 
> This patch is repairing some pretty significant breakage. Could we
> please get some review before there start appearing user reports?
> 
> [ sorry for the breakage ]

I'm surprised it has not been merged, since the fix seems quite
obvious.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
