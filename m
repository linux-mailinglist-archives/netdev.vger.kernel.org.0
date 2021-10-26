Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD72C43BDE1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbhJZXbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:31:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:24059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240288AbhJZXbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:31:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316242956"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316242956"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="597124830"
Received: from jdweinst-mobl2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.54.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, pabeni@redhat.com,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] mptcp: drop unused sk in mptcp_push_release
Date:   Tue, 26 Oct 2021 16:29:16 -0700
Message-Id: <20211026232916.179450-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
References: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Since mptcp_set_timeout() had removed from mptcp_push_release() in
commit 33d41c9cd74c5 ("mptcp: more accurate timeout"), the argument
sk in mptcp_push_release() became useless. Let's drop it.

Fixes: 33d41c9cd74c5 ("mptcp: more accurate timeout")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 81ef592113a5..eb316bd578bb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1469,8 +1469,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	return NULL;
 }
 
-static void mptcp_push_release(struct sock *sk, struct sock *ssk,
-			       struct mptcp_sendmsg_info *info)
+static void mptcp_push_release(struct sock *ssk, struct mptcp_sendmsg_info *info)
 {
 	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
 	release_sock(ssk);
@@ -1533,7 +1532,7 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			 * the last round, release prev_ssk
 			 */
 			if (ssk != prev_ssk && prev_ssk)
-				mptcp_push_release(sk, prev_ssk, &info);
+				mptcp_push_release(prev_ssk, &info);
 			if (!ssk)
 				goto out;
 
@@ -1546,7 +1545,7 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0) {
-				mptcp_push_release(sk, ssk, &info);
+				mptcp_push_release(ssk, &info);
 				goto out;
 			}
 
@@ -1561,7 +1560,7 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 
 	/* at this point we held the socket lock for the last subflow we used */
 	if (ssk)
-		mptcp_push_release(sk, ssk, &info);
+		mptcp_push_release(ssk, &info);
 
 out:
 	/* ensure the rtx timer is running */
-- 
2.33.1

