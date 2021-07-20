Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F83D0372
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhGTUJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:23 -0400
Received: from novek.ru ([213.148.174.62]:46650 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237733AbhGTTzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:55:08 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 5C37F503E25;
        Tue, 20 Jul 2021 23:33:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 5C37F503E25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626813200; bh=GW4Vmih5xj74VjcgQGvWz7Y5V5BTKkO8qSbc9G03p/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dy1PSN8B3Ir6bIvvY6F1MdpInE0T+DSkEIj8Yquaq94cTLIDRDRwHwgwLrx1lC9MF
         03II+M2MeC57psQx62IEYdHgKfur4AGzWAC6Ng2B56zl5kuiAXlwYhucfdTfjMMp57
         iC60eLyyFWPbfbvBZe/lWVRZpJ+fUC7aRKUoKYU0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v3 2/2] selftests: net: add ESP-in-UDP PMTU test
Date:   Tue, 20 Jul 2021 23:35:29 +0300
Message-Id: <20210720203529.21601-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210720203529.21601-1-vfedorenko@novek.ru>
References: <20210720203529.21601-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The case of ESP in UDP encapsulation was not covered before. Add
cases of local changes of MTU and difference on routed path.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/nettest.c |  55 ++++++-
 tools/testing/selftests/net/pmtu.sh   | 212 +++++++++++++++++++++++++-
 2 files changed, 260 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 6365c7fd1262..bd6288302094 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -11,9 +11,11 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <linux/tcp.h>
+#include <linux/udp.h>
 #include <arpa/inet.h>
 #include <net/if.h>
 #include <netinet/in.h>
+#include <netinet/ip.h>
 #include <netdb.h>
 #include <fcntl.h>
 #include <libgen.h>
@@ -27,6 +29,10 @@
 #include <time.h>
 #include <errno.h>
 
+#include <linux/xfrm.h>
+#include <linux/ipsec.h>
+#include <linux/pfkeyv2.h>
+
 #ifndef IPV6_UNICAST_IF
 #define IPV6_UNICAST_IF         76
 #endif
@@ -114,6 +120,9 @@ struct sock_args {
 		struct in_addr  in;
 		struct in6_addr in6;
 	} expected_raddr;
+
+	/* ESP in UDP encap test */
+	int use_xfrm;
 };
 
 static int server_mode;
@@ -1346,6 +1355,41 @@ static int bind_socket(int sd, struct sock_args *args)
 	return 0;
 }
 
+static int config_xfrm_policy(int sd, struct sock_args *args)
+{
+	struct xfrm_userpolicy_info policy = {};
+	int type = UDP_ENCAP_ESPINUDP;
+	int xfrm_af = IP_XFRM_POLICY;
+	int level = SOL_IP;
+
+	if (args->type != SOCK_DGRAM) {
+		log_error("Invalid socket type. Only DGRAM could be used for XFRM\n");
+		return 1;
+	}
+
+	policy.action = XFRM_POLICY_ALLOW;
+	policy.sel.family = args->version;
+	if (args->version == AF_INET6) {
+		xfrm_af = IPV6_XFRM_POLICY;
+		level = SOL_IPV6;
+	}
+
+	policy.dir = XFRM_POLICY_OUT;
+	if (setsockopt(sd, level, xfrm_af, &policy, sizeof(policy)) < 0)
+		return 1;
+
+	policy.dir = XFRM_POLICY_IN;
+	if (setsockopt(sd, level, xfrm_af, &policy, sizeof(policy)) < 0)
+		return 1;
+
+	if (setsockopt(sd, IPPROTO_UDP, UDP_ENCAP, &type, sizeof(type)) < 0) {
+		log_err_errno("Failed to set xfrm encap");
+		return 1;
+	}
+
+	return 0;
+}
+
 static int lsock_init(struct sock_args *args)
 {
 	long flags;
@@ -1389,6 +1433,11 @@ static int lsock_init(struct sock_args *args)
 	if (fcntl(sd, F_SETFD, FD_CLOEXEC) < 0)
 		log_err_errno("Failed to set close-on-exec flag");
 
+	if (args->use_xfrm && config_xfrm_policy(sd, args)) {
+		log_err_errno("Failed to set xfrm policy");
+		goto err;
+	}
+
 out:
 	return sd;
 
@@ -1772,7 +1821,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6L:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1795,6 +1844,7 @@ static void print_usage(char *prog)
 	"    -D|R          datagram (D) / raw (R) socket (default stream)\n"
 	"    -l addr       local address to bind to in server mode\n"
 	"    -c addr       local address to bind to in client mode\n"
+	"    -x            configure XFRM policy on socket\n"
 	"\n"
 	"    -d dev        bind socket to given device name\n"
 	"    -I dev        bind socket to given device name - server mode\n"
@@ -1966,6 +2016,9 @@ int main(int argc, char *argv[])
 		case 'q':
 			quiet = 1;
 			break;
+		case 'x':
+			args.use_xfrm = 1;
+			break;
 		default:
 			print_usage(argv[0]);
 			return 1;
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 64cd2e23c568..ac67bd78081a 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -118,6 +118,16 @@
 #	below for IPv6 doesn't apply here, because, on IPv4, administrative MTU
 #	changes alone won't affect PMTU
 #
+# - pmtu_vti4_udp_exception
+#       Same as pmtu_vti4_exception, but using ESP-in-UDP
+#
+# - pmtu_vti4_udp_routed_exception
+#       Set up vti tunnel on top of veth connected through routing namespace and
+#	add xfrm states and policies with ESP-in-UDP encapsulation. Check that
+#	route exception is not created if link layer MTU is not exceeded, then
+#	lower MTU on second part of routed environment and check that exception
+#	is created with the expected PMTU.
+#
 # - pmtu_vti6_exception
 #	Set up vti6 tunnel on top of veth, with xfrm states and policies, in two
 #	namespaces with matching endpoints. Check that route exception is
@@ -125,6 +135,13 @@
 #	decrease and increase MTU of tunnel, checking that route exception PMTU
 #	changes accordingly
 #
+# - pmtu_vti6_udp_exception
+#       Same as pmtu_vti6_exception, but using ESP-in-UDP
+#
+# - pmtu_vti6_udp_routed_exception
+#	Same as pmtu_vti6_udp_routed_exception but with routing between vti
+#	endpoints
+#
 # - pmtu_vti4_default_mtu
 #	Set up vti4 tunnel on top of veth, in two namespaces with matching
 #	endpoints. Check that MTU assigned to vti interface is the MTU of the
@@ -224,6 +241,10 @@ tests="
 	pmtu_ipv6_ipv6_exception	IPv6 over IPv6: PMTU exceptions		1
 	pmtu_vti6_exception		vti6: PMTU exceptions			0
 	pmtu_vti4_exception		vti4: PMTU exceptions			0
+	pmtu_vti6_udp_exception		vti6: PMTU exceptions (ESP-in-UDP)	0
+	pmtu_vti4_udp_exception		vti4: PMTU exceptions (ESP-in-UDP)	0
+	pmtu_vti6_udp_routed_exception	vti6: PMTU exceptions, routed (ESP-in-UDP)	0
+	pmtu_vti4_udp_routed_exception	vti4: PMTU exceptions, routed (ESP-in-UDP)	0
 	pmtu_vti4_default_mtu		vti4: default MTU assignment		0
 	pmtu_vti6_default_mtu		vti6: default MTU assignment		0
 	pmtu_vti4_link_add_mtu		vti4: MTU setting on link creation	0
@@ -246,7 +267,6 @@ ns_b="ip netns exec ${NS_B}"
 ns_c="ip netns exec ${NS_C}"
 ns_r1="ip netns exec ${NS_R1}"
 ns_r2="ip netns exec ${NS_R2}"
-
 # Addressing and routing for tests with routers: four network segments, with
 # index SEGMENT between 1 and 4, a common prefix (PREFIX4 or PREFIX6) and an
 # identifier ID, which is 1 for hosts (A and B), 2 for routers (R1 and R2).
@@ -279,7 +299,6 @@ routes="
 	A	${prefix6}:${b_r2}::1	${prefix6}:${a_r2}::2
 	B	default			${prefix6}:${b_r1}::2
 "
-
 USE_NH="no"
 #	ns	family	nh id	   destination		gateway
 nexthops="
@@ -326,6 +345,7 @@ dummy6_mask="64"
 
 err_buf=
 tcpdump_pids=
+nettest_pids=
 
 err() {
 	err_buf="${err_buf}${1}
@@ -548,6 +568,14 @@ setup_vti6() {
 	setup_vti 6 ${veth6_a_addr} ${veth6_b_addr} ${tunnel6_a_addr} ${tunnel6_b_addr} ${tunnel6_mask}
 }
 
+setup_vti4routed() {
+	setup_vti 4 ${prefix4}.${a_r1}.1 ${prefix4}.${b_r1}.1 ${tunnel4_a_addr} ${tunnel4_b_addr} ${tunnel4_mask}
+}
+
+setup_vti6routed() {
+	setup_vti 6 ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 ${tunnel6_a_addr} ${tunnel6_b_addr} ${tunnel6_mask}
+}
+
 setup_vxlan_or_geneve() {
 	type="${1}"
 	a_addr="${2}"
@@ -619,18 +647,36 @@ setup_xfrm() {
 	proto=${1}
 	veth_a_addr="${2}"
 	veth_b_addr="${3}"
+	encap=${4}
 
-	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel || return 1
-	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel ${encap} || return 1
+	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel ${encap}
 	run_cmd ${ns_a} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel
 	run_cmd ${ns_a} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel
 
-	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
-	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel ${encap}
+	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel ${encap}
 	run_cmd ${ns_b} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel
 	run_cmd ${ns_b} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel
 }
 
+setup_nettest_xfrm() {
+	which nettest >/dev/null
+	if [ $? -ne 0 ]; then
+        	echo "'nettest' command not found; skipping tests"
+	        return 1
+	fi
+
+	[ ${1} -eq 6 ] && proto="-6" || proto=""
+	port=${2}
+
+	run_cmd ${ns_a} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	nettest_pids="${nettest_pids} $!"
+
+	run_cmd ${ns_b} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	nettest_pids="${nettest_pids} $!"
+}
+
 setup_xfrm4() {
 	setup_xfrm 4 ${veth4_a_addr} ${veth4_b_addr}
 }
@@ -639,6 +685,26 @@ setup_xfrm6() {
 	setup_xfrm 6 ${veth6_a_addr} ${veth6_b_addr}
 }
 
+setup_xfrm4udp() {
+	setup_xfrm 4 ${veth4_a_addr} ${veth4_b_addr} "encap espinudp 4500 4500 0.0.0.0"
+	setup_nettest_xfrm 4 4500
+}
+
+setup_xfrm6udp() {
+	setup_xfrm 6 ${veth6_a_addr} ${veth6_b_addr} "encap espinudp 4500 4500 0.0.0.0"
+	setup_nettest_xfrm 6 4500
+}
+
+setup_xfrm4udprouted() {
+	setup_xfrm 4 ${prefix4}.${a_r1}.1 ${prefix4}.${b_r1}.1 "encap espinudp 4500 4500 0.0.0.0"
+	setup_nettest_xfrm 4 4500
+}
+
+setup_xfrm6udprouted() {
+	setup_xfrm 6 ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 "encap espinudp 4500 4500 0.0.0.0"
+	setup_nettest_xfrm 6 4500
+}
+
 setup_routing_old() {
 	for i in ${routes}; do
 		[ "${ns}" = "" ]	&& ns="${i}"		&& continue
@@ -823,6 +889,11 @@ cleanup() {
 	done
 	tcpdump_pids=
 
+	for pid in ${nettest_pids}; do
+		kill ${pid}
+	done
+	nettest_pids=
+
 	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
 		ip netns del ${n} 2> /dev/null
 	done
@@ -1432,6 +1503,135 @@ test_pmtu_vti6_exception() {
 	return ${fail}
 }
 
+test_pmtu_vti4_udp_exception() {
+	setup namespaces veth vti4 xfrm4udp || return $ksft_skip
+	trace "${ns_a}" veth_a    "${ns_b}" veth_b \
+	      "${ns_a}" vti4_a    "${ns_b}" vti4_b
+
+	veth_mtu=1500
+	vti_mtu=$((veth_mtu - 20))
+
+	#                                UDP   SPI   SN   IV  ICV   pad length   next header
+	esp_payload_rfc4106=$((vti_mtu - 8   - 4   - 4  - 8 - 16  - 1          - 1))
+	ping_payload=$((esp_payload_rfc4106 - 28))
+
+	mtu "${ns_a}" veth_a ${veth_mtu}
+	mtu "${ns_b}" veth_b ${veth_mtu}
+	mtu "${ns_a}" vti4_a ${vti_mtu}
+	mtu "${ns_b}" vti4_b ${vti_mtu}
+
+	# Send DF packet without exceeding link layer MTU, check that no
+	# exception is created
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s ${ping_payload} ${tunnel4_b_addr}
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel4_b_addr})"
+	check_pmtu_value "" "${pmtu}" "sending packet smaller than PMTU (IP payload length ${esp_payload_rfc4106})" || return 1
+
+	# Now exceed link layer MTU by one byte, check that exception is created
+	# with the right PMTU value
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s $((ping_payload + 1)) ${tunnel4_b_addr}
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel4_b_addr})"
+	check_pmtu_value "${esp_payload_rfc4106}" "${pmtu}" "exceeding PMTU (IP payload length $((esp_payload_rfc4106 + 1)))"
+}
+
+test_pmtu_vti6_udp_exception() {
+	setup namespaces veth vti6 xfrm6udp || return $ksft_skip
+	trace "${ns_a}" veth_a    "${ns_b}" veth_b \
+	      "${ns_a}" vti6_a    "${ns_b}" vti6_b
+	fail=0
+
+	# Create route exception by exceeding link layer MTU
+	mtu "${ns_a}" veth_a 4000
+	mtu "${ns_b}" veth_b 4000
+	mtu "${ns_a}" vti6_a 5000
+	mtu "${ns_b}" vti6_b 5000
+	run_cmd ${ns_a} ${ping6} -q -i 0.1 -w 1 -s 60000 ${tunnel6_b_addr}
+
+	# Check that exception was created
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
+	check_pmtu_value any "${pmtu}" "creating tunnel exceeding link layer MTU" || return 1
+
+	# Decrease tunnel MTU, check for PMTU decrease in route exception
+	mtu "${ns_a}" vti6_a 3000
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
+	check_pmtu_value "3000" "${pmtu}" "decreasing tunnel MTU" || fail=1
+
+	# Increase tunnel MTU, check for PMTU increase in route exception
+	mtu "${ns_a}" vti6_a 9000
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
+	check_pmtu_value "9000" "${pmtu}" "increasing tunnel MTU" || fail=1
+
+	return ${fail}
+}
+
+test_pmtu_vti4_udp_routed_exception() {
+	setup namespaces routing vti4routed xfrm4udprouted || return $ksft_skip
+	trace "${ns_a}" veth_A-R1    "${ns_b}" veth_B-R1 \
+	      "${ns_a}" vti4_a       "${ns_b}" vti4_b
+
+	veth_mtu=1500
+	vti_mtu=$((veth_mtu - 20))
+
+	#                                UDP   SPI   SN   IV  ICV   pad length   next header
+	esp_payload_rfc4106=$((vti_mtu - 8   - 4   - 4  - 8 - 16  - 1          - 1))
+	ping_payload=$((esp_payload_rfc4106 - 28))
+
+        mtu "${ns_a}"  veth_A-R1 ${veth_mtu}
+        mtu "${ns_r1}" veth_R1-A ${veth_mtu}
+        mtu "${ns_b}"  veth_B-R1 ${veth_mtu}
+        mtu "${ns_r1}" veth_R1-B ${veth_mtu}
+
+	mtu "${ns_a}" vti4_a ${vti_mtu}
+	mtu "${ns_b}" vti4_b ${vti_mtu}
+
+	# Send DF packet without exceeding link layer MTU, check that no
+	# exception is created
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s ${ping_payload} ${tunnel4_b_addr}
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel4_b_addr})"
+	check_pmtu_value "" "${pmtu}" "sending packet smaller than PMTU (IP payload length ${esp_payload_rfc4106})" || return 1
+
+	# Now decrease link layer MTU by 8 bytes on R1, check that exception is created
+	# with the right PMTU value
+        mtu "${ns_r1}" veth_R1-B $((veth_mtu - 8))
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s $((ping_payload)) ${tunnel4_b_addr}
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel4_b_addr})"
+	check_pmtu_value "$((esp_payload_rfc4106 - 8))" "${pmtu}" "exceeding PMTU (IP payload length $((esp_payload_rfc4106)))"
+}
+
+test_pmtu_vti6_udp_routed_exception() {
+	setup namespaces routing vti6routed xfrm6udprouted || return $ksft_skip
+	trace "${ns_a}" veth_A-R1    "${ns_b}" veth_B-R1 \
+	      "${ns_a}" vti6_a       "${ns_b}" vti6_b
+
+	veth_mtu=1500
+	vti_mtu=$((veth_mtu - 40))
+
+	#                                UDP   SPI   SN   IV  ICV   pad length   next header
+	esp_payload_rfc4106=$((vti_mtu - 8   - 4   - 4  - 8 - 16  - 1          - 1))
+	ping_payload=$((esp_payload_rfc4106 - 48))
+
+        mtu "${ns_a}"  veth_A-R1 ${veth_mtu}
+        mtu "${ns_r1}" veth_R1-A ${veth_mtu}
+        mtu "${ns_b}"  veth_B-R1 ${veth_mtu}
+        mtu "${ns_r1}" veth_R1-B ${veth_mtu}
+
+	# mtu "${ns_a}" vti6_a ${vti_mtu}
+	# mtu "${ns_b}" vti6_b ${vti_mtu}
+
+	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s ${ping_payload} ${tunnel6_b_addr}
+
+	# Check that exception was not created
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
+	check_pmtu_value "" "${pmtu}" "sending packet smaller than PMTU (IP payload length ${esp_payload_rfc4106})" || return 1
+
+	# Now decrease link layer MTU by 8 bytes on R1, check that exception is created
+	# with the right PMTU value
+        mtu "${ns_r1}" veth_R1-B $((veth_mtu - 8))
+	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s $((ping_payload)) ${tunnel6_b_addr}
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
+	check_pmtu_value "$((esp_payload_rfc4106 - 8))" "${pmtu}" "exceeding PMTU (IP payload length $((esp_payload_rfc4106)))"
+
+}
+
 test_pmtu_vti4_default_mtu() {
 	setup namespaces veth vti4 || return $ksft_skip
 
-- 
2.18.4

