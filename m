Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FFB1919FF
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgCXTeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:05 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:45401 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgCXTeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8C2645800D2;
        Tue, 24 Mar 2020 15:34:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Y5fbqbyhC9nHikAys
        vR5xHYyu26K6qCHhuZSJqKdWWU=; b=VaQeZuqi+cgBkI02D5lnKxWYzwIuSrbug
        m3Fx+5HTqnJe38a3dn3yQRYRcnQHOOFX4LWNrCAX4Hf8eVFUebkO++XKVJKkUfDS
        BHsWXSFE2rtxphKf0PR0ilgTc03qScHpPxV8B2vMajaonpQiNo0PLkSYkBDbQssg
        0OSPz4I3DzZtsCAb1lq/jTKzO0itSzmNnrRgevY5XDZileIULCUPnYICvC3sBvpN
        vOvzsumYU4LODNUG3y1KBui9bsqSzieNrADgqU71nIfi/RiPzw4y55vthJb9LYuv
        ++2STlL7r/6MNfMAPge3JEJzvs9WI0xCOEt9UEJJCMEl4iHKSDtrA==
X-ME-Sender: <xms:rGB6XnFbAUCYCM6EfsDEPnPs5ZIHs0RCYiOvQNa7yjDSxbokzcRAhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:rGB6XruRJCy4LgJkgTi29RB1rMjj928NucGrT9TqXJhQG2-QRBbq2A>
    <xmx:rGB6XiHdAnbQe3uEYTw8Qa9HRIqR3oPO5fosSBDjrbuJF71ycgujOw>
    <xmx:rGB6Xjs5_0rpxbUS40zUloR-wS7VmMWB5krq_BMbVvNw9dXuvjGRQw>
    <xmx:rGB6Xj5roaTJuicwrU-UQbse4v9nwpsdj6THhJ06SYvqydbZJGYTog>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE69E3065930;
        Tue, 24 Mar 2020 15:33:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/15] Add packet trap policers support
Date:   Tue, 24 Mar 2020 21:32:35 +0200
Message-Id: <20200324193250.1322038-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Background
==========

Devices capable of offloading the kernel's datapath and perform
functions such as bridging and routing must also be able to send (trap)
specific packets to the kernel (i.e., the CPU) for processing.

For example, a device acting as a multicast-aware bridge must be able to
trap IGMP membership reports to the kernel for processing by the bridge
module.

Motivation
==========

In most cases, the underlying device is capable of handling packet rates
that are several orders of magnitude higher compared to those that can
be handled by the CPU.

Therefore, in order to prevent the underlying device from overwhelming
the CPU, devices usually include packet trap policers that are able to
police the trapped packets to rates that can be handled by the CPU.

Proposed solution
=================

This patch set allows capable device drivers to register their supported
packet trap policers with devlink. User space can then tune the
parameters of these policers (currently, rate and burst size) and read
from the device the number of packets that were dropped by the policer,
if supported.

These packet trap policers can then be bound to existing packet trap
groups, which are used to aggregate logically related packet traps. As a
result, trapped packets are policed to rates that can be handled the
host CPU.

Example usage
=============

Instantiate netdevsim:
# echo "10 1" > /sys/bus/netdevsim/new_device

Dump available packet trap policers:
# devlink trap policer show
netdevsim/netdevsim10:
  policer 1 rate 1000 burst 128
  policer 2 rate 2000 burst 256
  policer 3 rate 3000 burst 512

Change the parameters of a packet trap policer:
# devlink trap policer set netdevsim/netdevsim10 policer 3 rate 100 burst 16

Bind a packet trap policer to a packet trap group:
# devlink trap group set netdevsim/netdevsim10 group acl_drops policer 3

Dump parameters and statistics of a packet trap policer:
# devlink -s trap policer show netdevsim/netdevsim10 policer 3
netdevsim/netdevsim10:
  policer 3 rate 100 burst 16
    stats:
        rx:
          dropped 92

Unbind a packet trap policer from a packet trap group:
# devlink trap group set netdevsim/netdevsim10 group acl_drops nopolicer

Patch set overview
==================

Patch #1 adds the core infrastructure in devlink which allows capable
device drivers to register their supported packet trap policers with
devlink.

Patch #2 extends the existing devlink-trap documentation.

Patch #3 extends netdevsim to register a few dummy packet trap policers
with devlink. Used later on to selftests the core infrastructure.

Patches #4-#5 adds infrastructure in devlink to allow binding of packet
trap policers to packet trap groups.

Patch #6 extends netdevsim to allow such binding.

Patch #7 adds a selftest over netdevsim that verifies the core
devlink-trap policers functionality.

Patches #8-#14 gradually add devlink-trap policers support in mlxsw.

Patch #15 adds a selftest over mlxsw. All registered packet trap
policers are verified to handle the configured rate and burst size.

Future plans
============

* Allow changing default association between packet traps and packet
  trap groups
* Add more packet traps. For example, for control packets (e.g., IGMP)

Ido Schimmel (15):
  devlink: Add packet trap policers support
  Documentation: Add description of packet trap policers
  netdevsim: Add devlink-trap policer support
  devlink: Add packet trap group parameters support
  devlink: Allow setting of packet trap group parameters
  netdevsim: Add support for setting of packet trap group parameters
  selftests: netdevsim: Add test cases for devlink-trap policers
  mlxsw: reg: Extend QPCR register
  mlxsw: spectrum: Track used packet trap policer IDs
  mlxsw: spectrum_trap: Prepare policers for registration with devlink
  mlxsw: spectrum_trap: Add devlink-trap policer support
  mlxsw: spectrum_trap: Do not initialize dedicated discard policer
  mlxsw: spectrum_trap: Switch to use correct packet trap group
  mlxsw: spectrum_trap: Add support for setting of packet trap group
    parameters
  selftests: mlxsw: Add test cases for devlink-trap policers

 .../networking/devlink/devlink-trap.rst       |  26 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  71 +++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  14 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  50 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  17 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 354 +++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  24 +
 drivers/net/netdevsim/dev.c                   | 121 ++++-
 drivers/net/netdevsim/netdevsim.h             |   2 +
 include/net/devlink.h                         |  77 ++-
 include/uapi/linux/devlink.h                  |  11 +
 net/core/devlink.c                            | 477 ++++++++++++++++++
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 384 ++++++++++++++
 .../drivers/net/netdevsim/devlink_trap.sh     | 110 ++++
 .../selftests/net/forwarding/devlink_lib.sh   |  43 ++
 16 files changed, 1751 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh

-- 
2.24.1

