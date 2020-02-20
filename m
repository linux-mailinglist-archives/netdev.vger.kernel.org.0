Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142F016582B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgBTHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:21 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59557 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgBTHIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 50B8E21ACE;
        Thu, 20 Feb 2020 02:08:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ylv2Md1H2trcaaM3H
        efYeHsPgHBAqBTejzurAUnrIYg=; b=UxZEJHCbxSSB/tuCqFqVKitaJIVYHqeLP
        TqTRWeyNc2qnZXQ0rrMEkb/Xkjkhgw5T6+3COrn6Qv8sIB7FbGEGf4QqUKdDkn3d
        6gqc0BLMJo3Dw/K1z0qYreyD2YxwYWUkFZTggWEN1M7QSXFsELwH2gTw4FDa8ntv
        YRihXe5H+od2qk7Xqrpxdhyt8XKeAWj0yCI5g99qEnxwWVc9nVlIjsuQW+PkNwyU
        ttR1NObD5pXrR9IDJxGLbjANGnMb37SZUgBXQiyWOxkkLZUcOJ4jwAF9nSPQADsa
        o5RouiviGBn0NfeLOXasnOoHj2VEbdUUZ1tbbP8PGEIPyi9LQ+c+Q==
X-ME-Sender: <xms:YzBOXlhzUlh-7VjkAX6cBA7QuVMJ3S6jh6ux42rrX9Z6ekrA7tAPyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:YzBOXrb7fOtomU32wQsrB48UnoL6pdbkU7yfUnH9SoXnlbhS2KsjfQ>
    <xmx:YzBOXmpzq-jCEIc8y7fpDCLCIsnLDY43WkKBYQrvDdFoBPy4jMZfLQ>
    <xmx:YzBOXuTtkpB-zr17jWa5iPkL8MN0hPTIrxVyJUvWBJA56PGE_bHaYw>
    <xmx:ZDBOXotiTJkAmuVYq67jeFMcYYlcB65WXcL-Why1Qb38LWZukdjKbQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E14CD3060C21;
        Thu, 20 Feb 2020 02:08:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/15] mlxsw: Preparation for RTNL removal
Date:   Thu, 20 Feb 2020 09:07:45 +0200
Message-Id: <20200220070800.364235-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver currently acquires RTNL in its route insertion path, which
contributes to very large control plane latencies. This patch set
prepares mlxsw for RTNL removal from its route insertion path in a
follow-up patch set.

Patches #1-#2 protect shared resources - KVDL and counter pool - with
their own locks. All allocations of these resources are currently
performed under RTNL, so no locks were required.

Patches #3-#7 ensure that updates to mirroring sessions only take place
in case there are active mirroring sessions. This allows us to avoid
taking RTNL when it is unnecessary, as updating of the mirroring
sessions must be performed under RTNL for the time being.

Patches #8-#10 replace the use of APIs that assume that RTNL is taken
with their RCU counterparts. Specifically, patches #8 and #9 replace
__in_dev_get_rtnl() with __in_dev_get_rcu() under RCU read-side critical
section. Patch #10 replaces __dev_get_by_index() with
dev_get_by_index_rcu().

Patches #11-#15 perform small adjustments in the code to make it easier
to later introduce a router lock instead of relying on RTNL.

Ido Schimmel (15):
  mlxsw: spectrum_kvdl: Protect allocations with a lock
  mlxsw: spectrum: Protect counter pool with a lock
  mlxsw: spectrum_span: Do no expose mirroring agents to entire driver
  mlxsw: spectrum_span: Use struct_size() to simplify allocation
  mlxsw: spectrum_span: Prepare work item to update mirroring agents
  mlxsw: spectrum: Convert callers to use new mirroring API
  mlxsw: spectrum_span: Only update mirroring agents if present
  mlxsw: spectrum_router: Do not assume RTNL is taken during nexthop
    init
  mlxsw: spectrum_router: Do not assume RTNL is taken during RIF
    teardown
  mlxsw: spectrum_router: Do not assume RTNL is taken when resolving
    underlay device
  mlxsw: spectrum_router: Prepare function for router lock introduction
  mlxsw: spectrum_router: Prepare function for router lock introduction
  mlxsw: spectrum: Prevent RIF access outside of routing code
  mlxsw: spectrum: Export function to check if RIF exists
  mlxsw: spectrum_nve: Make tunnel initialization symmetric

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    |  25 +++-
 .../ethernet/mellanox/mlxsw/spectrum_kvdl.c   |  16 ++-
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 112 ++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 102 ++++++++++------
 .../mellanox/mlxsw/spectrum_switchdev.c       |  42 +------
 8 files changed, 199 insertions(+), 123 deletions(-)

-- 
2.24.1

