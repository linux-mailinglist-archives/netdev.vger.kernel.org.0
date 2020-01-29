Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC014CCCF
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgA2OzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:55:07 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42558 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgA2OzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:55:06 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iwokC-000785-Ti; Wed, 29 Jan 2020 15:55:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/4] mptcp: defer freeing of cached ext until last moment
Date:   Wed, 29 Jan 2020 15:54:43 +0100
Message-Id: <20200129145446.26425-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129145446.26425-1-fw@strlen.de>
References: <20200129145446.26425-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

access to msk->cached_ext is only legal if the msk is locked or all
concurrent accesses are impossible.

Furthermore, once we start to tear down, we must make sure nothing else
can step in and allocate a new cached ext.

So place this code in the destroy callback where it belongs.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 39fdca79ce90..f1b1160dbbb4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -654,8 +654,6 @@ static void __mptcp_close(struct sock *sk, long timeout)
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
-	if (msk->cached_ext)
-		__skb_ext_put(msk->cached_ext);
 	release_sock(sk);
 	sk_common_release(sk);
 }
@@ -776,6 +774,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 
 static void mptcp_destroy(struct sock *sk)
 {
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (msk->cached_ext)
+		__skb_ext_put(msk->cached_ext);
 }
 
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
-- 
2.24.1

