Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41DE91087
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfHQNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:18 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54623 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbfHQNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A6090C33;
        Sat, 17 Aug 2019 09:30:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bV+b8cLBImpF7sn6E
        vObfLthD0YXK0k/wQfm4TpqfYY=; b=iMDVIUv6VXRy1sW3J2M8XdvBuQkstkUH9
        fj3YQ+1tdR9vyN3jzjQ7IfnG3DJ8tmiq8lieKdfR7Aorw0pXor3VO36E3nKYAaMJ
        HBZnZDkPH29AqGjt5addGGceFCeY6FoZ6SYNWEwKLGkUh1hck79LcLhLAr35RzVe
        lcw84NoeFYr3rOI+UYGC4YRy8j6dbvXri+Qw53w2Gxx6qiYz8a954oVQFdWCn0sc
        Drfl+D4LZ9dp73i1jkXu7w53OHNo6iue9LVeBVrO/GGKwE9cpAbRUoGurLDzfAq0
        ONPNqqx/zawwPrbVc+jXy/crx0HYBmk8GBVKLtlNMz7b1ktQN7yDw==
X-ME-Sender: <xms:ZQFYXaEyLE2RxO_XJ_D0QGZVGZsEl8uXPRnkX4MNMcrZ8MjJfVIAlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:ZQFYXQMMjFgpezKDTmbhqyhrjlop0TG7pVj7WGKRqxn8jKGv2uWFTw>
    <xmx:ZQFYXcsXfGY9wkTvUc38sS25qRwnijHtEFvMn5j-IlV9cK6h1hPPGg>
    <xmx:ZQFYXVXSXfXAXJ965V_IlwP0UxClGlMbPvmKZFNeCv0pyl4yzRoEtw>
    <xmx:aAFYXbr14VdJhbLjbkodbboaCGINv8DQKXFNYpJoNDKUavDnz9YH2w>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87BBE80064;
        Sat, 17 Aug 2019 09:30:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 00/16] Add drop monitor for offloaded data paths
Date:   Sat, 17 Aug 2019 16:28:09 +0300
Message-Id: <20190817132825.29790-1-idosch@idosch.org>
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

Patches #13-#16 add tests for the generic infrastructure over netdevsim.

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

Changes in v3:
* Place test with the rest of the netdevsim tests
* Fix test to load netdevsim module
* Move devlink helpers from the test to devlink_lib.sh. Will be used
  by mlxsw tests
* Re-order netdevsim includes in alphabetical order
* Fix reverse xmas tree in netdevsim
* Remove double include in netdevsim

Changes in v2:
* Use drop monitor to report dropped packets instead of devlink
* Add drop monitor patches
* Add test cases

Ido Schimmel (16):
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
  selftests: forwarding: devlink_lib: Allow tests to define devlink
    device
  selftests: forwarding: devlink_lib: Add devlink-trap helpers
  selftests: devlink_trap: Add test cases for devlink-trap
  Documentation: Add a section for devlink-trap testing

 .../networking/devlink-trap-netdevsim.rst     |   20 +
 Documentation/networking/devlink-trap.rst     |  208 ++++
 Documentation/networking/index.rst            |    2 +
 MAINTAINERS                                   |    1 +
 drivers/net/netdevsim/dev.c                   |  282 ++++-
 drivers/net/netdevsim/netdevsim.h             |    1 +
 include/net/devlink.h                         |  175 +++
 include/net/drop_monitor.h                    |   33 +
 include/uapi/linux/devlink.h                  |   62 +
 include/uapi/linux/net_dropmon.h              |   15 +
 net/Kconfig                                   |    1 +
 net/core/devlink.c                            | 1080 ++++++++++++++++-
 net/core/drop_monitor.c                       |  724 ++++++++++-
 .../drivers/net/netdevsim/devlink_trap.sh     |  364 ++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  189 ++-
 15 files changed, 3116 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink-trap.rst
 create mode 100644 include/net/drop_monitor.h
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh

-- 
2.21.0

