Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFF23EDC33
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 19:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhHPRRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 13:17:32 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:54736 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhHPRRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 13:17:31 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 4BEB7200DBB5;
        Mon, 16 Aug 2021 19:16:57 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4BEB7200DBB5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1629134217;
        bh=3Rp26y/WFpfynxH2bkzNElOW4gYOKSK4fU6CXaHEbPk=;
        h=From:To:Cc:Subject:Date:From;
        b=TTdFfF7y4fXf9mxy5aPMc4jPJRr808aOQER5Conc7RsAzAYFO8DAJXqFv/sDIpcVE
         He2098N1/xHbCGwL5ydr21hq/NnduR8d5UqF4MSom4KZspOkOkKeQRCex4/k0jqiaX
         v0Kb2OnhHvqd9LB/nnlaEouaMhhWvDoT9sm+gOLlLSfoxgAZvLuw1FEAuBGBc6MROR
         CSVCfHBexZd/Yvv1euxYgSIFwgQ2gynmEJ4DacKYhP/BncYR5SCPVupdb8gZWwn7VT
         ooQI8R5lWayplZjh2RrG67RkgouH2mVzsrUc5SBlpKQ4SAshJ06WZgG3RJ8xNF0JUu
         773Vqs7isr5JA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        justin.iurman@uliege.be
Subject: [PATCH net-next] selftests: net: improved IOAM tests
Date:   Mon, 16 Aug 2021 19:16:38 +0200
Message-Id: <20210816171638.17965-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previously discussed with David Ahern, here is a refactored and improved
version of the IOAM self-test. It is now more complete and more robust. Now,
all tests are divided into three categories: OUTPUT (evaluates the IOAM
processing by the sender), INPUT (evaluates the IOAM processing by the receiver)
and GLOBAL (evaluates wider use cases that do not fall into the other two
categories). Both OUTPUT and INPUT tests only use a two-node topology (alpha and
beta), while GLOBAL tests use the entire three-node topology (alpha, beta,
gamma). Each test is documented inside its own handler in the (bash) script.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 tools/testing/selftests/net/ioam6.sh       | 685 +++++++++++++-----
 tools/testing/selftests/net/ioam6_parser.c | 790 +++++++++++++++------
 2 files changed, 1074 insertions(+), 401 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/net/ioam6.sh

diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
old mode 100644
new mode 100755
index bcf15487e584..3caf72bb9c6a
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -3,137 +3,128 @@
 #
 # Author: Justin Iurman <justin.iurman@uliege.be>
 #
-# This test evaluates the IOAM insertion for IPv6 by checking the IOAM data
-# integrity on the receiver.
+# This script evaluates the IOAM insertion for IPv6 by checking the IOAM data
+# consistency directly inside packets on the receiver side. Tests are divided
+# into three categories: OUTPUT (evaluates the IOAM processing by the sender),
+# INPUT (evaluates the IOAM processing by the receiver) and GLOBAL (evaluates
+# wider use cases that do not fall into the other two categories). Both OUTPUT
+# and INPUT tests only use a two-node topology (alpha and beta), while GLOBAL
+# tests use the entire three-node topology (alpha, beta, gamma). Each test is
+# documented inside its own handler in the code below.
 #
-# The topology is formed by 3 nodes: Alpha (sender), Beta (router in-between)
-# and Gamma (receiver). An IOAM domain is configured from Alpha to Gamma only,
-# which means not on the reverse path. When Gamma is the destination, Alpha
-# adds an IOAM option (Pre-allocated Trace) inside a Hop-by-hop and fills the
-# trace with its own IOAM data. Beta and Gamma also fill the trace. The IOAM
-# data integrity is checked on Gamma, by comparing with the pre-defined IOAM
-# configuration (see below).
+# An IOAM domain is configured from Alpha to Gamma but not on the reverse path.
+# When either Beta or Gamma is the destination (depending on the test category),
+# Alpha adds an IOAM option (Pre-allocated Trace) inside a Hop-by-hop.
 #
-#     +-------------------+            +-------------------+
-#     |                   |            |                   |
-#     |    alpha netns    |            |    gamma netns    |
-#     |                   |            |                   |
-#     |  +-------------+  |            |  +-------------+  |
-#     |  |    veth0    |  |            |  |    veth0    |  |
-#     |  |  db01::2/64 |  |            |  |  db02::2/64 |  |
-#     |  +-------------+  |            |  +-------------+  |
-#     |         .         |            |         .         |
-#     +-------------------+            +-------------------+
-#               .                                .
-#               .                                .
-#               .                                .
-#     +----------------------------------------------------+
-#     |         .                                .         |
-#     |  +-------------+                  +-------------+  |
-#     |  |    veth0    |                  |    veth1    |  |
-#     |  |  db01::1/64 | ................ |  db02::1/64 |  |
-#     |  +-------------+                  +-------------+  |
-#     |                                                    |
-#     |                      beta netns                    |
-#     |                                                    |
-#     +--------------------------+-------------------------+
 #
+#            +-------------------+            +-------------------+
+#            |                   |            |                   |
+#            |    Alpha netns    |            |    Gamma netns    |
+#            |                   |            |                   |
+#            |  +-------------+  |            |  +-------------+  |
+#            |  |    veth0    |  |            |  |    veth0    |  |
+#            |  |  db01::2/64 |  |            |  |  db02::2/64 |  |
+#            |  +-------------+  |            |  +-------------+  |
+#            |         .         |            |         .         |
+#            +-------------------+            +-------------------+
+#                      .                                .
+#                      .                                .
+#                      .                                .
+#            +----------------------------------------------------+
+#            |         .                                .         |
+#            |  +-------------+                  +-------------+  |
+#            |  |    veth0    |                  |    veth1    |  |
+#            |  |  db01::1/64 | ................ |  db02::1/64 |  |
+#            |  +-------------+                  +-------------+  |
+#            |                                                    |
+#            |                      Beta netns                    |
+#            |                                                    |
+#            +----------------------------------------------------+
 #
-# ~~~~~~~~~~~~~~~~~~~~~~
-# | IOAM configuration |
-# ~~~~~~~~~~~~~~~~~~~~~~
 #
-# Alpha
-# +-----------------------------------------------------------+
-# | Type                | Value                               |
-# +-----------------------------------------------------------+
-# | Node ID             | 1                                   |
-# +-----------------------------------------------------------+
-# | Node Wide ID        | 11111111                            |
-# +-----------------------------------------------------------+
-# | Ingress ID          | 0xffff (default value)              |
-# +-----------------------------------------------------------+
-# | Ingress Wide ID     | 0xffffffff (default value)          |
-# +-----------------------------------------------------------+
-# | Egress ID           | 101                                 |
-# +-----------------------------------------------------------+
-# | Egress Wide ID      | 101101                              |
-# +-----------------------------------------------------------+
-# | Namespace Data      | 0xdeadbee0                          |
-# +-----------------------------------------------------------+
-# | Namespace Wide Data | 0xcafec0caf00dc0de                  |
-# +-----------------------------------------------------------+
-# | Schema ID           | 777                                 |
-# +-----------------------------------------------------------+
-# | Schema Data         | something that will be 4n-aligned   |
-# +-----------------------------------------------------------+
 #
-# Note: When Gamma is the destination, Alpha adds an IOAM Pre-allocated Trace
-#       option inside a Hop-by-hop, where 164 bytes are pre-allocated for the
-#       trace, with 123 as the IOAM-Namespace and with 0xfff00200 as the trace
-#       type (= all available options at this time). As a result, and based on
-#       IOAM configurations here, only both Alpha and Beta should be capable of
-#       inserting their IOAM data while Gamma won't have enough space and will
-#       set the overflow bit.
+#        =============================================================
+#        |                Alpha - IOAM configuration                 |
+#        +===========================================================+
+#        | Node ID             | 1                                   |
+#        +-----------------------------------------------------------+
+#        | Node Wide ID        | 11111111                            |
+#        +-----------------------------------------------------------+
+#        | Ingress ID          | 0xffff (default value)              |
+#        +-----------------------------------------------------------+
+#        | Ingress Wide ID     | 0xffffffff (default value)          |
+#        +-----------------------------------------------------------+
+#        | Egress ID           | 101                                 |
+#        +-----------------------------------------------------------+
+#        | Egress Wide ID      | 101101                              |
+#        +-----------------------------------------------------------+
+#        | Namespace Data      | 0xdeadbee0                          |
+#        +-----------------------------------------------------------+
+#        | Namespace Wide Data | 0xcafec0caf00dc0de                  |
+#        +-----------------------------------------------------------+
+#        | Schema ID           | 777                                 |
+#        +-----------------------------------------------------------+
+#        | Schema Data         | something that will be 4n-aligned   |
+#        +-----------------------------------------------------------+
 #
-# Beta
-# +-----------------------------------------------------------+
-# | Type                | Value                               |
-# +-----------------------------------------------------------+
-# | Node ID             | 2                                   |
-# +-----------------------------------------------------------+
-# | Node Wide ID        | 22222222                            |
-# +-----------------------------------------------------------+
-# | Ingress ID          | 201                                 |
-# +-----------------------------------------------------------+
-# | Ingress Wide ID     | 201201                              |
-# +-----------------------------------------------------------+
-# | Egress ID           | 202                                 |
-# +-----------------------------------------------------------+
-# | Egress Wide ID      | 202202                              |
-# +-----------------------------------------------------------+
-# | Namespace Data      | 0xdeadbee1                          |
-# +-----------------------------------------------------------+
-# | Namespace Wide Data | 0xcafec0caf11dc0de                  |
-# +-----------------------------------------------------------+
-# | Schema ID           | 0xffffff (= None)                   |
-# +-----------------------------------------------------------+
-# | Schema Data         |                                     |
-# +-----------------------------------------------------------+
 #
-# Gamma
-# +-----------------------------------------------------------+
-# | Type                | Value                               |
-# +-----------------------------------------------------------+
-# | Node ID             | 3                                   |
-# +-----------------------------------------------------------+
-# | Node Wide ID        | 33333333                            |
-# +-----------------------------------------------------------+
-# | Ingress ID          | 301                                 |
-# +-----------------------------------------------------------+
-# | Ingress Wide ID     | 301301                              |
-# +-----------------------------------------------------------+
-# | Egress ID           | 0xffff (default value)              |
-# +-----------------------------------------------------------+
-# | Egress Wide ID      | 0xffffffff (default value)          |
-# +-----------------------------------------------------------+
-# | Namespace Data      | 0xdeadbee2                          |
-# +-----------------------------------------------------------+
-# | Namespace Wide Data | 0xcafec0caf22dc0de                  |
-# +-----------------------------------------------------------+
-# | Schema ID           | 0xffffff (= None)                   |
-# +-----------------------------------------------------------+
-# | Schema Data         |                                     |
-# +-----------------------------------------------------------+
-
-#===============================================================================
+#        =============================================================
+#        |                 Beta - IOAM configuration                 |
+#        +===========================================================+
+#        | Node ID             | 2                                   |
+#        +-----------------------------------------------------------+
+#        | Node Wide ID        | 22222222                            |
+#        +-----------------------------------------------------------+
+#        | Ingress ID          | 201                                 |
+#        +-----------------------------------------------------------+
+#        | Ingress Wide ID     | 201201                              |
+#        +-----------------------------------------------------------+
+#        | Egress ID           | 202                                 |
+#        +-----------------------------------------------------------+
+#        | Egress Wide ID      | 202202                              |
+#        +-----------------------------------------------------------+
+#        | Namespace Data      | 0xdeadbee1                          |
+#        +-----------------------------------------------------------+
+#        | Namespace Wide Data | 0xcafec0caf11dc0de                  |
+#        +-----------------------------------------------------------+
+#        | Schema ID           | 666                                 |
+#        +-----------------------------------------------------------+
+#        | Schema Data         | Hello there -Obi                    |
+#        +-----------------------------------------------------------+
 #
-# WARNING:
-# Do NOT modify the following configuration unless you know what you're doing.
 #
-IOAM_NAMESPACE=123
-IOAM_TRACE_TYPE=0xfff00200
-IOAM_PREALLOC_DATA_SIZE=164
+#        =============================================================
+#        |                Gamma - IOAM configuration                 |
+#        +===========================================================+
+#        | Node ID             | 3                                   |
+#        +-----------------------------------------------------------+
+#        | Node Wide ID        | 33333333                            |
+#        +-----------------------------------------------------------+
+#        | Ingress ID          | 301                                 |
+#        +-----------------------------------------------------------+
+#        | Ingress Wide ID     | 301301                              |
+#        +-----------------------------------------------------------+
+#        | Egress ID           | 0xffff (default value)              |
+#        +-----------------------------------------------------------+
+#        | Egress Wide ID      | 0xffffffff (default value)          |
+#        +-----------------------------------------------------------+
+#        | Namespace Data      | 0xdeadbee2                          |
+#        +-----------------------------------------------------------+
+#        | Namespace Wide Data | 0xcafec0caf22dc0de                  |
+#        +-----------------------------------------------------------+
+#        | Schema ID           | 0xffffff (= None)                   |
+#        +-----------------------------------------------------------+
+#        | Schema Data         |                                     |
+#        +-----------------------------------------------------------+
+
+
+################################################################################
+#                                                                              #
+# WARNING: Be careful if you modify the block below - it MUST be kept          #
+#          synchronized with configurations inside ioam6_parser.c and always   #
+#          reflect the same.                                                   #
+#                                                                              #
+################################################################################
 
 ALPHA=(
 	1					# ID
@@ -157,8 +148,8 @@ BETA=(
 	202202
 	0xdeadbee1
 	0xcafec0caf11dc0de
-	0xffffff
-	""
+	666
+	"Hello there -Obi"
 )
 
 GAMMA=(
@@ -173,28 +164,75 @@ GAMMA=(
 	0xffffff
 	""
 )
-#===============================================================================
 
-if [ "$(id -u)" -ne 0 ]; then
-  echo "SKIP: Need root privileges"
-  exit 1
-fi
+TESTS_OUTPUT="
+	out_undef_ns
+	out_no_room
+	out_bits
+	out_full_supp_trace
+"
 
-if [ ! -x "$(command -v ip)" ]; then
-  echo "SKIP: Could not run test without ip tool"
-  exit 1
-fi
+TESTS_INPUT="
+	in_undef_ns
+	in_no_room
+	in_oflag
+	in_bits
+	in_full_supp_trace
+"
 
-ip ioam &>/dev/null
-if [ $? = 1 ]; then
-  echo "SKIP: ip tool must include IOAM"
-  exit 1
-fi
+TESTS_GLOBAL="
+	fwd_full_supp_trace
+"
 
-if [ ! -e /proc/sys/net/ipv6/ioam6_id ]; then
-  echo "SKIP: ioam6 sysctls do not exist"
-  exit 1
-fi
+
+################################################################################
+#                                                                              #
+#                                   LIBRARY                                    #
+#                                                                              #
+################################################################################
+
+check_kernel_compatibility()
+{
+  ip netns add ioam-tmp-node
+  ip link add name veth0 netns ioam-tmp-node type veth \
+         peer name veth1 netns ioam-tmp-node
+
+  ip -netns ioam-tmp-node link set veth0 up
+  ip -netns ioam-tmp-node link set veth1 up
+
+  ip -netns ioam-tmp-node ioam namespace add 0 &>/dev/null
+  ns_ad=$?
+
+  ip -netns ioam-tmp-node ioam namespace show | grep -q "namespace 0"
+  ns_sh=$?
+
+  if [[ $ns_ad != 0 || $ns_sh != 0 ]]
+  then
+    echo "SKIP: kernel version probably too old, missing ioam support"
+    ip link del veth0 2>/dev/null || true
+    ip netns del ioam-tmp-node || true
+    exit 1
+  fi
+
+  ip -netns ioam-tmp-node route add db02::/64 encap ioam6 trace prealloc \
+         type 0x800000 ns 0 size 4 dev veth0 &>/dev/null
+  tr_ad=$?
+
+  ip -netns ioam-tmp-node -6 route | grep -q "encap ioam6 trace"
+  tr_sh=$?
+
+  if [[ $tr_ad != 0 || $tr_sh != 0 ]]
+  then
+    echo "SKIP: cannot attach an ioam trace to a route, did you compile" \
+         "without CONFIG_IPV6_IOAM6_LWTUNNEL?"
+    ip link del veth0 2>/dev/null || true
+    ip netns del ioam-tmp-node || true
+    exit 1
+  fi
+
+  ip link del veth0 2>/dev/null || true
+  ip netns del ioam-tmp-node || true
+}
 
 cleanup()
 {
@@ -212,13 +250,10 @@ setup()
   ip netns add ioam-node-beta
   ip netns add ioam-node-gamma
 
-  ip link add name ioam-veth-alpha type veth peer name ioam-veth-betaL
-  ip link add name ioam-veth-betaR type veth peer name ioam-veth-gamma
-
-  ip link set ioam-veth-alpha netns ioam-node-alpha
-  ip link set ioam-veth-betaL netns ioam-node-beta
-  ip link set ioam-veth-betaR netns ioam-node-beta
-  ip link set ioam-veth-gamma netns ioam-node-gamma
+  ip link add name ioam-veth-alpha netns ioam-node-alpha type veth \
+         peer name ioam-veth-betaL netns ioam-node-beta
+  ip link add name ioam-veth-betaR netns ioam-node-beta type veth \
+         peer name ioam-veth-gamma netns ioam-node-gamma
 
   ip -netns ioam-node-alpha link set ioam-veth-alpha name veth0
   ip -netns ioam-node-beta link set ioam-veth-betaL name veth0
@@ -228,7 +263,9 @@ setup()
   ip -netns ioam-node-alpha addr add db01::2/64 dev veth0
   ip -netns ioam-node-alpha link set veth0 up
   ip -netns ioam-node-alpha link set lo up
-  ip -netns ioam-node-alpha route add default via db01::1
+  ip -netns ioam-node-alpha route add db02::/64 via db01::1 dev veth0
+  ip -netns ioam-node-alpha route del db01::/64
+  ip -netns ioam-node-alpha route add db01::/64 dev veth0
 
   ip -netns ioam-node-beta addr add db01::1/64 dev veth0
   ip -netns ioam-node-beta addr add db02::1/64 dev veth1
@@ -239,17 +276,16 @@ setup()
   ip -netns ioam-node-gamma addr add db02::2/64 dev veth0
   ip -netns ioam-node-gamma link set veth0 up
   ip -netns ioam-node-gamma link set lo up
-  ip -netns ioam-node-gamma route add default via db02::1
+  ip -netns ioam-node-gamma route add db01::/64 via db02::1 dev veth0
 
   # - IOAM config -
   ip netns exec ioam-node-alpha sysctl -wq net.ipv6.ioam6_id=${ALPHA[0]}
   ip netns exec ioam-node-alpha sysctl -wq net.ipv6.ioam6_id_wide=${ALPHA[1]}
   ip netns exec ioam-node-alpha sysctl -wq net.ipv6.conf.veth0.ioam6_id=${ALPHA[4]}
   ip netns exec ioam-node-alpha sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${ALPHA[5]}
-  ip -netns ioam-node-alpha ioam namespace add ${IOAM_NAMESPACE} data ${ALPHA[6]} wide ${ALPHA[7]}
+  ip -netns ioam-node-alpha ioam namespace add 123 data ${ALPHA[6]} wide ${ALPHA[7]}
   ip -netns ioam-node-alpha ioam schema add ${ALPHA[8]} "${ALPHA[9]}"
-  ip -netns ioam-node-alpha ioam namespace set ${IOAM_NAMESPACE} schema ${ALPHA[8]}
-  ip -netns ioam-node-alpha route add db02::/64 encap ioam6 trace type ${IOAM_TRACE_TYPE:0:-2} ns ${IOAM_NAMESPACE} size ${IOAM_PREALLOC_DATA_SIZE} via db01::1 dev veth0
+  ip -netns ioam-node-alpha ioam namespace set 123 schema ${ALPHA[8]}
 
   ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.all.forwarding=1
   ip netns exec ioam-node-beta sysctl -wq net.ipv6.ioam6_id=${BETA[0]}
@@ -259,38 +295,357 @@ setup()
   ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${BETA[3]}
   ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth1.ioam6_id=${BETA[4]}
   ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth1.ioam6_id_wide=${BETA[5]}
-  ip -netns ioam-node-beta ioam namespace add ${IOAM_NAMESPACE} data ${BETA[6]} wide ${BETA[7]}
+  ip -netns ioam-node-beta ioam namespace add 123 data ${BETA[6]} wide ${BETA[7]}
+  ip -netns ioam-node-beta ioam schema add ${BETA[8]} "${BETA[9]}"
+  ip -netns ioam-node-beta ioam namespace set 123 schema ${BETA[8]}
 
   ip netns exec ioam-node-gamma sysctl -wq net.ipv6.ioam6_id=${GAMMA[0]}
   ip netns exec ioam-node-gamma sysctl -wq net.ipv6.ioam6_id_wide=${GAMMA[1]}
   ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_enabled=1
   ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_id=${GAMMA[2]}
   ip netns exec ioam-node-gamma sysctl -wq net.ipv6.conf.veth0.ioam6_id_wide=${GAMMA[3]}
-  ip -netns ioam-node-gamma ioam namespace add ${IOAM_NAMESPACE} data ${GAMMA[6]} wide ${GAMMA[7]}
-}
+  ip -netns ioam-node-gamma ioam namespace add 123 data ${GAMMA[6]} wide ${GAMMA[7]}
 
-run()
-{
-  echo -n "IOAM test... "
+  sleep 1
 
   ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
-  if [ $? != 0 ]; then
-    echo "FAILED"
+  if [ $? != 0 ]
+  then
+    echo "Setup FAILED"
     cleanup &>/dev/null
     exit 0
   fi
+}
 
-  ip netns exec ioam-node-gamma ./ioam6_parser veth0 2 ${IOAM_NAMESPACE} ${IOAM_TRACE_TYPE} 64 ${ALPHA[0]} ${ALPHA[1]} ${ALPHA[2]} ${ALPHA[3]} ${ALPHA[4]} ${ALPHA[5]} ${ALPHA[6]} ${ALPHA[7]} ${ALPHA[8]} "${ALPHA[9]}" 63 ${BETA[0]} ${BETA[1]} ${BETA[2]} ${BETA[3]} ${BETA[4]} ${BETA[5]} ${BETA[6]} ${BETA[7]} ${BETA[8]} &
+log_test_passed()
+{
+  local desc=$1
+  printf "TEST: %-60s  [ OK ]\n" "${desc}"
+}
 
+log_test_failed()
+{
+  local desc=$1
+  printf "TEST: %-60s  [FAIL]\n" "${desc}"
+}
+
+run_test()
+{
+  local name=$1
+  local desc=$2
+  local node_src=$3
+  local node_dst=$4
+  local ip6_src=$5
+  local ip6_dst=$6
+  local if_dst=$7
+  local trace_type=$8
+  local ioam_ns=$9
+
+  ip netns exec $node_dst ./ioam6_parser $if_dst $name $ip6_src $ip6_dst \
+         $trace_type $ioam_ns &
   local spid=$!
   sleep 0.1
 
-  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
+  ip netns exec $node_src ping6 -t 64 -c 1 -W 1 $ip6_dst &>/dev/null
+  if [ $? != 0 ]
+  then
+    log_test_failed "${desc}"
+    kill -2 $spid &>/dev/null
+  else
+    wait $spid
+    [ $? = 0 ] && log_test_passed "${desc}" || log_test_failed "${desc}"
+  fi
+}
+
+run()
+{
+  echo
+  echo "OUTPUT tests"
+  printf "%0.s-" {1..74}
+  echo
+
+  # set OUTPUT settings
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_enabled=0
+
+  for t in $TESTS_OUTPUT
+  do
+    $t
+  done
+
+  # clean OUTPUT settings
+  ip netns exec ioam-node-beta sysctl -wq net.ipv6.conf.veth0.ioam6_enabled=1
+  ip -netns ioam-node-alpha route change db01::/64 dev veth0
+
 
-  wait $spid
-  [ $? = 0 ] && echo "PASSED" || echo "FAILED"
+  echo
+  echo "INPUT tests"
+  printf "%0.s-" {1..74}
+  echo
+
+  # set INPUT settings
+  ip -netns ioam-node-alpha ioam namespace del 123
+
+  for t in $TESTS_INPUT
+  do
+    $t
+  done
+
+  # clean INPUT settings
+  ip -netns ioam-node-alpha ioam namespace add 123 \
+         data ${ALPHA[6]} wide ${ALPHA[7]}
+  ip -netns ioam-node-alpha ioam namespace set 123 schema ${ALPHA[8]}
+  ip -netns ioam-node-alpha route change db01::/64 dev veth0
+
+
+  echo
+  echo "GLOBAL tests"
+  printf "%0.s-" {1..74}
+  echo
+
+  for t in $TESTS_GLOBAL
+  do
+    $t
+  done
 }
 
+bit2type=(
+  0x800000 0x400000 0x200000 0x100000 0x080000 0x040000 0x020000 0x010000
+  0x008000 0x004000 0x002000 0x001000 0x000800 0x000400 0x000200 0x000100
+  0x000080 0x000040 0x000020 0x000010 0x000008 0x000004 0x000002
+)
+bit2size=( 4 4 4 4 4 4 4 4 8 8 8 4 4 4 4 4 4 4 4 4 4 4 4 )
+
+
+################################################################################
+#                                                                              #
+#                              OUTPUT tests                                    #
+#                                                                              #
+#   Two nodes (sender/receiver), IOAM disabled on ingress for the receiver.    #
+################################################################################
+
+out_undef_ns()
+{
+  ##############################################################################
+  # Make sure that the encap node won't fill the trace if the chosen IOAM      #
+  # namespace is not configured locally.                                       #
+  ##############################################################################
+  local desc="Unknown IOAM namespace"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0x800000 ns 0 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0x800000 0
+}
+
+out_no_room()
+{
+  ##############################################################################
+  # Make sure that the encap node won't fill the trace and will set the        #
+  # Overflow flag since there is no room enough for its data.                  #
+  ##############################################################################
+  local desc="Missing trace room"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0xc00000 ns 123 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0xc00000 123
+}
+
+out_bits()
+{
+  ##############################################################################
+  # Make sure that, for each trace type bit, the encap node will either:       #
+  #  (i)  fill the trace with its data when it is a supported bit              #
+  #  (ii) not fill the trace with its data when it is an unsupported bit       #
+  ##############################################################################
+  local desc="Trace type with bit <n> only"
+
+  local tmp=${bit2size[22]}
+  bit2size[22]=$(( $tmp + ${#ALPHA[9]} + ((4 - (${#ALPHA[9]} % 4)) % 4) ))
+
+  for i in {0..22}
+  do
+    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
+           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
+
+    run_test "out_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
+           db01::2 db01::1 veth0 ${bit2type[$i]} 123
+  done
+
+  bit2size[22]=$tmp
+}
+
+out_full_supp_trace()
+{
+  ##############################################################################
+  # Make sure that the encap node will correctly fill a full trace. Be careful,#
+  # "full trace" here does NOT mean all bits (only supported ones).            #
+  ##############################################################################
+  local desc="Full supported trace"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0xfff002 ns 123 size 100 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0xfff002 123
+}
+
+
+################################################################################
+#                                                                              #
+#                               INPUT tests                                    #
+#                                                                              #
+#     Two nodes (sender/receiver), the sender MUST NOT fill the trace upon     #
+#     insertion -> the IOAM namespace configured on the sender is removed      #
+#     and is used in the inserted trace to force the sender not to fill it.    #
+################################################################################
+
+in_undef_ns()
+{
+  ##############################################################################
+  # Make sure that the receiving node won't fill the trace if the related IOAM #
+  # namespace is not configured locally.                                       #
+  ##############################################################################
+  local desc="Unknown IOAM namespace"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0x800000 ns 0 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0x800000 0
+}
+
+in_no_room()
+{
+  ##############################################################################
+  # Make sure that the receiving node won't fill the trace and will set the    #
+  # Overflow flag if there is no room enough for its data.                     #
+  ##############################################################################
+  local desc="Missing trace room"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0xc00000 ns 123 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0xc00000 123
+}
+
+in_bits()
+{
+  ##############################################################################
+  # Make sure that, for each trace type bit, the receiving node will either:   #
+  #  (i)  fill the trace with its data when it is a supported bit              #
+  #  (ii) not fill the trace with its data when it is an unsupported bit       #
+  ##############################################################################
+  local desc="Trace type with bit <n> only"
+
+  local tmp=${bit2size[22]}
+  bit2size[22]=$(( $tmp + ${#BETA[9]} + ((4 - (${#BETA[9]} % 4)) % 4) ))
+
+  for i in {0..22}
+  do
+    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
+           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
+
+    run_test "in_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
+           db01::2 db01::1 veth0 ${bit2type[$i]} 123
+  done
+
+  bit2size[22]=$tmp
+}
+
+in_oflag()
+{
+  ##############################################################################
+  # Make sure that the receiving node won't fill the trace since the Overflow  #
+  # flag is set.                                                               #
+  ##############################################################################
+  local desc="Overflow flag is set"
+
+  # Exception:
+  #   Here, we need the sender to set the Overflow flag. For that, we will add
+  #   back the IOAM namespace that was previously configured on the sender.
+  ip -netns ioam-node-alpha ioam namespace add 123
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0xc00000 ns 123 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0xc00000 123
+
+  # And we clean the exception for this test to get things back to normal for
+  # other INPUT tests
+  ip -netns ioam-node-alpha ioam namespace del 123
+}
+
+in_full_supp_trace()
+{
+  ##############################################################################
+  # Make sure that the receiving node will correctly fill a full trace. Be     #
+  # careful, "full trace" here does NOT mean all bits (only supported ones).   #
+  ##############################################################################
+  local desc="Full supported trace"
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
+         type 0xfff002 ns 123 size 80 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
+         db01::1 veth0 0xfff002 123
+}
+
+
+################################################################################
+#                                                                              #
+#                              GLOBAL tests                                    #
+#                                                                              #
+#   Three nodes (sender/router/receiver), IOAM fully enabled on every node.    #
+################################################################################
+
+fwd_full_supp_trace()
+{
+  ##############################################################################
+  # Make sure that all three nodes correctly filled the full supported trace   #
+  # by checking that the trace data is consistent with the predefined config.  #
+  ##############################################################################
+  local desc="Forward - Full supported trace"
+
+  ip -netns ioam-node-alpha route change db02::/64 encap ioam6 trace prealloc \
+         type 0xfff002 ns 123 size 244 via db01::1 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-gamma db01::2 \
+         db02::2 veth0 0xfff002 123
+}
+
+
+################################################################################
+#                                                                              #
+#                                     MAIN                                     #
+#                                                                              #
+################################################################################
+
+if [ "$(id -u)" -ne 0 ]
+then
+  echo "SKIP: Need root privileges"
+  exit 1
+fi
+
+if [ ! -x "$(command -v ip)" ]
+then
+  echo "SKIP: Could not run test without ip tool"
+  exit 1
+fi
+
+ip ioam &>/dev/null
+if [ $? = 1 ]
+then
+  echo "SKIP: iproute2 too old, missing ioam command"
+  exit 1
+fi
+
+check_kernel_compatibility
+
 cleanup &>/dev/null
 setup
 run
diff --git a/tools/testing/selftests/net/ioam6_parser.c b/tools/testing/selftests/net/ioam6_parser.c
index 2256cf5ad637..d376cb2c383c 100644
--- a/tools/testing/selftests/net/ioam6_parser.c
+++ b/tools/testing/selftests/net/ioam6_parser.c
@@ -2,19 +2,20 @@
 /*
  * Author: Justin Iurman (justin.iurman@uliege.be)
  *
- * IOAM parser for IPv6, see ioam6.sh for details.
+ * IOAM tester for IPv6, see ioam6.sh for details on each test case.
  */
-#include <asm/byteorder.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <limits.h>
 #include <linux/const.h>
 #include <linux/if_ether.h>
 #include <linux/ioam6.h>
 #include <linux/ipv6.h>
-#include <sys/socket.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 
-struct node_args {
+struct ioam_config {
 	__u32 id;
 	__u64 wide;
 	__u16 ingr_id;
@@ -24,143 +25,325 @@ struct node_args {
 	__u32 ns_data;
 	__u64 ns_wide;
 	__u32 sc_id;
-	__u8 hop_limit;
-	__u8 *sc_data; /* NULL when sc_id = 0xffffff (default empty value) */
+	__u8 hlim;
+	char *sc_data;
 };
 
-/* expected args per node, in that order */
-enum {
-	NODE_ARG_HOP_LIMIT,
-	NODE_ARG_ID,
-	NODE_ARG_WIDE,
-	NODE_ARG_INGR_ID,
-	NODE_ARG_INGR_WIDE,
-	NODE_ARG_EGR_ID,
-	NODE_ARG_EGR_WIDE,
-	NODE_ARG_NS_DATA,
-	NODE_ARG_NS_WIDE,
-	NODE_ARG_SC_ID,
-	__NODE_ARG_MAX,
+/*
+ * Be careful if you modify structs below - everything MUST be kept synchronized
+ * with configurations inside ioam6.sh and always reflect the same.
+ */
+
+static struct ioam_config node1 = {
+	.id = 1,
+	.wide = 11111111,
+	.ingr_id = 0xffff, /* default value */
+	.egr_id = 101,
+	.ingr_wide = 0xffffffff, /* default value */
+	.egr_wide = 101101,
+	.ns_data = 0xdeadbee0,
+	.ns_wide = 0xcafec0caf00dc0de,
+	.sc_id = 777,
+	.sc_data = "something that will be 4n-aligned",
+	.hlim = 64,
 };
 
-#define NODE_ARGS_SIZE __NODE_ARG_MAX
+static struct ioam_config node2 = {
+	.id = 2,
+	.wide = 22222222,
+	.ingr_id = 201,
+	.egr_id = 202,
+	.ingr_wide = 201201,
+	.egr_wide = 202202,
+	.ns_data = 0xdeadbee1,
+	.ns_wide = 0xcafec0caf11dc0de,
+	.sc_id = 666,
+	.sc_data = "Hello there -Obi",
+	.hlim = 63,
+};
 
-struct args {
-	__u16 ns_id;
-	__u32 trace_type;
-	__u8 n_node;
-	__u8 *ifname;
-	struct node_args node[0];
+static struct ioam_config node3 = {
+	.id = 3,
+	.wide = 33333333,
+	.ingr_id = 301,
+	.egr_id = 0xffff, /* default value */
+	.ingr_wide = 301301,
+	.egr_wide = 0xffffffff, /* default value */
+	.ns_data = 0xdeadbee2,
+	.ns_wide = 0xcafec0caf22dc0de,
+	.sc_id = 0xffffff, /* default value */
+	.sc_data = NULL,
+	.hlim = 62,
 };
 
-/* expected args, in that order */
 enum {
-	ARG_IFNAME,
-	ARG_N_NODE,
-	ARG_NS_ID,
-	ARG_TRACE_TYPE,
-	__ARG_MAX,
+	/**********
+	 * OUTPUT *
+	 **********/
+	TEST_OUT_UNDEF_NS,
+	TEST_OUT_NO_ROOM,
+	TEST_OUT_BIT0,
+	TEST_OUT_BIT1,
+	TEST_OUT_BIT2,
+	TEST_OUT_BIT3,
+	TEST_OUT_BIT4,
+	TEST_OUT_BIT5,
+	TEST_OUT_BIT6,
+	TEST_OUT_BIT7,
+	TEST_OUT_BIT8,
+	TEST_OUT_BIT9,
+	TEST_OUT_BIT10,
+	TEST_OUT_BIT11,
+	TEST_OUT_BIT12,
+	TEST_OUT_BIT13,
+	TEST_OUT_BIT14,
+	TEST_OUT_BIT15,
+	TEST_OUT_BIT16,
+	TEST_OUT_BIT17,
+	TEST_OUT_BIT18,
+	TEST_OUT_BIT19,
+	TEST_OUT_BIT20,
+	TEST_OUT_BIT21,
+	TEST_OUT_BIT22,
+	TEST_OUT_FULL_SUPP_TRACE,
+
+	/*********
+	 * INPUT *
+	 *********/
+	TEST_IN_UNDEF_NS,
+	TEST_IN_NO_ROOM,
+	TEST_IN_OFLAG,
+	TEST_IN_BIT0,
+	TEST_IN_BIT1,
+	TEST_IN_BIT2,
+	TEST_IN_BIT3,
+	TEST_IN_BIT4,
+	TEST_IN_BIT5,
+	TEST_IN_BIT6,
+	TEST_IN_BIT7,
+	TEST_IN_BIT8,
+	TEST_IN_BIT9,
+	TEST_IN_BIT10,
+	TEST_IN_BIT11,
+	TEST_IN_BIT12,
+	TEST_IN_BIT13,
+	TEST_IN_BIT14,
+	TEST_IN_BIT15,
+	TEST_IN_BIT16,
+	TEST_IN_BIT17,
+	TEST_IN_BIT18,
+	TEST_IN_BIT19,
+	TEST_IN_BIT20,
+	TEST_IN_BIT21,
+	TEST_IN_BIT22,
+	TEST_IN_FULL_SUPP_TRACE,
+
+	/**********
+	 * GLOBAL *
+	 **********/
+	TEST_FWD_FULL_SUPP_TRACE,
+
+	__TEST_MAX,
 };
 
-#define ARGS_SIZE __ARG_MAX
+static int check_ioam_header(int tid, struct ioam6_trace_hdr *ioam6h,
+			     __u32 trace_type, __u16 ioam_ns)
+{
+	if (__be16_to_cpu(ioam6h->namespace_id) != ioam_ns ||
+	    __be32_to_cpu(ioam6h->type_be32) != (trace_type << 8))
+		return 1;
 
-int check_ioam6_node_data(__u8 **p, struct ioam6_trace_hdr *trace, __u8 hlim,
-			  __u32 id, __u64 wide, __u16 ingr_id, __u32 ingr_wide,
-			  __u16 egr_id, __u32 egr_wide, __u32 ns_data,
-			  __u64 ns_wide, __u32 sc_id, __u8 *sc_data)
+	switch (tid) {
+	case TEST_OUT_UNDEF_NS:
+	case TEST_IN_UNDEF_NS:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen != 1 ||
+		       ioam6h->remlen != 1;
+
+	case TEST_OUT_NO_ROOM:
+	case TEST_IN_NO_ROOM:
+	case TEST_IN_OFLAG:
+		return !ioam6h->overflow ||
+		       ioam6h->nodelen != 2 ||
+		       ioam6h->remlen != 1;
+
+	case TEST_OUT_BIT0:
+	case TEST_IN_BIT0:
+	case TEST_OUT_BIT1:
+	case TEST_IN_BIT1:
+	case TEST_OUT_BIT2:
+	case TEST_IN_BIT2:
+	case TEST_OUT_BIT3:
+	case TEST_IN_BIT3:
+	case TEST_OUT_BIT4:
+	case TEST_IN_BIT4:
+	case TEST_OUT_BIT5:
+	case TEST_IN_BIT5:
+	case TEST_OUT_BIT6:
+	case TEST_IN_BIT6:
+	case TEST_OUT_BIT7:
+	case TEST_IN_BIT7:
+	case TEST_OUT_BIT11:
+	case TEST_IN_BIT11:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen != 1 ||
+		       ioam6h->remlen;
+
+	case TEST_OUT_BIT8:
+	case TEST_IN_BIT8:
+	case TEST_OUT_BIT9:
+	case TEST_IN_BIT9:
+	case TEST_OUT_BIT10:
+	case TEST_IN_BIT10:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen != 2 ||
+		       ioam6h->remlen;
+
+	case TEST_OUT_BIT12:
+	case TEST_IN_BIT12:
+	case TEST_OUT_BIT13:
+	case TEST_IN_BIT13:
+	case TEST_OUT_BIT14:
+	case TEST_IN_BIT14:
+	case TEST_OUT_BIT15:
+	case TEST_IN_BIT15:
+	case TEST_OUT_BIT16:
+	case TEST_IN_BIT16:
+	case TEST_OUT_BIT17:
+	case TEST_IN_BIT17:
+	case TEST_OUT_BIT18:
+	case TEST_IN_BIT18:
+	case TEST_OUT_BIT19:
+	case TEST_IN_BIT19:
+	case TEST_OUT_BIT20:
+	case TEST_IN_BIT20:
+	case TEST_OUT_BIT21:
+	case TEST_IN_BIT21:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen ||
+		       ioam6h->remlen != 1;
+
+	case TEST_OUT_BIT22:
+	case TEST_IN_BIT22:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen ||
+		       ioam6h->remlen;
+
+	case TEST_OUT_FULL_SUPP_TRACE:
+	case TEST_IN_FULL_SUPP_TRACE:
+	case TEST_FWD_FULL_SUPP_TRACE:
+		return ioam6h->overflow ||
+		       ioam6h->nodelen != 15 ||
+		       ioam6h->remlen;
+
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+static int check_ioam6_data(__u8 **p, struct ioam6_trace_hdr *ioam6h,
+			    const struct ioam_config cnf)
 {
+	unsigned int len;
+	__u8 aligned;
 	__u64 raw64;
 	__u32 raw32;
-	__u8 sc_len;
 
-	if (trace->type.bit0) {
+	if (ioam6h->type.bit0) {
 		raw32 = __be32_to_cpu(*((__u32 *)*p));
-		if (hlim != (raw32 >> 24) || id != (raw32 & 0xffffff))
+		if (cnf.hlim != (raw32 >> 24) || cnf.id != (raw32 & 0xffffff))
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit1) {
+	if (ioam6h->type.bit1) {
 		raw32 = __be32_to_cpu(*((__u32 *)*p));
-		if (ingr_id != (raw32 >> 16) || egr_id != (raw32 & 0xffff))
+		if (cnf.ingr_id != (raw32 >> 16) ||
+		    cnf.egr_id != (raw32 & 0xffff))
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit2)
+	if (ioam6h->type.bit2)
 		*p += sizeof(__u32);
 
-	if (trace->type.bit3)
+	if (ioam6h->type.bit3)
 		*p += sizeof(__u32);
 
-	if (trace->type.bit4) {
+	if (ioam6h->type.bit4) {
 		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit5) {
-		if (__be32_to_cpu(*((__u32 *)*p)) != ns_data)
+	if (ioam6h->type.bit5) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != cnf.ns_data)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit6) {
+	if (ioam6h->type.bit6) {
 		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit7) {
+	if (ioam6h->type.bit7) {
 		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit8) {
+	if (ioam6h->type.bit8) {
 		raw64 = __be64_to_cpu(*((__u64 *)*p));
-		if (hlim != (raw64 >> 56) || wide != (raw64 & 0xffffffffffffff))
+		if (cnf.hlim != (raw64 >> 56) ||
+		    cnf.wide != (raw64 & 0xffffffffffffff))
 			return 1;
 		*p += sizeof(__u64);
 	}
 
-	if (trace->type.bit9) {
-		if (__be32_to_cpu(*((__u32 *)*p)) != ingr_wide)
+	if (ioam6h->type.bit9) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != cnf.ingr_wide)
 			return 1;
 		*p += sizeof(__u32);
 
-		if (__be32_to_cpu(*((__u32 *)*p)) != egr_wide)
+		if (__be32_to_cpu(*((__u32 *)*p)) != cnf.egr_wide)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit10) {
-		if (__be64_to_cpu(*((__u64 *)*p)) != ns_wide)
+	if (ioam6h->type.bit10) {
+		if (__be64_to_cpu(*((__u64 *)*p)) != cnf.ns_wide)
 			return 1;
 		*p += sizeof(__u64);
 	}
 
-	if (trace->type.bit11) {
+	if (ioam6h->type.bit11) {
 		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
 			return 1;
 		*p += sizeof(__u32);
 	}
 
-	if (trace->type.bit22) {
+	if (ioam6h->type.bit22) {
+		len = cnf.sc_data ? strlen(cnf.sc_data) : 0;
+		aligned = cnf.sc_data ? __ALIGN_KERNEL(len, 4) : 0;
+
 		raw32 = __be32_to_cpu(*((__u32 *)*p));
-		sc_len = sc_data ? __ALIGN_KERNEL(strlen(sc_data), 4) : 0;
-		if (sc_len != (raw32 >> 24) * 4 || sc_id != (raw32 & 0xffffff))
+		if (aligned != (raw32 >> 24) * 4 ||
+		    cnf.sc_id != (raw32 & 0xffffff))
 			return 1;
 		*p += sizeof(__u32);
 
-		if (sc_data) {
-			if (strncmp(*p, sc_data, strlen(sc_data)))
+		if (cnf.sc_data) {
+			if (strncmp((char *)*p, cnf.sc_data, len))
 				return 1;
 
-			*p += strlen(sc_data);
-			sc_len -= strlen(sc_data);
+			*p += len;
+			aligned -= len;
 
-			while (sc_len--) {
+			while (aligned--) {
 				if (**p != '\0')
 					return 1;
 				*p += sizeof(__u8);
@@ -171,232 +354,367 @@ int check_ioam6_node_data(__u8 **p, struct ioam6_trace_hdr *trace, __u8 hlim,
 	return 0;
 }
 
-int check_ioam6_trace(struct ioam6_trace_hdr *trace, struct args *args)
+static int check_ioam_header_and_data(int tid, struct ioam6_trace_hdr *ioam6h,
+				      __u32 trace_type, __u16 ioam_ns)
 {
 	__u8 *p;
-	int i;
 
-	if (__be16_to_cpu(trace->namespace_id) != args->ns_id ||
-	    __be32_to_cpu(trace->type_be32) != args->trace_type)
+	if (check_ioam_header(tid, ioam6h, trace_type, ioam_ns))
 		return 1;
 
-	p = trace->data + trace->remlen * 4;
-
-	for (i = args->n_node - 1; i >= 0; i--) {
-		if (check_ioam6_node_data(&p, trace,
-					  args->node[i].hop_limit,
-					  args->node[i].id,
-					  args->node[i].wide,
-					  args->node[i].ingr_id,
-					  args->node[i].ingr_wide,
-					  args->node[i].egr_id,
-					  args->node[i].egr_wide,
-					  args->node[i].ns_data,
-					  args->node[i].ns_wide,
-					  args->node[i].sc_id,
-					  args->node[i].sc_data))
-			return 1;
+	p = ioam6h->data + ioam6h->remlen * 4;
+
+	switch (tid) {
+	case TEST_OUT_BIT0:
+	case TEST_OUT_BIT1:
+	case TEST_OUT_BIT2:
+	case TEST_OUT_BIT3:
+	case TEST_OUT_BIT4:
+	case TEST_OUT_BIT5:
+	case TEST_OUT_BIT6:
+	case TEST_OUT_BIT7:
+	case TEST_OUT_BIT8:
+	case TEST_OUT_BIT9:
+	case TEST_OUT_BIT10:
+	case TEST_OUT_BIT11:
+	case TEST_OUT_BIT22:
+	case TEST_OUT_FULL_SUPP_TRACE:
+		return check_ioam6_data(&p, ioam6h, node1);
+
+	case TEST_IN_BIT0:
+	case TEST_IN_BIT1:
+	case TEST_IN_BIT2:
+	case TEST_IN_BIT3:
+	case TEST_IN_BIT4:
+	case TEST_IN_BIT5:
+	case TEST_IN_BIT6:
+	case TEST_IN_BIT7:
+	case TEST_IN_BIT8:
+	case TEST_IN_BIT9:
+	case TEST_IN_BIT10:
+	case TEST_IN_BIT11:
+	case TEST_IN_BIT22:
+	case TEST_IN_FULL_SUPP_TRACE:
+	{
+		__u32 tmp32 = node2.egr_wide;
+		__u16 tmp16 = node2.egr_id;
+		int res;
+
+		node2.egr_id = 0xffff;
+		node2.egr_wide = 0xffffffff;
+
+		res = check_ioam6_data(&p, ioam6h, node2);
+
+		node2.egr_id = tmp16;
+		node2.egr_wide = tmp32;
+
+		return res;
 	}
 
-	return 0;
-}
-
-int parse_node_args(int *argcp, char ***argvp, struct node_args *node)
-{
-	char **argv = *argvp;
-
-	if (*argcp < NODE_ARGS_SIZE)
-		return 1;
-
-	node->hop_limit = strtoul(argv[NODE_ARG_HOP_LIMIT], NULL, 10);
-	if (!node->hop_limit) {
-		node->hop_limit = strtoul(argv[NODE_ARG_HOP_LIMIT], NULL, 16);
-		if (!node->hop_limit)
-			return 1;
-	}
-
-	node->id = strtoul(argv[NODE_ARG_ID], NULL, 10);
-	if (!node->id) {
-		node->id = strtoul(argv[NODE_ARG_ID], NULL, 16);
-		if (!node->id)
-			return 1;
-	}
-
-	node->wide = strtoull(argv[NODE_ARG_WIDE], NULL, 10);
-	if (!node->wide) {
-		node->wide = strtoull(argv[NODE_ARG_WIDE], NULL, 16);
-		if (!node->wide)
-			return 1;
-	}
-
-	node->ingr_id = strtoul(argv[NODE_ARG_INGR_ID], NULL, 10);
-	if (!node->ingr_id) {
-		node->ingr_id = strtoul(argv[NODE_ARG_INGR_ID], NULL, 16);
-		if (!node->ingr_id)
+	case TEST_FWD_FULL_SUPP_TRACE:
+		if (check_ioam6_data(&p, ioam6h, node3))
 			return 1;
-	}
-
-	node->ingr_wide = strtoul(argv[NODE_ARG_INGR_WIDE], NULL, 10);
-	if (!node->ingr_wide) {
-		node->ingr_wide = strtoul(argv[NODE_ARG_INGR_WIDE], NULL, 16);
-		if (!node->ingr_wide)
+		if (check_ioam6_data(&p, ioam6h, node2))
 			return 1;
-	}
+		return check_ioam6_data(&p, ioam6h, node1);
 
-	node->egr_id = strtoul(argv[NODE_ARG_EGR_ID], NULL, 10);
-	if (!node->egr_id) {
-		node->egr_id = strtoul(argv[NODE_ARG_EGR_ID], NULL, 16);
-		if (!node->egr_id)
-			return 1;
+	default:
+		break;
 	}
 
-	node->egr_wide = strtoul(argv[NODE_ARG_EGR_WIDE], NULL, 10);
-	if (!node->egr_wide) {
-		node->egr_wide = strtoul(argv[NODE_ARG_EGR_WIDE], NULL, 16);
-		if (!node->egr_wide)
-			return 1;
-	}
+	return 1;
+}
 
-	node->ns_data = strtoul(argv[NODE_ARG_NS_DATA], NULL, 16);
-	if (!node->ns_data)
-		return 1;
+static int str2id(const char *tname)
+{
+	if (!strcmp("out_undef_ns", tname))
+		return TEST_OUT_UNDEF_NS;
+	if (!strcmp("out_no_room", tname))
+		return TEST_OUT_NO_ROOM;
+	if (!strcmp("out_bit0", tname))
+		return TEST_OUT_BIT0;
+	if (!strcmp("out_bit1", tname))
+		return TEST_OUT_BIT1;
+	if (!strcmp("out_bit2", tname))
+		return TEST_OUT_BIT2;
+	if (!strcmp("out_bit3", tname))
+		return TEST_OUT_BIT3;
+	if (!strcmp("out_bit4", tname))
+		return TEST_OUT_BIT4;
+	if (!strcmp("out_bit5", tname))
+		return TEST_OUT_BIT5;
+	if (!strcmp("out_bit6", tname))
+		return TEST_OUT_BIT6;
+	if (!strcmp("out_bit7", tname))
+		return TEST_OUT_BIT7;
+	if (!strcmp("out_bit8", tname))
+		return TEST_OUT_BIT8;
+	if (!strcmp("out_bit9", tname))
+		return TEST_OUT_BIT9;
+	if (!strcmp("out_bit10", tname))
+		return TEST_OUT_BIT10;
+	if (!strcmp("out_bit11", tname))
+		return TEST_OUT_BIT11;
+	if (!strcmp("out_bit12", tname))
+		return TEST_OUT_BIT12;
+	if (!strcmp("out_bit13", tname))
+		return TEST_OUT_BIT13;
+	if (!strcmp("out_bit14", tname))
+		return TEST_OUT_BIT14;
+	if (!strcmp("out_bit15", tname))
+		return TEST_OUT_BIT15;
+	if (!strcmp("out_bit16", tname))
+		return TEST_OUT_BIT16;
+	if (!strcmp("out_bit17", tname))
+		return TEST_OUT_BIT17;
+	if (!strcmp("out_bit18", tname))
+		return TEST_OUT_BIT18;
+	if (!strcmp("out_bit19", tname))
+		return TEST_OUT_BIT19;
+	if (!strcmp("out_bit20", tname))
+		return TEST_OUT_BIT20;
+	if (!strcmp("out_bit21", tname))
+		return TEST_OUT_BIT21;
+	if (!strcmp("out_bit22", tname))
+		return TEST_OUT_BIT22;
+	if (!strcmp("out_full_supp_trace", tname))
+		return TEST_OUT_FULL_SUPP_TRACE;
+	if (!strcmp("in_undef_ns", tname))
+		return TEST_IN_UNDEF_NS;
+	if (!strcmp("in_no_room", tname))
+		return TEST_IN_NO_ROOM;
+	if (!strcmp("in_oflag", tname))
+		return TEST_IN_OFLAG;
+	if (!strcmp("in_bit0", tname))
+		return TEST_IN_BIT0;
+	if (!strcmp("in_bit1", tname))
+		return TEST_IN_BIT1;
+	if (!strcmp("in_bit2", tname))
+		return TEST_IN_BIT2;
+	if (!strcmp("in_bit3", tname))
+		return TEST_IN_BIT3;
+	if (!strcmp("in_bit4", tname))
+		return TEST_IN_BIT4;
+	if (!strcmp("in_bit5", tname))
+		return TEST_IN_BIT5;
+	if (!strcmp("in_bit6", tname))
+		return TEST_IN_BIT6;
+	if (!strcmp("in_bit7", tname))
+		return TEST_IN_BIT7;
+	if (!strcmp("in_bit8", tname))
+		return TEST_IN_BIT8;
+	if (!strcmp("in_bit9", tname))
+		return TEST_IN_BIT9;
+	if (!strcmp("in_bit10", tname))
+		return TEST_IN_BIT10;
+	if (!strcmp("in_bit11", tname))
+		return TEST_IN_BIT11;
+	if (!strcmp("in_bit12", tname))
+		return TEST_IN_BIT12;
+	if (!strcmp("in_bit13", tname))
+		return TEST_IN_BIT13;
+	if (!strcmp("in_bit14", tname))
+		return TEST_IN_BIT14;
+	if (!strcmp("in_bit15", tname))
+		return TEST_IN_BIT15;
+	if (!strcmp("in_bit16", tname))
+		return TEST_IN_BIT16;
+	if (!strcmp("in_bit17", tname))
+		return TEST_IN_BIT17;
+	if (!strcmp("in_bit18", tname))
+		return TEST_IN_BIT18;
+	if (!strcmp("in_bit19", tname))
+		return TEST_IN_BIT19;
+	if (!strcmp("in_bit20", tname))
+		return TEST_IN_BIT20;
+	if (!strcmp("in_bit21", tname))
+		return TEST_IN_BIT21;
+	if (!strcmp("in_bit22", tname))
+		return TEST_IN_BIT22;
+	if (!strcmp("in_full_supp_trace", tname))
+		return TEST_IN_FULL_SUPP_TRACE;
+	if (!strcmp("fwd_full_supp_trace", tname))
+		return TEST_FWD_FULL_SUPP_TRACE;
+
+	return -1;
+}
 
-	node->ns_wide = strtoull(argv[NODE_ARG_NS_WIDE], NULL, 16);
-	if (!node->ns_wide)
-		return 1;
+static int ipv6_addr_equal(const struct in6_addr *a1, const struct in6_addr *a2)
+{
+	return ((a1->s6_addr32[0] ^ a2->s6_addr32[0]) |
+		(a1->s6_addr32[1] ^ a2->s6_addr32[1]) |
+		(a1->s6_addr32[2] ^ a2->s6_addr32[2]) |
+		(a1->s6_addr32[3] ^ a2->s6_addr32[3])) == 0;
+}
 
-	node->sc_id = strtoul(argv[NODE_ARG_SC_ID], NULL, 10);
-	if (!node->sc_id) {
-		node->sc_id = strtoul(argv[NODE_ARG_SC_ID], NULL, 16);
-		if (!node->sc_id)
-			return 1;
-	}
+static int get_u32(__u32 *val, const char *arg, int base)
+{
+	unsigned long res;
+	char *ptr;
 
-	*argcp -= NODE_ARGS_SIZE;
-	*argvp += NODE_ARGS_SIZE;
+	if (!arg || !*arg)
+		return -1;
+	res = strtoul(arg, &ptr, base);
 
-	if (node->sc_id != 0xffffff) {
-		if (!*argcp)
-			return 1;
+	if (!ptr || ptr == arg || *ptr)
+		return -1;
 
-		node->sc_data = argv[NODE_ARG_SC_ID + 1];
+	if (res == ULONG_MAX && errno == ERANGE)
+		return -1;
 
-		*argcp -= 1;
-		*argvp += 1;
-	}
+	if (res > 0xFFFFFFFFUL)
+		return -1;
 
+	*val = res;
 	return 0;
 }
 
-struct args *parse_args(int argc, char **argv)
+static int get_u16(__u16 *val, const char *arg, int base)
 {
-	struct args *args;
-	int n_node, i;
+	unsigned long res;
+	char *ptr;
 
-	if (argc < ARGS_SIZE)
-		goto out;
-
-	n_node = strtoul(argv[ARG_N_NODE], NULL, 10);
-	if (!n_node || n_node > 10)
-		goto out;
-
-	args = calloc(1, sizeof(*args) + n_node * sizeof(struct node_args));
-	if (!args)
-		goto out;
+	if (!arg || !*arg)
+		return -1;
+	res = strtoul(arg, &ptr, base);
 
-	args->ns_id = strtoul(argv[ARG_NS_ID], NULL, 10);
-	if (!args->ns_id)
-		goto free;
+	if (!ptr || ptr == arg || *ptr)
+		return -1;
 
-	args->trace_type = strtoul(argv[ARG_TRACE_TYPE], NULL, 16);
-	if (!args->trace_type)
-		goto free;
-
-	args->n_node = n_node;
-	args->ifname = argv[ARG_IFNAME];
-
-	argv += ARGS_SIZE;
-	argc -= ARGS_SIZE;
-
-	for (i = 0; i < n_node; i++) {
-		if (parse_node_args(&argc, &argv, &args->node[i]))
-			goto free;
-	}
+	if (res == ULONG_MAX && errno == ERANGE)
+		return -1;
 
-	if (argc)
-		goto free;
+	if (res > 0xFFFFUL)
+		return -1;
 
-	return args;
-free:
-	free(args);
-out:
-	return NULL;
+	*val = res;
+	return 0;
 }
 
+static int (*func[__TEST_MAX])(int, struct ioam6_trace_hdr *, __u32, __u16) = {
+	[TEST_OUT_UNDEF_NS]		= check_ioam_header,
+	[TEST_OUT_NO_ROOM]		= check_ioam_header,
+	[TEST_OUT_BIT0]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT1]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT2]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT3]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT4]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT5]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT6]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT7]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT8]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT9]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT10]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT11]		= check_ioam_header_and_data,
+	[TEST_OUT_BIT12]		= check_ioam_header,
+	[TEST_OUT_BIT13]		= check_ioam_header,
+	[TEST_OUT_BIT14]		= check_ioam_header,
+	[TEST_OUT_BIT15]		= check_ioam_header,
+	[TEST_OUT_BIT16]		= check_ioam_header,
+	[TEST_OUT_BIT17]		= check_ioam_header,
+	[TEST_OUT_BIT18]		= check_ioam_header,
+	[TEST_OUT_BIT19]		= check_ioam_header,
+	[TEST_OUT_BIT20]		= check_ioam_header,
+	[TEST_OUT_BIT21]		= check_ioam_header,
+	[TEST_OUT_BIT22]		= check_ioam_header_and_data,
+	[TEST_OUT_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
+	[TEST_IN_UNDEF_NS]		= check_ioam_header,
+	[TEST_IN_NO_ROOM]		= check_ioam_header,
+	[TEST_IN_OFLAG]		= check_ioam_header,
+	[TEST_IN_BIT0]			= check_ioam_header_and_data,
+	[TEST_IN_BIT1]			= check_ioam_header_and_data,
+	[TEST_IN_BIT2]			= check_ioam_header_and_data,
+	[TEST_IN_BIT3]			= check_ioam_header_and_data,
+	[TEST_IN_BIT4]			= check_ioam_header_and_data,
+	[TEST_IN_BIT5]			= check_ioam_header_and_data,
+	[TEST_IN_BIT6]			= check_ioam_header_and_data,
+	[TEST_IN_BIT7]			= check_ioam_header_and_data,
+	[TEST_IN_BIT8]			= check_ioam_header_and_data,
+	[TEST_IN_BIT9]			= check_ioam_header_and_data,
+	[TEST_IN_BIT10]		= check_ioam_header_and_data,
+	[TEST_IN_BIT11]		= check_ioam_header_and_data,
+	[TEST_IN_BIT12]		= check_ioam_header,
+	[TEST_IN_BIT13]		= check_ioam_header,
+	[TEST_IN_BIT14]		= check_ioam_header,
+	[TEST_IN_BIT15]		= check_ioam_header,
+	[TEST_IN_BIT16]		= check_ioam_header,
+	[TEST_IN_BIT17]		= check_ioam_header,
+	[TEST_IN_BIT18]		= check_ioam_header,
+	[TEST_IN_BIT19]		= check_ioam_header,
+	[TEST_IN_BIT20]		= check_ioam_header,
+	[TEST_IN_BIT21]		= check_ioam_header,
+	[TEST_IN_BIT22]		= check_ioam_header_and_data,
+	[TEST_IN_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
+	[TEST_FWD_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
+};
+
 int main(int argc, char **argv)
 {
-	int ret, fd, pkts, size, hoplen, found;
-	struct ioam6_trace_hdr *ioam6h;
+	int fd, size, hoplen, tid, ret = 1;
+	struct in6_addr src, dst;
 	struct ioam6_hdr *opt;
 	struct ipv6hdr *ip6h;
 	__u8 buffer[400], *p;
-	struct args *args;
+	__u16 ioam_ns;
+	__u32 tr_type;
 
-	args = parse_args(argc - 1, argv + 1);
-	if (!args) {
-		ret = 1;
+	if (argc != 7)
+		goto out;
+
+	tid = str2id(argv[2]);
+	if (tid < 0 || !func[tid])
+		goto out;
+
+	if (inet_pton(AF_INET6, argv[3], &src) != 1 ||
+	    inet_pton(AF_INET6, argv[4], &dst) != 1)
+		goto out;
+
+	if (get_u32(&tr_type, argv[5], 16) ||
+	    get_u16(&ioam_ns, argv[6], 0))
 		goto out;
-	}
 
 	fd = socket(AF_PACKET, SOCK_DGRAM, __cpu_to_be16(ETH_P_IPV6));
-	if (!fd) {
-		ret = 1;
+	if (!fd)
 		goto out;
-	}
 
 	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
-		       args->ifname, strlen(args->ifname))) {
-		ret = 1;
+		       argv[1], strlen(argv[1])))
 		goto close;
-	}
 
-	pkts = 0;
-	found = 0;
-	while (pkts < 3 && !found) {
-		size = recv(fd, buffer, sizeof(buffer), 0);
-		ip6h = (struct ipv6hdr *)buffer;
-		pkts++;
+recv:
+	size = recv(fd, buffer, sizeof(buffer), 0);
+	if (size <= 0)
+		goto close;
 
-		if (ip6h->nexthdr == IPPROTO_HOPOPTS) {
-			p = buffer + sizeof(*ip6h);
-			hoplen = (p[1] + 1) << 3;
+	ip6h = (struct ipv6hdr *)buffer;
 
-			p += sizeof(struct ipv6_hopopt_hdr);
-			while (hoplen > 0) {
-				opt = (struct ioam6_hdr *)p;
+	if (!ipv6_addr_equal(&ip6h->saddr, &src) ||
+	    !ipv6_addr_equal(&ip6h->daddr, &dst))
+		goto recv;
 
-				if (opt->opt_type == IPV6_TLV_IOAM &&
-				    opt->type == IOAM6_TYPE_PREALLOC) {
-					found = 1;
+	if (ip6h->nexthdr != IPPROTO_HOPOPTS)
+		goto close;
 
-					p += sizeof(*opt);
-					ioam6h = (struct ioam6_trace_hdr *)p;
+	p = buffer + sizeof(*ip6h);
+	hoplen = (p[1] + 1) << 3;
+	p += sizeof(struct ipv6_hopopt_hdr);
 
-					ret = check_ioam6_trace(ioam6h, args);
-					break;
-				}
+	while (hoplen > 0) {
+		opt = (struct ioam6_hdr *)p;
 
-				p += opt->opt_len + 2;
-				hoplen -= opt->opt_len + 2;
-			}
+		if (opt->opt_type == IPV6_TLV_IOAM &&
+		    opt->type == IOAM6_TYPE_PREALLOC) {
+			p += sizeof(*opt);
+			ret = func[tid](tid, (struct ioam6_trace_hdr *)p,
+					   tr_type, ioam_ns);
+			break;
 		}
-	}
 
-	if (!found)
-		ret = 1;
+		p += opt->opt_len + 2;
+		hoplen -= opt->opt_len + 2;
+	}
 close:
 	close(fd);
 out:
-	free(args);
 	return ret;
 }
-- 
2.25.1

