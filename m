Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF5713CB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfGWITk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:19:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57563 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730211AbfGWITj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:19:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 56608220C9;
        Tue, 23 Jul 2019 04:19:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 04:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bw0CAxcIgdQtiJTK/lSTOMxVSw/sbW63SJyul6K+T2g=; b=YaKs902q
        URu0J5hjjDIa/qu7qfQZuSWCOIM9MvzC3kgC8/NygdnOofq6VjSgSwuye4BCScdY
        bBjyQGxD4bPNGLs92g/Cn+dzwVkdL0/pc37auSnI2VbZiLg9jErNcFtgja9GcKMt
        zRnBPkaJ4EoSnEnma3kgd8CsGCRt5jrCr2Hay+ZOzWSMJKqMLYZCYJHl8wZNJncd
        AEbt++XPpxx5yYs/HpNCEqPIYV/j/DeFW/qmnQ8Mae6VMHTzMpPbpsGIl2eQgun+
        EKM3RlpPVUVhKgC/eehZEZJNpBhB+JqaL65cV2LyhAIkHlnvMPHgPukZsfi/OQxd
        pgGHwrXK4B6sQQ==
X-ME-Sender: <xms:GsM2XSEYExz8VsLa1D8EKgw6vIeJxR4B1U1SHhHJImAuseBCBicBEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:GsM2XW1P1bzKI9ox08zdJlfrH-Iar-vaOacIR0_qfDMK8PgwMOVn4Q>
    <xmx:GsM2XfM3nxlaLlTtcfwbwDdgvy9OCid5WL1AAqzVbByDCoo2IwTW2Q>
    <xmx:GsM2XUBZ3k_cUsUySAy6PE-3-sDlb6YLLXPTtgM_Gm4DtCNpBwaoSQ>
    <xmx:GsM2XXRUhfboNIbN-mW8VgrpsToXToG3_EzOVO7EKzShqU1SA8nUcQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14008380084;
        Tue, 23 Jul 2019 04:19:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ssuryaextr@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] selftests: forwarding: gre_multipath: Fix flower filters
Date:   Tue, 23 Jul 2019 11:19:26 +0300
Message-Id: <20190723081926.30647-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723081926.30647-1-idosch@idosch.org>
References: <20190723081926.30647-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The TC filters used in the test do not work with veth devices because the
outer Ethertype is 802.1Q and not IPv4. The test passes with mlxsw
netdevs since the hardware always looks at "The first Ethertype that
does not point to either: VLAN, CNTAG or configurable Ethertype".

Fix this by matching on the VLAN ID instead, but on the ingress side.
The reason why this is not performed at egress is explained in the
commit cited below.

Fixes: 541ad323db3a ("selftests: forwarding: gre_multipath: Update next-hop statistics match criteria")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Tested-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 .../selftests/net/forwarding/gre_multipath.sh | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath.sh b/tools/testing/selftests/net/forwarding/gre_multipath.sh
index 37d7297e1cf8..a8d8e8b3dc81 100755
--- a/tools/testing/selftests/net/forwarding/gre_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/gre_multipath.sh
@@ -93,18 +93,10 @@ sw1_create()
 	ip route add vrf v$ol1 192.0.2.16/28 \
 	   nexthop dev g1a \
 	   nexthop dev g1b
-
-	tc qdisc add dev $ul1 clsact
-	tc filter add dev $ul1 egress pref 111 prot ipv4 \
-	   flower dst_ip 192.0.2.66 action pass
-	tc filter add dev $ul1 egress pref 222 prot ipv4 \
-	   flower dst_ip 192.0.2.82 action pass
 }
 
 sw1_destroy()
 {
-	tc qdisc del dev $ul1 clsact
-
 	ip route del vrf v$ol1 192.0.2.16/28
 
 	ip route del vrf v$ol1 192.0.2.82/32 via 192.0.2.146
@@ -139,10 +131,18 @@ sw2_create()
 	ip route add vrf v$ol2 192.0.2.0/28 \
 	   nexthop dev g2a \
 	   nexthop dev g2b
+
+	tc qdisc add dev $ul2 clsact
+	tc filter add dev $ul2 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul2 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
 }
 
 sw2_destroy()
 {
+	tc qdisc del dev $ul2 clsact
+
 	ip route del vrf v$ol2 192.0.2.0/28
 
 	ip route del vrf v$ol2 192.0.2.81/32 via 192.0.2.145
@@ -215,15 +215,15 @@ multipath4_test()
 	   nexthop dev g1a weight $weight1 \
 	   nexthop dev g1b weight $weight2
 
-	local t0_111=$(tc_rule_stats_get $ul1 111 egress)
-	local t0_222=$(tc_rule_stats_get $ul1 222 egress)
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
 
 	ip vrf exec v$h1 \
 	   $MZ $h1 -q -p 64 -A 192.0.2.1 -B 192.0.2.18 \
 	       -d 1msec -t udp "sp=1024,dp=0-32768"
 
-	local t1_111=$(tc_rule_stats_get $ul1 111 egress)
-	local t1_222=$(tc_rule_stats_get $ul1 222 egress)
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
 
 	local d111=$((t1_111 - t0_111))
 	local d222=$((t1_222 - t0_222))
-- 
2.21.0

