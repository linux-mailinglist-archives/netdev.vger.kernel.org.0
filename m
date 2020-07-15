Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0035220732
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgGOI2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39105 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730058AbgGOI2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7E16E5C0186;
        Wed, 15 Jul 2020 04:28:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Chksc6joR66Qc75I6nvCWHxKi0LExhOzdGT3jMub3s8=; b=Dvf09pvq
        1TuNGlBT9Zh1/5DtDV1LV8oyYlVAmgHfvlUfUZsCqbk7PdfBQqZAnuMT8IsesJhj
        vnWNJ9tHZ8inDUDslfDqdJj5bbSRSonTsYpc78JHgmo5HtVUNcYDVpUQIsCUCL2A
        rkQp83TXIgVwI2uTa/YXje3GAPRF7jAHxJghHCrQxfJoNCH4/01CIBv9cgFBWbZP
        sWgtY4twzEVFFde7y9D3ZDzC37oVGA5lzTlsIUgIoWJDESYRljtYBDynSMc/0QTt
        5i3LK+D4mOrdZm2ky0TAWY1bE7eUO68sMqnuYnLRJcoZAFMINlXKORYlOVPnG+Pr
        mQLu8GEIkj7xyQ==
X-ME-Sender: <xms:Jb4OXzkFdRlfFcRCSQosJINMIgLq0Sec9Pd14ExgEllR8o-fpUHaBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Jb4OX22LBoDMjGj4T7atbwaDofZWO-tHdKGLpDRZoT2xp2ObaX6Hlg>
    <xmx:Jb4OX5qj6WlfaiHSghKxW0HHmFqsAl6Ngg1AXCn5KkBn4QhO0gzPoA>
    <xmx:Jb4OX7lwUqQeUI6Q5FxfDUqTd6wdhYhJsAfNKKpfgbJ5zYQI6fb6ww>
    <xmx:Jb4OX_As5M8VeYcJqkGRGyRiZO0buMYT-_a06J8a5g9iYB6r0lSocg>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3A6B3280063;
        Wed, 15 Jul 2020 04:28:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/11] selftests: mlxsw: tc_restrictions: Test tc-police restrictions
Date:   Wed, 15 Jul 2020 11:27:31 +0300
Message-Id: <20200715082733.429610-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that upper and lower limits on rate and burst size imposed by the
device are rejected by the kernel.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../drivers/net/mlxsw/tc_restrictions.sh      | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 9241250c5921..553cb9fad508 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -11,6 +11,8 @@ ALL_TESTS="
 	matchall_mirror_behind_flower_ingress_test
 	matchall_sample_behind_flower_ingress_test
 	matchall_mirror_behind_flower_egress_test
+	police_limits_test
+	multi_police_test
 "
 NUM_NETIFS=2
 
@@ -287,6 +289,80 @@ matchall_mirror_behind_flower_egress_test()
 	matchall_behind_flower_egress_test "mirror" "mirred egress mirror dev $swp2"
 }
 
+police_limits_test()
+{
+	RET=0
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 0.5kbit burst 1m conform-exceed drop/ok
+	check_fail $? "Incorrect success to add police action with too low rate"
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 2.5tbit burst 1g conform-exceed drop/ok
+	check_fail $? "Incorrect success to add police action with too high rate"
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 1.5kbit burst 1m conform-exceed drop/ok
+	check_err $? "Failed to add police action with low rate"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 1.9tbit burst 1g conform-exceed drop/ok
+	check_err $? "Failed to add police action with high rate"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 1.5kbit burst 512b conform-exceed drop/ok
+	check_fail $? "Incorrect success to add police action with too low burst size"
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		flower skip_sw \
+		action police rate 1.5kbit burst 2k conform-exceed drop/ok
+	check_err $? "Failed to add police action with low burst size"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "police rate and burst limits"
+}
+
+multi_police_test()
+{
+	RET=0
+
+	# It is forbidden in mlxsw driver to have multiple police
+	# actions in a single rule.
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 \
+		flower skip_sw \
+		action police rate 100mbit burst 100k conform-exceed drop/ok
+	check_err $? "Failed to add rule with single police action"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 \
+		flower skip_sw \
+		action police rate 100mbit burst 100k conform-exceed drop/pipe \
+		action police rate 200mbit burst 200k conform-exceed drop/ok
+	check_fail $? "Incorrect success to add rule with two police actions"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "multi police"
+}
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
-- 
2.26.2

