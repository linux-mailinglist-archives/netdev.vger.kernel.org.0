Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4124599F
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgHPVO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 17:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgHPVO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 17:14:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89367C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:14:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k7Pyz-0003c3-1n; Sun, 16 Aug 2020 23:14:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH net] mptcp: sendmsg: reset iter on error redux
Date:   Sun, 16 Aug 2020 23:14:20 +0200
Message-Id: <20200816211420.7337-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fix wasn't correct: When this function is invoked from the
retransmission worker, the iterator contains garbage and resetting
it causes a crash.

As the work queue should not be performance critical also zero the
msghdr struct.

Fixes: 35759383133f64d "(mptcp: sendmsg: reset iter on error)"
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Brown paper bag patch.  I will see if having distinct functions
 for the mtcp_sendmsg and retransmit wq case is feasible/more
 appropriate.

 net/mptcp/protocol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2499757bf899..f6561d126110 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -740,7 +740,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	ret = do_tcp_sendpages(ssk, page, offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST | MSG_DONTWAIT);
 	if (ret <= 0) {
-		iov_iter_revert(&msg->msg_iter, psize);
+		if (!retransmission)
+			iov_iter_revert(&msg->msg_iter, psize);
 		return ret;
 	}
 
@@ -1391,7 +1392,9 @@ static void mptcp_worker(struct work_struct *work)
 	struct mptcp_data_frag *dfrag;
 	u64 orig_write_seq;
 	size_t copied = 0;
-	struct msghdr msg;
+	struct msghdr msg = {
+		.msg_flags = MSG_DONTWAIT,
+	};
 	long timeo = 0;
 
 	lock_sock(sk);
@@ -1424,7 +1427,6 @@ static void mptcp_worker(struct work_struct *work)
 
 	lock_sock(ssk);
 
-	msg.msg_flags = MSG_DONTWAIT;
 	orig_len = dfrag->data_len;
 	orig_offset = dfrag->offset;
 	orig_write_seq = dfrag->data_seq;
-- 
2.26.2

