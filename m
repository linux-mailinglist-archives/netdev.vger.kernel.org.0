Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8B4A4DF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfFRPNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57375 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727105AbfFRPN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EF7322374;
        Tue, 18 Jun 2019 11:13:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DP3NGBDy5I2EoFT7W
        PyI+03/B10tOkJrs1AK2PdUtMQ=; b=lRLtX1LBJmU+n0C0vjGNW48EASPzi1Nmx
        9+nSUEBZifHkpxZR5GKN0+Rj7N42Fx5Ln6Cd0Nc+drnEtxYHZAr4nyku7/5V/ntY
        0uP4Ph/qj6KgJLzCgxfb52ugdwajgLb5h73iYFuWHCnoOmzThjG2iI8sbH3VYRxe
        11U3SzYfI5Jnpo1rD3dJalKNNYuPpqCYnZbZqtsNKEiFcxJxN9Ay5vOUVmgRPx7D
        n7nzq1WYcfZ+AcI1WqxJfclpRjlRpB7LyKcKGd7YifZVUIdJ5XhK58rZgIv+1YzE
        MddPhuSmta/oMRrZ4VJ9xcOG4zoGewlOCoTl2Vlhdxl8+vH0mhtaw==
X-ME-Sender: <xms:l_8IXe_0W5cXBFxrZcw14q3I3mr50fbAuoaiH9TSCdezQYY1XZdCIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:l_8IXRTkPVFdbOTwJ2GFCPVpJ0DhkfxsSju5ea3OKoxuClPgua1kVg>
    <xmx:l_8IXXrp0VNngq4fmvPqCuok0Z1QKsOPNDeCQXfkx0fRxIbBl23smw>
    <xmx:l_8IXWm6KF7tWcw2mhNfbXryFonxEWzJXDu9khb-nq2o11o9WxyGLw>
    <xmx:mP8IXQxZ_A5mlxRY1WoMa22sTYt-2ORcPw7VA6iDXEo1GNyDkY-_Dg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 002C038008B;
        Tue, 18 Jun 2019 11:13:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/16] mlxsw: Improve IPv6 route insertion rate
Date:   Tue, 18 Jun 2019 18:12:42 +0300
Message-Id: <20190618151258.23023-1-idosch@idosch.org>
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

Patches #8-#14 do the same for mlxsw.

Patch #15 finally removes the limitations added in patches #4-#5 and
stops the kernel from sending a notification for each added / deleted
nexthop.

Patch #16 adds test cases.

v2 (David Ahern):
* Remove patch adjusting netdevsim to consume resources for each
  fib6_info. Instead, consume one resource for the entire multipath
  route
* Remove 'multipath_rt' usage in patch #10
* Remove 'multipath_rt' from 'struct fib6_entry_notifier_info' in patch
  #15. The member is only removed in this patch to prevent drivers from
  processing multipath routes twice during the series

Ido Schimmel (16):
  netlink: Document all fields of 'struct nl_info'
  netlink: Add field to skip in-kernel notifications
  ipv6: Extend notifier info for multipath routes
  mlxsw: spectrum_router: Ignore IPv6 multipath notifications
  netdevsim: Ignore IPv6 multipath notifications
  ipv6: Add IPv6 multipath notifications for add / replace
  ipv6: Add IPv6 multipath notification for route delete
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

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 209 ++++++++---
 include/net/ip6_fib.h                         |   6 +
 include/net/netlink.h                         |   6 +-
 net/ipv6/ip6_fib.c                            |  44 ++-
 net/ipv6/route.c                              |  21 ++
 .../drivers/net/mlxsw/fib_offload.sh          | 349 ++++++++++++++++++
 6 files changed, 567 insertions(+), 68 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/fib_offload.sh

-- 
2.20.1

