Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F8D30C0F8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhBBOKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:10:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:52468 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233488AbhBBOJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:12 -0500
IronPort-SDR: ECLz+YfyR5CHpgS5SdeRfITtP5xws0w7S6VCW93OWJRVlxYsfjUodVZ0V074zAG0wjazY2Iscj
 uG4EQIFhWZew==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="242371368"
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="242371368"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 06:06:45 -0800
IronPort-SDR: 1WGhji6db57yV3WojH2UFceF8br/zZPkvAGfykmAaoo+XKCflFNruUB7UxyGJ0sEFUPVzsrUT1
 8hW994AivgFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="479774673"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2021 06:06:43 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     daniel@iogearbox.net, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 2/6] selftests/bpf: restructure setting the packet count
Date:   Tue,  2 Feb 2021 13:36:38 +0000
Message-Id: <20210202133642.8562-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202133642.8562-1-ciara.loftus@intel.com>
References: <20210202133642.8562-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this, the packet count was fixed at 10000 for every test.
Future tracing tests need to modify the count in order to ensure
the trace buffer does not become full. So, make it possible to set
the count from test_xsk.h using the -C opt.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 17 +++++++++--------
 tools/testing/selftests/bpf/xsk_prereqs.sh |  3 +--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 88a7483eaae4..2b4a4f42b220 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -82,6 +82,7 @@ do
 done
 
 TEST_NAME="PREREQUISITES"
+DEFAULTPKTS=10000
 
 URANDOM=/dev/urandom
 [ ! -e "${URANDOM}" ] && { echo "${URANDOM} not found. Skipping tests."; test_exit 1 1; }
@@ -154,7 +155,7 @@ TEST_NAME="SKB NOPOLL"
 
 vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
 
-params=("-S")
+params=("-S" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -166,7 +167,7 @@ TEST_NAME="SKB POLL"
 
 vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
 
-params=("-S" "-p")
+params=("-S" "-p" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -178,7 +179,7 @@ TEST_NAME="DRV NOPOLL"
 
 vethXDPnative ${VETH0} ${VETH1} ${NS1}
 
-params=("-N")
+params=("-N" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -190,7 +191,7 @@ TEST_NAME="DRV POLL"
 
 vethXDPnative ${VETH0} ${VETH1} ${NS1}
 
-params=("-N" "-p")
+params=("-N" "-p" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -202,7 +203,7 @@ TEST_NAME="SKB SOCKET TEARDOWN"
 
 vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
 
-params=("-S" "-T")
+params=("-S" "-T" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -214,7 +215,7 @@ TEST_NAME="DRV SOCKET TEARDOWN"
 
 vethXDPnative ${VETH0} ${VETH1} ${NS1}
 
-params=("-N" "-T")
+params=("-N" "-T" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -226,7 +227,7 @@ TEST_NAME="SKB BIDIRECTIONAL SOCKETS"
 
 vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
 
-params=("-S" "-B")
+params=("-S" "-B" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
@@ -238,7 +239,7 @@ TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
 
 vethXDPnative ${VETH0} ${VETH1} ${NS1}
 
-params=("-N" "-B")
+params=("-N" "-B" "-C" "${DEFAULTPKTS}")
 execxdpxceiver params
 
 retval=$?
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index 9d54c4645127..41dd713d14df 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -15,7 +15,6 @@ NC='\033[0m'
 STACK_LIM=131072
 SPECFILE=veth.spec
 XSKOBJ=xdpxceiver
-NUMPKTS=10000
 
 validate_root_exec()
 {
@@ -131,5 +130,5 @@ execxdpxceiver()
 			copy[$index]=${!current}
 		done
 
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]}
 }
-- 
2.17.1

