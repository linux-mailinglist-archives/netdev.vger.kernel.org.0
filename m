Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB91711C4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgB0Hut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43722 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbgB0Huk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id c13so2021196wrq.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tyV9lcuBVrqFGYoHSGSXpAbJnERsNWRXUp/Gmv6cyH0=;
        b=nEONzRwsGDMvKUJ+ebLxaw9hhwamy/wf81aKa42SdxFn4/eVtlMdmG5adGac0DDmqv
         9W58uIrefKk8MQg/UZNRzZYwtBemYcLJlE1xoAfLIwgXQcm4MaWXrt+YVVI1oOwdoyHV
         PH6vqyHceYFmQx04I99zZd5nnkCmK3HP2jtqWaLYhjPikPXZZGKqILO9ms/2I1/ji/h4
         xg0LSKmUoCjpQ690wIusgw1WPs0hcfC35Eo820Me3ALv58w+lhe3skBi7SQqk2X7Bbsj
         qVYaI4LRWwqNTNuhnIXEqbzmHTQF8Llw+0ttdspEJyH3pzUU5ZUhpg0HezOmokysXTCI
         5Gqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tyV9lcuBVrqFGYoHSGSXpAbJnERsNWRXUp/Gmv6cyH0=;
        b=BER8erSsaXdoG15FIt/d8C1zGGpWI9Vo9veezUkJgovtVUmpST9z7uAnrLovAz+1QM
         1MZr8JSRkzP9tJADeakgc4AM1nFK1uWg/G3lLZP5l3dE88XYSy3cA4e3m7N4m+7yE15x
         +TtISFu8cDfx6jy5vndQ49IgVhrG50z+KR2fQrnylGe3+Mde2OkXqtmb9Mv1/yEznOqg
         82XESVCcvR1dUeKHRk2LDpove1tdQ+QOUw31ZJ843c9s+BPR47Rins+X5mcrJefpu1tI
         zHshgLNyAhoTVLgWyJGXBTdGmjR8dtHb49KydvLvpwl4fSVn33l30qGKKIe8Y7LNtuBk
         ELnw==
X-Gm-Message-State: APjAAAXM73DXgm2UOUVMepanhz39g89lh/cMjWfsphsozVu759nLW90C
        oVQQvw8c9XVUKETmySIJuDSOZPzf95w=
X-Google-Smtp-Source: APXvYqxnuvcdWCyNL5ZOa0hVixr22JK5rNEwaGPbh0hIn+QaNP//CPrMf4Xht3wnaF6KtiFJZqbi5Q==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr3479768wrn.29.1582789837946;
        Wed, 26 Feb 2020 23:50:37 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a26sm6557155wmm.18.2020.02.26.23.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 13/16] selftests: mlxsw: Add shared buffer traffic test
Date:   Thu, 27 Feb 2020 08:50:18 +0100
Message-Id: <20200227075021.3472-14-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Test the max shared buffer occupancy for port's pool and port's TC's (using
different types of packets).

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/mlxsw/sharedbuffer.sh         | 222 ++++++++++++++++++
 1 file changed, 222 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
new file mode 100755
index 000000000000..58f3a05f08af
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -0,0 +1,222 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	port_pool_test
+	port_tc_ip_test
+	port_tc_arp_test
+"
+
+NUM_NETIFS=2
+source ../../../net/forwarding/lib.sh
+source ../../../net/forwarding/devlink_lib.sh
+source mlxsw_lib.sh
+
+SB_POOL_ING=0
+SB_POOL_EGR_CPU=10
+
+SB_ITC_CPU_IP=3
+SB_ITC_CPU_ARP=2
+SB_ITC=0
+
+h1_create()
+{
+	simple_if_init $h1 192.0.1.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.1.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.1.2/24
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.1.2/24
+}
+
+sb_occ_pool_check()
+{
+	local dl_port=$1; shift
+	local pool=$1; shift
+	local exp_max_occ=$1
+	local max_occ
+	local err=0
+
+	max_occ=$(devlink sb -j occupancy show $dl_port \
+		  | jq -e ".[][][\"pool\"][\"$pool\"][\"max\"]")
+
+	if [[ "$max_occ" -ne "$exp_max_occ" ]]; then
+		err=1
+	fi
+
+	echo $max_occ
+	return $err
+}
+
+sb_occ_itc_check()
+{
+	local dl_port=$1; shift
+	local itc=$1; shift
+	local exp_max_occ=$1
+	local max_occ
+	local err=0
+
+	max_occ=$(devlink sb -j occupancy show $dl_port \
+		  | jq -e ".[][][\"itc\"][\"$itc\"][\"max\"]")
+
+	if [[ "$max_occ" -ne "$exp_max_occ" ]]; then
+		err=1
+	fi
+
+	echo $max_occ
+	return $err
+}
+
+sb_occ_etc_check()
+{
+	local dl_port=$1; shift
+	local etc=$1; shift
+	local exp_max_occ=$1; shift
+	local max_occ
+	local err=0
+
+	max_occ=$(devlink sb -j occupancy show $dl_port \
+		  | jq -e ".[][][\"etc\"][\"$etc\"][\"max\"]")
+
+	if [[ "$max_occ" -ne "$exp_max_occ" ]]; then
+		err=1
+	fi
+
+	echo $max_occ
+	return $err
+}
+
+port_pool_test()
+{
+	local exp_max_occ=288
+	local max_occ
+
+	devlink sb occupancy clearmax $DEVLINK_DEV
+
+	$MZ $h1 -c 1 -p 160 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
+		-t ip -q
+
+	devlink sb occupancy snapshot $DEVLINK_DEV
+
+	RET=0
+	max_occ=$(sb_occ_pool_check $dl_port1 $SB_POOL_ING $exp_max_occ)
+	check_err $? "Expected iPool($SB_POOL_ING) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h1) ingress pool"
+
+	RET=0
+	max_occ=$(sb_occ_pool_check $dl_port2 $SB_POOL_ING $exp_max_occ)
+	check_err $? "Expected iPool($SB_POOL_ING) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h2) ingress pool"
+
+	RET=0
+	max_occ=$(sb_occ_pool_check $cpu_dl_port $SB_POOL_EGR_CPU $exp_max_occ)
+	check_err $? "Expected ePool($SB_POOL_EGR_CPU) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "CPU port's egress pool"
+}
+
+port_tc_ip_test()
+{
+	local exp_max_occ=288
+	local max_occ
+
+	devlink sb occupancy clearmax $DEVLINK_DEV
+
+	$MZ $h1 -c 1 -p 160 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
+		-t ip -q
+
+	devlink sb occupancy snapshot $DEVLINK_DEV
+
+	RET=0
+	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
+	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h1) ingress TC - IP packet"
+
+	RET=0
+	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
+	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h2) ingress TC - IP packet"
+
+	RET=0
+	max_occ=$(sb_occ_etc_check $cpu_dl_port $SB_ITC_CPU_IP $exp_max_occ)
+	check_err $? "Expected egress TC($SB_ITC_CPU_IP) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "CPU port's egress TC - IP packet"
+}
+
+port_tc_arp_test()
+{
+	local exp_max_occ=96
+	local max_occ
+
+	if [[ $MLXSW_CHIP != "mlxsw_spectrum" ]]; then
+		exp_max_occ=144
+	fi
+
+	devlink sb occupancy clearmax $DEVLINK_DEV
+
+	$MZ $h1 -c 1 -p 160 -a $h1mac -A 192.0.1.1 -t arp -q
+
+	devlink sb occupancy snapshot $DEVLINK_DEV
+
+	RET=0
+	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
+	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h1) ingress TC - ARP packet"
+
+	RET=0
+	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
+	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "physical port's($h2) ingress TC - ARP packet"
+
+	RET=0
+	max_occ=$(sb_occ_etc_check $cpu_dl_port $SB_ITC_CPU_ARP $exp_max_occ)
+	check_err $? "Expected egress TC($SB_ITC_IP2ME) max occupancy to be $exp_max_occ, but got $max_occ"
+	log_test "CPU port's egress TC - ARP packet"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	dl_port1=$(devlink_port_by_netdev $h1)
+	dl_port2=$(devlink_port_by_netdev $h2)
+
+	cpu_dl_port=$(devlink_cpu_port_get)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.1

