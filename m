Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641D373EA9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhEEPhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:37:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233614AbhEEPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620228981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hkIAZ0STm9IWCnndFp9K2a4ZUXMUkZ2Fdm7l99uqidw=;
        b=SMk28IlpeMuR3leTxcYioOX5OiGCsPIFentNwhvg6898U6RCVMn/X6PBYujoJsVAQOzLM5
        2k3yg5uJiGrgYL+C1D+cTjAC3jBUihwzPbegeJe6Qvv57OkJV8a6dWmLyLJT7tDYC8xbCt
        U6S3VQab7itmVO2ytZHHBGFjgNsAIWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-4PoRonAzMV2KD27oUlOOsA-1; Wed, 05 May 2021 11:36:16 -0400
X-MC-Unique: 4PoRonAzMV2KD27oUlOOsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A11610CE780;
        Wed,  5 May 2021 15:36:15 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0467D5C1A3;
        Wed,  5 May 2021 15:36:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net 4/4] selftests: more UDP GRO tests
Date:   Wed,  5 May 2021 17:35:04 +0200
Message-Id: <31746302323edf8282b8c9e80293ca45f1dbbf03.1620223174.git.pabeni@redhat.com>
In-Reply-To: <cover.1620223174.git.pabeni@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduces explicit scenarios for the issues addressed
on the previous patches, and functionally checks the
expected aggregation and segmentation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/set_sysfs_attr.sh | 15 ++++++
 tools/testing/selftests/net/udpgro_fwd.sh     | 54 +++++++++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100755 tools/testing/selftests/net/set_sysfs_attr.sh

diff --git a/tools/testing/selftests/net/set_sysfs_attr.sh b/tools/testing/selftests/net/set_sysfs_attr.sh
new file mode 100755
index 000000000000..fd042a162326
--- /dev/null
+++ b/tools/testing/selftests/net/set_sysfs_attr.sh
@@ -0,0 +1,15 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+if [ $# -lt 2 ]; then
+	echo -e "syntax:\n$0 <device> <attr> [<value>]"
+	exit 0
+fi
+
+mount -t sysfs /sys 2>/dev/null
+if [ $# -lt 3 ]; then
+	cat /sys/class/net/$1/$2
+	exit $?
+fi
+
+echo $3 > /sys/class/net/$1/$2
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index a8fa64136282..8569b3f81fd7 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -79,6 +79,16 @@ create_vxlan_pair() {
 	done
 }
 
+move_address() {
+	local -r ns=$1
+	local -r src_dev=$2
+	local -r dst_dev=$3
+	local -r addr=$4
+
+	ip -n $ns addr del dev $src_dev $addr
+	ip -n $ns addr add dev $dst_dev $addr nodad 2>/dev/null
+}
+
 is_ipv6() {
 	if [[ $1 =~ .*:.* ]]; then
 		return 0
@@ -86,6 +96,35 @@ is_ipv6() {
 	return 1
 }
 
+create_bridge() {
+	local vxdev=vxlan$SRC
+	local src=$1
+	local i
+
+	is_ipv6 $src && vxdev=vxlan6$SRC
+
+	create_vxlan_pair
+	ip -n $NS_SRC link add name br_port type veth peer name br_port_peer
+	ip -n $NS_SRC link add name br0 type bridge
+	ip -n $NS_SRC link set dev br0 up
+	ip -n $NS_SRC link set dev br_port_peer up
+	ip -n $NS_SRC link set dev br_port up master br0
+	ip -n $NS_SRC link set dev $vxdev master br0
+	move_address $NS_SRC $vxdev br_port_peer $src/24
+
+	ip -n $NS_SRC link set br_port xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+	ip netns exec $NS_SRC ./set_sysfs_attr.sh br_port threaded 1
+
+	# slowing down the input path, we will help the napi thread to
+	# aggregate as much packets as possible via GRO
+	modprobe br_netfilter 2>/dev/null
+	ip netns exec $NS_SRC sysctl -qw net.bridge.bridge-nf-call-iptables=1
+	ip netns exec $NS_SRC sysctl -qw net.bridge.bridge-nf-call-ip6tables=1
+	for i in `seq 1 100`; do
+		ip netns exec $NS_SRC $IPT -A FORWARD
+	done
+}
+
 run_test() {
 	local -r msg=$1
 	local -r dst=$2
@@ -228,6 +267,21 @@ for family in 4 6; do
 	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 1 1
 	cleanup
 
+	create_bridge $OL_NET$SRC
+	ip netns exec $NS_SRC ethtool -K br_port rx-gro-list on
+	ip netns exec $NS_SRC ethtool -K br_port_peer tx-udp-segmentation off
+	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
+	run_test "GRO frag list over UDP tunnel segmentation" $OL_NET$DST 1 1
+	cleanup
+
+	create_bridge $OL_NET$SRC
+	ip netns exec $NS_SRC ethtool -K br_port rx-gro-list on
+	ip netns exec $NS_SRC ethtool -K br_port_peer tx-udp-segmentation off
+	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
+	ip netns exec $NS_SRC ethtool -K veth$SRC tx off
+	run_test "GRO frag list over UDP tunnel segmentation (tx csum off)" $OL_NET$DST 1 1
+	cleanup
+
 	# use NAT to circumvent GRO FWD check
 	create_vxlan_pair
 	ip -n $NS_DST addr add dev $VXDEV$DST $OL_NET$DST_NAT/$SUFFIX
-- 
2.26.2

