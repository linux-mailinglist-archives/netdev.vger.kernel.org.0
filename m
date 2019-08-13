Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD888B1A1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfHMHzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:55:51 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50309 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727501AbfHMHzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:55:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id CFA1330F9;
        Tue, 13 Aug 2019 03:55:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/XkXc9khw2AEUQZdt
        HeCu7zEoJKyEzfX2XRGgWizNj0=; b=MOBYzh7Z+PDA0TBLVOiCeJL3emxCP377I
        mbC5+LDK5wgX1ohMD1yodVgupiFWLZutqF6a07G2X6OS+piC/fgWGAVKFq4+khqi
        +WluXdxFBQqEuUk1AjpHQkkSMBU6jnGf9aAh+kfhD8TN5meyG9G6BkqeDv3Bi+Pb
        7U+qgLaJ7thlQZQqxgks9YeNuXdU/TqdqHIltTHhkKVdlGApj6VVtrnUl7T64Ur3
        qjTZ25YWvliwmobcF0ArkXSXhWeWhqUG6SeWHVVF77Q5G3CSwJOf7Q2MSMi0dxy0
        ap50xtAx5No6QMmyUbVLGXl1k6sJuJyhobmpVK2KRIjc66wgEf2Wg==
X-ME-Sender: <xms:_2xSXSQlciBGV7_Y_gJCzB0575r-SseZNPPFAe4r83R6vd_9ovNSnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:_2xSXfc-ycU1y680YHxHPiVphQ6P9FprbSTKDGLkOkb8FQb5tfAycg>
    <xmx:_2xSXSDJo6Wq86kn4P51YRUf5rJQRGGwp-5Wg2nH10LWQ3yt4AshTA>
    <xmx:_2xSXcvnmJ-FMX_U0dxhxGzyK42VaBx7Ggtzesz3EJfcP7aulks8ZA>
    <xmx:Am1SXbAfSye9nxiuMs7LgL4T1JrxioXsXYEDhZSniVkf1u3QEI7cuw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2DF080059;
        Tue, 13 Aug 2019 03:55:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/14] Add drop monitor for offloaded data paths
Date:   Tue, 13 Aug 2019 10:53:46 +0300
Message-Id: <20190813075400.11841-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Users have several ways to debug the kernel and understand why a packet
was dropped. For example, using drop monitor and perf. Both utilities
trace kfree_skb(), which is the function called when a packet is freed
as part of a failure. The information provided by these tools is
invaluable when trying to understand the cause of a packet loss.

In recent years, large portions of the kernel data path were offloaded
to capable devices. Today, it is possible to perform L2 and L3
forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
Different TC classifiers and actions are also offloaded to capable
devices, at both ingress and egress.

However, when the data path is offloaded it is not possible to achieve
the same level of introspection since packets are dropped by the
underlying device and never reach the kernel.

This patchset aims to solve this by allowing users to monitor packets
that the underlying device decided to drop along with relevant metadata
such as the drop reason and ingress port.

The above is achieved by exposing a fundamental capability of devices
capable of data path offloading - packet trapping. In much the same way
as drop monitor registers its probe function with the kfree_skb()
tracepoint, the device is instructed to pass to the CPU (trap) packets
that it decided to drop in various places in the pipeline.

The configuration of the device to pass such packets to the CPU is
performed using devlink, as it is not specific to a port, but rather to
a device. In the future, we plan to control the policing of such packets
using devlink, in order not to overwhelm the CPU.

While devlink is used as the control path, the dropped packets are
passed along with metadata to drop monitor, which reports them to
userspace as netlink events. This allows users to use the same interface
for the monitoring of both software and hardware drops.

Logically, the solution looks as follows:

                                    Netlink event: Packet w/ metadata
                                                   Or a summary of recent drops
                                  ^
                                  |
         Userspace                |
        +---------------------------------------------------+
         Kernel                   |
                                  |
                          +-------+--------+
                          |                |
                          |  drop_monitor  |
                          |                |
                          +-------^--------+
                                  |
                                  |
                                  |
                             +----+----+
                             |         |      Kernel's Rx path
                             | devlink |      (non-drop traps)
                             |         |
                             +----^----+      ^
                                  |           |
                                  +-----------+
                                  |
                          +-------+-------+
                          |               |
                          | Device driver |
                          |               |
                          +-------^-------+
         Kernel                   |
        +---------------------------------------------------+
         Hardware                 |
                                  | Trapped packet
                                  |
                               +--+---+
                               |      |
                               | ASIC |
                               |      |
                               +------+

In order to reduce the patch count, this patchset only includes
integration with netdevsim. A follow-up patchset will add devlink-trap
support in mlxsw.

Patches #1-#7 extend drop monitor to also monitor hardware originated
drops.

Patches #8-#10 add the devlink-trap infrastructure.

Patches #11-#12 add devlink-trap support in netdevsim.

Patches #13-#14 add tests for the generic infrastructure over netdevsim.

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
  name source_mac_is_multicast type drop generic true action drop group l2_drops
  name vlan_tag_mismatch type drop generic true action drop group l2_drops
  name ingress_vlan_filter type drop generic true action drop group l2_drops
  name ingress_spanning_tree_filter type drop generic true action drop group l2_drops
  name port_list_is_empty type drop generic true action drop group l2_drops
  name port_loopback_filter type drop generic true action drop group l2_drops
  name fid_miss type exception generic false action trap group l2_drops
  name blackhole_route type drop generic true action drop group l3_drops
  name ttl_value_is_too_small type exception generic true action trap group l3_drops
  name tail_drop type drop generic true action drop group buffer_drops

Enable a trap
-------------

# devlink trap set netdevsim/netdevsim10 trap blackhole_route action trap

Query statistics
----------------

# devlink -s trap show netdevsim/netdevsim10 trap blackhole_route
netdevsim/netdevsim10:
  name blackhole_route type drop generic true action trap group l3_drops
    stats:
        rx:
          bytes 7384 packets 52

Monitor dropped packets
-----------------------

dropwatch> set alertmode packet
Setting alert mode
Alert mode successfully set
dropwatch> set sw true
setting software drops monitoring to 1
dropwatch> set hw true
setting hardware drops monitoring to 1
dropwatch> start
Enabling monitoring...
Kernel monitoring activated.
Issue Ctrl-C to stop monitoring
drop at: ttl_value_is_too_small (l3_drops)
origin: hardware
input port ifindex: 55
input port name: eth0
timestamp: Mon Aug 12 10:52:20 2019 445911505 nsec
protocol: 0x800
length: 142
original length: 142

drop at: ip6_mc_input+0x8b8/0xef8 (0xffffffff9e2bb0e8)
origin: software
input port ifindex: 4
timestamp: Mon Aug 12 10:53:37 2019 024444587 nsec
protocol: 0x86dd
length: 110
original length: 110

Future plans
============

* Provide more drop reasons as well as more metadata
* Add dropmon support to libpcap, so that tcpdump/tshark could
  specifically listen on dropmon traffic, instead of capturing all
  netlink packets via nlmon interface

Changes in v2:
* Use drop monitor to report dropped packets instead of devlink
* Add drop monitor patches
* Add test cases

Ido Schimmel (14):
  drop_monitor: Move per-CPU data init/fini to separate functions
  drop_monitor: Initialize hardware per-CPU data
  drop_monitor: Add basic infrastructure for hardware drops
  drop_monitor: Consider all monitoring states before performing
    configuration
  drop_monitor: Add support for packet alert mode for hardware drops
  drop_monitor: Add support for summary alert mode for hardware drops
  drop_monitor: Allow user to start monitoring hardware drops
  devlink: Add packet trap infrastructure
  devlink: Add generic packet traps and groups
  Documentation: Add devlink-trap documentation
  netdevsim: Add devlink-trap support
  Documentation: Add description of netdevsim traps
  selftests: devlink_trap: Add test cases for devlink-trap
  Documentation: Add a section for devlink-trap testing

 .../networking/devlink-trap-netdevsim.rst     |   20 +
 Documentation/networking/devlink-trap.rst     |  207 ++++
 Documentation/networking/index.rst            |    2 +
 MAINTAINERS                                   |    1 +
 drivers/net/netdevsim/dev.c                   |  281 ++++-
 drivers/net/netdevsim/netdevsim.h             |    1 +
 include/net/devlink.h                         |  175 +++
 include/net/drop_monitor.h                    |   33 +
 include/uapi/linux/devlink.h                  |   62 +
 include/uapi/linux/net_dropmon.h              |   15 +
 net/Kconfig                                   |    1 +
 net/core/devlink.c                            | 1080 ++++++++++++++++-
 net/core/drop_monitor.c                       |  724 ++++++++++-
 tools/testing/selftests/net/Makefile          |    2 +-
 tools/testing/selftests/net/config            |    1 +
 tools/testing/selftests/net/devlink_trap.sh   |  616 ++++++++++
 16 files changed, 3191 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink-trap.rst
 create mode 100644 include/net/drop_monitor.h
 create mode 100755 tools/testing/selftests/net/devlink_trap.sh

-- 
2.21.0

