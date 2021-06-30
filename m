Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD063B8276
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhF3MyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:54:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234768AbhF3MyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:54:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625057504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ajBJtzqJE+l3NXjrwwRSscZLpEMU0RH+8vaS4u/Frqw=;
        b=ceZRISM9y/crQNZqVNgxxnj+S1SY3+h2Y5vOJIMjb/b5xje1q5QwWS3cximuJt6Mxe8Tu6
        0mK4iuqucZ42WICkHCv8zpeLcXRSIz60rVEfbEu4xF6jvY3vU2QoQzN/PK289HK/0VV7/Y
        /vcebKvXx0jrJxJThl0YmwLmqtFsN4M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-oUzbnZf2OZSRTxXV5RzGag-1; Wed, 30 Jun 2021 08:51:42 -0400
X-MC-Unique: oUzbnZf2OZSRTxXV5RzGag-1
Received: by mail-wm1-f69.google.com with SMTP id z127-20020a1c7e850000b02901e46e4d52c0so2784294wmc.6
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ajBJtzqJE+l3NXjrwwRSscZLpEMU0RH+8vaS4u/Frqw=;
        b=rOinOSG3kpvfJCD26FSRNjOrMiyGe1dp3xZxPD3twmmw78CF9BCSl0CRAfNps9fl81
         3MXonawL9AHHhhlAVmu+qOXUEWxFmuCTbwwpX/QG32OsW3mKb4F1K4N0rdAIBQWmCuol
         99baT1aEUc9FkTKl94LHu7ULied0H/OUyxdCXEauCCvG1p7PR2M54UcyeGKiwemoWvpZ
         e0sv5+or3DNb4coMvbcCy2+cr/YLI6FTE/l+DpyMqcTGZQ8yBvEuH2IgMCGKdw3LQFxI
         ymIc2WACC7ya7LJn46ZD9lJlnNfEZ8DtnKkBw3YVi+1TjPXH2g/JnIhbShFPoD6M+pxx
         IjIg==
X-Gm-Message-State: AOAM533U9Vy85ewDOXBBmjOVqY3JojnMtIfm6uakoTeyIHdya8QLaOA6
        I8wtAD/PisWmvsXHZ3Jio5ka8OtuVPLNbQe+ILNcj7w0mz++0GhYpILPOsjSqCI6Zdgg/Yg+LFt
        hJT13OJ7XLeNcDLQW
X-Received: by 2002:a05:600c:33a6:: with SMTP id o38mr4402921wmp.126.1625057501248;
        Wed, 30 Jun 2021 05:51:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd21aw/LgQxBoWwOk1235Qjr+tzsook1RHTvCUxo7CwlwayETBwncGxHyJkYIxhJI+SuFFPA==
X-Received: by 2002:a05:600c:33a6:: with SMTP id o38mr4402892wmp.126.1625057500902;
        Wed, 30 Jun 2021 05:51:40 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id w8sm8325967wrt.83.2021.06.30.05.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:51:40 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:51:38 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre or
 ipip packets to Ethernet
Message-ID: <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
References: <cover.1625056665.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1625056665.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for the following commits:
  * aab1e898c26c ("gre: let mac_header point to outer header only when
    necessary"),
  * 7ad136fd288c ("ipip: allow redirecting ipip and mplsip packets to
    eth devices").

Two end hosts ping each other, but they're separated by two routers.
The routers encapsulate the end host packets into gre or ipip packets.
On decap, the routers add an Ethernet header to the inner L3 packet and
forward the resulting frame to the end host.

A new topo_nschain_lib.sh file is created, to make the base network
settings reusable. The actual tests are implemented in
tc_redirect_l2l3.sh.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 tools/testing/selftests/net/forwarding/config |   2 +
 .../net/forwarding/tc_redirect_l2l3.sh        | 287 ++++++++++++++++++
 .../net/forwarding/topo_nschain_lib.sh        | 267 ++++++++++++++++
 4 files changed, 557 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
 create mode 100644 tools/testing/selftests/net/forwarding/topo_nschain_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index d97bd6889446..a5005b01f14c 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -49,6 +49,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
 	tc_mpls_l2vpn.sh \
+	tc_redirect_l2l3.sh \
 	tc_shblocks.sh \
 	tc_vlan_modify.sh \
 	vxlan_asymmetric.sh \
diff --git a/tools/testing/selftests/net/forwarding/config b/tools/testing/selftests/net/forwarding/config
index a4bd1b087303..9d28f801866f 100644
--- a/tools/testing/selftests/net/forwarding/config
+++ b/tools/testing/selftests/net/forwarding/config
@@ -16,3 +16,5 @@ CONFIG_NET_ACT_GACT=m
 CONFIG_VETH=m
 CONFIG_NAMESPACES=y
 CONFIG_NET_NS=y
+CONFIG_NET_IPGRE=m
+CONFIG_NET_IPIP=m
diff --git a/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
new file mode 100755
index 000000000000..3e69b5deb608
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
@@ -0,0 +1,287 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test redirecting frames received on L3 tunnel interfaces to an Ethernet
+# interface, after having added an Ethernet header.
+#
+# Example:
+#
+#  $ tc filter add dev ipip0 ingress matchall          \
+#       action vlan push_eth dst_mac 00:00:5e:00:53:01 \
+#                            src_mac 00:00:5e:00:53:00 \
+#       action mirred egress redirect dev eth0
+#
+# Network topology is as follow: H1 and H2 are end hosts, separated by two
+# routers, RTA and RTB. They ping each other using IPv4, IPv6, IPv4 in MPLS
+# and IPv6 in MPLS packets. The L3 tunnel to test is established between RTA
+# and RTB. These routers redirect packets from the tunnel to the end host's
+# veth and the other way around.
+#
+# This scripts only needs to define how packets are forwarded between RTA and
+# RTB (as that's where we do and test the tunnel encapsulation and packet
+# redirection). The base network configuration is done in topo_nschain_lib.sh.
+
+ALL_TESTS="
+	redir_gre
+	redir_ipip
+"
+
+NUM_NETIFS=0
+
+source topo_nschain_lib.sh
+source lib.sh
+
+readonly KSFT_PASS=0
+readonly KSFT_FAIL=1
+readonly KSFT_SKIP=4
+
+KSFT_RET="${KSFT_PASS}"
+TESTS_COMPLETED="no"
+
+# Create tunnels between RTA and RTB, and forward packets between tunnel and
+# veth interfaces.
+#
+# Parameters:
+#
+#   * $1: IP version of the underlay to use ("ipv4" or "ipv6").
+#   * $2: Tunnel mode (either "classical" or "collect_md").
+#   * $3: Device type (as in "ip link add mydev type <dev_type> ...").
+#   * $4: Options for the "ip link add" command
+#         (as in "ip link add mydev type dev_type <options>").
+#   * $5: Options for the TC tunnel_key command
+#         (as in "tc filter add ... action tunnel_key set <options>").
+#
+# For classical tunnels, the "local" and "remote" options of "ip link add" are
+# set automatically and mustn't appear in $4.
+#
+# For collect_md tunnels, the "src_ip" and "dst_ip" options of
+# "action tunnel_key" are set automatically and mustn't appear in $5.
+#
+setup_tunnel()
+{
+	local UNDERLAY_PROTO="$1"; readonly UNDERLAY_PROTO
+	local TUNNEL_MODE="$2"; readonly TUNNEL_MODE
+	local DEV_TYPE="$3"; readonly DEV_TYPE
+	local DEV_OPTS="$4"; readonly DEV_OPTS
+	local TK_OPTS="$5"; readonly TK_OPTS
+	local RTA_TUNNEL_OPTS
+	local RTB_TUNNEL_OPTS
+	local RTA_TK_ACTION
+	local RTB_TK_ACTION
+	local IP_RTA
+	local IP_RTB
+
+	case "${UNDERLAY_PROTO}" in
+		"IPv4"|"ipv4")
+			IP_RTA="192.0.2.0xab"
+			IP_RTB="192.0.2.0xba"
+			;;
+		"IPv6"|"ipv6")
+			IP_RTA="2001:db8::ab"
+			IP_RTB="2001:db8::ba"
+			;;
+		*)
+			exit 1
+			;;
+	esac
+
+	case "${TUNNEL_MODE}" in
+		"classical")
+			# Classical tunnel: underlay IP addresses are part of
+			# the tunnel configuration.
+			RTA_TUNNEL_OPTS="local ${IP_RTA} remote ${IP_RTB} ${DEV_OPTS}"
+			RTB_TUNNEL_OPTS="local ${IP_RTB} remote ${IP_RTA} ${DEV_OPTS}"
+			RTA_TK_ACTION=""
+			RTB_TK_ACTION=""
+			;;
+		"collect_md")
+			# External tunnel: underlay IP addresses are attached
+			# to the packets' metadata with the tunnel_key action
+			RTA_TUNNEL_OPTS="${DEV_OPTS}"
+			RTB_TUNNEL_OPTS="${DEV_OPTS}"
+			RTA_TK_ACTION="action tunnel_key set src_ip ${IP_RTA} dst_ip ${IP_RTB} ${TK_OPTS}"
+			RTB_TK_ACTION="action tunnel_key set src_ip ${IP_RTB} dst_ip ${IP_RTA} ${TK_OPTS}"
+			;;
+		*)
+		    echo "Internal error: setup_tunnel(): invalid tunnel mode \"${TUNNEL_MODE}\""
+		    return 1
+		    ;;
+	esac
+
+	# Transform options strings to arrays, so we can pass them to the ip or
+	# tc commands with double quotes (prevents shellcheck warning).
+	read -ra RTA_TUNNEL_OPTS <<< "${RTA_TUNNEL_OPTS}"
+	read -ra RTB_TUNNEL_OPTS <<< "${RTB_TUNNEL_OPTS}"
+	read -ra RTA_TK_ACTION <<< "${RTA_TK_ACTION}"
+	read -ra RTB_TK_ACTION <<< "${RTB_TK_ACTION}"
+
+	tc -netns "${RTA}" qdisc add dev veth-rta-h1 ingress
+	tc -netns "${RTB}" qdisc add dev veth-rtb-h2 ingress
+
+	ip -netns "${RTA}" link add name tunnel-rta up type "${DEV_TYPE}" \
+		"${RTA_TUNNEL_OPTS[@]}"
+	ip -netns "${RTB}" link add name tunnel-rtb up type "${DEV_TYPE}" \
+		"${RTB_TUNNEL_OPTS[@]}"
+
+	# Encapsulate IPv4 packets
+	tc -netns "${RTA}" filter add dev veth-rta-h1 ingress	\
+		protocol ipv4 flower dst_ip 198.51.100.2	\
+		"${RTA_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rta
+	tc -netns "${RTB}" filter add dev veth-rtb-h2 ingress	\
+		protocol ipv4 flower dst_ip 198.51.100.1	\
+		"${RTB_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rtb
+
+	# Encapsulate IPv6 packets
+	tc -netns "${RTA}" filter add dev veth-rta-h1 ingress	\
+		protocol ipv6 flower dst_ip 2001:db8::1:2	\
+		"${RTA_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rta
+	tc -netns "${RTB}" filter add dev veth-rtb-h2 ingress	\
+		protocol ipv6 flower dst_ip 2001:db8::1:1	\
+		"${RTB_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rtb
+
+	# Encapsulate MPLS packets
+	tc -netns "${RTA}" filter add dev veth-rta-h1 ingress	\
+		protocol mpls_uc matchall			\
+		"${RTA_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rta
+	tc -netns "${RTB}" filter add dev veth-rtb-h2 ingress	\
+		protocol mpls_uc matchall			\
+		"${RTB_TK_ACTION[@]}"				\
+		action mirred egress redirect dev tunnel-rtb
+
+	tc -netns "${RTA}" qdisc add dev tunnel-rta ingress
+	tc -netns "${RTB}" qdisc add dev tunnel-rtb ingress
+
+	# Redirect packets from tunnel devices to end hosts
+	tc -netns "${RTA}" filter add dev tunnel-rta ingress matchall	\
+		action vlan push_eth dst_mac 00:00:5e:00:53:1a		\
+			src_mac 00:00:5e:00:53:a1			\
+		action mirred egress redirect dev veth-rta-h1
+	tc -netns "${RTB}" filter add dev tunnel-rtb ingress matchall	\
+		action vlan push_eth dst_mac 00:00:5e:00:53:2b		\
+			src_mac 00:00:5e:00:53:b2			\
+		action mirred egress redirect dev veth-rtb-h2
+}
+
+# Remove everything that was created by setup_tunnel().
+#
+cleanup_tunnel()
+{
+	ip -netns "${RTB}" link delete dev tunnel-rtb
+	ip -netns "${RTA}" link delete dev tunnel-rta
+	tc -netns "${RTB}" qdisc delete dev veth-rtb-h2 ingress
+	tc -netns "${RTA}" qdisc delete dev veth-rta-h1 ingress
+}
+
+# Ping H2 from H1.
+#
+# Parameters:
+#
+#   $1: The protocol used for the ping test:
+#         * ipv4: use plain IPv4 packets,
+#         * ipv6: use plain IPv6 packets,
+#         * ipv4-mpls: use IPv4 packets encapsulated into MPLS,
+#         * ipv6-mpls: use IPv6 packets encapsulated into MPLS.
+#   $2: Description of the test.
+#
+ping_test()
+{
+	local PROTO="$1"; readonly PROTO
+	local MSG="$2"; readonly MSG
+	local PING_CMD
+	local PING_IP
+
+	case "${PROTO}" in
+		"ipv4")
+			PING_CMD="${PING}"
+			PING_IP="198.51.100.2"
+			;;
+		"ipv6")
+			PING_CMD="${PING6}"
+			PING_IP="2001:db8::1:2"
+			;;
+		"ipv4-mpls")
+			PING_CMD="${PING}"
+			PING_IP="198.51.100.0x12"
+			;;
+		"ipv6-mpls")
+			PING_CMD="${PING6}"
+			PING_IP="2001:db8::1:12"
+			;;
+		*)
+			echo "Internal error: ping_test(): invalid protocol \"${PROTO}\""
+			return 1
+			;;
+	esac
+
+	set +e
+	RET=0
+	ip netns exec "${H1}" "${PING_CMD}" -w "${PING_TIMEOUT}" -c 1 "${PING_IP}" > /dev/null 2>&1
+	RET=$?
+	log_test "${MSG}" || KSFT_RET="${KSFT_FAIL}"
+	set -e
+}
+
+redir_gre()
+{
+	setup_tunnel "ipv4" "classical" "gre"
+	ping_test ipv4 "GRE, classical mode: IPv4 / GRE / IPv4"
+	ping_test ipv6 "GRE, classical mode: IPv4 / GRE / IPv6"
+	ping_test ipv4-mpls "GRE, classical mode: IPv4 / GRE / MPLS / IPv4"
+	ping_test ipv6-mpls "GRE, classical mode: IPv4 / GRE / MPLS / IPv6"
+	cleanup_tunnel
+
+	setup_tunnel "ipv4" "collect_md" "gre" "external" "nocsum"
+	ping_test ipv4 "GRE, external mode: IPv4 / GRE / IPv4"
+	ping_test ipv6 "GRE, external mode: IPv4 / GRE / IPv6"
+	ping_test ipv4-mpls "GRE, external mode: IPv4 / GRE / MPLS / IPv4"
+	ping_test ipv6-mpls "GRE, external mode: IPv4 / GRE / MPLS / IPv6"
+	cleanup_tunnel
+}
+
+redir_ipip()
+{
+	setup_tunnel "ipv4" "classical" "ipip" "mode any"
+	ping_test ipv4 "IPIP, classical mode: IPv4 / IPv4"
+	ping_test ipv4-mpls "IPIP, classical mode: IPv4 / MPLS / IPv4"
+	ping_test ipv6-mpls "IPIP, classical mode: IPv4 / MPLS / IPv6"
+	cleanup_tunnel
+
+	setup_tunnel "ipv4" "collect_md" "ipip" "mode any external"
+	ping_test ipv4 "IPIP, external mode: IPv4 / IPv4"
+	ping_test ipv4-mpls "IPIP, external mode: IPv4 / MPLS / IPv4"
+	ping_test ipv6-mpls "IPIP, external mode: IPv4 / MPLS / IPv6"
+	cleanup_tunnel
+}
+
+exit_cleanup()
+{
+	if [ "${TESTS_COMPLETED}" = "no" ]; then
+		KSFT_RET="${KSFT_FAIL}"
+	fi
+
+	pre_cleanup
+	nsc_cleanup_ns "${H1}" "${RTA}" "${RTB}" "${H2}"
+	exit "${KSFT_RET}"
+}
+
+
+if ! tc actions add action vlan help 2>&1 | grep --quiet 'push_eth'; then
+	echo "SKIP: iproute2 is too old: tc doesn't support action \"push_eth\""
+	exit "${KSFT_SKIP}"
+fi
+
+nsc_setup_ns || exit "${KSFT_FAIL}"
+
+set -e
+trap exit_cleanup EXIT
+
+nsc_setup_base_net
+nsc_setup_hosts_net
+
+tests_run
+TESTS_COMPLETED="yes"
diff --git a/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
new file mode 100644
index 000000000000..4c0bf2d7328a
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
@@ -0,0 +1,267 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A chain of 4 nodes connected with veth pairs.
+# Each node lives in its own network namespace.
+# Each veth interface has an IPv4 and an IPv6 address. A host route provides
+# connectivity to the adjacent node. This base network only allows nodes to
+# communicate with their immediate neighbours.
+#
+# The two nodes at the extremities of the chain also have 4 host IPs on their
+# loopback device:
+#   * An IPv4 address, routed as is to the adjacent router.
+#   * An IPv4 address, routed over MPLS to the adjacent router.
+#   * An IPv6 address, routed as is to the adjacent router.
+#   * An IPv6 address, routed over MPLS to the adjacent router.
+#
+# This topology doesn't define how RTA and RTB handle these packets: users of
+# this script are responsible for the plumbing between RTA and RTB.
+#
+# As each veth connects two different namespaces, their MAC and IP addresses
+# are defined depending on the local and remote namespaces. For example
+# veth-h1-rta, which sits in H1 and links to RTA, has MAC address
+# 00:00:5e:00:53:1a, IPv4 192.0.2.0x1a and IPv6 2001:db8::1a, where "1a" means
+# that it's in H1 and links to RTA (the rest of each address is always built
+# from a IANA documentation prefix).
+#
+# Routed addresses in H1 and H2 on the other hand encode the routing type (with
+# or without MPLS encapsulation) and the namespace the address resides in. For
+# example H2 has 198.51.100.2 and 2001:db8::1:2, that are routed as is through
+# RTB. It also has 198.51.100.0x12 and 2001:db8::1:12, that are routed through
+# RTB with MPLS encapsulation.
+#
+# For clarity, the prefixes used for host IPs are different from the ones used
+# on the veths.
+#
+# The MPLS labels follow a similar principle: the first digit represents the
+# IP version of the encapsulated packet ("4" for IPv4, "6" for IPv6), the
+# second digit represents the destination host ("1" for H1, "2" for H2).
+#
+# +----------------------------------------------------+
+# |                    Host 1 (H1)                     |
+# |                                                    |
+# |   lo                                               |
+# |     198.51.100.1    (for plain IPv4)               |
+# |     2001:db8::1:1   (for plain IPv6)               |
+# |     198.51.100.0x11 (for IPv4 over MPLS, label 42) |
+# |     2001:db8::1:11  (for IPv6 over MPLS, label 62) |
+# |                                                    |
+# | + veth-h1-rta                                      |
+# | |   192.0.2.0x1a                                   |
+# | |   2001:db8::1a                                   |
+# +-|--------------------------------------------------+
+#   |
+# +-|--------------------+
+# | |  Router A (RTA)    |
+# | |                    |
+# | + veth-rta-h1        |
+# |     192.0.2.0xa1     |
+# |     2001:db8::a1     |
+# |                      |
+# | + veth-rta-rtb       |
+# | |   192.0.2.0xab     |
+# | |   2001:db8::ab     |
+# +-|--------------------+
+#   |
+# +-|--------------------+
+# | |  Router B (RTB)    |
+# | |                    |
+# | + veth-rtb-rta       |
+# |     192.0.2.0xba     |
+# |     2001:db8::ba     |
+# |                      |
+# | + veth-rtb-h2        |
+# | |   192.0.2.0xb2     |
+# | |   2001:db8::b2     |
+# +-|--------------------+
+#   |
+# +-|--------------------------------------------------+
+# | |                  Host 2 (H2)                     |
+# | |                                                  |
+# | + veth-h2-rtb                                      |
+# |     192.0.2.0x2b                                   |
+# |     2001:db8::2b                                   |
+# |                                                    |
+# |   lo                                               |
+# |     198.51.100.2    (for plain IPv4)               |
+# |     2001:db8::1:2   (for plain IPv6)               |
+# |     198.51.100.0x12 (for IPv4 over MPLS, label 41) |
+# |     2001:db8::1:12  (for IPv6 over MPLS, label 61) |
+# +----------------------------------------------------+
+#
+# This topology can be used for testing different routing or switching
+# scenarios, as H1 and H2 are pre-configured for sending different kinds of
+# packets (IPv4, IPv6, with or without MPLS encapsulation), which RTA and RTB
+# can easily match and process according to the forwarding mechanism to test.
+
+readonly H1=$(mktemp -u h1-XXXXXXXX)
+readonly RTA=$(mktemp -u rta-XXXXXXXX)
+readonly RTB=$(mktemp -u rtb-XXXXXXXX)
+readonly H2=$(mktemp -u h2-XXXXXXXX)
+
+# Create and configure a veth pair between two network namespaces A and B
+#
+# Parameters:
+#
+#   * $1: Name of netns A.
+#   * $2: Name of netns B.
+#   * $3: Name of the veth device to create in netns A.
+#   * $4: Name of the veth device to create in netns B.
+#   * $5: Identifier used to configure IP and MAC addresses in netns A.
+#   * $6: Identifier used to configure IP and MAC addresses in netns B.
+#
+# The identifiers are a one byte long integer given in hexadecimal format
+# (without a "0x" prefix). They're used as the lowest order byte for the MAC,
+# IPv4 and IPv6 addresses.
+#
+nsc_veth_config()
+{
+	local NS_A="${1}"; readonly NS_A
+	local NS_B="${2}"; readonly NS_B
+	local DEV_A="${3}"; readonly DEV_A
+	local DEV_B="${4}"; readonly DEV_B
+	local ID_A="${5}"; readonly ID_A
+	local ID_B="${6}"; readonly ID_B
+
+	ip link add name "${DEV_A}" address 00:00:5e:00:53:"${ID_A}"	\
+		netns "${NS_A}" type veth peer name "${DEV_B}"		\
+		address 00:00:5e:00:53:"${ID_B}" netns "${NS_B}"
+	ip -netns "${NS_A}" link set dev "${DEV_A}" up
+	ip -netns "${NS_B}" link set dev "${DEV_B}" up
+
+	ip -netns "${NS_A}" address add dev "${DEV_A}"		\
+		192.0.2.0x"${ID_A}" peer 192.0.2.0x"${ID_B}"/32
+	ip -netns "${NS_B}" address add dev "${DEV_B}"		\
+		192.0.2.0x"${ID_B}" peer 192.0.2.0x"${ID_A}"/32
+
+	ip -netns "${NS_A}" address add dev "${DEV_A}"			\
+		2001:db8::"${ID_A}" peer 2001:db8::"${ID_B}" nodad
+	ip -netns "${NS_B}" address add dev "${DEV_B}"			\
+		2001:db8::"${ID_B}" peer 2001:db8::"${ID_A}" nodad
+}
+
+# Add host IP addresses to the loopback device and route them to the adjacent
+# router.
+#
+# Parameters:
+#
+#   $1: Name of the netns to configure.
+#   $2: Identifier used to configure the local IP address.
+#   $3: Identifier used to configure the remote IP address.
+#   $4: IPv4 address of the adjacent router.
+#   $5: IPv6 address of the adjacent router.
+#   $6: Name of the network interface that links to the adjacent router.
+#
+# The identifiers are a one byte long integer given in hexadecimal format
+# (without a "0x" prefix). They're used as the lowest order byte for the IPv4
+# and IPv6 addresses.
+#
+nsc_lo_config()
+{
+	local NS="${1}"; readonly NS
+	local LOCAL_NSID="${2}"; readonly LOCAL_NSID
+	local PEER_NSID="${3}"; readonly PEER_NSID
+	local GW_IP4="${4}"; readonly GW_IP4
+	local GW_IP6="${5}"; readonly GW_IP6
+	local IFACE="${6}"; readonly IFACE
+
+	# For testing plain IPv4 traffic
+	ip -netns "${NS}" address add 198.51.100.0x"${LOCAL_NSID}"/32 dev lo
+	ip -netns "${NS}" route add 198.51.100.0x"${PEER_NSID}"/32	\
+		src 198.51.100.0x"${LOCAL_NSID}" via "${GW_IP4}"
+
+	# For testing plain IPv6 traffic
+	ip -netns "${NS}" address add 2001:db8::1:"${LOCAL_NSID}"/128 dev lo
+	ip -netns "${NS}" route add 2001:db8::1:"${PEER_NSID}"/128	\
+		src 2001:db8::1:"${LOCAL_NSID}" via "${GW_IP6}"
+
+	# For testing IPv4 over MPLS traffic
+	ip -netns "${NS}" address add 198.51.100.0x1"${LOCAL_NSID}"/32 dev lo
+	ip -netns "${NS}" route add 198.51.100.0x1"${PEER_NSID}"/32	\
+		src 198.51.100.0x1"${LOCAL_NSID}"			\
+		encap mpls 4"${PEER_NSID}" via "${GW_IP4}"
+
+	# For testing IPv6 over MPLS traffic
+	ip -netns "${NS}" address add 2001:db8::1:1"${LOCAL_NSID}"/128 dev lo
+	ip -netns "${NS}" route add 2001:db8::1:1"${PEER_NSID}"/128	\
+		src 2001:db8::1:1"${LOCAL_NSID}"			\
+		encap mpls 6"${PEER_NSID}" via "${GW_IP6}"
+
+	# Allow MPLS traffic
+	ip netns exec "${NS}" sysctl -qw net.mpls.platform_labels=100
+	ip netns exec "${NS}" sysctl -qw net.mpls.conf."${IFACE}".input=1
+
+	# Deliver MPLS packets locally
+	ip -netns "${NS}" -family mpls route add 4"${LOCAL_NSID}" dev lo
+	ip -netns "${NS}" -family mpls route add 6"${LOCAL_NSID}" dev lo
+}
+
+# Remove the network namespaces
+#
+# Parameters:
+#
+#   * The list of network namespaces to delete.
+#
+nsc_cleanup_ns()
+{
+	for ns in "$@"; do
+		ip netns delete "${ns}" 2>/dev/null || true
+	done
+}
+
+# Remove the network namespaces and return error
+#
+# Parameters:
+#
+#   * The list of network namespaces to delete.
+#
+nsc_err_cleanup_ns()
+{
+	nsc_cleanup_ns "$@"
+	return 1
+}
+
+# Create the four network namespaces (H1, RTA, RTB and H2)
+#
+nsc_setup_ns()
+{
+	ip netns add "${H1}" || nsc_err_cleanup_ns
+	ip netns add "${RTA}" || nsc_err_cleanup_ns "${H1}"
+	ip netns add "${RTB}" || nsc_err_cleanup_ns "${H1}" "${RTA}"
+	ip netns add "${H2}" || nsc_err_cleanup_ns "${H1}" "${RTA}" "${RTB}"
+}
+
+# Create base networking topology:
+#
+#   * Set up the loopback device in all network namespaces.
+#   * Create a veth pair to connect each netns in sequence.
+#   * Add an IPv4 and an IPv6 address on each veth interface.
+#
+# Requires the network namespaces to already exist (see nsc_setup_ns()).
+#
+nsc_setup_base_net()
+{
+	for ns in "${H1}" "${RTA}" "${RTB}" "${H2}"; do
+		ip -netns "${ns}" link set dev lo up
+	done;
+
+	nsc_veth_config "${H1}" "${RTA}" veth-h1-rta veth-rta-h1 1a a1
+	nsc_veth_config "${RTA}" "${RTB}" veth-rta-rtb veth-rtb-rta ab ba
+	nsc_veth_config "${RTB}" "${H2}" veth-rtb-h2 veth-h2-rtb b2 2b
+}
+
+# Configure the host IP addresses and routes in H1 and H2:
+#
+#   * Define the four host IP addresses on the loopback device of H1 and H2.
+#   * Route these addresses in H1 and H2 through the adjacent router (with MPLS
+#     encapsulation for two of them).
+#   * No routing is defined between RTA and RTB, that's the responsibility of
+#     the calling script.
+#
+# Requires the base network to be configured (see nsc_setup_base_net()).
+#
+nsc_setup_hosts_net()
+{
+	nsc_lo_config "${H1}" 1 2 192.0.2.0xa1 2001:db8::a1 veth-h1-rta
+	nsc_lo_config "${H2}" 2 1 192.0.2.0xb2 2001:db8::b2 veth-h2-rtb
+}
-- 
2.21.3

