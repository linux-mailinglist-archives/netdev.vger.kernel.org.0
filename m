Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2033D3C21B7
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhGIJns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:43:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231954AbhGIJnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 05:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625823664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWK+fkGO1BSGC/0eXaanXW3JGo/V+Biv7Cvpw/eIkjg=;
        b=P7BiZq4DB6O4vsVV83frspWzCfjKydGc/dvNZcmr1KfuNNPsuXuzPwanr37hdfexevuu+T
        ilXfPBstF7gi1Dh3gPwx8Cz5XjF943ghya74hga4F2unMpY/6hHWC7L0bi3JhT5FWT1VaO
        FypE0PzsWU3AXJGrDQVqt8AHoFfBoY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-xKH6Hm0hPaekiB5WyIaY6g-1; Fri, 09 Jul 2021 05:41:02 -0400
X-MC-Unique: xKH6Hm0hPaekiB5WyIaY6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C291804140;
        Fri,  9 Jul 2021 09:41:02 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-68.ams2.redhat.com [10.36.113.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 519AA369A;
        Fri,  9 Jul 2021 09:40:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, toke@redhat.com
Subject: [RFC PATCH 3/3] selftests: net: veth: add tests for set_channel
Date:   Fri,  9 Jul 2021 11:39:50 +0200
Message-Id: <316d4ebdd40b03b56f4e342f8e239442313f9e65.1625823139.git.pabeni@redhat.com>
In-Reply-To: <cover.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple functional test for the newly exposted features

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/veth.sh | 65 +++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 11d7cdb898c0..1f4cdbe6ffe0 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -75,6 +75,31 @@ chk_tso_flag() {
 	__chk_flag "$1" $2 $3 tcp-segmentation-offload
 }
 
+chk_channels() {
+	local msg="$1"
+	local target=$2
+	local rx=$3
+	local tx=$4
+
+	local dev=veth$target
+	local combined=$tx
+	[ $rx -lt $tx ] && combined=$rx
+
+	local cur_rx=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep RX: | tail -n 1 | awk '{print $2}' `
+	local cur_tx=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep TX: | tail -n 1 | awk '{print $2}'`
+	local cur_combined=`ip netns exec $BASE$target ethtool -l $dev |\
+		grep Combined: | tail -n 1 | awk '{print $2}'`
+
+	printf "%-60s" "$msg"
+	if [ "$cur_rx" = "$rx" -a "$cur_tx" = "$tx" -a "$cur_combined" = "$combined" ]; then
+		echo " ok "
+	else
+		echo " fail rx:$rx:$cur_rx tx:$tx:$cur_tx combined:$combined:$cur_combined"
+	fi
+}
+
 chk_gro() {
 	local msg="$1"
 	local expected=$2
@@ -122,6 +147,8 @@ ip netns exec $NS_SRC ethtool -K veth$SRC tx-udp-segmentation off
 chk_gro "        - aggregation with TSO off" 10
 cleanup
 
+# reset default, just in case
+echo 1 > /sys/module/veth/parameters/tx_queues
 create_ns
 ip netns exec $NS_DST ethtool -K veth$DST gro on
 chk_gro_flag "with gro on - gro flag" $DST on
@@ -134,6 +161,11 @@ chk_gro "        - aggregation with TSO off" 1
 cleanup
 
 create_ns
+chk_channels "default channels" $DST 1 1
+
+# will affect next veth device pair creation
+echo 128 > /sys/module/veth/parameters/tx_queues
+
 ip -n $NS_DST link set dev veth$DST down
 ip netns exec $NS_DST ethtool -K veth$DST gro on
 chk_gro_flag "with gro enabled on link down - gro flag" $DST on
@@ -147,7 +179,35 @@ chk_gro "        - aggregation with TSO off" 1
 cleanup
 
 create_ns
+
+ip netns exec $NS_DST ethtool -L veth$DST tx 2
+chk_channels "setting tx channels" $DST 128 2
+
+ip netns exec $NS_DST ethtool -L veth$DST rx 3 tx 4
+chk_channels "setting both rx and tx channels" $DST 3 4
+ip netns exec $NS_DST ethtool -L veth$DST combined 2 2>/dev/null
+chk_channels "bad setting: combined channels" $DST 3 4
+
+ip netns exec $NS_DST ethtool -L veth$DST tx 1025 2>/dev/null
+chk_channels "setting invalid channels nr" $DST 3 4
+
+printf "%-60s" "bad setting: XDP with RX nr less than TX"
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null &&\
+	echo "fail - set operation successful ?!?" || echo " ok "
+
+# the following tests will run with multiple channels active
+ip netns exec $NS_SRC ethtool -L veth$SRC tx 3
+
 ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
+ip netns exec $NS_DST ethtool -L veth$DST rx 2 2>/dev/null &&\
+	echo "fail - set operation successful ?!?" || echo " ok "
+printf "%-60s" "bad setting: increasing peer TX nr above RX with XDP set"
+ip netns exec $NS_SRC ethtool -L veth$SRC tx 4 2>/dev/null &&\
+	echo "fail - set operation successful ?!?" || echo " ok "
+
+chk_channels "setting invalid channels nr" $DST 3 4
+
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off
@@ -167,8 +227,13 @@ chk_gro_flag "        - after gro on xdp off, gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC on
 chk_tso_flag "        - peer tso flag" $DST on
+
+ip netns exec $NS_DST ethtool -L veth$DST tx 5
+chk_channels "setting tx channels with device down" $DST 3 4
+
 ip -n $NS_DST link set dev veth$DST up
 ip -n $NS_SRC link set dev veth$SRC up
+chk_channels "[takes effect after link up]" $DST 3 5
 chk_gro "        - aggregation" 1
 
 ip netns exec $NS_DST ethtool -K veth$DST gro off
-- 
2.26.3

