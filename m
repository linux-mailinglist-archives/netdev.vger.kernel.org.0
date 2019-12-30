Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006C912D4C7
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfL3WTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbfL3WTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:36 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0F721655;
        Mon, 30 Dec 2019 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743881;
        bh=2nqATkrqIbVncHRSegUoYpz52Gi0HNSX4fYuVXWq9u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luxTxqjyeS1/b6OF0Ht/fj8NCtjV2s83qa6M77DvGYsNzDBFxQaTwP+YaW8NmD4i9
         oFDUBBw5VQcG0a36kE2jXrLNXMWLb3YqILH0JU89iRnhCp3mCq0VodqCJDvDx2VsTx
         1gdxsIZshidXyPkFol4SV1crZd/tAf3cE8mU6zuw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 8/9] fcnal-test: Add TCP MD5 tests
Date:   Mon, 30 Dec 2019 14:14:32 -0800
Message-Id: <20191230221433.2717-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add tests for existing TCP MD5 APIs - both single address
config and the new extended API for prefixes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 145 ++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 9fd3a0b97f0d..e630c6a7ee72 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -45,17 +45,22 @@ VRF_TABLE=1101
 NSA_IP=172.16.1.1
 NSB_IP=172.16.1.2
 VRF_IP=172.16.3.1
+NS_NET=172.16.1.0/24
 
 # IPv6 config
 NSA_IP6=2001:db8:1::1
 NSB_IP6=2001:db8:1::2
 VRF_IP6=2001:db8:3::1
+NS_NET6=2001:db8:1::/120
 
 NSA_LO_IP=172.16.2.1
 NSB_LO_IP=172.16.2.2
 NSA_LO_IP6=2001:db8:2::1
 NSB_LO_IP6=2001:db8:2::2
 
+MD5_PW=abc123
+MD5_WRONG_PW=abc1234
+
 MCAST=ff02::1
 # set after namespace create
 NSA_LINKIP6=
@@ -714,6 +719,74 @@ ipv4_ping()
 ################################################################################
 # IPv4 TCP
 
+#
+# MD5 tests without VRF
+#
+ipv4_tcp_md5_novrf()
+{
+	#
+	# single address
+	#
+
+	# basic use case
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: Single address config"
+
+	# client sends MD5, server not configured
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: Client uses wrong password"
+
+	# client from different address
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: Client address does not match address configured with password"
+
+	#
+	# MD5 extension - prefix length
+	#
+
+	# client in prefix
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
+}
+
 ipv4_tcp_novrf()
 {
 	local a
@@ -831,6 +904,8 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
+
+	ipv4_tcp_md5_novrf
 }
 
 ipv4_tcp_vrf()
@@ -1961,6 +2036,74 @@ ipv6_ping()
 ################################################################################
 # IPv6 TCP
 
+#
+# MD5 tests without VRF
+#
+ipv6_tcp_md5_novrf()
+{
+	#
+	# single address
+	#
+
+	# basic use case
+	log_start
+	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: Single address config"
+
+	# client sends MD5, server not configured
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -6 -s &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: Client uses wrong password"
+
+	# client from different address
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_LO_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: Client address does not match address configured with password"
+
+	#
+	# MD5 extension - prefix length
+	#
+
+	# client in prefix
+	log_start
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
+}
+
 ipv6_tcp_novrf()
 {
 	local a
@@ -2077,6 +2220,8 @@ ipv6_tcp_novrf()
 		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
+
+	ipv6_tcp_md5_novrf
 }
 
 ipv6_tcp_vrf()
-- 
2.11.0

