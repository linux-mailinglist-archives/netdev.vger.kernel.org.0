Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607D431ADD5
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBMT6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:58:30 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:59725 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBMT6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:58:30 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9FF6F23E55;
        Sat, 13 Feb 2021 20:57:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613246267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNOfLV620QyHNix5X1chlue7rRNMtyaVvnvoquF1moU=;
        b=apfLyT8e4v4r8BY3BEr7xg2gKttGFR6brN6ikOOEgISeJpfJkLQ02CxcZQu6IZjImPqgs4
        TCRGtNjSHQABYrO4McTCA0wMRCtHseH3UjNJOuL2W5WTyEhaPYE9nqz6GuqJNwojUE3ZQb
        X33BxrpZucQp7rRdTB9Ahyh66SCkGw0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 13 Feb 2021 20:57:46 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
In-Reply-To: <20210213185620.3lij467kne6cm4gk@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
 <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
 <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
 <20210213185620.3lij467kne6cm4gk@skbuf>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <4b3f06686cb58dcdda582bfdbd0abb85@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-13 19:56, schrieb Vladimir Oltean:
> On Sat, Feb 13, 2021 at 06:09:13PM +0100, Michael Walle wrote:
>> Am 2021-02-13 17:53, schrieb Michael Walle:
>> > Am 2021-02-13 01:36, schrieb Vladimir Oltean:
>> > But the Atheros PHY seems to have a problem with the SGMII link
>> > if there is no autoneg.
>> > No matter what I do, I can't get any traffic though if its not
>> > gigabit on the copper side. Unfortunately, I don't have access
>> > to an oscilloscope right now to see whats going on on the SGMII
>> > link.
>> 
>> Scrap that. It will work if I set the speed/duplex mode in BMCR
>> correctly. (I tried that before, but I shifted one bit. doh).
>> 
>> So that will work, but when will it be done? There is no
>> callback to configure the PCS side of the PHY if a link up is
>> detected.
> 
> That's interesting/odd, on VSC8514 there is no need to force the speed
> of the system side to what was negotiated on media side. I took a quick
> look through the AR8033 datasheet and there isn't any mentioning the
> ability to program the SGMII link according to internal state as 
> opposed
> to register settings, but it's equally possible that I'm simply not
> seeing it.

I couldn't find anything in the AR8031 datasheet either.

> On the other hand, I never meant for the inband autoneg setting to only
> be configurable both ways.

Then why is there a "bool enabled"?

> I expect some PHYs are not able to operate
> using noinband mode, and for those I guess you should simply return
> -EINVAL, allowing the system designer to know that the configuration
> will not work and why.

You mean like this:

static int at803x_config_inband_aneg(struct phy_device *phydev, bool 
enabled)
{
	if (!enabled)
		return -EINVAL;
	/* enable SGMII autoneg */
	return phy_write_paged(...);
}

But then why bother with config_inband_aneg() at all and just enable
it unconditionally in config_init(). [and maybe keep the return 
-EINVAL].
Which then begs the question, does it makes sense on (Q)SGMII links at
all?

> I think you could hook into .config_aneg_done, for the autoneg=true
> case, and into .config_aneg for autoneg=false (I'm talking about 
> autoneg
> on media side here), but honestly I think the PHY is pretty broken for
> requiring external coordination between the clause 28 and the clause 37
> PCS. So unless there is a real need to configure noinband mode, I would
> probably not bother.

Probably not.

-michael
