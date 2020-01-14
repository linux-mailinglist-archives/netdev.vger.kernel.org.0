Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9013013A84F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgANLXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58497 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C188C21CDA;
        Tue, 14 Jan 2020 06:23:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4qeepVl+mJ+5M96Pp
        EBucvf/SG9AddaS0m/YouznpbA=; b=M77va7Wu6Ncg2UmebiaM4ubuozajPdub9
        Gtxy2/gGsdVV8KUjijnzyif06rtKN775Mf/zB4j/ju1h95dalxno7WBqH6rlJQuB
        ecEJa7vF3Fcr9QFKwliZgeseyXqkqyqHGvVxFfuchu3AoA/RqUF6mGaEWWfDSsH3
        YDqWg7PtMF9ZfPsNiTaJo9My124B+pY0Z3txbX5a8BrkNBhOiNhxUQWmufuLrx6e
        69jhrSS+vPrFsBK1zjV0G3Vcyj6/rCffCPaK8P14s8/3x7eBB4rCfU+qUgjvh8/T
        ngoLD8lWjkwbF8fbecBe/qZQNQb+XWMPfOzqR8sVL3YQwL/aePIiA==
X-ME-Sender: <xms:wKQdXs55uviIh8Bc4t74We_WsWkMBlo6F9uH6KdrlgSWTIeQlcaltQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduleefrdegje
    drudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wKQdXm62M7Z-_G0o78usfPBDx-ysC_YlmHWR8WJ87OQ-Jfg6YlmWng>
    <xmx:wKQdXlKUMFJJ4tAFDrHWKxutrTHCtwHd1eAgsLdWxVdPVPTZSNmDMA>
    <xmx:wKQdXoEi1Z8Kmsjg8leQ6rc48zsHt4-K-6eqBIoAVEteIjI0x5avvQ>
    <xmx:wKQdXrDOFKbj2rc5Gm1mTLgV6AgrxPjr6YG4TonOU4KKDI7qR1WR0w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E51A48005A;
        Tue, 14 Jan 2020 06:23:42 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/10] net: Add route offload indication
Date:   Tue, 14 Jan 2020 13:23:08 +0200
Message-Id: <20200114112318.876378-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set adds offload indication to IPv4 and IPv6 routes. So far
offload indication was only available for the nexthop via
'RTNH_F_OFFLOAD', which is problematic as a nexthop is usually shared
between multiple routes.

Based on feedback from Roopa and David on the RFC [1], the indication is
split to 'offload' and 'trap'. This is done because not all the routes
present in hardware actually offload traffic from the kernel. For
example, host routes merely trap packets to the kernel. The two flags
are dumped to user space via the 'rtm_flags' field in the ancillary
header of the rtnetlink message.

In addition, the patch set uses the new flags in order to test the FIB
offload API by adding a dummy FIB offload implementation to netdevsim.
The new tests are added to a shared library and can be therefore shared
between different drivers.

Patches #1-#3 add offload indication to IPv4 routes.
Patches #4 adds offload indication to IPv6 routes.
Patches #5-#6 add support for the offload indication in mlxsw.
Patch #7 adds dummy FIB offload implementation in netdevsim.
Patches #8-#10 add selftests.

v2 (feedback from David Ahern):
* Patch #2: Name last argument of fib_dump_info()
* Patch #2: Move 'struct fib_rt_info' to include/net/ip_fib.h so that it
  could later be passed to fib_alias_hw_flags_set()
* Patch #3: Make use of 'struct fib_rt_info' in fib_alias_hw_flags_set()
* Patch #6: Convert to new fib_alias_hw_flags_set() interface
* Patch #7: Convert to new fib_alias_hw_flags_set() interface

[1] https://patchwork.ozlabs.org/cover/1170530/

Ido Schimmel (10):
  ipv4: Replace route in list before notifying
  ipv4: Encapsulate function arguments in a struct
  ipv4: Add "offload" and "trap" indications to routes
  ipv6: Add "offload" and "trap" indications to routes
  mlxsw: spectrum_router: Separate nexthop offload indication from route
  mlxsw: spectrum_router: Set hardware flags for routes
  netdevsim: fib: Add dummy implementation for FIB offload
  selftests: forwarding: Add helpers and tests for FIB offload
  selftests: netdevsim: Add test for FIB offload API
  selftests: mlxsw: Add test for FIB offload API

 drivers/net/Kconfig                           |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 246 +++--
 drivers/net/netdevsim/fib.c                   | 671 +++++++++++++-
 include/net/ip6_fib.h                         |  11 +-
 include/net/ip_fib.h                          |  13 +
 include/uapi/linux/rtnetlink.h                |   2 +
 net/ipv4/fib_lookup.h                         |   8 +-
 net/ipv4/fib_semantics.c                      |  33 +-
 net/ipv4/fib_trie.c                           |  77 +-
 net/ipv4/route.c                              |  31 +-
 net/ipv6/route.c                              |   7 +
 .../selftests/drivers/net/mlxsw/fib.sh        | 180 ++++
 .../selftests/drivers/net/netdevsim/fib.sh    | 341 +++++++
 .../net/forwarding/fib_offload_lib.sh         | 873 ++++++++++++++++++
 14 files changed, 2365 insertions(+), 129 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/fib.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib.sh
 create mode 100644 tools/testing/selftests/net/forwarding/fib_offload_lib.sh

-- 
2.24.1

