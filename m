Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023094CDDFB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiCDUEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiCDUEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:22 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4632723A1B1
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423974; x=1677959974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e4H1NNFEPEPtaUDrXkY9mhWAswryRgKMsLlxBfLPh78=;
  b=MzeBe8M4EcoF2E10tc0yZJgSAzy+dPX0ERPi5Wfgj3AsLGTDWE17ppna
   bQBaZdwRQHfR3kWZXxhLJoWph8iKpM0i1HEMtAh1J1Q0dAyT/5afu42b2
   MSPbQOOMxrh0pOhIgn4eIFtF4W96bvEoS6yYmTYCj+1VcUGJWVamxZ20z
   TDVQvIaimH2s3NYu1ku4MgA4TYZVRp92upeq8b83UG4MDz+eGJ83F0Vzw
   Etq93p1MIr/sF57xBTpVpr0QyDtWt1vLQT6N+VFGMlkVNsX9gHeXeYpOm
   EpR2RIpAZZWLbVEPz0yaOcB7Qd6QxJm+Ym9T6A3giqP79ModRRDLPbfMs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981334"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340787"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/11] selftests: mptcp: add the MP_RST mibs check
Date:   Fri,  4 Mar 2022 11:36:30 -0800
Message-Id: <20220304193636.219315-6-mathew.j.martineau@linux.intel.com>
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

This patch added a new function chk_rst_nr() to check the numbers
of the MP_RST sending and receiving mibs.

Showed in the output whether the inverted namespaces check order is used.
Since if we pass -Cz to mptcp_join.sh, the MP_RST information is showed
twice.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 10339a796325..12008640d9f4 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -824,6 +824,50 @@ chk_fclose_nr()
 	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
+chk_rst_nr()
+{
+	local rst_tx=$1
+	local rst_rx=$2
+	local ns_invert=${3:-""}
+	local count
+	local dump_stats
+	local ns_tx=$ns1
+	local ns_rx=$ns2
+	local extra_msg=""
+
+	if [[ $ns_invert = "invert" ]]; then
+		ns_tx=$ns2
+		ns_rx=$ns1
+		extra_msg="   invert"
+	fi
+
+	printf "%-${nr_blank}s %s" " " "rtx"
+	count=$(ip netns exec $ns_tx nstat -as | grep MPTcpExtMPRstTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$rst_tx" ]; then
+		echo "[fail] got $count MP_RST[s] TX expected $rst_tx"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - rstrx "
+	count=$(ip netns exec $ns_rx nstat -as | grep MPTcpExtMPRstRx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$rst_rx" ]; then
+		echo "[fail] got $count MP_RST[s] RX expected $rst_rx"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	[ "${dump_stats}" = 1 ] && dump_stats
+
+	echo "$extra_msg"
+}
+
 chk_join_nr()
 {
 	local msg="$1"
@@ -878,6 +922,7 @@ chk_join_nr()
 	if [ $checksum -eq 1 ]; then
 		chk_csum_nr
 		chk_fail_nr 0 0
+		chk_rst_nr 0 0
 	fi
 }
 
-- 
2.35.1

