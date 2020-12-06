Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE22D0198
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgLFIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:23:41 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58609 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbgLFIXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:23:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CAF3BB05;
        Sun,  6 Dec 2020 03:22:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KJH90UYJF3V6cTIG8ZEpiZeHm4K/w/hvVTDHIoXR87g=; b=ev/7Ajvg
        y8qHzY4FEkXVYOloMlFygMbVuCJF2y4KmMmpgRN+iLWcm+Li+MC8h1mHRH0bg3L8
        MM4+/FSPRAb+Pa3Hh1Zc/B5QsYY+lvIvcRLu/+jjNwWjfwknqTfpzScy8/VgsD44
        52BM6y97rdIz2pxt6jktzK+QI/EIWyaanHfp15LLC2yRCdkQH2vtEtYbey1uZYXM
        gDAbdW7CV23wPsGOjCtoKw0ggBZ0h+oeFyfVDyzuVihhKf6jixtcTaTMGzQdXGF4
        O8zkNdMXeC28hKmnUjzXqOzLgEaXqcNJSyTRls9HE9OUVrUq1D2rKst/TZIYwZPi
        1XrbwYp3IvXzKA==
X-ME-Sender: <xms:3pTMX80ySZPHI2LcavlnS1cUzoOu_GQ_APJZPlG3VLjGKpdgF6kcZw>
    <xme:3pTMX3HrwFyVcfbn1r7-vsC5LEan-8zYLAweMleKCfAdPypbJCZdT_LsXVn0euwWd
    9HOZOuOO_eLzfo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3pTMX04dONPV5xvBWFz10fcmrf7kO4e-BoZ5eFSHF6qpP1Oqh_kxnA>
    <xmx:3pTMX136A0YmyqVSXgrFoSPWQ0tYjtaShETvJ-YXlxLgkKQvCpDLIA>
    <xmx:3pTMX_HroBL40qfHx3u2heXODbWfL6XEi1iP6y-CmhIRvuTeLUcEZQ>
    <xmx:3pTMX3BsVa-ZSLiNqC5se1AOh418nScBwE9bMxsvC5sn8qMt0YI6wg>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C6B3108005B;
        Sun,  6 Dec 2020 03:22:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] selftests: mlxsw: Test RIF's reference count when joining a LAG
Date:   Sun,  6 Dec 2020 10:22:22 +0200
Message-Id: <20201206082227.1857042-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that the reference count of a router interface (RIF) configured for
a LAG is incremented / decremented when ports join / leave the LAG. Use
the offload indication on routes configured on the RIF to understand if
it was created / destroyed.

The test fails without the previous patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index a2eff5f58209..ed346da5d3cb 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -22,6 +22,7 @@ ALL_TESTS="
 	duplicate_vlans_test
 	vlan_rif_refcount_test
 	subport_rif_refcount_test
+	subport_rif_lag_join_test
 	vlan_dev_deletion_test
 	lag_unlink_slaves_test
 	lag_dev_deletion_test
@@ -440,6 +441,48 @@ subport_rif_refcount_test()
 	ip link del dev bond1
 }
 
+subport_rif_lag_join_test()
+{
+	# Test that the reference count of a RIF configured for a LAG is
+	# incremented / decremented when ports join / leave the LAG. We use the
+	# offload indication on routes configured on the RIF to understand if
+	# it was created / destroyed
+	RET=0
+
+	ip link add name bond1 type bond mode 802.3ad
+	ip link set dev $swp1 down
+	ip link set dev $swp2 down
+	ip link set dev $swp1 master bond1
+	ip link set dev $swp2 master bond1
+
+	ip link set dev bond1 up
+	ip -6 address add 2001:db8:1::1/64 dev bond1
+
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
+	check_err $? "subport rif was not created on lag device"
+
+	ip link set dev $swp1 nomaster
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
+	check_err $? "subport rif of lag device was destroyed after removing one port"
+
+	ip link set dev $swp1 master bond1
+	ip link set dev $swp2 nomaster
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
+	check_err $? "subport rif of lag device was destroyed after re-adding a port and removing another"
+
+	ip link set dev $swp1 nomaster
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
+	check_err $? "subport rif of lag device was not destroyed when should"
+
+	log_test "subport rif lag join"
+
+	ip link del dev bond1
+}
+
 vlan_dev_deletion_test()
 {
 	# Test that VLAN devices are correctly deleted / unlinked when enslaved
-- 
2.28.0

