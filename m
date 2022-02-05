Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B054AA4DD
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378638AbiBEADw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:46963 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378618AbiBEADt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019430; x=1675555430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfbmUcVWCl5wd94io4ujwqYMesa9mKGmoOG+bRtuJgU=;
  b=MN1T1h1LDbOhFrj8WNwJI1i0pNHO+IFR/C+gjRJxzfHgrMGwRhsijFZC
   ZsNuWyffJ4MaqbDDnEhPSNFd/xkbsBW122wkZMSlQw5Ys9WMSaa98GLo3
   0fnRRc/OwBZqoejZQSAAvuNfqs93WAzjdK+aVfilsgMIUoNCMlkG5myiA
   JClq9ZigTEBNu5TFXB61Wusy5fhxu+VQqpWRoLqkzuIuzlmXUJXcocmtY
   XtFiiEuSjzqwN4MkvVlY6oPiQHB4vCk79QK40qWL03oS0vxTpLbTUO91H
   KbwzYaYfz4xNrUT0lZO/qH4ivXw4p89d5OPl5HbpudM/7b2hTdmuEu538
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115102"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115102"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097535"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 9/9] selftests: mptcp: set ip_mptcp in command line
Date:   Fri,  4 Feb 2022 16:03:37 -0800
Message-Id: <20220205000337.187292-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added a command line option '-i' for mptcp_join.sh to use
'ip mptcp' commands instead of using 'pm_nl_ctl' commands to deal with
PM netlink.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 757f26674c62..4a565fb84137 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2117,6 +2117,7 @@ usage()
 	echo "  -m fullmesh_tests"
 	echo "  -c capture pcap files"
 	echo "  -C enable data checksum"
+	echo "  -i use ip mptcp"
 	echo "  -h help"
 }
 
@@ -2138,9 +2139,12 @@ for arg in "$@"; do
 	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"C"[0-9a-zA-Z]*$ ]]; then
 		checksum=1
 	fi
+	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"i"[0-9a-zA-Z]*$ ]]; then
+		ip_mptcp=1
+	fi
 
-	# exception for the capture/checksum options, the rest means: a part of the tests
-	if [ "${arg}" != "-c" ] && [ "${arg}" != "-C" ]; then
+	# exception for the capture/checksum/ip_mptcp options, the rest means: a part of the tests
+	if [ "${arg}" != "-c" ] && [ "${arg}" != "-C" ] && [ "${arg}" != "-i" ]; then
 		do_all_tests=0
 	fi
 done
@@ -2150,7 +2154,7 @@ if [ $do_all_tests -eq 1 ]; then
 	exit $ret
 fi
 
-while getopts 'fesltra64bpkdmchCS' opt; do
+while getopts 'fesltra64bpkdmchCSi' opt; do
 	case $opt in
 		f)
 			subflows_tests
@@ -2201,6 +2205,8 @@ while getopts 'fesltra64bpkdmchCS' opt; do
 			;;
 		C)
 			;;
+		i)
+			;;
 		h | *)
 			usage
 			;;
-- 
2.35.1

