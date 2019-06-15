Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701974704A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfFOOJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38351 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8DAA221F30;
        Sat, 15 Jun 2019 10:09:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iF6SUlAtjbzkFHE07
        rEUu0VfibIiE/NTYE3nlnZCUoE=; b=jzUJdtg3nB0Q2RP29uHyDvSqGHAU8AeNl
        hdyJDrhYumcw38dIJV7MITzj/JSz50qD4DI/nDHlERk8YlYXxVOUmoM4TFleU5is
        fXjy5jQe8ZK4JbRtbI9nwxpcXkfEaqL76mosVFQhlHvQ652db592ad18cGGBDHNl
        GZ+k5D55HMmi6tKZ8AbEAOrwN7Rb1iQnRitxRYr7HU1OG5Tby8WzftYCIyzpcyJZ
        XCbV3GYm0wQIfG0PKIDREB3752tPro0B1GWfYrwcuBAsClZvhT+AfQWgVx9fKENW
        +quN+NfeI3j2qwmQsgQ1r2OY6xnua8QfLNX7RZRNLGuasux6wEyhg==
X-ME-Sender: <xms:AvwEXeoHKJTxdbsxPqUmpYZBX2cUAJQMhZ_Y5Uk6v0GHIZd-WZ1wug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:AvwEXQ-Gd-Gm7Qkl0hZ-D_DcX4tdndWasGdCtQ5392rmi2NIspaydg>
    <xmx:AvwEXSVBvtWgKcU_GW5nlxNHX4_IbJbzigU6Hu73oNy6n7cP8VmvzQ>
    <xmx:AvwEXWDydsZD_nTo681HGEGgggr762sLde-PcaKUn0rnTSrX6d_QJA>
    <xmx:A_wEXR_4o9pjud0KHy30lWMBVqnnv21AJKwNf89OssnOJ2uxBG4f_g>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5604380085;
        Sat, 15 Jun 2019 10:09:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/17] mlxsw: Improve IPv6 route insertion rate
Date:   Sat, 15 Jun 2019 17:07:34 +0300
Message-Id: <20190615140751.17661-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Unlike IPv4, an IPv6 multipath route in the kernel is composed from
multiple sibling routes, each representing a single nexthop.

Therefore, an addition of a multipath route with N nexthops translates
to N in-kernel notifications. This is inefficient for device drivers
that need to program the route to the underlying device. Each time a new
nexthop is appended, a new nexthop group needs to be constructed and the
old one deleted.

This patchset improves the situation by sending a single notification
for a multipath route addition / deletion instead of one per-nexthop.
When adding thousands of multipath routes with 16 nexthops, I measured
an improvement of about x10 in the insertion rate.

Patches #1-#3 add a flag that indicates that in-kernel notifications
need to be suppressed and extend the IPv6 FIB notification info with
information about the number of sibling routes that are being notified.

Patches #4-#5 adjust the two current listeners to these notifications to
ignore notifications about IPv6 multipath routes.

Patches #6-#7 adds add / delete notifications for IPv6 multipath routes.

Patch #8 teaches netdevsim to handle such notifications.

Patches #9-#15 do the same for mlxsw.

Patch #16 finally removes the limitations added in patches #4-#5 and
stops the kernel from sending a notification for each added / deleted
nexthop.

Patch #17 adds test cases.

Ido Schimmel (17):
  netlink: Document all fields of 'struct nl_info'
  netlink: Add field to skip in-kernel notifications
  ipv6: Extend notifier info for multipath routes
  mlxsw: spectrum_router: Ignore IPv6 multipath notifications
  netdevsim: Ignore IPv6 multipath notifications
  ipv6: Add IPv6 multipath notifications for add / replace
  ipv6: Add IPv6 multipath notification for route delete
  netdevsim: Adjust accounting for IPv6 multipath notifications
  mlxsw: spectrum_router: Remove processing of IPv6 append notifications
  mlxsw: spectrum_router: Prepare function to return errors
  mlxsw: spectrum_router: Pass multiple routes to work item
  mlxsw: spectrum_router: Adjust IPv6 replace logic to new notifications
  mlxsw: spectrum_router: Pass array of routes to route handling
    functions
  mlxsw: spectrum_router: Add / delete multiple IPv6 nexthops
  mlxsw: spectrum_router: Create IPv6 multipath routes in one go
  ipv6: Stop sending in-kernel notifications for each nexthop
  selftests: mlxsw: Add a test for FIB offload indication

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 210 ++++++++---
 drivers/net/netdevsim/fib.c                   |  17 +-
 include/net/ip6_fib.h                         |   7 +
 include/net/netlink.h                         |   6 +-
 net/ipv6/ip6_fib.c                            |  45 ++-
 net/ipv6/route.c                              |  21 ++
 .../drivers/net/mlxsw/fib_offload.sh          | 349 ++++++++++++++++++
 7 files changed, 582 insertions(+), 73 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/fib_offload.sh

-- 
2.20.1

