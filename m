Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4014F34D2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfKGQnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:14 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51735 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730364AbfKGQnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CEA5A2104A;
        Thu,  7 Nov 2019 11:43:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=smduMynfOuEBqVAmi
        IMqY6XFOBWXSX0Q529uhuUkrsc=; b=Dms6j4y7AEwulyzmXNTwz0rBYZlxKILue
        2JuKO1YWqvtf+CTNl60/OtBZwhbV0X9MThi3dcdTrphH0pFnO02CHb5C5MNYF4GZ
        P+yzAgZV6PmJXuvVZT9ChVVI+zpJeJ+boklvBSGghpsVfHOHaWPsl4ujdvcyIze0
        Qf4Ec5szw6Z5PJiKp6Vv1mAmTpBt09KrDTc+WBV/oq9HCOqUSCOv8NGRHvPpF4fx
        sWhb5RbAGHIaVpAnaO8GlhJ3Bd53wSXEK3AB9jJemJk79n/Yh4MmrOumSLG304II
        p0hmIHjZB72pTVgDHCJTtvg7G3U4aN23xjcPrWszsJFMGDAu9W5aw==
X-ME-Sender: <xms:oEnEXcz4KV0RGJPrBG_OICYc84hCj-ll4il7oHEaWTZibsSlb73toA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:oEnEXXqtfrIthOjRvpdhPOQI2nErz-LpiPrAU5iHDpjwM_qqCNFbIg>
    <xmx:oEnEXT59EYcKrNOqHTfjFqMpPQjrznA_nqDNSx2akmUzEsZzdU0wbg>
    <xmx:oEnEXWfjY120m6UTXODksje9yvyhmW6ALg4pACiFbJsN396Qw0tmuQ>
    <xmx:oEnEXX17I4jOIawNMEWLc62WigkFFOuCJTfVkZ1kJhfgT5rroMnI2Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2236180063;
        Thu,  7 Nov 2019 11:43:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/12] mlxsw: Add layer 3 devlink-trap support
Date:   Thu,  7 Nov 2019 18:42:08 +0200
Message-Id: <20191107164220.20526-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set from Amit adds support in mlxsw for layer 3 traps that
can report drops and exceptions via devlink-trap.

In a similar fashion to the existing layer 2 traps, these traps can send
packets to the CPU that were not routed as intended by the underlying
device.

The traps are divided between the two types detailed in devlink-trap
documentation: drops and exceptions. Unlike drops, packets received via
exception traps are also injected to the kernel's receive path, as they
are required for the correct functioning of the control plane. For
example, packets trapped due to TTL error must be injected to kernel's
receive path for traceroute to work properly.

Patch set overview:

Patch #1 adds the layer 3 drop traps to devlink along with their
documentation.

Patch #2 adds support for layer 3 drop traps in mlxsw.

Patches #3-#5 add selftests for layer 3 drop traps.

Patch #6 adds the layer 3 exception traps to devlink along with their
documentation.

Patches #7-#9 gradually add support for layer 3 exception traps in
mlxsw.

Patches #10-#12 add selftests for layer 3 exception traps.

Amit Cohen (12):
  devlink: Add layer 3 generic packet traps
  mlxsw: Add layer 3 devlink-trap support
  selftests: devlink: Export functions to devlink library
  selftests: devlink: Make devlink_trap_cleanup() more generic
  selftests: mlxsw: Add test cases for devlink-trap layer 3 drops
  devlink: Add layer 3 generic packet exception traps
  mlxsw: Add new FIB entry type for reject routes
  mlxsw: Add specific trap for packets routed via invalid nexthops
  mlxsw: Add layer 3 devlink-trap exceptions support
  selftests: forwarding: devlink: Add functionality for trap exceptions
    test
  selftests: forwarding: tc_common: Add hitting check
  selftests: mlxsw: Add test cases for devlink-trap layer 3 exceptions

 Documentation/networking/devlink-trap.rst     |  61 ++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   5 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  61 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 100 ++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  15 +
 include/net/devlink.h                         |  45 ++
 net/core/devlink.c                            |  15 +
 .../net/mlxsw/devlink_trap_l2_drops.sh        |  68 +--
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 563 ++++++++++++++++++
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   | 557 +++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  55 ++
 .../selftests/net/forwarding/tc_common.sh     |  11 +
 13 files changed, 1496 insertions(+), 61 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh

-- 
2.21.0

