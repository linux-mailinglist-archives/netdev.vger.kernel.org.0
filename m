Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9266322943
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhBWLIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:08:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:17911 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhBWLHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 06:07:42 -0500
IronPort-SDR: K2VZUGiiqnTpD7JxgX+qF6/efwakzPaUmPtFynCUpaobiYRPKYKdW2iLYAWVkz1Pdz5NBINV+j
 uRF2PszDf0Ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="182283632"
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="182283632"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 03:06:59 -0800
IronPort-SDR: zVQGT7PQvsr3CXoFqw/OgWLC0Qk1eZmwyolPQ+xIn+TJPePhydTHThxGOJWwVQ7gpE6/EGmhIq
 RaPtQ+F0unng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="441703758"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 03:06:27 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 2/4] selftests/bpf: expose and rename debug argument
Date:   Tue, 23 Feb 2021 10:35:05 +0000
Message-Id: <20210223103507.10465-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223103507.10465-1-ciara.loftus@intel.com>
References: <20210223103507.10465-1-ciara.loftus@intel.com>
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
 tools/testing/selftests/bpf/test_xsk.sh    | 7 ++++++-
 tools/testing/selftests/bpf/xdpxceiver.c   | 6 +++---
 tools/testing/selftests/bpf/xsk_prereqs.sh | 3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 91127a5be90d..870ae3f38818 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -74,11 +74,12 @@
 
 . xsk_prereqs.sh
 
-while getopts "cv" flag
+while getopts "cvD" flag
 do
 	case "${flag}" in
 		c) colorconsole=1;;
 		v) verbose=1;;
+		D) dump-pkts=1;;
 	esac
 done
 
@@ -135,6 +136,10 @@ if [[ $verbose -eq 1 ]]; then
 	VERBOSE_ARG="-v"
 fi
 
+if [[ $dump-pkts -eq 1 ]]; then
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

