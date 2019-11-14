Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E13FC30D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKNJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:51:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40601 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfKNJvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:51:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E30C20963;
        Thu, 14 Nov 2019 04:51:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 14 Nov 2019 04:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nh5H9gLrLqZzTvnOA
        iXgu3GWimfjDPMx65VNmL3LnAg=; b=XiM3mDVxSCTFpyzi5gJ11UVwFLq66NAgU
        VVJhHvyUQhDc9MsQCsveKxBsC/8Fc+f1QflWY2RgpAa5HCMUDwUACoss3/XUIlFb
        iEFnNaPEqbMMffCpYx6q5MXNueDu0/cNa7KVNOLvOV2hqdNe8/KM5S7Gt9Lr2lIZ
        ZINYy8pl4q9IxMGYOAWi8t7l045jmZ0eFDmshIBofk4V6ZSmR5ArQQxIiFF0IPAC
        TSx5mQkfQeGHwamhesfUgR28lih4KjyeX4xXEOJEOPJM38o+xtygie9JIbH0Dv4S
        waeuBA2X7bx5Yp18YryFTVxRhi0jCmmf2BayU2oHiJPmfVrc28bSA==
X-ME-Sender: <xms:rSPNXUlnwEsqkxJ-wcJFn6yId8wXUJM8-2wBalB8vVcVzNP9D99Qzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeffedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:rSPNXVER3T5_A-Jop5rlHAlpH7KpVpVr9VBAFNnvKJ8lzyTDJfrMGw>
    <xmx:rSPNXX_g-uOfBLBvt-cn0lwajdUCuqCvlSz1uWiG1Q5mJXmhe-rSwA>
    <xmx:rSPNXehB0F3536EBMoa-taF5DoVlUoE082w2Gua6GVvplyk6rgy2wg>
    <xmx:riPNXcF_XiWAlD7KWS8Wncql_DWjyabYKKx8NZemToyrKFsACDnSXw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 945783060069;
        Thu, 14 Nov 2019 04:51:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, ap420073@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] selftests: mlxsw: Adjust test to recent changes
Date:   Thu, 14 Nov 2019 11:50:57 +0200
Message-Id: <20191114095057.27335-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

mlxsw does not support VXLAN devices with a physical device attached and
vetoes such configurations upon enslavement to an offloaded bridge.

Commit 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
changed the VXLAN device to be an upper of the physical device which
causes mlxsw to veto the creation of the VXLAN device with "Unknown
upper device type".

This is OK as this configuration is not supported, but it prevents us
from testing bad flows involving the enslavement of VXLAN devices with a
physical device to a bridge, regardless if the physical device is an
mlxsw netdev or not.

Adjust the test to use a dummy device as a physical device instead of a
mlxsw netdev.

Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/drivers/net/mlxsw/vxlan.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index ae6146ec5afd..4632f51af7ab 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -112,14 +112,16 @@ sanitization_single_dev_mcast_group_test()
 	RET=0
 
 	ip link add dev br0 type bridge mcast_snooping 0
+	ip link add name dummy1 up type dummy
 
 	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
 		ttl 20 tos inherit local 198.51.100.1 dstport 4789 \
-		dev $swp2 group 239.0.0.1
+		dev dummy1 group 239.0.0.1
 
 	sanitization_single_dev_test_fail
 
 	ip link del dev vxlan0
+	ip link del dev dummy1
 	ip link del dev br0
 
 	log_test "vxlan device with a multicast group"
@@ -181,13 +183,15 @@ sanitization_single_dev_local_interface_test()
 	RET=0
 
 	ip link add dev br0 type bridge mcast_snooping 0
+	ip link add name dummy1 up type dummy
 
 	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789 dev $swp2
+		ttl 20 tos inherit local 198.51.100.1 dstport 4789 dev dummy1
 
 	sanitization_single_dev_test_fail
 
 	ip link del dev vxlan0
+	ip link del dev dummy1
 	ip link del dev br0
 
 	log_test "vxlan device with local interface"
-- 
2.21.0

