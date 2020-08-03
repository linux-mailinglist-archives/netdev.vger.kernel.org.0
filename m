Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3723AA4A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgHCQMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58847 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgHCQMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C3BC5C0134;
        Mon,  3 Aug 2020 12:12:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Gm+FSR9DIf0K2+0SXGQ3NYwBy7gZmCESkyWj9ElaqJw=; b=UnBB7iGk
        ah5ntlXLL5VwPBVd4Dh3dEJ9Xm/L2ybbsrBOxZ9tL1HL/99SEfCXMw2PLWL0jqX3
        FKy1NswAm3WXiac0BV7PKcY7/nvsZDdupNBN4K1R4jd7kLwmUG/Fbw21bl4aTVts
        ngeBGsjI8m18XZPNQJMg9DCLmJPl4oo47jgCWOHdlYHlvPwTKuVjuE2ZZ+S8HUmP
        Fk+sRw+4iKWTxUgQ7E8S5UER1Vna/Y4CgpAiprGfERez3c0nFo0QGEekdcJrEoeH
        DIDZO5xW4VWs11TcN0by76//jeLM3ogu69wPFOzAYgb6xRUh5epyxNHOn5tlgJwo
        AVKHOai94wcmog==
X-ME-Sender: <xms:gzcoXzDVw10_1_uT_DXwWAb6iMANSeNWD1ffmaHcduYHA_mW0S9c-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gzcoX5gBIU6pqDPVypbpIr8QEn79nAxlKAt_btiaP2TKWAJKvbFn_A>
    <xmx:gzcoX-mV_CquCOsGPAExtGO622nbpmZfSTnbIxTnSPZTwH5SdiTrkg>
    <xmx:gzcoX1yW6sGti7mmvlS2E0p5aejSgtoF9wBoSsjWTm_j0fwPD5CV_w>
    <xmx:gzcoX-dZQVUWSCQxonkluVtnhiVcksrNG3j0sSXIFiNpFnoNsiKG5g>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77940306005F;
        Mon,  3 Aug 2020 12:12:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] selftests: mlxsw: RED: Test offload of trapping on RED qevents
Date:   Mon,  3 Aug 2020 19:11:41 +0300
Message-Id: <20200803161141.2523857-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a selftest for RED early_drop and mark qevents when a trap action is
attached at the associated block.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 35 +++++++++++++++----
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 45042105ead7..517297a14ecf 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -568,17 +568,12 @@ do_drop_test()
 	busywait 1100 until_counter_is ">= $((base + 1))" $fetch_counter >/dev/null
 	check_fail $? "Spurious packets observed without buffer pressure"
 
-	qevent_rule_uninstall_$subtest
-
 	# Push to the queue until it's at the limit. The configured limit is
 	# rounded by the qdisc and then by the driver, so this is the best we
-	# can do to get to the real limit of the system. Do this with the rules
-	# uninstalled so that the inevitable drops don't get counted.
+	# can do to get to the real limit of the system.
 	build_backlog $vlan $((3 * limit / 2)) udp >/dev/null
 
-	qevent_rule_install_$subtest
 	base=$($fetch_counter)
-
 	send_packets $vlan udp 11
 
 	now=$(busywait 1100 until_counter_is ">= $((base + 10))" $fetch_counter)
@@ -631,3 +626,31 @@ do_drop_mirror_test()
 
 	tc filter del dev $h2 ingress pref 1 handle 101 flower
 }
+
+qevent_rule_install_trap()
+{
+	tc filter add block 10 pref 1234 handle 102 matchall skip_sw \
+	   action trap hw_stats disabled
+}
+
+qevent_rule_uninstall_trap()
+{
+	tc filter del block 10 pref 1234 handle 102 matchall
+}
+
+qevent_counter_fetch_trap()
+{
+	local trap_name=$1; shift
+
+	devlink_trap_rx_packets_get "$trap_name"
+}
+
+do_drop_trap_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local trap_name=$1; shift
+
+	do_drop_test "$vlan" "$limit" "$trap_name" trap \
+		     "qevent_counter_fetch_trap $trap_name"
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index c8968b041bea..3f007c5f8361 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -8,6 +8,7 @@ ALL_TESTS="
 	red_test
 	mc_backlog_test
 	red_mirror_test
+	red_trap_test
 "
 : ${QDISC:=ets}
 source sch_red_core.sh
@@ -94,6 +95,16 @@ red_mirror_test()
 	uninstall_qdisc
 }
 
+red_trap_test()
+{
+	install_qdisc qevent early_drop block 10
+
+	do_drop_trap_test 10 $BACKLOG1 early_drop
+	do_drop_trap_test 11 $BACKLOG2 early_drop
+
+	uninstall_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.26.2

