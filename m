Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1661B2FCC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDUTIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:08:46 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:54821 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgDUTIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:08:46 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C17EB22723;
        Tue, 21 Apr 2020 21:08:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587496121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73o0/lLPbuNG3CEmG0vdyF6uHhA+u4rQ0S0mMdDJmPA=;
        b=PLNHhMYXQt8s5WACaP/047QMnhgp8j5FVaiDUVikAvB428loQHyNLw/hQEYD4uu/LqY4on
        Xpa2Ulf75Y5UD0cdPo6CgGLjdum2kNqmdPOIg/sB1QxXK4eYAbhZdCjQnB3ecsHg2QagJP
        imoerBWrEN89HiNL92AFPZ20WOmijDU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 21:08:40 +0200
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
In-Reply-To: <20200421155031.GE933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
 <20200421155031.GE933345@lunn.ch>
Message-ID: <47bdeaf298a09f20ad6631db13df37d2@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: C17EB22723
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.972];
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

Am 2020-04-21 17:50, schrieb Andrew Lunn:
> On Tue, Apr 21, 2020 at 05:25:19PM +0200, Michael Walle wrote:
>> Am 2020-04-21 01:26, schrieb Michael Walle:
>> > +
>> > +/* Represents a shared structure between different phydev's in the same
>> > + * package, for example a quad PHY. See phy_package_join() and
>> > + * phy_package_leave().
>> > + */
>> > +struct phy_package_shared {
>> > +	int addr;
>> > +	refcount_t refcnt;
>> > +	unsigned long flags;
>> > +
>> > +	/* private data pointer */
>> > +	/* note that this pointer is shared between different phydevs and
>> > +	 * the user has to take care of appropriate locking.
>> > +	 */
>> > +	void *priv;
>> 
>> btw. how should a driver actually use this? I mean, it can allocate
>> memory if its still NULL but when will it be freed again. Do we need
>> a callback? Is there something better than a callback?
> 
> Good point. phy_package_join() should take a size_t and do the
> allocation. phy_package_leave() would then free it.
> 
> But since we don't have a user at the moment, maybe leave it out.

Speaking of it. Does anyone have an idea how I could create the hwmon
device without the PHY device? At the moment it is attached to the
first PHY device and is removed when the PHY is removed, although
there might be still other PHYs in this package. Its unlikely to
happen though, but if someone has a good idea how to handle that,
I'd give it a try.

-michael
