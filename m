Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB657E2BA
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbfHASzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbfHASzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88CD6217D4;
        Thu,  1 Aug 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685714;
        bh=//yN3fKaHjNl4t6I5kfOJyxHzSdJCJQjx4ZyQ3/eGdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qijJeNlt/6p9bBh9Xv8RnIOuZF8bzdubn+0PSV7GGp51N0QvCmFwxpYofDhlf7pcF
         PGobNcyFh74DvlgU0hVOfh1DvWf0K8/YEc0Dcho+2NeH0GpD6L07AIbbv6b49X5bJq
         rGxKfx9eHVhA+vMSlvCDlJf+GBotY+hL84IX3JuA=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 13/15] selftests: Add ipv4 netfilter tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:46 -0700
Message-Id: <20190801185648.27653-14-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add netfilter tests to send tcp reset or icmp unreachable for a port.
Initial tests are VRF only.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 69 ++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index dcfe0b13dfe9..6f56c91e2d66 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3120,6 +3120,72 @@ ipv6_runtime()
 }
 
 ################################################################################
+# netfilter blocking connections
+
+netfilter_tcp_reset()
+{
+	local a
+
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest -s &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 1 "Global server, reject with TCP-reset on Rx"
+	done
+}
+
+netfilter_icmp()
+{
+	local stype="$1"
+	local arg
+	local a
+
+	[ "${stype}" = "UDP" ] && arg="-D"
+
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest ${arg} -s &
+		sleep 1
+		run_cmd_nsb nettest ${arg} -r ${a}
+		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
+	done
+}
+
+ipv4_netfilter()
+{
+	which nettest >/dev/null
+	if [ $? -ne 0 ]; then
+		log_error "nettest not found; skipping tests"
+		return
+	fi
+
+	log_section "IPv4 Netfilter"
+	log_subsection "TCP reset"
+
+	setup "yes"
+	run_cmd iptables -A INPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset
+
+	netfilter_tcp_reset
+
+	log_start
+	log_subsection "ICMP unreachable"
+
+	log_start
+	run_cmd iptables -F
+	run_cmd iptables -A INPUT -p tcp --dport 12345 -j REJECT --reject-with icmp-port-unreachable
+	run_cmd iptables -A INPUT -p udp --dport 12345 -j REJECT --reject-with icmp-port-unreachable
+
+	netfilter_icmp "TCP"
+	netfilter_icmp "UDP"
+
+	log_start
+	iptables -F
+}
+
+################################################################################
 # usage
 
 usage()
@@ -3139,7 +3205,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
 TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime"
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -3183,6 +3249,7 @@ do
 	ipv4_udp|udp)    ipv4_udp;;
 	ipv4_bind|bind)  ipv4_addr_bind;;
 	ipv4_runtime)    ipv4_runtime;;
+	ipv4_netfilter)  ipv4_netfilter;;
 
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
-- 
2.11.0

