Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1873C4CF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404254AbfFKHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38493 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404216AbfFKHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 10C3C22405;
        Tue, 11 Jun 2019 03:20:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qVohjtZDNOYAUMUQh
        0rUJS4fQYkP8M4iwKAWNUiAxFA=; b=nID+zmaXUjjSpwoZ5c3LGtXIA1pscjZx6
        Soiw7oDvDznxQecoBHgkXXKN5DQKVuDnpWmRFTRopOMR42gTMbTgLawEdOM/z9ws
        SxzI5j+wuLvmmbJw95RT1yGRCBPDAUN8BDg/J5OIp76nuLRMuKCC94cJLyBiIejq
        2v0E/EISsV9uo9zC1aYc+LSYy/4I+qneI8ydJHJ40FJkPvSMON6XxZAw5XOBYfw9
        Z17xgNYcpKau7dIktkts+vV6UfcSXlRuuSzICrFVfUzOf5EQl6hDj0pjhuWhGHmr
        i9FweuQsyoN627jGJE2vUrTUtcETWlZAHtlZXZa7t7i4LDvnflLZA==
X-ME-Sender: <xms:Klb_XKFrBhlYZOTruca_KbW4hfTeCOLylzC-uQUOJ0QOxskHb5p17A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:Klb_XHCygLYlH27ZR0tHUi9cUAB81txi2Numw1APAQKqRLv3J0zmeQ>
    <xmx:Klb_XAmb0STbvp_6-MiYmg77LwUYKombzuQcIgA_7Th2Mlhw6-dETA>
    <xmx:Klb_XNPw8hQ9N4Y12pvRzvpnw9ILe4Zs6cvBcDLJTH1MSuZyg7PUoA>
    <xmx:K1b_XD8QJNnwVg45PgA_TesooZYOlUX4tPaz2TDyN15UHBGgaygS2A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC444380084;
        Tue, 11 Jun 2019 03:20:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/7] mlxsw: Various fixes
Date:   Tue, 11 Jun 2019 10:19:39 +0300
Message-Id: <20190611071946.11089-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset contains various fixes for mlxsw.

Patch #1 fixes an hash polarization problem when a nexthop device is a
LAG device. This is caused by the fact that the same seed is used for
the LAG and ECMP hash functions.

Patch #2 fixes an issue in which the driver fails to refresh a nexthop
neighbour after it becomes dead. This prevents the nexthop from ever
being written to the adjacency table and used to forward traffic. Patch
#3 is a test case.

Patch #4 fixes a wrong extraction of TOS value in flower offload code.
Patch #5 is a test case.

Patch #6 works around a buffer issue in Spectrum-2 by reducing the
default sizes of the shared buffer pools.

Patch #7 prevents prio-tagged packets from entering the switch when PVID
is removed from the bridge port.

Please consider patches #2, #4 and #6 for 5.1.y

Ido Schimmel (4):
  mlxsw: spectrum: Use different seeds for ECMP and LAG hash
  mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead
  selftests: mlxsw: Test nexthop offload indication
  mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Jiri Pirko (2):
  mlxsw: spectrum_flower: Fix TOS matching
  selftests: tc_flower: Add TOS matching test

Petr Machata (1):
  mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  5 +-
 .../mellanox/mlxsw/spectrum_buffers.c         |  4 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  4 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 73 ++++++++++++++++++-
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 47 ++++++++++++
 .../selftests/net/forwarding/tc_flower.sh     | 36 ++++++++-
 7 files changed, 161 insertions(+), 10 deletions(-)

-- 
2.20.1

