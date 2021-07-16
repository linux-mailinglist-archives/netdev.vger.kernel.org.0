Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ECF3CB9F0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhGPPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241030AbhGPPhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626449691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DH5o6Gy07+ISJ8mJy7cF3/v/pLE4+r8Hp1B8hJOsk18=;
        b=SgQCKlzWykJl5sHXgpq+quvFozKpkW+krl8RQXKKZMDSUfVHNPGmmH8uNPGkv1GDTLwtuw
        tWk7sD79IYYwS/mtKGwEw9JHT8oAMzPTNd7AJd1Bph4oFc8wwAgxDvIAgDHQXhuz0qg3yh
        lFreNl7BtLKPdvYU1izyOUKDBg3RB1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-YpFHf-INMSmdJay07BAQqQ-1; Fri, 16 Jul 2021 11:34:50 -0400
X-MC-Unique: YpFHf-INMSmdJay07BAQqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E92091275;
        Fri, 16 Jul 2021 15:34:49 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-207.ams2.redhat.com [10.36.113.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B85245C1A1;
        Fri, 16 Jul 2021 15:34:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH RFC v2 5/5] selftests: net: veth: add tests for set_channel
Date:   Fri, 16 Jul 2021 17:34:23 +0200
Message-Id: <c64b3d4dacea2aa2035bdbb5f15cfa681a8b911a.1626449533.git.pabeni@redhat.com>
In-Reply-To: <cover.1626449533.git.pabeni@redhat.com>
References: <cover.1626449533.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple functional test for the newly exposed features.

Also add an optional stress test for the channel number
update under flood.

RFC v1 -> RFC v2:
 - add the stress test

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/veth.sh | 183 +++++++++++++++++++++++++++-
 1 file changed, 182 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 11d7cdb898c0..19eac3e44c06 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -13,7 +13,7 @@ readonly NS_DST=$BASE$DST
 readonly BM_NET_V4=192.168.1.
 readonly BM_NET_V6=2001:db8::
 
-readonly NPROCS=`nproc`
+readonly CPUS=`nproc`
 ret=0
 
 cleanup() {
@@ -75,6 +75,29 @@ chk_tso_flag() {
 	__chk_flag "$1" $2 $3 tcp-segmentation-offload
 }
 
+chk_channels() {
+	local msg="$1"
+	local target=$2
+	local rx=$3
+	local tx=$4
+
+	local dev=veth$target
+
+	local cur_rx=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep RX: | tail -n 1 | awk '{print $2}' `
+		local cur_tx=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep TX: | tail -n 1 | awk '{print $2}'`
+	local cur_combined=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep Combined: | tail -n 1 | awk '{print $2}'`
+
+	printf "%-60s" "$msg"
+	if [ "$cur_rx" = "$rx" -a "$cur_tx" = "$tx" -a "$cur_combined" = "n/a" ]; then
+		echo " ok "
+	else
+		echo " fail rx:$rx:$cur_rx tx:$tx:$cur_tx combined:n/a:$cur_combined"
+	fi
+}
+
 chk_gro() {
 	local msg="$1"
 	local expected=$2
@@ -107,11 +130,100 @@ chk_gro() {
 	fi
 }
 
+__change_channels()
+{
+	local cur_cpu
+	local end=$1
+	local cur
+	local i
+
+	while true; do
+		printf -v cur '%(%s)T'
+		[ $cur -le $end ] || break
+
+		for i in `seq 1 $CPUS`; do
+			ip netns exec $NS_SRC ethtool -L veth$SRC rx $i tx $i
+			ip netns exec $NS_DST ethtool -L veth$DST rx $i tx $i
+		done
+
+		for i in `seq 1 $((CPUS - 1))`; do
+			cur_cpu=$((CPUS - $i))
+			ip netns exec $NS_SRC ethtool -L veth$SRC rx $cur_cpu tx $cur_cpu
+			ip netns exec $NS_DST ethtool -L veth$DST rx $cur_cpu tx $cur_cpu
+		done
+	done
+}
+
+__send_data() {
+	local end=$1
+
+	while true; do
+		printf -v cur '%(%s)T'
+		[ $cur -le $end ] || break
+
+		ip netns exec $NS_SRC ./udpgso_bench_tx -4 -s 1000 -M 300 -D $BM_NET_V4$DST
+	done
+}
+
+do_stress() {
+	local end
+	printf -v end '%(%s)T'
+	end=$((end + $STRESS))
+
+	ip netns exec $NS_SRC ethtool -L veth$SRC rx 3 tx 3
+	ip netns exec $NS_DST ethtool -L veth$DST rx 3 tx 3
+
+	ip netns exec $NS_DST ./udpgso_bench_rx &
+	local rx_pid=$!
+
+	echo "Running stress test for $STRESS seconds..."
+	__change_channels $end &
+	local ch_pid=$!
+	__send_data $end &
+	local data_pid_1=$!
+	__send_data $end &
+	local data_pid_2=$!
+	__send_data $end &
+	local data_pid_3=$!
+	__send_data $end &
+	local data_pid_4=$!
+
+	wait $ch_pid $data_pid_1 $data_pid_2 $data_pid_3 $data_pid_4
+	kill -9 $rx_pid
+	echo "done"
+
+	# restore previous setting
+	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2 tx 2
+	ip netns exec $NS_DST ethtool -L veth$DST rx 2 tx 1
+}
+
+usage() {
+	echo "Usage: $0 [-h] [-s <seconds>]"
+	echo -e "\t-h: show this help"
+	echo -e "\t-s: run optional stress tests for the given amount of seconds"
+}
+
+STRESS=0
+while getopts "hs:" option; do
+	case "$option" in
+	"h")
+		usage $0
+		exit 0
+		;;
+	"s")
+		STRESS=$OPTARG
+		;;
+	esac
+done
+
 if [ ! -f ../bpf/xdp_dummy.o ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
 	exit 1
 fi
 
+[ $CPUS -lt 2 ] && echo "Only one CPU available, some tests will be skipped"
+[ $STRESS -gt 0 -a $CPUS -lt 3 ] && echo " stress test will be skipped, too"
+
 create_ns
 chk_gro_flag "default - gro flag" $SRC off
 chk_gro_flag "        - peer gro flag" $DST off
@@ -134,6 +246,8 @@ chk_gro "        - aggregation with TSO off" 1
 cleanup
 
 create_ns
+chk_channels "default channels" $DST 1 1
+
 ip -n $NS_DST link set dev veth$DST down
 ip netns exec $NS_DST ethtool -K veth$DST gro on
 chk_gro_flag "with gro enabled on link down - gro flag" $DST on
@@ -147,6 +261,56 @@ chk_gro "        - aggregation with TSO off" 1
 cleanup
 
 create_ns
+
+CUR_TX=1
+CUR_RX=1
+if [ $CPUS -gt 1 ]; then
+	ip netns exec $NS_DST ethtool -L veth$DST tx 2
+	chk_channels "setting tx channels" $DST 1 2
+	CUR_TX=2
+fi
+
+if [ $CPUS -gt 2 ]; then
+	ip netns exec $NS_DST ethtool -L veth$DST rx 3 tx 3
+	chk_channels "setting both rx and tx channels" $DST 3 3
+	CUR_RX=3
+	CUR_TX=3
+fi
+
+ip netns exec $NS_DST ethtool -L veth$DST combined 2 2>/dev/null
+chk_channels "bad setting: combined channels" $DST $CUR_RX $CUR_TX
+
+ip netns exec $NS_DST ethtool -L veth$DST tx $((CPUS + 1)) 2>/dev/null
+chk_channels "setting invalid channels nr" $DST $CUR_RX $CUR_TX
+
+if [ $CPUS -gt 1 ]; then
+	# this also tests queues nr reduction
+	ip netns exec $NS_DST ethtool -L veth$DST rx 1 tx 2 2>/dev/null
+	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
+	printf "%-60s" "bad setting: XDP with RX nr less than TX"
+	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
+		section xdp_dummy 2>/dev/null &&\
+		echo "fail - set operation successful ?!?" || echo " ok "
+
+	# the following tests will run with multiple channels active
+	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
+	ip netns exec $NS_DST ethtool -L veth$DST rx 2
+	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
+		section xdp_dummy 2>/dev/null
+	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
+	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
+		echo "fail - set operation successful ?!?" || echo " ok "
+	CUR_RX=2
+	CUR_TX=2
+fi
+
+if [ $CPUS -gt 2 ]; then
+	printf "%-60s" "bad setting: increasing peer TX nr above RX with XDP set"
+	ip netns exec $NS_SRC ethtool -L veth$SRC tx 3 2>/dev/null &&\
+		echo "fail - set operation successful ?!?" || echo " ok "
+	chk_channels "setting invalid channels nr" $DST 2 2
+fi
+
 ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
@@ -167,10 +331,27 @@ chk_gro_flag "        - after gro on xdp off, gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC on
 chk_tso_flag "        - peer tso flag" $DST on
+
+if [ $CPUS -gt 1 ]; then
+	ip netns exec $NS_DST ethtool -L veth$DST tx 1
+	chk_channels "decreasing tx channels with device down" $DST 2 1
+fi
+
 ip -n $NS_DST link set dev veth$DST up
 ip -n $NS_SRC link set dev veth$SRC up
 chk_gro "        - aggregation" 1
 
+if [ $CPUS -gt 1 ]; then
+	[ $STRESS -gt 0 -a $CPUS -gt 2 ] && do_stress
+
+	ip -n $NS_DST link set dev veth$DST down
+	ip -n $NS_SRC link set dev veth$SRC down
+	ip netns exec $NS_DST ethtool -L veth$DST tx 2
+	chk_channels "increasing tx channels with device down" $DST 2 2
+	ip -n $NS_DST link set dev veth$DST up
+	ip -n $NS_SRC link set dev veth$SRC up
+fi
+
 ip netns exec $NS_DST ethtool -K veth$DST gro off
 ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
 chk_gro "aggregation again with default and TSO off" 10
-- 
2.26.3

