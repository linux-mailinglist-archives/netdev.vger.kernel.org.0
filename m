Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85566339A7D
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhCMAoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:44:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:5022 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCMAoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 19:44:05 -0500
IronPort-SDR: VKGarerr0AsOczc9g97fexYxOz9XARSFuDPZG05pSy38UrogXD6H9PiqnRC53PHUaIRD0dvdq6
 MFYxJs4bL6tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250276273"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250276273"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 16:44:01 -0800
IronPort-SDR: KyAPreyQTGvTZq2rSkCrESyjra/rfmyR225xC7otFytW2VdtzpE6ccwBbPQ7lP6Wyc3Oi1tP0r
 U8VcudQcI90A==
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="404592905"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 16:44:01 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH net] selftests: mptcp: Restore packet capture option in join tests
Date:   Fri, 12 Mar 2021 16:43:52 -0800
Message-Id: <20210313004352.209906-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The join self tests previously used the '-c' command line option to
enable creation of pcap files for the tests that run, but the change to
allow running a subset of the join tests made overlapping use of that
option.

Restore the capture functionality with '-c' and move the syncookie test
option to '-k'.

Fixes: 1002b89f23ea ("selftests: mptcp: add command line arguments for mptcp_join.sh")
Acked-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 30 ++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 964db9ed544f..ad32240fbfda 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -11,6 +11,7 @@ ksft_skip=4
 timeout=30
 mptcp_connect=""
 capture=0
+do_all_tests=1
 
 TEST_COUNT=0
 
@@ -121,12 +122,6 @@ reset_with_add_addr_timeout()
 		-j DROP
 }
 
-for arg in "$@"; do
-	if [ "$arg" = "-c" ]; then
-		capture=1
-	fi
-done
-
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"
@@ -1221,7 +1216,8 @@ usage()
 	echo "  -4 v4mapped_tests"
 	echo "  -b backup_tests"
 	echo "  -p add_addr_ports_tests"
-	echo "  -c syncookies_tests"
+	echo "  -k syncookies_tests"
+	echo "  -c capture pcap files"
 	echo "  -h help"
 }
 
@@ -1235,12 +1231,24 @@ make_file "$cin" "client" 1
 make_file "$sin" "server" 1
 trap cleanup EXIT
 
-if [ -z $1 ]; then
+for arg in "$@"; do
+	# check for "capture" arg before launching tests
+	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"c"[0-9a-zA-Z]*$ ]]; then
+		capture=1
+	fi
+
+	# exception for the capture option, the rest means: a part of the tests
+	if [ "${arg}" != "-c" ]; then
+		do_all_tests=0
+	fi
+done
+
+if [ $do_all_tests -eq 1 ]; then
 	all_tests
 	exit $ret
 fi
 
-while getopts 'fsltra64bpch' opt; do
+while getopts 'fsltra64bpkch' opt; do
 	case $opt in
 		f)
 			subflows_tests
@@ -1272,9 +1280,11 @@ while getopts 'fsltra64bpch' opt; do
 		p)
 			add_addr_ports_tests
 			;;
-		c)
+		k)
 			syncookies_tests
 			;;
+		c)
+			;;
 		h | *)
 			usage
 			;;

base-commit: 080bfa1e6d928a5d1f185cc44e5f3c251df06df5
-- 
2.30.2

