Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99545550C17
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiFSQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 12:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSQhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 12:37:19 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBE9B491;
        Sun, 19 Jun 2022 09:37:17 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 959DE240005;
        Sun, 19 Jun 2022 16:37:13 +0000 (UTC)
From:   Riccardo Paolo Bestetti <pbl@bestov.io>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Riccardo Paolo Bestetti <pbl@bestov.io>,
        Carlos Llamas <cmllamas@google.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] ipv4: fix bind address validity regression tests
Date:   Sun, 19 Jun 2022 18:27:35 +0200
Message-Id: <20220619162734.113340-1-pbl@bestov.io>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
introduces support for binding to nonlocal addresses, as well as some
basic test coverage for some of the related cases.

Commit b4a028c4d031 ("ipv4: ping: fix bind address validity check")
fixes a regression which incorrectly removed some checks for bind
address validation. In addition, it introduces regression tests for
those specific checks. However, those regression tests are defective, in
that they perform the tests using an incorrect combination of bind
flags. As a result, those tests fail when they should succeed.

This commit introduces additional regression tests for nonlocal binding
and fixes the defective regression tests. It also introduces new
set_sysctl calls for the ipv4_bind test group, as to perform the ICMP
binding tests it is necessary to allow ICMP socket creation by setting
the net.ipv4.ping_group_range knob.

Fixes: b4a028c4d031 ("ipv4: ping: fix bind address validity check")
Reported-by: Riccardo Paolo Bestetti <pbl@bestov.io>
Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
---
This has been tested on the net tree (@ b4a028c4d031) w/ the following:
$ cd $KERNEL_TREE/tools/testing/selftests/net
$ make nettest
# PATH=$PATH:./ ./fcnal-test.sh -t ipv4_bind -v

All tests, including the previously broken ones and the new tests, pass
with the expected results.

 tools/testing/selftests/net/fcnal-test.sh | 36 +++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 75223b63e3c8..03b586760164 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1800,24 +1800,32 @@ ipv4_addr_bind_novrf()
 	done
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
-	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
+	run_cmd nettest -s -R -f -l ${a} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -f -l ${a} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address"
 
 	#
 	# check that ICMP sockets cannot bind to broadcast and multicast addresses
 	#
 	a=${BCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -l ${a} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address"
 
 	a=${MCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address"
 
 	#
@@ -1870,24 +1878,32 @@ ipv4_addr_bind_vrf()
 	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -R -f -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
 
+	log_start
+	run_cmd nettest -s -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address after VRF bind"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address after VRF bind"
+
 	#
 	# check that ICMP sockets cannot bind to broadcast and multicast addresses
 	#
 	a=${BCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address after VRF bind"
 
 	a=${MCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address after VRF bind"
 
 	#
@@ -1922,10 +1938,12 @@ ipv4_addr_bind()
 
 	log_subsection "No VRF"
 	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_vrf
 }
 
-- 
2.36.1

