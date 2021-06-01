Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7ED3973FF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhFANVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:21:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhFANVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+u4SacplXlTkNNJW8BzGweLscGfIHsyXrxZtnVa/2Gc=; b=zVa7iUPXcUVaD1A2u2w2D1ec/O
        8YXJGb0khfrhWFCxia4mThkPojjrPS93yEiuumYG5pS3r7Bbx1nugMKx7FAI0PAuPy91eodrcLa8k
        qMjSGlgxYp2Q0q9DacnQWDvZ/fEv6Kfa/hkhCd6a3iv/82IQXMicxQpnPHUea6x/kEcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo4JD-007I76-L1; Tue, 01 Jun 2021 15:19:51 +0200
Date:   Tue, 1 Jun 2021 15:19:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YLYz94yo0ge6CDh+@lunn.ch>
References: <20210528193719.6132-1-davthompson@nvidia.com>
 <YLGJLv7y0NLPFR28@lunn.ch>
 <CH2PR12MB3895FA4354E69D830F39CDC8D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895FA4354E69D830F39CDC8D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please do not top post.

> Thanks.
> Asmaa
> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch> 
> Sent: Friday, May 28, 2021 8:22 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org; Liming Sun <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet driver
> 
> > +static void mlxbf_gige_adjust_link (struct net_device *netdev) {
> > +	struct mlxbf_gige *priv = netdev_priv(netdev);
> > +	struct phy_device *phydev = netdev->phydev;
> > +
> > +	if (phydev->link) {
> > +		priv->rx_pause = phydev->pause;
> > +		priv->tx_pause = phydev->pause;
> > +	}
> 
> ...
> 
> > +	/* MAC supports symmetric flow control */
> > +	phy_support_sym_pause(phydev);
> 

> What i don't see anywhere is you acting on the results of the pause
> negotiation. It could be, mlxbf_gige_adjust_link() tells you the
> peer does not support pause, and you need to disable it in this MAC
> as well. It is a negotiation, after all.

From what you are saying, this is all wrong. You don't negotiate at
all. So don't report negotiated values in ethtool, just report the
fixed values, and do not set autoneg in ethtool_pauseparam because you
have not negotiated it.

You also should not be calling phy_support_sym_pause(), which means, i
support negotiated pause up to and including symmetric pause. You
might also need to clear the pause bits from phydev->advertising.

	Andrew
