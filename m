Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C7C1C569B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgEENTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:19:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgEENTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cOGZMDYDg91AdmJwbZJ05nNM/oJQN2A62u8nZ70fMzc=; b=VS9bEppuNnpoJTurjp7fm2M6Ul
        9ekYJP8XV/RYiCBi9GQdgC/YdzCqqni0NtzRI1TTprSpiOQyXE6riVtOAosQG4h0DQ65gXnmiBpnZ
        52OjQln2RKo7K0dvmaP4EFOdy/dG2Ys/rc26xROPl8JL0Gvcr0d6IYB5UIfUkvAHNxbY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVxU0-000w3y-En; Tue, 05 May 2020 15:19:36 +0200
Date:   Tue, 5 May 2020 15:19:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200505131936.GF208718@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-7-andrew@lunn.ch>
 <20200505104226.GJ8237@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505104226.GJ8237@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int ethnl_cable_test_alloc(struct phy_device *phydev)
> > +{
> > +	int err = -ENOMEM;
> > +
> > +	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> > +	if (!phydev->skb)
> > +		goto out;
> > +
> > +	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb,
> > +					  ETHTOOL_MSG_CABLE_TEST_NTF);
> > +	if (!phydev->ehdr) {
> > +		err = -EINVAL;
> 
> This should be -EMSGSIZE.
> 
> > +		goto out;
> > +	}
> > +
> > +	err = ethnl_fill_reply_header(phydev->skb, phydev->attached_dev,
> > +				      ETHTOOL_A_CABLE_TEST_NTF_HEADER);
> > +	if (err)
> > +		goto out;
> > +
> > +	err = nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_TEST_NTF_STATUS,
> > +			 ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED);
> > +	if (err)
> > +		goto out;
> > +
> > +	phydev->nest = nla_nest_start(phydev->skb,
> > +				      ETHTOOL_A_CABLE_TEST_NTF_NEST);
> > +	if (!phydev->nest)
> > +		goto out;
> 
> If nla_nest_start() fails, we still have 0 in err.
> 
> > +
> > +	return 0;
> > +
> > +out:
> > +	nlmsg_free(phydev->skb);
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(ethnl_cable_test_alloc);
> 
> Do you think it would make sense to set phydev->skb to NULL on failure
> and also in ethnl_cable_test_free() and ethnl_cable_test_finished() so
> that if driver messes up, it hits null pointer dereference which is much
> easier to debug than use after free?

Hi Michal

The use after free is not that hard to debug, i had to do it myself :-)

But yes, i can poison phydev->skb.

    Andrew
