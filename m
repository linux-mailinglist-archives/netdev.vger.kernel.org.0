Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91019C05D
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388048AbgDBLpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:45:15 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44682 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:45:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJyHZ-0002j3-PO; Thu, 02 Apr 2020 13:45:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net 3/4] mptcp: re-check dsn before reading from subflow
Date:   Thu,  2 Apr 2020 13:44:53 +0200
Message-Id: <20200402114454.8533-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402114454.8533-1-fw@strlen.de>
References: <20200402114454.8533-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_subflow_data_available() is commonly called via
ssk->sk_data_ready(), in this case the mptcp socket lock
cannot be acquired.

Therefore, while we can safely discard subflow data that
was already received up to msk->ack_seq, we cannot be sure
that 'subflow->data_avail' will still be valid at the time
userspace wants to read the data -- a previous read on a
different subflow might have carried this data already.

In that (unlikely) event, msk->ack_seq will have been updated
and will be ahead of the subflow dsn.

We can check for this condition and skip/resync to the expected
sequence number.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cc9dd2cc828..939a5045181a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -158,6 +158,27 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	MPTCP_SKB_CB(skb)->offset = offset;
 }
 
+/* both sockets must be locked */
+static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
+				    struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	u64 dsn = mptcp_subflow_get_mapped_dsn(subflow);
+
+	/* revalidate data sequence number.
+	 *
+	 * mptcp_subflow_data_available() is usually called
+	 * without msk lock.  Its unlikely (but possible)
+	 * that msk->ack_seq has been advanced since the last
+	 * call found in-sequence data.
+	 */
+	if (likely(dsn == msk->ack_seq))
+		return true;
+
+	subflow->data_avail = 0;
+	return mptcp_subflow_data_available(ssk);
+}
+
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 					   struct sock *ssk,
 					   unsigned int *bytes)
@@ -169,6 +190,11 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	struct tcp_sock *tp;
 	bool done = false;
 
+	if (!mptcp_subflow_dsn_valid(msk, ssk)) {
+		*bytes = 0;
+		return false;
+	}
+
 	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
 
-- 
2.24.1

