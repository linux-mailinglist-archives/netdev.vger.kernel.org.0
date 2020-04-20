Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC211B1130
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgDTQLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgDTQLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:11:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72ADC061A0C;
        Mon, 20 Apr 2020 09:11:24 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 24DB823058;
        Mon, 20 Apr 2020 18:11:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587399083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV6/yxI0hnc0gvSbIatDYRHmoDSkrGEsV3XUSagw0bk=;
        b=Gft4E8gYE1Lgsbzo3T45DiSRrqtW8EXgO1MzjtcCpkpzeNmTcz9ooabT2uU5w+5DEq1jiB
        Fm2CW2M+hAkXy/yB6/MppZvOKIVGP+qyL8twG3E2QEaWi6pe5VB8nmJZ+has2k0UFwuWs5
        zegzfvshTGmk6r02tUYBRwmwFvYHTbU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Apr 2020 18:11:22 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
In-Reply-To: <20200420153625.GA917792@lunn.ch>
References: <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
 <20200419170547.GO836632@lunn.ch>
 <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
 <20200419215549.GR836632@lunn.ch>
 <75428c5faab7fc656051ab227663e6e6@walle.cc>
 <20200420153625.GA917792@lunn.ch>
Message-ID: <00e8c608daac498623643e8f769f80a6@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 24DB823058
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.970];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,suse.com,roeck-us.net,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-20 17:36, schrieb Andrew Lunn:
>> Ok I see, but what locking do you have in mind? We could have 
>> something
>> like
>> 
>> __phy_package_write(struct phy_device *dev, u32 regnum, u16 val)
>> {
>>   return __mdiobus_write(phydev->mdio.bus, phydev->shared->addr,
>>                          regnum, val);
>> }
>> 
>> and its phy_package_write() equivalent. But that would just be
>> convenience functions, nothing where you actually help the user with
>> locking. Am I missing something?
> 
> In general, drivers should not be using __foo functions. We want
> drivers to make use of phy_package_write() which would do the bus
> locking. Look at a typical PHY driver. There is no locking what so
> ever. Just lots of phy_read() and phy write(). The locking is done by
> the core and so should be correct.

Ok, but for example the BCM54140 uses indirect register access and thus
need to lock the mdio bus itself in which case I need the __funcs.

>> > > > Get the core to do reference counting on the structure?
>> > > > Add helpers phy_read_shared(), phy_write_shared(), etc, which does
>> > > > MDIO accesses on the base device, taking care of the locking.
>> > > >
>> > > The "base" access is another thing, I guess, which has nothing to do
>> > > with the shared structure.
>> > >
>> > I'm making the assumption that all global addresses are at the base
>> > address. If we don't want to make that assumption, we need the change
>> > the API above so you pass a cookie, and all PHYs need to use the same
>> > cookie to identify the package.
>> 
>> how would a phy driver deduce a common cookie? And how would that be a
>> difference to using a PHY address.
> 
> For a cookie, i don't care how the driver decides on the cookie. The
> core never uses it, other than comparing cookies to combine individual
> PHYs into a package. It could be a PHY address. It could be the PHY
> address where the global registers are. Or it could be anything else.
> 
>> > Maybe base is the wrong name, since MSCC can have the base as the high
>> > address of the four, not the low?
>> 
>> I'd say it might be any of the four addresses as long as it is the 
>> same
>> across the PHYs in the same package. And in that case you can also 
>> have
>> the phy_package_read/write() functions.
> 
> Yes. That is the semantics which is think is most useful. But then we
> don't have a cookie, the value has real significance, and we need to
> document what is should mean.

Agreed.

I will post a RFC shortly.

-michael
