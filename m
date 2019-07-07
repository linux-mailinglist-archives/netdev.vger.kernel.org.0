Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA506144B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 09:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGGH7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 03:59:52 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:34355 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbfGGH7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 03:59:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id CA6DD2663;
        Sun,  7 Jul 2019 03:59:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 03:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vMhwabHkb/nc0cEgz
        MWAcNzE8UsW5rbapeQfp8FFajI=; b=yJLQQjPDBnROEWaPo3M7YKxj6ZcViMJZ0
        r+OkBxQsCf1SPLg48uMZZxbh7DBM8OC6ok2XjE+lFmcYXKbhKXlqgcd9/eRFa0Ob
        eXXozyu0yXuFX0PcOrYHQwmh4CwpAJv9X0YE5Rm9gztOh7QbdrMau0I0pWfPwcOQ
        x4WzalYUVc24trDIe036paH67QBvwXldjAX5OS+9Apeb+toOb89LjTjlUQR71pia
        +SO7ehpdNh/aKaByYH40kaphuA2/mv8zfq1eR2nIwoVR2hrEFIpEiLbB+Z0qPF4P
        OehscI22lNef7nUjFDB3+2e/RKy3PksglRL8SXHwHELMkzXYfzOIA==
X-ME-Sender: <xms:daYhXQPGF-YFCZX3OGCKW27xoXaItHPaJ-Wiahvlyr587d4gd0EhZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:daYhXQrkVlYpisoeKe8QkfWtlf7_V2vuRE4s5fWh-RLsYilE98Q7ZQ>
    <xmx:daYhXWlVebju6t1j1iuQAmHijftMxpszlgLsjxvFPL0nMJg30-e-NQ>
    <xmx:daYhXQzSMmmf2KFUm8CAbdWciwap3xgIbJExNGxT2u7Tt4xQ81LW3A>
    <xmx:dqYhXe5oIRmqAQB8CQawKNTDOQyvWCIFHsY_tlzA_cNUncmuLqWwmA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E187C380074;
        Sun,  7 Jul 2019 03:59:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Date:   Sun,  7 Jul 2019 10:58:17 +0300
Message-Id: <20190707075828.3315-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Users have several ways to debug the kernel and understand why a packet
was dropped. For example, using "drop monitor" and "perf". Both
utilities trace kfree_skb(), which is the function called when a packet
is freed as part of a failure. The information provided by these tools
is invaluable when trying to understand the cause of a packet loss.

In recent years, large portions of the kernel data path were offloaded
to capable devices. Today, it is possible to perform L2 and L3
forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
Different TC classifiers and actions are also offloaded to capable
devices, at both ingress and egress.

However, when the data path is offloaded it is not possible to achieve
the same level of introspection as tools such "perf" and "drop monitor"
become irrelevant.

This patchset aims to solve this by allowing users to monitor packets
that the underlying device decided to drop along with relevant metadata
such as the drop reason and ingress port.

The above is achieved by exposing a fundamental capability of devices
capable of data path offloading - packet trapping. While the common use
case for packet trapping is the trapping of packets required for the
correct functioning of the control plane (e.g., STP, BGP packets),
packets can also be trapped due to other reasons such as exceptions
(e.g., TTL error) and drops (e.g., blackhole route).

Given this ability is not specific to a port, but rather to a device, it
is exposed using devlink. Each capable driver is expected to register
its supported packet traps with devlink and report trapped packets to
devlink as they income. devlink will perform accounting of received
packets and bytes and will potentially generate an event to user space
using a new generic netlink multicast group.

While this patchset is concerned with traps corresponding to dropped
packets, the interface itself is generic and can be used to expose traps
corresponding to control packets in the future. The API is vendor
neutral and similar to the API exposed by SAI which is implemented by
several vendors already.

The implementation in this patchset is on top of both mlxsw and
netdevsim so that people could experiment with the interface and provide
useful feedback.

Patches #1-#4 add the devlink-trap infrastructure.

Patches #5-#6 add an example implementation of netdevsim.

Patches #7-#11 add a real world implementation over mlxsw.

Tests for both the core infrastructure (over netdevsim) and mlxsw will
be sent separately as RFC as they are dependent on the acceptance of the
iproute2 changes.

Example
=======

Instantiate netdevsim
---------------------

# echo "10 1" > /sys/bus/netdevsim/new_device
# ip link set dev eth0 up

List supported traps
--------------------

# devlink trap show
netdevsim/netdevsim10:
  name source_mac_is_multicast type drop generic true report false action drop group l2_drops
  name vlan_tag_mismatch type drop generic true report false action drop group l2_drops
  name ingress_vlan_filter type drop generic true report false action drop group l2_drops
  name ingress_spanning_tree_filter type drop generic true report false action drop group l2_drops
  name port_list_is_empty type drop generic true report false action drop group l2_drops
  name port_loopback_filter type drop generic true report false action drop group l2_drops
  name fid_miss type exception generic false report false action trap group l2_drops
  name blackhole_route type drop generic true report false action drop group l3_drops
  name ttl_value_is_too_small type exception generic true report false action trap group l3_drops
  name tail_drop type drop generic true report false action drop group buffer_drops

Enable a trap
-------------

# devlink trap set netdevsim/netdevsim10 trap blackhole_route action trap report true

Query statistics
----------------

# devlink -s trap show netdevsim/netdevsim10 trap blackhole_route
netdevsim/netdevsim10:
  name blackhole_route type drop generic true report true action trap group l3_drops
    stats:
        rx:
          bytes 18744 packets 132

Monitor dropped packets
-----------------------

# devlink -v mon trap-report
[trap-report,report] netdevsim/netdevsim10: name blackhole_route type drop group l3_drops length 142 timestamp Sun Jun 30 20:26:12 2019 835605178 nsec
  input_port:
    netdevsim/netdevsim10/0: type eth netdev eth0

Future plans
============

* Provide more drop reasons as well as more metadata

v1:
* Rename trap names to make them more generic
* Change policer settings in mlxsw

Ido Schimmel (11):
  devlink: Create helper to fill port type information
  devlink: Add packet trap infrastructure
  devlink: Add generic packet traps and groups
  Documentation: Add devlink-trap documentation
  netdevsim: Add devlink-trap support
  Documentation: Add description of netdevsim traps
  mlxsw: core: Add API to set trap action
  mlxsw: reg: Add new trap action
  mlxsw: Add layer 2 discard trap IDs
  mlxsw: Add trap group for layer 2 discards
  mlxsw: spectrum: Add devlink-trap support

 .../networking/devlink-trap-netdevsim.rst     |   20 +
 Documentation/networking/devlink-trap.rst     |  190 +++
 Documentation/networking/index.rst            |    2 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   64 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   12 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   10 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   17 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   13 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  270 ++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |    7 +
 drivers/net/netdevsim/dev.c                   |  273 +++-
 drivers/net/netdevsim/netdevsim.h             |    1 +
 include/net/devlink.h                         |  175 +++
 include/uapi/linux/devlink.h                  |   68 +
 net/core/devlink.c                            | 1312 ++++++++++++++++-
 16 files changed, 2409 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink-trap.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c

-- 
2.20.1

