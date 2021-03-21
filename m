Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10062343396
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhCURCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230167AbhCURCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OxuqBGC5Xb3P4PhL9Z7K4kE6Xz95k+iv+MUHTIkw9Ik=;
        b=CKHUfVM49h02N6o9oC3JMcim/qLYs+XhMpllTb5yKro6bPkdeku9my5dPBXGGZqOepnMSu
        PqWMMUWu8K/7OvfcfjCfiYlcjFFx4ioJzngCv0pYsAZFbq15K0/kzroiWYVjsDWkz9xcLZ
        ECVsjov/pfD+oE6URgvqExEpYwN/oi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-YbglT8ySO4WTpvmtnkUJqQ-1; Sun, 21 Mar 2021 13:01:59 -0400
X-MC-Unique: YbglT8ySO4WTpvmtnkUJqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B50180FCA7;
        Sun, 21 Mar 2021 17:01:57 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 623475D6B1;
        Sun, 21 Mar 2021 17:01:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 8/8] selftests: net: add UDP GRO forwarding self-tests
Date:   Sun, 21 Mar 2021 18:01:19 +0100
Message-Id: <a9791dcc26e3f70858eee5d14506f8b36e747960.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

create a bunch of virtual topology and verify that
GRO_FRAG_LIST and GRO_FWD aggregate the ingress
packets as expected, and the aggregate packets
are segmented correctly when landing on a socket

Also test L4 aggregation on top of UDP tunnel (vxlan)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile      |   1 +
 tools/testing/selftests/net/udpgro_fwd.sh | 251 ++++++++++++++++++++++
 2 files changed, 252 insertions(+)
 create mode 100755 tools/testing/selftests/net/udpgro_fwd.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 25f198bec0b25..2d71b283dde36 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -23,6 +23,7 @@ TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS += vrf_route_leaking.sh
 TEST_PROGS += bareudp.sh
 TEST_PROGS += unicast_extensions.sh
+TEST_PROGS += udpgro_fwd.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
new file mode 100755
index 0000000000000..ac7ac56a27524
--- /dev/null
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -0,0 +1,251 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+readonly BASE="ns-$(mktemp -u XXXXXX)"
+readonly SRC=2
+readonly DST=1
+readonly DST_NAT=100
+readonly NS_SRC=$BASE$SRC
+readonly NS_DST=$BASE$DST
+
+# "baremetal" network used for raw UDP traffic
+readonly BM_NET_V4=192.168.1.
+readonly BM_NET_V6=2001:db8::
+
+# "overlay" network used for UDP over UDP tunnel traffic
+readonly OL_NET_V4=172.16.1.
+readonly OL_NET_V6=2002:db8::
+readonly NPROCS=`nproc`
+
+cleanup() {
+	local ns
+	local -r jobs="$(jobs -p)"
+	[ -n "${jobs}" ] && kill -1 ${jobs} 2>/dev/null
+
+	for ns in $NS_SRC $NS_DST; do
+		ip netns del $ns 2>/dev/null
+	done
+}
+
+trap cleanup EXIT
+
+create_ns() {
+	local net
+	local ns
+
+	for ns in $NS_SRC $NS_DST; do
+		ip netns add $ns
+		ip -n $ns link set dev lo up
+	done
+
+	ip link add name veth$SRC type veth peer name veth$DST
+
+	for ns in $SRC $DST; do
+		ip link set dev veth$ns netns $BASE$ns
+		ip -n $BASE$ns link set dev veth$ns up
+		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
+		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
+	done
+	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+}
+
+create_vxlan_endpoint() {
+	local -r netns=$1
+	local -r bm_dev=$2
+	local -r bm_rem_addr=$3
+	local -r vxlan_dev=$4
+	local -r vxlan_id=$5
+	local -r vxlan_port=4789
+
+	ip -n $netns link set dev $bm_dev up
+	ip -n $netns link add dev $vxlan_dev type vxlan id $vxlan_id \
+				dstport $vxlan_port remote $bm_rem_addr
+	ip -n $netns link set dev $vxlan_dev up
+}
+
+create_vxlan_pair() {
+	local ns
+
+	create_ns
+
+	for ns in $SRC $DST; do
+		# note that 3 - $SRC == $DST and 3 - $DST == $SRC
+		create_vxlan_endpoint $BASE$ns veth$ns $BM_NET_V4$((3 - $ns)) vxlan$ns 4
+		ip -n $BASE$ns addr add dev vxlan$ns $OL_NET_V4$ns/24
+	done
+	for ns in $SRC $DST; do
+		create_vxlan_endpoint $BASE$ns veth$ns $BM_NET_V6$((3 - $ns)) vxlan6$ns 6
+		ip -n $BASE$ns addr add dev vxlan6$ns $OL_NET_V6$ns/24 nodad
+	done
+}
+
+is_ipv6() {
+	if [[ $1 =~ .*:.* ]]; then
+		return 0
+	fi
+	return 1
+}
+
+run_test() {
+	local -r msg=$1
+	local -r dst=$2
+	local -r pkts=$3
+	local -r vxpkts=$4
+	local bind=$5
+	local rx_args=""
+	local rx_family="-4"
+	local family=-4
+	local filter=IpInReceives
+	local ipt=iptables
+
+	printf "%-40s" "$msg"
+
+	if is_ipv6 $dst; then
+		# rx program does not support '-6' and implies ipv6 usage by default
+		rx_family=""
+		family=-6
+		filter=Ip6InReceives
+		ipt=ip6tables
+	fi
+
+	rx_args="$rx_family"
+	[ -n "$bind" ] && rx_args="$rx_args -b $bind"
+
+	# send a single GSO packet, segmented in 10 UDP frames.
+	# Always expect 10 UDP frames on RX side as rx socket does
+	# not enable GRO
+	ip netns exec $NS_DST $ipt -A INPUT -p udp --dport 4789
+	ip netns exec $NS_DST $ipt -A INPUT -p udp --dport 8000
+	ip netns exec $NS_DST ./udpgso_bench_rx -C 1000 -R 10 -n 10 -l 1300 $rx_args &
+	local spid=$!
+	sleep 0.1
+	ip netns exec $NS_SRC ./udpgso_bench_tx $family -M 1 -s 13000 -S 1300 -D $dst
+	local retc=$?
+	wait $spid
+	local rets=$?
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo " fail client exit code $retc, server $rets"
+		ret=1
+		return
+	fi
+
+	local rcv=`ip netns exec $NS_DST $ipt"-save" -c | grep 'dport 8000' | \
+							  sed -e 's/\[//' -e 's/:.*//'`
+	if [ $rcv != $pkts ]; then
+		echo " fail - received $rvs packets, expected $pkts"
+		ret=1
+		return
+	fi
+
+	local vxrcv=`ip netns exec $NS_DST $ipt"-save" -c | grep 'dport 4789' | \
+							    sed -e 's/\[//' -e 's/:.*//'`
+
+	# upper net can generate a little noise, allow some tolerance
+	if [ $vxrcv -lt $vxpkts -o $vxrcv -gt $((vxpkts + 3)) ]; then
+		echo " fail - received $vxrcv vxlan packets, expected $vxpkts"
+		ret=1
+		return
+	fi
+	echo " ok"
+}
+
+run_bench() {
+	local -r msg=$1
+	local -r dst=$2
+	local family=-4
+
+	printf "%-40s" "$msg"
+	if [ $NPROCS -lt 2 ]; then
+		echo " skip - needed 2 CPUs found $NPROCS"
+		return
+	fi
+
+	is_ipv6 $dst && family=-6
+
+	# bind the sender and the receiver to different CPUs to try
+	# get reproducible results
+	ip netns exec $NS_DST bash -c "echo 2 > /sys/class/net/veth$DST/queues/rx-0/rps_cpus"
+	ip netns exec $NS_DST taskset 0x2 ./udpgso_bench_rx -C 1000 -R 10  &
+	local spid=$!
+	sleep 0.1
+	ip netns exec $NS_SRC taskset 0x1 ./udpgso_bench_tx $family -l 3 -S 1300 -D $dst
+	local retc=$?
+	wait $spid
+	local rets=$?
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo " fail client exit code $retc, server $rets"
+		ret=1
+		return
+	fi
+}
+
+for family in 4 6; do
+	BM_NET=$BM_NET_V4
+	OL_NET=$OL_NET_V4
+	IPT=iptables
+	SUFFIX=24
+	VXDEV=vxlan
+
+	if [ $family = 6 ]; then
+		BM_NET=$BM_NET_V6
+		OL_NET=$OL_NET_V6
+		SUFFIX="64 nodad"
+		VXDEV=vxlan6
+		IPT=ip6tables
+	fi
+
+	echo "IPv$family"
+
+	create_ns
+	run_test "No GRO" $BM_NET$DST 10 0
+	cleanup
+
+	create_ns
+	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
+	run_test "GRO frag list" $BM_NET$DST 1 0
+	cleanup
+
+	# UDP GRO fwd skips aggregation when find an udp socket with the GRO option
+	# if there is an UDP tunnel in the running system, such lookup happen
+	# take place.
+	# use NAT to circumvent GRO FWD check
+	create_ns
+	ip -n $NS_DST addr add dev veth$DST $BM_NET$DST_NAT/$SUFFIX
+	ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+	ip netns exec $NS_DST $IPT -t nat -I PREROUTING -d $BM_NET$DST_NAT \
+					-j DNAT --to-destination $BM_NET$DST
+	run_test "GRO fwd" $BM_NET$DST_NAT 1 0 $BM_NET$DST
+	cleanup
+
+	create_ns
+	run_bench "UDP fwd perf" $BM_NET$DST
+	ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+	run_bench "UDP GRO fwd perf" $BM_NET$DST
+	cleanup
+
+	create_vxlan_pair
+	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
+	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 1 1
+	cleanup
+
+	# use NAT to circumvent GRO FWD check
+	create_vxlan_pair
+	ip -n $NS_DST addr add dev $VXDEV$DST $OL_NET$DST_NAT/$SUFFIX
+	ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+	ip netns exec $NS_DST $IPT -t nat -I PREROUTING -d $OL_NET$DST_NAT \
+					-j DNAT --to-destination $OL_NET$DST
+
+	# load arp cache before running the test to reduce the amount of
+	# stray traffic on top of the UDP tunnel
+	ip netns exec $NS_SRC ping -q -c 1 $OL_NET$DST_NAT >/dev/null
+	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 1 1 $OL_NET$DST
+	cleanup
+
+	create_vxlan_pair
+	run_bench "UDP tunnel fwd perf" $OL_NET$DST
+	ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+	run_bench "UDP tunnel GRO fwd perf" $OL_NET$DST
+	cleanup
+done
+
+exit $ret
-- 
2.26.2

