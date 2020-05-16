Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036A31D648D
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgEPWng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33007 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgEPWng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E5F875C006A;
        Sat, 16 May 2020 18:43:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vbyX4uBlcuZmjkH89
        pqAPRpwDxhKf3jZToin3GOfe00=; b=hTAYrkwQxpNdJZW1h4pPNmkcjxJzhZ0Ke
        qRzV1pWisiqI7+nsFRmaYSQSQBM4KsU8qfjF3UbOL36H5A/Woo3Tm8YzZMPcmzBy
        T/F8zM8LKq5zsYfEhSqxAURNDsVdTystAXc6OH8aeyBBrqE00VdOSRZQLa0TBjtV
        ruUpxNjW+B5ixjimEwiRNgVhOSQjBHtSiRAQwpTsija0GNNjgcR9h5XlKviY/tV7
        nBduQ9MwWTmt7QiPrXHLzzYhgtmqaZbbQaP0ai9sbQSmLKFBEZ/5f5FbIxt6vUWJ
        1LI0qTdujABPwJXLCMcRRFnYGnwDXXqcgv/A8ba8geD/DKj163oNA==
X-ME-Sender: <xms:lmzAXi8vP_2d1i1AV8mXwzwWfJ5fsnFd20Gtt-mELAfeq8qWsSV6Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lmzAXittlSG85qIFuJv9q941DoHhPi3v1883zWqfg-7VG0SkcVgh3A>
    <xmx:lmzAXoB1uHGHW0VUXfTxqMR2NTPyoDEbD4bNMko8c0c10ZLaJeLvqw>
    <xmx:lmzAXqdz_rvCz2VUNTY8sUI8-6aZY-SrpbCe8eQMfg4IRe7VYh2nPg>
    <xmx:lmzAXt2sG9EFuC1mmYt2dUnhY_-LuU1XGpBi-msVvG2MgdNsZqfupQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EA8830663A0;
        Sat, 16 May 2020 18:43:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] mlxsw: Reorganize trap data
Date:   Sun, 17 May 2020 01:43:04 +0300
Message-Id: <20200516224310.877237-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set does not include any functional changes. It merely
reworks the internal storage of traps, trap groups and trap policers in
mlxsw to each use a single array.

These changes allow us to get rid of the multiple arrays we currently
have for traps, which make the trap data easier to validate and extend
with more per-trap information in the future. It will also allow us to
more easily add per-ASIC traps in future submissions.

Last two patches include minor changes to devlink-trap selftests.

Tested with existing devlink-trap selftests.

Ido Schimmel (6):
  mlxsw: spectrum_trap: Move struct definition out of header file
  mlxsw: spectrum_trap: Store all trap policer data in one array
  mlxsw: spectrum_trap: Store all trap group data in one array
  mlxsw: spectrum_trap: Store all trap data in one array
  selftests: devlink_lib: Remove double blank line
  selftests: mlxsw: Do not hard code trap group name

 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 763 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  16 +-
 .../net/mlxsw/devlink_trap_acl_drops.sh       |   4 +-
 .../net/mlxsw/devlink_trap_l2_drops.sh        |  33 +-
 .../net/mlxsw/devlink_trap_l3_drops.sh        |  35 +-
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   |  20 +-
 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     |   6 +-
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    |   9 +-
 .../selftests/net/forwarding/devlink_lib.sh   |   9 +-
 9 files changed, 572 insertions(+), 323 deletions(-)

-- 
2.26.2

