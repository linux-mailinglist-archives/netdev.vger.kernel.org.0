Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0928F38F7D8
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhEYCFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:05:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEYCFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 22:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g8xlnZg8Jx1EpR1gdv4PlknglCwEvlw9U1PHrDmqOwM=; b=k+mE3gv6OzMdVv5ETedr4SNnxD
        rRAOJ4vfdymggeiI6ZB/5Ju0mOJieEH3s1PLNf1h+SmhRSXzsq+QNAESWG8J1kIeEenhjPdiGwicK
        r9b46LvJSNeohxTpX10Hz11LRUxvZq9lh7pAzafhoZidNWsXR6T9A3UtfrcV7au7cSjU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llMQ8-0064KR-05; Tue, 25 May 2021 04:03:48 +0200
Date:   Tue, 25 May 2021 04:03:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 00/13] Add NXP SJA1110 support to the sja1105
 DSA driver
Message-ID: <YKxbA86Ci0Ll7RjE@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There are some integrated NXP PHYs (100base-T1 and 100base-TX). Their
> initialization is handled by their own PHY drivers, the switch is only
> concerned with enabling register accesses to them, by registering two
> MDIO buses.
> 
> PHY interrupts might be possible, however I believe that the board I am
> working on does not have them wired, which makes things a bit more
> difficult to test.

In general, internal PHYs have an internal interrupt controller, often
in the switch register space. There then might be one interrupt from
the switch to the host. It could be this one interrupt is missing on
your board. But this is also quite common with mv88e6xxx boards. So i
added code to poll the interrupt bit, i think 10 times per
second. Polling one bit 10 times a second is more efficient than
having phylib poll each PHY every second when it needs to read a
number of registers. And the latency is better.

       Andrew
