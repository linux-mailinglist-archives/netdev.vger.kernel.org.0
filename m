Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490463FBE9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiLAXYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiLAXYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:24:04 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A011820
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 15:24:02 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4C9B250F;
        Fri,  2 Dec 2022 00:24:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669937041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Jtnmo4I47IdTSG/Z7smZDH0I/Y+AGngT56oWJX9nXo=;
        b=SKMnUQQxsu2xDYUo6hOweLDZlZmJ9K96QrMWSAuz9zNgkv3tH/TwubWIyi9FXWV21XoT+r
        9EAn48aO6a0dcVSNeL5FpAn7Ymul/dflAN6I9sZy/nbDe3+qRqD1g8q1yMpCXhObva5XlE
        WY9lw1lhnkiRD3++xKHBsha7Jk/psofP8BFoJB1JopzvVyqa1el7vSAlL5uoe3sOPw68wN
        cnH1pm9NkX/ebnqanENT4EEAC1xoldyLqvMQQT4JBsTvHxsuVOpLBBS0taZE63Fmx/w8RX
        4OKNRWwtD4yVLTDifnjG+enR2OFiVT6I465anYeM/lbOtOSeqmzjj2HcxrAi4w==
MIME-Version: 1.0
Date:   Fri, 02 Dec 2022 00:24:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
In-Reply-To: <Y4klbgDIuxHXaWrC@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch> <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch> <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
 <Y4jOMocoLneO8xoD@lunn.ch> <158870dd20a5e30cda9f17009aa0c6c8@walle.cc>
 <Y4klbgDIuxHXaWrC@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1d186774cfa4173955c89e7262b1d1b7@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-01 23:06, schrieb Andrew Lunn:
> On Thu, Dec 01, 2022 at 10:31:19PM +0100, Michael Walle wrote:
>> Am 2022-12-01 16:54, schrieb Andrew Lunn:
>> > > So, switching the line to GPIO input doesn't help here, which also
>> > > means the interrupt line will be stuck the whole time.
>> >
>> > Sounds like they totally messed up the design somehow.
>> >
>> > Since we are into horrible hack territory.....
>> >
>> > I assume you are using the Link state change interrupt? LSTC?
>> 
>> Yes, but recently I've found it that it also happens with
>> the speed change interrupt (during link-up). By pure luck (or
>> bad luck really?) I discovered that when I reduce the MDIO
>> frequency I get a similar behavior for the interrupt line
>> at link-up with the LSPC interrupt. I don't think it has
>> something to do with the frequency but with changed timing.
> 
> So at a wild guess, there is some sort of race condition between the
> 2.5MHz ish MDIO clock and the rest of the system which is probably
> clocked at 25Mhz.
> 
> We have to hope this is limited to just interrupts! Not any MDIO bus
> transaction.
> 
>> +	/* The PHY might leave the interrupt line asserted even after 
>> PHY_ISTAT
>> +	* is read. To avoid interrupt storms, delay the interrupt handling 
>> as
>> +	* long as the PHY drives the interrupt line. An internal bus read 
>> will
>> +	* stall as long as the interrupt line is asserted, thus just read a
>> +	* random register here.
>> +	* Because we cannot access the internal bus at all while the 
>> interrupt
>> +	* is driven by the PHY, there is no way to make the interrupt line
>> +	* unstuck (e.g. by changing the pinmux to GPIO input) during that 
>> time
>> +	* frame. Therefore, polling is the best we can do and won't do any 
>> more
>> +	* harm.
>> +	* It was observed that this bug happens on link state and link speed
>> +	* changes on a GPY215B and GYP215C independent of the firmware 
>> version
>> +	* (which doesn't mean that this list is exhaustive).
>> +	*/
>> +	if (needs_mdint_wa && (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC)))
>> +		gpy_mbox_read(phydev, REG_GPIO0_OUT);
>> +
>>  	phy_trigger_machine(phydev);
>> 
>>  	return IRQ_HANDLED;
> 
> So this delayed exiting the interrupt handler until the line actually
> return to normal. And during that time, the interrupt is disabled. And
> hence the storm is avoided.

Exactly. Almost like your idea with polling the interrupt line
in GPIO mode.

> I'm assuming gpy_mbox_read() has a timeout, so if the PHY completely
> jams, it does exit? If that happens, maybe call phy_error() to
> indicate the PHY is dead. And don't return IRQ_HANDLED, but
> IRQ_NONE. I think the IRQ core should notice the storm for an
> interrupt which nobody cares about and disable the interrupt.
> Probably not much you can do after that, but at least the machine
> won't be totally dead.

Ah, yes. In the earlier code (that changed the pin to GPIO input),
I had that error handling. Missed that here, I'll add it.
And yes, there is an timeout of 10ms.

>> It seems like at least these two are :/ So with the code above
>> we could avoid the interrupt storm but we can't do anything about
>> the blocked interrupt line. I'm unsure if that is acceptable or
>> if we'd have to disable interrupts on this PHY altogether and
>> fallback to polling.
> 
> It probably depends on your system design. If this is the only PHY and
> the storm can be avoided, it is probably O.K. If you have other PHYs
> sharing the line, and those PHYs are doing time sensitive stuff like
> PTP, maybe polling would be better.
> 
> Maybe add a kconfig symbol CONFIG_MAXLINEAR_GPHY_BROKEN_INTERRUPTS and
> make all the interrupt code conditional on this? Hopefully distros
> won't enable it, but the option is there to buy into the behaviour if
> you want?

I don't even dare to ask, but wouldn't a device tree property
maxlinear,use-broken-interrupts make more sense than a compile time
option? I'm fine with both.

-michael
