Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FEA3D0260
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhGTTO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:14:28 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37795 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhGTTNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:13:14 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 0E4462012360;
        Tue, 20 Jul 2021 21:43:27 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 0E4462012360
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626810207;
        bh=pub+UQe7ZerW1wdRbaqtceSx9G74A2RNVNhQbMKecao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyZ6IGpwntIbC30zi6YyavCmqqO6sQGh5hk2T3l3drt+SuW4zR/GcJIXki7V8jogL
         JnetDaI9oDbmUBvZvUMODYlpevpPmzQlCg0esaHo/I6Gg8UkIOdWezsp3dxQtqoswl
         rh9g9UreYTMB36A7/ILTiP00UVDktp1Civ7H7teL2p07FdY5IYmgBDt3Tn8MzTP1gC
         svgS6zlIblIy8tuK+M/i0viC2dR+dg5tbFv6tG6Tl5bEyVTe2M9LBK+6Ltvs1/ckeK
         HUEbecbFR9kA28PsfvKVTSrbqIQ6ggNjT1lYJFT71Z+C6GNLrXhV7PmEiSrsQajnfr
         kiB1Oy1vJ2u3w==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, justin.iurman@uliege.be
Subject: [PATCH net-next v5 6/6] selftests: net: Test for the IOAM insertion with IPv6
Date:   Tue, 20 Jul 2021 21:43:01 +0200
Message-Id: <20210720194301.23243-7-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720194301.23243-1-justin.iurman@uliege.be>
References: <20210720194301.23243-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test evaluates the IOAM insertion for IPv6 by checking the IOAM data
integrity on the receiver.

The topology is formed by 3 nodes: Alpha (sender), Beta (router in-between)
and Gamma (receiver). An IOAM domain is configured from Alpha to Gamma only,
which means not on the reverse path. When Gamma is the destination, Alpha
adds an IOAM option (Pre-allocated Trace) inside a Hop-by-hop and fills the
trace with its own IOAM data. Beta and Gamma also fill the trace. The IOAM
data integrity is checked on Gamma, by comparing with the pre-defined IOAM
configuration (see below).

    +-------------------+            +-------------------+
    |                   |            |                   |
    |    alpha netns    |            |    gamma netns    |
    |                   |            |                   |
    |  +-------------+  |            |  +-------------+  |
    |  |    veth0    |  |            |  |    veth0    |  |
    |  |  db01::2/64 |  |            |  |  db02::2/64 |  |
    |  +-------------+  |            |  +-------------+  |
    |         .         |            |         .         |
    +-------------------+            +-------------------+
              .                                .
              .                                .
              .                                .
    +----------------------------------------------------+
    |         .                                .         |
    |  +-------------+                  +-------------+  |
    |  |    veth0    |                  |    veth1    |  |
    |  |  db01::1/64 | ................ |  db02::1/64 |  |
    |  +-------------+                  +-------------+  |
    |                                                    |
    |                      beta netns                    |
    |                                                    |
    +--------------------------+-------------------------+

~~~~~~~~~~~~~~~~~~~~~~
| IOAM configuration |
~~~~~~~~~~~~~~~~~~~~~~

Alpha
+-----------------------------------------------------------+
| Type                | Value                               |
+-----------------------------------------------------------+
| Node ID             | 1                                   |
+-----------------------------------------------------------+
| Node Wide ID        | 11111111                            |
+-----------------------------------------------------------+
| Ingress ID          | 0xffff (default value)              |
+-----------------------------------------------------------+
| Ingress Wide ID     | 0xffffffff (default value)          |
+-----------------------------------------------------------+
| Egress ID           | 101                                 |
+-----------------------------------------------------------+
| Egress Wide ID      | 101101                              |
+-----------------------------------------------------------+
| Namespace Data      | 0xdeadbee0                          |
+-----------------------------------------------------------+
| Namespace Wide Data | 0xcafec0caf00dc0de                  |
+-----------------------------------------------------------+
| Schema ID           | 777                                 |
+-----------------------------------------------------------+
| Schema Data         | something that will be 4n-aligned   |
+-----------------------------------------------------------+

Note: When Gamma is the destination, Alpha adds an IOAM Pre-allocated Trace
      option inside a Hop-by-hop, where 164 bytes are pre-allocated for the
      trace, with 123 as the IOAM-Namespace and with 0xfff00200 as the trace
      type (= all available options at this time). As a result, and based on
      IOAM configurations here, only both Alpha and Beta should be capable of
      inserting their IOAM data while Gamma won't have enough space and will
      set the overflow bit.

Beta
+-----------------------------------------------------------+
| Type                | Value                               |
+-----------------------------------------------------------+
| Node ID             | 2                                   |
+-----------------------------------------------------------+
| Node Wide ID        | 22222222                            |
+-----------------------------------------------------------+
| Ingress ID          | 201                                 |
+-----------------------------------------------------------+
| Ingress Wide ID     | 201201                              |
+-----------------------------------------------------------+
| Egress ID           | 202                                 |
+-----------------------------------------------------------+
| Egress Wide ID      | 202202                              |
+-----------------------------------------------------------+
| Namespace Data      | 0xdeadbee1                          |
+-----------------------------------------------------------+
| Namespace Wide Data | 0xcafec0caf11dc0de                  |
+-----------------------------------------------------------+
| Schema ID           | 0xffffff (= None)                   |
+-----------------------------------------------------------+
| Schema Data         |                                     |
+-----------------------------------------------------------+

Gamma
+-----------------------------------------------------------+
| Type                | Value                               |
+-----------------------------------------------------------+
| Node ID             | 3                                   |
+-----------------------------------------------------------+
| Node Wide ID        | 33333333                            |
+-----------------------------------------------------------+
| Ingress ID          | 301                                 |
+-----------------------------------------------------------+
| Ingress Wide ID     | 301301                              |
+-----------------------------------------------------------+
| Egress ID           | 0xffff (default value)              |
+-----------------------------------------------------------+
| Egress Wide ID      | 0xffffffff (default value)          |
+-----------------------------------------------------------+
| Namespace Data      | 0xdeadbee2                          |
+-----------------------------------------------------------+
| Namespace Wide Data | 0xcafec0caf22dc0de                  |
+-----------------------------------------------------------+
| Schema ID           | 0xffffff (= None)                   |
+-----------------------------------------------------------+
| Schema Data         |                                     |
+-----------------------------------------------------------+

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/config         |   1 +
 tools/testing/selftests/net/ioam6.sh       | 298 +++++++++++++++
 tools/testing/selftests/net/ioam6_parser.c | 403 +++++++++++++++++++++
 4 files changed, 704 insertions(+)
 create mode 100644 tools/testing/selftests/net/ioam6.sh
 create mode 100644 tools/testing/selftests/net/ioam6_parser.c

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 79c9eb0034d5..5b169e915679 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -25,6 +25,7 @@ TEST_PROGS += bareudp.sh
 TEST_PROGS += unicast_extensions.sh
 TEST_PROGS += udpgro_fwd.sh
 TEST_PROGS += veth.sh
+TEST_PROGS += ioam6.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
@@ -36,6 +37,7 @@ TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_FILES += reuseaddr_ports_exhausted
 TEST_GEN_FILES += hwtstamp_config rxtimestamp timestamping txtimestamp
 TEST_GEN_FILES += ipsec
+TEST_GEN_FILES += ioam6_parser
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 6f905b53904f..21b646d10b88 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -42,3 +42,4 @@ CONFIG_NET_CLS_FLOWER=m
 CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
+CONFIG_IPV6_IOAM6_LWTUNNEL=y
diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
new file mode 100644
index 000000000000..928b3510898c
--- /dev/null
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -0,0 +1,298 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Author: Justin Iurman <justin.iurman@uliege.be>
+#
+# This test evaluates the IOAM insertion for IPv6 by checking the IOAM data
+# integrity on the receiver.
+#
+# The topology is formed by 3 nodes: Alpha (sender), Beta (router in-between)
+# and Gamma (receiver). An IOAM domain is configured from Alpha to Gamma only,
+# which means not on the reverse path. When Gamma is the destination, Alpha
+# adds an IOAM option (Pre-allocated Trace) inside a Hop-by-hop and fills the
+# trace with its own IOAM data. Beta and Gamma also fill the trace. The IOAM
+# data integrity is checked on Gamma, by comparing with the pre-defined IOAM
+# configuration (see below).
+#
+#     +-------------------+            +-------------------+
+#     |                   |            |                   |
+#     |    alpha netns    |            |    gamma netns    |
+#     |                   |            |                   |
+#     |  +-------------+  |            |  +-------------+  |
+#     |  |    veth0    |  |            |  |    veth0    |  |
+#     |  |  db01::2/64 |  |            |  |  db02::2/64 |  |
+#     |  +-------------+  |            |  +-------------+  |
+#     |         .         |            |         .         |
+#     +-------------------+            +-------------------+
+#               .                                .
+#               .                                .
+#               .                                .
+#     +----------------------------------------------------+
+#     |         .                                .         |
+#     |  +-------------+                  +-------------+  |
+#     |  |    veth0    |                  |    veth1    |  |
+#     |  |  db01::1/64 | ................ |  db02::1/64 |  |
+#     |  +-------------+                  +-------------+  |
+#     |                                                    |
+#     |                      beta netns                    |
+#     |                                                    |
+#     +--------------------------+-------------------------+
+#
+#
+# ~~~~~~~~~~~~~~~~~~~~~~
+# | IOAM configuration |
+# ~~~~~~~~~~~~~~~~~~~~~~
+#
+# Alpha
+# +-----------------------------------------------------------+
+# | Type                | Value                               |
+# +-----------------------------------------------------------+
+# | Node ID             | 1                                   |
+# +-----------------------------------------------------------+
+# | Node Wide ID        | 11111111                            |
+# +-----------------------------------------------------------+
+# | Ingress ID          | 0xffff (default value)              |
+# +-----------------------------------------------------------+
+# | Ingress Wide ID     | 0xffffffff (default value)          |
+# +-----------------------------------------------------------+
+# | Egress ID           | 101                                 |
+# +-----------------------------------------------------------+
+# | Egress Wide ID      | 101101                              |
+# +-----------------------------------------------------------+
+# | Namespace Data      | 0xdeadbee0                          |
+# +-----------------------------------------------------------+
+# | Namespace Wide Data | 0xcafec0caf00dc0de                  |
+# +-----------------------------------------------------------+
+# | Schema ID           | 777                                 |
+# +-----------------------------------------------------------+
+# | Schema Data         | something that will be 4n-aligned   |
+# +-----------------------------------------------------------+
+#
+# Note: When Gamma is the destination, Alpha adds an IOAM Pre-allocated Trace
+#       option inside a Hop-by-hop, where 164 bytes are pre-allocated for the
+#       trace, with 123 as the IOAM-Namespace and with 0xfff00200 as the trace
+#       type (= all available options at this time). As a result, and based on
+#       IOAM configurations here, only both Alpha and Beta should be capable of
+#       inserting their IOAM data while Gamma won't have enough space and will
+#       set the overflow bit.
+#
+# Beta
+# +-----------------------------------------------------------+
+# | Type                | Value                               |
+# +-----------------------------------------------------------+
+# | Node ID             | 2                                   |
+# +-----------------------------------------------------------+
+# | Node Wide ID        | 22222222                            |
+# +-----------------------------------------------------------+
+# | Ingress ID          | 201                                 |
+# +-----------------------------------------------------------+
+# | Ingress Wide ID     | 201201                              |
+# +-----------------------------------------------------------+
+# | Egress ID           | 202                                 |
+# +-----------------------------------------------------------+
+# | Egress Wide ID      | 202202                              |
+# +-----------------------------------------------------------+
+# | Namespace Data      | 0xdeadbee1                          |
+# +-----------------------------------------------------------+
+# | Namespace Wide Data | 0xcafec0caf11dc0de                  |
+# +-----------------------------------------------------------+
+# | Schema ID           | 0xffffff (= None)                   |
+# +-----------------------------------------------------------+
+# | Schema Data         |                                     |
+# +-----------------------------------------------------------+
+#
+# Gamma
+# +-----------------------------------------------------------+
+# | Type                | Value                               |
+# +-----------------------------------------------------------+
+# | Node ID             | 3                                   |
+# +-----------------------------------------------------------+
+# | Node Wide ID        | 33333333                            |
+# +-----------------------------------------------------------+
+# | Ingress ID          | 301                                 |
+# +-----------------------------------------------------------+
+# | Ingress Wide ID     | 301301                              |
+# +-----------------------------------------------------------+
+# | Egress ID           | 0xffff (default value)              |
+# +-----------------------------------------------------------+
+# | Egress Wide ID      | 0xffffffff (default value)          |
+# +-----------------------------------------------------------+
+# | Namespace Data      | 0xdeadbee2                          |
+# +-----------------------------------------------------------+
+# | Namespace Wide Data | 0xcafec0caf22dc0de                  |
+# +-----------------------------------------------------------+
+# | Schema ID           | 0xffffff (= None)                   |
+# +-----------------------------------------------------------+
+# | Schema Data         |                                     |
+# +-----------------------------------------------------------+
+
+#===============================================================================
+#
+# WARNING:
+# Do NOT modify the following configuration unless you know what you're doing.
+#
+IOAM_NAMESPACE=123
+IOAM_TRACE_TYPE=0xfff00200
+IOAM_PREALLOC_DATA_SIZE=164
+
+ALPHA=(
+	1					# ID
+	11111111				# Wide ID
+	0xffff					# Ingress ID
+	0xffffffff				# Ingress Wide ID
+	101					# Egress ID
+	101101					# Egress Wide ID
+	0xdeadbee0				# Namespace Data
+	0xcafec0caf00dc0de			# Namespace Wide Data
+	777					# Schema ID (0xffffff = None)
+	"something that will be 4n-aligned"	# Schema Data
+)
+
+BETA=(
+	2
+	22222222
+	201
+	201201
+	202
+	202202
+	0xdeadbee1
+	0xcafec0caf11dc0de
+	0xffffff
+	""
+)
+
+GAMMA=(
+	3
+	33333333
+	301
+	301301
+	0xffff
+	0xffffffff
+	0xdeadbee2
+	0xcafec0caf22dc0de
+	0xffffff
+	""
+)
+#===============================================================================
+
+if [ "$(id -u)" -ne 0 ]; then
+  echo "SKIP: Need root privileges"
+  exit 1
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+  echo "SKIP: Could not run test without ip tool"
+  exit 1
+fi
+
+ip ioam &>/dev/null
+if [ $? = 1 ]; then
+  echo "SKIP: ip tool must include IOAM"
+  exit 1
+fi
+
+if [ ! -e /proc/sys/net/ipv6/ioam6_id ]; then
+  echo "SKIP: ioam6 sysctls do not exist"
+  exit 1
+fi
+
+cleanup()
+{
+  ip link del ioam-veth-alpha 2>/dev/null || true
+  ip link del ioam-veth-gamma 2>/dev/null || true
+
+  ip netns del ioam-node-alpha || true
+  ip netns del ioam-node-beta || true
+  ip netns del ioam-node-gamma || true
+}
+
+setup()
+{
+  ip netns add ioam-node-alpha
+  ip netns add ioam-node-beta
+  ip netns add ioam-node-gamma
+
+  ip link add name ioam-veth-alpha type veth peer name ioam-veth-betaL
+  ip link add name ioam-veth-betaR type veth peer name ioam-veth-gamma
+
+  ip link set ioam-veth-alpha netns ioam-node-alpha
+  ip link set ioam-veth-betaL netns ioam-node-beta
+  ip link set ioam-veth-betaR netns ioam-node-beta
+  ip link set ioam-veth-gamma netns ioam-node-gamma
+
+  ip -netns ioam-node-alpha link set ioam-veth-alpha name veth0
+  ip -netns ioam-node-beta link set ioam-veth-betaL name veth0
+  ip -netns ioam-node-beta link set ioam-veth-betaR name veth1
+  ip -netns ioam-node-gamma link set ioam-veth-gamma name veth0
+
+  ip -netns ioam-node-alpha addr add db01::2/64 dev veth0
+  ip -netns ioam-node-alpha link set veth0 up
+  ip -netns ioam-node-alpha link set lo up
+  ip -netns ioam-node-alpha route add default via db01::1
+
+  ip -netns ioam-node-beta addr add db01::1/64 dev veth0
+  ip -netns ioam-node-beta addr add db02::1/64 dev veth1
+  ip -netns ioam-node-beta link set veth0 up
+  ip -netns ioam-node-beta link set veth1 up
+  ip -netns ioam-node-beta link set lo up
+
+  ip -netns ioam-node-gamma addr add db02::2/64 dev veth0
+  ip -netns ioam-node-gamma link set veth0 up
+  ip -netns ioam-node-gamma link set lo up
+  ip -netns ioam-node-gamma route add default via db02::1
+
+  # - IOAM config -
+  ip netns exec ioam-node-alpha sysctl -wq net.ipv6.ioam6_id=${ALPHA[0]}
+  ip netns exec ioam-node-alpha sysctl -wq net.ipv6.ioam6_id_wide=${ALPHA[1]}
+  ip netns exec ioam-node-alpha sysctl -wq net.ipv6.conf.veth0.ioam6_id=${ALPHA[4]}
+  ip netns exec ioam-node-alpha sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${ALPHA[5]}
+  ip -netns ioam-node-alpha ioam namespace add ${IOAM_NAMESPACE} data ${ALPHA[6]} wide ${ALPHA[7]}
+  ip -netns ioam-node-alpha ioam schema add ${ALPHA[8]} "${ALPHA[9]}"
+  ip -netns ioam-node-alpha ioam namespace set ${IOAM_NAMESPACE} schema ${ALPHA[8]}
+  ip -netns ioam-node-alpha route add db02::/64 encap ioam6 trace type ${IOAM_TRACE_TYPE:0:-2} ns ${IOAM_NAMESPACE} size ${IOAM_PREALLOC_DATA_SIZE} via db01::1 dev veth0
+
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.all.forwarding=1
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.ioam6_id=${BETA[0]}
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.ioam6_id_wide=${BETA[1]}
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_enabled=1
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_id=${BETA[2]}
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${BETA[3]}
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth1.ioam6_id=${BETA[4]}
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth1.ioam6_id_wide=${BETA[5]}
+  ip -netns ioam-node-beta ioam namespace add ${IOAM_NAMESPACE} data ${BETA[6]} wide ${BETA[7]}
+
+  ip netns exec ioam-node-gamma sysctl -wq net.ipv6.ioam6_id=${GAMMA[0]}
+  ip netns exec ioam-node-gamma sysctl -wq net.ipv6.ioam6_id_wide=${GAMMA[1]}
+  ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_enabled=1
+  ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_id=${GAMMA[2]}
+  ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${GAMMA[3]}
+  ip -netns ioam-node-gamma ioam namespace add ${IOAM_NAMESPACE} data ${GAMMA[6]} wide ${GAMMA[7]}
+}
+
+run()
+{
+  echo -n "IOAM test... "
+
+  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
+  if [ $? != 0 ]; then
+    echo "FAILED"
+    cleanup &>/dev/null
+    exit 0
+  fi
+
+  ip netns exec ioam-node-gamma ./ioam6_parser veth0 2 ${IOAM_NAMESPACE} ${IOAM_TRACE_TYPE} 64 ${ALPHA[0]} ${ALPHA[1]} ${ALPHA[2]} ${ALPHA[3]} ${ALPHA[4]} ${ALPHA[5]} ${ALPHA[6]} ${ALPHA[7]} ${ALPHA[8]} "${ALPHA[9]}" 63 ${BETA[0]} ${BETA[1]} ${BETA[2]} ${BETA[3]} ${BETA[4]} ${BETA[5]} ${BETA[6]} ${BETA[7]} ${BETA[8]} &
+
+  local spid=$!
+  sleep 0.1
+
+  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
+
+  wait $spid
+  [ $? = 0 ] && echo "PASSED" || echo "FAILED"
+}
+
+cleanup &>/dev/null
+setup
+run
+cleanup &>/dev/null
+
diff --git a/tools/testing/selftests/net/ioam6_parser.c b/tools/testing/selftests/net/ioam6_parser.c
new file mode 100644
index 000000000000..b0a89d544bc8
--- /dev/null
+++ b/tools/testing/selftests/net/ioam6_parser.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Author: Justin Iurman (justin.iurman@uliege.be)
+ *
+ * IOAM parser for IPv6, see ioam6.sh for details.
+ */
+#include <asm/byteorder.h>
+#include <linux/const.h>
+#include <linux/if_ether.h>
+#include <linux/ioam6.h>
+#include <linux/ipv6.h>
+#include <sys/socket.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+struct node_args {
+	__u32 id;
+	__u64 wide;
+	__u16 ingr_id;
+	__u16 egr_id;
+	__u32 ingr_wide;
+	__u32 egr_wide;
+	__u32 ns_data;
+	__u64 ns_wide;
+	__u32 sc_id;
+	__u8 hop_limit;
+	__u8 *sc_data; /* NULL when sc_id = 0xffffff (default empty value) */
+};
+
+/* expected args per node, in that order */
+enum {
+	NODE_ARG_HOP_LIMIT,
+	NODE_ARG_ID,
+	NODE_ARG_WIDE,
+	NODE_ARG_INGR_ID,
+	NODE_ARG_INGR_WIDE,
+	NODE_ARG_EGR_ID,
+	NODE_ARG_EGR_WIDE,
+	NODE_ARG_NS_DATA,
+	NODE_ARG_NS_WIDE,
+	NODE_ARG_SC_ID,
+	__NODE_ARG_MAX,
+};
+
+#define NODE_ARGS_SIZE __NODE_ARG_MAX
+
+struct args {
+	__u16 ns_id;
+	__u32 trace_type;
+	__u8 n_node;
+	__u8 *ifname;
+	struct node_args node[0];
+};
+
+/* expected args, in that order */
+enum {
+	ARG_IFNAME,
+	ARG_N_NODE,
+	ARG_NS_ID,
+	ARG_TRACE_TYPE,
+	__ARG_MAX,
+};
+
+#define ARGS_SIZE __ARG_MAX
+
+int check_ioam6_node_data(__u8 **p, struct ioam6_trace_hdr *trace, __u8 hlim,
+			  __u32 id, __u64 wide, __u16 ingr_id, __u32 ingr_wide,
+			  __u16 egr_id, __u32 egr_wide, __u32 ns_data,
+			  __u64 ns_wide, __u32 sc_id, __u8 *sc_data)
+{
+	__u64 raw64;
+	__u32 raw32;
+	__u8 sc_len;
+
+	if (trace->type.bit0) {
+		raw32 = __be32_to_cpu(*((__u32 *)*p));
+		if (hlim != (raw32 >> 24) || id != (raw32 & 0xffffff))
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit1) {
+		raw32 = __be32_to_cpu(*((__u32 *)*p));
+		if (ingr_id != (raw32 >> 16) || egr_id != (raw32 & 0xffff))
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit2)
+		*p += sizeof(__u32);
+
+	if (trace->type.bit3)
+		*p += sizeof(__u32);
+
+	if (trace->type.bit4) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit5) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != ns_data)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit6) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit7) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit8) {
+		raw64 = __be64_to_cpu(*((__u64 *)*p));
+		if (hlim != (raw64 >> 56) || wide != (raw64 & 0xffffffffffffff))
+			return 1;
+		*p += sizeof(__u64);
+	}
+
+	if (trace->type.bit9) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != ingr_wide)
+			return 1;
+		*p += sizeof(__u32);
+
+		if (__be32_to_cpu(*((__u32 *)*p)) != egr_wide)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit10) {
+		if (__be64_to_cpu(*((__u64 *)*p)) != ns_wide)
+			return 1;
+		*p += sizeof(__u64);
+	}
+
+	if (trace->type.bit11) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (trace->type.bit22) {
+		raw32 = __be32_to_cpu(*((__u32 *)*p));
+		sc_len = sc_data ? __ALIGN_KERNEL(strlen(sc_data), 4) : 0;
+		if (sc_len != (raw32 >> 24) * 4 || sc_id != (raw32 & 0xffffff))
+			return 1;
+		*p += sizeof(__u32);
+
+		if (sc_data) {
+			if (strncmp(*p, sc_data, strlen(sc_data)))
+				return 1;
+
+			*p += strlen(sc_data);
+			sc_len -= strlen(sc_data);
+
+			while (sc_len--) {
+				if (**p != '\0')
+					return 1;
+				*p += sizeof(__u8);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int check_ioam6_trace(struct ioam6_trace_hdr *trace, struct args *args)
+{
+	__u8 *p;
+	int i;
+
+	if (__be16_to_cpu(trace->namespace_id) != args->ns_id ||
+	    __be32_to_cpu(trace->type_be32) != args->trace_type)
+		return 1;
+
+	p = trace->data + trace->remlen * 4;
+
+	for (i = args->n_node - 1; i >= 0; i--) {
+		if (check_ioam6_node_data(&p, trace,
+					  args->node[i].hop_limit,
+					  args->node[i].id,
+					  args->node[i].wide,
+					  args->node[i].ingr_id,
+					  args->node[i].ingr_wide,
+					  args->node[i].egr_id,
+					  args->node[i].egr_wide,
+					  args->node[i].ns_data,
+					  args->node[i].ns_wide,
+					  args->node[i].sc_id,
+					  args->node[i].sc_data))
+			return 1;
+	}
+
+	return 0;
+}
+
+int parse_node_args(int *argcp, char ***argvp, struct node_args *node)
+{
+	char **argv = *argvp;
+
+	if (*argcp < NODE_ARGS_SIZE)
+		return 1;
+
+	node->hop_limit = strtoul(argv[NODE_ARG_HOP_LIMIT], NULL, 10);
+	if (!node->hop_limit) {
+		node->hop_limit = strtoul(argv[NODE_ARG_HOP_LIMIT], NULL, 16);
+		if (!node->hop_limit)
+			return 1;
+	}
+
+	node->id = strtoul(argv[NODE_ARG_ID], NULL, 10);
+	if (!node->id) {
+		node->id = strtoul(argv[NODE_ARG_ID], NULL, 16);
+		if (!node->id)
+			return 1;
+	}
+
+	node->wide = strtoull(argv[NODE_ARG_WIDE], NULL, 10);
+	if (!node->wide) {
+		node->wide = strtoull(argv[NODE_ARG_WIDE], NULL, 16);
+		if (!node->wide)
+			return 1;
+	}
+
+	node->ingr_id = strtoul(argv[NODE_ARG_INGR_ID], NULL, 10);
+	if (!node->ingr_id) {
+		node->ingr_id = strtoul(argv[NODE_ARG_INGR_ID], NULL, 16);
+		if (!node->ingr_id)
+			return 1;
+	}
+
+	node->ingr_wide = strtoul(argv[NODE_ARG_INGR_WIDE], NULL, 10);
+	if (!node->ingr_wide) {
+		node->ingr_wide = strtoul(argv[NODE_ARG_INGR_WIDE], NULL, 16);
+		if (!node->ingr_wide)
+			return 1;
+	}
+
+	node->egr_id = strtoul(argv[NODE_ARG_EGR_ID], NULL, 10);
+	if (!node->egr_id) {
+		node->egr_id = strtoul(argv[NODE_ARG_EGR_ID], NULL, 16);
+		if (!node->egr_id)
+			return 1;
+	}
+
+	node->egr_wide = strtoul(argv[NODE_ARG_EGR_WIDE], NULL, 10);
+	if (!node->egr_wide) {
+		node->egr_wide = strtoul(argv[NODE_ARG_EGR_WIDE], NULL, 16);
+		if (!node->egr_wide)
+			return 1;
+	}
+
+	node->ns_data = strtoul(argv[NODE_ARG_NS_DATA], NULL, 16);
+	if (!node->ns_data)
+		return 1;
+
+	node->ns_wide = strtoull(argv[NODE_ARG_NS_WIDE], NULL, 16);
+	if (!node->ns_wide)
+		return 1;
+
+	node->sc_id = strtoul(argv[NODE_ARG_SC_ID], NULL, 10);
+	if (!node->sc_id) {
+		node->sc_id = strtoul(argv[NODE_ARG_SC_ID], NULL, 16);
+		if (!node->sc_id)
+			return 1;
+	}
+
+	*argcp -= NODE_ARGS_SIZE;
+	*argvp += NODE_ARGS_SIZE;
+
+	if (node->sc_id != 0xffffff) {
+		if (!*argcp)
+			return 1;
+
+		node->sc_data = argv[NODE_ARG_SC_ID + 1];
+
+		*argcp -= 1;
+		*argvp += 1;
+	}
+
+	return 0;
+}
+
+struct args *parse_args(int argc, char **argv)
+{
+	struct args *args;
+	int n_node, i;
+
+	if (argc < ARGS_SIZE)
+		goto out;
+
+	n_node = strtoul(argv[ARG_N_NODE], NULL, 10);
+	if (!n_node || n_node > 10)
+		goto out;
+
+	args = calloc(1, sizeof(*args) + n_node * sizeof(struct node_args));
+	if (!args)
+		goto out;
+
+	args->ns_id = strtoul(argv[ARG_NS_ID], NULL, 10);
+	if (!args->ns_id)
+		goto free;
+
+	args->trace_type = strtoul(argv[ARG_TRACE_TYPE], NULL, 16);
+	if (!args->trace_type)
+		goto free;
+
+	args->n_node = n_node;
+	args->ifname = argv[ARG_IFNAME];
+
+	argv += ARGS_SIZE;
+	argc -= ARGS_SIZE;
+
+	for (i = 0; i < n_node; i++) {
+		if (parse_node_args(&argc, &argv, &args->node[i]))
+			goto free;
+	}
+
+	if (argc)
+		goto free;
+
+	return args;
+free:
+	free(args);
+out:
+	return NULL;
+}
+
+int main(int argc, char **argv)
+{
+	int ret, fd, pkts, size, hoplen, found;
+	struct ioam6_trace_hdr *ioam6h;
+	struct ioam6_hdr *opt;
+	struct ipv6hdr *ip6h;
+	__u8 buffer[400], *p;
+	struct args *args;
+
+	args = parse_args(argc - 1, argv + 1);
+	if (!args) {
+		ret = 1;
+		goto out;
+	}
+
+	fd = socket(AF_PACKET, SOCK_DGRAM, __cpu_to_be16(ETH_P_IPV6));
+	if (!fd) {
+		ret = 1;
+		goto out;
+	}
+
+	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
+		       args->ifname, strlen(args->ifname))) {
+		ret = 1;
+		goto close;
+	}
+
+	pkts = 0;
+	found = 0;
+	while (pkts < 3 && !found) {
+		size = recv(fd, buffer, sizeof(buffer), 0);
+		ip6h = (struct ipv6hdr *)buffer;
+		pkts++;
+
+		if (ip6h->nexthdr == IPPROTO_HOPOPTS) {
+			p = buffer + sizeof(*ip6h);
+			hoplen = (p[1] + 1) << 3;
+
+			p += sizeof(struct ipv6_hopopt_hdr);
+			while (hoplen > 0) {
+				opt = (struct ioam6_hdr *)p;
+
+				if (opt->opt_type == IPV6_TLV_IOAM &&
+				    opt->type == IOAM6_TYPE_PREALLOC) {
+					found = 1;
+
+					p += sizeof(*opt);
+					ioam6h = (struct ioam6_trace_hdr *)p;
+
+					ret = check_ioam6_trace(ioam6h, args);
+					break;
+				}
+
+				p += opt->opt_len + 2;
+				hoplen -= opt->opt_len + 2;
+			}
+		}
+	}
+
+	if (!found)
+		ret = 1;
+close:
+	close(fd);
+out:
+	free(args);
+	return ret;
+}
+
-- 
2.25.1

