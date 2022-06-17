Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49D6550168
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382355AbiFRAf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 20:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiFRAf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:35:28 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207BD65D28;
        Fri, 17 Jun 2022 17:35:26 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id C5E45200004;
        Sat, 18 Jun 2022 00:35:20 +0000 (UTC)
From:   Riccardo Paolo Bestetti <pbl@bestov.io>
To:     patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     cmllamas@google.com, dsahern@kernel.org, kernel-team@android.com,
        linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pbl@bestov.io, yoshfuji@linux-ipv6.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net] ipv4: fix bind address validity regression tests
Date:   Sat, 18 Jun 2022 01:46:49 +0200
Message-Id: <20220617234647.24309-1-pbl@bestov.io>
X-Mailer: git-send-email 2.36.1
In-Reply-To: CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning
References: 
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
introduced support for binding to nonlocal addresses, as well as some
basic test coverage for some of the cases.

Commit b4a028c4d031 ("ipv4: ping: fix bind address validity check")
fixes a regression which incorrectly removed some checks for bind
address validation. In addition, it introduces regression tests for
those specific checks. However, those regression tests are defective, in
that they perform the tests using an incorrect combination of bind
flags. As a result, those tests fail when they should succeed.

This commit introduces additional regression tests for nonlocal binding
and fixes the defective regression tests.

PLEASE NOTE THAT THIS PATCH SHOULD NOT BE APPLIED AS-IS. The ICMP
broadcast and multicast regression tests succeed, but they do so while
returning the wrong error status. In particular, it isn't the bind that
fails, but the socket creation. This is /not/ correct, and it must be
investigated to have proper regression testing. Other instances where
this happens are: 1) if the broadcast/multicast addresses are replace
with an allowed (e.g. local) address (bind should work, but socket is
never created in the first place); 2) the commented out tests (nonlocal
bind should work but ditto.) Additionally, please note that when the
test cases are manually (i.e. without the network namespace setup from
fcnal-test.sh) ran, the expected/correct outcome is observed. The reason
I'm submitting this patch for comments, is that I'm failing to
understand where the issue lies. (Disclamer: might be something
stupid/trivial that I'm plainly missing due to tunnel vision.)

Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
---
 tools/testing/selftests/net/fcnal-test.sh | 36 +++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 75223b63e3c8..778288539879 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1800,24 +1800,33 @@ ipv4_addr_bind_novrf()
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
+	# currently fails with ACCES
+	#log_start
+	#run_cmd nettest -s -D -P icmp -f -l ${a} -b
+	#log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address"
 
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
@@ -1870,24 +1879,33 @@ ipv4_addr_bind_vrf()
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
+	# currently fails with ACCES
+	#log_start
+	#run_cmd nettest -s -D -P icmp -f -l ${a} -I ${VRF} -b
+	#log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address after VRF bind"
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
-- 
2.36.1

