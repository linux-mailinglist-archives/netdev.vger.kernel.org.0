Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8D23F555D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhHXBHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:07:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:62117 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhHXBGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:06:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204346760"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204346760"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:51 -0700
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="515224413"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.11.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/6] selftests: mptcp: add_addr and echo race test
Date:   Mon, 23 Aug 2021 18:05:44 -0700
Message-Id: <20210824010544.68600-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
References: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

This patch added an extra test for the singal_address_tests() to do the
ADD_ADDR and ADD_ADDR_ECHO race test.

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 8c7117e2c337..7b3e6cc56935 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1016,6 +1016,21 @@ signal_address_tests()
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal invalid addresses" 1 1 1
 	chk_add_nr 3 3
+
+	# signal addresses race test
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_add_nr 4 4
 }
 
 link_failure_tests()
-- 
2.33.0

