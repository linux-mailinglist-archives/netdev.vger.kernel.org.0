Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14D546C799
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbhLGWlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:41:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhLGWlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:41:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KL7t3EzMOJg7Y8VdK8+7cVEQezPhxkNeMva2hDQV8gI=; b=ahFFO/P5JyoTmj2MDU6qu85ZOB
        FNPq3kmvh9O8tAfjF3j3jGABnIuiwYVU8COGAWSpXSl82uu2w3ur6V6jFUo9dWPsYsqyaRoRfNee7
        d0KJC7NPMCR/tUXMVyI6WyLRgHkrx+U+R6t3mPVfazsCMPVp4u5DahHRc/S+YIBPYkFY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muj5w-00Forc-Gc; Tue, 07 Dec 2021 23:37:56 +0100
Date:   Tue, 7 Dec 2021 23:37:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya/iRAAN8OXC57Ph@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
 <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
 <20211207211018.cljhqkjyyychisl5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207211018.cljhqkjyyychisl5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This raises interesting questions. I see two distinct cases:
> 
> 1. "dual I/O": the switch probes initially over a standard bus (MDIO,
>    SPI, I2C) then at some point transitions towards I/O through the
>    tagger.  This would be the case when there is some preparation work
>    to be done (maybe the CPU port needs to be brought up, maybe there is
>    a firmware to be uploaded to the switch's embedded microcontroller
>    such that the expected remote management protocol is supported, etc).
>    It would also be the case when multiple CPU ports are supported (and
>    changing between CPU ports), because we could end up bringing a
>    certain CPU port down, and the register I/O would need to be
>    temporarily done over MDIO before bringing the other CPU port up.

mv88e6xxx is very likely to take this path. You need to program some
registers to enable RMU. It is possible to enable this via EEPROM
configuration, but i've never seen any hardware with the necessary
EEPROM configuration. And you have the old chicken/egg, in order to be
able to program the EEPROM, you need access to the switch, or a header
and a cable.

> 2. "single I/O": the switch needs no such configuration, and in this
>     case, it could in principle probe over an "Ethernet bus" rather than
>     a standard bus as mentioned above.
> 
> I don't know which case is going to be more common, honestly.

Given the history, i think MDIO startup, and then transition to
Ethernet is going to be a lot more common.  If there was a lot of
hardware out there which could do Ethernet from the beginning, we
would of had patches or at least requests for it by now. 

I would keep it KISS.

      Andrew
