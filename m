Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036201AE71E
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDQVEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 17:04:24 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:53495 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgDQVEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 17:04:24 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3010723058;
        Fri, 17 Apr 2020 23:04:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587157461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/PN16jFZd/i+9d/mGAxYl50fVRiGccVhJ4spDDgVjQ=;
        b=j6MnWxfue0MNQjUs8iKR91s6Ynf5MNFyFOmD27vkRN28tMCVaM96jvPZJ7+7SKMfI93iYb
        pIHXNxfjr6MZq0K9Fi7kb4EVU3ZZ+/jv76wzGp/Sv22rsCbZQaKW/45vrkX/vBZHB83Z3w
        tkYGSfwKKx7BL7TKvfnW+O7GKJsBiBw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 17 Apr 2020 23:04:21 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-hwmon@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: phy: add Broadcom BCM54140 support
In-Reply-To: <CA+h21hoB5n9DM0kcH_-DOzyxXvs5oMg-wxp-KkNTZOpfFhbWVA@mail.gmail.com>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-2-michael@walle.cc> <20200417193905.GF785713@lunn.ch>
 <ef747b543bd8dd34aea89a6243de8da4@walle.cc>
 <CA+h21hoB5n9DM0kcH_-DOzyxXvs5oMg-wxp-KkNTZOpfFhbWVA@mail.gmail.com>
Message-ID: <8e11a4792db1312b402d37a6a612cf8c@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 3010723058
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         NEURAL_HAM(-0.00)[-0.239];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,vger.kernel.org,suse.com,roeck-us.net,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am 2020-04-17 22:00, schrieb Vladimir Oltean:
> Hi Michael,
> 
> On Fri, 17 Apr 2020 at 22:52, Michael Walle <michael@walle.cc> wrote:
>> 
>> Hi Andrew,
>> 
>> Am 2020-04-17 21:39, schrieb Andrew Lunn:
>> > On Fri, Apr 17, 2020 at 09:28:57PM +0200, Michael Walle wrote:
>> >
>> >> +static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
>> >> +{
>> >> +    struct bcm54140_phy_priv *priv = phydev->priv;
>> >> +    struct mii_bus *bus = phydev->mdio.bus;
>> >> +    int addr, min_addr, max_addr;
>> >> +    int step = 1;
>> >> +    u32 phy_id;
>> >> +    int tmp;
>> >> +
>> >> +    min_addr = phydev->mdio.addr;
>> >> +    max_addr = phydev->mdio.addr;
>> >> +    addr = phydev->mdio.addr;
>> >> +
>> >> +    /* We scan forward and backwards and look for PHYs which have the
>> >> +     * same phy_id like we do. Step 1 will scan forward, step 2
>> >> +     * backwards. Once we are finished, we have a min_addr and
>> >> +     * max_addr which resembles the range of PHY addresses of the same
>> >> +     * type of PHY. There is one caveat; there may be many PHYs of
>> >> +     * the same type, but we know that each PHY takes exactly 4
>> >> +     * consecutive addresses. Therefore we can deduce our offset
>> >> +     * to the base address of this quad PHY.
>> >> +     */
>> >
>> > Hi Michael
>> >
>> > How much flexibility is there in setting the base address using
>> > strapping etc? Is it limited to a multiple of 4?
>> 
>> You can just set the base address to any address. Then the following
>> addresses are used:
>>    base, base + 1, base + 2, base + 3, (base + 4)*
>> 
>> It is not specified what happens if you set the base so that it would
>> overflow. I guess that is a invalid strapping.
>> 
>> * (base + 4) is some kind of special PHY address which maps some kind
>> of moving window to a QSGMII address space. It is enabled by default,
>> could be disabled in software, but it doesn't share the same PHY id
>> for which this scans.
>> 
>> So yes, if you look at the addresses and the phy ids, there are
>> always 4 of this.
>> 
>> -michael
> 
> What does the reading of the global register give you, when accessed
> through the master PHY ID vs any other PHY ID? Could you use that as
> an indication of this being the correct PHY ID, and scan only to the
> left?

That was my first try, I thought it reads zero if you access a global
register by a PHY address which is not the base one. So I've looked
at registers which have at least one read-only 1 bit in it and scanned
only backwards. Well it turns out, my assumption was wrong and it
returns an old value of a successful read/write before. So it can just
return anything. And yes, its likely that you could read another
register and then probe the global register. But in the end I preferred
scanning the (known) phy id registers over strange hacks. Broadcom
could have just added a per-port register to actually read the base
address, but well.. ;)

-michael
