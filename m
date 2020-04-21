Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B81B2B07
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgDUPUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:20:25 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:37199 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgDUPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:20:24 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CF11923059;
        Tue, 21 Apr 2020 17:20:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587482423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11Is5HZRKmOiZumdMUwNkL7ciOuq8bgi7k2YfmGDNpI=;
        b=VEkFTSh0uY4eQcKr7G1Ri0EFROHJz5Dlss5bT0wVp6+UlpFMj7EfhrU/KNDBGe3jVnJrRW
        MB+6ApsUEiALMQDfLtFaAb93h7SVgbovYkwATRjaIdEkKGmwwxKb8Hv0+9ExkqzN+SyXQ9
        TQ8FEQM7VI/6bcfrJfHCuY9g24a4JpI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 17:20:22 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
In-Reply-To: <20200421145214.GD933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <20200421143455.GB933345@lunn.ch>
 <20200421144302.GD25745@shell.armlinux.org.uk>
 <20200421145214.GD933345@lunn.ch>
Message-ID: <f297cb3c07554ef55d3040329978f8d4@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: CF11923059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.975];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[armlinux.org.uk,vger.kernel.org,gmail.com,davemloft.net,nxp.com];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-21 16:52, schrieb Andrew Lunn:
> On Tue, Apr 21, 2020 at 03:43:02PM +0100, Russell King - ARM Linux 
> admin wrote:
>> On Tue, Apr 21, 2020 at 04:34:55PM +0200, Andrew Lunn wrote:
>> > > +static inline bool phy_package_init_once(struct phy_device *phydev)
>> > > +{
>> > > +	struct phy_package_shared *shared = phydev->shared;
>> > > +
>> > > +	if (!shared)
>> > > +		return false;
>> > > +
>> > > +	return !test_and_set_bit(PHY_SHARED_F_INIT_DONE, &shared->flags);
>> > > +}
>> >
>> > I need to look at how you actually use this, but i wonder if this is
>> > sufficient. Can two PHYs probe at the same time? Could we have one PHY
>> > be busy setting up the global init, and the other thinks the global
>> > setup is complete?

So with Russells answer below, this should be clarified and the
test_and_set_bit() is enough correct?

>> > Do we want a comment like: 'Returns true when the
>> > global package initialization is either under way or complete'?

I've forgot the whole annotation here.

>> IIRC, probe locking in the driver model is by per-driver locks, so
>> any particular driver won't probe more than one device at a time.

-michael
