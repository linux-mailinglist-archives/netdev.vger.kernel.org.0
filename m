Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F734B0301
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiBJCCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:02:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbiBJCAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95E8D7B;
        Wed,  9 Feb 2022 17:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AB94B823DE;
        Thu, 10 Feb 2022 00:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B5C340F3;
        Thu, 10 Feb 2022 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453420;
        bh=g1CPzUf3kpfJu1yv8MbiwxU60ye8UpKazj3rrKl4QB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWqAqboGhvww68nO+z3IZfC9wI3Qo7V3vhfER15WqeYX20X83XwGs2/Z9n0jtVf5y
         Rtv2pbRVSeg2UfQSNzEIlOpAS4cCMAWtdejm6nmK5oJbS0tMU9p4sap650JqMZX/zT
         tsURMxttTV3Iq/8M64hd8juDljukwwITEFt4b+5+sJB0o3AIGe7Uw/DX80mx3DrElJ
         U1hDEz2HXWLT+RwiRZjVH9qCwypRjEOQ+tRS+dXO/Z8Rf5iraH8Q8dD4ZkIxMtx/Wx
         DLQMTj1907hJU1zrFTt+zG7J9EVUyXtNbMCKVWed1F0x7qKAO7Pl1m+q24KLiXTFVV
         qE7gmOFPUqSnw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/11] selftests: net: test standard socket cmsgs across UDP and ICMP sockets
Date:   Wed,  9 Feb 2022 16:36:49 -0800
Message-Id: <20220210003649.3120861-12-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test TIMESTAMPING and TXTIME across UDP / ICMP and IP versions.

Before ICMPv6 support:
  # ./tools/testing/selftests/net/cmsg_time.sh
    Case ICMPv6  - ts cnt returned '0', expected '2'
    Case ICMPv6  - ts0 SCHED returned '', expected 'OK'
    Case ICMPv6  - ts0 SND returned '', expected 'OK'
    Case ICMPv6  - TXTIME abs returned '', expected 'OK'
    Case ICMPv6  - TXTIME rel returned '', expected 'OK'
  FAIL - 5/36 cases failed

After:
  # ./tools/testing/selftests/net/cmsg_time.sh
  OK

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/Makefile     |  1 +
 tools/testing/selftests/net/cmsg_time.sh | 83 ++++++++++++++++++++++++
 2 files changed, 84 insertions(+)
 create mode 100755 tools/testing/selftests/net/cmsg_time.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8f4c1f16655f..3bfeaf06b960 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -30,6 +30,7 @@ TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
 TEST_PROGS += cmsg_so_mark.sh
+TEST_PROGS += cmsg_time.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
diff --git a/tools/testing/selftests/net/cmsg_time.sh b/tools/testing/selftests/net/cmsg_time.sh
new file mode 100755
index 000000000000..91161e1da734
--- /dev/null
+++ b/tools/testing/selftests/net/cmsg_time.sh
@@ -0,0 +1,83 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NS=ns
+IP4=172.16.0.1/24
+TGT4=172.16.0.2
+IP6=2001:db8:1::1/64
+TGT6=2001:db8:1::2
+
+cleanup()
+{
+    ip netns del $NS
+}
+
+trap cleanup EXIT
+
+# Namespaces
+ip netns add $NS
+
+ip netns exec $NS sysctl -w net.ipv4.ping_group_range='0 2147483647' > /dev/null
+
+# Connectivity
+ip -netns $NS link add type dummy
+ip -netns $NS link set dev dummy0 up
+ip -netns $NS addr add $IP4 dev dummy0
+ip -netns $NS addr add $IP6 dev dummy0
+
+# Need FQ for TXTIME
+ip netns exec $NS tc qdisc replace dev dummy0 root fq
+
+# Test
+BAD=0
+TOTAL=0
+
+check_result() {
+    ((TOTAL++))
+    if [ $1 -ne 0 ]; then
+	echo "  Case $4 returned $1, expected 0"
+	((BAD++))
+    elif [ "$2" != "$3" ]; then
+	echo "  Case $4 returned '$2', expected '$3'"
+	((BAD++))
+    fi
+}
+
+for i in "-4 $TGT4" "-6 $TGT6"; do
+    for p in u i r; do
+	[ $p == "u" ] && prot=UDPv${i:1:2}
+	[ $p == "i" ] && prot=ICMPv${i:1:2}
+	[ $p == "r" ] && prot=RAWv${i:1:2}
+
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234)
+	check_result $? "$ts" "" "$prot - no options"
+
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234 -t | wc -l)
+	check_result $? "$ts" "2" "$prot - ts cnt"
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234 -t |
+		 sed -n "s/.*SCHED ts0 [0-9].*/OK/p")
+	check_result $? "$ts" "OK" "$prot - ts0 SCHED"
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234 -t |
+		 sed -n "s/.*SND ts0 [0-9].*/OK/p")
+	check_result $? "$ts" "OK" "$prot - ts0 SND"
+
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234 -t -d 1000 |
+		 awk '/SND/ { if ($3 > 1000) print "OK"; }')
+	check_result $? "$ts" "OK" "$prot - TXTIME abs"
+
+	ts=$(ip netns exec $NS ./cmsg_sender -p $p $i 1234 -t -d 1000 |
+		 awk '/SND/ {snd=$3}
+		      /SCHED/ {sch=$3}
+		      END { if (snd - sch > 500) print "OK"; }')
+	check_result $? "$ts" "OK" "$prot - TXTIME rel"
+    done
+done
+
+# Summary
+if [ $BAD -ne 0 ]; then
+    echo "FAIL - $BAD/$TOTAL cases failed"
+    exit 1
+else
+    echo "OK"
+    exit 0
+fi
-- 
2.34.1

