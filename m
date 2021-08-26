Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019B43F8327
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 09:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhHZHbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 03:31:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239566AbhHZHbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 03:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629963054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YBo+y/AAa5VV6M9utwZlFTZwEYLUB48K6070Pr9Y4QY=;
        b=fuirlZ7Hq0f8/y+JeSg0mw1vKD/80FhdF5YmriYZMeJqOg1kAvWIKDG1Ygl/Wj8XWZ5U/5
        Uk8YefhZ8umh8TYfFYFnWDHa6n2VwpjO1rBsgXNzCZbFciponOFN7WUcnmdTo1Kzl/gHRH
        ZNBQEaqmLlQ99NegEzE2lnYjRQ/X1tI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-ZLX4iMlcNNGNle-220IWvA-1; Thu, 26 Aug 2021 03:30:52 -0400
X-MC-Unique: ZLX4iMlcNNGNle-220IWvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C21D21082923;
        Thu, 26 Aug 2021 07:30:50 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33B856A8E7;
        Thu, 26 Aug 2021 07:30:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v2 net-next] selftests/net: allow GRO coalesce test on veth
Date:   Thu, 26 Aug 2021 09:30:42 +0200
Message-Id: <529bc61a01c28fbe883ec079cf256070e969b98f.1629963020.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change extends the existing GRO coalesce test to
allow running on top of a veth pair, so that no H/W dep
is required to run them.

By default gro.sh will use the veth backend, and will try
to use exiting H/W in loopback mode if a specific device
name is provided with the '-i' command line option.

No functional change is intended for the loopback-based
tests, just move all the relevant initialization/cleanup
code into the related script.

Introduces a new initialization helper script for the
veth backend, and plugs the correct helper script according
to the provided command line.

Additionally, enable veth-based tests by default.

v1 -> v2:
  - drop unused code in setup_veth_ns() - Willem

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/gro.sh            | 43 +++----------------
 tools/testing/selftests/net/setup_loopback.sh | 38 +++++++++++++++-
 tools/testing/selftests/net/setup_veth.sh     | 41 ++++++++++++++++++
 4 files changed, 86 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/net/setup_veth.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 4f9f73e7a299..378c0aac5a1a 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -26,6 +26,7 @@ TEST_PROGS += unicast_extensions.sh
 TEST_PROGS += udpgro_fwd.sh
 TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
+TEST_PROGS += gro.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/gro.sh b/tools/testing/selftests/net/gro.sh
index 794d2bf36dd7..342ad27f631b 100755
--- a/tools/testing/selftests/net/gro.sh
+++ b/tools/testing/selftests/net/gro.sh
@@ -1,45 +1,14 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-source setup_loopback.sh
 readonly SERVER_MAC="aa:00:00:00:00:02"
 readonly CLIENT_MAC="aa:00:00:00:00:01"
 readonly TESTS=("data" "ack" "flags" "tcp" "ip" "large")
 readonly PROTOS=("ipv4" "ipv6")
-dev="eth0"
+dev=""
 test="all"
 proto="ipv4"
 
-setup_interrupt() {
-  # Use timer on  host to trigger the network stack
-  # Also disable device interrupt to not depend on NIC interrupt
-  # Reduce test flakiness caused by unexpected interrupts
-  echo 100000 >"${FLUSH_PATH}"
-  echo 50 >"${IRQ_PATH}"
-}
-
-setup_ns() {
-  # Set up server_ns namespace and client_ns namespace
-  setup_macvlan_ns "${dev}" server_ns server "${SERVER_MAC}"
-  setup_macvlan_ns "${dev}" client_ns client "${CLIENT_MAC}"
-}
-
-cleanup_ns() {
-  cleanup_macvlan_ns server_ns server client_ns client
-}
-
-setup() {
-  setup_loopback_environment "${dev}"
-  setup_interrupt
-}
-
-cleanup() {
-  cleanup_loopback "${dev}"
-
-  echo "${FLUSH_TIMEOUT}" >"${FLUSH_PATH}"
-  echo "${HARD_IRQS}" >"${IRQ_PATH}"
-}
-
 run_test() {
   local server_pid=0
   local exit_code=0
@@ -115,10 +84,12 @@ while getopts "i:t:p:" opt; do
   esac
 done
 
-readonly FLUSH_PATH="/sys/class/net/${dev}/gro_flush_timeout"
-readonly IRQ_PATH="/sys/class/net/${dev}/napi_defer_hard_irqs"
-readonly FLUSH_TIMEOUT="$(< ${FLUSH_PATH})"
-readonly HARD_IRQS="$(< ${IRQ_PATH})"
+if [ -n "$dev" ]; then
+	source setup_loopback.sh
+else
+	source setup_veth.sh
+fi
+
 setup
 trap cleanup EXIT
 if [[ "${test}" == "all" ]]; then
diff --git a/tools/testing/selftests/net/setup_loopback.sh b/tools/testing/selftests/net/setup_loopback.sh
index 0a8ad97b07ea..e57bbfbc5208 100755
--- a/tools/testing/selftests/net/setup_loopback.sh
+++ b/tools/testing/selftests/net/setup_loopback.sh
@@ -1,5 +1,11 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
+
+readonly FLUSH_PATH="/sys/class/net/${dev}/gro_flush_timeout"
+readonly IRQ_PATH="/sys/class/net/${dev}/napi_defer_hard_irqs"
+readonly FLUSH_TIMEOUT="$(< ${FLUSH_PATH})"
+readonly HARD_IRQS="$(< ${IRQ_PATH})"
+
 netdev_check_for_carrier() {
 	local -r dev="$1"
 
@@ -18,7 +24,7 @@ netdev_check_for_carrier() {
 
 # Assumes that there is no existing ipvlan device on the physical device
 setup_loopback_environment() {
-    local dev="$1"
+	local dev="$1"
 
 	# Fail hard if cannot turn on loopback mode for current NIC
 	ethtool -K "${dev}" loopback on || exit 1
@@ -80,3 +86,33 @@ cleanup_loopback(){
 		exit 1
 	fi
 }
+
+setup_interrupt() {
+	# Use timer on  host to trigger the network stack
+	# Also disable device interrupt to not depend on NIC interrupt
+	# Reduce test flakiness caused by unexpected interrupts
+	echo 100000 >"${FLUSH_PATH}"
+	echo 50 >"${IRQ_PATH}"
+}
+
+setup_ns() {
+	# Set up server_ns namespace and client_ns namespace
+	setup_macvlan_ns "${dev}" server_ns server "${SERVER_MAC}"
+	setup_macvlan_ns "${dev}" client_ns client "${CLIENT_MAC}"
+}
+
+cleanup_ns() {
+	cleanup_macvlan_ns server_ns server client_ns client
+}
+
+setup() {
+	setup_loopback_environment "${dev}"
+	setup_interrupt
+}
+
+cleanup() {
+	cleanup_loopback "${dev}"
+
+	echo "${FLUSH_TIMEOUT}" >"${FLUSH_PATH}"
+	echo "${HARD_IRQS}" >"${IRQ_PATH}"
+}
diff --git a/tools/testing/selftests/net/setup_veth.sh b/tools/testing/selftests/net/setup_veth.sh
new file mode 100644
index 000000000000..1003ddf7b3b2
--- /dev/null
+++ b/tools/testing/selftests/net/setup_veth.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+setup_veth_ns() {
+	local -r link_dev="$1"
+	local -r ns_name="$2"
+	local -r ns_dev="$3"
+	local -r ns_mac="$4"
+
+	[[ -e /var/run/netns/"${ns_name}" ]] || ip netns add "${ns_name}"
+	echo 100000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
+	ip link set dev "${ns_dev}" netns "${ns_name}" mtu 65535
+	ip -netns "${ns_name}" link set dev "${ns_dev}" up
+
+	ip netns exec "${ns_name}" ethtool -K "${ns_dev}" gro on tso off
+}
+
+setup_ns() {
+	# Set up server_ns namespace and client_ns namespace
+	ip link add name server type veth peer name client
+
+	setup_veth_ns "${dev}" server_ns server "${SERVER_MAC}"
+	setup_veth_ns "${dev}" client_ns client "${CLIENT_MAC}"
+}
+
+cleanup_ns() {
+	local ns_name
+
+	for ns_name in client_ns server_ns; do
+		[[ -e /var/run/netns/"${ns_name}" ]] && ip netns del "${ns_name}"
+	done
+}
+
+setup() {
+	# no global init setup step needed
+	:
+}
+
+cleanup() {
+	cleanup_ns
+}
-- 
2.26.3

