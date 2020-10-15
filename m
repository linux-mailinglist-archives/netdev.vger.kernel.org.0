Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477F428EEB7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgJOIpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:45:51 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40685 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388233AbgJOIpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:45:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 37ABCB92;
        Thu, 15 Oct 2020 04:45:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 15 Oct 2020 04:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+o6OT9THLkqgP1/Yr
        StfX5yCJbAJz/IFXHqieQMT4O4=; b=calBjbbOAS5Fp49+rO7zIuup5fqC/vKqh
        1bVORdPRNnkPtJ72zb/6RadqvkoVVBdtAhWA/dG2Z33SPVu4s0+bUuwHMHPD9927
        rgWNcXGTq1RKkfE6guDu/2fPXgnO5gwf9DnLdAX+Rksk+SoFg4bcJ8oUwFnmNVTd
        LVTggjk+ycgpzUJv+Eyz+rbHWHbeke+HV6OkGUZZYGQXkaeI6yEZDUqJz/edXbIb
        9lppY11WevCnoffB79c3kC8G3MfGMadgTQO4NFYd3ZTsDByTvc82k1oZzQhvPjFx
        Bp8MkgmhmwfkOK7rYpoPXT2ecrc1u9EJA5y5Iwt4O8ghAGGY8yr+Q==
X-ME-Sender: <xms:PQyIX5V-QUkT9PoJo9T_sgjosH0soo0IJxG4PMv1HHu4fpxQLYM6Vg>
    <xme:PQyIX5nf7jfS-N-6_1gmmXIQHfi-gQLJDVC_33XLzM-qO5r4bwxgG4izQTmoUH4jh
    hpZ8eFpaSG15ts>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieefgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudegkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PQyIX1YCBTS2R9vngyMIGn8lAYZ2zgbxDU2YdwXnm6puZx8RxsYGaw>
    <xmx:PQyIX8WuZqaUlwX5qxyA8BxdezYvgBw0Xb8WJRHRvwZSAtlp--4MDQ>
    <xmx:PQyIXzksnUo9iaxkh9WGBV_Uw1RfHApgMLbb-V_qpGvI6hc7AcwUyw>
    <xmx:PQyIXxioQSLvnv4olAav6XgG7pWTC2KDn7YZX9b1Nybzr97DUt--GA>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E5BD3064683;
        Thu, 15 Oct 2020 04:45:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, liuhangbin@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: forwarding: Add missing 'rp_filter' configuration
Date:   Thu, 15 Oct 2020 11:45:25 +0300
Message-Id: <20201015084525.135121-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When 'rp_filter' is configured in strict mode (1) the tests fail because
packets received from the macvlan netdevs would not be forwarded through
them on the reverse path.

Fix this by disabling the 'rp_filter', meaning no source validation is
performed.

Fixes: 1538812e0880 ("selftests: forwarding: Add a test for VXLAN asymmetric routing")
Fixes: 438a4f5665b2 ("selftests: forwarding: Add a test for VXLAN symmetric routing")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/net/forwarding/vxlan_asymmetric.sh       | 10 ++++++++++
 .../selftests/net/forwarding/vxlan_symmetric.sh        | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
index a0b5f57d6bd3..0727e2012b68 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
@@ -215,10 +215,16 @@ switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 
 switch_destroy()
 {
+	sysctl_restore net.ipv4.conf.all.rp_filter
+
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
 
@@ -359,6 +365,10 @@ ns_switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 export -f ns_switch_create
 
diff --git a/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh b/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh
index 1209031bc794..5d97fa347d75 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_symmetric.sh
@@ -237,10 +237,16 @@ switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 
 switch_destroy()
 {
+	sysctl_restore net.ipv4.conf.all.rp_filter
+
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
 	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
 
@@ -402,6 +408,10 @@ ns_switch_create()
 
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
 	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+	sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 export -f ns_switch_create
 
-- 
2.26.2

