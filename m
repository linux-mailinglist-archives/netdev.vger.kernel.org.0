Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40887303EBB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbhAZN2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:28:19 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43299 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391929AbhAZNZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:25:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4B8B19A4;
        Tue, 26 Jan 2021 08:24:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oEj2lQQ9t5VuaxLOt
        8hmYUIiHw133ZMz+u5Wr39uaSw=; b=rhyoWhrfG1crb23+G7+RDiLoS26LUen+5
        h5MM9C1odtBG2uDtE3xvCVJbJqRlz6ohKeCkpvh66RwriCeiMPyJjLiS2q8zrOUA
        zHyKU/pQ3oxyoS8Gp1wYIrxSaUZoryluBjl0tIKIDcHtFtMNFUOv/UivlHWc3FR4
        VftGTRTPbMCnWOavkumXEM6XQiVCTGZzbwnXfmbsXOUTXm5JdNHCzK1HQ7j6w2oK
        uECxxTR7v2C+pVk7l72vBf3/oWdO06SIwOemrgfe9uNZy7gQ58JgfA/TQio17ONu
        2Fu9JW0Lr15/rtqhuO6qIMZM07to5LHuKz0dcT05q/xzkd19UIhpg==
X-ME-Sender: <xms:-xcQYILYmAGu6bH4wElZAxOuLwqz5o6gkAfgqgmTZMiZtM5lU0eAGg>
    <xme:-xcQYIIXZ5wdGVEmoDQMwpKFTVBqhoNervWbxRqdibEgl3An8pk-awsdszNvX_miC
    pAKH5oU8asxNk0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-xcQYIsmPJbC4PSqKaONh-7Aol_5befqQHGwqvQeN11bCIR24jAZew>
    <xmx:-xcQYFa3RFmmG2hl17glTT32FTpsRzsQ8iRazUoJrs1-9VYjGdm-DA>
    <xmx:-xcQYPYXhZKu5-fhVnVc5rAGVe49IDYGvu04plv66vruWIqXtYoJWw>
    <xmx:-xcQYENi1R_pyuT_Nc0ErdZnk-MX92jARgSM3xfE_mx-RBxHVaNVgw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E928D108005F;
        Tue, 26 Jan 2021 08:24:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] Add notifications when route hardware flags change
Date:   Tue, 26 Jan 2021 15:23:01 +0200
Message-Id: <20210126132311.3061388-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Routes installed to the kernel can be programmed to capable devices, in
which case they are marked with one of two flags. RTM_F_OFFLOAD for
routes that offload traffic from the kernel and RTM_F_TRAP for routes
that trap packets to the kernel for processing (e.g., host routes).

These flags are of interest to routing daemons since they would like to
delay advertisement of routes until they are installed in hardware. This
allows them to avoid packet loss or misrouted packets. Currently,
routing daemons do not receive any notifications when these flags are
changed, requiring them to poll the kernel tables for changes which is
inefficient.

This series addresses the issue by having the kernel emit RTM_NEWROUTE
notifications whenever these flags change. The behavior is controlled by
two sysctls (net.ipv4.fib_notify_on_flag_change and
net.ipv6.fib_notify_on_flag_change) that default to 0 (no
notifications).

Note that even if route installation in hardware is improved to be more
synchronous, these notifications are still of interest. For example, a
multipath route can change from RTM_F_OFFLOAD to RTM_F_TRAP if its
neighbours become invalid. A routing daemon can choose to withdraw /
replace the route in that case. In addition, the deletion of a route
from the kernel can prompt the installation of an identical route
(already in kernel, with an higher metric) to hardware.

For testing purposes, netdevsim is aligned to simulate a "real" driver
that programs routes to hardware.

Series overview:

Patches #1-#2 align netdevsim to perform route programming in a
non-atomic context

Patches #3-#5 add sysctl to control IPv4 notifications

Patches #6-#8 add sysctl to control IPv6 notifications

Patch #9 extends existing fib tests to set sysctls before running tests

Patch #10 adds test for fib notifications over netdevsim

Amit Cohen (10):
  netdevsim: fib: Convert the current occupancy to an atomic variable
  netdevsim: fib: Perform the route programming in a non-atomic context
  net: ipv4: Pass fib_rt_info as const to fib_dump_info()
  net: ipv4: Publish fib_nlmsg_size()
  net: ipv4: Emit notification when fib hardware flags are changed
  net: Pass 'net' struct as first argument to fib6_info_hw_flags_set()
  net: Do not call fib6_info_hw_flags_set() when IPv6 is disabled
  net: ipv6: Emit notification when fib hardware flags are changed
  selftests: Extend fib tests to run with and without flags
    notifications
  selftests: netdevsim: Add fib_notifications test

 Documentation/networking/ip-sysctl.rst        |  40 ++
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  23 +-
 drivers/net/netdevsim/fib.c                   | 535 ++++++++++++------
 include/net/ip6_fib.h                         |   9 +-
 include/net/netns/ipv4.h                      |   2 +
 include/net/netns/ipv6.h                      |   1 +
 net/ipv4/af_inet.c                            |   2 +
 net/ipv4/fib_lookup.h                         |   3 +-
 net/ipv4/fib_semantics.c                      |   4 +-
 net/ipv4/fib_trie.c                           |  27 +
 net/ipv4/sysctl_net_ipv4.c                    |   9 +
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/route.c                              |  44 ++
 net/ipv6/sysctl_net_ipv6.c                    |   9 +
 .../selftests/drivers/net/mlxsw/fib.sh        |  14 +
 .../selftests/drivers/net/netdevsim/fib.sh    |  14 +
 .../net/netdevsim/fib_notifications.sh        | 300 ++++++++++
 17 files changed, 855 insertions(+), 182 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh

-- 
2.29.2

