Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5403E132A4E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgAGPpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:45:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55185 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgAGPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A43FA21B2A;
        Tue,  7 Jan 2020 10:45:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sXs6y3fRAURypMciO
        R4uh+IPPhnOQhxrCWWr7KyR6Os=; b=lUeIox/bOWFSNEDZKnFoTIFSqajVfNZqx
        aMZfgEPX/oydPNiZgStgfZJFHAvSbiE3qcNI3wpNZXFHcV0zHbHplfe5Hbw3yNrR
        wd1Awo/FJGnwgxiOcHPbUkXb65zwWe8BCr2jQlo9nmj4Jrl5wxVMlxyvH/wOwG7O
        aBdwOpdhQdzVss6keCivZ+TTnIi3kmp2m+MkuJTCAZ5T88lM5UmQAJmr6jQ1tgyt
        ZMyjNirfCDH18vWyqRtpc4N2QT6pZ4/mwOKmIoFyVNcSchED25ydCBJQTmTUj0WC
        A0rsXgrmZa4PhPM1IEeqMX3ijHpUlSsgqjQsbxZbQmsZGjcKDyRFA==
X-ME-Sender: <xms:q6cUXnFnsBVAm5dsky1R9VxmEH10YASnSuAwsBFi0sBJY7apFXJn-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:q6cUXqHWXf7BnGRtvJuaevD1tqEKzAOpzHTzQJEnDm4okY8Wz7NAVw>
    <xmx:q6cUXv-pY4zrqBMMD6kvGA5pLU33V1Jn5w5BkyuViRByrntSSCSZPw>
    <xmx:q6cUXsQSz-XdHk6mNhkCYXuk9CCRoWjub4RcpEJBCNVv6k3OaZkN9w>
    <xmx:q6cUXpaX0N3WB40D2TsO2Y63nqyuMUVxe90AObksgyn51HDnQxqD-Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB5888005C;
        Tue,  7 Jan 2020 10:45:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/10] net: Add route offload indication
Date:   Tue,  7 Jan 2020 17:45:07 +0200
Message-Id: <20200107154517.239665-1-idosch@idosch.org>
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
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 233 +++--
 drivers/net/netdevsim/fib.c                   | 664 ++++++++++++-
 include/net/ip6_fib.h                         |  11 +-
 include/net/ip_fib.h                          |   4 +
 include/uapi/linux/rtnetlink.h                |   2 +
 net/ipv4/fib_lookup.h                         |  20 +-
 net/ipv4/fib_semantics.c                      |  33 +-
 net/ipv4/fib_trie.c                           |  81 +-
 net/ipv4/route.c                              |  31 +-
 net/ipv6/route.c                              |   7 +
 .../selftests/drivers/net/mlxsw/fib.sh        | 180 ++++
 .../selftests/drivers/net/netdevsim/fib.sh    | 341 +++++++
 .../net/forwarding/fib_offload_lib.sh         | 873 ++++++++++++++++++
 14 files changed, 2352 insertions(+), 129 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/fib.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib.sh
 create mode 100644 tools/testing/selftests/net/forwarding/fib_offload_lib.sh

-- 
2.24.1

