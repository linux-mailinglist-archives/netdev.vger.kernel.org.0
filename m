Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F9C30B0F1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhBAT5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:57:08 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48965 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhBATt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:49:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 27F5E580503;
        Mon,  1 Feb 2021 14:48:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=M9tu9lxb1+yYZxxul
        3MtH+kx9ub4kfRcReMkZAt84II=; b=T70Znt1thjQpvcnI8gK3YX0N3wz05wiTk
        nHoI683SAFApDSZJjW0HfQ1GmCLEseVOkZ9thaXv7PDI9/rOi2ygL0CmpSN571bz
        8YVTwkSouy3aFtHLPeWOSOeIe0fOc38CohJxbF+oukdHODQVFOqJSBEMzMIJ1b9T
        9bkmbNQawSobr3iBHLL8rWtVnV+vDK1kvKeFuAXwmZnpQZvRFjDyJ5Y5ol5yiIyi
        977JW+U367TJDdPDaJIXffgFYTkfstSs9s9ScNtDCRGvOYDi+ADuFeN+cb9bSzo1
        EaiQJVockASKdrBYhu8DysciGyi3CrS0AdQ9KUA1r6xRUgLEQ61gg==
X-ME-Sender: <xms:FlsYYA3m1iShNUnnRLkBCN1kPBwgwaKQKuKKeDpTSLUObhkAx0vd9A>
    <xme:FlsYYLG9IWQAQkjKtYcOTgP3g8IuMOoXVcjuFQK3xNdJRpzTO9VLnr7dfjC-V5BOJ
    i8TNhRjyL7Io2I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FlsYYI4iV0f-SVFP_lF2SCCYrd6i3Jafl5ij0igiJNww5wf2XtSl1Q>
    <xmx:FlsYYJ228Oz7_ZpQ-L5hRnndOdHVg5cahzeiWa4L0c4dq2Texik_sQ>
    <xmx:FlsYYDGTjuHeaH1nSaBkeWkIHTeaK6OdNqTTuP0ONr7sTa901bVULQ>
    <xmx:F1sYYJbKa-tvYuO86NYiXV-yOCSq_3QJ_ntswJc4qy369ixp_RNUKA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71EB724005E;
        Mon,  1 Feb 2021 14:48:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/10] Add notifications when route hardware flags change
Date:   Mon,  1 Feb 2021 21:47:47 +0200
Message-Id: <20210201194757.3463461-1-idosch@idosch.org>
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

v2:
* Patch #1: Use atomic64_sub() in nsim_nexthop_account()'s error path

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
 drivers/net/netdevsim/fib.c                   | 534 ++++++++++++------
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
 17 files changed, 854 insertions(+), 182 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh

-- 
2.29.2

