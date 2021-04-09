Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6032359C9D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhDILFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:05:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233839AbhDILFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617966300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j09Iq4gBy1PlKj39HRZLlpuevLwebALCZPqy1x3QnxY=;
        b=dh9qrLnkf+gdMZJtpGHJwfpg0onKoLEVRDfnuzES9KdVtXluObzOuDYkSwy5CaMYtoQPP4
        +h5q3bqC/dnVw5k2p3RFtSc/pw6axapZdfqryApwtPYkJ10O0PP9ZtW66EZ9GYMHlgj4zm
        CfG+qLJUaX+crSLEhzgoYvx7ATGlc3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-siAw2uoSM6qC2VpwxotJ-g-1; Fri, 09 Apr 2021 07:04:57 -0400
X-MC-Unique: siAw2uoSM6qC2VpwxotJ-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E442B107ACCA;
        Fri,  9 Apr 2021 11:04:56 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24F8F10023BE;
        Fri,  9 Apr 2021 11:04:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 4/4] self-tests: add veth tests
Date:   Fri,  9 Apr 2021 13:04:40 +0200
Message-Id: <1eb0fdb47388767021aea5e2a3822ff12f80aa1c.1617965243.git.pabeni@redhat.com>
In-Reply-To: <cover.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some basic veth tests, that verify the expected flags and
aggregation with different setups (default, xdp, etc...)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile |   1 +
 tools/testing/selftests/net/veth.sh  | 177 +++++++++++++++++++++++++++
 2 files changed, 178 insertions(+)
 create mode 100755 tools/testing/selftests/net/veth.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 2d71b283dde36..f4242a9610883 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -24,6 +24,7 @@ TEST_PROGS += vrf_route_leaking.sh
 TEST_PROGS += bareudp.sh
 TEST_PROGS += unicast_extensions.sh
 TEST_PROGS += udpgro_fwd.sh
+TEST_PROGS += veth.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
new file mode 100755
index 0000000000000..2fedc0781ce8c
--- /dev/null
+++ b/tools/testing/selftests/net/veth.sh
@@ -0,0 +1,177 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+readonly STATS="$(mktemp -p /tmp ns-XXXXXX)"
+readonly BASE=`basename $STATS`
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
+readonly NPROCS=`nproc`
+ret=0
+
+cleanup() {
+	local ns
+	local -r jobs="$(jobs -p)"
+	[ -n "${jobs}" ] && kill -1 ${jobs} 2>/dev/null
+	rm -f $STATS
+
+	for ns in $NS_SRC $NS_DST; do
+		ip netns del $ns 2>/dev/null
+	done
+}
+
+trap cleanup EXIT
+
+create_ns() {
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
+		ip link set dev veth$ns netns $BASE$ns up
+		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
+		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
+	done
+	echo "#kernel" > $BASE
+	chmod go-rw $BASE
+}
+
+__chk_flag() {
+	local msg="$1"
+	local target=$2
+	local expected=$3
+	local flagname=$4
+
+	local flag=`ip netns exec $BASE$target ethtool -k veth$target |\
+		    grep $flagname | awk '{print $2}'`
+
+	printf "%-60s" "$msg"
+	if [ "$flag" = "$expected" ]; then
+		echo " ok "
+	else
+		echo " fail - expected $expected found $flag"
+		ret=1
+	fi
+}
+
+chk_gro_flag() {
+	__chk_flag "$1" $2 $3 generic-receive-offload
+}
+
+chk_tso_flag() {
+	__chk_flag "$1" $2 $3 tcp-segmentation-offload
+}
+
+chk_gro() {
+	local msg="$1"
+	local expected=$2
+
+	ip netns exec $BASE$SRC ping -qc 1 $BM_NET_V4$DST >/dev/null
+	NSTAT_HISTORY=$STATS ip netns exec $NS_DST nstat -n
+
+	printf "%-60s" "$msg"
+	ip netns exec $BASE$DST ./udpgso_bench_rx -C 1000 -R 10 &
+	local spid=$!
+	sleep 0.1
+
+	ip netns exec $NS_SRC ./udpgso_bench_tx -4 -s 13000 -S 1300 -M 1 -D $BM_NET_V4$DST
+	local retc=$?
+	wait $spid
+	local rets=$?
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo " fail client exit code $retc, server $rets"
+		ret=1
+		return
+	fi
+
+	local pkts=`NSTAT_HISTORY=$STATS ip netns exec $NS_DST nstat IpInReceives | \
+		    awk '{print $2}' | tail -n 1`
+	if [ "$pkts" = "$expected" ]; then
+		echo " ok "
+	else
+		echo " fail - got $pkts packets, expected $expected "
+		ret=1
+	fi
+}
+
+if [ ! -f ../bpf/xdp_dummy.o ]; then
+	echo "Missing xdp_dummy helper. Build bpf selftest first"
+	exit -1
+fi
+
+create_ns
+chk_gro_flag "default - gro flag" $SRC off
+chk_gro_flag "        - peer gro flag" $DST off
+chk_tso_flag "        - tso flag" $SRC on
+chk_tso_flag "        - peer tso flag" $DST on
+chk_gro "        - aggregation" 1
+ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
+chk_gro "        - aggregation with TSO off" 10
+cleanup
+
+create_ns
+ip netns exec $NS_DST ethtool -K veth$DST gro on
+chk_gro_flag "with gro on - gro flag" $DST on
+chk_gro_flag "        - peer gro flag" $SRC off
+chk_tso_flag "        - tso flag" $SRC on
+chk_tso_flag "        - peer tso flag" $DST on
+ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
+ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+chk_gro "        - aggregation with TSO off" 1
+cleanup
+
+create_ns
+ip -n $NS_DST link set dev veth$DST down
+ip netns exec $NS_DST ethtool -K veth$DST gro on
+chk_gro_flag "with gro enabled on link down - gro flag" $DST on
+chk_gro_flag "        - peer gro flag" $SRC off
+chk_tso_flag "        - tso flag" $SRC on
+chk_tso_flag "        - peer tso flag" $DST on
+ip -n $NS_DST link set dev veth$DST up
+ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
+ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+chk_gro "        - aggregation with TSO off" 1
+cleanup
+
+create_ns
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+chk_gro_flag "with xdp attached - gro flag" $DST on
+chk_gro_flag "        - peer gro flag" $SRC off
+chk_tso_flag "        - tso flag" $SRC off
+chk_tso_flag "        - peer tso flag" $DST on
+ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
+chk_gro "        - aggregation" 1
+
+
+ip -n $NS_DST link set dev veth$DST down
+ip -n $NS_SRC link set dev veth$SRC down
+chk_gro_flag "        - after dev off, flag" $DST on
+chk_gro_flag "        - peer flag" $SRC off
+
+ip netns exec $NS_DST ethtool -K veth$DST gro on
+ip -n $NS_DST link set dev veth$DST xdp off
+chk_gro_flag "        - after gro on xdp off, gro flag" $DST on
+chk_gro_flag "        - peer gro flag" $SRC off
+chk_tso_flag "        - tso flag" $SRC on
+chk_tso_flag "        - peer tso flag" $DST on
+ip -n $NS_DST link set dev veth$DST up
+ip -n $NS_SRC link set dev veth$SRC up
+chk_gro "        - aggregation" 1
+
+ip netns exec $NS_DST ethtool -K veth$DST gro off
+ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
+chk_gro "aggregation again with default and TSO off" 10
+
+exit $ret
-- 
2.26.2

