Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C387E2B7
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387836AbfHASzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387779AbfHASzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:17 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC83217D6;
        Thu,  1 Aug 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685714;
        bh=1DoW/qVFmZftIw2OozF/zuDKbhjSGqK1T1rDnKTKuaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9qE0Ml84x6v+JdeUdWR33LMdbsqvzleOtRQWuPuxych5mypVmBPF725afFgw39o4
         Aaz3k7PBAOJBGmfmlmzyGNIexkETviEmigEfuFa7hTZNHFJhG6wd1qjwZ0xOoEyfJe
         VdwLgfZiA6Bs+caneRnzpvWcBATBTXh/ASH1wbfs=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 14/15] selftests: Add ipv6 netfilter tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:47 -0700
Message-Id: <20190801185648.27653-15-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 netfilter tests to send tcp reset or icmp unreachable for a
port. Initial tests are VRF only.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 65 ++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 6f56c91e2d66..17eec10e06bf 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3185,6 +3185,68 @@ ipv4_netfilter()
 	iptables -F
 }
 
+netfilter_tcp6_reset()
+{
+	local a
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "Global server, reject with TCP-reset on Rx"
+	done
+}
+
+netfilter_icmp6()
+{
+	local stype="$1"
+	local arg
+	local a
+
+	[ "${stype}" = "UDP" ] && arg="$arg -D"
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s ${arg} &
+		sleep 1
+		run_cmd_nsb nettest -6 ${arg} -r ${a}
+		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
+	done
+}
+
+ipv6_netfilter()
+{
+	which nettest >/dev/null
+	if [ $? -ne 0 ]; then
+		log_error "nettest not found; skipping tests"
+		return
+	fi
+
+	log_section "IPv6 Netfilter"
+	log_subsection "TCP reset"
+
+	setup "yes"
+	run_cmd ip6tables -A INPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset
+
+	netfilter_tcp6_reset
+
+	log_subsection "ICMP unreachable"
+
+	log_start
+	run_cmd ip6tables -F
+	run_cmd ip6tables -A INPUT -p tcp --dport 12345 -j REJECT --reject-with icmp6-port-unreachable
+	run_cmd ip6tables -A INPUT -p udp --dport 12345 -j REJECT --reject-with icmp6-port-unreachable
+
+	netfilter_icmp6 "TCP"
+	netfilter_icmp6 "UDP"
+
+	log_start
+	ip6tables -F
+}
+
 ################################################################################
 # usage
 
@@ -3206,7 +3268,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime ipv6_netfilter"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -3256,6 +3318,7 @@ do
 	ipv6_udp|udp6)   ipv6_udp;;
 	ipv6_bind|bind6) ipv6_addr_bind;;
 	ipv6_runtime)    ipv6_runtime;;
+	ipv6_netfilter)  ipv6_netfilter;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

