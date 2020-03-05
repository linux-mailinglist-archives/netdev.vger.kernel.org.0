Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F2F17A80D
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCEOsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:48:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38595 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgCEOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:48:11 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j9rnG-0002VL-9s; Thu, 05 Mar 2020 15:48:10 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j9rnF-000245-Tr; Thu, 05 Mar 2020 15:48:09 +0100
Date:   Thu, 5 Mar 2020 15:48:09 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] fsl/fman: Use random MAC address when none is given
Message-ID: <20200305144809.GW3335@pengutronix.de>
References: <20200305123414.5010-1-s.hauer@pengutronix.de>
 <DB8PR04MB6985F8A2EB05F426F2CF8C0AECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985F8A2EB05F426F2CF8C0AECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:17:58 up 14 days, 21:48, 52 users,  load average: 0.02, 0.11,
 0.17
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 01:38:01PM +0000, Madalin Bucur wrote:
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Thursday, March 5, 2020 2:34 PM
> > To: netdev@vger.kernel.org
> > Cc: Madalin Bucur <madalin.bucur@nxp.com>; Sascha Hauer
> > <s.hauer@pengutronix.de>
> > Subject: [PATCH v2] fsl/fman: Use random MAC address when none is given
> > 
> > There's no need to fail probing when no MAC address is given in the
> > device tree, just use a random MAC address.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> > 
> > Changes since v1:
> > - Remove printing of permanent MAC address
> > 
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 11 +++++++++--
> >  drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
> >  drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
> >  3 files changed, 11 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index fd93d542f497..fc117eab788d 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -233,8 +233,15 @@ static int dpaa_netdev_init(struct net_device
> > *net_dev,
> >  	net_dev->features |= net_dev->hw_features;
> >  	net_dev->vlan_features = net_dev->features;
> > 
> > -	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> > -	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > +	if (is_valid_ether_addr(mac_addr)) {
> > +		dev_info(dev, "FMan MAC address: %pM\n", mac_addr);
> > +		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> > +		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > +	} else {
> > +		eth_hw_addr_random(net_dev);
> > +		dev_info(dev, "Using random MAC address: %pM\n",
> > +			 net_dev->dev_addr);
> > +	}
> 
> To make the HW MAC aware of the new random address you set in the dpaa_eth,
> you also need to call mac_dev->change_addr() after eth_hw_addr_random(), like
> it's done in dpaa_set_mac_address():
> 
>         err = mac_dev->change_addr(mac_dev->fman_mac,
>                                    (enet_addr_t *)net_dev->dev_addr);
> 
> This will write the new MAC address in the MAC HW registers.

Ok, I see.

So when I call mac_dev->change_addr() here in dpaa_netdev_init() it
means I can remove all the code setting the MAC address in hardware
before this point, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
