Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB0224CA
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbfERUNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:13:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbfERUNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 16:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CYbYvK1CPKk1/MLTqKZ6ICtd6ww/51FVz365HfMjpxs=; b=KaSqR2CU5ObZUkC7VQKzszrVtC
        +iJAgz4AqV9h3b1yws3owoaYNZ4a2FKrsYnTKaJAFfIYWmbsQbUXOYcBAvysCNjW4n9ftzDREwsAO
        OFZdopy2hgYSo9wxDExhMA67b/MQ34lwowpgH98E0JeRpQX3dwaJJtjCPiYlAeL+sa2o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hS5hL-00085K-Bc; Sat, 18 May 2019 22:12:51 +0200
Date:   Sat, 18 May 2019 22:12:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190518201251.GA30854@lunn.ch>
References: <20190517235123.32261-1-marex@denx.de>
 <20190518141456.GK14298@lunn.ch>
 <b69b9b70-a299-2754-de9f-c7562b31fa16@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b69b9b70-a299-2754-de9f-c7562b31fa16@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 06:50:48PM +0200, Marek Vasut wrote:
> On 5/18/19 4:14 PM, Andrew Lunn wrote:
> > On Sat, May 18, 2019 at 01:51:23AM +0200, Marek Vasut wrote:
> >> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> >> BroadRReach 100BaseT1 PHYs used in automotive.
> > 
> > Hi Marek
> 
> Hello Andrew,
> 
> >> +	}, {
> >> +		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
> >> +		.name		= "NXP TJA1101",
> >> +		.features       = PHY_BASIC_T1_FEATURES,
> > 
> > One thing i would like to do before this patch goes in is define
> > ETHTOOL_LINK_MODE_100baseT1_Full_BIT in ethtool.h, and use it here.
> > We could not do it earlier because were ran out of bits. But with
> > PHYLIB now using bitmaps, rather than u32, we can.
> > 
> > Once net-next reopens i will submit a patch adding it.
> 
> I can understand blocking patches from being applied if they have review
> problems or need to be updated on some existing or even posted feature.
> But blocking a patch because some future yet-to-be-developed patch is a
> bit odd.

Hi Marek

What i'm trying to avoid is an ABI change. By using
PHY_BASIC_T1_FEATURES you are saying the device support 100BaseT. It
does not. It supports 100BaseT1. I want to add 100BaseT1 first, so
your PHY does not change from 100BaseT to 100BaseT1, which could be
considered an ABI change.

I'm not suggesting blocking your patch for a long time. I'm already
2/3 of the way doing the work. At the latest, i expect to have patches
submitted in the next few days. And then your driver can go in, using
this. So by end of next week, your driver can be in.

> > I also see in the data sheet we should be able to correct detect its
> > features using register 15. So we should extend
> > genphy_read_abilities().
> 
> Which bits do you refer to ?

Register 15, bit 7. This indicates the PHY can do 100BaseT1. I want to
double check with the 802.3 standard, but i expect this is part of the
standard.

	Andrew
