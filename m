Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF4563609
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiGAOn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiGAOn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:43:58 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B448A13E84;
        Fri,  1 Jul 2022 07:43:55 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v9so2866696ljk.10;
        Fri, 01 Jul 2022 07:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=tYCnn8R4xNTj7zmMhb4TNnMs9+GKNqUHo8dm/fGJ1xE=;
        b=Y1ZSKsljxR+K7RGEjqMJMpsXJMolYI5QVaiMPMj3h79OeYQn8enbgT1P5gptKtAW+t
         0AtveKLt+CA0UHY2m2bk9jUtigBK0fJocifRjop7sFQDav7jf4ymYvvFoGnyaWA+Wyrn
         1YJdohonW28CH2zT7EgM5YdcEJmxfjFS+S3PaTRLp6wTTyTdJTNpOC8iuc9BZWLEMF6b
         HoQIvRLlqPhQVMQe6XmxAnE1c9iV2V1qFnuRTBXi9kivkKlHuQhs/DlI7MgeCDZzfLSp
         AjwYAoYba8Gzt0vk5qDifYHAaBXjdVuaO7e3NYRQennj2Y3hjAa2MmYG+vV9IJTxgrYl
         4sQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=tYCnn8R4xNTj7zmMhb4TNnMs9+GKNqUHo8dm/fGJ1xE=;
        b=kzEyMaDHzphXK+Hb6SdQhI0AJUdJu/l2+0x9QkUgpnAIfv3vCCRd0LY5u50BpHLej/
         YU2vl25dlMKlU80l2GWcgiJpPeIN04Q78ZMeGjNpi3+0WM7sRwbgVxxuilj0uE9yFAjQ
         lvfaFilsHIe6mEOgz6YcUCtBOTerbTVJ+q/omJyoMcEYZfRbEQpqKhsvsIT3V7EObrX6
         RHU1x4RknOXVWgg3eBi5OntS5VqDKOYHj4LBpvfd7dEdhycxmcayi42A4BtroSywricV
         a5y2VIMKJ9wzHhkTVv59B069GWtu2Nz3jguA1yo3FWG9kS8qVKZ8+KR8FruFo1oze7bZ
         GDgw==
X-Gm-Message-State: AJIora9HSLOMKa/T1qBzDimiL5E5OS5WcmTasUg4o08Jkt/2+M9QXL2l
        uQxQ1X5RImMBmcFfCPYEPMkCmvRV9YoJ0s0veCw=
X-Google-Smtp-Source: AGRyM1s7Ce93jQIH316rF0tBL1LJz3ojzUFFLkFXKeEURwp2dncgojJSD3ovOcCef+DyHv7oJNB0vg==
X-Received: by 2002:a2e:990:0:b0:25a:7c03:eb70 with SMTP id 138-20020a2e0990000000b0025a7c03eb70mr8636969ljj.350.1656686633866;
        Fri, 01 Jul 2022 07:43:53 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v13-20020ac2560d000000b0047f8790085csm3655746lfd.71.2022.07.01.07.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 07:43:52 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next] selftest: net: bridge mdb add/del entry to port that is down
Date:   Fri,  1 Jul 2022 16:43:50 +0200
Message-Id: <20220701144350.2034989-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
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

Tests that permanent mdb entries can be added/deleted on ports with state down.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
This feature was implemented recently and a selftest was suggested:
https://lore.kernel.org/netdev/20220614063223.zvtrdrh7pbkv3b4v@wse-c0155/

 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_mdb_port_down.sh    | 118 ++++++++++++++++++
 2 files changed, 119 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_port_down.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 8f481218a492..669ffd6f2a68 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -3,6 +3,7 @@
 TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
 	bridge_mdb.sh \
+	bridge_mdb_port_down.sh \
 	bridge_mld.sh \
 	bridge_port_isolation.sh \
 	bridge_sticky_fdb.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb_port_down.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_port_down.sh
new file mode 100755
index 000000000000..8c73d21441bf
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb_port_down.sh
@@ -0,0 +1,118 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that permanent mdb entries can be added to and deleted from bridge
+# interfaces that are down, and works correctly when done so.
+
+ALL_TESTS="add_del_to_port_down"
+NUM_NETIFS=4
+
+TEST_GROUP="239.10.10.10"
+TEST_GROUP_MAC="01:00:5e:0a:0a:0a"
+
+source lib.sh
+
+
+add_del_to_port_down() {
+	RET=0
+
+	ip link set dev $swp2 down
+	bridge mdb add dev br0 port "$swp2" grp $TEST_GROUP permanent 2>/dev/null
+	check_err $? "Failed adding mdb entry"
+
+	ip link set dev $swp2 up
+	setup_wait_dev $swp2
+	mcast_packet_test $TEST_GROUP_MAC 192.0.2.1 $TEST_GROUP $h1 $h2
+	check_fail $? "Traffic to $TEST_GROUP wasn't forwarded"
+
+	ip link set dev $swp2 down
+	bridge mdb show dev br0 | grep -q "$TEST_GROUP permanent" 2>/dev/null
+	check_err $? "MDB entry did not persist after link up/down"
+
+	bridge mdb del dev br0 port "$swp2" grp $TEST_GROUP 2>/dev/null
+	check_err $? "Failed deleting mdb entry"
+
+	ip link set dev $swp2 up
+	setup_wait_dev $swp2
+	mcast_packet_test $TEST_GROUP_MAC 192.0.2.1 $TEST_GROUP $h1 $h2
+	check_err $? "Traffic to $TEST_GROUP was forwarded after entry removed"
+
+	log_test "MDB add/del entry to port with state down "
+}
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
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	# Enable multicast filtering
+	ip link add dev br0 type bridge mcast_snooping 1 mcast_querier 1
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+
+	bridge link set dev $swp2 mcast_flood off
+	# Bridge currently has a "grace time" at creation time before it
+	# forwards multicast according to the mdb. Since we disable the
+	# mcast_flood setting per port
+	sleep 10
+}
+
+switch_destroy()
+{
+	ip link set dev $swp1 down
+	ip link set dev $swp2 down
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h1_destroy
+	h2_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+tests_run
+exit $EXIT_STATUS
-- 
2.30.2

