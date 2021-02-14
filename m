Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF031B287
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 21:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBNUtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 15:49:43 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37363 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhBNUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 15:49:41 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 245C623E55;
        Sun, 14 Feb 2021 21:48:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613335734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4EvxVK/9O9RvKC8BdWgGppQqCSSsdcDZvffgw37T44I=;
        b=XdWc502Y3EaDmJZd0FF9GP85MiznN15e0ilPt/ffop+geGfFLF1xjTrN7Bv6V7IkCRoM+Q
        4xBDQtTe4t3IzNchvw1n15RNql25/nD9ioph2AJYgRNdh4JypKH5yKzyzF+yMJeFyaKjm6
        k3ahaF2HYHgNoW7tRlxqgZuTo+1gxJ4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 14 Feb 2021 21:48:53 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phy: at803x: use proper locking in
 at803x_aneg_done()
In-Reply-To: <20210214022439.cyrfud4ahj4fzk7e@skbuf>
References: <20210214010405.32019-1-michael@walle.cc>
 <20210214010405.32019-3-michael@walle.cc>
 <20210214015733.tfodqglq4djj2h44@skbuf>
 <4ABD9AA0-94A3-4417-B6B2-996D193FB670@walle.cc>
 <20210214022439.cyrfud4ahj4fzk7e@skbuf>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <758cac1a76541e0e419a54af14d0cd20@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-14 03:24, schrieb Vladimir Oltean:
> On Sun, Feb 14, 2021 at 03:18:49AM +0100, Michael Walle wrote:
>> Am 14. Februar 2021 02:57:33 MEZ schrieb Vladimir Oltean 
>> <olteanv@gmail.com>:
>> >Hi Michael,
>> >
>> >On Sun, Feb 14, 2021 at 02:04:05AM +0100, Michael Walle wrote:
>> >> at803x_aneg_done() checks if auto-negotiation is completed on the
>> >SGMII
>> >> side. This doesn't take the mdio bus lock and the page switching is
>> >> open-coded. Now that we have proper page support, just use
>> >> phy_read_paged(). Also use phydev->interface to check if we have an
>> >> SGMII link instead of reading the mode register and be a bit more
>> >> precise on the warning message.
>> >>
>> >> Signed-off-by: Michael Walle <michael@walle.cc>
>> >> ---
>> >
>> >How did you test this patch?
>> 
>> I'm afraid it's just compile time tested.
> 
> I'm asking because at803x_aneg_done has been dead code for more than 2
> years now. Unreachable. And while it was reachable it was buggy and an
> abuse of the phylib API. So you might want to just delete this function
> instead. Context:
> https://lkml.org/lkml/2020/5/30/375

Are you sure? While it isn't called from phylib, it might be called from
some drivers directly or indirectly if they use phy_speed_down(). But
it is questionable if this is much of a use then.

That being said, if no one objects, I'd remove it, too.

-michael
