Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B500A2F3B3E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393090AbhALTy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393028AbhALTyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:54:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC766206C3;
        Tue, 12 Jan 2021 19:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610481254;
        bh=S9UgT7/zTuyKXrcGSG6jcg900etnahQJAFa0IuIH9Ww=;
        h=From:To:Cc:Subject:Date:From;
        b=sI3kBiJH0anKgR57iX5lFm6ieWGYTywfTJ5btqzBJqug30/kjBvopE21kS0cIIqrk
         dBX21/bABrc04mUF1AR0njOt0YtHT1kD/hXO6LCKY+EFlwQuDi2eZZmADacFd6ymm8
         NaeA00llAGcLNzaIUzZRiFLqc+88duzvRcdf4EItsA9wB1+xwBbt4CE+sEQxhkumzP
         UIHZaEfNYHvBsq/9ug99VViKWe1/m7GBq2PvKFhc5T6prRh2ZA4WfJii9PWmypBbFo
         j5Hqw6TAeekjT3XVlWz/slsqbJCzUnDDAdpDEy2Qzywi4ORDI7h7ufAtXS7J6fP6m2
         Vm0Q/afd5tD7g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v15 0/6] Add support for mv88e6393x family of Marvell
Date:   Tue, 12 Jan 2021 20:53:59 +0100
Message-Id: <20210112195405.12890-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is version 15 of patches adding support for Amethyst family to
mv88e6xxx. It should apply cleanly on net-next.

This series is tested on Marvell CN9130-CRB.

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
 drivers/net/dsa/mv88e6xxx/chip.c              | 227 ++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.c           |  19 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 397 ++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/port.h              |  50 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 394 +++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h            | 108 +++--
 include/linux/phy.h                           |   4 +
 12 files changed, 1073 insertions(+), 163 deletions(-)


base-commit: c73a45965dd54a10c368191804b9de661eee1007
-- 
2.26.2

