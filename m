Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B894B634816
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiKVU0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiKVU0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:26:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45795E9D0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669148717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r3/2piB6GXyvdrxnNdT33GXkLuSFNYhdrcvdRhDy1+c=;
        b=UbO58rs9DmqLFBGDW3+25pD/37PMaRYY8uUbd7mdvVdFoJT+YU93V+QPNCLyoz5RJ5L4Ku
        XWIP2FeSbm2gvamtUY1g/uCGKCgbaNlwV478jwkRKw+6wxDU/0ZF1bRyWvLJ17Ry4ontt4
        zfrxhcie0467G39AnkjaxAklU9XPtI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-raX7gI8DNlSf5KwaXD7P4Q-1; Tue, 22 Nov 2022 15:25:13 -0500
X-MC-Unique: raX7gI8DNlSf5KwaXD7P4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1957F800B23;
        Tue, 22 Nov 2022 20:25:13 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.32.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9942A40C6EC6;
        Tue, 22 Nov 2022 20:25:12 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        pabeni@redhat.com
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>, Liang Li <liali@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v2 1/2] selftests: bonding: up/down delay w/ slave link flapping
Date:   Tue, 22 Nov 2022 15:25:04 -0500
Message-Id: <58a5bf9b72f14eb9a770391359bae33da5e490f4.1669147951.git.jtoppins@redhat.com>
In-Reply-To: <cover.1669147951.git.jtoppins@redhat.com>
References: <cover.1669147951.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

Notes:
    v2:
     * reduced the number of icmp echos to two (-c 2) and removed the
       unneeded `return 0` from function `test_bond_recovery`.

 .../selftests/drivers/net/bonding/Makefile    |   4 +-
 .../selftests/drivers/net/bonding/lag_lib.sh  | 106 ++++++++++++++++++
 .../net/bonding/mode-1-recovery-updelay.sh    |  45 ++++++++
 .../net/bonding/mode-2-recovery-updelay.sh    |  45 ++++++++
 .../selftests/drivers/net/bonding/settings    |   2 +-
 5 files changed, 200 insertions(+), 2 deletions(-)
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
index 16c7fb858ac1..2a268b17b61f 100644
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
@@ -59,3 +61,107 @@ test_LAG_cleanup()
 
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
+	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 2 >/dev/null 2>&1
+	check_err $? "No connectivity"
+
+	# force the links of the bond down
+	ip netns exec ${SWITCH} ip link set eth0 down
+	sleep 2
+	ip netns exec ${SWITCH} ip link set eth0 up
+	ip netns exec ${SWITCH} ip link set eth1 down
+
+	# re-verify connectivity
+	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 2 >/dev/null 2>&1
+
+	local rc=$?
+	check_err $rc "Bond failed to recover"
+	log_test "$1 ($2) bond recovery"
+	lag_reset_network
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

