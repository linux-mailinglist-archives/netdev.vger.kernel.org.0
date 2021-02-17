Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7F31DD6E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhBQQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:34:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:47635 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhBQQdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 11:33:44 -0500
IronPort-SDR: EF7IQHBw3BLlmTQQJRdLcSbOQlWyhpSX1eozfMHopicjmbsaHzihjRTitc3mVWXo1PACvnZtGz
 QMsM/xCC7Jog==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="183315340"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="183315340"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 08:33:04 -0800
IronPort-SDR: rMKy0sfql9DbXlJTX70E7q9z/Q3+HDIp0CWMUm5ZPqPVyGrQlRVcUbYfZPJYjuWW7FrG0j1M9F
 dTwgn8hMNzXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="494184872"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 17 Feb 2021 08:33:02 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 2/4] selftests/bpf: expose debug arg to shell script for xsk tests
Date:   Wed, 17 Feb 2021 16:02:12 +0000
Message-Id: <20210217160214.7869-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210217160214.7869-1-ciara.loftus@intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Launching xdpxceiver with -D enables debug mode. Make it possible
to pass this flag to the app via the test_xsk.sh shell script like
so:

./test_xsk.sh -d

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 7 ++++++-
 tools/testing/selftests/bpf/xsk_prereqs.sh | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 91127a5be90d..a72f8ed2932d 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -74,11 +74,12 @@
 
 . xsk_prereqs.sh
 
-while getopts "cv" flag
+while getopts "cvd" flag
 do
 	case "${flag}" in
 		c) colorconsole=1;;
 		v) verbose=1;;
+		d) debug=1;;
 	esac
 done
 
@@ -135,6 +136,10 @@ if [[ $verbose -eq 1 ]]; then
 	VERBOSE_ARG="-v"
 fi
 
+if [[ $debug -eq 1 ]]; then
+	DEBUG_ARG="-D"
+fi
+
 test_status $retval "${TEST_NAME}"
 
 ## START TESTS
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index ef8c5b31f4b6..d95018051fcc 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -128,5 +128,6 @@ execxdpxceiver()
 			copy[$index]=${!current}
 		done
 
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG} \
+		${DEBUG_ARG}
 }
-- 
2.17.1

