Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59EA8BD75
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfHMPoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:44:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:46102 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfHMPoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 11:44:18 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 3998B140AE0;
        Tue, 13 Aug 2019 17:44:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565711057; bh=LU9UkiNLrL+a9D+idc7IQ86LF+mUCzXynwlTRQrOPO0=;
        h=Date:From:To;
        b=BALiV59MQMTP56Yv95IStCpXVP8sLRl/sZDh/pcjFM4u31qY2mXOdBoryo8l5NoCo
         eVfey93Aud6Miqh63XZ3/6//3rjVU3HvD5ExYik7gQqU7Jo61gXFYWDUCb4Kgz7hHD
         CpedYyh6uBveR3S2c96ihFJYPm7kyvJ7f8LRRkUc=
Date:   Tue, 13 Aug 2019 17:44:16 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port
 setup
Message-ID: <20190813174416.5c57b08f@dellmb.labs.office.nic.cz>
In-Reply-To: <20190811165108.GG14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
        <20190811153153.GB14290@lunn.ch>
        <20190811181445.71048d2c@nic.cz>
        <20190811165108.GG14290@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> We should read the switch registers. I think you can set the defaults
> using strapping pins. And in general, the driver always reads state
> from the hardware rather than caching it.

hmm. The cmode is cached for each port, though. For example
mv88e6390x_port_set_cmode compares the new requested value with the
cached one and doesn't do anything if they are equal.

If mv88e6xxx_port_setup_mac can be called once per second by phylink as
you say, do we really want to read the value via MDIO every time? We
already have cmode cached (read from registers at mv88e6xxx_setup, and
then changed when cmode change is requested). From cmode we can already
differentiate mode in the terms of phy_interface_t, unless it is RGMII,
in which case we would have to read RX/TX timing.

Marek
