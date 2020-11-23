Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D12C007E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgKWHOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:07 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51765 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 33EBFF40;
        Mon, 23 Nov 2020 02:14:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=097UPPkWIyX64kjGB
        yJnypJ2lkCFLIbAViTyUaeTTjk=; b=c/g2lNqlccbTjTWglP4L3FyIIKCvS9VNG
        OoAULtN2Xp7eVnRLkSJwMjpLLHX2H00d+frE0clFJqT3fXEcenFytdbVz9f65y7R
        ejXce8ZqGTQY+MOJopo0Lcn8p+vQzXDG4VfrqHvML8CiFRwHIe3XAaVh5AkgTTq8
        ZknIyeqRKA3f/XIZyDQH0NqiUvGtTaUweReaQL2evPK1/Nb//KFTWbDzposxIKt7
        ODPBmKEvR37PHjUGR5I9kwfz8yywKcXcpUJIr+AX0MytwVug5e2gcB3Aq0Tfu6y3
        c1wCyO1XBPRCqRKtN7pPpV2B3z9Patmgnm3C6T+bozdusKQMeZ0Dw==
X-ME-Sender: <xms:PWG7X9JBWevRstCJWLSv_Rs0ypATGx1BI8ZuBChmgHITNLGygAbSxA>
    <xme:PWG7X5LOsXetVTlsnzzi0rhdV-LRDDAMya_n3aVa3Zs_nCVpuZSe3940QOS_Nsb79
    KJKwVwhxFeznDE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheegrddugeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PWG7X1t4RLj0yvXveRrNUYf-LbMoiJ3N_e-dClUjAucR_qX3IS-RGg>
    <xmx:PWG7X-ZsEByZt7f0eiN9RAiz9O0C5cU7YIAHQwhDJcMvKgsl5Uyzdw>
    <xmx:PWG7X0bGIMnEn-VhjffXhboYTmfeSo5P-2ykayRWg-oATZbsXrShtg>
    <xmx:PWG7X8G1M3cMNH4Toqb2uw5Y_V3QNh0K6v8qGvzckpWaT1qCCNAmNw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38A643280060;
        Mon, 23 Nov 2020 02:14:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Add support for blackhole nexthops
Date:   Mon, 23 Nov 2020 09:12:20 +0200
Message-Id: <20201123071230.676469-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set adds support for blackhole nexthops in mlxsw. These
nexthops are exactly the same as other nexthops, but instead of
forwarding packets to an egress router interface (RIF), they are
programmed to silently drop them.

Patches #1-#4 are preparations.

Patch #5 adds support for blackhole nexthops and removes the check that
prevented them from being programmed.

Patch #6 adds a selftests over mlxsw which tests that blackhole nexthops
can be programmed and are marked as offloaded.

Patch #7 extends the existing nexthop forwarding test to also test
blackhole functionality.

Patches #8-#10 add support for a new packet trap ('blackhole_nexthop')
which should be triggered whenever packets are dropped by a blackhole
nexthop. Obviously, by default, the trap action is set to 'drop' so that
dropped packets will not be reported.

Ido Schimmel (10):
  mlxsw: spectrum_router: Create loopback RIF during initialization
  mlxsw: spectrum_router: Use different trap identifier for unresolved
    nexthops
  mlxsw: spectrum_router: Use loopback RIF for unresolved nexthops
  mlxsw: spectrum_router: Resolve RIF from nexthop struct instead of
    neighbour
  mlxsw: spectrum_router: Add support for blackhole nexthops
  selftests: mlxsw: Add blackhole nexthop configuration tests
  selftests: forwarding: Add blackhole nexthops tests
  devlink: Add blackhole_nexthop trap
  mlxsw: spectrum_trap: Add blackhole_nexthop trap
  selftests: mlxsw: Add blackhole_nexthop trap test

 .../networking/devlink/devlink-trap.rst       |  4 +
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  9 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 92 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  8 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  1 +
 include/net/devlink.h                         |  4 +-
 net/core/devlink.c                            |  1 +
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 36 ++++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 25 ++++-
 .../net/forwarding/router_mpath_nh.sh         | 58 +++++++++++-
 11 files changed, 218 insertions(+), 22 deletions(-)

-- 
2.28.0

