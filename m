Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB78263B05
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgIJCxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:53:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbgIJB5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:57:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00DzpI-LO; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 0/9] mv88e6xxx: Add devlink regions support
Date:   Thu, 10 Sep 2020 01:58:18 +0200
Message-Id: <20200909235827.3335881-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
 drivers/net/dsa/mv88e6xxx/chip.h             |  14 +
 drivers/net/dsa/mv88e6xxx/devlink.c          | 523 +++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h          |  21 +
 drivers/net/ethernet/intel/ice/ice_devlink.c |   2 +
 drivers/net/netdevsim/dev.c                  |   6 +-
 include/net/devlink.h                        |   6 +-
 include/net/dsa.h                            |  18 +-
 net/core/devlink.c                           |   2 +-
 net/dsa/dsa.c                                |  28 +-
 net/dsa/dsa2.c                               |  19 +-
 12 files changed, 653 insertions(+), 277 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h

-- 
2.28.0

