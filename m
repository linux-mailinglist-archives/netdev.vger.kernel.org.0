Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0829270E9E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgISOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 10:43:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgISOn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 10:43:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJe5h-00FNaN-1R; Sat, 19 Sep 2020 16:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next RFC v1 0/4] Add per port devlink regions
Date:   Sat, 19 Sep 2020 16:43:28 +0200
Message-Id: <20200919144332.3665538-1-andrew@lunn.ch>
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
mdio_bus/gpio-0:00/1/port: size 64 snapshot []
mdio_bus/gpio-0:00/2/port: size 64 snapshot []
mdio_bus/gpio-0:00/3/port: size 64 snapshot []
mdio_bus/gpio-0:00/4/port: size 64 snapshot []
mdio_bus/gpio-0:00/8/port: size 64 snapshot []

root@rap:~# devlink region new mdio_bus/gpio-0:00/1/port snapshot 42
root@rap:~# devlink region dump mdio_bus/gpio-0:00/1/port snapshot 42
0000000000000000 4f 1e 3e 20 00 01 01 39 3f 05 00 00 fd 07 00 00
0000000000000010 80 00 01 00 00 00 00 00 00 00 00 00 00 00 00 91
0000000000000020 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00
0000000000000030 07 3e 00 00 00 00 00 80 00 00 00 00 00 00 5b 00

DSA only instantiates devlink ports for switch ports which are used.
For this hardware, only 4 user ports and the CPU port have devlink
ports, which explains the discontinuous port regions.

Andrew Lunn (4):
  net: devlink: Add support for port regions
  net: dsa: Add devlink port regions support to DSA
  net: dsa: Add helper for converting devlink port to ds and port
  net: dsa: mv88e6xxx: Add per port devlink regions

 drivers/net/dsa/mv88e6xxx/chip.c    |   8 +
 drivers/net/dsa/mv88e6xxx/devlink.c |  61 +++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |   6 +-
 include/net/devlink.h               |  27 +++
 include/net/dsa.h                   |  19 +++
 net/core/devlink.c                  | 250 +++++++++++++++++++++++++---
 net/dsa/dsa.c                       |  14 ++
 7 files changed, 358 insertions(+), 27 deletions(-)

-- 
2.28.0

