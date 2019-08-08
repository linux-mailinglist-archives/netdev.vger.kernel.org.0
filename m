Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8C863F4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390085AbfHHOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35161 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389968AbfHHOKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:11 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id EA9A06000A;
        Thu,  8 Aug 2019 14:10:06 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 0/9] net: macsec: initial support for hardware offloading
Date:   Thu,  8 Aug 2019 16:05:51 +0200
Message-Id: <20190808140600.21477-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series intends to add support for offloading MACsec transformations
in hardware enabled devices. The series is divided in two parts: the
first 6 patches add the infrastructure support to offload a MACsec
configuration to hardware drivers; and the last 3 patches introduce the
MACsec offloading support in the Microsemi Ocelot networking PHY, making
it the first driver to support the MACsec hardware offloading feature.

The series can also be found at:
https://github.com/atenart/linux/tree/net-next/macsec

MACsec hardware offloading infrastructure
-----------------------------------------

Linux has a software implementation of the MACsec standard and so far no
hardware offloading feature was developed and submitted. Some hardware
engines can perform MACsec operations, such as the Intel ixgbe NIC and
the Microsemi Ocelot PHY (the one we use in this series). This means the
MACsec offloading infrastructure should support networking PHY and
Ethernet drivers. A preliminary email[1] was sent about this.

The main idea here is to re-use the logic and data structures of the
software MACsec implementation. This allows not to duplicate definitions
and structure storing the same kind of information. It also allows to
use a unified genlink interface for both MACsec implementations (so that
the same userspace tool, `ip macsec`, is used with the same arguments).
The MACsec offloading support cannot be disabled if an interface
supports it at the moment, but this could be implemented later on if
this is a need (we could think of something like
`ip macsec set macsec0 offloading off`).

Because we do reuse the software implementation logic and because the
choice was made to expose the exact same interface to the user, a
virtual interface is created exactly as if the MACsec software
implementation was used. This was a big question when doing this work,
and another approach would have been to register the genl helpers for
all MACsec implementations and to have the software one a provider (such
as the h/w offloading device drivers are). This would mean there would
be no way to switch between implementations in the future at runtime.
I'm open to discuss this point as I think this is really important and
I'm not sure what is the best solution here.

The MACsec configuration is passed to device drivers supporting it
through MACsec ops which are called (indirectly) from the MACsec
genl helpers. This function calls the MACsec ops of PHY and Ethernet
drivers in two steps: a preparation one, and a commit one. The first
step is allowed to fail and should be used to check if a provided
configuration is compatible with the features provided by a MACsec
engine, while the second step is not allowed to fail and should only be
used to enable a given MACsec configuration. Two extra calls are made:
when a virtual MACsec interface is created and when it is deleted, so
that the hardware driver can stay in sync.

The Rx and TX handlers are modified to take in account the special case
were the MACsec transformation happens in the hardware, whether in a PHY
or in a MAC, as the packets seen by the networking stack on both the
physical and MACsec virtual interface are exactly the same. This leads
to some limitations: the hardware and software implementations can't be
used on the same physical interface, as the policies would be impossible
to fulfill (such as strict validation of the frames). Also only a single
virtual MACsec interface can be attached to a physical port supporting
hardware offloading as it would be impossible to guess onto which
interface a given packet should go (for ingress traffic).

Another limitation as of now is that the counters and statistics are not
reported back from the hardware to the software MACsec implementation.
This isn't an issue when using offloaded MACsec transformations, but it
should be added in the future so that the MACsec state can be reported
to the user (which would also improve the debug).

[1] https://www.spinics.net/lists/netdev/msg513047.html

Microsemi Ocelot PHY MACsec support
-----------------------------------

In order to add support for the MACsec offloading feature in the
Microsemi Ocelot driver, the __phy_read_page and __phy_write_page
helpers had to be exported. This is because the initialization of the
PHY is done while holding the MDIO bus lock, and we need to change the
page to configure the MACsec block.

The support itself is then added in two patches. The first one adds
support for configuring the MACsec block within the PHY, so that it is
up, running and available for future configuration, but is not doing any
modification on the traffic passing through the PHY. The second patch
implements the phy_device MACsec ops in the Microsemi Ocelot PHY driver,
and introduce helpers to configure MACsec transformations and flows to
match specific packets.

Thanks!
Antoine

Since v1:
  - Reworked the MACsec offloading API, moving from a single helper
    called for all MACsec configuration operations, to a per-operation
    function that is provided by the underlying hardware drivers.
  - Those functions now contain a verb to describe the configuration
    action they're offloading.
  - Improved the error handling in the MACsec genl helpers to revert
    the configuration to its previous state when the offloading call
    failed.
  - Reworked the file inclusions.

Antoine Tenart (9):
  net: introduce the MACSEC netdev feature
  net: macsec: move some definitions in a dedicated header
  net: macsec: introduce the macsec_context structure
  net: introduce MACsec ops and add a reference in net_device
  net: phy: add MACsec ops in phy_device
  net: macsec: hardware offloading infrastructure
  net: phy: export __phy_read_page/__phy_write_page
  net: phy: mscc: macsec initialization
  net: phy: mscc: macsec support

 drivers/net/macsec.c             |  542 ++++++++++------
 drivers/net/phy/Kconfig          |    2 +
 drivers/net/phy/mscc.c           | 1024 ++++++++++++++++++++++++++++++
 drivers/net/phy/mscc_fc_buffer.h |   64 ++
 drivers/net/phy/mscc_mac.h       |  159 +++++
 drivers/net/phy/mscc_macsec.h    |  258 ++++++++
 drivers/net/phy/phy-core.c       |    6 +-
 include/linux/netdev_features.h  |    3 +
 include/linux/netdevice.h        |   31 +
 include/linux/phy.h              |   13 +
 include/net/macsec.h             |  203 ++++++
 include/uapi/linux/if_macsec.h   |    3 +-
 net/core/ethtool.c               |    1 +
 13 files changed, 2125 insertions(+), 184 deletions(-)
 create mode 100644 drivers/net/phy/mscc_fc_buffer.h
 create mode 100644 drivers/net/phy/mscc_mac.h
 create mode 100644 drivers/net/phy/mscc_macsec.h
 create mode 100644 include/net/macsec.h

-- 
2.21.0

