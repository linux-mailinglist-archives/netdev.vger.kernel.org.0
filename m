Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B572704BF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIRTLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:11:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgIRTLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:11:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJLn1-00FH8z-ON; Fri, 18 Sep 2020 21:11:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 0/9] mv88e6xxx: Add devlink regions support
Date:   Fri, 18 Sep 2020 21:11:00 +0200
Message-Id: <20200918191109.3640779-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of devlink regions to allow read access to some of the
internal of the switches. Currently access to global1, global2 and the
ATU is provided.

The switch itself will never trigger a region snapshot, it is assumed
it is performed from user space as needed.

v2:
Remove left of debug print
Comment ATU format is generic to mv88e6xxx
Combine declaration and the assignment on a single line.

v3:
Drop support for port regions
Improve the devlink API with a priv member and passing the region to
the snapshot function
Make the helper to convert from devlink to ds an inline function

v4:
Add missing kerneldoc in ICE driver
Fix typo for global2 reading global1 registers
Make use of enum to make code more readable

Andrew Lunn (9):
  net: devlink: regions: Add a priv member to the regions ops struct
  net: devlink: region: Pass the region ops to the snapshot function
  net: dsa: Add helper to convert from devlink to ds
  net: dsa: Add devlink regions support to DSA
  net: dsa: mv88e6xxx: Move devlink code into its own file
  net: dsa: mv88e6xxx: Create helper for FIDs in use
  net: dsa: mv88e6xxx: Add devlink regions
  net: dsa: wire up devlink info get
  net: dsa: mv88e6xxx: Implement devlink info get callback

 drivers/net/dsa/mv88e6xxx/Makefile           |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c             | 290 ++--------
 drivers/net/dsa/mv88e6xxx/chip.h             |  18 +
 drivers/net/dsa/mv88e6xxx/devlink.c          | 532 +++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h          |  21 +
 drivers/net/ethernet/intel/ice/ice_devlink.c |   4 +
 drivers/net/netdevsim/dev.c                  |   6 +-
 include/net/devlink.h                        |   6 +-
 include/net/dsa.h                            |  18 +-
 net/core/devlink.c                           |   2 +-
 net/dsa/dsa.c                                |  28 +-
 net/dsa/dsa2.c                               |  19 +-
 12 files changed, 668 insertions(+), 277 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h

-- 
2.28.0

