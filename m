Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16456B915C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCNLQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjCNLQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:16:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300A5FA59
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:42 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so9856532wmq.2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678792537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6rNKWnv18aXCtS8BXdWSG3qLBLgCFJvz/stcHMS3qM=;
        b=xqCWR+s5p3BqXWX2LUnMtUclDIeHTo2/6gb26WBzQegEqD6037htJqSh1MPZAolkbE
         S0IkuSKb9Hhc/JczAy1Nfb9jxyd7AClSU035POjAuUvI32gcpI3+RtHTDGhBn5Z0zB5v
         9jyCFo3I6Stg2kwpgx2pBeH4vzyQwmdspT7QCTl3LWJT65hrW0d1FPL3wVHl6PIWABch
         7BCnniuFTDmIb0XrKKcfGlHQ7y9gVb6glt0h2GAgYNpkLDW9NLE3qO/hJzH4vtsV2I7R
         TuFRJeBdEynPGo1VrV9oQQ/7s8EeOLZQC1SlOnz9tm85znJzDrT+N/wz3dEMV2HIg/XH
         6bzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6rNKWnv18aXCtS8BXdWSG3qLBLgCFJvz/stcHMS3qM=;
        b=N2dXJJTLlCFcCLCzShwVTv+1rHl+JwxTfkcbjjyCF+yQ/9PtfjjIhjgnoeeSKv0bPR
         O1RXEHyxs11lPQe7xsSanKXAgsoX696WRFq8m2cnsl55xeCJ/71C5/RCLdMjKmYK+SKJ
         whLF2XGlbnftEyxl9KwmgTc+8nOtS0rsNgbaH29eOSTs8/ClXx0+iJYdaINAXmj7S3po
         3RFE301C6GmwN/sa0ROrZX4CohJ8NyB6gchLbemS2eE3hlOH3Bggy/VDrM3JwTfGDcdP
         xC2PcVTribpfKUE5wVQF8lFIfooVCWt807WA+gYTQisAgrZJaBAarHNWnwpa0NW9tAFA
         Tfig==
X-Gm-Message-State: AO0yUKWoCw/fF+sE+uCuWp/RdOT5XaSJA2/gw2r+Te4JtJdRAgFx02Kb
        T58pAmGiQ/YZKRCQ97LJ4MO3EyTXF2vX3mlJ/qk=
X-Google-Smtp-Source: AK7set9c/fPoYp/rcbRhM1mTL2stzQyaOtt4f+HETLPb/RKfVnOZOpyf0c0JX29xOOP9DzORZ4+9JA==
X-Received: by 2002:a05:600c:3595:b0:3ed:2a91:3bc9 with SMTP id p21-20020a05600c359500b003ed2a913bc9mr2588600wmq.15.1678792537670;
        Tue, 14 Mar 2023 04:15:37 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c2f8f00b003e1fee8baacsm2442323wmn.25.2023.03.14.04.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:15:37 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 4/4] selftests: bonding: add tests for ether type changes
Date:   Tue, 14 Mar 2023 13:14:26 +0200
Message-Id: <20230314111426.1254998-5-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314111426.1254998-1-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new network selftests for the bonding device which exercise the ether
type changing call paths. They also test for the recent syzbot bug[1] which
causes a warning and results in wrong device flags (IFF_SLAVE missing).
The test adds three bond devices and a nlmon device, enslaves one of the
bond devices to the other and then uses the nlmon device for successful
and unsuccesful enslaves both of which change the bond ether type. Thus
we can test for both MASTER and SLAVE flags at the same time.

If the flags are properly restored we get:
TEST: Change ether type of an enslaved bond device with unsuccessful enslave   [ OK ]
TEST: Change ether type of an enslaved bond device with successful enslave   [ OK ]

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 8e3b786a748f..a39bb2560d9b 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -8,7 +8,8 @@ TEST_PROGS := \
 	dev_addr_lists.sh \
 	mode-1-recovery-updelay.sh \
 	mode-2-recovery-updelay.sh \
-	option_prio.sh
+	option_prio.sh \
+	bond-eth-type-change.sh
 
 TEST_FILES := \
 	lag_lib.sh \
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
new file mode 100755
index 000000000000..5cdd22048ba7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
@@ -0,0 +1,85 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bond device ether type changing
+#
+
+ALL_TESTS="
+	bond_test_unsuccessful_enslave_type_change
+	bond_test_successful_enslave_type_change
+"
+REQUIRE_MZ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/net_forwarding_lib.sh
+
+bond_check_flags()
+{
+	local bonddev=$1
+
+	ip -d l sh dev "$bonddev" | grep -q "MASTER"
+	check_err $? "MASTER flag is missing from the bond device"
+
+	ip -d l sh dev "$bonddev" | grep -q "SLAVE"
+	check_err $? "SLAVE flag is missing from the bond device"
+}
+
+# test enslaved bond dev type change from ARPHRD_ETHER and back
+# this allows us to test both MASTER and SLAVE flags at once
+bond_test_enslave_type_change()
+{
+	local test_success=$1
+	local devbond0="test-bond0"
+	local devbond1="test-bond1"
+	local devbond2="test-bond2"
+	local nonethdev="test-noneth0"
+
+	# create a non-ARPHRD_ETHER device for testing (e.g. nlmon type)
+	ip link add name "$nonethdev" type nlmon
+	check_err $? "could not create a non-ARPHRD_ETHER device (nlmon)"
+	ip link add name "$devbond0" type bond
+	if [ $test_success -eq 1 ]; then
+		# we need devbond0 in active-backup mode to successfully enslave nonethdev
+		ip link set dev "$devbond0" type bond mode active-backup
+		check_err $? "could not change bond mode to active-backup"
+	fi
+	ip link add name "$devbond1" type bond
+	ip link add name "$devbond2" type bond
+	ip link set dev "$devbond0" master "$devbond1"
+	check_err $? "could not enslave $devbond0 to $devbond1"
+	# change bond type to non-ARPHRD_ETHER
+	ip link set dev "$nonethdev" master "$devbond0" 1>/dev/null 2>/dev/null
+	ip link set dev "$nonethdev" nomaster 1>/dev/null 2>/dev/null
+	# restore ARPHRD_ETHER type by enslaving such device
+	ip link set dev "$devbond2" master "$devbond0"
+	check_err $? "could not enslave $devbond2 to $devbond0"
+	ip link set dev "$devbond1" nomaster
+
+	bond_check_flags "$devbond0"
+
+	# clean up
+	ip link del dev "$devbond0"
+	ip link del dev "$devbond1"
+	ip link del dev "$devbond2"
+	ip link del dev "$nonethdev"
+}
+
+bond_test_unsuccessful_enslave_type_change()
+{
+	RET=0
+
+	bond_test_enslave_type_change 0
+	log_test "Change ether type of an enslaved bond device with unsuccessful enslave"
+}
+
+bond_test_successful_enslave_type_change()
+{
+	RET=0
+
+	bond_test_enslave_type_change 1
+	log_test "Change ether type of an enslaved bond device with successful enslave"
+}
+
+tests_run
+
+exit "$EXIT_STATUS"
-- 
2.39.2

