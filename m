Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EE889282
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfHKQOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:14:47 -0400
Received: from mail.nic.cz ([217.31.204.67]:50740 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfHKQOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:14:47 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id BD1DF140AB0;
        Sun, 11 Aug 2019 18:14:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565540085; bh=jHa23c+B6uUC51F8gphU5jTVLcaF6BYJ0xQD47Qdp0Q=;
        h=Date:From:To;
        b=ouNnmBwuJ8sgSy4/dfTMOLxyDsFYNUGQEG818QWXRC2b+7GOIgUFL5ZcXnCHF81Do
         mQOeCyhMvEPybrV87sPMkT2fspvR18H5qtU9KViYJMEhR/ft874ZCIF2lO8vftmwZG
         kT8MxnPHNkyzlAQFRrt4ED/H1rFkvGUswI2t7kWs=
Date:   Sun, 11 Aug 2019 18:14:45 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port
 setup
Message-ID: <20190811181445.71048d2c@nic.cz>
In-Reply-To: <20190811153153.GB14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
        <20190811153153.GB14290@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Aug 2019 17:31:53 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Aug 11, 2019 at 05:08:11PM +0200, Marek Beh=C3=BAn wrote:
> > The mv88e6xxx_port_setup_mac looks if one of the {link, speed, duplex}
> > parameters is being changed from the current setting, and if not, does
> > not do anything. This test is wrong in some situations: this method also
> > has the mode argument, which can also be changed.
> >=20
> > For example on Turris Omnia, the mode is PHY_INTERFACE_MODE_RGMII_ID,
> > which has to be set byt the ->port_set_rgmii_delay method. The test does
> > not look if mode is being changed (in fact there is currently no method
> > to determine port mode as phy_interface_t type).
> >=20
> > The simplest solution seems to be to drop this test altogether and
> > simply do the setup when requested. =20
>=20
> Hi Marek
>=20
> Unfortunately, that code is there for a reason. phylink can call the
> ->mac_config() method once per second. It is documented that =20
> mac_config() should only reconfigure what, if anything, has changed.
> And mv88e6xxx_port_setup_mac() needs to disable the port in order to
> change anything. So the change you propose here, under some
> conditions, will cause the port to be disabled/enables once per
> second.
>=20
> We need to fix this by expanding the test, not removing it.  My
> current _guess_ would be, we need to add a ops->port_get_rgmii_delay()
> so we can see if that is what needs configuring.
>=20
>    Andrew

Hi Andrew,
what if we added a phy_mode member to struct mv88e6xxx_port, and either
set it to PHY_INTERFACE_MODE_NA in mv88e6xxx_setup, or implemented
methods for converting the switch register values to
PHY_INTERFACE_MODE_* values.
This way we could just add port.mode =3D=3D mode check to port_setup_mac
method.
I am willing to implement this if you think this could work.

Marek
