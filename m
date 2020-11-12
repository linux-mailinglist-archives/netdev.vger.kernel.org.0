Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8489E2B0B81
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgKLRqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:46:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbgKLRqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 12:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605203210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZSMv+Cpki+mAAZ8o0ta9+Wjoshp2Ns4uhV56VB5eiY=;
        b=PoBCpoaAQgxgn+1vNKrUkTxcN++5DXcY6fv9fh4bM7GRkAMstExigM5C0gehaCYewJrg3E
        cGd87YlpqXKhlzj+8MsE0rDmVtOaSpsrfCt1zBZw/4yATDu8qgVGS3dObnRwwONl/aZAlk
        QuWgt8SI6PfEPIWVEYWtpTJOyrpOBhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-iZ6bFhX0MCCk-rsc5Tq7VA-1; Thu, 12 Nov 2020 12:46:48 -0500
X-MC-Unique: iZ6bFhX0MCCk-rsc5Tq7VA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FEF31899422;
        Thu, 12 Nov 2020 17:46:47 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED23055763;
        Thu, 12 Nov 2020 17:46:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 05/13] mptcp: reduce the arguments of mptcp_sendmsg_frag
Date:   Thu, 12 Nov 2020 18:45:25 +0100
Message-Id: <a3493603d604c809ba925120b716494d7e50bc8a.1605199807.git.pabeni@redhat.com>
In-Reply-To: <cover.1605199807.git.pabeni@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current argument list is pretty long and quite unreadable,
move many of them into a specific struct. Later patches
will add more stuff to such struct.

Additionally drop the 'timeo' argument, now unused.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 53 ++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2efa7817505a..691fdb2071cf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -914,12 +914,16 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 	return dfrag;
 }
 
+struct mptcp_sendmsg_info {
+	int mss_now;
+	int size_goal;
+};
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct msghdr *msg, struct mptcp_data_frag *dfrag,
-			      long *timeo, int *pmss_now,
-			      int *ps_goal)
+			      struct mptcp_sendmsg_info *info)
 {
-	int mss_now, avail_size, size_goal, offset, ret, frag_truesize = 0;
+	int avail_size, offset, ret, frag_truesize = 0;
 	bool dfrag_collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
@@ -945,10 +949,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	}
 
 	/* compute copy limit */
-	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	*pmss_now = mss_now;
-	*ps_goal = size_goal;
-	avail_size = size_goal;
+	info->mss_now = tcp_send_mss(ssk, &info->size_goal, msg->msg_flags);
+	avail_size = info->size_goal;
 	skb = tcp_write_queue_tail(ssk);
 	if (skb) {
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
@@ -959,12 +961,12 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 * queue management operation, to avoid breaking the ext <->
 		 * SSN association set here
 		 */
-		can_collapse = (size_goal - skb->len > 0) &&
+		can_collapse = (info->size_goal - skb->len > 0) &&
 			      mptcp_skb_can_collapse_to(*write_seq, skb, mpext);
 		if (!can_collapse)
 			TCP_SKB_CB(skb)->eor = 1;
 		else
-			avail_size = size_goal - skb->len;
+			avail_size = info->size_goal - skb->len;
 	}
 
 	if (!retransmission) {
@@ -1187,11 +1189,15 @@ static void ssk_check_wmem(struct mptcp_sock *msk)
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
-	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_sendmsg_info info = {
+		.mss_now = 0,
+		.size_goal = 0,
+	};
 	struct page_frag *pfrag;
 	size_t copied = 0;
 	struct sock *ssk;
+	int ret = 0;
 	u32 sndbuf;
 	bool tx_ok;
 	long timeo;
@@ -1260,8 +1266,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	lock_sock(ssk);
 	tx_ok = msg_data_left(msg);
 	while (tx_ok) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &timeo, &mss_now,
-					 &size_goal);
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &info);
 		if (ret < 0) {
 			if (ret == -EAGAIN && timeo > 0) {
 				mptcp_set_timeout(sk, ssk);
@@ -1284,8 +1289,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (!sk_stream_memory_free(ssk) ||
 		    !mptcp_page_frag_refill(ssk, pfrag) ||
 		    !mptcp_ext_cache_refill(msk)) {
-			tcp_push(ssk, msg->msg_flags, mss_now,
-				 tcp_sk(ssk)->nonagle, size_goal);
+			tcp_push(ssk, msg->msg_flags, info.mss_now,
+				 tcp_sk(ssk)->nonagle, info.size_goal);
 			mptcp_set_timeout(sk, ssk);
 			release_sock(ssk);
 			goto restart;
@@ -1305,8 +1310,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		 * limits before we send more data.
 		 */
 		if (unlikely(!sk_stream_memory_free(sk))) {
-			tcp_push(ssk, msg->msg_flags, mss_now,
-				 tcp_sk(ssk)->nonagle, size_goal);
+			tcp_push(ssk, msg->msg_flags, info.mss_now,
+				 tcp_sk(ssk)->nonagle, info.size_goal);
 			mptcp_clean_una(sk);
 			if (!sk_stream_memory_free(sk)) {
 				/* can't send more for now, need to wait for
@@ -1323,8 +1328,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	mptcp_set_timeout(sk, ssk);
 	if (copied) {
-		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
-			 size_goal);
+		tcp_push(ssk, msg->msg_flags, info.mss_now,
+			 tcp_sk(ssk)->nonagle, info.size_goal);
 
 		/* start the timer, if it's not pending */
 		if (!mptcp_timer_pending(sk))
@@ -1763,14 +1768,15 @@ static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
 	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
-	int orig_len, orig_offset, mss_now = 0, size_goal = 0;
+	struct mptcp_sendmsg_info info = {};
 	struct mptcp_data_frag *dfrag;
+	int orig_len, orig_offset;
 	u64 orig_write_seq;
 	size_t copied = 0;
 	struct msghdr msg = {
 		.msg_flags = MSG_DONTWAIT,
 	};
-	long timeo = 0;
+	int ret;
 
 	lock_sock(sk);
 	mptcp_clean_una_wakeup(sk);
@@ -1809,8 +1815,7 @@ static void mptcp_worker(struct work_struct *work)
 	orig_offset = dfrag->offset;
 	orig_write_seq = dfrag->data_seq;
 	while (dfrag->data_len > 0) {
-		int ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &timeo,
-					     &mss_now, &size_goal);
+		ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &info);
 		if (ret < 0)
 			break;
 
@@ -1823,8 +1828,8 @@ static void mptcp_worker(struct work_struct *work)
 			break;
 	}
 	if (copied)
-		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
-			 size_goal);
+		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
+			 info.size_goal);
 
 	dfrag->data_seq = orig_write_seq;
 	dfrag->offset = orig_offset;
-- 
2.26.2

