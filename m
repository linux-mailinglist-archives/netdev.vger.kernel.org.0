Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194E91C56FD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgEENcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:32:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbgEENcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zm8nmYUQ9jsX6QIKXZvBO6ftEpq89LkOxRAGw68Poyc=; b=vojTHqdIfHPSKRMmh7eiTM1zv5
        7qXJJ3bXitDwvBjqxMbKtYxzNaoh6ErGgpYzjWvaeoVOa3B6wGSK6PFCuK4UpHrLhWkObqqpXYDxY
        2EU4qydYY64cGX0pOvqjwxmZ6BjkpbP1AAffBrpZFA2z/48+218Ms4TU+Wptb0Mevjck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVxgQ-000wBw-95; Tue, 05 May 2020 15:32:26 +0200
Date:   Tue, 5 May 2020 15:32:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 08/10] net: phy: marvell: Add cable test
 support
Message-ID: <20200505133226.GH208718@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-9-andrew@lunn.ch>
 <6c50c8892e7639e5b0772c9ea8d37d3a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c50c8892e7639e5b0772c9ea8d37d3a@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int marvell_vct7_cable_test_start(struct phy_device *phydev)
> > +{
> > +	int bmcr, bmsr, ret;
> > +
> > +	/* If auto-negotiation is enabled, but not complete, the cable
> > +	 * test never completes. So disable auto-neg.
> > +	 */
> > +	bmcr = phy_read(phydev, MII_BMCR);
> > +	if (bmcr < 0)
> > +		return bmcr;
> > +
> > +	bmsr = phy_read(phydev, MII_BMSR);
> > +
> > +	if (bmsr < 0)
> > +		return bmsr;
> > +
> > +	if (bmcr & BMCR_ANENABLE) {
> > +		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = genphy_soft_reset(phydev);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	/* If the link is up, allow it some time to go down */
> > +	if (bmsr & BMSR_LSTATUS)
> > +		msleep(1500);
> 
> Is it mandatory to wait 1.5s unconditionally or can we poll for link down?

Polling is fine. I think i got this from the Marvell SDK.

> > +
> > +	return phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
> > +			       MII_VCT7_CTRL,
> > +			       MII_VCT7_CTRL_RUN_NOW |
> > +			       MII_VCT7_CTRL_CENTIMETERS);
> > +}
> > +
> > +static int marvell_vct7_distance_to_length(int distance, bool meter)
> > +{
> > +	if (meter)
> > +		distance *= 100;
> 
> I've never understood the use of the meter unit. If we always use
> centimeters, we have 2^16 cm = 655m, shouldn't that be enough given
> that the max cable length is 100m in TP ethernet? Also you hardcode
> the unit to centimeters, so this should be superfluous, making this
> function a noop.

Yes, it should never be used now. But i did use it initially, to see
if the results were different/better. It is a rather odd design, and
i'm wondering if some of the older PHYs only have meters? I guess i
should go look at the SDK.

> > +	return distance;
> > +}
> > +
> > +static bool marvell_vct7_distance_valid(int result)
> > +{
> > +	switch (result) {
> > +	case MII_VCT7_RESULTS_OPEN:
> > +	case MII_VCT7_RESULTS_SAME_SHORT:
> > +	case MII_VCT7_RESULTS_CROSS_SHORT:
> 
> btw on the BCM54140 I've observed, that if you have a intra-pair
> short, the length is wrong; looks like it is twice the value it
> should be.
> 
> Does the Marvell PHY report the correct value?

I've not tested that.

Chris, do you have results for this test?

> > +static int marvell_vct7_cable_test_report(struct phy_device *phydev)
> > +{
> > +	int pair0, pair1, pair2, pair3;
> > +	bool meter;
> > +	int ret;
> > +
> > +	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
> > +			     MII_VCT7_RESULTS);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	pair3 = (ret & MII_VCT7_RESULTS_PAIR3_MASK) >>
> > +		MII_VCT7_RESULTS_PAIR3_SHIFT;
> > +	pair2 = (ret & MII_VCT7_RESULTS_PAIR2_MASK) >>
> > +		MII_VCT7_RESULTS_PAIR2_SHIFT;
> > +	pair1 = (ret & MII_VCT7_RESULTS_PAIR1_MASK) >>
> > +		MII_VCT7_RESULTS_PAIR1_SHIFT;
> > +	pair0 = (ret & MII_VCT7_RESULTS_PAIR0_MASK) >>
> > +		MII_VCT7_RESULTS_PAIR0_SHIFT;
> 
> I'm sure you know FIELD_GET(), so there must be another
> reason why you use mask and shift, consistency?

Consistency, and FIELD_GET() just looks odd, only taking a mask, not a
shift.

     Andrew
