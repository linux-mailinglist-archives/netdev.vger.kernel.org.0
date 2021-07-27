Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F043D6BA6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 03:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhG0BRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 21:17:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhG0BRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 21:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HMgJV3uvT/ccXgXUndUBzgjHpSF3q66T70QHV1OP8Po=; b=3MfQ7sVIZ9ABcm1rZUJXDAOPnh
        Z43SVdviFaDETNTo9/eYjtVOulvrFrt01OgBt7cqN/Ma1vw5kaHKU1KyAE5wgaLR29ztSF1nOSN5a
        O7FZ3jlhEOeMSB85yl/jHIuPxJDXRWpCjPBn9tAwS6qbv6ZbmlItSMjNPg8aAknen8VI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8CLJ-00Ex3M-Ej; Tue, 27 Jul 2021 03:57:13 +0200
Date:   Tue, 27 Jul 2021 03:57:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YP9n+VKcRDIvypes@lunn.ch>
References: <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad>
 <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
 <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
 <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
 <20210727020619.2ba78163@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727020619.2ba78163@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The last time we discussed this (Andrew, Pavel and I), we've decided
> that for ethernet PHY controlled LEDs we want the devicename part
> should be something like
>    phyN  or  ethphyN  or  ethernet-phyN
> with N a number unique for every PHY (a simple atomically increased
> integer for every ethernet PHY).

We might want to rethink this. PHYs typically have 2 or 3 LEDs. So we
want a way to indicate which LED of a PHY it is. So i suspect we will
want something like

ethphyN-led0, ethphyN-led1, ethphyN-led2.

I would also suggest N starts at 42, in order to make it clear it is a
made up arbitrary number, it has no meaning other than it is
unique. What we don't want is people thinking ethphy0-led0 has
anything to do with eth0.

> I confess that I am growing a little frustrated here, because there
> seems to be no optimal solution with given constraints and no official
> consensus for a suboptimal yet acceptable solution.

I do think it is clear that the base name is mostly irrelevant and not
going to be used in any meaningful way. You are unlikely to access
these LEDs via /sys/class/leds. You are going to go into
/sys/class/net/<ifname> and then either follow the device symlink, or
the phydev symlink and look for LEDs there. And then only the -ledM
part of the name might be useful. Since the name is mostly
meaningless, we should just decide and move on.

     Andrew
