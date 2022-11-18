Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8DC62FEDE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiKRUbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiKRUba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:31:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2337460FA
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668803429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=68o9gsyPQ5CgCEpOe1a5pEBZyWLNNRQQ7qhaCbVlRTg=;
        b=I0PordCwJQfHhZ4Vbrtr5Eq2vRsVW1QgMP7yJNsQp/cuzYttuDV9/TiWByy9AyyDvXm0Qa
        7RA0nJaCMqF1JjUu8Vm+9qkQTdJSTFTA93rzXp1BqV1CP99dyyaDyk2V5RvEJsBPakPLkB
        4Q5umB7lF93kgZ2pihxmbRzADNTofAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-_Ka1sUAdN5OgA_XU1Ky1wA-1; Fri, 18 Nov 2022 15:30:23 -0500
X-MC-Unique: _Ka1sUAdN5OgA_XU1Ky1wA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D188B85A59D;
        Fri, 18 Nov 2022 20:30:22 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7303C492B04;
        Fri, 18 Nov 2022 20:30:22 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Liang Li <liali@redhat.com>, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/2] selftests: bonding: up/down delay w/ slave link flapping
Date:   Fri, 18 Nov 2022 15:30:12 -0500
Message-Id: <314990ea9ee4e475cb200cf32efdf9fc37f4a02a.1668800711.git.jtoppins@redhat.com>
In-Reply-To: <cover.1668800711.git.jtoppins@redhat.com>
References: <cover.1668800711.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify when a bond is configured with {up,down}delay and the link state
of slave members flaps if there are no remaining members up the bond
should immediately select a member to bring up. (from bonding.txt
section 13.1 paragraph 4)

Suggested-by: Liang Li <liali@redhat.com>
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 .../selftests/drivers/net/bonding/Makefile    |   4 +-
 .../selftests/drivers/net/bonding/lag_lib.sh  | 107 ++++++++++++++++++
 .../net/bonding/mode-1-recovery-updelay.sh    |  45 ++++++++
 .../net/bonding/mode-2-recovery-updelay.sh    |  45 ++++++++
 .../selftests/drivers/net/bonding/settings    |   2 +-
 5 files changed, 201 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 6b8d2e2f23c2..0f3921908b07 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -5,7 +5,9 @@ TEST_PROGS := \
 	bond-arp-interval-causes-panic.sh \
 	bond-break-lacpdu-tx.sh \
 	bond-lladdr-target.sh \
-	dev_addr_lists.sh
+	dev_addr_lists.sh \
+	mode-1-recovery-updelay.sh \
+	mode-2-recovery-updelay.sh
 
 TEST_FILES := \
 	lag_lib.sh \
diff --git a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
index 16c7fb858ac1..6dc9af1f2428 100644
--- a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
+++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+NAMESPACES=""
+
 # Test that a link aggregation device (bonding, team) removes the hardware
 # addresses that it adds on its underlying devices.
 test_LAG_cleanup()
@@ -59,3 +61,108 @@ test_LAG_cleanup()
 
 	log_test "$driver cleanup mode $mode"
 }
+
+# Build a generic 2 node net namespace with 2 connections
+# between the namespaces
+#
+#  +-----------+       +-----------+
+#  | node1     |       | node2     |
+#  |           |       |           |
+#  |           |       |           |
+#  |      eth0 +-------+ eth0      |
+#  |           |       |           |
+#  |      eth1 +-------+ eth1      |
+#  |           |       |           |
+#  +-----------+       +-----------+
+lag_setup2x2()
+{
+	local state=${1:-down}
+	local namespaces="lag_node1 lag_node2"
+
+	# create namespaces
+	for n in ${namespaces}; do
+		ip netns add ${n}
+	done
+
+	# wire up namespaces
+	ip link add name lag1 type veth peer name lag1-end
+	ip link set dev lag1 netns lag_node1 $state name eth0
+	ip link set dev lag1-end netns lag_node2 $state name eth0
+
+	ip link add name lag1 type veth peer name lag1-end
+	ip link set dev lag1 netns lag_node1 $state name eth1
+	ip link set dev lag1-end netns lag_node2 $state name eth1
+
+	NAMESPACES="${namespaces}"
+}
+
+# cleanup all lag related namespaces and remove the bonding module
+lag_cleanup()
+{
+	for n in ${NAMESPACES}; do
+		ip netns delete ${n} >/dev/null 2>&1 || true
+	done
+	modprobe -r bonding
+}
+
+SWITCH="lag_node1"
+CLIENT="lag_node2"
+CLIENTIP="172.20.2.1"
+SWITCHIP="172.20.2.2"
+
+lag_setup_network()
+{
+	lag_setup2x2 "down"
+
+	# create switch
+	ip netns exec ${SWITCH} ip link add br0 up type bridge
+	ip netns exec ${SWITCH} ip link set eth0 master br0 up
+	ip netns exec ${SWITCH} ip link set eth1 master br0 up
+	ip netns exec ${SWITCH} ip addr add ${SWITCHIP}/24 dev br0
+}
+
+lag_reset_network()
+{
+	ip netns exec ${CLIENT} ip link del bond0
+	ip netns exec ${SWITCH} ip link set eth0 up
+	ip netns exec ${SWITCH} ip link set eth1 up
+}
+
+create_bond()
+{
+	# create client
+	ip netns exec ${CLIENT} ip link set eth0 down
+	ip netns exec ${CLIENT} ip link set eth1 down
+
+	ip netns exec ${CLIENT} ip link add bond0 type bond $@
+	ip netns exec ${CLIENT} ip link set eth0 master bond0
+	ip netns exec ${CLIENT} ip link set eth1 master bond0
+	ip netns exec ${CLIENT} ip link set bond0 up
+	ip netns exec ${CLIENT} ip addr add ${CLIENTIP}/24 dev bond0
+}
+
+test_bond_recovery()
+{
+	RET=0
+
+	create_bond $@
+
+	# verify connectivity
+	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 5 >/dev/null 2>&1
+	check_err $? "No connectivity"
+
+	# force the links of the bond down
+	ip netns exec ${SWITCH} ip link set eth0 down
+	sleep 2
+	ip netns exec ${SWITCH} ip link set eth0 up
+	ip netns exec ${SWITCH} ip link set eth1 down
+
+	# re-verify connectivity
+	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 5 >/dev/null 2>&1
+
+	local rc=$?
+	check_err $rc "Bond failed to recover"
+	log_test "$1 ($2) bond recovery"
+	lag_reset_network
+	return 0
+}
diff --git a/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh b/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
new file mode 100755
index 000000000000..ad4c845a4ac7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
@@ -0,0 +1,45 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#  When the bond is configured with down/updelay and the link state of
+#  slave members flaps if there are no remaining members up the bond
+#  should immediately select a member to bring up. (from bonding.txt
+#  section 13.1 paragraph 4)
+#
+#  +-------------+       +-----------+
+#  | client      |       | switch    |
+#  |             |       |           |
+#  |    +--------| link1 |-----+     |
+#  |    |        +-------+     |     |
+#  |    |        |       |     |     |
+#  |    |        +-------+     |     |
+#  |    | bond   | link2 | Br0 |     |
+#  +-------------+       +-----------+
+#     172.20.2.1           172.20.2.2
+
+
+REQUIRE_MZ=no
+REQUIRE_JQ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/net_forwarding_lib.sh
+source "$lib_dir"/lag_lib.sh
+
+cleanup()
+{
+	lag_cleanup
+}
+
+trap cleanup 0 1 2
+
+lag_setup_network
+test_bond_recovery mode 1 miimon 100 updelay 0
+test_bond_recovery mode 1 miimon 100 updelay 200
+test_bond_recovery mode 1 miimon 100 updelay 500
+test_bond_recovery mode 1 miimon 100 updelay 1000
+test_bond_recovery mode 1 miimon 100 updelay 2000
+test_bond_recovery mode 1 miimon 100 updelay 5000
+test_bond_recovery mode 1 miimon 100 updelay 10000
+
+exit "$EXIT_STATUS"
diff --git a/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh b/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
new file mode 100755
index 000000000000..2330d37453f9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
@@ -0,0 +1,45 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#  When the bond is configured with down/updelay and the link state of
+#  slave members flaps if there are no remaining members up the bond
+#  should immediately select a member to bring up. (from bonding.txt
+#  section 13.1 paragraph 4)
+#
+#  +-------------+       +-----------+
+#  | client      |       | switch    |
+#  |             |       |           |
+#  |    +--------| link1 |-----+     |
+#  |    |        +-------+     |     |
+#  |    |        |       |     |     |
+#  |    |        +-------+     |     |
+#  |    | bond   | link2 | Br0 |     |
+#  +-------------+       +-----------+
+#     172.20.2.1           172.20.2.2
+
+
+REQUIRE_MZ=no
+REQUIRE_JQ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/net_forwarding_lib.sh
+source "$lib_dir"/lag_lib.sh
+
+cleanup()
+{
+	lag_cleanup
+}
+
+trap cleanup 0 1 2
+
+lag_setup_network
+test_bond_recovery mode 2 miimon 100 updelay 0
+test_bond_recovery mode 2 miimon 100 updelay 200
+test_bond_recovery mode 2 miimon 100 updelay 500
+test_bond_recovery mode 2 miimon 100 updelay 1000
+test_bond_recovery mode 2 miimon 100 updelay 2000
+test_bond_recovery mode 2 miimon 100 updelay 5000
+test_bond_recovery mode 2 miimon 100 updelay 10000
+
+exit "$EXIT_STATUS"
diff --git a/tools/testing/selftests/drivers/net/bonding/settings b/tools/testing/selftests/drivers/net/bonding/settings
index 867e118223cd..6091b45d226b 100644
--- a/tools/testing/selftests/drivers/net/bonding/settings
+++ b/tools/testing/selftests/drivers/net/bonding/settings
@@ -1 +1 @@
-timeout=60
+timeout=120
-- 
2.31.1

