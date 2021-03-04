Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9578D32DBDF
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbhCDVgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:36:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:5337 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239567AbhCDVfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:35:54 -0500
IronPort-SDR: 9kjROWACgdZTHU6dAuM1OCxmTfCqcdg9nVcwxIxCXMJxlTtOdhDJd4+3aXSCKa5Y38SVOwMnuT
 7f8A+SOrvbRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769417"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769417"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: g36bec/vFOZmQ+P+UHuyl2Xhf4V6FtezIF/a+x2RPW8Z+V5NmeTJrTxrxJYUcirXgaGiOqjFz6
 9UML8fiRP/lQ==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329482"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/9] mptcp: dispose initial struct socket when its subflow is closed
Date:   Thu,  4 Mar 2021 13:32:11 -0800
Message-Id: <20210304213216.205472-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Christoph Paasch reported following crash:
dst_release underflow
WARNING: CPU: 0 PID: 1319 at net/core/dst.c:175 dst_release+0xc1/0xd0 net/core/dst.c:175
CPU: 0 PID: 1319 Comm: syz-executor217 Not tainted 5.11.0-rc6af8e85128b4d0d24083c5cac646e891227052e0c #70
Call Trace:
 rt_cache_route+0x12e/0x140 net/ipv4/route.c:1503
 rt_set_nexthop.constprop.0+0x1fc/0x590 net/ipv4/route.c:1612
 __mkroute_output net/ipv4/route.c:2484 [inline]
...

The worker leaves msk->subflow alone even when it
happened to close the subflow ssk associated with it.

Fixes: 866f26f2a9c33b ("mptcp: always graft subflow socket to parent")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/157
Reported-by: Christoph Paasch <cpaasch@apple.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index aa59101ffe54..a58da04bed71 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2116,6 +2116,14 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 	return backup;
 }
 
+static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
+{
+	if (msk->subflow) {
+		iput(SOCK_INODE(msk->subflow));
+		msk->subflow = NULL;
+	}
+}
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -2160,6 +2168,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 
 	if (ssk == msk->last_snd)
 		msk->last_snd = NULL;
+
+	if (msk->subflow && ssk == msk->subflow->sk)
+		mptcp_dispose_initial_subflow(msk);
 }
 
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
@@ -2529,12 +2540,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	might_sleep();
 
-	/* dispose the ancillatory tcp socket, if any */
-	if (msk->subflow) {
-		iput(SOCK_INODE(msk->subflow));
-		msk->subflow = NULL;
-	}
-
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -2559,6 +2564,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 	sk_refcnt_debug_release(sk);
+	mptcp_dispose_initial_subflow(msk);
 	sock_put(sk);
 }
 
-- 
2.30.1

