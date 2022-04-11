Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F384FB63C
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiDKInk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbiDKInf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:43:35 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EC63D4A1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:20 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u7so8208947lfs.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=e7IjdhPKEVh1ILxXP0o9ofaJvPijy5TyOaJH5gWrzSo=;
        b=CG69gl74fRXhya4eLFC2KbyTlkiTOQUfJ0CqTKGenEhzBRLHESehB2tnCquvSwHp9V
         8SMqS50EaoIbfSPADm86/PKfHoBBmVzE39VIBPdpxhkJkPilkH3vztEfv3WkKvglG1Os
         PuqTSsqBr2RuqS/OZiqe3QORivaD67vSahID8wyRBvrivLtQyvh2pnHU8lvqiKi42tPP
         +A7yJMKoDapprK+zyFWrnq4HlejGJ+SqUcy1CbfwUqjY2GjGeP6jaqbQtqz54pBM65s6
         d1V6NoauDuqLA/hv7/CkSd40hEmp5yCDGBhxITP3i+zGdGFdAa9sslFpeEpk7k4WH1YP
         HVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=e7IjdhPKEVh1ILxXP0o9ofaJvPijy5TyOaJH5gWrzSo=;
        b=2BacB8ZcpHrJqTEFlc44zUC8MaGO4GD2h4VmIi5UipOAzBnT/VULh7qZvCETrKKLeM
         YDup+DreBzAeIMEXh5x2mzLRp9P2JSi0roV2SkXUjgrzX6KuKyWGlJgIt6YoXOJSxTMP
         vD+S3PpnCnlgI+Cjzk3QBn5lL6KVT823+L9X8TUURGDSqBAKeekG2ikMuG4HXonmvbY0
         6mFUxQ44CICqCFaBMa4XWFUZut758kj1+qi/RlFiEF88DYg44xgjRxm/8UwuCh84TcNj
         efweYhbRZ7io6x92T3Hl1TJmxlKVHOb/wmncoO2qf6R42EQMZ3YUN8v3BVtWv9nhTW48
         I6fg==
X-Gm-Message-State: AOAM533EORQ95mZvf332L2bwbX97+LXI1Fhjuv8tDDvLquQ334Nxv5kK
        CIBytQ3U7c0jTYaSFcDZHyfEteqVRhxzVaMa
X-Google-Smtp-Source: ABdhPJwdM/7oBZs5n1xaB3RwYAFSEvoTFzMB0BeIbziN9YE1pQQ3sgHq8emQrtip5/Es8R74XrPYeA==
X-Received: by 2002:a05:6512:1681:b0:464:fa16:393d with SMTP id bu1-20020a056512168100b00464fa16393dmr11996924lfb.672.1649666477820;
        Mon, 11 Apr 2022 01:41:17 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id x24-20020a056512047800b0046b9dafd55bsm549080lfd.164.2022.04.11.01.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:41:16 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH v2 net-next 2/2] selftests: forwarding: new test, verify host mdb entries
Date:   Mon, 11 Apr 2022 10:40:54 +0200
Message-Id: <20220411084054.298807-3-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411084054.298807-1-troglobit@gmail.com>
References: <20220223172407.175865-1-troglobit@gmail.com>
 <20220411084054.298807-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Boiler plate for testing static mdb entries.  This first test verifies
adding and removing host mdb entries for all supported types: IPv4,
IPv6, and MAC multicast.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_mdb.sh    | 103 ++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 8fa97ae9af9e..ae80c2aef577 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -2,6 +2,7 @@
 
 TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
+	bridge_mdb.sh \
 	bridge_port_isolation.sh \
 	bridge_sticky_fdb.sh \
 	bridge_vlan_aware.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
new file mode 100755
index 000000000000..b1ba6876dd86
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -0,0 +1,103 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that adding host mdb entries work as intended for all types of
+# multicast filters: ipv4, ipv6, and mac
+
+ALL_TESTS="mdb_add_del_test"
+NUM_NETIFS=2
+
+TEST_GROUP_IP4="225.1.2.3"
+TEST_GROUP_IP6="ff02::42"
+TEST_GROUP_MAC="01:00:01:c0:ff:ee"
+
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+switch_create()
+{
+	# Enable multicast filtering
+	ip link add dev br0 type bridge mcast_snooping 1
+
+	ip link set dev $swp1 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+}
+
+switch_destroy()
+{
+	ip link set dev $swp1 down
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	vrf_prepare
+
+	h1_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+do_mdb_add_del()
+{
+	local group=$1
+	local flag=$2
+
+	RET=0
+	bridge mdb add dev br0 port br0 grp $group $flag 2>/dev/null
+	check_err $? "Failed adding $group to br0, port br0"
+
+	if [ -z "$flag" ]; then
+	    flag="temp"
+	fi
+
+	bridge mdb show dev br0 | grep $group | grep -q $flag 2>/dev/null
+	check_err $? "$group not added with $flag flag"
+
+	bridge mdb del dev br0 port br0 grp $group 2>/dev/null
+	check_err $? "Failed deleting $group from br0, port br0"
+
+	bridge mdb show dev br0 | grep -q $group >/dev/null
+	check_err_fail 1 $? "$group still in mdb after delete"
+
+	log_test "MDB add/del group $group to bridge port br0"
+}
+
+mdb_add_del_test()
+{
+	do_mdb_add_del $TEST_GROUP_MAC permanent
+	do_mdb_add_del $TEST_GROUP_IP4
+	do_mdb_add_del $TEST_GROUP_IP6
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
2.25.1

