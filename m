Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCE432DBE2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhCDVhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:37:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:5219 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239568AbhCDVgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:36:51 -0500
IronPort-SDR: LwI42t/d8v7nMo+JD0ur6vk3Wa2cSUtURlRza/Z/j2sWbDDmn+5ve2EqsoPNDu+5meNPOeNN0M
 fX3EBaYOKw6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769418"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769418"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: J9U/gH7waUbTEGbRAz7gP0wKrkGNoUhCpgcCBcKVmg/y6uqJUstdQBLZtyCVkqqgrAQsRWM0Qr
 UFxraXhBEdLw==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329491"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 8/9] mptcp: fix missing wakeup
Date:   Thu,  4 Mar 2021 13:32:15 -0800
Message-Id: <20210304213216.205472-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

__mptcp_clean_una() can free write memory and should wake-up
user-space processes when needed.

When such function is invoked by the MPTCP receive path, the wakeup
is not needed, as the TCP stack will later trigger subflow_write_space
which will do the wakeup as needed.

Other __mptcp_clean_una() call sites need an additional wakeup check
Let's bundle the relevant code in a new helper and use it.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/165
Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Fixes: 64b9cea7a0af ("mptcp: fix spurious retransmissions")
Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d2a2169e6d9e..76958570ae7f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1061,6 +1061,12 @@ static void __mptcp_clean_una(struct sock *sk)
 	}
 }
 
+static void __mptcp_clean_una_wakeup(struct sock *sk)
+{
+	__mptcp_clean_una(sk);
+	mptcp_write_space(sk);
+}
+
 static void mptcp_enter_memory_pressure(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2270,7 +2276,7 @@ static void __mptcp_retrans(struct sock *sk)
 	struct sock *ssk;
 	int ret;
 
-	__mptcp_clean_una(sk);
+	__mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag)
 		return;
@@ -2983,7 +2989,7 @@ static void mptcp_release_cb(struct sock *sk)
 	}
 
 	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
-		__mptcp_clean_una(sk);
+		__mptcp_clean_una_wakeup(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
 		__mptcp_error_report(sk);
 
-- 
2.30.1

