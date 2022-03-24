Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79B4E6695
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351471AbiCXQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243557AbiCXQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:04:37 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE973AA;
        Thu, 24 Mar 2022 09:03:03 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6F6FF2222E;
        Thu, 24 Mar 2022 17:03:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648137781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOeoWOP9P8ui80SyFUlad9ju5LUWsfcnsPplOFlDO70=;
        b=EeKxMp06ZQk8ui1RpJzLu7AJ8sC9SP8bJawlTrirSxK7N4gPhe+cvKGGPvrx11fj8j0fiz
        i8I5Y6C7jeOAYZ+NWFSwM96K9gEBFT+0WCuO1y6T2aRH6L3xuA7mqiNhGhX7EqVba63aJ4
        h925PIv4NCf3XOdylWO1/ktUHnhU/y8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Mar 2022 17:03:00 +0100
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
In-Reply-To: <Yju+SGuZ9aB52ARi@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc> <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc> <Yju+SGuZ9aB52ARi@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <30012bd8256be3be9977bd15d1486c84@walle.cc>
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

Am 2022-03-24 01:41, schrieb Andrew Lunn:
>> > Thinking out loud...
>> >
>> > 1) We have a C22 only bus. Easy, C45 over C22 should be used.
>> >
>> > 2) We have a C45 only bus. Easy, C45 should be used, and it will of
>> >    probed that way.
>> >
>> > 3) We have a C22 and C45 bus, but MDIOBUS_NO_CAP. It will probe C22,
>> >    but ideally we want to swap to C45.
>> >
>> > 4) We have a C22 and C45 bus, MDIOBUS_C22_C45. It will probe C22, but
>> >    ideally we want to swap to C45.
>> 
>> I presume you are speaking of
>> https://elixir.bootlin.com/linux/v5.17/source/drivers/net/phy/mdio_bus.c#L700
> 
> Yes.
> 
>> Shouldn't that be the other way around then? How would you tell if
>> you can do C45?
> 
> For a long time, only C22 was probed. To actually make use of a C45
> only PHY, you had to have a compatible string in DT which indicated a
> C45 device is present on the bus. But then none DT systems came along
> which needed to find a C45 only PHY during probe without the hint it
> is was actually there. That is when the probe capabilities we added,
> and the scan extended to look for a C45 device if the capabilities
> indicates the bus actually supported it. But to keep backwards
> compatibility, C22 was scanned first and then C45 afterwards.

Ok, I figured.

> To some extent, we need to separate finding the device on the bus to
> actually using the device. The device might respond to C22, give us
> its ID, get the correct driver loaded based on that ID, and the driver
> then uses the C45 address space to actually configure the PHY.
> 
> Then there is the Marvel 10G PHY. It responds to C22, but returns 0
> for the ID! There is a special case for this in the code, it then
> looks in the C45 space and uses the ID from there, if it finds
> something useful.
> 
> So as i said in my reply to the cover letter, we have two different
> state variables:
> 
> 1) The PHY has the C45 register space.
> 
> 2) We need to either use C45 transfers, or C45 over C22 transfers to
>    access the C45 register space.
> 
> And we potentially have a chicken/egg problem. The PHY driver knows
> 1), but in order to know what driver to load we need the ID registers
> from the PHY, or some external hint like DT. We are also currently
> only probing C22, or C45, but not C45 over C22. And i'm not sure we
> actually can probe C45 over C22 because there are C22 only PHYs which
> use those two register for other things. So we are back to the driver
> again which does know if C45 over C22 will work.

Isn't it safe to assume that if a PHY implements the indirect
registers for c45 in its c22 space that it will also have a valid
PHY ID and then the it's driver will be probed? So if a PHY is
probed as c22 its driver might tell us "wait, it's actually a c45
phy and hey for your convenience it also have the indirect registers
in c22". We can then set has_c45 and maybe c45_over_c22 (also depending
on the bus capabilities).

> So phydev->has_c45 we can provisionally set if we probed the PHY by
> C45. But the driver should also set it if it knows better, or even the
> core can set it the first time the driver uses an _mmd API call.

I'm not sure about the _mmd calls, there are PHYs which have MMDs
(I guess EEE is an example?) but are not capable of C45 accesses.

> phydev->c45_over_c22 we are currently in a bad shape for. We cannot
> reliably say the bus master supports C45. If the bus capabilities say
> C22 only, we can set phydev->c45_over_c22. If the bus capabilities
> list C45, we can set it false. But that only covers a few busses, most
> don't have any capabilities set. We can try a C45 access and see if we
> get an -EOPNOTSUPP, in which case we can set phydev->c45_over_c22. But
> the bus driver could also do the wrong thing, issue a C22 transfer and
> give us back rubbish.

First question, what do you think about keeping the is_c45 property but
with a different meaning and add use_c45_over_c22. That way it will be
less code churn:

  * @is_c45:  Set to true if this PHY has clause 45 address space.
  * @use_c45_over_c22:  Set to true if c45-over-c22 addressing is used.

  1) c45 phy probed as c45 -> is_c45 = 1, like it is at the moment
     use c45 transfers
2a) c45 phy probed as c22 -> is_c45 = 1, use_c45_over_c22 = 0
     use c45 transfers
2b) c45 phy probed as c22 -> is_c45 = 1, use_c45_over_c22 = 1
     use c22 transfers

Did I miss something?

To promote from c22 to c45 we could look at a flag in the PHY
driver. That should be basically that what the gpy driver is trying
to do with the "if (!is_c45) get_c45_ids()" (but fail).

> So i think we do need to review all the bus drivers and any which do
> support C45 need their capabilities set to indicate that. We can then
> set phydev->c45_over_c22.

I could add the probe_capabilites, or at least I could try. But it won't
tell us if the PHY is capable of the indirect addressing. So we aren't
much further in this regard. But IMHO this can be done incrementally
if someone is interested in having that feature. He should also be in
the position to test it properly.

[just saw your latest mail while writing this, so half of it is done
anyway, btw, I did the same today ;)]

-michael
