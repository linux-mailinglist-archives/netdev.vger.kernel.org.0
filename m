Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D478C4CDE6F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiCDUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiCDUDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:03:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415B2FD3DE
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423984; x=1677959984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wc9PGwvPhtaF4JiP57AOPUOF9WiO6euM1D/bIVvEp5I=;
  b=dRbWQ5KLpHbOb7MAxz8/I5MEhxKYYHG3JBTqnEWPcylfwhdo2Oq6iixM
   kWAuC2hBfBv1P6kRPBoSYdhiup84jzkhfCz14cyUPMrPIfCUfeXGH59G/
   t+P6EGNF6e3ApmyoDd4mf9dq9llfr4c15k03OoTcfU4e6rB6qOaCES5Bt
   H3y9+T4LCBZG29BDa6g+tROQabjGJlfcxg/hue+o5Dvng3Hi9BmOxtw1U
   NaBL/a+IJY3YFpVbQlcJfTMAFnlCEOt2zljOGD0MupO/FawrncY0ePL5D
   cdkntRF3JXmkXNSVbjS7F923qLAvwUzze+4aoRY9uQ34RAa/ffSfvbRQ5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981337"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981337"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340791"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/11] selftests: mptcp: add fastclose testcase
Date:   Fri,  4 Mar 2022 11:36:33 -0800
Message-Id: <20220304193636.219315-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the self test for MP_FASTCLOSE. Reused the argument
addr_nr_ns2 of do_transfer() to pass the extra arguments '-I 2' to
mptcp_connect commands. Then mptcp_connect disconnected the
connections to trigger the MP_FASTCLOSE sending and receiving. Used
chk_fclose_nr to check the MP_FASTCLOSE mibs and used chk_rst_nr to
check the MP_RST mibs. This test used the test_linkfail value to make
1024KB test files.

The output looks like this:

Created /tmp/tmp.XB8sfv1hJ0 (size 1024 KB) containing data sent by client
Created /tmp/tmp.RtTDbzqrXI (size 1024 KB) containing data sent by server
001 fastclose test                syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  ctx[ ok ] - fclzrx[ ok ]
                                  rtx[ ok ] - rstrx [ ok ]   invert

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 1fda29d5d69f..4604dd13a87e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -452,6 +452,12 @@ do_transfer()
 		extra_args="-r ${speed:6}"
 	fi
 
+	if [[ "${addr_nr_ns2}" = "fastclose_"* ]]; then
+		# disconnect
+		extra_args="$extra_args -I ${addr_nr_ns2:10}"
+		addr_nr_ns2=0
+	fi
+
 	local local_addr
 	if is_v6 "${connect_addr}"; then
 		local_addr="::"
@@ -2196,6 +2202,15 @@ fullmesh_tests()
 	chk_rm_nr 0 1
 }
 
+fastclose_tests()
+{
+	reset
+	run_tests $ns1 $ns2 10.0.1.1 1024 0 fastclose_2
+	chk_join_nr "fastclose test" 0 0 0
+	chk_fclose_nr 1 1
+	chk_rst_nr 1 1 invert
+}
+
 all_tests()
 {
 	subflows_tests
@@ -2213,6 +2228,7 @@ all_tests()
 	checksum_tests
 	deny_join_id0_tests
 	fullmesh_tests
+	fastclose_tests
 }
 
 # [$1: error message]
@@ -2239,6 +2255,7 @@ usage()
 	echo "  -S checksum_tests"
 	echo "  -d deny_join_id0_tests"
 	echo "  -m fullmesh_tests"
+	echo "  -z fastclose_tests"
 	echo "  -c capture pcap files"
 	echo "  -C enable data checksum"
 	echo "  -i use ip mptcp"
@@ -2270,7 +2287,7 @@ if [ $do_all_tests -eq 1 ]; then
 	exit $ret
 fi
 
-while getopts 'fesltra64bpkdmchCSi' opt; do
+while getopts 'fesltra64bpkdmchzCSi' opt; do
 	case $opt in
 		f)
 			subflows_tests
@@ -2317,6 +2334,9 @@ while getopts 'fesltra64bpkdmchCSi' opt; do
 		m)
 			fullmesh_tests
 			;;
+		z)
+			fastclose_tests
+			;;
 		c)
 			;;
 		C)
-- 
2.35.1

