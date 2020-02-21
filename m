Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252761685A2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgBURyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58487 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbgBURym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CFC122027;
        Fri, 21 Feb 2020 12:54:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6+WsD5qeDKY/Sl9C6
        uFmHOIRLZu6cmsyLyfz6JK7yOE=; b=exXPB3cQ20O962fnE9P5EUo6s+xUANKGB
        Xbz+I+REBEbXmkWTyKpQOL+7DJDKtoWrYq4xEffBEBv7ehHj7HzjA6mS1sos/bCe
        UiN1Ie8wCreBYo/IyTl5UJXlBFf7kCDXpcl79o/WjHVn7azFkC3Sr5F2wjgPTNmB
        iko+TDZqjnK9hALAstvZloQMxnFfBTx6lyzWmtezFio1J/GWdDu6/MpE48Hofgjr
        8qfSV9W++NIpzaJWKD528Fo0JqR630GDkiNdCRbgzTxM6xNoJKJ0ldi0qlGFop3A
        h5rUSoX7VI1LhAwW29j6p9vLuFbkYGyNXmusESdoaWnSIXtxvdKbg==
X-ME-Sender: <xms:YRlQXsAWip93Hr7AgL9UZKnPzaaZylhpdnth_-yyTgGMX3H3QSLkMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:YRlQXohNJey2ke1WUarqk2fmp03RgKJv6FFWsL946iQEI60MUryI_A>
    <xmx:YRlQXmPBKKGB0NWEoKcmoN7rIEHmu2hXroXo1LZeEDgzIBwlw5TYkg>
    <xmx:YRlQXg9HFT7bcwoR8QKYTjd9Ex2yRq9c4-dk54DM6YPrDVHYfSemTg>
    <xmx:YRlQXmtoKlK7V5D81s0J3pcJ0DUjOP82_C9CLhhv5I12zx8nRQXYjw>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AF063060FE0;
        Fri, 21 Feb 2020 12:54:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/12] mlxsw: Remove RTNL from route insertion path
Date:   Fri, 21 Feb 2020 19:54:03 +0200
Message-Id: <20200221175415.390884-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set removes RTNL from the route insertion path in mlxsw in
order to reduce the control plane latency: the time it takes to push
routes from user space to the kernel and mlxsw.

Up until now mlxsw did not have a lock to protect its shared router data
structures and instead relied on RTNL. While this was simple and worked,
it resulted in large control plane latencies as RTNL was heavily
contended - by both the task receiving the netlink messages from user
space and the mlxsw workqueue that programs the routes to the device.

By removing RTNL and introducing a new router mutex, this patch set
reduces the control plane latency by ~80%. A single mutex is added as
inside mlxsw there is not a lot of concurrency. In addition, a more
fine-grained locking scheme is much more error-prone.

Patches #1-#6 are preparations. They add needed locking in NVE and
multicast routing code instead of relying on RTNL
Patch #7 introduces the new mutex
Patches #8-#12 gradually take the lock in various entry points into the
routing code
Patch #13 removes RTNL in places where it is no longer required

Ido Schimmel (12):
  mlxsw: spectrum_mr: Publish multicast route after writing it to the
    device
  mlxsw: spectrum_mr: Protect multicast table list with a lock
  mlxsw: spectrum_mr: Protect multicast route list with a lock
  mlxsw: spectrum_router: Expose router struct to internal users
  mlxsw: spectrum_router: Store NVE decapsulation configuration in
    router
  mlxsw: spectrum_router: Introduce router lock
  mlxsw: spectrum_router: Take router lock from inside routing code
  mlxsw: spectrum_dpipe: Take router lock from dpipe code
  mlxsw: spectrum_router: Take router lock from netdev listener
  mlxsw: spectrum_router: Take router lock from inetaddr listeners
  mlxsw: spectrum_router: Take router lock from exported helpers
  mlxsw: spectrum: Remove RTNL where possible

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  35 +--
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c |  52 +++-
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  21 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 267 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  43 +++
 6 files changed, 267 insertions(+), 156 deletions(-)

-- 
2.24.1

