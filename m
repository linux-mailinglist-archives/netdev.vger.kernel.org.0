Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5507B4BAFF1
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiBRDDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiBRDDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9253459A64
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153401; x=1676689401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ATRa+uik1AsrOEVB2CM3pwo/U8VGumfyuTnhTNOouXM=;
  b=bnEksq20TGFL5rQIL5TDLMf2qayma6itnKVItriqmCKvOsOTUI+ca/2o
   e7p0SExu2+GCC7tnpTiYbYjWRniLbVZDlXKEiFuhIxtITnUObZS9/4C72
   yTvqj8RWbQRQHJZQ/n22ECfGYZvSZiA/XE6Tldsb2dQJY7n9dc2qGI5Xq
   BdVHON+9AM3tW0qIQ4UfbpQtevPA2GeXQsRaipCZN1Kp+Vk+v2jFcpuVq
   5s4J5tsfWnpbBEOXUF4t5Nb6c8CyrlVI7mSGGxDt+Mj9/7WtXuwEkB2tH
   82RO/nEC4XttHQXi1g5XSQ426ieQpQAco4W2aH98Uhy0I49z6p5HG13SP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794600"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794600"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431968"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/7] selftests: mptcp: add csum mib check for mptcp_connect
Date:   Thu, 17 Feb 2022 19:03:11 -0800
Message-Id: <20220218030311.367536-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the data checksum error mib counters check for the
script mptcp_connect.sh when the data checksum is enabled.

In do_transfer(), got the mib counters twice, before and after running
the mptcp_connect commands. The latter minus the former is the actual
number of the data checksum mib counter.

The output looks like this:

ns1 MPTCP -> ns2 (dead:beef:1::2:10007) MPTCP   (duration    86ms) [ OK ]
ns1 MPTCP -> ns2 (10.0.2.1:10008      ) MPTCP   (duration    66ms) [ FAIL ]
server got 1 data checksum error[s]

Fixes: 94d66ba1d8e48 ("selftests: mptcp: enable checksum in mptcp_connect.sh")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/255
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index cb5809b89081..5b7a40d73253 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -432,6 +432,8 @@ do_transfer()
 	local stat_ackrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	local stat_cookietx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	local stat_csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+	local stat_csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -524,6 +526,23 @@ do_transfer()
 		fi
 	fi
 
+	if $checksum; then
+		local csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+		local csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+
+		local csum_err_s_nr=$((csum_err_s - stat_csum_err_s))
+		if [ $csum_err_s_nr -gt 0 ]; then
+			printf "[ FAIL ]\nserver got $csum_err_s_nr data checksum error[s]"
+			rets=1
+		fi
+
+		local csum_err_c_nr=$((csum_err_c - stat_csum_err_c))
+		if [ $csum_err_c_nr -gt 0 ]; then
+			printf "[ FAIL ]\nclient got $csum_err_c_nr data checksum error[s]"
+			retc=1
+		fi
+	fi
+
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
 		printf "[ OK ]"
 	fi
-- 
2.35.1

