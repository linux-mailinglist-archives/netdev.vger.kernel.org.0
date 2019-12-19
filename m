Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04003126059
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSLBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:01:32 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:54859 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLSLAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:19 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 5B539FF807;
        Thu, 19 Dec 2019 11:00:16 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 00/15] net: macsec: initial support for hardware offloading
Date:   Thu, 19 Dec 2019 11:55:00 +0100
Message-Id: <20191219105515.78400-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

td;dr: When applying this series, do not apply patches 12 to 14.

This series intends to add support for offloading MACsec transformations
to hardware enabled devices. The series adds the necessary
infrastructure for offloading MACsec configurations to hardware drivers,
in patches 1 to 6; then introduces MACsec offloading support in the
Microsemi MSCC PHY driver, in patches 7 to 11.

The remaining 4 patches, 12 to 14, are *not* part of the series but
provide the mandatory changes needed to support offloading MACsec
operations to a MAC driver. Those patches are provided for anyone
willing to add support for offloading MACsec operations to a MAC, and
should be part of the first series adding a MAC as a MACsec offloading
provider.

The series can also be found at:
https://github.com/atenart/linux/tree/net-next/macsec

IProute2 modifications can be found at:
https://github.com/atenart/iproute2/tree/macsec

MACsec hardware offloading infrastructure
-----------------------------------------

Linux has a software implementation of the MACsec standard. There are
hardware engines supporting MACsec operations, such as the Intel ixgbe
NIC and some Microsemi PHYs (the one we use in this series). This means
the MACsec offloading infrastructure should support networking PHY and
MAC drivers. Note that MAC driver preliminary support is part of this
series, but should not be merged before we actually have a provider for
this.

We do intend in this series to re-use the logic, netlink API and data
structures of the existing MACsec software implementation. This allows
not to duplicate definitions and structure storing the same information;
as well as using the same userspace tools to configure both software or
hardware offloaded MACsec flows (with `ip macsec`).

When adding a new MACsec virtual interface the existing logic is kept:
offloading is disabled by default. A user driven configuration choice is
needed to switch to offloading mode (a patch in iproute2 is needed for
this). A single MACsec interface can be offloaded for now, and some
limitations are there: no flow can be moved from one implementation to
the other so the decision needs to be done before configuring the
interface.

MACsec offloading ops are called in 2 steps: a preparation one, and a
commit one. The first step is allowed to fail and should be used to
check if a provided configuration is compatible with a given MACsec
capable hardware. The second step is not allowed to fail and should
only be used to enable a given MACsec configuration.

A limitation as of now is the counters and statistics are not reported
back from the hardware to the software MACsec implementation. This
isn't an issue when using offloaded MACsec transformations, but it
should be added in the future so that the MACsec state can be reported
to the user (which would also improve the debug).

Microsemi PHY MACsec support
-----------------------------------

In order to add support for the MACsec offloading feature in the
Microsemi MSCC PHY driver, the __phy_read_page and __phy_write_page
helpers had to be exported. This is because the initialization of the
PHY is done while holding the MDIO bus lock, and we need to change the
page to configure the MACsec block.

The support itself is then added in three patches. The first one adds
support for configuring the MACsec block within the PHY, so that it is
up, running and available for future configuration, but is not doing any
modification on the traffic passing through the PHY. The second patch
implements the phy_device MACsec ops in the Microsemi MSCC PHY driver,
and introduce helpers to configure MACsec transformations and flows to
match specific packets. The last one adds support for PN rollover.

Thanks!
Antoine

Since v3:
  - Fixed a check when enabling offloading that was too restrictive.
  - Fixed the propagation of the changelink event to the underlying
    device drivers.

Since v2:
  - Allow selection the offloading from userspace, defaulting to the
    software implementation when adding a new MACsec interface. The
    offloading mode is now also reported through netlink.
  - Added support for letting MKA packets in and out when using MACsec
    (there are rules to let them bypass the MACsec h/w engine within the
    PHY).
  - Added support for PN rollover (following what's currently done in
    the software implementation: the flow is disabled).
  - Split patches to remove MAC offloading support for now, as there are
    no current provider for this (patches are still included).
  - Improved a few parts of the MACsec support within the MSCC PHY
    driver (e.g. default rules now block non-MACsec traffic, depending
    on the configuration).
  - Many cosmetic fixes & small improvements.

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

Antoine Tenart (15):
  net: macsec: move some definitions in a dedicated header
  net: macsec: introduce the macsec_context structure
  net: macsec: introduce MACsec ops
  net: phy: add MACsec ops in phy_device
  net: macsec: hardware offloading infrastructure
  net: macsec: add nla support for changing the offloading selection
  net: phy: export __phy_read_page/__phy_write_page
  net: phy: mscc: macsec initialization
  net: phy: mscc: macsec support
  net: macsec: PN wrap callback
  net: phy: mscc: PN rollover support
  net: introduce the MACSEC netdev feature
  net: add a reference to MACsec ops in net_device
  net: macsec: allow to reference a netdev from a MACsec context
  net: macsec: add support for offloading to the MAC

 drivers/net/macsec.c               |  794 ++++++++++++++-----
 drivers/net/phy/Kconfig            |    2 +
 drivers/net/phy/mscc.c             | 1183 +++++++++++++++++++++++++++-
 drivers/net/phy/mscc_fc_buffer.h   |   64 ++
 drivers/net/phy/mscc_mac.h         |  159 ++++
 drivers/net/phy/mscc_macsec.h      |  266 +++++++
 drivers/net/phy/phy-core.c         |    6 +-
 include/linux/netdev_features.h    |    3 +
 include/linux/netdevice.h          |    9 +
 include/linux/phy.h                |   12 +
 include/net/macsec.h               |  228 ++++++
 include/uapi/linux/if_link.h       |    8 +
 include/uapi/linux/if_macsec.h     |   14 +-
 net/ethtool/common.c               |    1 +
 tools/include/uapi/linux/if_link.h |    8 +
 15 files changed, 2568 insertions(+), 189 deletions(-)
 create mode 100644 drivers/net/phy/mscc_fc_buffer.h
 create mode 100644 drivers/net/phy/mscc_mac.h
 create mode 100644 drivers/net/phy/mscc_macsec.h
 create mode 100644 include/net/macsec.h

-- 
2.24.1

