Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6A244AEC
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHNN4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHNN4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 09:56:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F49C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 06:56:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k6aCN-0008WG-IV; Fri, 14 Aug 2020 15:56:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH net] mptcp: sendmsg: reset iter on error
Date:   Fri, 14 Aug 2020 15:56:34 +0200
Message-Id: <20200814135634.12996-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once we've copied data from the iterator we need to revert in case we
end up not sending any data.

This bug doesn't trigger with normal 'poll' based tests, because
we only feed a small chunk of data to kernel after poll indicated
POLLOUT.  With blocking IO and large writes this triggers. Receiver
ends up with less data than it should get.

Fixes: 72511aab95c94d ("mptcp: avoid blocking in tcp_sendpages")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d5aaa98b9136..2e7e87304930 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -725,8 +725,10 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		if (!psize)
 			return -EINVAL;
 
-		if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
+		if (!sk_wmem_schedule(sk, psize + dfrag->overhead)) {
+			iov_iter_revert(&msg->msg_iter, psize);
 			return -ENOMEM;
+		}
 	} else {
 		offset = dfrag->offset;
 		psize = min_t(size_t, dfrag->data_len, avail_size);
@@ -737,8 +739,10 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 */
 	ret = do_tcp_sendpages(ssk, page, offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST | MSG_DONTWAIT);
-	if (ret <= 0)
+	if (ret <= 0) {
+		iov_iter_revert(&msg->msg_iter, psize);
 		return ret;
+	}
 
 	frag_truesize += ret;
 	if (!retransmission) {
-- 
2.26.2

