Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1E2F59F1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhANEeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbhANEea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783F323787;
        Thu, 14 Jan 2021 04:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610598829;
        bh=hntER9pmtviqYMwn91xJthVz5Ugga3M0xy4IKUvkZT8=;
        h=From:To:Cc:Subject:Date:From;
        b=BfCtdqM9PX3az9onmEJWXZSlAvbem6B8d4BHsWjVgyAaKbeSd+FCfgxQF+m8p8BWm
         GlUBBdvmFLtQBabBvhtk0kVGGOhT20gfkv8QvOkE+GUOJ40RJgB1J0NHiSMrnZ8gqT
         nYjQ/hdfL5K4W+zU6xT7VsKceYtuBqNw7kR/g5dORrwzm29AkIleZ/yauQnMGiXZIt
         tUO51wy77bgWKSKFNxLxCbXkBYPVLZUjQ/3Af9AZe51OVyUEBrpq3dGrVn8pUuHQ6I
         WC2Tug3cx7AZL8cY/R3qpviO1iRVxDQ+HtmR/mfOxr+qblZWySQY/HOaFI7yZSEvxR
         HiitClwD+uNfA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v16 0/6] Add support for mv88e6393x family of Marvell
Date:   Thu, 14 Jan 2021 05:33:25 +0100
Message-Id: <20210114043331.4572-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is version 16 of patches adding support for Amethyst family to
mv88e6xxx. It should apply cleanly on net-next.

This series is tested on Marvell CN9130-CRB.

Changes from v15:
- put 10000baseKR_Full back into phylink_validate method for Amethyst,
  it seems I misunderstood the meaning behind things and removed it
  from v15
- removed erratum 3.7, since the procedure is done anyway in
  mv88e6390_serdes_pcs_config
- renumbered errata 3.6 and 3.8 to 4.6 and 4.8, according to newer
  version of the errata document
- refactored errata code a little and removed duplicate macro
  definitions (for example MV88E6390_SGMII_CONTROL is already called
  MV88E6390_SGMII_BMCR)

Changes from v14:
- added my Signed-off-by tags to Pavana's patches, since I am sending
  them (as suggested by Andrew)
- added documentation to second patch adding 5gbase-r mode (as requested
  by Russell)
- added Reviewed-by tags
- applied Vladimir's suggestions:
  - reduced indentation level in mv88e6xxx_set_egress_port and
    mv88e6393x_serdes_port_config
  - removed 10000baseKR_Full from mv88e6393x_phylink_validate
  - removed PHY_INTERFACE_MODE_10GKR from mv88e6xxx_port_set_cmode

Changes from v13:
- added patch that wraps .set_egress_port into mv88e6xxx_set_egress_port,
  so that we do not have to set chip->*gress_dest_port members in every
  implementation of this method
- for the patch that adds Amethyst support:
  - added more information into commit message
  - added these methods for mv88e6393x_ops:
      .port_sync_link
      .port_setup_message_port
      .port_max_speed_mode (new implementation needed)
      .atu_get_hash
      .atu_set_hash
      .serdes_pcs_config
      .serdes_pcs_an_restart
      .serdes_pcs_link_up
  - this device can set upstream port per port, so implement
      .port_set_upstream_port
    instead of
      .set_cpu_port
  - removed USXGMII cmode (not yet supported, working on it)
  - added debug messages into mv88e6393x_port_set_speed_duplex
  - added Amethyst errata 4.5 (EEE should be disabled on SERDES ports)
  - fixed 5gbase-r serdes configuration and interrupt handling
  - refactored mv88e6393x_serdes_setup_errata
  - refactored mv88e6393x_port_policy_write
- added patch implementing .port_set_policy for Amethyst

Marek

Marek Behún (2):
  net: dsa: mv88e6xxx: wrap .set_egress_port method
  net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter type from u8 type to
    int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell

 .../bindings/net/ethernet-controller.yaml     |   1 +
 Documentation/networking/phy.rst              |   6 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 228 ++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.c           |  19 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 397 ++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/port.h              |  50 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 338 +++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h            |  98 +++--
 include/linux/phy.h                           |   4 +
 12 files changed, 1008 insertions(+), 163 deletions(-)


base-commit: 0ae5b43d6dde6003070106e97cd0d41bace2eeb2
prerequisite-patch-id: 8fe60846eecbffca04e65661b0b9529b8006ac5d
-- 
2.26.2

