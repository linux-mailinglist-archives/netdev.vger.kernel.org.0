Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55882F0ABB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 02:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbhAKBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 20:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbhAKBWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 20:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0622C2229C;
        Mon, 11 Jan 2021 01:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610328125;
        bh=3fqdgltTKIeGvQSsORijncJpvjwFlX41m9PTvSptScs=;
        h=From:To:Cc:Subject:Date:From;
        b=Y60cvAquvfjQIV3gB5AaaYOmGk3M9e1yDD45XRClcc4SG0FyxUZxScvP7Jy3IxoQV
         P4VBWaPlbwQ1zPHlydZuIcCgkcm6N/vuK1YVQAZiVw6ZDdcxhc03KX+kcEBsgmgfCy
         yPJIS3bMqmA2RR0y0YvlaHPJBfDctaxHoC6k7Tn/mx6qettTaeX+XOy28Yygj9dfSS
         xeaBdnR87BFD709zt5VcI6rpAcrervjwDMsePq6VHW5r1XfAi85ftvSpK5/fiQ9IGC
         ikaKm7F4DqaXm5P/eggbU/5J2c4zuT6faaSHaQ2WJLUiIdGloZ212giT8P0fRK2UmJ
         rAroE85nHBf0A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v14 0/6] Add support for mv88e6393x family of Marvell
Date:   Mon, 11 Jan 2021 02:21:50 +0100
Message-Id: <20210111012156.27799-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

so I took Pavana's patches for Amethyst and did some more work on this.
I am sending version 14, which should apply cleanly on net-next.

This series is tested on Marvell CN9130-CRB.

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
 drivers/net/dsa/mv88e6xxx/chip.c              | 227 ++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.c           |  19 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 398 ++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/port.h              |  50 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 398 ++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h            | 108 +++--
 include/linux/phy.h                           |   4 +
 11 files changed, 1072 insertions(+), 163 deletions(-)


base-commit: 73b7a6047971aa6ce4a70fc4901964d14f077171
-- 
2.26.2

