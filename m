Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B0A1984A4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgC3TjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:09 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59111 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727714AbgC3TjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 95F50580542;
        Mon, 30 Mar 2020 15:39:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EiveXQopLl4q1QgUC
        9JozplGpiJrbtzxwqslzTdeiZ0=; b=gXfi98MaH8X+6p6BJVnSFGSGb/dQOn/sS
        BIqp3FyBG22BZ1lWggawV2sdUG3FMwXyGLcOXCimEBrtVP2tdKY8dRSmVbSId6vu
        zS687UsezH4Zmqh1wudUnBMSoCjh20GGrwc8tOPW/6VWoBB3rot1v87nUKCDNlxl
        olrhGshYF0M1+BtK+YmQ5s2uly6553TSXwb18mBMxEIL6B47WORKlNYutvY937B1
        Y+aGYg6RB88wNCIhTW9y5lQaKbzyqyxkfzZ3/qvxdceCwxuzUjDKq3e8gsIE+xNe
        lo9LoyIIc5hdxZ8yxA8bVEFKeiJqq68yArYKzrkAzp75DKKbY3+cQ==
X-ME-Sender: <xms:2UqCXiqjnaW8BcR7LOKwxw8Sr9ZGWtNYqZJMbac02ozTlI4CdJ0WxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:2UqCXsJ-PTBXv1f8SASqE7CS2_uUKZEBSZxe18DKivG5eflQ9ZU4jg>
    <xmx:2UqCXuOHvTCX0vv9Vi9X5fgPymqeMb3IKMdfMKbSchDhrlOmTZdL9g>
    <xmx:2UqCXq3T4aAYxzMLHoE1Kxdzwu-Qarawm5IX8K25sMEkBMy47_39CQ>
    <xmx:20qCXmI0bfIbM3IOEJM9ZecaYLK4WZrhYmROFosFrXrNuT2tz9HNzg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E54A306CA4E;
        Mon, 30 Mar 2020 15:39:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 00/15] Add packet trap policers support
Date:   Mon, 30 Mar 2020 22:38:17 +0300
Message-Id: <20200330193832.2359876-1-idosch@idosch.org>
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

v3:
* Rebase

v2 (address comments from Jiri and Jakub):
* Patch #1: Add 'strict_start_type' in devlink policy
* Patch #1: Have device drivers provide max/min rate/burst size for each
  policer. Use them to check validity of user provided parameters
* Patch #3: Remove check about burst size being a power of 2 and instead
  add a debugfs knob to fail the operation
* Patch #3: Provide max/min rate/burst size when registering policers
  and remove the validity checks from nsim_dev_devlink_trap_policer_set()
* Patch #5: Check for presence of 'DEVLINK_ATTR_TRAP_POLICER_ID' in
  devlink_trap_group_set() and bail if not present
* Patch #5: Add extack error message in case trap group was partially
  modified
* Patch #7: Add test case with new 'fail_trap_policer_set' knob
* Patch #7: Add test case for partially modified trap group
* Patch #10: Provide max/min rate/burst size when registering policers
* Patch #11: Remove the max/min validity checks from
  __mlxsw_sp_trap_policer_set()

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
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 336 ++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  24 +
 drivers/net/netdevsim/dev.c                   | 110 +++-
 drivers/net/netdevsim/netdevsim.h             |   3 +
 include/net/devlink.h                         |  90 ++-
 include/uapi/linux/devlink.h                  |  11 +
 net/core/devlink.c                            | 515 +++++++++++++++++-
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 384 +++++++++++++
 .../drivers/net/netdevsim/devlink_trap.sh     | 116 ++++
 .../selftests/net/forwarding/devlink_lib.sh   |  43 ++
 16 files changed, 1778 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh

-- 
2.24.1

