Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0E62ADDB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKOWK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKOWKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:10:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD9A30564
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668550253; x=1700086253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h27g9PViRa+DdVfY8WqZPlUq8vMy1a58+HzU30dDaXY=;
  b=cFoMODCOij7aulU/hbG4wzvMQyrAeYIfp+F2zGTnL7MGsnhF/cLUfUK0
   ZnPYyfPdfNqjNA3cn2CamRvm5xe0JgNlBNSXANN/0Sbfo+CD5AXlbeGbC
   bKXDmfA+DtQnlxCcHnhlUfH636pyXFzyeEBMRW8MwA+2d2f9c/aM/2k9O
   J8a1aU9Bo5iZy3jEnE/yoE8vSPfqnXL0eNFd3YgVOaSBLVPb0zSD0YSlg
   XVYKDUAJoAwTwyDYUdWIhbi6ASbKGfoe6FYLohXw6kjQnYCCrTbETu5hg
   ByqKbf5jYara7MqBDIDQbucaS12xtG6vRMhhJxtoHG9ITIVzdYIFARcrk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="299906719"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="299906719"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="616917997"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="616917997"
Received: from imunagan-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.21.103])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:52 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/3] selftests: mptcp: fix mibit vs mbit mix up
Date:   Tue, 15 Nov 2022 14:10:46 -0800
Message-Id: <20221115221046.20370-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
References: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

The estimated time was supposing the rate was expressed in mibit
(bit * 1024^2) but it is in mbit (bit * 1000^2).

This makes the threshold higher but in a more realistic way to avoid
false positives reported by CI instances.

Before this patch, the thresholds were at 7561/4005ms and now they are
at 7906/4178ms.

While at it, also fix a typo in the linked comment, spotted by Mat.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/310
Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index ffa13a957a36..40aeb5a71a2a 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -247,9 +247,10 @@ run_test()
 	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
 	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
 
-	# time is measured in ms, account for transfer size, affegated link speed
+	# time is measured in ms, account for transfer size, aggregated link speed
 	# and header overhead (10%)
-	local time=$((size * 8 * 1000 * 10 / (( $rate1 + $rate2) * 1024 *1024 * 9) ))
+	#              ms    byte -> bit   10%        mbit      -> kbit -> bit  10%
+	local time=$((1000 * size  *  8  * 10 / ((rate1 + rate2) * 1000 * 1000 * 9) ))
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
 	# completion (see mptcp_connect): 200ms on each side, add some slack
-- 
2.38.1

