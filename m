Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84335CADB
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbhDLQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:12:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242899AbhDLQM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:12:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVzAx-00GHri-OE; Mon, 12 Apr 2021 18:12:35 +0200
Date:   Mon, 12 Apr 2021 18:12:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YHRxcyezvUij82bl@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRcu+dNKE7xC8EG@lunn.ch>
 <20210412150152.pbz5zt7mu3aefbrx@pali>
 <YHRoEfGi3/l3K6iF@lunn.ch>
 <20210412155239.chgrne7uzvlrac2e@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412155239.chgrne7uzvlrac2e@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 05:52:39PM +0200, Pali Rohár wrote:
> On Monday 12 April 2021 17:32:33 Andrew Lunn wrote:
> > > Anyway, now I'm looking at phy/marvell.c driver again and it supports
> > > only 88E6341 and 88E6390 families from whole 88E63xxx range.
> > > 
> > > So do we need to define for now table for more than
> > > MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries?
> > 
> > Probably not. I've no idea if the 6393 has an ID, so to be safe you
> > should add that. Assuming it has a family of its own.
> 
> So what about just?
> 
> 	if (reg == MII_PHYSID2 && !(val & 0x3f0)) {
> 		if (chip->info->family == MV88E6XXX_FAMILY_6341)
> 			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6341 >> 4;
> 		else if (chip->info->family == MV88E6XXX_FAMILY_6390)
> 			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> 	}

As i said, i expect the 6393 also has no ID. And i recently found out
Marvell have some automotive switches, 88Q5xxx which are actually
based around the same IP and could be added to this driver. They also
might not have an ID. I suspect this list is going to get longer, so
having it table driven will make that simpler, less error prone.

     Andrew
