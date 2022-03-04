Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9136F4CDEBF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiCDUEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiCDUEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:14 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8130C24893A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423960; x=1677959960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kZluU2NCyxAed2hBE2ovZyl7Xq48J8RwdT9X6ixUlUc=;
  b=cgPtz/pA6t8bh1sVXc8LJtW0Yzqd8XDwa0gk3NI1i+BwM1gXJrTWcWSV
   FsakMvWaZLC4Kno9uEmQq/Om6EkR3nlrdSm+o7LJxWRWWtmlg4b2lSpmR
   jRkNR6UOlU0Meat6xvqwoZ9rnWD9ViCUz1kAFE0b+Qn/AZtQ43Wm6XRak
   YVl9K257zbOYEpmcXFIb2zJ/n6961+arzfYckEbCHzqnR+PfwS7VjBhih
   fq8ZalCXSNeNWqJaRStOkZMyI7yjRChDQ3X3qyVV8oSHU/1MRHUGJj+p7
   XGNuarrDAcH1fDlz4Vb/t6fd7JqiAi0qLhd7BgPhHszPzdoVsc6MFBaKg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981332"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981332"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340782"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/11] selftests: mptcp: add the MP_FASTCLOSE mibs check
Date:   Fri,  4 Mar 2022 11:36:28 -0800
Message-Id: <20220304193636.219315-4-mathew.j.martineau@linux.intel.com>
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

This patch added a new function chk_fclose_nr() to check the numbers
of the MP_FASTCLOSE sending and receiving mibs.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 88740cfe49dd..10339a796325 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -792,6 +792,38 @@ chk_fail_nr()
 	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
+chk_fclose_nr()
+{
+	local fclose_tx=$1
+	local fclose_rx=$2
+	local count
+	local dump_stats
+
+	printf "%-${nr_blank}s %s" " " "ctx"
+	count=$(ip netns exec $ns2 nstat -as | grep MPTcpExtMPFastcloseTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$fclose_tx" ]; then
+		echo "[fail] got $count MP_FASTCLOSE[s] TX expected $fclose_tx"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - fclzrx"
+	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPFastcloseRx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$fclose_rx" ]; then
+		echo "[fail] got $count MP_FASTCLOSE[s] RX expected $fclose_rx"
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	[ "${dump_stats}" = 1 ] && dump_stats
+}
+
 chk_join_nr()
 {
 	local msg="$1"
-- 
2.35.1

