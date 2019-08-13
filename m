Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD688BDB0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfHMPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:51:27 -0400
Received: from mail.nic.cz ([217.31.204.67]:46210 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfHMPv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 11:51:27 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 44864140AE0;
        Tue, 13 Aug 2019 17:51:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565711485; bh=1ZjiG7apIBmJxJQz8eTthe+CNhs1/tD3upibZNIyyws=;
        h=Date:From:To;
        b=d9cJLIfde68wTedoNV3jlb5A+oThMYc7t4wFWpesYQVwfNvCLlovIcJl0ghyD2kog
         Yg/B5WPMpNuQ92Wl8h3pmW6jjGe83puIKY9OJrPry9hoVvlIILhamj+ZQGIzzjE5tK
         kAuaASAU9omLxNDIvcRuUIrVonF7XXAclSIENrpE=
Date:   Tue, 13 Aug 2019 17:51:24 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port
 setup
Message-ID: <20190813175124.06d8cdf5@dellmb.labs.office.nic.cz>
In-Reply-To: <20190813174416.5c57b08f@dellmb.labs.office.nic.cz>
References: <20190811150812.6780-1-marek.behun@nic.cz>
        <20190811153153.GB14290@lunn.ch>
        <20190811181445.71048d2c@nic.cz>
        <20190811165108.GG14290@lunn.ch>
        <20190813174416.5c57b08f@dellmb.labs.office.nic.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 17:44:16 +0200
Marek Beh=C3=BAn <marek.behun@nic.cz> wrote:

> Hi Andrew,
>=20
> > We should read the switch registers. I think you can set the
> > defaults using strapping pins. And in general, the driver always
> > reads state from the hardware rather than caching it. =20
>=20
> hmm. The cmode is cached for each port, though. For example
> mv88e6390x_port_set_cmode compares the new requested value with the
> cached one and doesn't do anything if they are equal.
>=20
> If mv88e6xxx_port_setup_mac can be called once per second by phylink
> as you say, do we really want to read the value via MDIO every time?
> We already have cmode cached (read from registers at mv88e6xxx_setup,
> and then changed when cmode change is requested). From cmode we can
> already differentiate mode in the terms of phy_interface_t, unless it
> is RGMII, in which case we would have to read RX/TX timing.
>=20
> Marek

/o\ OK. I see now that mv88e6xxx_port_setup_mac already calls
->port_link_state(), which fills in a struct phylink_link_state, and
already does MDIO communication. Sorry :)
I will try to send a patch which adds the filling of the ->interface
member of the struct phylink_link_state in ->port_link_state() method.

Marek
