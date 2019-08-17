Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BE191094
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfHQNbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:31:07 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46427 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfHQNbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:31:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 162B576;
        Sat, 17 Aug 2019 09:31:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Y/cL/27/fI+e8IufG923syOnQAL5BeU0mRvPVC718bU=; b=Os2C6UVZ
        NQ70g36jJYjAftfptPsphpPLsHoB8se5ZVC/67U8D+fI5HwEOIQlEwApkZVuI2Dm
        9duUDeevaS2AB4pCTztgoX9WV6Xd4I2wW1nADwKIMh9PZQae5OxyNyF0L/atM+Gm
        y+87GQLk085GbLxBSoSyNZIIu+jTVev6daSkasjaHv52GmHY0cmZcPZ/Rn8GO3Jy
        x6Tsfe9ZdLQTQXIu1ccuIbIext+QE/ROYLRruLp07egLmRlpIrQOFMvVATZf9pkq
        jw0tgnECusFMP4o0dtNQnFJADXLu2Wk8+MYnYmcIUsov9aU2BCsnqa3f+O58JrDR
        8NW01HaZiJuvEg==
X-ME-Sender: <xms:mQFYXcCSz27OIniVVm6GYVsSBM-Rh866vIlwoYxPvnxec0fcAtEuEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddu
X-ME-Proxy: <xmx:mQFYXT6nwmcFf3I8a64P_HCipjtSGj_jxotADCsxyXWpR5zAF5QnQA>
    <xmx:mQFYXTNkoHqCU_nS5KX9qoUEp9foERoBYBPtD4Tdv6mcvdO2kG-fyA>
    <xmx:mQFYXSr1NDKHNesgrhPbyp3DOVzo6tjX17EOYn0yncEBpGZP8aUDtQ>
    <xmx:mgFYXTW3Sx_EDBvs-ujO07TzI2C58RVMN8UsA4KNMdjAm1Gh-1HP9w>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E82B8005C;
        Sat, 17 Aug 2019 09:31:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 14/16] selftests: forwarding: devlink_lib: Add devlink-trap helpers
Date:   Sat, 17 Aug 2019 16:28:23 +0300
Message-Id: <20190817132825.29790-15-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add helpers to interact with devlink-trap, such as setting the action of
a trap and retrieving statistics.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 163 ++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 2b9296f6aa07..13d03a6d85ba 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -29,6 +29,12 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
+devlink help 2>&1 | grep trap &> /dev/null
+if [ $? -ne 0 ]; then
+	echo "SKIP: iproute2 too old, missing devlink trap support"
+	exit 1
+fi
+
 ##############################################################################
 # Devlink helpers
 
@@ -192,3 +198,160 @@ devlink_tc_bind_pool_th_restore()
 	devlink sb tc bind set $port tc $tc type $dir \
 		pool ${orig[0]} th ${orig[1]}
 }
+
+devlink_traps_num_get()
+{
+	devlink -j trap | jq '.[]["'$DEVLINK_DEV'"] | length'
+}
+
+devlink_traps_get()
+{
+	devlink -j trap | jq -r '.[]["'$DEVLINK_DEV'"][].name'
+}
+
+devlink_trap_type_get()
+{
+	local trap_name=$1; shift
+
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].type'
+}
+
+devlink_trap_action_set()
+{
+	local trap_name=$1; shift
+	local action=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap set $DEVLINK_DEV trap $trap_name \
+		action $action &> /dev/null
+}
+
+devlink_trap_action_get()
+{
+	local trap_name=$1; shift
+
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].action'
+}
+
+devlink_trap_group_get()
+{
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].group'
+}
+
+devlink_trap_metadata_test()
+{
+	local trap_name=$1; shift
+	local metadata=$1; shift
+
+	devlink -jv trap show $DEVLINK_DEV trap $trap_name \
+		| jq -e '.[][][].metadata | contains(["'$metadata'"])' \
+		&> /dev/null
+}
+
+devlink_trap_rx_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_rx_bytes_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t0_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+devlink_traps_enable_all()
+{
+	local trap_name
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_action_set $trap_name "trap"
+	done
+}
+
+devlink_traps_disable_all()
+{
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_action_set $trap_name "drop"
+	done
+}
+
+devlink_trap_groups_get()
+{
+	devlink -j trap group | jq -r '.[]["'$DEVLINK_DEV'"][].name'
+}
+
+devlink_trap_group_action_set()
+{
+	local group_name=$1; shift
+	local action=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap group set $DEVLINK_DEV group $group_name action $action \
+		&> /dev/null
+}
+
+devlink_trap_group_rx_packets_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_group_rx_bytes_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_group_stats_idle_test()
+{
+	local group_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t0_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t1_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
-- 
2.21.0

