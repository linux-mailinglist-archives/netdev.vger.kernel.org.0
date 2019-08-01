Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5007E2B6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbfHASzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbfHASzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:17 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC33217D7;
        Thu,  1 Aug 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685715;
        bh=mE9zQ0inMMjEfjUFu6eWoxwX8FEHBsQupDBFLViOqJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8ayHph07SxRxyA36u7K/8VnUUCEzrDBrI8AxIqES/bkzMsHrv3T9PMvwA+dsduul
         aqUdccqRR5HYM/jgaEaPZbpekHUHKQ5Xd34J1a0INM43B0WDP9M8dtXDZojKPWxu8m
         uBBIEfqsouzl8maXWD5+zTLT2EEg82PJE0eg31w8=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 15/15] selftests: Add use case section to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:48 -0700
Message-Id: <20190801185648.27653-16-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add use case section to fcnal-test.

Initial test is VRF based with a bridge and vlans. The commands
stem from bug reports fixed by:

a173f066c7cf ("netfilter: bridge: Don't sabotage nf_hook calls from an l3mdev")
cd6428988bf4 ("netfilter: bridge: Don't sabotage nf_hook calls for an l3mdev slave")

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 124 ++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 17eec10e06bf..bd6b564382ec 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3248,6 +3248,126 @@ ipv6_netfilter()
 }
 
 ################################################################################
+# specific use cases
+
+# VRF only.
+# ns-A device enslaved to bridge. Verify traffic with and without
+# br_netfilter module loaded. Repeat with SVI on bridge.
+use_case_br()
+{
+	setup "yes"
+
+	setup_cmd ip link set ${NSA_DEV} down
+	setup_cmd ip addr del dev ${NSA_DEV} ${NSA_IP}/24
+	setup_cmd ip -6 addr del dev ${NSA_DEV} ${NSA_IP6}/64
+
+	setup_cmd ip link add br0 type bridge
+	setup_cmd ip addr add dev br0 ${NSA_IP}/24
+	setup_cmd ip -6 addr add dev br0 ${NSA_IP6}/64 nodad
+
+	setup_cmd ip li set ${NSA_DEV} master br0
+	setup_cmd ip li set ${NSA_DEV} up
+	setup_cmd ip li set br0 up
+	setup_cmd ip li set br0 vrf ${VRF}
+
+	rmmod br_netfilter 2>/dev/null
+	sleep 5 # DAD
+
+	run_cmd ip neigh flush all
+	run_cmd ping -c1 -w1 -I br0 ${NSB_IP}
+	log_test $? 0 "Bridge into VRF - IPv4 ping out"
+
+	run_cmd ip neigh flush all
+	run_cmd ${ping6} -c1 -w1 -I br0 ${NSB_IP6}
+	log_test $? 0 "Bridge into VRF - IPv6 ping out"
+
+	run_cmd ip neigh flush all
+	run_cmd_nsb ping -c1 -w1 ${NSA_IP}
+	log_test $? 0 "Bridge into VRF - IPv4 ping in"
+
+	run_cmd ip neigh flush all
+	run_cmd_nsb ${ping6} -c1 -w1 ${NSA_IP6}
+	log_test $? 0 "Bridge into VRF - IPv6 ping in"
+
+	modprobe br_netfilter
+	if [ $? -eq 0 ]; then
+		run_cmd ip neigh flush all
+		run_cmd ping -c1 -w1 -I br0 ${NSB_IP}
+		log_test $? 0 "Bridge into VRF with br_netfilter - IPv4 ping out"
+
+		run_cmd ip neigh flush all
+		run_cmd ${ping6} -c1 -w1 -I br0 ${NSB_IP6}
+		log_test $? 0 "Bridge into VRF with br_netfilter - IPv6 ping out"
+
+		run_cmd ip neigh flush all
+		run_cmd_nsb ping -c1 -w1 ${NSA_IP}
+		log_test $? 0 "Bridge into VRF with br_netfilter - IPv4 ping in"
+
+		run_cmd ip neigh flush all
+		run_cmd_nsb ${ping6} -c1 -w1 ${NSA_IP6}
+		log_test $? 0 "Bridge into VRF with br_netfilter - IPv6 ping in"
+	fi
+
+	setup_cmd ip li set br0 nomaster
+	setup_cmd ip li add br0.100 link br0 type vlan id 100
+	setup_cmd ip li set br0.100 vrf ${VRF} up
+	setup_cmd ip    addr add dev br0.100 172.16.101.1/24
+	setup_cmd ip -6 addr add dev br0.100 2001:db8:101::1/64 nodad
+
+	setup_cmd_nsb ip li add vlan100 link ${NSB_DEV} type vlan id 100
+	setup_cmd_nsb ip addr add dev vlan100 172.16.101.2/24
+	setup_cmd_nsb ip -6 addr add dev vlan100 2001:db8:101::2/64 nodad
+	setup_cmd_nsb ip li set vlan100 up
+	sleep 1
+
+	rmmod br_netfilter 2>/dev/null
+
+	run_cmd ip neigh flush all
+	run_cmd ping -c1 -w1 -I br0.100 172.16.101.2
+	log_test $? 0 "Bridge vlan into VRF - IPv4 ping out"
+
+	run_cmd ip neigh flush all
+	run_cmd ${ping6} -c1 -w1 -I br0.100 2001:db8:101::2
+	log_test $? 0 "Bridge vlan into VRF - IPv6 ping out"
+
+	run_cmd ip neigh flush all
+	run_cmd_nsb ping -c1 -w1 172.16.101.1
+	log_test $? 0 "Bridge vlan into VRF - IPv4 ping in"
+
+	run_cmd ip neigh flush all
+	run_cmd_nsb ${ping6} -c1 -w1 2001:db8:101::1
+	log_test $? 0 "Bridge vlan into VRF - IPv6 ping in"
+
+	modprobe br_netfilter
+	if [ $? -eq 0 ]; then
+		run_cmd ip neigh flush all
+		run_cmd ping -c1 -w1 -I br0.100 172.16.101.2
+		log_test $? 0 "Bridge vlan into VRF with br_netfilter - IPv4 ping out"
+
+		run_cmd ip neigh flush all
+		run_cmd ${ping6} -c1 -w1 -I br0.100 2001:db8:101::2
+		log_test $? 0 "Bridge vlan into VRF with br_netfilter - IPv6 ping out"
+
+		run_cmd ip neigh flush all
+		run_cmd_nsb ping -c1 -w1 172.16.101.1
+		log_test $? 0 "Bridge vlan into VRF - IPv4 ping in"
+
+		run_cmd ip neigh flush all
+		run_cmd_nsb ${ping6} -c1 -w1 2001:db8:101::1
+		log_test $? 0 "Bridge vlan into VRF - IPv6 ping in"
+	fi
+
+	setup_cmd ip li del br0 2>/dev/null
+	setup_cmd_nsb ip li del vlan100 2>/dev/null
+}
+
+use_cases()
+{
+	log_section "Use cases"
+	use_case_br
+}
+
+################################################################################
 # usage
 
 usage()
@@ -3269,6 +3389,8 @@ EOF
 
 TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
 TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime ipv6_netfilter"
+TESTS_OTHER="use_cases"
+
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -3320,6 +3442,8 @@ do
 	ipv6_runtime)    ipv6_runtime;;
 	ipv6_netfilter)  ipv6_netfilter;;
 
+	use_cases)       use_cases;;
+
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
-- 
2.11.0

