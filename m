Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884731CCBAD
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgEJOwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:52:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgEJOww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jf7KMzLoUqWjJA4nOzX8hvYveYbVixu6Y8T38Edyc00=; b=WG/vdhGV35Zb2wA0e9MecT4sJB
        Y4LjB1ntGhzqaFmlWc/ZL6q0UF3C1DUJD+sHHFZh2LWxX0MJU1FjZikTB/Tk5BYHk89nSuTC8YGLQ
        SDa2FNkruDJzy+UpJMCKBezFYKxhD2/OnAD6KyPJ/4U1cOjRVeMTGfZNQDBvdIrsaWCk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXnJy-001iDm-Cd; Sun, 10 May 2020 16:52:50 +0200
Date:   Sun, 10 May 2020 16:52:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: at803x: add cable diagnostics support
Message-ID: <20200510145250.GK362499@lunn.ch>
References: <20200509221719.24334-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509221719.24334-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More of a note to self:

Now we have three implementations, we start to see bits of common code
which could be pulled out and shared.

> +static bool at803x_cdt_fault_length_valid(u16 status)
> +{
> +	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
> +	case AT803X_CDT_STATUS_STAT_OPEN:
> +	case AT803X_CDT_STATUS_STAT_SHORT:
> +		return true;
> +	}
> +	return false;
> +}

If we uses the netlink attribute values, not the PHY specific values,
this could be put in the core.

> +
> +static int at803x_cdt_fault_length(u16 status)
> +{
> +	int dt;
> +
> +	/* According to the datasheet the distance to the fault is
> +	 * DELTA_TIME * 0.824 meters.
> +	 *
> +	 * The author suspect the correct formula is:
> +	 *
> +	 *   fault_distance = DELTA_TIME * (c * VF) / 125MHz / 2
> +	 *
> +	 * where c is the speed of light, VF is the velocity factor of
> +	 * the twisted pair cable, 125MHz the counter frequency and
> +	 * we need to divide by 2 because the hardware will measure the
> +	 * round trip time to the fault and back to the PHY.
> +	 *
> +	 * With a VF of 0.69 we get the factor 0.824 mentioned in the
> +	 * datasheet.
> +	 */
> +	dt = FIELD_GET(AT803X_CDT_STATUS_DELTA_TIME_MASK, status);
> +
> +	return (dt * 824) / 10;
> +}

There seems to be a general consensus of 0.824 meters. So we could
have helpers to convert back and forth in the core.

> +static int at803x_cable_test_start(struct phy_device *phydev)
> +{
> +	/* Enable auto-negotiation, but advertise no capabilities, no link
> +	 * will be established. A restart of the auto-negotiation is not
> +	 * required, because the cable test will automatically break the link.
> +	 */
> +	phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
> +	phy_write(phydev, MII_ADVERTISE, ADVERTISE_CSMA);
> +	phy_write(phydev, MII_CTRL1000, 0);

Could be a genphy_ helper.

Lets get the code merged, when we can come back and do some
refactoring.

	Andrew

