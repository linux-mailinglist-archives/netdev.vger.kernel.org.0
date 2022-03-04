Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626814CDE0B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiCDUE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiCDUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D72A753B
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423998; x=1677959998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ROvep7kyVqc+GmBw/uIi6w1KfX09rcAB6oWAZ89yNz0=;
  b=evDXzoLaFMmlbpeUVQMEz6GenZd/lNbeY0HcZ/D0+Bou4oXtaImoPxQg
   R93hSKbO5pPoJAFWfq33K5/hN0nNIieZMERKi7wkctflavW+N5YgRoSmJ
   rWE+xRbzpdV7Way9qgqhf32YWVLRrPf1asZt65SIk0iew9RJx2tLFBI7M
   3Y6prgns4Xyaxrl+iE4szBj1L9bMvMb+9gJ6okQ3XB1Ayh5hEF3Zl6FLG
   40a1ILxyQbmMPHQtRiz7T2PWu0bOB+KF/2rALVdqfzbE9F0fEft87NhzR
   44Klc73Cp+cZyhxGn5yVa6Sd/erW3e8IvplMECI6WX7GF9MqkPVPrSoU9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981338"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981338"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340792"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/11] selftests: mptcp: add invert check in check_transfer
Date:   Fri,  4 Mar 2022 11:36:34 -0800
Message-Id: <20220304193636.219315-10-mathew.j.martineau@linux.intel.com>
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

This patch added the invert bytes check for the output data in
check_transfer().

Instead of the file mismatch error:

  [ FAIL ] file received by server does not match (in, out):
  -rw------- 1 root root 45643832 Jan 16 15:04 /tmp/tmp.9xpM6Paivv
  Trailing bytes are:
  MPTCP_TEST_FILE_END_MARKER
  -rw------- 1 root root 45643832 Jan 16 15:04 /tmp/tmp.wnz1Yp4u7Z
  Trailing bytes are:
  MPTCP_TEST_FILE_END_MARKER

Print out the inverted bytes like this:

  file received by server has inverted byte at 7454789
  file received by server has inverted byte at 7454790
  file received by server has inverted byte at 7454791
  file received by server has inverted byte at 7454792

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 4604dd13a87e..f4812e820acf 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -15,6 +15,7 @@ timeout_test=$((timeout_poll * 2 + 1))
 capture=0
 checksum=0
 ip_mptcp=0
+check_invert=0
 do_all_tests=1
 init=0
 
@@ -59,6 +60,8 @@ init_partial()
 		fi
 	done
 
+	check_invert=0
+
 	#  ns1              ns2
 	# ns1eth1    ns2eth1
 	# ns1eth2    ns2eth2
@@ -216,15 +219,21 @@ check_transfer()
 	out=$2
 	what=$3
 
-	cmp "$in" "$out" > /dev/null 2>&1
-	if [ $? -ne 0 ] ;then
-		echo "[ FAIL ] $what does not match (in, out):"
-		print_file_err "$in"
-		print_file_err "$out"
-		ret=1
+	cmp -l "$in" "$out" | while read line; do
+		local arr=($line)
 
-		return 1
-	fi
+		let sum=0${arr[1]}+0${arr[2]}
+		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
+			echo "[ FAIL ] $what does not match (in, out):"
+			print_file_err "$in"
+			print_file_err "$out"
+			ret=1
+
+			return 1
+		else
+			echo "$what has inverted byte at ${arr[0]}"
+		fi
+	done
 
 	return 0
 }
-- 
2.35.1

