Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A181AFC41
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgDSQ5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbgDSQ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:57:00 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F4FC061A0C;
        Sun, 19 Apr 2020 09:56:59 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 25FEC23059;
        Sun, 19 Apr 2020 18:56:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587315418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/XyGS8Ih2jliMK5tWK4NrlSo2vV1w+fYZEjP9GEbFHQ=;
        b=VL8lHcY891HUtQsplwCdu2HO0oAmA8YZ+BzC7x4Va83HsABuf8gAgtHnOU7B4Ntd+hFHIT
        xH6Pfb/wiP5NHafpYNVgy/eqVUFmYRq1pKrAkW8RYrOfXdgEM9HFGxCobbAcew5TX59qWA
        jBhDFKZ7wFCS9NU/GTos+TuQxqVJ0nI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 18:56:58 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 2/3] net: phy: add Broadcom BCM54140 support
In-Reply-To: <20200419164958.GN836632@lunn.ch>
References: <20200419101249.28991-1-michael@walle.cc>
 <20200419101249.28991-2-michael@walle.cc> <20200419154943.GJ836632@lunn.ch>
 <d40eafc5ed95b62886e10159dcb7a509@walle.cc>
 <20200419164958.GN836632@lunn.ch>
Message-ID: <8478a8bb5542f8e40fa17a003893f08d@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 25FEC23059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.977];
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

Am 2020-04-19 18:49, schrieb Andrew Lunn:
> On Sun, Apr 19, 2020 at 06:33:40PM +0200, Michael Walle wrote:
>> >
>> > > +
>> > > +	return 0;
>> > > +}
>> > > +
>> > > +static int bcm54140_config_init(struct phy_device *phydev)
>> > > +{
>> > > +	u16 reg = 0xffff;
>> > > +	int ret;
>> > > +
>> > > +	/* Apply hardware errata */
>> > > +	ret = bcm54140_b0_workaround(phydev);
>> > > +	if (ret)
>> > > +		return ret;
>> > > +
>> > > +	/* Unmask events we are interested in. */
>> > > +	reg &= ~(BCM54140_RDB_INT_DUPLEX |
>> > > +		 BCM54140_RDB_INT_SPEED |
>> > > +		 BCM54140_RDB_INT_LINK);
>> > > +	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_IMR, reg);
>> > > +	if (ret)
>> > > +		return ret;
>> > > +
>> > > +	/* LED1=LINKSPD[1], LED2=LINKSPD[2], LED3=ACTIVITY */
>> > > +	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE1,
>> > > +				 0, BCM54140_RDB_SPARE1_LSLM);
>> > > +	if (ret)
>> > > +		return ret;
>> >
>> > What are the reset default for LEDs? Can the LEDs be configured via
>> > strapping pins? There is currently no good solution for this. Whatever
>> > you pick will be wrong for somebody else. At minimum, strapping pins,
>> > if they exist, should not be overridden.
>> 
>> Fair enough. There are no strapping options, just the "default 
>> behaviour",
>> where LED1/2 indicates the speed, and LED3 just activity (no link
>> indication). And I just noticed that in this case the comment above is
>> wrong, because it is actually link/activity. Further, there are myriad
>> configuration options which I didn't want to encode altogether. So 
>> I've
>> just chosen the typical one (which actually matches our hardware), ie.
>> to have the "activity/led mode". The application note mentions some 
>> other
>> concrete modes, but I don't know if its worth implementing them. Maybe 
>> we
>> can have a enumeration of some distinct modes? Ie.
>> 
>>    broadcom,led-mode = <BCM54140_NO_CHANGE>;
>>    broadcom,led-mode = <BCM54140_ACT_LINK_MODE>;
> 
> Configuring LEDs is a mess at the moment. No two PHYs do it the
> same. For a long time i've had a TODO item to make PHY LEDs work just
> like every other LED in linux, and you can set trigger actions which
> are then implemented in hardware.
> 
> We have been pushing back on adding DT properties, it just makes the
> problem worse. If reset defaults are good enough for you, please leave
> it at that.

Unfortunately not. We need the link/act, which I presume will also be
used by most other users, thus the driver enables this setting. I don't
know any board which just have an activity led, that is just off and
blinks for a short time if there is RX or TX, which is the reset default
setting of this PHY.

-michael
