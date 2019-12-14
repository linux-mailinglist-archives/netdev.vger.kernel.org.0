Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D04811F29E
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLNPyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:54:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43751 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfLNPyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:54:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 358D422621;
        Sat, 14 Dec 2019 10:54:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ubup7XulmWbox8tbP
        5ulSI1c3xdrA8DXDzkigipug6s=; b=tL33+ETwIOBQELM6Y6xnwQY9Fd3k/jGxT
        VLGpMgNeddNZNiJi7uJBCuRH0MV/eTBbVygXGkfLKs31GeNRN0eP6K0W78i8kD3A
        AMRuBpucmh1qls3Jieyv0WoShNI8C6++U/JgY1HPX0YOfGtwTLmopRE8G6CvLRp1
        gwMHvh4Ru4t+lXr7CB5v32f2+z9lgmTMW3STsZDo5R5dELHYNAPJBTIBGNHTJFFc
        3WVOTLd1VIluE6WpDoEe3o/S8AzujWi952n2SF6VV9mMDku/VLobuEILO4hHdu4P
        znpm1sYyvNkyR8fT79JKmC8I5vdeLk8ho/010QBo2U+OS0ux9fLeQ==
X-ME-Sender: <xms:xwX1XWyzL10f7rdW0nLxJtHQFqja-yBndxXw3rbo74TaSx4IZxu_YA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghsrdhorh
    hgnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xwX1XdaSjv4i0YyWy-rr-TR6v1Xov5DWxBal2ZjbnvI8Q4YQzeIOEw>
    <xmx:xwX1XdvjcpY86RmaB-SMj9k5ysuwUG_9Xbx-4u0mlKdFcsXG7k6MCg>
    <xmx:xwX1XcWFyz_CA0Ii_6SydRjELTBokgPg--Fpcw2sgjMbPCCzyDv9Mg>
    <xmx:yAX1XeN9OqaEfF58jwZdYq1PSwEPqD7ctYuleszAdjNFnF7ej--QfA>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id A47398005B;
        Sat, 14 Dec 2019 10:54:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/10] Simplify IPv4 route offload API
Date:   Sat, 14 Dec 2019 17:53:05 +0200
Message-Id: <20191214155315.613186-1-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Motivation
==========

The aim of this patch set is to simplify the IPv4 route offload API by
making the stack a bit smarter about the notifications it is generating.
This allows driver authors to focus on programming the underlying device
instead of having to duplicate the IPv4 route insertion logic in their
driver, which is error-prone.

This is the first patch set out of a series of four. Subsequent patch
sets will simplify the IPv6 API, add offload/trap indication to routes
and add tests for all the code paths (including error paths). Available
here [1].

Details
=======

Today, whenever an IPv4 route is added or deleted a notification is sent
in the FIB notification chain and it is up to offload drivers to decide
if the route should be programmed to the hardware or not. This is not an
easy task as in hardware routes are keyed by {prefix, prefix length,
table id}, whereas the kernel can store multiple such routes that only
differ in metric / TOS / nexthop info.

This series makes sure that only routes that are actually used in the
data path are notified to offload drivers. This greatly simplifies the
work these drivers need to do, as they are now only concerned with
programming the hardware and do not need to replicate the IPv4 route
insertion logic and store multiple identical routes.

The route that is notified is the first FIB alias in the FIB node with
the given {prefix, prefix length, table ID}. In case the route is
deleted and there is another route with the same key, a replace
notification is emitted. Otherwise, a delete notification is emitted.

The above means that in the case of multiple routes with the same key,
but different TOS, only the route with the highest TOS is notified.
While the kernel can route a packet based on its TOS, this is not
supported by any hardware devices I am familiar with. Moreover, this is
not supported by IPv6 nor by BIRD/FRR from what I could see. Offload
drivers should therefore use the presence of a non-zero TOS as an
indication to trap packets matching the route and let the kernel route
them instead. mlxsw has been doing it for the past two years.

Testing
=======

To ensure there is no degradation in route insertion rates, I averaged
the insertion rate of 512k routes (/24 and /32) over 50 runs. Did not
observe any degradation.

Functional tests are available here [1]. They rely on route trap
indication, which is only added in the last patch set.

In addition, I have been running syzkaller for the past week with all
four patch sets and debug options enabled. Did not observe any problems.

Patch set overview
==================

Patches #1-#8 gradually introduce the new FIB notifications
Patch #9 converts mlxsw to use the new notifications
Patch #10 converts the remaining listeners and removes the old
notifications

v2:
* Extend fib_find_alias() with another argument instead of introducing a
  new function (David Ahern)

RFC: https://patchwork.ozlabs.org/cover/1170530/

[1] https://github.com/idosch/linux/tree/fib-notifier

Ido Schimmel (10):
  net: fib_notifier: Add temporary events to the FIB notification chain
  ipv4: Notify route after insertion to the routing table
  ipv4: Extend FIB alias find function
  ipv4: Notify route if replacing currently offloaded one
  ipv4: Notify newly added route if should be offloaded
  ipv4: Handle route deletion notification
  ipv4: Handle route deletion notification during flush
  ipv4: Only Replay routes of interest to new listeners
  mlxsw: spectrum_router: Start using new IPv4 route notifications
  ipv4: Remove old route notifications and convert listeners

 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   4 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 136 +++---------------
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 drivers/net/netdevsim/fib.c                   |   4 +-
 net/ipv4/fib_trie.c                           | 121 +++++++++++-----
 5 files changed, 104 insertions(+), 165 deletions(-)

-- 
2.23.0

