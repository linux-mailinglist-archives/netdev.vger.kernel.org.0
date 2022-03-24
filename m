Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53E34E679F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350786AbiCXRT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 13:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345269AbiCXRTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 13:19:55 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ADFDF56;
        Thu, 24 Mar 2022 10:18:17 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0C3F22222E;
        Thu, 24 Mar 2022 18:18:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648142295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mW5UfH8Ylkm3/jigdRwLAUC6EVlLm7SjaltxrCgFE7g=;
        b=CkHlieX6xNiThKeWq282t7PUgDhAZ97n/a0kKkZsS3QLnrE1+q/L10hZGvj8UscSyBNNM7
        xPJekUK9hwPYqxtZLw4FfrUrByxiiH+3IJcDA3JufWFv6aFEOGmiZcRTHg9yp93g/gIBkg
        8uOFHdsnA1sZv86gtjXgH3TuYJ14+iU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Mar 2022 18:18:14 +0100
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
In-Reply-To: <YjybB/fseibDU4dT@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc> <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc> <Yju+SGuZ9aB52ARi@lunn.ch>
 <30012bd8256be3be9977bd15d1486c84@walle.cc> <YjybB/fseibDU4dT@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
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

Am 2022-03-24 17:23, schrieb Andrew Lunn:
>> > To some extent, we need to separate finding the device on the bus to
>> > actually using the device. The device might respond to C22, give us
>> > its ID, get the correct driver loaded based on that ID, and the driver
>> > then uses the C45 address space to actually configure the PHY.
>> >
>> > Then there is the Marvel 10G PHY. It responds to C22, but returns 0
>> > for the ID! There is a special case for this in the code, it then
>> > looks in the C45 space and uses the ID from there, if it finds
>> > something useful.
>> >
>> > So as i said in my reply to the cover letter, we have two different
>> > state variables:
>> >
>> > 1) The PHY has the C45 register space.
>> >
>> > 2) We need to either use C45 transfers, or C45 over C22 transfers to
>> >    access the C45 register space.
>> >
>> > And we potentially have a chicken/egg problem. The PHY driver knows
>> > 1), but in order to know what driver to load we need the ID registers
>> > from the PHY, or some external hint like DT. We are also currently
>> > only probing C22, or C45, but not C45 over C22. And i'm not sure we
>> > actually can probe C45 over C22 because there are C22 only PHYs which
>> > use those two register for other things. So we are back to the driver
>> > again which does know if C45 over C22 will work.
>> 
>> Isn't it safe to assume that if a PHY implements the indirect
>> registers for c45 in its c22 space that it will also have a valid
>> PHY ID and then the it's driver will be probed?
> 
> See:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L895
> 
> No valid ID in C22 space.

I actually looked at the datasheet and yes, it implements the
registers 13 and 14 in c22 to access the c45 space. I couldn't
find any descriptions of other c22 registers though.

>> So if a PHY is
>> probed as c22 its driver might tell us "wait, it's actually a c45
>> phy and hey for your convenience it also have the indirect registers
>> in c22". We can then set has_c45 and maybe c45_over_c22 (also 
>> depending
>> on the bus capabilities).
> 
> In general, if the core can do something, it is better than the driver
> doing it. If the core cannot reliably figure it out, then we have to
> leave it to the drivers. It could well be we need the drivers to set
> has_c45. I would prefer that drivers don't touch c45_over_c22 because
> they don't have the knowledge of what the bus is capable of doing. The
> only valid case i can think of is for a very oddball PHY which has C45
> register space, but cannot actually do C45 transfers, and so C45 over
> C22 is the only option.

And how would you know that the PHY has the needed registers in c22
space? Or do we assume that every C45 PHY has these registers?

..

>> > phydev->c45_over_c22 we are currently in a bad shape for. We cannot
>> > reliably say the bus master supports C45. If the bus capabilities say
>> > C22 only, we can set phydev->c45_over_c22. If the bus capabilities
>> > list C45, we can set it false. But that only covers a few busses, most
>> > don't have any capabilities set. We can try a C45 access and see if we
>> > get an -EOPNOTSUPP, in which case we can set phydev->c45_over_c22. But
>> > the bus driver could also do the wrong thing, issue a C22 transfer and
>> > give us back rubbish.
>> 
>> First question, what do you think about keeping the is_c45 property 
>> but
>> with a different meaning and add use_c45_over_c22. That way it will be
>> less code churn:
>> 
>>  * @is_c45:  Set to true if this PHY has clause 45 address space.
>>  * @use_c45_over_c22:  Set to true if c45-over-c22 addressing is used.
> 
> I prefer to change is_c45. We then get the compiler to help us with
> code review. The build bots will tell us about any code we fail to
> check and change. It will also help anybody with out of tree code
> making use of is_c45.

Ok. Fair enough.

-michael
