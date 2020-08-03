Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6671223AE7F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgHCUyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:54:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728631AbgHCUyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:54:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9iEwJvXhyu9By5qWPCDecQD4HczqBDu5NDyVyxrIRc=;
        b=Vc90jyy4g26OZVXNsWR3vi8i2Ql0o6aH6x9RTITrKLjmbgZckv1Z1b4HEQUQeJUXv+An2F
        yH0Vd88dXwT8mhczBH61u46tzjjfBSImZNXUyreC6FYEYugIfZEuDdigL6Vdao3jWFzeJF
        m7PEGVzo0nRuEqm5LV22RiT2ce0PmdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-uRQrsBRFPfawo68u4w6PRQ-1; Mon, 03 Aug 2020 16:54:09 -0400
X-MC-Unique: uRQrsBRFPfawo68u4w6PRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 707238017FB;
        Mon,  3 Aug 2020 20:54:08 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AFE71001B2B;
        Mon,  3 Aug 2020 20:54:02 +0000 (UTC)
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
Subject: [PATCH net-next 6/6] selftests: pmtu.sh: Add tests for UDP tunnels handled by Open vSwitch
Date:   Mon,  3 Aug 2020 22:52:14 +0200
Message-Id: <c02be25303e71c2829ee1907127adc4c31d6f2e5.1596487323.git.sbrivio@redhat.com>
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
estimate, forwarded by an Open vSwitch instance from another node,
result in the correct route exceptions being created, and that
communication with end-to-end fragmentation, over GENEVE and VXLAN
Open vSwitch ports, is now possible as a result of PMTU discovery.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 180 ++++++++++++++++++++++++++++
 1 file changed, 180 insertions(+)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index ee79c26a37dd..5401f6fd615d 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -78,6 +78,26 @@
 #	Same as pmtu_ipv{4,6}_br_vxlan{4,6}_exception, with a GENEVE tunnel
 #	instead.
 #
+# - pmtu_ipv{4,6}_ovs_vxlan{4,6}_exception
+#	Set up two namespaces, B, and C, with routing between the init namespace
+#	and B over R1. A and R2 are unused in these tests. The init namespace
+#	has a veth connection to C, and is connected to B via a VXLAN endpoint,
+#	which is handled by Open vSwitch and bridged to C. MTU on the B-R1 link
+#	is lower than other MTUs.
+#
+#	Check that C is able to communicate with B over the VXLAN tunnel, and
+#	that PMTU exceptions with the correct values are created.
+#
+#	                  segment a_r1    segment b_r1            b_r1: 4000
+#	                .--------------R1--------------.    everything
+#	   C---veth    init                             B         else: 5000
+#	        '- ovs                                  |
+#	            '---- - - - - - VXLAN - - - - - - - '
+#
+# - pmtu_ipv{4,6}_ovs_geneve{4,6}_exception
+#	Same as pmtu_ipv{4,6}_ovs_vxlan{4,6}_exception, with a GENEVE tunnel
+#	instead.
+#
 # - pmtu_ipv{4,6}_fou{4,6}_exception
 #	Same as pmtu_ipv4_vxlan4, but using a direct IPv4/IPv6 encapsulation
 #	(FoU) over IPv4/IPv6, instead of VXLAN
@@ -174,6 +194,14 @@ tests="
 	pmtu_ipv6_br_geneve4_exception	IPv6, bridged geneve4: PMTU exceptions	1
 	pmtu_ipv4_br_geneve6_exception	IPv4, bridged geneve6: PMTU exceptions	1
 	pmtu_ipv6_br_geneve6_exception	IPv6, bridged geneve6: PMTU exceptions	1
+	pmtu_ipv4_ovs_vxlan4_exception	IPv4, OVS vxlan4: PMTU exceptions	1
+	pmtu_ipv6_ovs_vxlan4_exception	IPv6, OVS vxlan4: PMTU exceptions	1
+	pmtu_ipv4_ovs_vxlan6_exception	IPv4, OVS vxlan6: PMTU exceptions	1
+	pmtu_ipv6_ovs_vxlan6_exception	IPv6, OVS vxlan6: PMTU exceptions	1
+	pmtu_ipv4_ovs_geneve4_exception	IPv4, OVS geneve4: PMTU exceptions	1
+	pmtu_ipv6_ovs_geneve4_exception	IPv6, OVS geneve4: PMTU exceptions	1
+	pmtu_ipv4_ovs_geneve6_exception	IPv4, OVS geneve6: PMTU exceptions	1
+	pmtu_ipv6_ovs_geneve6_exception	IPv6, OVS geneve6: PMTU exceptions	1
 	pmtu_ipv4_fou4_exception	IPv4 over fou4: PMTU exceptions		1
 	pmtu_ipv6_fou4_exception	IPv6 over fou4: PMTU exceptions		1
 	pmtu_ipv4_fou6_exception	IPv4 over fou6: PMTU exceptions		1
@@ -699,6 +727,66 @@ setup_bridge() {
 	run_cmd ${ns_a} ip link set veth_A-C master br0
 }
 
+setup_ovs_vxlan_or_geneve() {
+	type="${1}"
+	a_addr="${2}"
+	b_addr="${3}"
+
+	if [ "${type}" = "vxlan" ]; then
+		opts="${opts} ttl 64 dstport 4789"
+		opts_b="local ${b_addr}"
+	fi
+
+	run_cmd ovs-vsctl add-port ovs_br0 ${type}_a -- \
+		set interface ${type}_a type=${type} \
+		options:remote_ip=${b_addr} options:key=1 options:csum=true || return 1
+
+	run_cmd ${ns_b} ip link add ${type}_b type ${type} id 1 ${opts_b} remote ${a_addr} ${opts} || return 1
+
+	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
+	run_cmd ${ns_b} ip addr add ${tunnel6_b_addr}/${tunnel6_mask} dev ${type}_b
+
+	run_cmd ${ns_b} ip link set ${type}_b up
+}
+
+setup_ovs_geneve4() {
+	setup_ovs_vxlan_or_geneve geneve ${prefix4}.${a_r1}.1  ${prefix4}.${b_r1}.1
+}
+
+setup_ovs_vxlan4() {
+	setup_ovs_vxlan_or_geneve vxlan  ${prefix4}.${a_r1}.1  ${prefix4}.${b_r1}.1
+}
+
+setup_ovs_geneve6() {
+	setup_ovs_vxlan_or_geneve geneve ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1
+}
+
+setup_ovs_vxlan6() {
+	setup_ovs_vxlan_or_geneve vxlan  ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1
+}
+
+setup_ovs_bridge() {
+	run_cmd ovs-vsctl add-br ovs_br0 || return 2
+	run_cmd ip link set ovs_br0 up
+
+	run_cmd ${ns_c} ip link add veth_C-A type veth peer name veth_A-C
+	run_cmd ${ns_c} ip link set veth_A-C netns 1
+
+	run_cmd         ip link set veth_A-C up
+	run_cmd ${ns_c} ip link set veth_C-A up
+	run_cmd ${ns_c} ip addr add ${veth4_c_addr}/${veth4_mask} dev veth_C-A
+	run_cmd ${ns_c} ip addr add ${veth6_c_addr}/${veth6_mask} dev veth_C-A
+	run_cmd ovs-vsctl add-port ovs_br0 veth_A-C
+
+	# Move veth_A-R1 to init
+	run_cmd ${ns_a} ip link set veth_A-R1 netns 1
+	run_cmd ip addr add ${prefix4}.${a_r1}.1/${veth4_mask} dev veth_A-R1
+	run_cmd ip addr add ${prefix6}:${a_r1}::1/${veth6_mask} dev veth_A-R1
+	run_cmd ip link set veth_A-R1 up
+	run_cmd ip route add ${prefix4}.${b_r1}.1 via ${prefix4}.${a_r1}.2
+	run_cmd ip route add ${prefix6}:${b_r1}::1 via ${prefix6}:${a_r1}::2
+}
+
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
@@ -729,6 +817,11 @@ cleanup() {
 	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
 		ip netns del ${n} 2> /dev/null
 	done
+
+	ip link del veth_A-C			2>/dev/null
+	ip link del veth_A-R1			2>/dev/null
+	ovs-vsctl --if-exists del-port vxlan_a	2>/dev/null
+	ovs-vsctl --if-exists del-br ovs_br0	2>/dev/null
 }
 
 mtu() {
@@ -1045,6 +1138,93 @@ test_pmtu_ipv6_br_geneve6_exception() {
 	test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception geneve 6 6
 }
 
+test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception() {
+	type=${1}
+	family=${2}
+	outer_family=${3}
+	ll_mtu=4000
+
+	if [ ${outer_family} -eq 4 ]; then
+		setup namespaces routing ovs_bridge ovs_${type}4 || return 2
+		#                      IPv4 header   UDP header   VXLAN/GENEVE header   Ethernet header
+		exp_mtu=$((${ll_mtu} - 20          - 8          - 8                   - 14))
+	else
+		setup namespaces routing ovs_bridge ovs_${type}6 || return 2
+		#                      IPv6 header   UDP header   VXLAN/GENEVE header   Ethernet header
+		exp_mtu=$((${ll_mtu} - 40          - 8          - 8                   - 14))
+	fi
+
+	if [ "${type}" = "vxlan" ]; then
+		tun_a="vxlan_sys_4789"
+	elif [ "${type}" = "geneve" ]; then
+		tun_a="genev_sys_6081"
+	fi
+
+	trace ""        "${tun_a}"  "${ns_b}"  ${type}_b \
+	      ""        veth_A-R1   "${ns_r1}" veth_R1-A \
+	      "${ns_b}" veth_B-R1   "${ns_r1}" veth_R1-B \
+	      ""        ovs_br0     ""         veth-A-C  \
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
+	mtu ""         veth_A-R1 $((${ll_mtu} + 1000))
+	mtu ""         ovs_br0   $((${ll_mtu} + 1000))
+	mtu ""         veth_A-C  $((${ll_mtu} + 1000))
+	mtu "${ns_c}"  veth_C-A  $((${ll_mtu} + 1000))
+	mtu "${ns_r1}" veth_R1-A $((${ll_mtu} + 1000))
+	mtu "${ns_b}"  veth_B-R1 ${ll_mtu}
+	mtu "${ns_r1}" veth_R1-B ${ll_mtu}
+
+	mtu ""        ${tun_a}  $((${ll_mtu} + 1000))
+	mtu "${ns_b}" ${type}_b $((${ll_mtu} + 1000))
+
+	run_cmd ${ns_c} ${ping} -q -M want -i 0.1 -c 20 -s $((${ll_mtu} + 500)) ${dst} || return 1
+
+	# Check that exceptions were created
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_c}" ${dst})"
+	check_pmtu_value ${exp_mtu} "${pmtu}" "exceeding link layer MTU on Open vSwitch ${type} interface"
+}
+
+test_pmtu_ipv4_ovs_vxlan4_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception vxlan  4 4
+}
+
+test_pmtu_ipv6_ovs_vxlan4_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception vxlan  6 4
+}
+
+test_pmtu_ipv4_ovs_geneve4_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception geneve 4 4
+}
+
+test_pmtu_ipv6_ovs_geneve4_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception geneve 6 4
+}
+
+test_pmtu_ipv4_ovs_vxlan6_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception vxlan  4 6
+}
+
+test_pmtu_ipv6_ovs_vxlan6_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception vxlan  6 6
+}
+
+test_pmtu_ipv4_ovs_geneve6_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception geneve 4 6
+}
+
+test_pmtu_ipv6_ovs_geneve6_exception() {
+	test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception geneve 6 6
+}
+
 test_pmtu_ipvX_over_fouY_or_gueY() {
 	inner_family=${1}
 	outer_family=${2}
-- 
2.27.0

