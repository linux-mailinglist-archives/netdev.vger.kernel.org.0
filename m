Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4032B55C809
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345437AbiF1LiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345288AbiF1LiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:38:05 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B50832EFB;
        Tue, 28 Jun 2022 04:38:01 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25SBbSQX010288
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jun 2022 13:37:29 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 3/4] selftests: seg6: add selftest for SRv6 H.Encaps.Red behavior
Date:   Tue, 28 Jun 2022 13:36:41 +0200
Message-Id: <20220628113642.3223-4-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
References: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This selftest is designed for testing the H.Encaps.Red behavior. It
instantiates a virtual network composed of several nodes: hosts and SRv6
routers. Each node is realized using a network namespace that is
properly interconnected to others through veth pairs.
The test considers SRv6 routers implementing L3 VPNs leveraged by hosts
for communicating with each other. Such routers make use of the SRv6
H.Encaps.Red behavior for applying SRv6 policies to L3 traffic coming
from hosts.

The correct execution of the behavior is verified through reachability
tests carried out between hosts belonging to the same VPN.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 .../net/srv6_hencap_red_l3vpn_test.sh         | 742 ++++++++++++++++++
 1 file changed, 742 insertions(+)
 create mode 100755 tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh

diff --git a/tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh b/tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh
new file mode 100755
index 000000000000..3b97f187b189
--- /dev/null
+++ b/tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh
@@ -0,0 +1,742 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# author: Andrea Mayer <andrea.mayer@uniroma2.it>
+#
+# This script is designed for testing the SRv6 H.Encaps.Red behavior.
+#
+# Below is depicted the IPv6 network of an operator which offers advanced
+# IPv4/IPv6 VPN services to hosts, enabling them to communicate with each
+# other.
+# In this example, hosts hs-1 and hs-2 are connected through an IPv4/IPv6 VPN
+# service, while hs-3 and hs-4 are connected using an IPv6 only VPN.
+#
+# Routers rt-1,rt-2,rt-3 and rt-4 implement IPv4/IPv6 L3 VPN services
+# leveraging the SRv6 architecture. The key components for such VPNs are:
+#
+#   i) The SRv6 H.Encaps.Red behavior applies SRv6 Policies on traffic received
+#      by connected hosts, initiating the VPN tunnel. Such a behavior is an
+#      optimization of the SRv6 H.Encap aiming to reduce the length of the SID
+#      List carried in the pushed SRH. Specifically, the H.Encaps.Red removes
+#      the first SID contained in the SID List (i.e. SRv6 Policy) by storing it
+#      into the IPv6 Destination Address. When a SRv6 Policy is made of only one
+#      SID, the SRv6 H.Encaps.Red behavior omits the SRH at all and pushes that
+#      SID directly into the IPv6 DA;
+#
+#  ii) The SRv6 End behavior advances the active SID in the SID List carried by
+#      the SRH;
+#
+# iii) The SRv6 End.DT46 behavior is used for removing the SRv6 Policy and,
+#      thus, it terminates the VPN tunnel. Such a behavior is capable of
+#      handling, at the same time, both tunneled IPv4 and IPv6 traffic.
+#
+#
+#               cafe::1                      cafe::2
+#              10.0.0.1                     10.0.0.2
+#             +--------+                   +--------+
+#             |        |                   |        |
+#             |  hs-1  |                   |  hs-2  |
+#             |        |                   |        |
+#             +---+----+                   +--- +---+
+#    cafe::/64    |                             |      cafe::/64
+#  10.0.0.0/24    |                             |    10.0.0.0/24
+#             +---+----+                   +----+---+
+#             |        |  fcf0:0:1:2::/64  |        |
+#             |  rt-1  +-------------------+  rt-2  |
+#             |        |                   |        |
+#             +---+----+                   +----+---+
+#                 |      .               .      |
+#                 |  fcf0:0:1:3::/64   .        |
+#                 |          .       .          |
+#                 |            .   .            |
+# fcf0:0:1:4::/64 |              .              | fcf0:0:2:3::/64
+#                 |            .   .            |
+#                 |          .       .          |
+#                 |  fcf0:0:2:4::/64   .        |
+#                 |      .               .      |
+#             +---+----+                   +----+---+
+#             |        |                   |        |
+#             |  rt-4  +-------------------+  rt-3  |
+#             |        |  fcf0:0:3:4::/64  |        |
+#             +---+----+                   +----+---+
+#    cafe::/64    |                             |      cafe::/64
+#  10.0.0.0/24    |                             |    10.0.0.0/24
+#             +---+----+                   +--- +---+
+#             |        |                   |        |
+#             |  hs-4  |                   |  hs-3  |
+#             |        |                   |        |
+#             +--------+                   +--------+
+#               cafe::4                      cafe::3
+#              10.0.0.4                     10.0.0.3
+#
+#
+# Every fcf0:0:x:y::/64 network interconnects the SRv6 routers rt-x with rt-y
+# in the IPv6 operator network.
+#
+# Local SID table
+# ===============
+#
+# Each SRv6 router is configured with a Local SID table in which SIDs are
+# stored. Considering the given SRv6 router rt-x, at least two SIDs are
+# configured in the Local SID table:
+#
+#   Local SID table for SRv6 router rt-x
+#   +----------------------------------------------------------+
+#   |fcff:x:e is associated with the SRv6 End behavior         |
+#   |fcff:x:d46 is associated with the SRv6 End.DT46 behavior  |
+#   +----------------------------------------------------------+
+#
+# The fcff:/16 prefix is reserved by the operator for implementing SRv6 VPN
+# services. Reachability of SIDs is ensured by proper configuration of the IPv6
+# operator's network and SRv6 routers.
+#
+# # SRv6 Policies
+# ===============
+#
+# An SRv6 ingress router applies SRv6 policies to the traffic received from a
+# connected host. SRv6 policy enforcement consists of encapsulating the
+# received traffic into a new IPv6 packet with a given SID List contained in
+# the SRH.
+#
+# IPv4/IPv6 VPN between hs-1 and hs-2
+# -----------------------------------
+#
+# Hosts hs-1 and hs-2 are connected using dedicated IPv4/IPv6 VPNs.
+# Specifically, packets generated from hs-1 and directed towards hs-2 are
+# handled by rt-1 which applies the following SRv6 Policies:
+#
+#   i.a) IPv6 traffic, SID List=fcff:3::e,fcff:4::e,fcff:2::d46
+#  ii.a) IPv4 traffic, SID List=fcff:2::d46
+#
+# Policy (i.a) steers tunneled IPv6 traffic through SRv6 routers
+# rt-3,rt-4,rt-2. Instead, Policy (ii.b) steers tunneled IPv4 traffic through
+# rt-2.
+# The H.Encaps.Red reduces the SID List (i.a) carried in SRH by removing the
+# first SID (fcff:3::e) and pushing it into the IPv6 DA. In case of IPv4
+# traffic, the H.Encaps.Red omits the presence of SRH at all, since the SID
+# List (ii.a) consists of only one SID that can be stored directly in the IPv6
+# DA.
+#
+# On the reverse path (i.e. from hs-2 to hs-1), rt-2 applies the following
+# policies:
+#
+#   i.b) IPv6 traffic, SID List=fcff:1:d46
+#  ii.b) IPv4 traffic, SID List=fcff:4::e,fcff:3::e,fcff:1::d46
+#
+# Policy (i.b) steers tunneled IPv6 traffic through the SRv6 router rt-1.
+# Conversely, Policy (ii.b) steers tunneled IPv4 traffic through SRv6 routers
+# rt-4,rt-3,rt-1.
+# The H.Encaps.Red omits the SRH at all in case of (i.b) by pushing the single
+# SID (fcff::1:d46) inside the IPv6 DA.
+# The H.Encaps.Red reduces the SID List (ii.b) in the SRH by removing the first
+# SID (fcff:4::e) and pushing it into the IPv6 DA.
+#
+# In summary:
+#  * hs-1 -> hs-2 |IPv6 DA=fcff:3::e|SRH SIDs=fcff:4::e,fcff:2::d46|IPv6|...| (i.a)
+#  * hs-1 -> hs-2 |IPv6 DA=fcff:2::d46|IPv4|...|                              (ii.a)
+#
+#  * hs-2 -> hs-1 |IPv6 DA=fcff:1::d46|IPv6|...|                              (i.b)
+#  * hs-2 -> hs-1 |IPv6 DA=fcff:4::e|SRH SIDs=fcff:3::e,fcff:1::d46|IPv4|...| (ii.b)
+#
+#
+# IPv6 VPN between hs-3 and hs-4
+# ------------------------------
+#
+# Hosts hs-3 and hs-4 are connected using a dedicated IPv6 only VPN.
+# Specifically, packets generated from hs-3 and directed towards hs-4 are
+# handled by rt-3 which applies the following SRv6 Policy:
+#
+#  i.c) IPv6 traffic, SID List=fcff:2::e,fcff:4::d46
+#
+# Policy (i.c) steers tunneled IPv6 traffic through SRv6 routers rt-2,rt-4.
+# The H.Encaps.Red reduces the SID List (i.c) carried in SRH by pushing the
+# first SID (fcff:2::e) in the IPv6 DA.
+#
+# On the reverse path (i.e. from hs-4 to hs-3) the router rt-4 applies the
+# following SRv6 Policy:
+#
+#  i.d) IPv6 traffic, SID List=fcff:1::e,fcff:3::d46.
+#
+# Policy (i.d) steers tunneled IPv6 traffic through SRv6 routers rt-1,rt-3.
+# The H.Encaps.Red reduces the SID List (i.d) carried in SRH by pushing the
+# first SID (fcff:1::e) in the IPv6 DA.
+#
+# In summary:
+#  * hs-3 -> hs-4 |IPv6 DA=fcff:2::e|SRH SIDs=fcff:4::d46|IPv6|...| (i.c)
+#  * hs-4 -> hs-3 |IPv6 DA=fcff:1::e|SRH SIDs=fcff:3::d46|IPv6|...| (i.d)
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+readonly VRF_TID=100
+readonly LOCALSID_TABLE_ID=90
+readonly IPv6_RT_NETWORK=fcf0:0
+readonly IPv6_HS_NETWORK=cafe
+readonly IPv4_HS_NETWORK=10.0.0
+readonly VPN_LOCATOR_SERVICE=fcff
+readonly END_FUNC=000e
+readonly DT46_FUNC=0d46
+PING_TIMEOUT_SEC=4
+
+# global vars initialized during the setup of the selftest network
+ROUTERS=''
+HOSTS=''
+
+ret=0
+
+PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		nsuccess=$((nsuccess+1))
+		printf "\n    TEST: %-60s  [ OK ]\n" "${msg}"
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "\n    TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+}
+
+print_log_test_results()
+{
+	if [ "$TESTS" != "none" ]; then
+		printf "\nTests passed: %3d\n" ${nsuccess}
+		printf "Tests failed: %3d\n"   ${nfail}
+	fi
+}
+
+log_section()
+{
+	echo
+	echo "################################################################################"
+	echo "TEST SECTION: $*"
+	echo "################################################################################"
+}
+
+test_command_or_ksft_skip()
+{
+	local cmd="$1"
+
+	if [ ! -x "$(command -v "${cmd}")" ]; then
+		echo "SKIP: Could not run test without \"${cmd}\" tool";
+		exit ${ksft_skip}
+	fi
+}
+
+cleanup()
+{
+	local ifnames
+	local dev
+
+	ifnames="$(ip -o link show | grep -oE "veth-rt-[0-9]+-[0-9]" | sort -n | uniq)"
+
+	# destroy any pending device
+	for dev in ${ifnames}; do
+		ip link del ${dev} || true
+	done
+
+	# destroy routers rt-* and hosts hs-*
+	for ns in $(ip netns show | grep -E 'rt-*|hs-*'); do
+		ip netns del ${ns} || true
+	done
+}
+
+add_link_rt_pairs()
+{
+	local rt=$1
+	local rt_neighs="$2"
+	local neigh
+
+	for neigh in ${rt_neighs}; do
+		ip link add veth-rt-${rt}-${neigh} type veth \
+			peer name veth-rt-${neigh}-${rt}
+	done
+}
+
+get_network_prefix()
+{
+	local rt=$1
+	local neigh=$2
+	local p=${rt}
+	local q=${neigh}
+
+	if [ "${p}" -gt "${q}" ]; then
+		p=${q}; q=${rt};
+	fi
+
+	echo "${IPv6_RT_NETWORK}:${p}:${q}"
+}
+
+# Setup the basic networking for the routers
+setup_rt_networking()
+{
+	local rt=$1
+	local rt_neighs="$2"
+	local nsname=rt-${rt}
+	local net_prefix
+	local devname
+	local neigh
+
+	ip netns add ${nsname}
+
+	for neigh in ${rt_neighs}; do
+		devname=veth-rt-${rt}-${neigh}
+		ip link set ${devname} netns ${nsname}
+
+		net_prefix="$(get_network_prefix ${rt} ${neigh})"
+
+		ip -netns ${nsname} addr add ${net_prefix}::${rt}/64 \
+			dev ${devname} nodad
+
+		ip -netns ${nsname} link set ${devname} up
+	done
+
+	ip -netns ${nsname} link set lo up
+
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.forwarding=1
+
+	ip netns exec ${nsname} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${nsname} sysctl -wq net.ipv4.conf.default.rp_filter=0
+	ip netns exec ${nsname} sysctl -wq net.ipv4.ip_forward=1
+}
+
+# Setup local SIDs for an SRv6 router
+setup_rt_local_sids()
+{
+	local rt=$1
+	local rt_neighs="$2"
+	local nsname=rt-${rt}
+	local rtveth=veth-t${VRF_TID}
+	local net_prefix
+	local devname
+	local neigh
+
+	for neigh in ${rt_neighs}; do
+		devname=veth-rt-${rt}-${neigh}
+
+		net_prefix="$(get_network_prefix ${rt} ${neigh})"
+
+		# set underlay network routes for SIDs reachability
+		ip -netns ${nsname} -6 route add ${VPN_LOCATOR_SERVICE}:${neigh}::/32 \
+			table ${LOCALSID_TABLE_ID} \
+			via ${net_prefix}::${neigh} dev ${devname}
+	done
+
+	# Local End behavior (note that "dev" is dummy and the VRF is chosen
+	# for the sake of simplicity).
+	ip -netns ${nsname} -6 route add ${VPN_LOCATOR_SERVICE}:${rt}::${END_FUNC} \
+		table ${LOCALSID_TABLE_ID} \
+		encap seg6local action End count dev vrf-${VRF_TID}
+
+	# Local End.DT46 behavior
+	ip -netns ${nsname} -6 route add ${VPN_LOCATOR_SERVICE}:${rt}::${DT46_FUNC} \
+		table ${LOCALSID_TABLE_ID} \
+		encap seg6local action End.DT46 vrftable ${VRF_TID} count dev vrf-${VRF_TID}
+
+	# all SIDs for VPNs start with a common locator. Routes and SRv6
+	# Endpoint behaviors instaces are grouped together in the 'localsid'
+	# table.
+	ip -netns ${nsname} -6 rule add \
+			to ${VPN_LOCATOR_SERVICE}::/16 \
+			lookup ${LOCALSID_TABLE_ID} prio 999
+
+	# set default routes to unreachable for both ipv4 and ipv6
+	ip -netns ${nsname} -6 route add unreachable default metric 4278198272 \
+		vrf vrf-${VRF_TID}
+
+	ip -netns ${nsname} -4 route add unreachable default metric 4278198272 \
+		vrf vrf-${VRF_TID}
+}
+
+# build and install the SRv6 policy into the ingress SRv6 router.
+# args:
+#  $1 - destination host (i.e. cafe::x host)
+#  $2 - SRv6 router configured for enforcing the SRv6 Policy
+#  $3 - SRv6 routers configured for steering traffic (End behaviors)
+#  $4 - SRv6 router configured for removing the SRv6 Policy (router connected
+#       to the destination host)
+#  $5 - encap mode (full or red)
+#  $6 - traffic type (IPv6 or IPv4)
+__setup_rt_policy()
+{
+	local dst=$1
+	local encap=$2
+	local end_rts="$3"
+	local dec_rt=$4
+	local mode="$5"
+	local traffic=$6
+	local nsname=rt-${encap}
+	local rtveth=veth-t${VRF_TID}
+	local policy=''
+	local n
+
+	for n in ${end_rts}; do
+		policy=${policy}"${VPN_LOCATOR_SERVICE}:${n}::${END_FUNC},"
+	done
+
+	policy=${policy}"${VPN_LOCATOR_SERVICE}:${dec_rt}::${DT46_FUNC}"
+
+	# add SRv6 policy to incoming traffic sent by attached hosts
+	if [ "${traffic}" -eq 6 ]; then
+		ip -netns ${nsname} -6 route add ${IPv6_HS_NETWORK}::${dst} vrf vrf-${VRF_TID} \
+			encap seg6 mode ${mode} segs ${policy} dev vrf-${VRF_TID}
+
+		ip -netns ${nsname} -6 neigh add proxy ${IPv6_HS_NETWORK}::${dst} dev ${rtveth}
+	else
+		# "dev" must be different from the one where the packet is
+		# received, otherwise the proxy arp does not work.
+		ip -netns ${nsname} -4 route add ${IPv4_HS_NETWORK}.${dst} vrf vrf-${VRF_TID} \
+			encap seg6 mode ${mode} segs ${policy} dev vrf-${VRF_TID}
+	fi
+}
+
+# see __setup_rt_policy
+setup_rt_policy_ipv6()
+{
+	__setup_rt_policy "$1" "$2" "$3" "$4" "$5" 6
+}
+
+#see __setup_rt_policy
+setup_rt_policy_ipv4()
+{
+	__setup_rt_policy "$1" "$2" "$3" "$4" "$5" 4
+}
+
+setup_hs()
+{
+	local hs=$1
+	local rt=$2
+	local hsname=hs-${hs}
+	local rtname=rt-${rt}
+	local rtveth=veth-t${VRF_TID}
+
+	# set the networking for the host
+	ip netns add ${hsname}
+
+	ip netns exec ${hsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${hsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
+	ip -netns ${hsname} link add veth0 type veth peer name ${rtveth}
+	ip -netns ${hsname} link set ${rtveth} netns ${rtname}
+	ip -netns ${hsname} addr add ${IPv6_HS_NETWORK}::${hs}/64 dev veth0 nodad
+	ip -netns ${hsname} addr add ${IPv4_HS_NETWORK}.${hs}/24 dev veth0
+	ip -netns ${hsname} link set veth0 up
+	ip -netns ${hsname} link set lo up
+
+	# configure the VRF on the router which is directly connected to the
+	# source host.
+	ip -netns ${rtname} link add vrf-${VRF_TID} type vrf table ${VRF_TID}
+	ip -netns ${rtname} link set vrf-${VRF_TID} up
+
+	# enslave the veth-tX interface to the vrf-X in the access router
+	ip -netns ${rtname} link set ${rtveth} master vrf-${VRF_TID}
+	ip -netns ${rtname} addr add ${IPv6_HS_NETWORK}::254/64 dev ${rtveth} nodad
+	ip -netns ${rtname} addr add ${IPv4_HS_NETWORK}.254/24 dev ${rtveth}
+	ip -netns ${rtname} link set ${rtveth} up
+
+	ip netns exec ${rtname} sysctl -wq net.ipv6.conf.${rtveth}.proxy_ndp=1
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.${rtveth}.proxy_arp=1
+
+	# disable the rp_filter otherwise the kernel gets confused about how
+	# to route decap ipv4 packets.
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.${rtveth}.rp_filter=0
+
+	ip netns exec ${rtname} sh -c "echo 1 > /proc/sys/net/vrf/strict_mode"
+}
+
+setup()
+{
+	# set up the links for connecting routers
+	add_link_rt_pairs 1 "2 3 4"
+	add_link_rt_pairs 2 "3 4"
+	add_link_rt_pairs 3 "4"
+
+	# set up the basic connectivity of routers and routes required for
+	# reachability of SIDs.
+	ROUTERS="1 2 3 4"
+	setup_rt_networking 1 "2 3 4"
+	setup_rt_networking 2 "1 3 4"
+	setup_rt_networking 3 "1 2 4"
+	setup_rt_networking 4 "1 2 3"
+
+	# set up the hosts connected to routers
+	HOSTS="1 2 3 4"
+	setup_hs 1 1
+	setup_hs 2 2
+	setup_hs 3 3
+	setup_hs 4 4
+
+	# set up default SRv6 Endpoints (i.e. SRv6 End and SRv6 End.DT46)
+	setup_rt_local_sids 1 "2 3 4"
+	setup_rt_local_sids 2 "1 3 4"
+	setup_rt_local_sids 3 "1 2 4"
+	setup_rt_local_sids 4 "1 2 3"
+
+	# set up SRv6 policies
+
+	# create an IPv6 VPN between hosts hs-1 and hs-2.
+	# the network path between hs-1 and hs-2 traverses several routers
+	# depending on the direction of traffic.
+	#
+	# Direction hs-1 -> hs-2 (H.Encaps.Red)
+	#  - rt-3,rt-4 (SRv6 End behaviors)
+	#  - rt-2 (SRv6 End.DT46 behavior)
+	#
+	# Direction hs-2 -> hs-1 (H.Encaps.Red)
+	#  - rt-1 (SRv6 End.DT46 behavior)
+	setup_rt_policy_ipv6 2 1 "3 4" 2 encap.red
+	setup_rt_policy_ipv6 1 2 "" 1 encap.red
+
+	# create an IPv4 VPN between hosts hs-1 and hs-2
+	# the network path between hs-1 and hs-2 traverses several routers
+	# depending on the direction of traffic.
+	#
+	# Direction hs-1 -> hs-2 (H.Encaps.Red)
+	# - rt-2 (SRv6 End.DT46 behavior)
+	#
+	# Direction hs-2 -> hs-1 (H.Encaps.Red)
+	#  - rt-4,rt-3 (SRv6 End behaviors)
+	#  - rt-1 (SRv6 End.DT46 behavior)
+	setup_rt_policy_ipv4 2 1 "" 2 encap.red
+	setup_rt_policy_ipv4 1 2 "4 3" 1 encap.red
+
+	# create an IPv6 VPN between hosts hs-3 and hs-4
+	# the network path between hs-3 and hs-4 traverses several routers
+	# depending on the direction of traffic.
+	#
+	# Direction hs-3 -> hs-4 (H.Encaps.Red)
+	# - rt-2 (SRv6 End Behavior)
+	# - rt-4 (SRv6 End.DT46 behavior)
+	#
+	# Direction hs-4 -> hs-3 (H.Encaps.Red)
+	#  - rt-1 (SRv6 End behavior)
+	#  - rt-3 (SRv6 End.DT46 behavior)
+	setup_rt_policy_ipv6 4 3 "2" 4 encap.red
+	setup_rt_policy_ipv6 3 4 "1" 3 encap.red
+}
+
+check_rt_connectivity()
+{
+	local rtsrc=$1
+	local rtdst=$2
+	local prefix
+
+	prefix="$(get_network_prefix ${rtsrc} ${rtdst})"
+
+	ip netns exec rt-${rtsrc} ping -c 1 -W 1 ${prefix}::${rtdst} \
+		>/dev/null 2>&1
+}
+
+check_and_log_rt_connectivity()
+{
+	local rtsrc=$1
+	local rtdst=$2
+
+	check_rt_connectivity ${rtsrc} ${rtdst}
+	log_test $? 0 "Routers connectivity: rt-${rtsrc} -> rt-${rtdst}"
+}
+
+check_hs_ipv6_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	ip netns exec hs-${hssrc} ping -c 1 -W ${PING_TIMEOUT_SEC} \
+		${IPv6_HS_NETWORK}::${hsdst} >/dev/null 2>&1
+}
+
+check_hs_ipv4_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	ip netns exec hs-${hssrc} ping -c 1 -W ${PING_TIMEOUT_SEC} \
+		${IPv4_HS_NETWORK}.${hsdst} >/dev/null 2>&1
+}
+
+check_and_log_hs2gw_connectivity()
+{
+	local hssrc=$1
+
+	check_hs_ipv6_connectivity ${hssrc} 254
+	log_test $? 0 "IPv6 Hosts connectivity: hs-${hssrc} -> gw"
+
+	check_hs_ipv4_connectivity ${hssrc} 254
+	log_test $? 0 "IPv4 Hosts connectivity: hs-${hssrc} -> gw"
+}
+
+check_and_log_hs_ipv6_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_hs_ipv6_connectivity ${hssrc} ${hsdst}
+	log_test $? 0 "IPv6 Hosts connectivity: hs-${hssrc} -> hs-${hsdst}"
+}
+
+check_and_log_hs_ipv4_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_hs_ipv4_connectivity ${hssrc} ${hsdst}
+	log_test $? 0 "IPv4 Hosts connectivity: hs-${hssrc} -> hs-${hsdst}"
+}
+
+check_and_log_hs_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_and_log_hs_ipv4_connectivity ${hssrc} ${hsdst}
+	check_and_log_hs_ipv6_connectivity ${hssrc} ${hsdst}
+}
+
+check_and_log_hs_ipv6_isolation()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_hs_ipv6_connectivity ${hssrc} ${hsdst}
+	log_test $? 1 "IPv6 Hosts isolation: hs-${hssrc} -X-> hs-${hsdst}"
+}
+
+check_and_log_hs_ipv4_isolation()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_hs_ipv4_connectivity ${hssrc} ${hsdst}
+	log_test $? 1 "IPv4 Hosts isolation: hs-${hssrc} -X-> hs-${hsdst}"
+}
+
+check_and_log_hs_isolation()
+{
+	local hssrc=$1
+	local hsdst=$2
+
+	check_and_log_hs_ipv6_isolation ${hssrc} ${hsdst}
+	check_and_log_hs_ipv4_isolation ${hssrc} ${hsdst}
+}
+
+router_tests()
+{
+	local i
+	local j
+
+	log_section "IPv6 routers connectivity test"
+
+	for i in ${ROUTERS}; do
+		for j in ${ROUTERS}; do
+			if [ ${i} -eq ${j} ]; then
+				continue
+			fi
+
+			check_and_log_rt_connectivity ${i} ${j}
+		done
+	done
+}
+
+host2gateway_tests()
+{
+	local hs
+
+	log_section "IPv4/IPv6 connectivity test among hosts and gateways"
+
+	for hs in ${HOSTS}; do
+		check_and_log_hs2gw_connectivity ${hs}
+	done
+}
+
+host_vpn_tests()
+{
+	log_section "SRv6 VPN connectivity test hosts (h1 <-> h2, IPv4/IPv6)"
+
+	check_and_log_hs_connectivity 1 2
+	check_and_log_hs_connectivity 2 1
+
+	log_section "SRv6 VPN connectivity test hosts (h3 <-> h4, IPv6 only)"
+
+	check_and_log_hs_ipv6_connectivity 3 4
+	check_and_log_hs_ipv6_connectivity 4 3
+}
+
+host_vpn_isolation_tests()
+{
+	local l1="1 2"
+	local l2="3 4"
+	local tmp
+	local i
+	local j
+	local k
+
+	log_section "SRv6 VPN isolation test among hosts"
+
+	for k in 0 1; do
+		for i in ${l1}; do
+			for j in ${l2}; do
+				check_and_log_hs_isolation ${i} ${j}
+			done
+		done
+
+		# let us test the reverse path
+		tmp="${l1}"; l1="${l2}"; l2="${tmp}"
+		tmp=${t1}; t1=${t2}; t2=${tmp}
+	done
+
+	log_section "SRv6 VPN isolation test among hosts (h2 <-> h4, IPv4 only)"
+
+	check_and_log_hs_ipv4_isolation 2 4
+	check_and_log_hs_ipv4_isolation 4 2
+}
+
+test_vrf_or_ksft_skip()
+{
+	modprobe vrf &>/dev/null
+	if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
+		echo "SKIP: vrf sysctl does not exist"
+		exit ${ksft_skip}
+	fi
+}
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit ${ksft_skip}
+fi
+
+# required programs to carry out this selftest
+test_command_or_ksft_skip ip
+test_command_or_ksft_skip grep
+test_command_or_ksft_skip sort
+test_command_or_ksft_skip uniq
+
+test_vrf_or_ksft_skip
+
+cleanup &>/dev/null
+
+setup
+
+router_tests
+host2gateway_tests
+host_vpn_tests
+host_vpn_isolation_tests
+
+print_log_test_results
+
+cleanup &>/dev/null
+
+exit ${ret}
-- 
2.20.1

