Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0514B020F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiBJBZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:25:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiBJBZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:25:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5C12654
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644456316; x=1675992316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ki68UMGj3/IhMfG82pNOMPf9Hgiw3imD98DaNC35q+Y=;
  b=TxLCnGSQPi9LMbvkIs0HKoIp+ot9Ku2P094iY06MAHd/rF9KKE96IYib
   duwKaIDZCl5Exvm57Ojm8LNYhEAlu8pCtvOv67S7okEVirAVhVnHI4QZW
   DHH9y3aA6eh481oqsEBsFKFRJnTxR/SXdxzTOUxl1zbyvoA5OR4+Xkrjy
   /xgnFJ4yO27Jmqd7T+x6+JxiVABeg3YuCut7khQnPI8g8aJBUXaKCvPRi
   9W2VBjdah04FHP+drYxo8YXXKxJBEpHnB5UWid/XjE0mbS/cOxM5sew0M
   etG4A6mzdjI6tDABI6Jxp+OQRqG76bDT1gIsfOETjhifUFBd9jZKGf37n
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="230029675"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="230029675"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="526263244"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.101])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:15 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, liyonglong@chinatelecom.cn,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] selftests: mptcp: add missing join check
Date:   Wed,  9 Feb 2022 17:25:07 -0800
Message-Id: <20220210012508.226880-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
References: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

This function also writes the name of the test with its ID, making clear
a new test has been executed.

Without that, the ADD_ADDR results from this test was appended at the
end of the previous test causing confusions. Especially when the second
test was failing, we had:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
                                  add[fail] got 2 ADD_ADDR[s] expected 3

In fact, this 17th test was OK but not the 18th one.

Now we have:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
  18 signal addresses race test   syn[fail] got 2 JOIN[s] syn expected 3
   - synack[fail] got 2 JOIN[s] synack expected
   - ack[fail] got 2 JOIN[s] ack expected 3
                                  add[fail] got 2 ADD_ADDR[s] expected 3

Fixes: 33c563ad28e3 ("selftests: mptcp: add_addr and echo race test")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b8bdbec0cf69..c0801df15f54 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1159,6 +1159,7 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal addresses race test" 3 3 3
 
 	# the server will not signal the address terminating
 	# the MPC subflow
-- 
2.35.1

