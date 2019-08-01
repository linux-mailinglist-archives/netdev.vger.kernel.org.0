Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961317E1CE
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbfHASAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfHASAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7CBAC8D9E;
        Thu,  1 Aug 2019 18:00:21 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E96860922;
        Thu,  1 Aug 2019 18:00:17 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A6B1931259BA1;
        Thu,  1 Aug 2019 20:00:16 +0200 (CEST)
Subject: [net v1 PATCH 1/4] bpf: fix XDP vlan selftests test_xdp_vlan.sh
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 01 Aug 2019 20:00:16 +0200
Message-ID: <156468241661.27559.5610881573190983692.stgit@firesoul>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 01 Aug 2019 18:00:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change BPF selftest test_xdp_vlan.sh to (default) use generic XDP.

This selftest was created together with a fix for generic XDP, in commit
297249569932 ("net: fix generic XDP to handle if eth header was
mangled"). And was suppose to catch if generic XDP was broken again.

The tests are using veth and assumed that veth driver didn't support
native driver XDP, thus it used the (ip link set) 'xdp' attach that fell
back to generic-XDP. But veth gained native-XDP support in 948d4f214fde
("veth: Add driver XDP"), which caused this test script to use
native-XDP.

Fixes: 948d4f214fde ("veth: Add driver XDP")
Fixes: 97396ff0bc2d ("selftests/bpf: add XDP selftests for modifying and popping VLAN headers")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh |   42 ++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index 51a3a31d1aac..c8aed63b0ffe 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -1,7 +1,12 @@
 #!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Author: Jesper Dangaard Brouer <hawk@kernel.org>
 
 TESTNAME=xdp_vlan
 
+# Default XDP mode
+XDP_MODE=xdpgeneric
+
 usage() {
   echo "Testing XDP + TC eBPF VLAN manipulations: $TESTNAME"
   echo ""
@@ -9,9 +14,23 @@ usage() {
   echo "  -v | --verbose : Verbose"
   echo "  --flush        : Flush before starting (e.g. after --interactive)"
   echo "  --interactive  : Keep netns setup running after test-run"
+  echo "  --mode=XXX     : Choose XDP mode (xdp | xdpgeneric | xdpdrv)"
   echo ""
 }
 
+valid_xdp_mode()
+{
+	local mode=$1
+
+	case "$mode" in
+		xdpgeneric | xdpdrv | xdp)
+			return 0
+			;;
+		*)
+			return 1
+	esac
+}
+
 cleanup()
 {
 	local status=$?
@@ -37,7 +56,7 @@ cleanup()
 
 # Using external program "getopt" to get --long-options
 OPTIONS=$(getopt -o hvfi: \
-    --long verbose,flush,help,interactive,debug -- "$@")
+    --long verbose,flush,help,interactive,debug,mode: -- "$@")
 if (( $? != 0 )); then
     usage
     echo "selftests: $TESTNAME [FAILED] Error calling getopt, unknown option?"
@@ -60,6 +79,11 @@ while true; do
 		cleanup
 		shift
 		;;
+	    --mode )
+		shift
+		XDP_MODE=$1
+		shift
+		;;
 	    -- )
 		shift
 		break
@@ -81,8 +105,14 @@ if [ "$EUID" -ne 0 ]; then
 	exit 1
 fi
 
-ip link set dev lo xdp off 2>/dev/null > /dev/null
-if [ $? -ne 0 ];then
+valid_xdp_mode $XDP_MODE
+if [ $? -ne 0 ]; then
+	echo "selftests: $TESTNAME [FAILED] unknown XDP mode ($XDP_MODE)"
+	exit 1
+fi
+
+ip link set dev lo xdpgeneric off 2>/dev/null > /dev/null
+if [ $? -ne 0 ]; then
 	echo "selftests: $TESTNAME [SKIP] need ip xdp support"
 	exit 0
 fi
@@ -166,7 +196,7 @@ export FILE=test_xdp_vlan.o
 
 # First test: Remove VLAN by setting VLAN ID 0, using "xdp_vlan_change"
 export XDP_PROG=xdp_vlan_change
-ip netns exec ns1 ip link set $DEVNS1 xdp object $FILE section $XDP_PROG
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # In ns1: egress use TC to add back VLAN tag 4011
 #  (del cmd)
@@ -187,8 +217,8 @@ ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
 # ETH_P_8021Q indication, and this cause overwriting of our changes.
 #
 export XDP_PROG=xdp_vlan_remove_outer2
-ip netns exec ns1 ip link set $DEVNS1 xdp off
-ip netns exec ns1 ip link set $DEVNS1 xdp object $FILE section $XDP_PROG
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
+ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
 ip netns exec ns2 ping -W 2 -c 3 $IPADDR1

