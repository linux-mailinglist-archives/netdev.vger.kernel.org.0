Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC37F3F72F6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbhHYK0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237307AbhHYK0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629887126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y9gln0+YSOB3xu5CwJQaup299piooAlhBXlRDsV5xLc=;
        b=UPiGaj+vVUdr6/y+qkgE5GFS6wHcVOb43WRp6lkzQXIWuhfc93eq8LQDHc2vTiOFTHrEZ2
        Pp2f9D4AS7avjLavrqePnhPrrQANWUYz9fOMgs5IBO43w6RJCGPxraraAdYizDMk1RhVSQ
        XW5L+uR051EJDbJO7gpVpv7RMEG39Y0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-HRANlLLNMb6henfyZOW41Q-1; Wed, 25 Aug 2021 06:25:22 -0400
X-MC-Unique: HRANlLLNMb6henfyZOW41Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 267968799EB;
        Wed, 25 Aug 2021 10:25:21 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE0D6A056;
        Wed, 25 Aug 2021 10:25:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: allow GRO coalesce test on veth
Date:   Wed, 25 Aug 2021 12:24:54 +0200
Message-Id: <2d9ca8df08aed8dcb8c56554225f8f71db621bbe.1629886126.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/gro.sh            | 43 +++---------------
 tools/testing/selftests/net/setup_loopback.sh | 38 +++++++++++++++-
 tools/testing/selftests/net/setup_veth.sh     | 45 +++++++++++++++++++
 4 files changed, 90 insertions(+), 37 deletions(-)
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
index 000000000000..06cf102769ee
--- /dev/null
+++ b/tools/testing/selftests/net/setup_veth.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+setup_veth_ns() {
+	local -r link_dev="$1"
+	local -r ns_name="$2"
+	local -r ns_dev="$3"
+	local -r ns_mac="$4"
+	local -r addr="$5"
+
+	[[ -e /var/run/netns/"${ns_name}" ]] || ip netns add "${ns_name}"
+	echo 100000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
+	ip link set dev "${ns_dev}" netns "${ns_name}" mtu 65535
+	ip -netns "${ns_name}" link set dev "${ns_dev}" up
+	if [[ -n "${addr}" ]]; then
+		ip -netns "${ns_name}" addr add dev "${ns_dev}" "${addr}"
+	fi
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

