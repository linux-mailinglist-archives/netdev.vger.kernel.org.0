Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1935CE45
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245506AbhDLQn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244977AbhDLQiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902C861025;
        Mon, 12 Apr 2021 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618245512;
        bh=x3poDP3WbJQgi2AQw0KWdhqafvNKtUGED5/DHA8UJXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=INaZO7S7eTTZQVRTr6KcM2lAn4neII3N+mzu3NKC4VJsrEJVFGyw3Z1DVBXsyOVXK
         FsiE9LYDWFS9L7EGmmIFN+a+uUgeSDT9Q1CB7X+EcC1PeMtZb3ApGzyUz9l4y34leL
         CtnXtK2NBPx6CvvOe6EjhC1BBd9+BYWHZfGMKagGK6eRu1i3xGP18U34yZvmp4Psf6
         rBz/pOLFS3DrVDjlCoFETjS7VH2q8ika8bbsaeVCro04zlcposLKE2VZxvoULZXqpk
         A2jTlDBiLpK+ReWXh2Q0Z+/UNr7xsiq41lQPjtLlAVn1s99RSWJLnbUmFl8ISN6gYC
         EfMeCsWQlPr2A==
Received: by pali.im (Postfix)
        id 15A19687; Mon, 12 Apr 2021 18:38:29 +0200 (CEST)
Date:   Mon, 12 Apr 2021 18:38:29 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <20210412163829.kp7feb3yhzymukg2@pali>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRcu+dNKE7xC8EG@lunn.ch>
 <20210412150152.pbz5zt7mu3aefbrx@pali>
 <YHRoEfGi3/l3K6iF@lunn.ch>
 <20210412155239.chgrne7uzvlrac2e@pali>
 <YHRxcyezvUij82bl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YHRxcyezvUij82bl@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 April 2021 18:12:35 Andrew Lunn wrote:
> On Mon, Apr 12, 2021 at 05:52:39PM +0200, Pali Rohár wrote:
> > On Monday 12 April 2021 17:32:33 Andrew Lunn wrote:
> > > > Anyway, now I'm looking at phy/marvell.c driver again and it supports
> > > > only 88E6341 and 88E6390 families from whole 88E63xxx range.
> > > > 
> > > > So do we need to define for now table for more than
> > > > MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries?
> > > 
> > > Probably not. I've no idea if the 6393 has an ID, so to be safe you
> > > should add that. Assuming it has a family of its own.
> > 
> > So what about just?
> > 
> > 	if (reg == MII_PHYSID2 && !(val & 0x3f0)) {
> > 		if (chip->info->family == MV88E6XXX_FAMILY_6341)
> > 			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6341 >> 4;
> > 		else if (chip->info->family == MV88E6XXX_FAMILY_6390)
> > 			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> > 	}
> 
> As i said, i expect the 6393 also has no ID. And i recently found out
> Marvell have some automotive switches, 88Q5xxx which are actually
> based around the same IP and could be added to this driver. They also
> might not have an ID. I suspect this list is going to get longer, so
> having it table driven will make that simpler, less error prone.
> 
>      Andrew

Ok, I will use table but I fill it only with Topaz (6341) and Peridot
(6390) which was there before as I do not have 6393 switch for testing.

If you or anybody else has 6393 unit for testing, please extend then
table.
