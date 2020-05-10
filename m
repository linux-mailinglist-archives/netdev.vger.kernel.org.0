Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B65C1CCBB9
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 17:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgEJPEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 11:04:14 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:59047 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgEJPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 11:04:13 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D42C62271F;
        Sun, 10 May 2020 17:04:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589123051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLojyfYNjEZhaHGJskL5dHK8If95RppJnGDENEZpXcI=;
        b=mw4ydhCvvQbVl7hV+zSzE0T83jfbolJsVqw+WZe8tk4xUjQ3ofWeD7bOkl8pZqZ2ccwXk0
        irMga3UJwzD64bDGWwXP9Y6rL1zdM2M3yfzOgG8Mq0BVG1dN3DI8tEv52ZNxRi2Oo3baL0
        rd58z3gLqlCUQj0KXauBxUnTAzdy1ag=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 10 May 2020 17:04:11 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: at803x: add cable diagnostics support
In-Reply-To: <20200510145250.GK362499@lunn.ch>
References: <20200509221719.24334-1-michael@walle.cc>
 <20200510145250.GK362499@lunn.ch>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8e64c94a4306a93578d9092c00bbc827@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-10 16:52, schrieb Andrew Lunn:
> More of a note to self:
> 
> Now we have three implementations, we start to see bits of common code
> which could be pulled out and shared.
> 
>> +static bool at803x_cdt_fault_length_valid(u16 status)
>> +{
>> +	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
>> +	case AT803X_CDT_STATUS_STAT_OPEN:
>> +	case AT803X_CDT_STATUS_STAT_SHORT:
>> +		return true;
>> +	}
>> +	return false;
>> +}
> 
> If we uses the netlink attribute values, not the PHY specific values,
> this could be put in the core.
> 
>> +
>> +static int at803x_cdt_fault_length(u16 status)
>> +{
>> +	int dt;
>> +
>> +	/* According to the datasheet the distance to the fault is
>> +	 * DELTA_TIME * 0.824 meters.
>> +	 *
>> +	 * The author suspect the correct formula is:
>> +	 *
>> +	 *   fault_distance = DELTA_TIME * (c * VF) / 125MHz / 2
>> +	 *
>> +	 * where c is the speed of light, VF is the velocity factor of
>> +	 * the twisted pair cable, 125MHz the counter frequency and
>> +	 * we need to divide by 2 because the hardware will measure the
>> +	 * round trip time to the fault and back to the PHY.
>> +	 *
>> +	 * With a VF of 0.69 we get the factor 0.824 mentioned in the
>> +	 * datasheet.
>> +	 */
>> +	dt = FIELD_GET(AT803X_CDT_STATUS_DELTA_TIME_MASK, status);
>> +
>> +	return (dt * 824) / 10;
>> +}
> 
> There seems to be a general consensus of 0.824 meters. So we could
> have helpers to convert back and forth in the core.

Yeah, but I don't know why VF is 0.69 (and it differs per cable, so
its just some kind of sensible default value). According to
https://en.wikipedia.org/wiki/Velocity_factor it should be something
around 0.64 or 0.65.

-michael

> 
>> +static int at803x_cable_test_start(struct phy_device *phydev)
>> +{
>> +	/* Enable auto-negotiation, but advertise no capabilities, no link
>> +	 * will be established. A restart of the auto-negotiation is not
>> +	 * required, because the cable test will automatically break the 
>> link.
>> +	 */
>> +	phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
>> +	phy_write(phydev, MII_ADVERTISE, ADVERTISE_CSMA);
>> +	phy_write(phydev, MII_CTRL1000, 0);
> 
> Could be a genphy_ helper.
> 
> Lets get the code merged, when we can come back and do some
> refactoring.
> 
> 	Andrew
