Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3744E3482A6
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhCXUPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52085 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238103AbhCXUOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E0E1F5C00C1;
        Wed, 24 Mar 2021 16:14:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rHDzetONS5/eUNlCy
        zbY38ESQri1XNWQplr3Ctv7SJk=; b=iWLtIbpXEDaUN7jzPYhi288zVWseEHFMm
        ybqbURsTlCoEXYmdr9S1C/tP1ahiJE4Ne2g81rJmszbUiFyX1Twsfp3G0hAbDzCC
        t9JyGcQXatAIoaTK3vNamoqmC6lAbxcKF+Jm1egvSeoke/ZEHii/bToFtJ6vk8KA
        c7cH/hOx9TB28i4adsVzGpPhvGiV5IgQKuVfpe5cTR2cICROjiCOFNfPl5Cz8E1S
        Im+9RCD34Lp7M+iaUPj6YRl54k4j46hYjJqLSQJ6Aj+5GGiBcUioNcGAzr2HzgeM
        C5pg4bTyBJYL6JcPsJQigLv26H71eNHwaxK2c/Jb5t39CkheGgNzg==
X-ME-Sender: <xms:s51bYJil-_9UgNcm23CbKaY1bGlUnGSvcsMi-8TFsHoL4jARHG8O_Q>
    <xme:s51bYOAtAtXnK6mnC6sg8zlmwMdsh_VRXu-LY_C3KV0A2n3d1b2SsewkkuWnxctJf
    CykNMngFoIW0D0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:s51bYJEgBSmDzuXWCSNgqhZLSW64LQ5UkPHPmH-LMmAG1-bie5CLqg>
    <xmx:s51bYOSPABtCjyKpL3l4YT1TAWJDxTLbiNZ34sBudqKMTl6eW04rSA>
    <xmx:s51bYGzg95q1bbSrcBAGV7NEE_R__3Q5u2Q85B3A6ej0F2ZpGmne6Q>
    <xmx:s51bYAt7K7R7qRK3JSIecrGzLUMlI1yGEllx_mO-P7KJBpcwcGkOvQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 536A324033F;
        Wed, 24 Mar 2021 16:14:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Add support for resilient nexthop groups
Date:   Wed, 24 Mar 2021 22:14:14 +0200
Message-Id: <20210324201424.157387-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset adds support for resilient nexthop groups in mlxsw. As far
as the hardware is concerned, resilient groups are the same as regular
groups. The differences lie in how mlxsw manages the individual
adjacency entries (nexthop buckets) that make up the group.

The first difference is that unlike regular groups the driver needs to
periodically update the kernel about activity of nexthop buckets so that
the kernel will not treat the buckets as idle, given traffic is
offloaded from the CPU to the ASIC. This is similar to what mlxsw is
already doing with respect to neighbour entries. The update interval is
set to 1 second to allow for short idle timers.

The second difference is that nexthop buckets that correspond to an
unresolved neighbour must be programmed to the device, as the size of
the group must remain fixed. This is achieved by programming such
entries with trap action, in order to trigger neighbour resolution by
the kernel.

The third difference is atomic replacement of individual nexthop
buckets. While the driver periodically updates the kernel about activity
of nexthop buckets, it is possible for a bucket to become active just
before the kernel decides to replace it with a different nexthop. To
avoid such situations and connections being reset, the driver instructs
the device to only replace an adjacency entry if it is inactive.
Failures are propagated back to the nexthop code.

Patchset overview:

Patches #1-#7 gradually add support for resilient nexthop groups

Patch #8 finally enables such groups to be programmed to the device

Patches #9-#10 add mlxsw-specific selftests

Ido Schimmel (10):
  mlxsw: spectrum_router: Add support for resilient nexthop groups
  mlxsw: spectrum_router: Add ability to overwrite adjacency entry only
    when inactive
  mlxsw: spectrum_router: Pass payload pointer to nexthop update
    function
  mlxsw: spectrum_router: Add nexthop bucket replacement support
  mlxsw: spectrum_router: Update hardware flags on nexthop buckets
  mlxsw: reg: Add Router Adjacency Table Activity Dump Register
  mlxsw: spectrum_router: Periodically update activity of nexthop
    buckets
  mlxsw: spectrum_router: Enable resilient nexthop groups to be
    programmed
  selftests: mlxsw: Test unresolved neigh trap with resilient nexthop
    groups
  selftests: mlxsw: Add resilient nexthop groups configuration tests

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  55 +++
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  10 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 422 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   5 +-
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   |  31 ++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  82 ++++
 tools/testing/selftests/net/forwarding/lib.sh |   5 +
 9 files changed, 594 insertions(+), 23 deletions(-)

-- 
2.30.2

