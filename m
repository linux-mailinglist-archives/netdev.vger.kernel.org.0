Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC2423AE7E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgHCUyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:54:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44515 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728631AbgHCUyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2BGzJHCRmu+Ti04yASYnkNBY+SonUCn3y6V4jRugrE=;
        b=diR1JCHEJSwzgAsILuXpsx47t/AGPZai/z1z5f6x9K48ohsgG+vfQz5sAhS0zwxenfOddP
        rmZuvie4qd8cuYo9XMoO7qD7WeDgUFJ4WJMsyWWZ8uzgh7Z8GGt8LnAmsfo86seBuQeaLb
        3aNktE3yoZkBvpM7CptxpnWN4v5F4VI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-U6qYYESxMcaAiY03s0F9DA-1; Mon, 03 Aug 2020 16:54:04 -0400
X-MC-Unique: U6qYYESxMcaAiY03s0F9DA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACEEF59;
        Mon,  3 Aug 2020 20:54:02 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73A9D10013C1;
        Mon,  3 Aug 2020 20:53:59 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/6] selftests: pmtu.sh: Add tests for bridged UDP tunnels
Date:   Mon,  3 Aug 2020 22:52:13 +0200
Message-Id: <f581d1c427ac260d5a0630e6ac1548d10ebfafc7.1596487323.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596487323.git.sbrivio@redhat.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new tests check that IP and IPv6 packets exceeding the local PMTU
estimate, both locally generated and forwarded by a bridge from
another node, result in the correct route exceptions being created,
and that communication with end-to-end fragmentation over VXLAN and
GENEVE tunnels is now possible as a result of PMTU discovery.

Part of the existing setup functions aren't generic enough to simply
add a namespace and a bridge to the existing routing setup. This
rework is in progress and we can easily shrink this once more generic
topology functions are available.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 167 ++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 77c09cd339c3..ee79c26a37dd 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -59,6 +59,25 @@
 #	Same as pmtu_ipv6_vxlan6_exception, but using a GENEVE tunnel instead of
 #	VXLAN
 #
+# - pmtu_ipv{4,6}_br_vxlan{4,6}_exception
+#	Set up three namespaces, A, B, and C, with routing between A and B over
+#	R1. R2 is unused in these tests. A has a veth connection to C, and is
+#	connected to B via a VXLAN endpoint, which is directly bridged to C.
+#	MTU on the B-R1 link is lower than other MTUs.
+#
+#	Check that both C and A are able to communicate with B over the VXLAN
+#	tunnel, and that PMTU exceptions with the correct values are created.
+#
+#	                  segment a_r1    segment b_r1            b_r1: 4000
+#	                .--------------R1--------------.    everything
+#	   C---veth     A                               B         else: 5000
+#	        ' bridge                                |
+#	            '---- - - - - - VXLAN - - - - - - - '
+#
+# - pmtu_ipv{4,6}_br_geneve{4,6}_exception
+#	Same as pmtu_ipv{4,6}_br_vxlan{4,6}_exception, with a GENEVE tunnel
+#	instead.
+#
 # - pmtu_ipv{4,6}_fou{4,6}_exception
 #	Same as pmtu_ipv4_vxlan4, but using a direct IPv4/IPv6 encapsulation
 #	(FoU) over IPv4/IPv6, instead of VXLAN
@@ -147,6 +166,14 @@ tests="
 	pmtu_ipv6_geneve4_exception	IPv6 over geneve4: PMTU exceptions	1
 	pmtu_ipv4_geneve6_exception	IPv4 over geneve6: PMTU exceptions	1
 	pmtu_ipv6_geneve6_exception	IPv6 over geneve6: PMTU exceptions	1
+	pmtu_ipv4_br_vxlan4_exception	IPv4, bridged vxlan4: PMTU exceptions	1
+	pmtu_ipv6_br_vxlan4_exception	IPv6, bridged vxlan4: PMTU exceptions	1
+	pmtu_ipv4_br_vxlan6_exception	IPv4, bridged vxlan6: PMTU exceptions	1
+	pmtu_ipv6_br_vxlan6_exception	IPv6, bridged vxlan6: PMTU exceptions	1
+	pmtu_ipv4_br_geneve4_exception	IPv4, bridged geneve4: PMTU exceptions	1
+	pmtu_ipv6_br_geneve4_exception	IPv6, bridged geneve4: PMTU exceptions	1
+	pmtu_ipv4_br_geneve6_exception	IPv4, bridged geneve6: PMTU exceptions	1
+	pmtu_ipv6_br_geneve6_exception	IPv6, bridged geneve6: PMTU exceptions	1
 	pmtu_ipv4_fou4_exception	IPv4 over fou4: PMTU exceptions		1
 	pmtu_ipv6_fou4_exception	IPv6 over fou4: PMTU exceptions		1
 	pmtu_ipv4_fou6_exception	IPv4 over fou6: PMTU exceptions		1
@@ -173,10 +200,12 @@ tests="
 
 NS_A="ns-A"
 NS_B="ns-B"
+NS_C="ns-C"
 NS_R1="ns-R1"
 NS_R2="ns-R2"
 ns_a="ip netns exec ${NS_A}"
 ns_b="ip netns exec ${NS_B}"
+ns_c="ip netns exec ${NS_C}"
 ns_r1="ip netns exec ${NS_R1}"
 ns_r2="ip netns exec ${NS_R2}"
 
@@ -239,9 +268,11 @@ routes_nh="
 
 veth4_a_addr="192.168.1.1"
 veth4_b_addr="192.168.1.2"
+veth4_c_addr="192.168.2.10"
 veth4_mask="24"
 veth6_a_addr="fd00:1::a"
 veth6_b_addr="fd00:1::b"
+veth6_c_addr="fd00:2::c"
 veth6_mask="64"
 
 tunnel4_a_addr="192.168.2.1"
@@ -428,7 +459,7 @@ setup_ip6ip6() {
 }
 
 setup_namespaces() {
-	for n in ${NS_A} ${NS_B} ${NS_R1} ${NS_R2}; do
+	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
 		ip netns add ${n} || return 1
 
 		# Disable DAD, so that we don't have to wait to use the
@@ -484,6 +515,7 @@ setup_vxlan_or_geneve() {
 	a_addr="${2}"
 	b_addr="${3}"
 	opts="${4}"
+	br_if_a="${5}"
 
 	if [ "${type}" = "vxlan" ]; then
 		opts="${opts} ttl 64 dstport 4789"
@@ -497,12 +529,19 @@ setup_vxlan_or_geneve() {
 	run_cmd ${ns_a} ip link add ${type}_a type ${type} id 1 ${opts_a} remote ${b_addr} ${opts} || return 1
 	run_cmd ${ns_b} ip link add ${type}_b type ${type} id 1 ${opts_b} remote ${a_addr} ${opts}
 
-	run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
-	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
+	if [ -n "${br_if_a}" ]; then
+		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${br_if_a}
+		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${br_if_a}
+		run_cmd ${ns_a} ip link set ${type}_a master ${br_if_a}
+	else
+		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
+		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
+	fi
 
-	run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
+	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
 	run_cmd ${ns_b} ip addr add ${tunnel6_b_addr}/${tunnel6_mask} dev ${type}_b
 
+
 	run_cmd ${ns_a} ip link set ${type}_a up
 	run_cmd ${ns_b} ip link set ${type}_b up
 }
@@ -516,11 +555,27 @@ setup_vxlan4() {
 }
 
 setup_geneve6() {
-	setup_vxlan_or_geneve geneve ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1
+	setup_vxlan_or_geneve geneve ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 ""
 }
 
 setup_vxlan6() {
-	setup_vxlan_or_geneve vxlan  ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1
+	setup_vxlan_or_geneve vxlan  ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 ""
+}
+
+setup_bridged_geneve4() {
+	setup_vxlan_or_geneve geneve ${prefix4}.${a_r1}.1  ${prefix4}.${b_r1}.1  "df set" "br0"
+}
+
+setup_bridged_vxlan4() {
+	setup_vxlan_or_geneve vxlan  ${prefix4}.${a_r1}.1  ${prefix4}.${b_r1}.1  "df set" "br0"
+}
+
+setup_bridged_geneve6() {
+	setup_vxlan_or_geneve geneve ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 "" "br0"
+}
+
+setup_bridged_vxlan6() {
+	setup_vxlan_or_geneve vxlan  ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 "" "br0"
 }
 
 setup_xfrm() {
@@ -630,6 +685,20 @@ setup_routing() {
 	return 0
 }
 
+setup_bridge() {
+	run_cmd ${ns_a} ip link add br0 type bridge || return 2
+	run_cmd ${ns_a} ip link set br0 up
+
+	run_cmd ${ns_c} ip link add veth_C-A type veth peer name veth_A-C
+	run_cmd ${ns_c} ip link set veth_A-C netns ns-A
+
+	run_cmd ${ns_a} ip link set veth_A-C up
+	run_cmd ${ns_c} ip link set veth_C-A up
+	run_cmd ${ns_c} ip addr add ${veth4_c_addr}/${veth4_mask} dev veth_C-A
+	run_cmd ${ns_c} ip addr add ${veth6_c_addr}/${veth6_mask} dev veth_C-A
+	run_cmd ${ns_a} ip link set veth_A-C master br0
+}
+
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
@@ -657,7 +726,7 @@ cleanup() {
 	done
 	tcpdump_pids=
 
-	for n in ${NS_A} ${NS_B} ${NS_R1} ${NS_R2}; do
+	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
 		ip netns del ${n} 2> /dev/null
 	done
 }
@@ -892,6 +961,90 @@ test_pmtu_ipv6_geneve6_exception() {
 	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception geneve 6 6
 }
 
+test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() {
+	type=${1}
+	family=${2}
+	outer_family=${3}
+	ll_mtu=4000
+
+	if [ ${outer_family} -eq 4 ]; then
+		setup namespaces routing bridge bridged_${type}4 || return 2
+		#                      IPv4 header   UDP header   VXLAN/GENEVE header   Ethernet header
+		exp_mtu=$((${ll_mtu} - 20          - 8          - 8                   - 14))
+	else
+		setup namespaces routing bridge bridged_${type}6 || return 2
+		#                      IPv6 header   UDP header   VXLAN/GENEVE header   Ethernet header
+		exp_mtu=$((${ll_mtu} - 40          - 8          - 8                   - 14))
+	fi
+
+	trace "${ns_a}" ${type}_a    "${ns_b}"  ${type}_b \
+	      "${ns_a}" veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_b}" veth_B-R1    "${ns_r1}" veth_R1-B \
+	      "${ns_a}" br0          "${ns_a}"  veth-A-C  \
+	      "${ns_c}" veth_C-A
+
+	if [ ${family} -eq 4 ]; then
+		ping=ping
+		dst=${tunnel4_b_addr}
+	else
+		ping=${ping6}
+		dst=${tunnel6_b_addr}
+	fi
+
+	# Create route exception by exceeding link layer MTU
+	mtu "${ns_a}"  veth_A-R1 $((${ll_mtu} + 1000))
+	mtu "${ns_a}"  br0       $((${ll_mtu} + 1000))
+	mtu "${ns_a}"  veth_A-C  $((${ll_mtu} + 1000))
+	mtu "${ns_c}"  veth_C-A  $((${ll_mtu} + 1000))
+	mtu "${ns_r1}" veth_R1-A $((${ll_mtu} + 1000))
+	mtu "${ns_b}"  veth_B-R1 ${ll_mtu}
+	mtu "${ns_r1}" veth_R1-B ${ll_mtu}
+
+	mtu "${ns_a}" ${type}_a $((${ll_mtu} + 1000))
+	mtu "${ns_b}" ${type}_b $((${ll_mtu} + 1000))
+
+	run_cmd ${ns_c} ${ping} -q -M want -i 0.1 -c 10 -s $((${ll_mtu} + 500)) ${dst} || return 1
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1  -s $((${ll_mtu} + 500)) ${dst} || return 1
+
+	# Check that exceptions were created
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_c}" ${dst})"
+	check_pmtu_value ${exp_mtu} "${pmtu}" "exceeding link layer MTU on bridged ${type} interface"
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst})"
+	check_pmtu_value ${exp_mtu} "${pmtu}" "exceeding link layer MTU on locally bridged ${type} interface"
+}
+
+test_pmtu_ipv4_br_vxlan4_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception vxlan  4 4
+}
+
+test_pmtu_ipv6_br_vxlan4_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception vxlan  6 4
+}
+
+test_pmtu_ipv4_br_geneve4_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception geneve 4 4
+}
+
+test_pmtu_ipv6_br_geneve4_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception geneve 6 4
+}
+
+test_pmtu_ipv4_br_vxlan6_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception vxlan  4 6
+}
+
+test_pmtu_ipv6_br_vxlan6_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception vxlan  6 6
+}
+
+test_pmtu_ipv4_br_geneve6_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception geneve 4 6
+}
+
+test_pmtu_ipv6_br_geneve6_exception() {
+	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception geneve 6 6
+}
+
 test_pmtu_ipvX_over_fouY_or_gueY() {
 	inner_family=${1}
 	outer_family=${2}
-- 
2.27.0

