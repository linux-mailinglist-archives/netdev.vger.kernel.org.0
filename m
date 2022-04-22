Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE150C3EE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiDVWai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiDVWaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28042336DD2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664565; x=1682200565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3K/31va/RyyDkPboWS2IboZC2kBhh+5PAFP+cCkjibQ=;
  b=XKaJw2zH8D/yiH/OtcruU4UklkuYOfztO6bYJ5J+7zzewLv2olXqnYN7
   TssI8tuFvEayFU3Pk5GWrDAaWhoCgQqN/6yzlSkE9FK4tMqznEiaqbzC0
   UI4TwpGfiu+hwgw1imryJCvq7876JpUFvdQgOediYh1gudKVX7/GZ4M29
   c49SAtrfWKNCR9WvSnfYEf4Ntiqw6C2YecVEZHj5CmKBKSId9JXM+/1SP
   HDDRXs6HqoWD1hH1zmDuGp9AxZoN35mBcFNXOCdZAFpXTRGSJSl+YU3PJ
   PQEtZWhGu23jWvtqIVIAgHB1IkhuxaVU3hV+JI6ynBAF/0Netbbu0fcom
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285985"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285985"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119267"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] selftests: mptcp: add infinite map mibs check
Date:   Fri, 22 Apr 2022 14:55:43 -0700
Message-Id: <20220422215543.545732-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
References: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds a function chk_infi_nr() to check the mibs for the
infinite mapping. Invoke it in chk_join_nr() when validate_checksum
is set.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 7314257d248a..9eb4d889a24a 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1106,6 +1106,38 @@ chk_rst_nr()
 	echo "$extra_msg"
 }
 
+chk_infi_nr()
+{
+	local infi_tx=$1
+	local infi_rx=$2
+	local count
+	local dump_stats
+
+	printf "%-${nr_blank}s %s" " " "itx"
+	count=$(ip netns exec $ns2 nstat -as | grep InfiniteMapTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$infi_tx" ]; then
+		echo "[fail] got $count infinite map[s] TX expected $infi_tx"
+		fail_test
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - infirx"
+	count=$(ip netns exec $ns1 nstat -as | grep InfiniteMapRx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$infi_rx" ]; then
+		echo "[fail] got $count infinite map[s] RX expected $infi_rx"
+		fail_test
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
 	local syn_nr=$1
@@ -1115,7 +1147,8 @@ chk_join_nr()
 	local csum_ns2=${5:-0}
 	local fail_nr=${6:-0}
 	local rst_nr=${7:-0}
-	local corrupted_pkts=${8:-0}
+	local infi_nr=${8:-0}
+	local corrupted_pkts=${9:-0}
 	local count
 	local dump_stats
 	local with_cookie
@@ -1170,6 +1203,7 @@ chk_join_nr()
 		chk_csum_nr $csum_ns1 $csum_ns2
 		chk_fail_nr $fail_nr $fail_nr
 		chk_rst_nr $rst_nr $rst_nr
+		chk_infi_nr $infi_nr $infi_nr
 	fi
 }
 
-- 
2.36.0

