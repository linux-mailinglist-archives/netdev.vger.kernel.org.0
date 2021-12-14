Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AAA474E7A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbhLNXQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:16:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:9344 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238172AbhLNXQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:16:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225961175"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="225961175"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="518491437"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/4] mptcp: clear 'kern' flag from fallback sockets
Date:   Tue, 14 Dec 2021 15:16:02 -0800
Message-Id: <20211214231604.211016-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
References: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The mptcp ULP extension relies on sk->sk_sock_kern being set correctly:
It prevents setsockopt(fd, IPPROTO_TCP, TCP_ULP, "mptcp", 6); from
working for plain tcp sockets (any userspace-exposed socket).

But in case of fallback, accept() can return a plain tcp sk.
In such case, sk is still tagged as 'kernel' and setsockopt will work.

This will crash the kernel, The subflow extension has a NULL ctx->conn
mptcp socket:

BUG: KASAN: null-ptr-deref in subflow_data_ready+0x181/0x2b0
Call Trace:
 tcp_data_ready+0xf8/0x370
 [..]

Fixes: cf7da0d66cc1 ("mptcp: Create SUBFLOW socket for incoming connections")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---

Note: The original author of cf7da0d66cc1 is not cc'd because the email
address is no longer valid.

---
 net/mptcp/protocol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c82a76d2d0bf..6dc1ff07994c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2879,7 +2879,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		 */
 		if (WARN_ON_ONCE(!new_mptcp_sock)) {
 			tcp_sk(newsk)->is_mptcp = 0;
-			return newsk;
+			goto out;
 		}
 
 		/* acquire the 2nd reference for the owning socket */
@@ -2891,6 +2891,8 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	}
 
+out:
+	newsk->sk_kern_sock = kern;
 	return newsk;
 }
 
-- 
2.34.1

