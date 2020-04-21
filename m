Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09681B305B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDUTa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:30:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDUTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=869WgTAm8fPzHRXk0oXeeK3XJ3W9FcEBHCf2mBhSQ8A=; b=UhkMmxc5rqjccfJlOUb2dLymev
        FkmPpIzQPLpgPvbZQTymH6ckC4KQ290Bf+VA/7DqWrGBz2AXOif24oj03RgSwL5uVRqRUsneEeEND
        KBMiGYQQ1d7hYGHxolQFrl02K/4dNhxwBK5qhTSdWzdKs+hJTYINL3FmYiFBDJ1ouySk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQybf-0044tp-73; Tue, 21 Apr 2020 21:30:55 +0200
Date:   Tue, 21 Apr 2020 21:30:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200421193055.GI933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
 <20200421155031.GE933345@lunn.ch>
 <47bdeaf298a09f20ad6631db13df37d2@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47bdeaf298a09f20ad6631db13df37d2@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Speaking of it. Does anyone have an idea how I could create the hwmon
> device without the PHY device? At the moment it is attached to the
> first PHY device and is removed when the PHY is removed, although
> there might be still other PHYs in this package. Its unlikely to
> happen though, but if someone has a good idea how to handle that,
> I'd give it a try.

There is a somewhat similar problem with Marvell Ethernet switches and
their internal PHYs. The PHYs are the same as the discrete PHYs, and
the usual Marvell PHY driver is used. But there is only one
temperature sensor for the whole switch, and it is mapped into all the
PHYs. So we end up creating multiple hwmon devices for the one
temperature sensor, one per PHY.

You could take the same approach here. Each PHY exposes a hwmon
device?

Looking at
static struct device *
__hwmon_device_register(struct device *dev, const char *name, void *drvdata,
                        const struct hwmon_chip_info *chip,
                        const struct attribute_group **groups)

I think it is O.K. to pass dev as NULL. You don't have to associate it
to a device. So you could create the hwmon device as part of package
initialisation and put it into shared->priv.

	Andrew
