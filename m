Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB092141DE4
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgASNB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54137 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgASNB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C59FD216C5;
        Sun, 19 Jan 2020 08:01:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hkvGRVNveik/3uf/2
        FD2ebaOnUmp85W65OCGZsyKoSE=; b=p0nuCVbQHNlnUOMPV5wpAtWKkJmDyS8Kv
        4ZzMQZ9DFCzwSVqcyAPzX+/gRkg2Ay74OrBjtaRL7BpNUhUabnvJFAeXax8sFkLg
        G7nVlrCmFvuQF9KnJTw40GBPjRzaZ4llWCg22IydzdLUq0rjOkwskn4lSbjWzuOa
        mhqkL0MOmZzz1Rspjsie25UzKM5uZ7k0D+MCWfGXgsPteMc+7Dj4LtfccYWyiO9C
        cAzFq/NCSLasqIDPV6dpYw88aHkaExxXXB+rtnM0Lxa4D3avsP2j0JFHhIhgSMRI
        jsGIiMhsiAnPXcyM2+cn2oju+ukg3c/42LxrtzEfCuCN+wVp/rYoA==
X-ME-Sender: <xms:JVMkXj-I_lKb1RkcOInghN5HMlGn_Y5FjgJEcUtzcfuNWnjXawlqwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:JVMkXm8DrUV5u6DOGKwUhkkPFJcrbdVTr-5tBf2mXjc9sOmCf3vMaA>
    <xmx:JVMkXpmSn3bBq5hsfvCyGrNJDQJOrs_OfO5QVXnyfiDzo194HBDG1A>
    <xmx:JVMkXs2AJpQZVLTOdgg2uSBo_F-DwRaJEP1Dm3lSegFlN6-xX_8vAg>
    <xmx:JVMkXtBNbPu1N5xRE1hDBe0BvRT4WQHJr9sk0SXFa33z8xtwDitGhA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21ECD80060;
        Sun, 19 Jan 2020 08:01:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/15] mlxsw: Add tunnel devlink-trap support
Date:   Sun, 19 Jan 2020 15:00:45 +0200
Message-Id: <20200119130100.3179857-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set from Amit adds support in mlxsw for tunnel traps and a
few additional layer 3 traps that can report drops and exceptions via
devlink-trap.

These traps allow the user to more quickly diagnose problems relating to
tunnel decapsulation errors, such as packet being too short to
decapsulate or a packet containing wrong GRE key in its GRE header.

Patch set overview:

Patches #1-#4 add three additional layer 3 traps. Two of which are
mlxsw-specific as they relate to hardware-specific errors. The patches
include documentation of each trap and selftests.

Patches #5-#8 are preparations. They ensure that the correct ECN bits
are set in the outer header during IPinIP encapsulation and that packets
with an invalid ECN combination in underlay and overlay are trapped to
the kernel and not decapsulated in hardware.

Patches #9-#15 add support for two tunnel related traps. Each trap is
documented and selftested using both VXLAN and IPinIP tunnels, if
applicable.

Amit Cohen (15):
  mlxsw: Add irif and erif disabled traps
  selftests: devlink_trap_l3_drops: Add test cases of irif and erif
    disabled
  devlink: Add non-routable packet trap
  mlxsw: Add NON_ROUTABLE trap
  mlxsw: reg: Add Tunneling IPinIP Encapsulation ECN Mapping Register
  mlxsw: reg: Add Tunneling IPinIP Decapsulation ECN Mapping Register
  mlxsw: Add ECN configurations with IPinIP tunnels
  mlxsw: spectrum_trap: Reorder cases according to enum order
  devlink: Add tunnel generic packet traps
  mlxsw: Add tunnel devlink-trap support
  selftests: devlink_trap_tunnel_vxlan: Add test case for decap_error
  selftests: devlink_trap_tunnel_ipip: Add test case for decap_error
  devlink: Add overlay source MAC is multicast trap
  mlxsw: Add OVERLAY_SMAC_MC trap
  selftests: devlink_trap_tunnel_vxlan: Add test case for
    overlay_smac_is_mc

 .../networking/devlink/devlink-trap.rst       |  19 +
 Documentation/networking/devlink/mlxsw.rst    |  22 ++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  89 +++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 -
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  60 ++++
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  10 +
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  52 ++-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   5 +
 include/net/devlink.h                         |  12 +
 net/core/devlink.c                            |   4 +
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 112 ++++++
 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     | 265 ++++++++++++++
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    | 330 ++++++++++++++++++
 14 files changed, 981 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh

-- 
2.24.1

