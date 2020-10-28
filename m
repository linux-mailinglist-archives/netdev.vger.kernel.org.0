Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA36229E195
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgJ2CCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727463AbgJ1VtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vRfli5Z5DUhcuyRlIgm4cbCOglHgREI9yrOIn+85HoI=;
        b=GFAlwCKGoTzx9mf6V63YhHPBFIrZ3ARut8oZMHBjIy+5c3kkNJhQcTbvr0XxUep4aE63Js
        FbLzmeaQLAxhSKnHkOQH7fwL6Ps94G94qnDXTLD3qSo0jDNonOVC+Bf8mtxD7S4Dz+R93A
        WJtXZ2MgmJFj+G8rKi3LyYSYpWcXWS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-VDuhqbblOD6oapEgFdZfoQ-1; Wed, 28 Oct 2020 13:47:02 -0400
X-MC-Unique: VDuhqbblOD6oapEgFdZfoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00D1F18A0727;
        Wed, 28 Oct 2020 17:46:40 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-68.ams2.redhat.com [10.36.115.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB78F6198D;
        Wed, 28 Oct 2020 17:46:37 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next 3/3] self-tests: introduce self-tests for RPS default mask
Date:   Wed, 28 Oct 2020 18:46:03 +0100
Message-Id: <27a3dd523e015ba27ba5666ad727ff5d935ce3a8.1603906564.git.pabeni@redhat.com>
In-Reply-To: <cover.1603906564.git.pabeni@redhat.com>
References: <cover.1603906564.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that RPS default mask changes take place on
all newly created netns/devices and don't affect
existing ones.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/config            |  3 +
 .../testing/selftests/net/rps_default_mask.sh | 57 +++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 tools/testing/selftests/net/rps_default_mask.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ef352477cac6..2531ec3e5027 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -21,6 +21,7 @@ TEST_PROGS += rxtimestamp.sh
 TEST_PROGS += devlink_port_split.py
 TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS += vrf_route_leaking.sh
+TEST_PROGS += rps_default_mask.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 4d5df8e1eee7..5d467364f082 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -34,3 +34,6 @@ CONFIG_TRACEPOINTS=y
 CONFIG_NET_DROP_MONITOR=m
 CONFIG_NETDEVSIM=m
 CONFIG_NET_FOU=m
+CONFIG_RPS=y
+CONFIG_SYSFS=y
+CONFIG_PROC_SYSCTL=y
diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/testing/selftests/net/rps_default_mask.sh
new file mode 100644
index 000000000000..c81c0ac7ddfe
--- /dev/null
+++ b/tools/testing/selftests/net/rps_default_mask.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+readonly ksft_skip=4
+readonly cpus=$(nproc)
+ret=0
+
+[ $cpus -gt 2 ] || exit $ksft_skip
+
+readonly INITIAL_RPS_DEFAULT_MASK=$(cat /proc/sys/net/core/rps_default_mask)
+readonly NETNS="ns-$(mktemp -u XXXXXX)"
+
+setup() {
+	ip netns add "${NETNS}"
+	ip -netns "${NETNS}" link set lo up
+}
+
+cleanup() {
+	echo $INITIAL_RPS_DEFAULT_MASK > /proc/sys/net/core/rps_default_mask
+	ip netns del $NETNS
+}
+
+chk_rps() {
+	local rps_mask expected_rps_mask=$3
+	local dev_name=$2
+	local msg=$1
+
+	rps_mask=$(ip netns exec $NETNS cat /sys/class/net/$dev_name/queues/rx-0/rps_cpus)
+	printf "%-60s" "$msg"
+	if [ $rps_mask -eq $expected_rps_mask ]; then
+		echo "[ ok ]"
+	else
+		echo "[fail] expected $expected_rps_mask found $rps_mask"
+		ret=1
+	fi
+}
+
+trap cleanup EXIT
+
+echo 0 > /proc/sys/net/core/rps_default_mask
+setup
+chk_rps "empty rps_default_mask" lo 0
+cleanup
+
+echo 1 > /proc/sys/net/core/rps_default_mask
+setup
+chk_rps "non zero rps_default_mask" lo 1
+
+echo 3 > /proc/sys/net/core/rps_default_mask
+chk_rps "changing rps_default_mask dont affect existing netns" lo 1
+
+ip -n $NETNS link add type veth
+ip -n $NETNS link set dev veth0 up
+ip -n $NETNS link set dev veth1 up
+chk_rps "changing rps_default_mask affect newly created devices" veth0 3
+chk_rps "changing rps_default_mask affect newly created devices[II]" veth1 3
+exit $ret
-- 
2.26.2

