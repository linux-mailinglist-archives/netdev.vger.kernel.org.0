Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 601ED3A255
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfFHWWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB612184C;
        Sat,  8 Jun 2019 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030828;
        bh=sQlGt0gu6NmxHCLN8KEx/vu7tTGIackFfr6eIYe8Jog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7AfMCyFBcxADtgoLLJbkXlYS9hXWKeeEGc9sqVl1XsL3Te9LG5Y8hfGnrdHpGGRQ
         InddfDk1iH+1x5ln0dd9Up8T8oD8b1S6oPl/9qn8txAIsYGD577OC9dXFbp3MLn3x/
         hfRA6Ypwog4IMaw6Onc9mTyLYD2lsknOwbr7FL3Y=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 17/20] selftests: pmtu: Add support for routing via nexthop objects
Date:   Sat,  8 Jun 2019 14:53:38 -0700
Message-Id: <20190608215341.26592-18-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add routing setup using nexthop objects and repeat tests with
old and new routing.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 158 ++++++++++++++++++++++++++++--------
 1 file changed, 126 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 14ffcf490032..9e6d8b704186 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -123,34 +123,35 @@ TRACING=0
 # Some systems don't have a ping6 binary anymore
 which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
 
+#               Name                          Description                  re-run with nh
 tests="
-	pmtu_ipv4_exception		ipv4: PMTU exceptions
-	pmtu_ipv6_exception		ipv6: PMTU exceptions
-	pmtu_ipv4_vxlan4_exception	IPv4 over vxlan4: PMTU exceptions
-	pmtu_ipv6_vxlan4_exception	IPv6 over vxlan4: PMTU exceptions
-	pmtu_ipv4_vxlan6_exception	IPv4 over vxlan6: PMTU exceptions
-	pmtu_ipv6_vxlan6_exception	IPv6 over vxlan6: PMTU exceptions
-	pmtu_ipv4_geneve4_exception	IPv4 over geneve4: PMTU exceptions
-	pmtu_ipv6_geneve4_exception	IPv6 over geneve4: PMTU exceptions
-	pmtu_ipv4_geneve6_exception	IPv4 over geneve6: PMTU exceptions
-	pmtu_ipv6_geneve6_exception	IPv6 over geneve6: PMTU exceptions
-	pmtu_ipv4_fou4_exception	IPv4 over fou4: PMTU exceptions
-	pmtu_ipv6_fou4_exception	IPv6 over fou4: PMTU exceptions
-	pmtu_ipv4_fou6_exception	IPv4 over fou6: PMTU exceptions
-	pmtu_ipv6_fou6_exception	IPv6 over fou6: PMTU exceptions
-	pmtu_ipv4_gue4_exception	IPv4 over gue4: PMTU exceptions
-	pmtu_ipv6_gue4_exception	IPv6 over gue4: PMTU exceptions
-	pmtu_ipv4_gue6_exception	IPv4 over gue6: PMTU exceptions
-	pmtu_ipv6_gue6_exception	IPv6 over gue6: PMTU exceptions
-	pmtu_vti6_exception		vti6: PMTU exceptions
-	pmtu_vti4_exception		vti4: PMTU exceptions
-	pmtu_vti4_default_mtu		vti4: default MTU assignment
-	pmtu_vti6_default_mtu		vti6: default MTU assignment
-	pmtu_vti4_link_add_mtu		vti4: MTU setting on link creation
-	pmtu_vti6_link_add_mtu		vti6: MTU setting on link creation
-	pmtu_vti6_link_change_mtu	vti6: MTU changes on link changes
-	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions
-	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions"
+	pmtu_ipv4_exception		ipv4: PMTU exceptions			1
+	pmtu_ipv6_exception		ipv6: PMTU exceptions			1
+	pmtu_ipv4_vxlan4_exception	IPv4 over vxlan4: PMTU exceptions	1
+	pmtu_ipv6_vxlan4_exception	IPv6 over vxlan4: PMTU exceptions	1
+	pmtu_ipv4_vxlan6_exception	IPv4 over vxlan6: PMTU exceptions	1
+	pmtu_ipv6_vxlan6_exception	IPv6 over vxlan6: PMTU exceptions	1
+	pmtu_ipv4_geneve4_exception	IPv4 over geneve4: PMTU exceptions	1
+	pmtu_ipv6_geneve4_exception	IPv6 over geneve4: PMTU exceptions	1
+	pmtu_ipv4_geneve6_exception	IPv4 over geneve6: PMTU exceptions	1
+	pmtu_ipv6_geneve6_exception	IPv6 over geneve6: PMTU exceptions	1
+	pmtu_ipv4_fou4_exception	IPv4 over fou4: PMTU exceptions		1
+	pmtu_ipv6_fou4_exception	IPv6 over fou4: PMTU exceptions		1
+	pmtu_ipv4_fou6_exception	IPv4 over fou6: PMTU exceptions		1
+	pmtu_ipv6_fou6_exception	IPv6 over fou6: PMTU exceptions		1
+	pmtu_ipv4_gue4_exception	IPv4 over gue4: PMTU exceptions		1
+	pmtu_ipv6_gue4_exception	IPv6 over gue4: PMTU exceptions		1
+	pmtu_ipv4_gue6_exception	IPv4 over gue6: PMTU exceptions		1
+	pmtu_ipv6_gue6_exception	IPv6 over gue6: PMTU exceptions		1
+	pmtu_vti6_exception		vti6: PMTU exceptions			0
+	pmtu_vti4_exception		vti4: PMTU exceptions			0
+	pmtu_vti4_default_mtu		vti4: default MTU assignment		0
+	pmtu_vti6_default_mtu		vti6: default MTU assignment		0
+	pmtu_vti4_link_add_mtu		vti4: MTU setting on link creation	0
+	pmtu_vti6_link_add_mtu		vti6: MTU setting on link creation	0
+	pmtu_vti6_link_change_mtu	vti6: MTU changes on link changes	0
+	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
+	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1"
 
 NS_A="ns-A"
 NS_B="ns-B"
@@ -194,6 +195,30 @@ routes="
 	B	default			${prefix6}:${b_r1}::2
 "
 
+USE_NH="no"
+#	ns	family	nh id	   destination		gateway
+nexthops="
+	A	4	41	${prefix4}.${a_r1}.2	veth_A-R1
+	A	4	42	${prefix4}.${a_r2}.2	veth_A-R2
+	B	4	41	${prefix4}.${b_r1}.2	veth_B-R1
+
+	A	6	61	${prefix6}:${a_r1}::2	veth_A-R1
+	A	6	62	${prefix6}:${a_r2}::2	veth_A-R2
+	B	6	61	${prefix6}:${b_r1}::2	veth_B-R1
+"
+
+# nexthop id correlates to id in nexthops config above
+#	ns    family	prefix			nh id
+routes_nh="
+	A	4	default			41
+	A	4	${prefix4}.${b_r2}.1	42
+	B	4	default			41
+
+	A	6	default			61
+	A	6	${prefix6}:${b_r2}::1	62
+	B	6	default			61
+"
+
 veth4_a_addr="192.168.1.1"
 veth4_b_addr="192.168.1.2"
 veth4_mask="24"
@@ -462,6 +487,36 @@ setup_routing_old() {
 	done
 }
 
+setup_routing_new() {
+	for i in ${nexthops}; do
+		[ "${ns}" = "" ]	&& ns="${i}"		&& continue
+		[ "${fam}" = "" ]	&& fam="${i}"		&& continue
+		[ "${nhid}" = "" ]	&& nhid="${i}"		&& continue
+		[ "${gw}" = "" ]	&& gw="${i}"		&& continue
+		[ "${dev}" = "" ]	&& dev="${i}"
+
+		ns_name="$(nsname ${ns})"
+
+		ip -n ${ns_name} -${fam} nexthop add id ${nhid} via ${gw} dev ${dev}
+
+		ns=""; fam=""; nhid=""; gw=""; dev=""
+
+	done
+
+	for i in ${routes_nh}; do
+		[ "${ns}" = "" ]	&& ns="${i}"		&& continue
+		[ "${fam}" = "" ]	&& fam="${i}"		&& continue
+		[ "${addr}" = "" ]	&& addr="${i}"		&& continue
+		[ "${nhid}" = "" ]	&& nhid="${i}"
+
+		ns_name="$(nsname ${ns})"
+
+		ip -n ${ns_name} -${fam} route add ${addr} nhid ${nhid}
+
+		ns=""; fam=""; addr=""; nhid=""
+	done
+}
+
 setup_routing() {
 	for i in ${NS_R1} ${NS_R2}; do
 		ip netns exec ${i} sysctl -q net/ipv4/ip_forward=1
@@ -492,7 +547,13 @@ setup_routing() {
 		ns=""; peer=""; segment=""
 	done
 
-	setup_routing_old
+	if [ "$USE_NH" = "yes" ]; then
+		setup_routing_new
+	else
+		setup_routing_old
+	fi
+
+	return 0
 }
 
 setup() {
@@ -1126,7 +1187,19 @@ run_test() {
 
 	return $ret
 	)
-	[ $? -ne 0 ] && exitcode=1
+	ret=$?
+	[ $ret -ne 0 ] && exitcode=1
+
+	return $ret
+}
+
+run_test_nh() {
+	tname="$1"
+	tdesc="$2"
+
+	USE_NH=yes
+	run_test "${tname}" "${tdesc} - nexthop objects"
+	USE_NH=no
 }
 
 usage() {
@@ -1175,8 +1248,20 @@ trap cleanup EXIT
 # start clean
 cleanup
 
+HAVE_NH=no
+ip nexthop ls >/dev/null 2>&1
+[ $? -eq 0 ] && HAVE_NH=yes
+
+name=""
+desc=""
+rerun_nh=0
 for t in ${tests}; do
-	[ $desc -eq 0 ] && name="${t}" && desc=1 && continue || desc=0
+	[ "${name}" = "" ]	&& name="${t}"	&& continue
+	[ "${desc}" = "" ]	&& desc="${t}"	&& continue
+
+	if [ "${HAVE_NH}" = "yes" ]; then
+		rerun_nh="${t}"
+	fi
 
 	run_this=1
 	for arg do
@@ -1184,9 +1269,18 @@ for t in ${tests}; do
 		[ "${arg}" = "${name}" ] && run_this=1 && break
 		run_this=0
 	done
-	[ $run_this -eq 0 ] && continue
+	if [ $run_this -eq 1 ]; then
+		run_test "${name}" "${desc}"
+		# if test was skipped no need to retry with nexthop objects
+		[ $? -eq 2 ] && rerun_nh=0
 
-	run_test "${name}" "${t}"
+		if [ "${rerun_nh}" = "1" ]; then
+			run_test_nh "${name}" "${desc}"
+		fi
+	fi
+	name=""
+	desc=""
+	rerun_nh=0
 done
 
 exit ${exitcode}
-- 
2.11.0

