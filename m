Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2536052C5F5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiERWGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiERWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:06:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D11B1CD2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652911494; x=1684447494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7jv4TLkPgS77sTOajhv/AhHBPudRU+BK3j6zHr5UKYM=;
  b=ZYM6iBSFBCNyJ0IkB/0PJGvv45zYTq3yHYHZ0kZASVuAZCHxFEzaptTp
   EgYsXK4BLmePCAlUKV0hJAj3UUj+2r4RBnT/F6sM8EGjHS79iJfFHPsQ5
   no+K94t8x+BdlUXrhv3xoyGTo8S020EyCnTIUCzfb7GdAOFTZroP1M6US
   oc3s2ChZaBiQOsIiFE40assefS1qS6FDHrIEOdDYagza81zrwqwpxL7Cv
   ASmbLcjfTwuTYdTAaoQbueJadKGkOAbT2B5u9CNsWdCxBzXLeVz4eZwRy
   Ou/8+uqCersrBiAb+R2mj3/SzgzVH7uEwZy9vEtezJ9wfbJyAY2Fv6/HK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270734209"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="270734209"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="598075443"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] selftests: mptcp: add MP_FAIL reset testcase
Date:   Wed, 18 May 2022 15:04:46 -0700
Message-Id: <20220518220446.209750-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
References: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Add the multiple subflows test case for MP_FAIL, to test the MP_FAIL
reset case. Use the test_linkfail value to make 1024KB test files.

Invoke reset_with_fail() to use 'iptables' and 'tc action pedit' rules
to produce the bit flips to trigger the checksum failures on ns2eth2.
Add delays on ns2eth1 to make sure more data can translate on ns2eth2.

The check_invert flag is enabled in reset_with_fail(), so this test
prints out the inverted bytes, instead of the file mismatch errors.

Invoke pedit_action_pkts() to get the numbers of the packets edited
by the tc pedit actions, and print this numbers to the output.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 7381d1f85209..91039605d82f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2705,6 +2705,16 @@ fail_tests()
 		chk_join_nr 0 0 0 +1 +0 1 0 1 "$(pedit_action_pkts)"
 		chk_fail_nr 1 -1 invert
 	fi
+
+	# multiple subflows
+	if reset_with_fail "MP_FAIL MP_RST" 2; then
+		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 1024
+		chk_join_nr 1 1 1 1 0 1 1 0 "$(pedit_action_pkts)"
+	fi
 }
 
 userspace_tests()
-- 
2.36.1

