Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921C01359EF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgAINSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:18:46 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:33123 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbgAINSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:18:46 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 192431C0004;
        Thu,  9 Jan 2020 13:18:42 +0000 (UTC)
Date:   Thu, 9 Jan 2020 14:18:42 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     David Miller <davem@davemloft.net>
Cc:     antoine.tenart@bootlin.com, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 08/15] net: phy: mscc: macsec initialization
Message-ID: <20200109131842.GC5472@kwain>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
 <20191219105515.78400-9-antoine.tenart@bootlin.com>
 <20191219.121117.1826219046339114907.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191219.121117.1826219046339114907.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Thu, Dec 19, 2019 at 12:11:17PM -0800, David Miller wrote:
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Date: Thu, 19 Dec 2019 11:55:08 +0100
> 
> > +static u32 __vsc8584_macsec_phy_read(struct phy_device *phydev,
> > +				     enum macsec_bank bank, u32 reg, bool init)
> > +{
> > +	u32 val, val_l = 0, val_h = 0;
> > +	unsigned long deadline;
> > +	int rc;
> > +
> > +	if (!init) {
> > +		rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
> > +		if (rc < 0)
> > +			goto failed;
> > +	} else {
> > +		__phy_write_page(phydev, MSCC_PHY_PAGE_MACSEC);
> > +	}
> 
> Having to export __phy_write_page() in the previous patch looked like
> a huge red flag to me, and indeed on top of it you're using it to do
> conditional locking here.
> 
> I'm going to unfortunately have to push back on this, please sanitize
> the locking here so that you can use the existing exports properly.

I do agree this conditional locking is not very good. We had discussions
with Andrew about how bad this is, but there are no easy fix for this.
At least the condition is consistent depending on if we're in the init
step or not, which is better than having different values in the same
context. The idea was not to duplicate hundreds of lines.

Having said that, the reason we had to do this is we have multiple PHYs
inside the same package and some steps are to be done for all PHYs at a
time. I had another look at this and, for MACsec only, we might be able
not to have a single common part. I'll test the changes and if that's
successful I'll be able to fix this in a clean way.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
