Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F329234E57A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhC3Kah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231675AbhC3KaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PberHQMAvfU4E/HK2k75gIUNfGRz91QL/7sCifINyWo=;
        b=RVp9nLswu1Uf3N2dHD+G8R21lhEpT0gVZXUiR9HNQiEjJX98ettxbnK1oFi6EN0N/QZMxa
        XFkQT9CpNJ22hFpwVTvGDx4R22tdmrZGeQ9V3/f7Y45Gq6k/jvF0xGTvIrPGlUH6iyJNaV
        S8tVZStf9YOWI6dP58eGQfFNc3OUxK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-DdOpqOnnMBe_JlM1z7wByw-1; Tue, 30 Mar 2021 06:30:02 -0400
X-MC-Unique: DdOpqOnnMBe_JlM1z7wByw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DE6881433D;
        Tue, 30 Mar 2021 10:30:01 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 804D419C45;
        Tue, 30 Mar 2021 10:29:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 8/8] selftests: net: add UDP GRO forwarding self-tests
Date:   Tue, 30 Mar 2021 12:28:56 +0200
Message-Id: <9de587fd719db1cc318ee76cd7465ba8ca00c7cd.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a bunch of virtual topologies and verify that
NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_UDP_FWD-enabled
devices aggregate the ingress packets as expected.
Additionally check that the aggregate packets are
segmented correctly when landing on a socket

Also test SKB_GSO_FRAGLIST and SKB_GSO_UDP_L4 aggregation
on top of UDP tunnel (vxlan)

v1 -> v2:
 - hopefully clarify the commit message
 - moved the overlay network ipv6 range into the 'documentation'
   reserved range (Willem)

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
index 0000000000000..a8fa641362828
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
+readonly OL_NET_V6=2001:db8:1::
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

