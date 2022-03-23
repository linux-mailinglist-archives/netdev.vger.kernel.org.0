Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB64E5B56
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 23:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiCWWkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 18:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbiCWWkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 18:40:17 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D036167C1;
        Wed, 23 Mar 2022 15:38:46 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 08027221D4;
        Wed, 23 Mar 2022 23:38:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648075124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8jdoR5jqJ3/I0PWZz2NXnJG2RKiRWixoRqKl2Hur6U=;
        b=nVBcxd4j5IU6vfFmHjAuziycN0DAYCCG9p55wtx+3lKUFc84gNrL0WYDwtLSzYMZHh2HVh
        CvCWT3SIhW7p0AHA5uzPI8telKF3X70GtqPVhlGcXIaIr32QmevLKDcyRkFN4K9tpYtqI9
        rCAhTAzjzOcMKL32Xbdh1BJn/L6N4Pw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Mar 2022 23:38:43 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
In-Reply-To: <Yjt99k57mM5PQ8bT@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc> <Yjt99k57mM5PQ8bT@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8304fb3578ee38525a158af768691e75@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-23 21:07, schrieb Andrew Lunn:
> On Wed, Mar 23, 2022 at 07:34:18PM +0100, Michael Walle wrote:
>> The GPY215 driver supports indirect accesses to c45 over the c22
>> registers. In its probe function phy_get_c45_ids() is called and the
>> author descibed their use case as follows:
>> 
>>   The problem comes from condition "phydev->c45_ids.mmds_present &
>>   MDIO_DEVS_AN".
>> 
>>   Our product supports both C22 and C45.
>> 
>>   In the real system, we found C22 was used by customers (with 
>> indirect
>>   access to C45 registers when necessary).
>> 
>> So it is pretty clear that the intention was to have a method to use 
>> the
>> c45 features over a c22-only MDIO bus. The purpose of calling
>> phy_get_c45_ids() is to populate the .c45_ids for a PHY which wasn't
>> probed as a c45 one. Thus, first rename the phy_get_c45_ids() function
>> to reflect its actual meaning and second, add a new flag which 
>> indicates
>> that this is actually a c45 PHY but behind a c22 bus. The latter is
>> important for phylink because phylink will treat c45 in a special way 
>> by
>> checking the .is_c45 property. But in our case this isn't set.
> 
> Thinking out loud...
> 
> 1) We have a C22 only bus. Easy, C45 over C22 should be used.
> 
> 2) We have a C45 only bus. Easy, C45 should be used, and it will of
>    probed that way.
> 
> 3) We have a C22 and C45 bus, but MDIOBUS_NO_CAP. It will probe C22,
>    but ideally we want to swap to C45.
> 
> 4) We have a C22 and C45 bus, MDIOBUS_C22_C45. It will probe C22, but
>    ideally we want to swap to C45.

I presume you are speaking of
https://elixir.bootlin.com/linux/v5.17/source/drivers/net/phy/mdio_bus.c#L700

Shouldn't that be the other way around then? How would you tell if
you can do C45?

>> @@ -99,7 +99,7 @@ static int gpy_probe(struct phy_device *phydev)
>>  	int ret;
>> 
>>  	if (!phydev->is_c45) {
>> -		ret = phy_get_c45_ids(phydev);
>> +		ret = phy_get_c45_ids_by_c22(phydev);
>>  		if (ret < 0)
>>  			return ret;
>>  	}
> 
> If we are inside the if, we know we probed C22. We have to achieve two
> things:
> 
> 1) Get the c45 ids,
> 2) Figure out if C45 works, or if C45 over C22 is needed.
> 
> I don't see how we are getting this second bit of information, if we
> are explicitly using c45 over c22.

That is related to how C45 capable PHYs are probed (your 4) above),
right? If the PHY would be probed correctly as C45 we wouldn't have
to worry about it. TBH I didn't consider that a valid case because
I thought there were other means to tell "treat this PHY as C45",
that is by the device tree compatible, for example.

Btw. all of this made me question if this is actually the correct
place, or if if shouldn't be handled in the core. With a flag
in the phy driver which might indicate its capable of doing
c45 over c22.

> This _by_c22 is also making me think of the previous patch, where we
> look at the bus capabilities. We are explicitly saying here was want
> c45 over c22, and the PHY driver should know the PHY is capable of
> it. So we don't need to look at the capabilities, just do it.

Mh? I can't follow you here. Are you talking about the
probe_capabilites? These are for the bus probing, i.e. if you can
call mdiobus_c45_read().

-michael
