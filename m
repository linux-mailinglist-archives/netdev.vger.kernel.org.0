Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0933F16C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhCQNrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhCQNrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 09:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07F0264F50;
        Wed, 17 Mar 2021 13:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615988835;
        bh=0nTLSksxR22MUmSMzM+q8/uD5iVTh97BeoTWj6M+Y0A=;
        h=From:To:Cc:Subject:Date:From;
        b=BOh7zTkcxY/sYWjShPAzQILgJzPh/dkC7MPZhMDK3XXUs1QxsTcvyXI2enKqHfyLc
         SYykwmRET0Faeme9PUftNZE1nH8dwRzdf0lGjl/Cix4bYDJSuR6Kynk2R9XgWuVTEc
         aHIYmQRM6e74pHJB7432L0Qs47Fvd/F7X1C3eIoL/l4mHrHQXdIrNdasGH0HUjGCBU
         81l/NF9G14tReZKVKYYhIYrpYZphUzX9jdR3VRLQZ02Pp7Mu9PNZrVXn/9dyRkvafs
         aznG6tCu09fxW8G1Mvict65pfs4UwdD/ES/GqVQFgVm3C/LDOF+kdnC3vUoDN62iud
         fUzNJBW20d3AQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        olteanv@gmail.com, andrew@lunn.ch, ashkan.boldaji@digi.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, lkp@intel.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v17 0/4] Add support for mv88e6393x family of Marvell
Date:   Wed, 17 Mar 2021 14:46:39 +0100
Message-Id: <20210317134643.24463-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

after 2 months I finally had time to send v17 of Amethyst patches.

This series is tested on Marvell CN9130-CRB.

Changes since v16:
- dropped patches adding 5gbase-r, since they are already merged
- rebased onto net-next/master
- driver API renamed set_egress_flood() method into 2 methods for
  ucast/mcast floods, so this is fixed

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

Pavana Sharma (2):
  net: dsa: mv88e6xxx: change serdes lane parameter type from u8 type to
    int
  net: dsa: mv88e6xxx: add support for mv88e6393x family

 drivers/net/dsa/mv88e6xxx/chip.c    | 233 +++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h    |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.c |  19 +-
 drivers/net/dsa/mv88e6xxx/global1.h |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h |   8 +
 drivers/net/dsa/mv88e6xxx/port.c    | 397 +++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/port.h    |  48 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c  | 338 ++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h  |  98 ++++---
 9 files changed, 1002 insertions(+), 161 deletions(-)

-- 
2.26.2

