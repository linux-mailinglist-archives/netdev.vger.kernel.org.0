Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AB51C56FB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgEENc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:32:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbgEENc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:32:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2ED04AB89;
        Tue,  5 May 2020 13:32:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 601DD602B9; Tue,  5 May 2020 15:32:25 +0200 (CEST)
Date:   Tue, 5 May 2020 15:32:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 07/10] net: ethtool: Add helpers for
 reporting test results
Message-ID: <20200505133225.GJ5989@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-8-andrew@lunn.ch>
 <20200505105043.GK8237@lion.mk-sys.cz>
 <20200505132203.GG208718@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505132203.GG208718@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 03:22:03PM +0200, Andrew Lunn wrote:
> > > +int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
> > > +{
> > > +	struct nlattr *nest;
> > > +	int ret = -EMSGSIZE;
> > > +
> > > +	nest = nla_nest_start(phydev->skb,
> > > +			      ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH);
> > > +	if (!nest)
> > > +		return -EMSGSIZE;
> > > +
> > > +	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR, pair))
> > > +		goto err;
> > > +	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_CM, cm))
> > > +		goto err;
> > 
> > This should be nla_put_u32().
> 
> Yes. I think i messed up a rebase merge conflict somewhere. I'm also
> surprised user space is not complaining.

There is no difference on little endian architectures as nla_put_*()
helpers all call __nla_reserve() which fills the padding with zero
bytes. IIRC there was a case where wrong attribute type had been used
for quite long without anyone noticing.

Michal
