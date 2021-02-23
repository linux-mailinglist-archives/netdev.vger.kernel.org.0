Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17D4322F2B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhBWQ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:56:10 -0500
Received: from mga18.intel.com ([134.134.136.126]:11206 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233585AbhBWQ4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:56:01 -0500
IronPort-SDR: V5uNaYmNJCIHJw0oSE4BP23d1fNcZKSVW+ndvuSbqkQxbGxVV2Lf98Swp3mijC2PKPslJFg0K0
 Sj9+Q9AOQyeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="172522720"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="172522720"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 08:55:18 -0800
IronPort-SDR: jM60HyQ6DAyvTsPDltHuzLXx2V/Dho1zU/6qbyHSQIXa+y3WQIKC0DecZE+axMwQ3VS6QbqAmw
 6lII/ParM1pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="441792457"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 08:54:40 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 2/4] selftests/bpf: expose and rename debug argument
Date:   Tue, 23 Feb 2021 16:23:02 +0000
Message-Id: <20210223162304.7450-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223162304.7450-1-ciara.loftus@intel.com>
References: <20210223162304.7450-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Launching xdpxceiver with -D enables what was formerly know as 'debug'
mode. Rename this mode to 'dump-pkts' as it better describes the
behavior enabled by the option. New usage:

./xdpxceiver .. -D
or
./xdpxceiver .. --dump-pkts

Also make it possible to pass this flag to the app via the test_xsk.sh
shell script like so:

./test_xsk.sh -D

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 10 +++++++++-
 tools/testing/selftests/bpf/xdpxceiver.c   |  6 +++---
 tools/testing/selftests/bpf/xsk_prereqs.sh |  3 ++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index f4cedf4c2718..dbb129a36606 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -74,14 +74,18 @@
 #
 # Run with verbose output:
 #   sudo ./test_xsk.sh -v
+#
+# Run and dump packet contents:
+#   sudo ./test_xsk.sh -D
 
 . xsk_prereqs.sh
 
-while getopts "cv" flag
+while getopts "cvD" flag
 do
 	case "${flag}" in
 		c) colorconsole=1;;
 		v) verbose=1;;
+		D) dump_pkts=1;;
 	esac
 done
 
@@ -138,6 +142,10 @@ if [[ $verbose -eq 1 ]]; then
 	VERBOSE_ARG="-v"
 fi
 
+if [[ $dump_pkts -eq 1 ]]; then
+	DUMP_PKTS_ARG="-D"
+fi
+
 test_status $retval "${TEST_NAME}"
 
 ## START TESTS
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8af746c9a6b6..506423201197 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -58,7 +58,7 @@
  * - Rx thread verifies if all 10k packets were received and delivered in-order,
  *   and have the right content
  *
- * Enable/disable debug mode:
+ * Enable/disable packet dump mode:
  * --------------------------
  * To enable L2 - L4 headers and payload dump of each packet on STDOUT, add
  * parameter -D to params array in test_xsk.sh, i.e. params=("-S" "-D")
@@ -340,7 +340,7 @@ static struct option long_options[] = {
 	{"copy", no_argument, 0, 'c'},
 	{"tear-down", no_argument, 0, 'T'},
 	{"bidi", optional_argument, 0, 'B'},
-	{"debug", optional_argument, 0, 'D'},
+	{"dump-pkts", optional_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -359,7 +359,7 @@ static void usage(const char *prog)
 	    "  -c, --copy           Force copy mode\n"
 	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -B, --bidi           Bi-directional sockets test\n"
-	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
+	    "  -D, --dump-pkts      Dump packets L2 - L5\n"
 	    "  -v, --verbose        Verbose output\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index ef8c5b31f4b6..da93575d757a 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -128,5 +128,6 @@ execxdpxceiver()
 			copy[$index]=${!current}
 		done
 
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG} \
+		${DUMP_PKTS_ARG}
 }
-- 
2.17.1

