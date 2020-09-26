Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4957B279C89
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgIZVHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIZVHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPT-00GJgw-Ql; Sat, 26 Sep 2020 23:07:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/7] mv88e6xxx: Add per port devlink regions
Date:   Sat, 26 Sep 2020 23:06:25 +0200
Message-Id: <20200926210632.3888886-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset extends devlink regions to support per port regions, and
them makes use of them to support the ports of the mv88e6xxx switches.

root@rap:~# devlink region show
mdio_bus/gpio-0:00/global1: size 64 snapshot []
mdio_bus/gpio-0:00/global2: size 64 snapshot []
mdio_bus/gpio-0:00/atu: size 49152 snapshot []
mdio_bus/gpio-0:00/0/port: size 64 snapshot []
mdio_bus/gpio-0:00/1/port: size 64 snapshot []
mdio_bus/gpio-0:00/2/port: size 64 snapshot []
mdio_bus/gpio-0:00/3/port: size 64 snapshot []
mdio_bus/gpio-0:00/4/port: size 64 snapshot []
mdio_bus/gpio-0:00/5/port: size 64 snapshot []
mdio_bus/gpio-0:00/6/port: size 64 snapshot []
mdio_bus/gpio-0:00/7/port: size 64 snapshot []
mdio_bus/gpio-0:00/8/port: size 64 snapshot []
mdio_bus/gpio-0:00/9/port: size 64 snapshot []
mdio_bus/gpio-0:00/10/port: size 64 snapshot []

root@rap:~# devlink region new mdio_bus/gpio-0:00/1/port snapshot 42
root@rap:~# devlink region dump mdio_bus/gpio-0:00/1/port snapshot 42
0000000000000000 4f 1e 3e 20 00 01 01 39 3f 05 00 00 fd 07 00 00
0000000000000010 80 00 01 00 00 00 00 00 00 00 00 00 00 00 00 91
0000000000000020 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00
0000000000000030 07 3e 00 00 00 00 00 80 00 00 00 00 00 00 5b 00

In order to support all ports of the switch, a new devlink flavour has
been added for unused ports:

# devlink port show
mdio_bus/gpio-0:00/0: type notset flavour unused splittable false
mdio_bus/gpio-0:00/1: type notset flavour cpu port 1 splittable false
mdio_bus/gpio-0:00/2: type eth netdev red flavour physical port 2 splittable fae
mdio_bus/gpio-0:00/3: type eth netdev blue flavour physical port 3 splittable fe
mdio_bus/gpio-0:00/4: type eth netdev green flavour physical port 4 splittable e
mdio_bus/gpio-0:00/5: type notset flavour unused splittable false
mdio_bus/gpio-0:00/6: type notset flavour unused splittable false
mdio_bus/gpio-0:00/7: type notset flavour unused splittable false
mdio_bus/gpio-0:00/8: type eth netdev waic0 flavour physical port 8 splittable e
mdio_bus/gpio-0:00/9: type notset flavour unused splittable false
mdio_bus/gpio-0:00/10: type notset flavour unused splittable false

The DSA core now creates the devlink port instances earlier, so that
the driver setup function can make use of them.

Andrew Lunn (7):
  net: devlink: Add unused port flavour
  net: dsa: Make use of devlink port flavour unused
  net: dsa: Register devlink ports before calling DSA driver setup()
  net: devlink: Add support for port regions
  net: dsa: Add devlink port regions support to DSA
  net: dsa: Add helper for converting devlink port to ds and port
  net: dsa: mv88e6xxx: Add per port devlink regions

 drivers/net/dsa/mv88e6xxx/devlink.c | 109 +++++++++++-
 include/net/devlink.h               |  27 +++
 include/net/dsa.h                   |  20 +++
 include/uapi/linux/devlink.h        |   3 +
 net/core/devlink.c                  | 254 +++++++++++++++++++++++++---
 net/dsa/dsa.c                       |  14 ++
 net/dsa/dsa2.c                      | 123 +++++++++-----
 7 files changed, 478 insertions(+), 72 deletions(-)

-- 
2.28.0

