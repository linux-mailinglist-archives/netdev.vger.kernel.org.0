Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0143F9163
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 02:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243891AbhH0Ap4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:45:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:46997 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243874AbhH0Apu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:45:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="240080606"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="240080606"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="599007140"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.68.199])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/5] mptcp: make the locking tx schema more readable
Date:   Thu, 26 Aug 2021 17:44:54 -0700
Message-Id: <20210827004455.286754-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
References: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Florian noted the locking schema used by __mptcp_push_pending()
is hard to follow, let's add some more descriptive comments
and drop an unneeded and confusing check.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1a408395e78f..ade648c3512b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1515,15 +1515,19 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			mptcp_flush_join_list(msk);
 			ssk = mptcp_subflow_get_send(msk);
 
-			/* try to keep the subflow socket lock across
-			 * consecutive xmit on the same socket
+			/* First check. If the ssk has changed since
+			 * the last round, release prev_ssk
 			 */
 			if (ssk != prev_ssk && prev_ssk)
 				mptcp_push_release(sk, prev_ssk, &info);
 			if (!ssk)
 				goto out;
 
-			if (ssk != prev_ssk || !prev_ssk)
+			/* Need to lock the new subflow only if different
+			 * from the previous one, otherwise we are still
+			 * helding the relevant lock
+			 */
+			if (ssk != prev_ssk)
 				lock_sock(ssk);
 
 			/* keep it simple and always provide a new skb for the
-- 
2.33.0

