Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34525144A94
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAVDuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:50:10 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:59744 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVDuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:50:10 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eJ020009;
        Tue, 21 Jan 2020 16:57:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=nqG6dk68pEmOIYmqkjlhBAXolRpLFOB8dqAyqxYZrIU=;
 b=A0+MlTIeU3bgRQFqEyyLBdsN3dI5nate1ZvN480fIfSmpoIGoRorfCf/8hwvLcjcryL/
 Kb3XfOb33V2HNkoOblXCdGEJiJ1hClpJ/kll4UUW9bhSjD+alMaEIHghJvZq2xnmJbKg
 hEymzbZB9n/55MElwgVd4tYFGVwTc+pM9+dk7BMgzGyHAxkDf2ObX6mlRwRnuPzb7iXV
 cdcfT26RDmKMQJPN0XbvXIirxxpWTQQ5E9CYTZ9ZPVUBdjlPmtQjWRpOT9bLShsHT9wD
 8hmVhFTbGtFOn8LQTZAlc7rcGMBP1sDMxACSt83CGX7m71MYQ3QP+bCJ/UZioK7gEWL6 og== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:04 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: dc7a0cfcd4f3e0cf0efdc41aa53bc138
X-Va-R-CD: 840b521611be5ac4c5a7cb6f20566d03
X-Va-CD: 0
X-Va-ID: 328199fb-b8e8-44ff-9071-1a7b2b487bb2
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: dc7a0cfcd4f3e0cf0efdc41aa53bc138
X-V-R-CD: 840b521611be5ac4c5a7cb6f20566d03
X-V-CD: 0
X-V-ID: 46174355-2834-4141-b72e-199f926c2792
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DSQHB0DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 13/19] mptcp: allow collapsing consecutive
 sendpages on the same substream
Date:   Tue, 21 Jan 2020 16:56:27 -0800
Message-id: <20200122005633.21229-14-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the current sendmsg() lands on the same subflow we used last, we
can try to collapse the data.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 75 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ad9c73cc20e1..0b21ae25bd0f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -122,14 +122,27 @@ static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 	return NULL;
 }
 
+static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
+					     const struct sk_buff *skb,
+					     const struct mptcp_ext *mpext)
+{
+	if (!tcp_skb_can_collapse_to(skb))
+		return false;
+
+	/* can collapse only if MPTCP level sequence is in order */
+	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
-			      struct msghdr *msg, long *timeo)
+			      struct msghdr *msg, long *timeo, int *pmss_now,
+			      int *ps_goal)
 {
-	int mss_now = 0, size_goal = 0, ret = 0;
+	int mss_now, avail_size, size_goal, ret;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
+	struct sk_buff *skb, *tail;
+	bool can_collapse = false;
 	struct page_frag *pfrag;
-	struct sk_buff *skb;
 	size_t psize;
 
 	/* use the mptcp page cache so that we can easily move the data
@@ -145,8 +158,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 	/* compute copy limit */
 	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	psize = min_t(int, pfrag->size - pfrag->offset, size_goal);
+	*pmss_now = mss_now;
+	*ps_goal = size_goal;
+	avail_size = size_goal;
+	skb = tcp_write_queue_tail(ssk);
+	if (skb) {
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
+
+		/* Limit the write to the size available in the
+		 * current skb, if any, so that we create at most a new skb.
+		 * Explicitly tells TCP internals to avoid collapsing on later
+		 * queue management operation, to avoid breaking the ext <->
+		 * SSN association set here
+		 */
+		can_collapse = (size_goal - skb->len > 0) &&
+			      mptcp_skb_can_collapse_to(msk, skb, mpext);
+		if (!can_collapse)
+			TCP_SKB_CB(skb)->eor = 1;
+		else
+			avail_size = size_goal - skb->len;
+	}
+	psize = min_t(size_t, pfrag->size - pfrag->offset, avail_size);
 
+	/* Copy to page */
 	pr_debug("left=%zu", msg_data_left(msg));
 	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
 				    min_t(size_t, msg_data_left(msg), psize),
@@ -155,14 +189,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (!psize)
 		return -EINVAL;
 
-	/* Mark the end of the previous write so the beginning of the
-	 * next write (with its own mptcp skb extension data) is not
-	 * collapsed.
+	/* tell the TCP stack to delay the push so that we can safely
+	 * access the skb after the sendpages call
 	 */
-	skb = tcp_write_queue_tail(ssk);
-	if (skb)
-		TCP_SKB_CB(skb)->eor = 1;
-
 	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
@@ -170,6 +199,18 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (unlikely(ret < psize))
 		iov_iter_revert(&msg->msg_iter, psize - ret);
 
+	/* if the tail skb extension is still the cached one, collapsing
+	 * really happened. Note: we can't check for 'same skb' as the sk_buff
+	 * hdr on tail can be transmitted, freed and re-allocated by the
+	 * do_tcp_sendpages() call
+	 */
+	tail = tcp_write_queue_tail(ssk);
+	if (mpext && tail && mpext == skb_ext_find(tail, SKB_EXT_MPTCP)) {
+		WARN_ON_ONCE(!can_collapse);
+		mpext->data_len += ret;
+		goto out;
+	}
+
 	skb = tcp_write_queue_tail(ssk);
 	mpext = __skb_ext_set(skb, SKB_EXT_MPTCP, msk->cached_ext);
 	msk->cached_ext = NULL;
@@ -185,11 +226,11 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
 		 mpext->dsn64);
 
+out:
 	pfrag->offset += ret;
 	msk->write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
-	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 	return ret;
 }
 
@@ -212,11 +253,11 @@ static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
+	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
-	int ret = 0;
 	long timeo;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
@@ -243,15 +284,19 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(ssk);
 	while (msg_data_left(msg)) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo);
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo, &mss_now,
+					 &size_goal);
 		if (ret < 0)
 			break;
 
 		copied += ret;
 	}
 
-	if (copied > 0)
+	if (copied) {
 		ret = copied;
+		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
+			 size_goal);
+	}
 
 	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
-- 
2.23.0

