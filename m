Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE67F41DBCB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351642AbhI3OC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:02:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351630AbhI3OCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 10:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GqfIQMoOfvYuD6pFZH47BEA82MZMbwCc2wxffNr631k=; b=DqG3RCLA4PmCZb8wRSE56KUqb5
        GpG5tzQjKiJKwKG+NmKP0uD/PpN3TIHtYdxXZy7TSoK0GfZotKPiPWXGj6AVRty+1jgm1fb0/GHXL
        YETdopjEfvdjghnxucTDs9RdBHikKwa4aBrdX7HGl7EZZBAGybSD0k2sC2+1NdvAu7WQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVwbx-008xOn-DF; Thu, 30 Sep 2021 16:00:33 +0200
Date:   Thu, 30 Sep 2021 16:00:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YVXDAQc6RMvDjjFu@lunn.ch>
References: <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
 <20210930134343.ztq3hgianm34dvqb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930134343.ztq3hgianm34dvqb@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew is testing with arch/arm/boot/dts/vf610-zii-dev-rev-b.dts.
> 
> Graphically it looks like this:

Nice ASCII art :-)

This shows the flow of Ethernet frames thought the switch
cluster. What is missing, and causing fw_devlink problems is the MDIO
bus master for the PHYs, and the interrupt control where PHY
interrupts are stored, and the linking from the PHY to the interrupt
controller. Physically all these parts are inside the Ethernet switch
package. But Linux models them as separate blocks. This is because in
the general case, they are all discrete blocks. You have a MAC chip,
and a PHY chip, and the PHY interrupt output it connected to a SoC
GPIO.

> 
>  +-----------------------------+
>  |          VF610 SoC          |
>  |          +--------+         |
>  |          |  fec1  |         |
>  +----------+--------+---------+
>                 | DSA master
>                 |
>                 | ethernet = <&fec1>;
>  +--------+----------+---------------------------+
>  |        |  port@6  |                           |
>  |        +----------+                           |
>  |        | CPU port |     dsa,member = <0 0>;   |
>  |        +----------+      -> tree 0, switch 0  |
>  |        |   cpu    |                           |
>  |        +----------+                           |
>  |                                               |
>  |            switch0                            |
>  |                                               |
>  +-----------+-----------+-----------+-----------+

Inside the block above, is the interrupt controller and the MDIO bus
master.


>  |   port@0  |   port@1  |   port@2  |   port@5  |
>  +-----------+-----------+-----------+-----------+
>  |switch0phy0|switch0phy1|switch0phy2|   no PHY  |
>  +-----------+-----------+-----------+-----------+

The control path for these PHYs is over the MDIO bus. They are probed
via the control path bus. These PHYs also have an interrupt output,
which is wired to the interrupt controller above.


>  | user port | user port | user port | DSA port  |
>  +-----------+-----------+-----------+-----------+
>  |    lan0   |    lan1   |    lan2   |    dsa    |
>  +-----------+-----------+-----------+-----------+

   Andrew
