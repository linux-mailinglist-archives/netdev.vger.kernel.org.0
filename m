Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62F255CE99
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbiF1LiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345223AbiF1LiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:38:03 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E048F33348;
        Tue, 28 Jun 2022 04:38:00 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25SBbSQY010288
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
Subject: [net-next v3 4/4] selftests: seg6: add selftest for SRv6 H.L2Encaps.Red behavior
Date:   Tue, 28 Jun 2022 13:36:42 +0200
Message-Id: <20220628113642.3223-5-andrea.mayer@uniroma2.it>
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

This selftest is designed for testing the H.L2Encaps.Red behavior. It
instantiates a virtual network composed of several nodes: hosts and SRv6
routers. Each node is realized using a network namespace that is
properly interconnected to others through veth pairs.
The test considers SRv6 routers implementing a L2 VPN leveraged by hosts
for communicating with each other. Such routers make use of the SRv6
H.L2Encaps.Red behavior for applying SRv6 policies to L2 traffic coming
from hosts.

The correct execution of the behavior is verified through reachability
tests carried out between hosts belonging to the same VPN.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 .../net/srv6_hl2encap_red_l2vpn_test.sh       | 674 ++++++++++++++++++
 1 file changed, 674 insertions(+)
 create mode 100755 tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh

diff --git a/tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh b/tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh
new file mode 100755
index 000000000000..77e4c945b540
--- /dev/null
+++ b/tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh
@@ -0,0 +1,674 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# author: Andrea Mayer <andrea.mayer@uniroma2.it>
+#
+# This script is designed for testing the SRv6 H.L2Encaps.Red behavior.
+#
+# Below is depicted the IPv6 network of an operator which offers L2 VPN
+# services to hosts, enabling them to communicate with each other.
+# In this example, hosts hs-1 and hs-2 are connected through an L2 VPN service.
+# Currently, the SRv6 subsystem in Linux allows hosts hs-1 and hs-2 to exchange
+# full L2 frames as long as they carry IPv4/IPv6.
+#
+# Routers rt-1,rt-2,rt-3 and rt-4 implement L2 VPN services
+# leveraging the SRv6 architecture. The key components for such VPNs are:
+#
+#   i) The SRv6 H.L2Encaps.Red behavior applies SRv6 Policies on traffic
+#      received by connected hosts, initiating the VPN tunnel. Such a behavior
+#      is an optimization of the SRv6 H.L2Encap aiming to reduce the
+#      length of the SID List carried in the pushed SRH. Specifically, the
+#      H.L2Encaps.Red removes the first SID contained in the SID List (i.e. SRv6
+#      Policy) by storing it into the IPv6 Destination Address. When a SRv6
+#      Policy is made of only one SID, the SRv6 H.L2Encaps.Red behavior omits
+#      the SRH at all and pushes that SID directly into the IPv6 DA;
+#
+#  ii) The SRv6 End behavior advances the active SID in the SID List
+#      carried by the SRH;
+#
+# iii) The SRv6 End.DX2 behavior is used for removing the SRv6 Policy
+#      and, thus, it terminates the VPN tunnel. The decapsulated L2 frame is
+#      sent over the interface connected with the destination host.
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
+#   |fcff:x:d2 is associated with the SRv6 End.DX2 behavior    |
+#   +----------------------------------------------------------+
+#
+# The fcff:/16 prefix is reserved by the operator for implementing SRv6 VPN
+# services. Reachability of SIDs is ensured by proper configuration of the IPv6
+# operator's network and SRv6 routers.
+#
+# SRv6 Policies
+# =============
+#
+# An SRv6 ingress router applies SRv6 policies to the traffic received from a
+# connected host. SRv6 policy enforcement consists of encapsulating the
+# received traffic into a new IPv6 packet with a given SID List contained in
+# the SRH.
+#
+# L2 VPN between hs-1 and hs-2
+# ----------------------------
+#
+# Hosts hs-1 and hs-2 are connected using a dedicated L2 VPN.
+# Specifically, packets generated from hs-1 and directed towards hs-2 are
+# handled by rt-1 which applies the following SRv6 Policies:
+#
+#   i.a) L2 traffic, SID List=fcff:2::d2
+#
+# Policy (i.a) steers tunneled L2 traffic through SRv6 router rt-2.
+# The H.L2Encaps.Red omits the presence of SRH at all, since the SID List
+# consists of only one SID (fcff:2::d2) that can be stored directly in the IPv6
+# DA.
+#
+# On the reverse path (i.e. from hs-2 to hs-1), rt-2 applies the following
+# policies:
+#
+#   i.b) L2 traffic, SID List=fcff:4::e,fcff:3::e,fcff:1::d2
+#
+# Policy (i.b) steers tunneled L2 traffic through the SRv6 routers
+# rt-4,rt-3,rt2. The H.L2Encaps.Red reduces the SID List in the SRH by removing
+# the first SID (fcff:4::e) and pushing it into the IPv6 DA.
+#
+# In summary:
+#  * hs-1 -> hs-2 |IPv6 DA=fcff:2::d2|eth|...|                              (i.a)
+#  * hs-2 -> hs-1 |IPv6 DA=fcff:4::e|SRH SIDs=fcff:3::e,fcff:1::d2|eth|...| (i.b)
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+readonly LOCALSID_TABLE_ID=90
+readonly IPv6_RT_NETWORK=fcf0:0
+readonly IPv6_HS_NETWORK=cafe
+readonly IPv4_HS_NETWORK=10.0.0
+readonly VPN_LOCATOR_SERVICE=fcff
+readonly MAC_PREFIX=00:00:00:c0:01
+readonly END_FUNC=000e
+readonly DX2_FUNC=00d2
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
+
+	ip link del pdum0 &>/dev/null || true
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
+	ip -netns ${nsname} link add dum0 type dummy
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
+	ip -netns ${nsname} link set dum0 up
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
+	local rtveth=veth-host
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
+		encap seg6local action End count dev dum0
+
+	# all SIDs for VPNs start with a common locator. Routes and SRv6
+	# Endpoint behaviors instaces are grouped together in the 'localsid'
+	# table.
+	ip -netns ${nsname} -6 rule add \
+			to ${VPN_LOCATOR_SERVICE}::/16 \
+			lookup ${LOCALSID_TABLE_ID} prio 999
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
+	local rtveth=veth-host
+	local policy=''
+	local n
+
+	for n in ${end_rts}; do
+		policy=${policy}"${VPN_LOCATOR_SERVICE}:${n}::${END_FUNC},"
+	done
+
+	policy=${policy}"${VPN_LOCATOR_SERVICE}:${dec_rt}::${DX2_FUNC}"
+
+	# add SRv6 policy to incoming traffic sent by attached hosts
+	if [ "${traffic}" -eq 6 ]; then
+		ip -netns ${nsname} -6 route add ${IPv6_HS_NETWORK}::${dst} \
+			encap seg6 mode ${mode} segs ${policy} dev dum0
+	else
+		ip -netns ${nsname} -4 route add ${IPv4_HS_NETWORK}.${dst} \
+			encap seg6 mode ${mode} segs ${policy} dev dum0
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
+setup_decap()
+{
+	local rt=$1
+	local nsname=rt-${rt}
+	local rtveth=veth-host
+
+	# Local End.DX2 behavior
+	ip -netns ${nsname} -6 route add ${VPN_LOCATOR_SERVICE}:${rt}::${DX2_FUNC} \
+		table ${LOCALSID_TABLE_ID} \
+		encap seg6local action End.DX2 oif ${rtveth} count dev ${rtveth}
+}
+
+setup_hs()
+{
+	local hs=$1
+	local rt=$2
+	local hsname=hs-${hs}
+	local rtname=rt-${rt}
+	local rtveth=veth-host
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
+	ip -netns ${rtname} addr add ${IPv6_HS_NETWORK}::254/64 dev ${rtveth} nodad
+	ip -netns ${rtname} addr add ${IPv4_HS_NETWORK}.254/24 dev ${rtveth}
+	ip -netns ${rtname} link set ${rtveth} up
+
+	# disable the rp_filter otherwise the kernel gets confused about how
+	# to route decap ipv4 packets.
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.${rtveth}.rp_filter=0
+}
+
+# set an auto-generated mac address
+# args:
+#  $1 - name of the node (e.g.: hs-1, rt-3, etc)
+#  $2 - id of the node (e.g.: 1 for hs-1, 3 for rt-3, etc)
+#  $3 - host part of the IPv6 network address
+#  $4 - name of the network interface to which the generated mac address must
+#       be set.
+set_mac_address()
+{
+	local nodename=$1
+	local nodeid=$2
+	local host=$3
+	local ifname=$4
+
+	ip -netns ${nodename} link set dev ${ifname} down
+	ip -netns ${nodename} link set address ${MAC_PREFIX}:${nodeid} \
+		dev ${ifname}
+
+	# the IPv6 address must be set once again after the MAC address has
+	# been changed.
+	ip -netns ${nodename} addr add ${IPv6_HS_NETWORK}::${host}/64 \
+		dev ${ifname} nodad
+
+	ip -netns ${nodename} link set dev ${ifname} up
+}
+
+set_host_l2peer()
+{
+	local hssrc=$1
+	local hsdst=$2
+	local ipprefix=$3
+	local proto=$4
+	local hssrc_name=hs-${hssrc}
+	local ipaddr
+
+	if [ ${proto} -eq 6 ]; then
+		ipaddr=${ipprefix}::${hsdst}
+	else
+		ipaddr=${ipprefix}.${hsdst}
+	fi
+
+	ip -netns ${hssrc_name} route add ${ipaddr} dev veth0
+	ip -netns ${hssrc_name} neigh add ${ipaddr} \
+		lladdr ${MAC_PREFIX}:${hsdst} dev veth0
+}
+
+# setup an SRv6 L2 VPN between host hs-x and hs-y (currently, the SRv6
+# subsystem only supports L2 frames whose layer-3 is IPv4/IPv6).
+# args:
+#  $1 - source host
+#  $2 - SRv6 routers configured for steering tunneled traffic
+#  $3 - destination host
+setup_l2vpn()
+{
+	local hssrc=$1
+	local end_rts=$2
+	local hsdst=$3
+	local rtsrc=${hssrc}
+	local rtdst=${hsdst}
+	local rtveth=veth-host
+
+	# set fixed mac for source node and the neigh MAC address
+	set_mac_address hs-${hssrc} ${hssrc} ${hssrc} veth0
+	set_host_l2peer ${hssrc} ${hsdst} ${IPv6_HS_NETWORK} 6
+	set_host_l2peer ${hssrc} ${hsdst} ${IPv4_HS_NETWORK} 4
+
+	# we have to set the mac address of the veth-host (on ingress router)
+	# to the mac address of the remote peer (L2 VPN destination host).
+	# Otherwise, traffic coming from the source host is dropped at the
+	# ingress router.
+	set_mac_address rt-${rtsrc} ${hsdst} 254 ${rtveth}
+
+	# set the SRv6 Policies at the ingress router
+	setup_rt_policy_ipv6 ${hsdst} ${rtsrc} "${end_rts}" ${rtdst} l2encap.red 6
+	setup_rt_policy_ipv4 ${hsdst} ${rtsrc} "${end_rts}" ${rtdst} l2encap.red 4
+
+	# set the decap behavior at the egress router
+	setup_decap ${rtsrc}
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
+	HOSTS="1 2"
+	setup_hs 1 1
+	setup_hs 2 2
+
+	# set up default SRv6 Endpoints (i.e. SRv6 End and SRv6 End.DX2)
+	setup_rt_local_sids 1 "2 3 4"
+	setup_rt_local_sids 2 "1 3 4"
+	setup_rt_local_sids 3 "1 2 4"
+	setup_rt_local_sids 4 "1 2 3"
+
+	# create a L2 VPN between hs-1 and hs-2.
+	# NB: currently, H.L2Encap* enables tunneling of L2 frames whose
+	# layer-3 is IPv4/IPv6.
+	#
+	# the network path between hs-1 and hs-2 traverses several routers
+	# depending on the direction of traffic.
+	#
+	# Direction hs-1 -> hs-2 (H.L2Encaps.Red)
+	# - rt-2 (SRv6 End.DX2 behavior)
+	#
+	# Direction hs-2 -> hs-1 (H.L2Encaps.Red)
+	#  - rt-4,rt-3 (SRv6 End behaviors)
+	#  - rt-1 (SRv6 End.DX2 behavior)
+	setup_l2vpn 1 "" 2
+	setup_l2vpn 2 "4 3" 1
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
+	log_section "SRv6 L2 VPN connectivity test hosts (h1 <-> h2)"
+
+	check_and_log_hs_connectivity 1 2
+	check_and_log_hs_connectivity 2 1
+}
+
+test_dummy_or_ksft_skip()
+{
+	modprobe dummy &>/dev/null
+	ip link add pdum0 type dummy
+	if [ $? -ne 0 ]; then
+		echo "SKIP: dummy not supported"
+		exit ${ksft_skip}
+	fi
+
+	ip link del dev pdum0
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
+test_dummy_or_ksft_skip
+
+cleanup &>/dev/null
+
+setup
+
+router_tests
+host2gateway_tests
+host_vpn_tests
+
+print_log_test_results
+
+cleanup &>/dev/null
+
+exit ${ret}
-- 
2.20.1

