Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990341090F5
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfKYPXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:23:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfKYPXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 10:23:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QxQNDY3h4QEH/474FEBZsr50zPaZur7gyEqjwq7sTZM=; b=mijzQuOfdJ4Y2MJffDpDWUAHJU
        zAmGh+pHy/bdZumijvMa5jTNBetlh8xEgic7xoCr5sdF5V569i4n4u9j+44Rm+BE/0FhjF9AGp4pL
        qlxWvESVzBxgOLE7kKvNRpM1iR3tnv/jrHAlPTkezhYDGCk0QbxeQdUjKAgK6tlTQOXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZGCm-0007xf-FU; Mon, 25 Nov 2019 16:23:12 +0100
Date:   Mon, 25 Nov 2019 16:23:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
Subject: Re: [PATCH v1 1/2] net: dsa: sja1105: print info about probet chip
 only after every thing was done.
Message-ID: <20191125152312.GJ6602@lunn.ch>
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
 <CA+h21hrOO6AFhvXQL47LwqCKU9vpRZ47feWB6fkn=WfrdZr6tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrOO6AFhvXQL47LwqCKU9vpRZ47feWB6fkn=WfrdZr6tA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you want to actually fix something, there is also a memory leak
> related to this. It is present in most DSA drivers. When
> dsa_register_switch returns -EPROBE_DEFER, anything allocated with
> devm_kzalloc will be overwritten and the old memory will leak.

There is a rather unfortunate chicken/egg problem here for any switch
using MDIO. At the moment i don't know how to solve it. As a result
the first probe is pretty much guaranteed to return -EPROBE_DEFER. The
problem is that the MAC driver registers its MDIO bus. That causes the
DT to be walked for the bus and the switch probed. The switch probe
registers the switch with the DSA core. It then tries to get a handle
on the master device. But the MAC driver has not called
netdev_register() yet, it is busy registering its MDIO bus. So the
master device is not there, and so we get a -EPROBE_DEFER and the
switch driver needs to unwind.

So for an MDIO switch, i suggest the probe it kept to a minimum, and
all the real work is done in the setup callback. Setup is called when
all resources the DSA core needs are available.

I've got a patch somewhere for mv88e6xxx which does this move, and it
cut boot time by a noticeable amount.

    Andrew
