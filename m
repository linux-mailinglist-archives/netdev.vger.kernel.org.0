Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3B3F0D38
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhHRVU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:20:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233753AbhHRVU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 17:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KjZbslUDSsRTouML/anK3fJ95C9w1DxGIoxVwKiJy/0=; b=SD1+A4ilJQrrwI1CTMy9P1E/zS
        Yb7F0brjaM5jyx1hXiHTC5c7qJRFCyw3/7wFwOKNjoG211G/njmpuDrv/6N8sq01/muMOW9KJXfxx
        nWF2gS42yO0YHSFFe4AUpLNRyOCCg0DLagYTWX+vCcku6WNNWNX0mS2UaFbo2oW71r1k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGSyw-000qek-Ps; Wed, 18 Aug 2021 23:20:18 +0200
Date:   Wed, 18 Aug 2021 23:20:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: Support set_loopback override
Message-ID: <YR15ku/FsZN55/Pi@lunn.ch>
References: <20210818122736.4877-1-gerhard@engleder-embedded.com>
 <20210818122736.4877-2-gerhard@engleder-embedded.com>
 <YR0hQ6UmtmGNg2AW@lunn.ch>
 <CANr-f5xL_H0GOQ7u6xsVxS--mKpM5zve6k-jcMKnqHBf+Bm9rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5xL_H0GOQ7u6xsVxS--mKpM5zve6k-jcMKnqHBf+Bm9rg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I saw only 4 references for to_phy_driver():
> - phy_loopback() of course
> - phy_probe() which uses it to initialize phydev->drv 3 lines later

This is correct. The driver core will set dev.driver to what it thinks
is the correct driver to use, before calling probe.

> - mdio_bus_phy_may_suspend() which checks only for valid suspend function
>   pointer, but later phy_suspend() uses phydev->drv, so this is at
>   least inconsistent

I guess the real question here is, can a device be suspended before it
is probed? It would seem rather odd. So i expect phydev->drv is safe
to use.

> - phy_bus_match() which casts from struct device_driver to struct phy_driver

This is used by the driver core when trying to find a matching
driver. So it is used before phy_probe(). So this is correct.

> 
> phydev->drv is used much more often and seems to be the right way. I suggest to
> also fix mdio_bus_phy_may_suspend(). phy_probe() and phy_bus_match() are
> valid uses, because phydev->drv is not available for them.
> 
> Do you agree?

Agreed. Thanks for spending the time to look at this. I was expecting
there to be more problems than just loopback.

	Andrew
