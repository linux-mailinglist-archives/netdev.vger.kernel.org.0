Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9C1B31CC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 23:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDUVTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 17:19:51 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50209 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgDUVTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 17:19:51 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5FB1D22FE3;
        Tue, 21 Apr 2020 23:19:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587503988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJCmpPlfT0jhbjpmDTIcPC9jUtk8NLpD0FJUCgCWl8A=;
        b=ryGczwr6UFQ8WNhssB2ni/EeoyeMhz84YBfkDZFS6uJ2mr2YStuCiC5QJXJAwlRQW4V6X6
        JeaDrQquXCVtLVY27Ks9UYXYhLq9uwfyU+f618OuFoY0XpFe3AlOC54iD6s9rHl3YPVg5/
        IpCUoAuTa6nO8vLt3H3N5kbTOfjAhNQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 23:19:48 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
In-Reply-To: <20200421193055.GI933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
 <20200421155031.GE933345@lunn.ch>
 <47bdeaf298a09f20ad6631db13df37d2@walle.cc>
 <20200421193055.GI933345@lunn.ch>
Message-ID: <a3add59040db907be22d7299d0896c5d@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 5FB1D22FE3
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.948];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,armlinux.org.uk,davemloft.net,nxp.com];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-21 21:30, schrieb Andrew Lunn:
>> Speaking of it. Does anyone have an idea how I could create the hwmon
>> device without the PHY device? At the moment it is attached to the
>> first PHY device and is removed when the PHY is removed, although
>> there might be still other PHYs in this package. Its unlikely to
>> happen though, but if someone has a good idea how to handle that,
>> I'd give it a try.
> 
> There is a somewhat similar problem with Marvell Ethernet switches and
> their internal PHYs. The PHYs are the same as the discrete PHYs, and
> the usual Marvell PHY driver is used. But there is only one
> temperature sensor for the whole switch, and it is mapped into all the
> PHYs. So we end up creating multiple hwmon devices for the one
> temperature sensor, one per PHY.
> 
> You could take the same approach here. Each PHY exposes a hwmon
> device?
> 
> Looking at
> static struct device *
> __hwmon_device_register(struct device *dev, const char *name, void 
> *drvdata,
>                         const struct hwmon_chip_info *chip,
>                         const struct attribute_group **groups)
> 
> I think it is O.K. to pass dev as NULL. You don't have to associate it
> to a device. So you could create the hwmon device as part of package
> initialisation and put it into shared->priv.

I actually tried that before writing my mail. Have a look at commit
59df4f4e8e0b ("hwmon: (core) check parent dev != NULL when chip != 
NULL")

and the corresponding discussion here:
   https://patchwork.kernel.org/patch/10381759/

And if I'd had to choose, I'd prefer having one hwmon device on the
first PHY (with its drawback) rather than having it four times.

-michael
