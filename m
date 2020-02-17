Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1468D1614BD
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgBQOb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:28 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41243 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729021AbgBQObY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CC05F21C24;
        Mon, 17 Feb 2020 09:31:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9MGYvv+2vx0EhD2m64PC+wY25ZmUqrjzQpfhbFPPtR4=; b=r74d6yd4
        CjLisZNK/GDL6wxd9qrmTbCQikeRZfN6XUJjR0xD0rnx4472cNYs3xvaXwHLzqh1
        rasJH/8KaFALTU6XLTgDTwNAN4zoVUxW3ZLBnoLJC1AYLFyvUcRIK9O/T6Y5WXj2
        9tnibDOUnaBsmJPxY9wJfYH/Z59ZTXxvAyysVIACRbj2mb/ST3zcbFUhn5mhU1/z
        wgj3lplyjCKgMfVIjWALvgXDDhWwTQB78U5f74N2s7z/uhKsqKOfyAN2y2067WIF
        uQUZuhQtEVUY9ci9CGtPQVeq5yZ4QvdwJHyssu+xKbAuQZajj9blqaDLFsw/qWu/
        noquFn5wRFT6ww==
X-ME-Sender: <xms:u6NKXhKX8y0iegJ37H9qlbPRlL2Eb3zcXuP-MD3ECRNi51PYUtYhWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:u6NKXmN0eKRCcYP-zKdZ1ip-ctTmMzlVvFq-XuB3v72koPAM9Nwvhw>
    <xmx:u6NKXizdimnO92NvGMrlaqAWiYycjP5ksBeUi8L6oJzEh__arqcqew>
    <xmx:u6NKXuIySOCkjL4i2ANG0P6b-0cvXY3Q5DzsjspdR6a6mZQhqnMb-g>
    <xmx:u6NKXoZB2tAkHylPC6qvk03QMgr1A-9HB12pqwK2fY0Fiv9pGQ13qA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0AE53060BE4;
        Mon, 17 Feb 2020 09:31:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/10] selftests: mlxsw: Remove deprecated test
Date:   Mon, 17 Feb 2020 16:29:36 +0200
Message-Id: <20200217142940.307014-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The addition of a VLAN on a bridge slave prompts the driver to have the
local port in question join the FID corresponding to this VLAN.

Before recent changes, the operation of joining the FID would also mean
that the driver would enable VXLAN tunneling if a VXLAN device was also
member in the VLAN. In case the configuration of the VXLAN tunnel was
not supported, an extack error would be returned.

Since the operation of joining the FID no longer means that VXLAN
tunneling is potentially enabled, the test is no longer relevant. Remove
it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/extack.sh     | 30 -------------------
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 15 ----------
 2 files changed, 45 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/extack.sh b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
index d72d8488a3b2..d9e02624c70b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/extack.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
@@ -8,7 +8,6 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 ALL_TESTS="
 	netdev_pre_up_test
 	vxlan_vlan_add_test
-	port_vlan_add_test
 "
 NUM_NETIFS=2
 source $lib_dir/lib.sh
@@ -106,35 +105,6 @@ vxlan_vlan_add_test()
 	ip link del dev br1
 }
 
-port_vlan_add_test()
-{
-	RET=0
-
-	ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 0
-
-	# Unsupported configuration: mlxsw demands VXLAN with "noudpcsum".
-	ip link add name vx1 up type vxlan id 1000 \
-		local 192.0.2.17 remote 192.0.2.18 \
-		dstport 4789 tos inherit ttl 100
-
-	ip link set dev $swp1 master br1
-	check_err $?
-
-	bridge vlan del dev $swp1 vid 1
-
-	ip link set dev vx1 master br1
-	check_err $?
-
-	bridge vlan add dev $swp1 vid 1 pvid untagged 2>&1 >/dev/null \
-		| grep -q mlxsw_spectrum
-	check_err $?
-
-	log_test "extack - map VLAN at port"
-
-	ip link del dev vx1
-	ip link del dev br1
-}
-
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 4632f51af7ab..f68a109c0352 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -854,21 +854,6 @@ sanitization_vlan_aware_test()
 	bridge vlan del vid 10 dev vxlan20
 	bridge vlan add vid 20 dev vxlan20 pvid untagged
 
-	# Test that offloading of an unsupported tunnel fails when it is
-	# triggered by addition of VLAN to a local port
-	RET=0
-
-	# TOS must be set to inherit
-	ip link set dev vxlan10 type vxlan tos 42
-
-	ip link set dev $swp1 master br0
-	bridge vlan add vid 10 dev $swp1 &> /dev/null
-	check_fail $?
-
-	log_test "vlan-aware - failed vlan addition to a local port"
-
-	ip link set dev vxlan10 type vxlan tos inherit
-
 	ip link del dev vxlan20
 	ip link del dev vxlan10
 	ip link del dev br0
-- 
2.24.1

