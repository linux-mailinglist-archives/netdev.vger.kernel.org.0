Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721D53C2BFF
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhGJAXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:60426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhGJAXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270913472"
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="270913472"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="462343541"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.240.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:58 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, pabeni@redhat.com,
        fw@strlen.de, mptcp@lists.linux.dev,
        kernel test robot <oliver.sang@intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/6] selftests: mptcp: fix case multiple subflows limited by server
Date:   Fri,  9 Jul 2021 17:20:50 -0700
Message-Id: <20210710002051.216010-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
References: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

After patch "mptcp: fix syncookie process if mptcp can not_accept new
subflow", if subflow is limited, MP_JOIN SYN is dropped, and no SYN/ACK
will be replied.

So in case "multiple subflows limited by server", the expected SYN/ACK
number should be 1.

Fixes: 00587187ad30 ("selftests: mptcp: add test cases for mptcp join tests with syn cookies")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 9a191c1a5de8..f02f4de2f3a0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1409,7 +1409,7 @@ syncookies_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflows limited by server w cookies" 2 2 1
+	chk_join_nr "subflows limited by server w cookies" 2 1 1
 
 	# test signal address with cookies
 	reset_with_cookies
-- 
2.32.0

