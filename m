Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7020D526ED8
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiENDAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 23:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiENC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:59:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B22636AE35
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 18:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652491731; x=1684027731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1zXQQLIalYYZ2M8+aZMUpfjKxvlmKG2qfFu5cLhcq1M=;
  b=irkYNjNeRD+aAphzSfIkMYM39S5RtKP/TV+n/sILXjE8+hzgabEDAEcY
   eZCmpQYhFjj+YkydC3M1nm4Xfq2aOfL0EPZ7BCmJcTfl9I6tBWkf+Mloi
   SBI55S+UmtYPYmj0YOJKwT0+rgIt+cg1U9srnm0OA63XzVgZN7vWKZeQz
   zkHCa/VCbBzTQGnyNBJqIeCjOUIXDyPk6jihuf3ghght9aSCL67NtkTjT
   fxeQ8nNfZsQJcjiXrajr1fvSGDAMEMIoUWiER9XvuSKfpnnOYwxZpkUMt
   yFnYOPE8OtZFStYIOEYlBw76Jn+L5ZDVu+0cY4acZ78CqU6+QEeJ1oy6a
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="257994308"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="257994308"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="625102784"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/3] selftests: mptcp: fix a mp_fail test warning
Date:   Fri, 13 May 2022 17:21:13 -0700
Message-Id: <20220514002115.725976-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
References: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Old tc versions (iproute2 5.3) show actions in multiple lines, not a
single line. Then the following unexpected MP_FAIL selftest output
occurs:

 file received by server has inverted byte at 169
 ./mptcp_join.sh: line 1277: [: [{"total acts":1},{"actions":[{"order":0 pedit ,"control_action":{"type":"pipe"}keys 1
         index 1 ref 1 bind 1,"installed":0,"last_used":0
         key #0  at 148: val ff000000 mask ffffffff
 5: integer expression expected
 001 Infinite map                      syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       sum[ ok ] - csum  [ ok ]
                                       ftx[ ok ] - failrx[ ok ]
                                       rtx[ ok ] - rstrx [ ok ]
                                       itx[ ok ] - infirx[ ok ]
                                       ftx[ ok ] - failrx[ ok ] invert

This patch adds a 'grep' before 'sed' to fix this.

Fixes: b6e074e171bc ("selftests: mptcp: add infinite map testcase")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d1de1e7702fb..7381d1f85209 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2693,6 +2693,7 @@ fastclose_tests()
 pedit_action_pkts()
 {
 	tc -n $ns2 -j -s action show action pedit index 100 | \
+		grep "packets" | \
 		sed 's/.*"packets":\([0-9]\+\),.*/\1/'
 }
 
-- 
2.36.1

