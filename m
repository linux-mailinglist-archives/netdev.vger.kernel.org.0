Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7461614B8
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgBQObU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:20 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35901 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728087AbgBQObU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B8FFD21EAF;
        Mon, 17 Feb 2020 09:31:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0mnpylERM1WwX75Vf
        E0umnGtMyDQqWVF0IxBZlXIYuk=; b=R/0rGM93I2hJyUWRsUlA2ftkpuJYVhBqM
        zqxDFMQy7f7Jgzqtc3LOLwr0hy8ttvKi5qE11xIrBaS4IQcIJm1WpqgKZqCK5vo4
        4VZ0F7IqoINsAC3gYvwbwJoOHVNqy0tcdmZBPYOEq5V5n3XwABzxHPgGEXfkntdM
        MA1JEI6Y/nbU++i+VtiyeACDis0kMhVQnqMk9OnUb5gbvl2ISGXXz7wgk8ZJ+MIB
        Z1H4bsHh8pAKRBP6wR65KO4rV/rXgtQ9x59N6wflZUHdNNZCopWuablcRgLHLCFL
        m0e5bmFZR5zJ0KUrcey5TBBGmO6QcIRuwh/KpPNKnagROie89duIQ==
X-ME-Sender: <xms:tKNKXn4beac5GRMm5aOammhVCtNUt7A48ztdDP79HniI3iJRj_C2xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:tKNKXhgIc4zwBTOOqmZygSvRQlVIEkrJOdy70v2RAEt398lEFxty_A>
    <xmx:tKNKXhJr07AiH0_eh7GcBHyODxZXyF3CesGCrNYGVGHaZD2o0YCvJg>
    <xmx:tKNKXndpfB-U8ClAq3VIdw5stS5Q6K3Z1Q1qX8PmKsJfTQTjeJlL5w>
    <xmx:tKNKXuBvfYEcJtzqgrAHu6qsCo7pqdnDoEVWxaF5opAmGDvtDbeYOg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B7523060EF2;
        Mon, 17 Feb 2020 09:31:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/10] mlxsw: Reduce dependency between bridge and router code
Date:   Mon, 17 Feb 2020 16:29:30 +0200
Message-Id: <20200217142940.307014-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set reduces the dependency between the bridge and the router
code in preparation for RTNL removal from the route insertion path in
mlxsw.

The motivation and solution are explained in detail in patch #3. The
main idea is that we need to stop special-casing the VXLAN devices with
regards to the reference counting of the FIDs. Otherwise, we can bump
into the situation described in patch #3, where the routing code calls
into the bridge code which calls back into the routing code. After
adding a mutex to protect router data structures to remove RTNL
dependency, this can result in an AA deadlock.

Patches #1 and #2 are preparations. They convert the FIDs to use
'refcount_t' for reference counting in order to catch over/under flows
and add extack to the bridge creation function.

Patches #3-#5 reduce the dependency between the bridge and the router
code. First, by having the VXLAN device take a reference on the FID in
patch #3 and then by removing unnecessary code following the change in
patch #3.

Patches #6-#10 adjust existing selftests and add new ones to exercise
the new code paths.

Ido Schimmel (10):
  mlxsw: spectrum_fid: Use 'refcount_t' for FID reference counting
  mlxsw: spectrum_switchdev: Propagate extack to bridge creation
    function
  mlxsw: spectrum_switchdev: Have VXLAN device take reference on FID
  mlxsw: spectrum_switchdev: Remove VXLAN checks during FID membership
  mlxsw: spectrum: Reduce dependency between bridge and router code
  selftests: mlxsw: Remove deprecated test
  selftests: mlxsw: extack: Test bridge creation with VXLAN
  selftests: mlxsw: extack: Test creation of multiple VLAN-aware bridges
  selftests: mlxsw: vxlan: Adjust test to recent changes
  selftests: mlxsw: vxlan: Add test for error path

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 -
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |  13 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   4 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 186 +++++++++---------
 .../selftests/drivers/net/mlxsw/extack.sh     |  45 ++++-
 .../selftests/drivers/net/mlxsw/vxlan.sh      |  27 +--
 6 files changed, 147 insertions(+), 132 deletions(-)

-- 
2.24.1

