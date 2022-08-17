Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F17596A7D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiHQHh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiHQHh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:37:29 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB8375CF6;
        Wed, 17 Aug 2022 00:37:25 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H5Ac33010596;
        Wed, 17 Aug 2022 09:37:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=12052020;
 bh=JCIXwg2KltuVDsw3bCg0ydI9BX7R71/9nGIwU3MIRGI=;
 b=BoeTrH5vvMHaptfG3AJudM5bDydQ9RhdnJScCs/fvHWyBAGAZPTwKqTw2Nbj183MAppn
 yE2lUxP8R4nFX8h/gn1OrR0ReeR+8OA/FThu5iMbKJAmP2BJq1jEINbHETvdryWIl/mw
 Hrj+z+6awiV9zXK5YTPgQRTc6KG6HozNjrb5XF+Ncf+r0lJ5JsMawlsPX8rTKYPpxuQU
 Dup/sh61pVrz1mkLOgDHBEQsJ6qvNDiFFtmYMLaee0wb5fZ5PBXeZec7CA0v0VsbKEyN
 ncJrqCjtE39KNGNtoOcWti+7Lst+D1tOXXE4xDb9L4htqga9L1NuTJv9etQWLyLZ4kpk xA== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hx0abuxrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 09:37:01 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Wed, 17 Aug 2022 09:37:00 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH net-next] selftests/net: test l2 tunnel TOS/TTL inheriting
Date:   Wed, 17 Aug 2022 09:36:49 +0200
Message-ID: <20220817073649.26117-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: QuttER8pdkLpt5kxDXIUih3FlLxTgaAJ
X-Proofpoint-ORIG-GUID: QuttER8pdkLpt5kxDXIUih3FlLxTgaAJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently 3 ip tunnels that are capable of carrying
L2 traffic: gretap, vxlan and geneve.
They all are capable to inherit the TOS/TTL for the outer
IP-header from the inner frame.

Add a test that verifies that these fields are correctly inherited.

These tests failed before the following commits:
b09ab9c92e50 ("ip6_tunnel: allow to inherit from VLAN encapsulated IP")
3f8a8447fd0b ("ip6_gre: use actual protocol to select xmit")
41337f52b967 ("ip6_gre: set DSCP for non-IP")
7ae29fd1be43 ("ip_tunnel: allow to inherit from VLAN encapsulated IP")
7074732c8fae ("ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL from VLAN")
ca2bb69514a8 ("geneve: do not use RT_TOS for IPv6 flowlabel")
b4ab94d6adaa ("geneve: fix TOS inheriting for ipv4")

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/l2_tos_ttl_inherit.sh       | 390 ++++++++++++++++++
 2 files changed, 391 insertions(+)
 create mode 100755 tools/testing/selftests/net/l2_tos_ttl_inherit.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index c0ee2955fe54..11a288b67e2f 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -42,6 +42,7 @@ TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
 TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
+TEST_PROGS := l2_tos_ttl_inherit.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
new file mode 100755
index 000000000000..dca1e6f777a8
--- /dev/null
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -0,0 +1,390 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Author: Matthias May <matthias.may@westermo.com>
+#
+# This script evaluates ip tunnels that are capable of carrying L2 traffic
+# if they inherit or set the inheritable fields.
+# Namely these tunnels are: 'gretap', 'vxlan' and 'geneve'.
+# Checked inheritable fields are: TOS and TTL.
+# The outer tunnel protocol of 'IPv4' or 'IPv6' is verified-
+# As payload frames of type 'IPv4', 'IPv6' and 'other'(ARP) are verified.
+# In addition this script also checks if forcing a specific field in the
+# outer header is working.
+
+if [ "$(id -u)" != "0" ]; then
+	echo "Please run as root."
+	exit 0
+fi
+if ! which tcpdump > /dev/null 2>&1; then
+	echo "No tcpdump found. Required for this test."
+	exit 0
+fi
+
+expected_tos="0x00"
+expected_ttl="0"
+failed=false
+
+get_random_tos() {
+	# Get a random hex tos value between 0x00 and 0xfc, a multiple of 4
+	echo "0x$(tr -dc '0-9a-f' < /dev/urandom | head -c 1)\
+$(tr -dc '048c' < /dev/urandom | head -c 1)"
+}
+get_random_ttl() {
+	# Get a random dec value between 0 and 255
+	printf "%d" "0x$(tr -dc '0-9a-f' < /dev/urandom | head -c 2)"
+}
+get_field() {
+	# Expects to get the 'head -n 1' of a captured frame by tcpdump.
+	# Parses this first line and returns the specified field.
+	local field="$1"
+	local input="$2"
+	local found=false
+	input="$(echo "$input" | tr -d '(),')"
+	for input_field in $input; do
+		if $found; then
+			echo "$input_field"
+			return
+		fi
+		# The next field that we iterate over is the looked for value
+		if [ "$input_field" = "$field" ]; then
+			found=true
+		fi
+	done
+	echo "0"
+}
+setup() {
+	local type="$1"
+	local outer="$2"
+	local inner="$3"
+	local tos_ttl="$4"
+	local vlan="$5"
+	local test_tos="0x00"
+	local test_ttl="0"
+	local ns="ip netns exec testing"
+
+	# We don't want a test-tos of 0x00,
+	# because this is the value that we get when no tos is set.
+	expected_tos="$(get_random_tos)"
+	while [ "$expected_tos" = "0x00" ]; do
+		expected_tos="$(get_random_tos)"
+	done
+	if [ "$tos_ttl" = "random" ]; then
+		test_tos="$expected_tos"
+		tos="fixed $test_tos"
+	elif [ "$tos_ttl" = "inherit" ]; then
+		test_tos="$tos_ttl"
+		tos="inherit $expected_tos"
+	fi
+
+	# We don't want a test-ttl of 64 or 0,
+	# because 64 is when no ttl is set and 0 is not a valid ttl.
+	expected_ttl="$(get_random_ttl)"
+	while [ "$expected_ttl" = "64" ] || [ "$expected_ttl" = "0" ]; do
+		expected_ttl="$(get_random_ttl)"
+	done
+
+	if [ "$tos_ttl" = "random" ]; then
+		test_ttl="$expected_ttl"
+		ttl="fixed $test_ttl"
+	elif [ "$tos_ttl" = "inherit" ]; then
+		test_ttl="$tos_ttl"
+		ttl="inherit $expected_ttl"
+	fi
+	printf "│%7s │%6s │%6s │%13s │%13s │%6s │" \
+	"$type" "$outer" "$inner" "$tos" "$ttl" "$vlan"
+
+	# Create 'testing' netns, veth pair and connect main ns with testing ns
+	ip netns add testing
+	ip link add type veth
+	ip link set veth1 netns testing
+	ip link set veth0 up
+	$ns ip link set veth1 up
+	ip addr flush dev veth0
+	$ns ip addr flush dev veth1
+
+	local local_addr1=""
+	local local_addr2=""
+	if [ "$type" = "gre" ] || [ "$type" = "vxlan" ]; then
+		if [ "$outer" = "4" ]; then
+			local_addr1="local 198.18.0.1"
+			local_addr2="local 198.18.0.2"
+		elif [ "$outer" = "6" ]; then
+			local_addr1="local fdd1:ced0:5d88:3fce::1"
+			local_addr2="local fdd1:ced0:5d88:3fce::2"
+		fi
+	fi
+	local vxlan=""
+	if [ "$type" = "vxlan" ]; then
+		vxlan="vni 100 dstport 4789"
+	fi
+	local geneve=""
+	if [ "$type" = "geneve" ]; then
+		geneve="vni 100"
+	fi
+	# Create tunnel and assign outer IPv4/IPv6 addresses
+	if [ "$outer" = "4" ]; then
+		if [ "$type" = "gre" ]; then
+			type="gretap"
+		fi
+		ip addr add 198.18.0.1/24 dev veth0
+		$ns ip addr add 198.18.0.2/24 dev veth1
+		ip link add name tep0 type $type $local_addr1 remote \
+		198.18.0.2 tos $test_tos ttl $test_ttl $vxlan $geneve
+		$ns ip link add name tep1 type $type $local_addr2 remote \
+		198.18.0.1 tos $test_tos ttl $test_ttl $vxlan $geneve
+	elif [ "$outer" = "6" ]; then
+		if [ "$type" = "gre" ]; then
+			type="ip6gretap"
+		fi
+		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0
+		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1
+		ip link add name tep0 type $type $local_addr1 \
+		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
+		$vxlan $geneve
+		$ns ip link add name tep1 type $type $local_addr2 \
+		remote fdd1:ced0:5d88:3fce::1 tos $test_tos ttl $test_ttl \
+		$vxlan $geneve
+	fi
+
+	# Bring L2-tunnel link up and create VLAN on top
+	ip link set tep0 up
+	$ns ip link set tep1 up
+	ip addr flush dev tep0
+	$ns ip addr flush dev tep1
+	local parent
+	if $vlan; then
+		parent="vlan99-"
+		ip link add link tep0 name ${parent}0 type vlan id 99
+		$ns ip link add link tep1 name ${parent}1 type vlan id 99
+		ip link set ${parent}0 up
+		$ns ip link set ${parent}1 up
+		ip addr flush dev ${parent}0
+		$ns ip addr flush dev ${parent}1
+	else
+		parent="tep"
+	fi
+
+	# Assign inner IPv4/IPv6 addresses
+	if [ "$inner" = "4" ] || [ "$inner" = "other" ]; then
+		ip addr add 198.19.0.1/24 brd + dev ${parent}0
+		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
+	elif [ "$inner" = "6" ]; then
+		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0
+		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1
+	fi
+}
+
+verify() {
+	local outer="$1"
+	local inner="$2"
+	local tos_ttl="$3"
+	local vlan="$4"
+
+	local ping_pid out captured_tos captured_ttl result
+
+	local ping_dst
+	if [ "$inner" = "4" ]; then
+		ping_dst="198.19.0.2"
+	elif [ "$inner" = "6" ]; then
+		ping_dst="fdd4:96cf:4eae:443b::2"
+	elif [ "$inner" = "other" ]; then
+		ping_dst="198.19.0.3" # Generates ARPs which are not IPv4/IPv6
+	fi
+	if [ "$tos_ttl" = "inherit" ]; then
+		ping -i 0.1 $ping_dst -Q "$expected_tos" -t "$expected_ttl" \
+		2>/dev/null 1>&2 & ping_pid="$!"
+	else
+		ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
+	fi
+	local tunnel_type_offset tunnel_type_proto req_proto_offset req_offset
+	if [ "$type" = "gre" ]; then
+		tunnel_type_proto="0x2f"
+	elif [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+		tunnel_type_proto="0x11"
+	fi
+	if [ "$outer" = "4" ]; then
+		tunnel_type_offset="9"
+		if [ "$inner" = "4" ]; then
+			req_proto_offset="47"
+			req_offset="58"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 12))"
+				req_offset="$((req_offset + 12))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip[$req_proto_offset] = 0x01 and \
+			ip[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+		elif [ "$inner" = "6" ]; then
+			req_proto_offset="44"
+			req_offset="78"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 12))"
+				req_offset="$((req_offset + 12))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip[$req_proto_offset] = 0x3a and \
+			ip[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+		elif [ "$inner" = "other" ]; then
+			req_proto_offset="36"
+			req_offset="45"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 12))"
+				req_offset="$((req_offset + 12))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			if [ "$tos_ttl" = "inherit" ]; then
+				expected_tos="0x00"
+				expected_ttl="64"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip[$req_proto_offset] = 0x08 and \
+			ip[$((req_proto_offset + 1))] = 0x06 and \
+			ip[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+		fi
+	elif [ "$outer" = "6" ]; then
+		if [ "$type" = "gre" ]; then
+			tunnel_type_offset="40"
+		elif [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+			tunnel_type_offset="6"
+		fi
+		if [ "$inner" = "4" ]; then
+			local req_proto_offset="75"
+			local req_offset="86"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip6[$req_proto_offset] = 0x01 and \
+			ip6[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+		elif [ "$inner" = "6" ]; then
+			local req_proto_offset="72"
+			local req_offset="106"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip6[$req_proto_offset] = 0x3a and \
+			ip6[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+		elif [ "$inner" = "other" ]; then
+			local req_proto_offset="64"
+			local req_offset="73"
+			if [ "$type" = "vxlan" ] || [ "$type" = "geneve" ]; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			if $vlan; then
+				req_proto_offset="$((req_proto_offset + 4))"
+				req_offset="$((req_offset + 4))"
+			fi
+			if [ "$tos_ttl" = "inherit" ]; then
+				expected_tos="0x00"
+				expected_ttl="64"
+			fi
+			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
+			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+			ip6[$req_proto_offset] = 0x08 and \
+			ip6[$((req_proto_offset + 1))] = 0x06 and \
+			ip6[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+		fi
+	fi
+	kill -9 $ping_pid
+	wait $ping_pid 2>/dev/null
+	result="FAIL"
+	if [ "$outer" = "4" ]; then
+		captured_ttl="$(get_field "ttl" "$out")"
+		captured_tos="$(printf "0x%02x" "$(get_field "tos" "$out")")"
+		if [ "$captured_tos" = "$expected_tos" ] &&
+		   [ "$captured_ttl" = "$expected_ttl" ]; then
+			result="OK"
+		fi
+	elif [ "$outer" = "6" ]; then
+		captured_ttl="$(get_field "hlim" "$out")"
+		captured_tos="$(printf "0x%02x" "$(get_field "class" "$out")")"
+		if [ "$captured_tos" = "$expected_tos" ] &&
+		   [ "$captured_ttl" = "$expected_ttl" ]; then
+			result="OK"
+		fi
+	fi
+
+	printf "%7s │\n" "$result"
+	if [ "$result" = "FAIL" ]; then
+		failed=true
+		if [ "$captured_tos" != "$expected_tos" ]; then
+			printf "│%43s%27s │\n" \
+			"Expected TOS value: $expected_tos" \
+			"Captured TOS value: $captured_tos"
+		fi
+		if [ "$captured_ttl" != "$expected_ttl" ]; then
+			printf "│%43s%27s │\n" \
+			"Expected TTL value: $expected_ttl" \
+			"Captured TTL value: $captured_ttl"
+		fi
+		printf "│%71s│\n" " "
+	fi
+}
+
+cleanup() {
+	ip link del veth0 2>/dev/null
+	ip netns del testing 2>/dev/null
+	ip link del tep0 2>/dev/null
+}
+
+printf "┌────────┬───────┬───────┬──────────────┬"
+printf "──────────────┬───────┬────────┐\n"
+for type in gre vxlan geneve; do
+	if ! $(modprobe "$type" 2>/dev/null); then
+		continue
+	fi
+	for outer in 4 6; do
+		printf "├────────┼───────┼───────┼──────────────┼"
+		printf "──────────────┼───────┼────────┤\n"
+		printf "│  Type  │ outer | inner │     tos      │"
+		printf "      ttl     │  vlan │ result │\n"
+		for inner in 4 6 other; do
+			printf "├────────┼───────┼───────┼──────────────┼"
+			printf "──────────────┼───────┼────────┤\n"
+			for tos_ttl in inherit random; do
+				for vlan in false true; do
+					setup "$type" "$outer" "$inner" \
+					"$tos_ttl" "$vlan"
+					verify "$outer" "$inner" "$tos_ttl" \
+					"$vlan"
+					cleanup
+				done
+			done
+		done
+	done
+done
+printf "└────────┴───────┴───────┴──────────────┴"
+printf "──────────────┴───────┴────────┘\n"
+
+if $failed; then
+	exit 1
+fi
-- 
2.35.1

