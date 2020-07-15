Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059CA220730
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgGOI2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35611 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730083AbgGOI2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7EFB05C00D7;
        Wed, 15 Jul 2020 04:28:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7TI0o1o7/3GGLZWv59loyzmAPUtXFViRmUtGGLaNtBM=; b=HAl3mo5/
        zoM9iIPMgEbznt93vCtrD0/TV9oixyab8iIkxxfvszx+RfyLDW22EKZnU/0DrLZG
        7cl3/tf2l/f1l/MfJzDnU/AVxNBPlbCB/ANDACMBgLFJnVenecYFTzu4IThcJ8D/
        C/smMVySjb9E0Q8CWkAnLb3uXxMZxoMbFdOTTCaeI8ke4G7FQHI8V4Zvtl6LGA8a
        j/feMGNWB/cT9pcbSYVW+doXBTi5Ypd0CyFMfvpjt04u+A3UnaCSn7Ok2xNib3lx
        ck+2H4Pk1p/qE4k6AOAwJFe11P5jcEBXZNo8pEepMLqYjdtAIuiZRFIQkryvVdcL
        y7lUgRR5DqeG+A==
X-ME-Sender: <xms:J74OX0aNPgLg6QoLTVAHJxvT-f-3tn_0gnLW310UKi-HtmBHCUnkrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:J74OX_YmDWAEOi4Vx40QD0qVMWiGd440kDEbJm9DNRm8mri0IKzUTw>
    <xmx:J74OX-_ywuze_BHLlAOqmVmuc4h80ZzQEounG_mU8bqWM7cayA91hA>
    <xmx:J74OX-qVe3DxBCUXNaTz-PorTxhTjUMCYR26Kc6xwd0ENxDo9d_kpg>
    <xmx:J74OX23H2beS06l4e_3XWErUa4omXPtotenA3EIWnknQXjXhSAWq4w>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D0CC3280063;
        Wed, 15 Jul 2020 04:28:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/11] selftests: mlxsw: Add scale test for tc-police
Date:   Wed, 15 Jul 2020 11:27:32 +0300
Message-Id: <20200715082733.429610-11-idosch@idosch.org>
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

Query the maximum number of supported policers using devlink-resource
and test that this number can be reached by configuring tc filters with
police action. Test that an error is returned in case the maximum number
is exceeded.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../net/mlxsw/spectrum-2/tc_police_scale.sh   | 16 ++++
 .../net/mlxsw/spectrum/resource_scale.sh      |  2 +-
 .../net/mlxsw/spectrum/tc_police_scale.sh     | 16 ++++
 .../drivers/net/mlxsw/tc_police_scale.sh      | 92 +++++++++++++++++++
 5 files changed, 126 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_police_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/tc_police_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index fd583a171db7..d7cf33a3f18d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -28,7 +28,7 @@ cleanup()
 
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre"
+ALL_TESTS="router tc_flower mirror_gre tc_police"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_police_scale.sh
new file mode 100644
index 000000000000..e79ac0dad1f4
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_police_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../tc_police_scale.sh
+
+tc_police_get_target()
+{
+	local should_fail=$1; shift
+	local target
+
+	target=$(devlink_resource_size_get global_policers single_rate_policers)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 43ba1b438f6d..43f662401bc3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -22,7 +22,7 @@ cleanup()
 devlink_sp_read_kvd_defaults
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre"
+ALL_TESTS="router tc_flower mirror_gre tc_police"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/tc_police_scale.sh
new file mode 100644
index 000000000000..e79ac0dad1f4
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/tc_police_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../tc_police_scale.sh
+
+tc_police_get_target()
+{
+	local should_fail=$1; shift
+	local target
+
+	target=$(devlink_resource_size_get global_policers single_rate_policers)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
new file mode 100644
index 000000000000..4b96561c462f
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TC_POLICE_NUM_NETIFS=2
+
+tc_police_h1_create()
+{
+	simple_if_init $h1
+}
+
+tc_police_h1_destroy()
+{
+	simple_if_fini $h1
+}
+
+tc_police_switch_create()
+{
+	simple_if_init $swp1
+	tc qdisc add dev $swp1 clsact
+}
+
+tc_police_switch_destroy()
+{
+	tc qdisc del dev $swp1 clsact
+	simple_if_fini $swp1
+}
+
+tc_police_rules_create()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
+
+	TC_POLICE_BATCH_FILE="$(mktemp)"
+
+	for ((i = 0; i < count; ++i)); do
+		cat >> $TC_POLICE_BATCH_FILE <<-EOF
+			filter add dev $swp1 ingress \
+				prot ip \
+				flower skip_sw \
+				action police rate 10mbit burst 100k \
+				conform-exceed drop/ok
+		EOF
+	done
+
+	tc -b $TC_POLICE_BATCH_FILE
+	check_err_fail $should_fail $? "Rule insertion"
+}
+
+__tc_police_test()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
+
+	tc_police_rules_create $count $should_fail
+
+	offload_count=$(tc filter show dev $swp1 ingress | grep in_hw | wc -l)
+	((offload_count == count))
+	check_err_fail $should_fail $? "tc police offload count"
+}
+
+tc_police_test()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
+
+	if ! tc_offload_check $TC_POLICE_NUM_NETIFS; then
+		check_err 1 "Could not test offloaded functionality"
+		return
+	fi
+
+	__tc_police_test $count $should_fail
+}
+
+tc_police_setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	vrf_prepare
+
+	tc_police_h1_create
+	tc_police_switch_create
+}
+
+tc_police_cleanup()
+{
+	pre_cleanup
+
+	tc_police_switch_destroy
+	tc_police_h1_destroy
+
+	vrf_cleanup
+}
-- 
2.26.2

