Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF9118EE9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfLJRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47621 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727562AbfLJRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AB08A22329;
        Tue, 10 Dec 2019 12:24:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HmnVB56mbND1H/Vzw
        TyPVut5dNnylyN+JFco8mL2ac4=; b=weGCRbt+9YaQo+1asQnEt4QE8WHQDwZg6
        1+i+9b/wOnGCjeQPEODn0A98QwBd+VEw+D0GewSidesKq4DHvSJRUAJ5dF+aESnF
        122PCdVDxDHoqiH3r4jnVjmzu0Lqc9pAE+Kx/8tg8ceLkbWrN1dxwzfk5YuX7OlZ
        MGMGdPFGB1g9k0lYEuoI6VowEQgqiNy5BG8qbViVDEm6rVUR3a48yeQXA9+g3UPQ
        vAlbh4RV4RrBYGL5sCWDw81X0tXX1qn3MrUBE9kckfOc/g/VDFGH16e3VQD5RTe/
        jMpoDQZho26uLYvHf0p5cNUwDu314QGgbVoO6BsZx7PY+bju1sFKA==
X-ME-Sender: <xms:4NTvXe_LA9qXAC1BF5XJremZ206jfPNGiEDUhQV0zxRMeD0y65LrRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghsrdhorh
    hgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4NTvXXKG8x0Q3v7nxgv_fj9Thw-_GhRR0US-tvQnJ_P2nQeGWwyzWw>
    <xmx:4NTvXZrUJ-b6P2oUUJVONiXPRXjikRTUcT-xndMTGK2cRdUYdIYm6g>
    <xmx:4NTvXagIYFVa5CxbbQB49HFLp8vJDPTkx-5VqsTs_lAH9TsXNGJUIA>
    <xmx:4NTvXf2N07Qw7RuF6Q-UihQn5pnngtgUrSbV0JEt6YNSlqR13sMLoQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD98F80060;
        Tue, 10 Dec 2019 12:24:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] Simplify IPv4 route offload API
Date:   Tue, 10 Dec 2019 19:23:53 +0200
Message-Id: <20191210172402.463397-1-idosch@idosch.org>
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

Patches #1-#7 gradually introduce the new FIB notifications
Patch #8 converts mlxsw to use the new notifications
Patch #9 converts the remaining listeners and removes the old
notifications

RFC: https://patchwork.ozlabs.org/cover/1170530/

[1] https://github.com/idosch/linux/tree/fib-notifier

Ido Schimmel (9):
  net: fib_notifier: Add temporary events to the FIB notification chain
  ipv4: Notify route after insertion to the routing table
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
 net/ipv4/fib_trie.c                           | 131 ++++++++++++-----
 5 files changed, 117 insertions(+), 162 deletions(-)

-- 
2.23.0

