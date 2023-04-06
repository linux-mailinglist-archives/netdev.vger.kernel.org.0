Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFBB6D918D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbjDFI3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbjDFI3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:29:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB0C1BD
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:29:49 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id kc4so36856617plb.10
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680769788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mg1ubyg4pZMNoNvCIqYalC3JZOKNniPWe3SUXfrhNU=;
        b=Y7XD5MSaJi0khajCEPXmpHD1I89sXIKemkvlF1nE6kVL4RlYaF9vgVQy8GS6zMj24u
         dDFtQBo6/16MTGaGj1kkCzkg14vGHX3Jbez65ZMlh5sxS8ak5HhpSHDtUKp/mT/SjF68
         AukyVXz7qDRzuQbn/AK3I9mlC7Z6WpLb6xLdylaC6GJWYEFLMti3xvfGszzgCtRsqE7U
         8/0cdreLZLNoChgcwXZMu3YCs/QPd4aRBEwn+FtJku32AhW0Ir6IXwaEgvukIXevcmIH
         JynG74ul4qf1b6s769MXj6xtQ+RWoMB4AwGB60YnFoIUygadL1Ge/UaQ1fZaURYnUCI6
         E0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mg1ubyg4pZMNoNvCIqYalC3JZOKNniPWe3SUXfrhNU=;
        b=IBCYiZwoktOYDuOzxiiCgTNH14E01RLRoA2bS6SZrXoh5lotRvVQRL6xaBtUEcSNUG
         HlF1oRxCuE3q0IsU3IRfDUhraFPmms3jRlhzcLFFTh+IbbMpgO9FqlqgFeShlSJ+oylS
         W3xvOLDoPqQHsCFb0fAle/WLWIFFIODB+tKmTNJB84qYSpdycMRHblnY1VwYGXFk2M26
         jbV7lQSlJ1EhS9RyfgRh/iFutrU9TtatFxqyPslUmH/eqpFjOf9vXqUxhvknhe/WkXj6
         56GEiYWdJvpiokW88Jji+4aqCMf4nSd38dGy7oGb6Fn7LlumQOGdT7wg979FfYwrlNF0
         cpMA==
X-Gm-Message-State: AAQBX9feK8riRXcMNgwEQ1VXTCY9zohZbu3akIrXC6olrpQeZ8Z9nygL
        7e/FuhuQkqSmWmimDXiJC6eNBEqJrjeWXw==
X-Google-Smtp-Source: AKy350aaqPraz3/PtKZZhI3fEFZueMKfIdS4QBH8FByIjV0C1EZx6q54R3/wUeXXctSFQJo6u311qQ==
X-Received: by 2002:a17:90a:d583:b0:234:d42:1628 with SMTP id v3-20020a17090ad58300b002340d421628mr10422649pju.10.1680769787832;
        Thu, 06 Apr 2023 01:29:47 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id on13-20020a17090b1d0d00b0023493354f37sm2644433pjb.26.2023.04.06.01.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:29:46 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCHv2 net 2/3] selftests: bonding: re-format bond option tests
Date:   Thu,  6 Apr 2023 16:23:51 +0800
Message-Id: <20230406082352.986477-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230406082352.986477-1-liuhangbin@gmail.com>
References: <20230406082352.986477-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve the testing process for bond options, A new bond topology lib
is added to our testing setup. The current option_prio.sh file will be
renamed to bond_options.sh so that all bonding options can be tested here.
Specifically, for priority testing, we will run all tests using modes
1, 5, and 6. These changes will help us streamline the testing process
and ensure that our bond options are rigorously evaluated.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: fix some typos. Rename the bond_lib.sh to bond_topo_3d1c.sh and
simplify the topo with 3 slaves and 1 client. I use 3 slaves because
the prio test need that. I do not add bond_lib.sh this time as I think
there is no common functions yet. We can add the the bond_lib.sh in future
if needed.
---
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../drivers/net/bonding/bond_options.sh       | 209 +++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     | 143 ++++++++++
 .../drivers/net/bonding/option_prio.sh        | 245 ------------------
 4 files changed, 354 insertions(+), 246 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_options.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
 delete mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index a39bb2560d9b..03f92d7aeb19 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -8,11 +8,12 @@ TEST_PROGS := \
 	dev_addr_lists.sh \
 	mode-1-recovery-updelay.sh \
 	mode-2-recovery-updelay.sh \
-	option_prio.sh \
+	bond_options.sh \
 	bond-eth-type-change.sh
 
 TEST_FILES := \
 	lag_lib.sh \
+	bond_topo_3d1c.sh \
 	net_forwarding_lib.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
new file mode 100755
index 000000000000..7213211d0bde
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -0,0 +1,209 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bonding options with mode 1,5,6
+
+ALL_TESTS="
+	prio
+"
+
+REQUIRE_MZ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source ${lib_dir}/net_forwarding_lib.sh
+source ${lib_dir}/bond_topo_3d1c.sh
+
+skip_prio()
+{
+	local skip=1
+
+	# check if iproute support prio option
+	ip -n ${s_ns} link set eth0 type bond_slave prio 10
+	[[ $? -ne 0 ]] && skip=0
+
+	# check if kernel support prio option
+	ip -n ${s_ns} -d link show eth0 | grep -q "prio 10"
+	[[ $? -ne 0 ]] && skip=0
+
+	return $skip
+}
+
+skip_ns()
+{
+	local skip=1
+
+	# check if iproute support ns_ip6_target option
+	ip -n ${s_ns} link add bond1 type bond ns_ip6_target ${g_ip6}
+	[[ $? -ne 0 ]] && skip=0
+
+	# check if kernel support ns_ip6_target option
+	ip -n ${s_ns} -d link show bond1 | grep -q "ns_ip6_target ${g_ip6}"
+	[[ $? -ne 0 ]] && skip=0
+
+	ip -n ${s_ns} link del bond1
+
+	return $skip
+}
+
+active_slave=""
+check_active_slave()
+{
+	local target_active_slave=$1
+	active_slave=$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].linkinfo.info_data.active_slave")
+	test "$active_slave" = "$target_active_slave"
+	check_err $? "Current active slave is $active_slave but not $target_active_slave"
+}
+
+
+# Test bonding prio option
+prio_test()
+{
+	local param="$1"
+	RET=0
+
+	# create bond
+	bond_reset "${param}"
+
+	# check bonding member prio value
+	ip -n ${s_ns} link set eth0 type bond_slave prio 0
+	ip -n ${s_ns} link set eth1 type bond_slave prio 10
+	ip -n ${s_ns} link set eth2 type bond_slave prio 11
+	cmd_jq "ip -n ${s_ns} -d -j link show eth0" \
+		".[].linkinfo.info_slave_data | select (.prio == 0)" "-e" &> /dev/null
+	check_err $? "eth0 prio is not 0"
+	cmd_jq "ip -n ${s_ns} -d -j link show eth1" \
+		".[].linkinfo.info_slave_data | select (.prio == 10)" "-e" &> /dev/null
+	check_err $? "eth1 prio is not 10"
+	cmd_jq "ip -n ${s_ns} -d -j link show eth2" \
+		".[].linkinfo.info_slave_data | select (.prio == 11)" "-e" &> /dev/null
+	check_err $? "eth2 prio is not 11"
+
+	bond_check_connection "setup"
+
+	# active slave should be the primary slave
+	check_active_slave eth1
+
+	# active slave should be the higher prio slave
+	ip -n ${s_ns} link set $active_slave down
+	bond_check_connection "fail over"
+	check_active_slave eth2
+
+	# when only 1 slave is up
+	ip -n ${s_ns} link set $active_slave down
+	bond_check_connection "only 1 slave up"
+	check_active_slave eth0
+
+	# when a higher prio slave change to up
+	ip -n ${s_ns} link set eth2 up
+	bond_check_connection "higher prio slave up"
+	case $primary_reselect in
+		"0")
+			check_active_slave "eth2"
+			;;
+		"1")
+			check_active_slave "eth0"
+			;;
+		"2")
+			check_active_slave "eth0"
+			;;
+	esac
+	local pre_active_slave=$active_slave
+
+	# when the primary slave change to up
+	ip -n ${s_ns} link set eth1 up
+	bond_check_connection "primary slave up"
+	case $primary_reselect in
+		"0")
+			check_active_slave "eth1"
+			;;
+		"1")
+			check_active_slave "$pre_active_slave"
+			;;
+		"2")
+			check_active_slave "$pre_active_slave"
+			ip -n ${s_ns} link set $active_slave down
+			bond_check_connection "pre_active slave down"
+			check_active_slave "eth1"
+			;;
+	esac
+
+	# Test changing bond slave prio
+	if [[ "$primary_reselect" == "0" ]];then
+		ip -n ${s_ns} link set eth0 type bond_slave prio 1000000
+		ip -n ${s_ns} link set eth1 type bond_slave prio 0
+		ip -n ${s_ns} link set eth2 type bond_slave prio -50
+		ip -n ${s_ns} -d link show eth0 | grep -q 'prio 1000000'
+		check_err $? "eth0 prio is not 1000000"
+		ip -n ${s_ns} -d link show eth1 | grep -q 'prio 0'
+		check_err $? "eth1 prio is not 0"
+		ip -n ${s_ns} -d link show eth2 | grep -q 'prio -50'
+		check_err $? "eth3 prio is not -50"
+		check_active_slave "eth1"
+
+		ip -n ${s_ns} link set $active_slave down
+		bond_check_connection "change slave prio"
+		check_active_slave "eth0"
+	fi
+}
+
+prio_miimon()
+{
+	local primary_reselect
+	local mode=$1
+
+	for primary_reselect in 0 1 2; do
+		prio_test "mode $mode miimon 100 primary eth1 primary_reselect $primary_reselect"
+		log_test "prio" "$mode miimon primary_reselect $primary_reselect"
+	done
+}
+
+prio_arp()
+{
+	local primary_reselect
+	local mode=$1
+
+	for primary_reselect in 0 1 2; do
+		prio_test "mode active-backup arp_interval 100 arp_ip_target ${g_ip4} primary eth1 primary_reselect $primary_reselect"
+		log_test "prio" "$mode arp_ip_target primary_reselect $primary_reselect"
+	done
+}
+
+prio_ns()
+{
+	local primary_reselect
+	local mode=$1
+
+	if skip_ns; then
+		log_test_skip "prio ns" "Current iproute or kernel doesn't support bond option 'ns_ip6_target'."
+		return 0
+	fi
+
+	for primary_reselect in 0 1 2; do
+		prio_test "mode active-backup arp_interval 100 ns_ip6_target ${g_ip6} primary eth1 primary_reselect $primary_reselect"
+		log_test "prio" "$mode ns_ip6_target primary_reselect $primary_reselect"
+	done
+}
+
+prio()
+{
+	local mode modes="active-backup balance-tlb balance-alb"
+
+	if skip_prio; then
+		log_test_skip "prio" "Current iproute or kernel doesn't support bond option 'prio'."
+		return 0
+	fi
+
+	for mode in $modes; do
+		prio_miimon $mode
+		prio_arp $mode
+		prio_ns $mode
+	done
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
new file mode 100644
index 000000000000..4045ca97fb22
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
@@ -0,0 +1,143 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Topology for Bond mode 1,5,6 testing
+#
+#  +-------------------------------------+
+#  |                bond0                |
+#  |                  +                  |  Server
+#  |      eth0        | eth1   eth2      |  192.0.2.1/24
+#  |        +-------------------+        |  2001:db8::1/24
+#  |        |         |         |        |
+#  +-------------------------------------+
+#           |         |         |
+#  +-------------------------------------+
+#  |        |         |         |        |
+#  |    +---+---------+---------+---+    |  Gateway
+#  |    |            br0            |    |  192.0.2.254/24
+#  |    +-------------+-------------+    |  2001:db8::254/24
+#  |                  |                  |
+#  +-------------------------------------+
+#                     |
+#  +-------------------------------------+
+#  |                  |                  |  Client
+#  |                  +                  |  192.0.2.10/24
+#  |                eth0                 |  2001:db8::10/24
+#  +-------------------------------------+
+
+s_ns="s-$(mktemp -u XXXXXX)"
+c_ns="c-$(mktemp -u XXXXXX)"
+g_ns="g-$(mktemp -u XXXXXX)"
+s_ip4="192.0.2.1"
+c_ip4="192.0.2.10"
+g_ip4="192.0.2.254"
+s_ip6="2001:db8::1"
+c_ip6="2001:db8::10"
+g_ip6="2001:db8::254"
+
+gateway_create()
+{
+	ip netns add ${g_ns}
+	ip -n ${g_ns} link add br0 type bridge
+	ip -n ${g_ns} link set br0 up
+	ip -n ${g_ns} addr add ${g_ip4}/24 dev br0
+	ip -n ${g_ns} addr add ${g_ip6}/24 dev br0
+}
+
+gateway_destroy()
+{
+	ip -n ${g_ns} link del br0
+	ip netns del ${g_ns}
+}
+
+server_create()
+{
+	ip netns add ${s_ns}
+	ip -n ${s_ns} link add bond0 type bond mode active-backup miimon 100
+
+	for i in $(seq 0 2); do
+		ip -n ${s_ns} link add eth${i} type veth peer name s${i} netns ${g_ns}
+
+		ip -n ${g_ns} link set s${i} up
+		ip -n ${g_ns} link set s${i} master br0
+		ip -n ${s_ns} link set eth${i} master bond0
+	done
+
+	ip -n ${s_ns} link set bond0 up
+	ip -n ${s_ns} addr add ${s_ip4}/24 dev bond0
+	ip -n ${s_ns} addr add ${s_ip6}/24 dev bond0
+	sleep 2
+}
+
+# Reset bond with new mode and options
+bond_reset()
+{
+	local param="$1"
+
+	ip -n ${s_ns} link set bond0 down
+	ip -n ${s_ns} link del bond0
+
+	ip -n ${s_ns} link add bond0 type bond $param
+	for i in $(seq 0 2); do
+		ip -n ${s_ns} link set eth$i master bond0
+	done
+
+	ip -n ${s_ns} link set bond0 up
+	ip -n ${s_ns} addr add ${s_ip4}/24 dev bond0
+	ip -n ${s_ns} addr add ${s_ip6}/24 dev bond0
+	sleep 2
+}
+
+server_destroy()
+{
+	for i in $(seq 0 2); do
+		ip -n ${s_ns} link del eth${i}
+	done
+	ip netns del ${s_ns}
+}
+
+client_create()
+{
+	ip netns add ${c_ns}
+	ip -n ${c_ns} link add eth0 type veth peer name c0 netns ${g_ns}
+
+	ip -n ${g_ns} link set c0 up
+	ip -n ${g_ns} link set c0 master br0
+
+	ip -n ${c_ns} link set eth0 up
+	ip -n ${c_ns} addr add ${c_ip4}/24 dev eth0
+	ip -n ${c_ns} addr add ${c_ip6}/24 dev eth0
+}
+
+client_destroy()
+{
+	ip -n ${c_ns} link del eth0
+	ip netns del ${c_ns}
+}
+
+setup_prepare()
+{
+	gateway_create
+	server_create
+	client_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	client_destroy
+	server_destroy
+	gateway_destroy
+}
+
+bond_check_connection()
+{
+	local msg=${1:-"check connection"}
+
+	sleep 2
+	ip netns exec ${s_ns} ping ${c_ip4} -c5 -i 0.1 &>/dev/null
+	check_err $? "${msg}: ping failed"
+	ip netns exec ${s_ns} ping6 ${c_ip6} -c5 -i 0.1 &>/dev/null
+	check_err $? "${msg}: ping6 failed"
+}
diff --git a/tools/testing/selftests/drivers/net/bonding/option_prio.sh b/tools/testing/selftests/drivers/net/bonding/option_prio.sh
deleted file mode 100755
index c32eebff5005..000000000000
--- a/tools/testing/selftests/drivers/net/bonding/option_prio.sh
+++ /dev/null
@@ -1,245 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#
-# Test bonding option prio
-#
-
-ALL_TESTS="
-	prio_arp_ip_target_test
-	prio_miimon_test
-"
-
-REQUIRE_MZ=no
-REQUIRE_JQ=no
-NUM_NETIFS=0
-lib_dir=$(dirname "$0")
-source "$lib_dir"/net_forwarding_lib.sh
-
-destroy()
-{
-	ip link del bond0 &>/dev/null
-	ip link del br0 &>/dev/null
-	ip link del veth0 &>/dev/null
-	ip link del veth1 &>/dev/null
-	ip link del veth2 &>/dev/null
-	ip netns del ns1 &>/dev/null
-	ip link del veth3 &>/dev/null
-}
-
-cleanup()
-{
-	pre_cleanup
-
-	destroy
-}
-
-skip()
-{
-        local skip=1
-	ip link add name bond0 type bond mode 1 miimon 100 &>/dev/null
-	ip link add name veth0 type veth peer name veth0_p
-	ip link set veth0 master bond0
-
-	# check if iproute support prio option
-	ip link set dev veth0 type bond_slave prio 10
-	[[ $? -ne 0 ]] && skip=0
-
-	# check if bonding support prio option
-	ip -d link show veth0 | grep -q "prio 10"
-	[[ $? -ne 0 ]] && skip=0
-
-	ip link del bond0 &>/dev/null
-	ip link del veth0
-
-	return $skip
-}
-
-active_slave=""
-check_active_slave()
-{
-	local target_active_slave=$1
-	active_slave="$(cat /sys/class/net/bond0/bonding/active_slave)"
-	test "$active_slave" = "$target_active_slave"
-	check_err $? "Current active slave is $active_slave but not $target_active_slave"
-}
-
-
-# Test bonding prio option with mode=$mode monitor=$monitor
-# and primary_reselect=$primary_reselect
-prio_test()
-{
-	RET=0
-
-	local monitor=$1
-	local mode=$2
-	local primary_reselect=$3
-
-	local bond_ip4="192.169.1.2"
-	local peer_ip4="192.169.1.1"
-	local bond_ip6="2009:0a:0b::02"
-	local peer_ip6="2009:0a:0b::01"
-
-
-	# create veths
-	ip link add name veth0 type veth peer name veth0_p
-	ip link add name veth1 type veth peer name veth1_p
-	ip link add name veth2 type veth peer name veth2_p
-
-	# create bond
-	if [[ "$monitor" == "miimon" ]];then
-		ip link add name bond0 type bond mode $mode miimon 100 primary veth1 primary_reselect $primary_reselect
-	elif [[ "$monitor" == "arp_ip_target" ]];then
-		ip link add name bond0 type bond mode $mode arp_interval 1000 arp_ip_target $peer_ip4 primary veth1 primary_reselect $primary_reselect
-	elif [[ "$monitor" == "ns_ip6_target" ]];then
-		ip link add name bond0 type bond mode $mode arp_interval 1000 ns_ip6_target $peer_ip6 primary veth1 primary_reselect $primary_reselect
-	fi
-	ip link set bond0 up
-	ip link set veth0 master bond0
-	ip link set veth1 master bond0
-	ip link set veth2 master bond0
-	# check bonding member prio value
-	ip link set dev veth0 type bond_slave prio 0
-	ip link set dev veth1 type bond_slave prio 10
-	ip link set dev veth2 type bond_slave prio 11
-	ip -d link show veth0 | grep -q 'prio 0'
-	check_err $? "veth0 prio is not 0"
-	ip -d link show veth1 | grep -q 'prio 10'
-	check_err $? "veth0 prio is not 10"
-	ip -d link show veth2 | grep -q 'prio 11'
-	check_err $? "veth0 prio is not 11"
-
-	ip link set veth0 up
-	ip link set veth1 up
-	ip link set veth2 up
-	ip link set veth0_p up
-	ip link set veth1_p up
-	ip link set veth2_p up
-
-	# prepare ping target
-	ip link add name br0 type bridge
-	ip link set br0 up
-	ip link set veth0_p master br0
-	ip link set veth1_p master br0
-	ip link set veth2_p master br0
-	ip link add name veth3 type veth peer name veth3_p
-	ip netns add ns1
-	ip link set veth3_p master br0 up
-	ip link set veth3 netns ns1 up
-	ip netns exec ns1 ip addr add $peer_ip4/24 dev veth3
-	ip netns exec ns1 ip addr add $peer_ip6/64 dev veth3
-	ip addr add $bond_ip4/24 dev bond0
-	ip addr add $bond_ip6/64 dev bond0
-	sleep 5
-
-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
-	check_err $? "ping failed 1."
-	ping6 $peer_ip6 -c5 -I bond0 &>/dev/null
-	check_err $? "ping6 failed 1."
-
-	# active salve should be the primary slave
-	check_active_slave veth1
-
-	# active slave should be the higher prio slave
-	ip link set $active_slave down
-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
-	check_err $? "ping failed 2."
-	check_active_slave veth2
-
-	# when only 1 slave is up
-	ip link set $active_slave down
-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
-	check_err $? "ping failed 3."
-	check_active_slave veth0
-
-	# when a higher prio slave change to up
-	ip link set veth2 up
-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
-	check_err $? "ping failed 4."
-	case $primary_reselect in
-		"0")
-			check_active_slave "veth2"
-			;;
-		"1")
-			check_active_slave "veth0"
-			;;
-		"2")
-			check_active_slave "veth0"
-			;;
-	esac
-	local pre_active_slave=$active_slave
-
-	# when the primary slave change to up
-	ip link set veth1 up
-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
-	check_err $? "ping failed 5."
-	case $primary_reselect in
-		"0")
-			check_active_slave "veth1"
-			;;
-		"1")
-			check_active_slave "$pre_active_slave"
-			;;
-		"2")
-			check_active_slave "$pre_active_slave"
-			ip link set $active_slave down
-			ping $peer_ip4 -c5 -I bond0 &>/dev/null
-			check_err $? "ping failed 6."
-			check_active_slave "veth1"
-			;;
-	esac
-
-	# Test changing bond salve prio
-	if [[ "$primary_reselect" == "0" ]];then
-		ip link set dev veth0 type bond_slave prio 1000000
-		ip link set dev veth1 type bond_slave prio 0
-		ip link set dev veth2 type bond_slave prio -50
-		ip -d link show veth0 | grep -q 'prio 1000000'
-		check_err $? "veth0 prio is not 1000000"
-		ip -d link show veth1 | grep -q 'prio 0'
-		check_err $? "veth1 prio is not 0"
-		ip -d link show veth2 | grep -q 'prio -50'
-		check_err $? "veth3 prio is not -50"
-		check_active_slave "veth1"
-
-		ip link set $active_slave down
-		ping $peer_ip4 -c5 -I bond0 &>/dev/null
-		check_err $? "ping failed 7."
-		check_active_slave "veth0"
-	fi
-
-	cleanup
-
-	log_test "prio_test" "Test bonding option 'prio' with mode=$mode monitor=$monitor and primary_reselect=$primary_reselect"
-}
-
-prio_miimon_test()
-{
-	local mode
-	local primary_reselect
-
-	for mode in 1 5 6; do
-		for primary_reselect in 0 1 2; do
-			prio_test "miimon" $mode $primary_reselect
-		done
-	done
-}
-
-prio_arp_ip_target_test()
-{
-	local primary_reselect
-
-	for primary_reselect in 0 1 2; do
-		prio_test "arp_ip_target" 1 $primary_reselect
-	done
-}
-
-if skip;then
-	log_test_skip "option_prio.sh" "Current iproute doesn't support 'prio'."
-	exit 0
-fi
-
-trap cleanup EXIT
-
-tests_run
-
-exit "$EXIT_STATUS"
-- 
2.38.1

