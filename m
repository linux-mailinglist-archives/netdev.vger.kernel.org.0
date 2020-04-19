Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27F61AFC0B
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgDSQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:33:45 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45961 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSQdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:33:44 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 08BB623059;
        Sun, 19 Apr 2020 18:33:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587314021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GOoSj1TRldaELJCcK0WvJBnRq5xMTAY5xTbPGB0XFg0=;
        b=LiSsTXxDyTSj03EI1sfwUgKdbTS37ytdAECdoWVUgPO//wQY8CGc1hClnTFfJ1uK7+Enix
        u6h/6Nt5C+bxVYqPmw34W+e1Py672L62KhEiNVzsekwBLWHf/wklcFR4vZrvDKR965sQ7C
        /G3N4+Ep94zpwWSpNnYP1ja6S4bq3k0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 18:33:40 +0200
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
In-Reply-To: <20200419154943.GJ836632@lunn.ch>
References: <20200419101249.28991-1-michael@walle.cc>
 <20200419101249.28991-2-michael@walle.cc> <20200419154943.GJ836632@lunn.ch>
Message-ID: <d40eafc5ed95b62886e10159dcb7a509@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 08BB623059
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

Am 2020-04-19 17:49, schrieb Andrew Lunn:
> On Sun, Apr 19, 2020 at 12:12:48PM +0200, Michael Walle wrote:
> 
> Hi Michael
> 
>> +static int bcm54140_b0_workaround(struct phy_device *phydev)
>> +{
>> +	int spare3;
>> +	int ret;
> 
> Could you add a comment about what this is working around?

sure

> 
>> +static int bcm54140_phy_probe(struct phy_device *phydev)
>> +{
>> +	struct bcm54140_phy_priv *priv;
>> +	int ret;
>> +
>> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	phydev->priv = priv;
>> +
>> +	ret = bcm54140_get_base_addr_and_port(phydev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	dev_info(&phydev->mdio.dev,
>> +		 "probed (port %d, base PHY address %d)\n",
>> +		 priv->port, priv->base_addr);
> 
> phydev_dbg() ? Do we need to see this message four times?

ok. every phy will have a different port. And keep in mind,
that you might have less than four ports/PHYs here. So I'd
like to keep that as a phydev_dbg() if you agree.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int bcm54140_config_init(struct phy_device *phydev)
>> +{
>> +	u16 reg = 0xffff;
>> +	int ret;
>> +
>> +	/* Apply hardware errata */
>> +	ret = bcm54140_b0_workaround(phydev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Unmask events we are interested in. */
>> +	reg &= ~(BCM54140_RDB_INT_DUPLEX |
>> +		 BCM54140_RDB_INT_SPEED |
>> +		 BCM54140_RDB_INT_LINK);
>> +	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_IMR, reg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* LED1=LINKSPD[1], LED2=LINKSPD[2], LED3=ACTIVITY */
>> +	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE1,
>> +				 0, BCM54140_RDB_SPARE1_LSLM);
>> +	if (ret)
>> +		return ret;
> 
> What are the reset default for LEDs? Can the LEDs be configured via
> strapping pins? There is currently no good solution for this. Whatever
> you pick will be wrong for somebody else. At minimum, strapping pins,
> if they exist, should not be overridden.

Fair enough. There are no strapping options, just the "default 
behaviour",
where LED1/2 indicates the speed, and LED3 just activity (no link
indication). And I just noticed that in this case the comment above is
wrong, because it is actually link/activity. Further, there are myriad
configuration options which I didn't want to encode altogether. So I've
just chosen the typical one (which actually matches our hardware), ie.
to have the "activity/led mode". The application note mentions some 
other
concrete modes, but I don't know if its worth implementing them. Maybe 
we
can have a enumeration of some distinct modes? Ie.

    broadcom,led-mode = <BCM54140_NO_CHANGE>;
    broadcom,led-mode = <BCM54140_ACT_LINK_MODE>;

-michael
