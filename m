Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E62C686
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfE1Mb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:28 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49503 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727147AbfE1MbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0A0C81CE5;
        Tue, 28 May 2019 08:22:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SG1RlAKirPJcfQ27g
        TXq0oWg9C6ESoQoq2S939ROZyY=; b=sX8NjAuamrZHSV190q5sVZhPS8uPx0unf
        T9FARUUSMl46BVp/frBbfZE1Y6YY4zrV88lezJ5PymFlVG8JmdWiG88OkZPb7lDA
        vz9T4aq3bIAOuonRCcWYd4/M4eWPcXEL9zHOBx5rsB2+AZ5zByMkuVjp7RetPLEL
        dI+1BFzHBF/ySr0no4SyYvxOh896mvDDB+5rVdO/3gtA6XqlTkChGZC0v0DkxOqG
        3Ed/WOaYHDIUhCiLVMWgGAxynDd90w8CkIcxb64Gw0N1s+PkdzOjxY1ydKIsfsmH
        fkNJqC/+uvma51Fe/CdiqzePlo6oB9WybwlblXi/bqlPFpFXOYsFw==
X-ME-Sender: <xms:CCjtXB7Aaui1QJqmKKZUIzTnNzeolZC74fc1QfOG8DjhgCZOrTzxzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:CSjtXLW2rGZSWNAuOEdSrirxnWspJMYk4L1cjKL2I8QQJfoNPKImAA>
    <xmx:CSjtXEd9z6fCPJ_YKAHsNbqJT-1F91cOs7K3or275Q7Yjri3po3I_g>
    <xmx:CSjtXLnM4t_VaHD2CJUDIwT68TxzPPykqDiAyFIlx2tDMqjCquNQ0w>
    <xmx:CijtXLAgCxmJVe_DGhVPgzbdV_FHjKD1YteUG-R9ZBTbOx-d0XqLjg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7276F380087;
        Tue, 28 May 2019 08:22:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 00/12] Add drop monitor for offloaded data paths
Date:   Tue, 28 May 2019 15:21:24 +0300
Message-Id: <20190528122136.30476-1-idosch@idosch.org>
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
  name ingress_smac_mc_drop type drop generic true report false action drop group l2_drops
  name ingress_vlan_tag_allow_drop type drop generic true report false action drop group l2_drops
  name ingress_vlan_filter_drop type drop generic true report false action drop group l2_drops
  name ingress_stp_filter_drop type drop generic true report false action drop group l2_drops
  name uc_empty_tx_list_drop type drop generic true report false action drop group l2_drops
  name mc_empty_tx_list_drop type drop generic true report false action drop group l2_drops
  name uc_loopback_filter_drop type drop generic true report false action drop group l2_drops
  name fid_miss_exception type exception generic false report false action trap group l2_drops
  name blackhole_route_drop type drop generic true report false action drop group l3_drops
  name ttl_error_exception type exception generic true report false action trap group l3_drops
  name tail_drop type drop generic true report false action drop group buffer_drops
  name early_drop type drop generic true report false action drop group buffer_drops

Enable a trap
-------------

# devlink trap set netdevsim/netdevsim10 trap blackhole_route_drop action trap report true

Query statistics
----------------

# devlink -s trap show netdevsim/netdevsim10 trap blackhole_route_drop
netdevsim/netdevsim10:
  name blackhole_route_drop type drop generic true report true action trap group l3_drops
    stats:
        rx:
          bytes 2272 packets 16

Monitor dropped packets
-----------------------

# devlink -v mon trap-report
[trap-report,report] netdevsim/netdevsim10: name blackhole_route_drop type drop group l3_drops length 146 timestamp Tue May 28 15:02:26 2019 153282944 nsec
  input_port:
    netdevsim/netdevsim10/0: type eth netdev eth0

TODO
====

* Add selftests
* Write a man page for devlink-trap

Future plans
============

* Write a Wireshark dissector
* Provide eBPF programs that show how drops are distributed between different
  flows
* Provide more drop reasons as well as more metadata

Ido Schimmel (12):
  devlink: Create helper to fill port type information
  devlink: Add packet trap infrastructure
  devlink: Add generic packet traps and groups
  Documentation: Add devlink-trap documentation
  netdevsim: Add devlink-trap support
  Documentation: Add description of netdevsim traps
  mlxsw: pci: Query and store PCIe bandwidth during init
  mlxsw: core: Add API to set trap action
  mlxsw: reg: Add new trap action
  mlxsw: Add layer 2 discard trap IDs
  mlxsw: Add trap group for layer 2 discards
  mlxsw: spectrum: Add devlink-trap support

 .../networking/devlink-trap-netdevsim.rst     |   20 +
 Documentation/networking/devlink-trap.rst     |  200 +++
 Documentation/networking/index.rst            |    2 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   64 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   13 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |    2 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   10 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   17 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   13 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  245 +++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |    7 +
 drivers/net/netdevsim/dev.c                   |  273 +++-
 drivers/net/netdevsim/netdevsim.h             |    1 +
 include/net/devlink.h                         |  188 +++
 include/uapi/linux/devlink.h                  |   68 +
 net/core/devlink.c                            | 1314 ++++++++++++++++-
 17 files changed, 2412 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink-trap.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c

-- 
2.20.1

